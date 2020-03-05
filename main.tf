data "terraform_remote_state" "test_tags" {
  backend = "remote"

  config = {
    organization= "delta"
    workspaces = {
      name = "tf-use-case"
    }
  }
}
provider "aws" {
  region                  = "us-east-1"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Wolverine"
  }
  vpc_security_group_ids = [data.terraform_remote_state.test_tags.tags.sec_group.test]
}
