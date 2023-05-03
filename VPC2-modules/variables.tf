variable "vpc_cidr_block" {
  type    = string
  default = "192.168.101.0/26"
}

variable "private_subnet" {
  type    = list(string)
}

variable "public_subnet" {
  type    = list(string)
}

variable "availability_zone" {
  type    = list(string)
}