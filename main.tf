provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  
  security_groups             = ["${aws_security_group.ec2-sg.id}"]
  subnet_id                   = aws_subnet.public.id
#   user_data                   = file("httpd.sh")
    user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    cd /var/www/html
    echo "<!DOCTYPEhtml><html><head><link rel=\"stylesheet\" href=\"style.css\"></head><body><h1>Hello world</h1></body></html>" > index.html
    echo "h1{color:brown;}" > style.css
    service httpd start
    chkconfig httpd on
    EOF
  associate_public_ip_address = true

  

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
    tags = {
      Name = "EBS-${var.environment_name}"
    }
  }
  
}

# resource "null_resource" "copyhtml" {

#     connection {
#         type = "ssh"
#         host = aws_instance.web_server.public_ip
#         user = "ec2-user"
#         private_key = file("service_terraform")
#     }


#   provisioner "file" {
#     source      = "web/"
#     destination = "/var/www/html"
#   }

#   depends_on = [ aws_instance.web_server ]

#   }

resource "aws_security_group" "ec2-sg" {
  vpc_id = aws_vpc.main.id
  ingress = [
    {
      # ssh port allowed from any ip
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      # http port allowed from any ip
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = "all-open"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    "Name"      = "terraform-ec2-sg"
    "terraform" = "true"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.environment_name}-web-server-key"
  public_key = file("service_terraform.pub")
}