# Security Group Configuration
resource "aws_security_group" "ansible_security_group" {
  name        = "ansible-sg"
  description = "Ansible Security Group"

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
# Define the instance
resource "aws_instance" "ansible" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.large"
    key_name      = var.key_pair_name
    security_groups = [aws_security_group.ansible_security_group.name]

    # Define storage 
    root_block_device {
        volume_size = 20
        volume_type = "gp2"
    }
    tags = {
        Name = "Ansible"
    }
    # Define the user data script to install Ansible
    user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get upgrade -y
            apt-get install -y software-properties-common
            apt-add-repository --yes --update ppa:ansible/ansible
            apt-get install -y ansible

            git clone https://github.com/layamba25/SplunkEngineerTraining.git
            cd SplunkEngineerTraining/Scripts/BashScripts
            # chmod +x awx_installer.sh
            # ./awx_installer.sh
            chmod +x awx_operator_installer.sh
            ./awx_operator_installer.sh
            EOF

    # Use remote-exec provisioner to create ansible user and generate private key
    provisioner "remote-exec" {
        inline = [
            "sleep 60",
            "cloud-init status --wait",
            # "sudo useradd -m -s /bin/bash ansible",
            # "echo 'ansible ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers.d/ansible-sudoers",
            "sudo mkdir -p /home/ansible/.ssh",
            "sudo chmod 700 /home/ansible/.ssh",
            "sudo touch /home/ansible/.ssh/authorized_keys",
            "sudo chmod 600 /home/ansible/.ssh/authorized_keys",
            "sudo chown -R ansible:ansible /home/ansible/.ssh",
            "sudo -u ansible ssh-keygen -t rsa -N '' -f /home/ansible/.ssh/id_rsa",
            "sudo cat /home/ansible/.ssh/id_rsa.pub",
        ]

         connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = file(var.key_pair_path)
            host        = self.public_ip
        }
    }

}

# Define the output
output "public_ip" {
    value = aws_instance.ansible.public_ip
}
