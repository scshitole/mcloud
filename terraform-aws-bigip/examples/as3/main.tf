
terraform {
  required_providers {
    bigip = {
      source  = "f5networks/bigip"
      version = "1.8.0"
    }
  }
}

provider "bigip" {
  address  = var.address
  username = "admin"
  password = var.password
  port     = var.port
}

resource "bigip_as3" "as3-waf" {
  as3_json = file(var.declaration)
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


resource "aws_instance" "backend1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  private_ip    = "10.0.0.100"
  subnet_id     = var.subnet_id
   security_groups = [aws_security_group.nginx.id]
   user_data     = file("nginx.sh")
  tags = {
    Name = "scs-back01"
  }
}

resource "aws_instance" "backend2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  private_ip    = "10.0.0.101"
  subnet_id     = var.subnet_id
  security_groups = [aws_security_group.nginx.id]
  user_data     = file("nginx.sh")
  tags = {
    Name = "scs-back02"
  }
}
