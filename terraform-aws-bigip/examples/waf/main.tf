
terraform {
  required_providers {
    bigip = {
      source  = "f5networks/bigip"
      version = "1.4.0"
    }
  }
}

provider "bigip" {
  address  = var.address
  username = "admin"
  password = var.password
}


provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  private_ip    = "10.0.0.100"
  subnet_id     = var.subnet_id
  tags = {
    Name = "scs-minstance"
  }
}
