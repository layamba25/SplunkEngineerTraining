# Provider configuration
provider "aws" {
  region = "us-east-2"
}

# Security Group Configuration
resource "aws_security_group" "syslog_security_group" {
  name        = "syslog-sg"
  description = "Syslog Security Group"

  tags = {
    Name = "Syslog Security Group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = ["514", "6514"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  instance_type = "t2.medium"
  key_name      = "SplunkTraining"

  security_groups = [aws_security_group.syslog_security_group.name]

  # Define storage 
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get upgrade -y
                sudo apt-get install -y syslog-ng

                cat <<'SYSLOG_CONF' > /etc/syslog-ng/conf.d/syslog-ng.conf
                @version: 3.16
                @include "scl.conf"
                source s_src {
                    system();
                    internal();
                };
                # Filters for different data types
                filter f_palo { match("palo" value("MESSAGE")); };
                filter f_other { not match("palo" value("MESSAGE")); };

                # Destinations for different data types
                destination d_palo {
                    file("/var/log/palo/$${YEAR}-$${MONTH}-$${DAY}/palo.log"
                    create-dirs(yes));
                };
                destination d_other {
                    file("/var/log/other/$${YEAR}-$${MONTH}-$${DAY}/other.log"
                    create-dirs(yes));
                };

                # Log paths
                log {
                    source(s_src);filter(f_palo);destination(d_palo);
                };

                log {
                    source(s_src);filter(f_other);destination(d_other);
                };
                SYSLOG_CONF

            sudo systemctl restart syslog-ng

                EOF

  tags = {
    Name = "syslog-ng"
  }
}
