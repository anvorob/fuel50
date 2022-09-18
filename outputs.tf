output "public_ip" {
  description = "public-ip"
  value       = aws_instance.web_server.public_ip
}