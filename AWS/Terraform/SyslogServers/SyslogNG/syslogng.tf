# Provider configuration
provider "aws" {
    region = "us-west-2"
}

# Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

# EC2 instance
resource "aws_instance" "syslog-ng" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name      = "my-key"
    subnet_id     = "subnet-1234567890"
    vpc_security_group_ids = ["sg-1234567890"]

    user_data = <<-EOF
                            #!/bin/bash
                            sudo apt-get update
                            sudo apt-get install -y syslog-ng
                            EOF

    tags = {
        Name = "syslog-ng"
    }
}
