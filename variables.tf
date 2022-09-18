variable "region" {
  type = string
}

variable "access_key" {
  type = string
  sensitive = true
}

variable "secret_key" {
  type = string 
  sensitive = true
}

variable "environment_name" {
  type = string
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

# variable "instance_count" {
#   type = number
#   default = 1
# }

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}