# Security Group Configuration
resource "aws_security_group" "my_security_group" {
  name        = "awx-sg"
  description = "My Security Group"

#   vpc_id = aws_vpc.splunkvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   dynamic "ingress" {
    for_each = var.awx_ports
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

# # EC2 Instance Configuration
resource "aws_instance" "splunk_instances" {
    ami           = var.ubuntu_ami
    instance_type = var.instance_type
    key_name      = var.key_pair_name
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    subnet_id = aws_subnet.public_subnet.id
    tags = {
        Name = "AWX Server"
    }
    user_data = <<-EOF
                #!/bin/bash
                # Run AWS Install Script
                yum update -y
                yum install -y git
                git clone https://github.com/layamba25/SplunkEngineerTraining.git
                cd SplunkEngineerTraining/Scripts/BashScripts
                chmod +x awx_installer.sh
                ./awx_installer.sh

                sleep 1m
                # Install Tailscale
                curl -fsSL https://tailscale.com/install.sh | sh
                tailscale up --ssh --authkey="tskey-auth-knCJ6g7CNTRL-9RzpqSxDoGcKttY8bniMHckS8ZDMLVWZZ" --advertise-tags="${var.tailscale_advertiseTags}"
   
                EOF

}
