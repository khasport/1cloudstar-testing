provider "aws" {
  region = "ap-southeast-1"

}

module "VPC1-modules" {
  source = "./test"

  vpc_cidr_block    = "192.168.100.0/26"
  public_subnet     = ["192.168.100.0/28"]
  availability_zone = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

module "VPC2-modules" {
  source = "./test"

  vpc_cidr_block    = "192.168.101.0/26"
  public_subnet     = ["192.168.101.0/28"]
  availability_zone = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

resource "aws_vpc_peering_connection" "VPC01toVPC02" {
  vpc_id      = aws_vpc.vpc01.id
  peer_vpc_id = aws_vpc.vpc02.id
  auto_accept = true
}