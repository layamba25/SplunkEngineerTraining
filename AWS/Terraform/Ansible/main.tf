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
    instance_type = "t2.medium"
    key_name      = var.key_pair_name
    security_groups = [aws_security_group.ansible_security_group.name]

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
            EOF

    # Use remote-exec provisioner to create ansible user and generate private key
    provisioner "remote-exec" {
        inline = [
            "sudo useradd -m -s /bin/bash ansible",
            "echo 'ansible ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers.d/ansible-sudoers",
            "sudo mkdir -p /home/ansible/.ssh",
            "sudo chmod 700 /home/ansible/.ssh",
            "sudo touch /home/ansible/.ssh/authorized_keys",
            "sudo chmod 600 /home/ansible/.ssh/authorized_keys",
            "sudo chown -R ansible:ansible /home/ansible/.ssh",
            "sudo -u ansible ssh-keygen -t rsa -N '' -f /home/ansible/.ssh/id_rsa",
            "sudo cat /home/ansible/.ssh/id_rsa.pub"
        ]

         connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = file(var.key_pair_path)
            host        = self.public_ip
        }
    }

    # Use file provisioner to copy the public key to the local machine
    # provisioner "file" {
    #     source      = "/home/ansible/.ssh/id_rsa.pub"
    #     destination = "ansible_id_rsa.pub"

    #      connection {
    #         type        = "ssh"
    #         user        = "ubuntu"
    #         private_key = file("C:\\Users\\leona\\OneDrive\\Desktop\\Training\\Splunk Engineering\\AWS\\SplunkTraining.pem")
    #         host        = self.public_ip
    #     }
    # }
    # provisioner "local-exec" {
    #     command = "scp -i C:\\Users\\leona\\OneDrive\\Desktop\\Training\\Splunk Engineering\\AWS\\SplunkTraining.pem ubuntu@${self.public_ip}:/home/ansible/.ssh/id_rsa.pub ."
      
    # }
}

# Define the output
output "public_ip" {
    value = aws_instance.ansible.public_ip
}
