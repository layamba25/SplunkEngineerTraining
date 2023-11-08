
# Define the provider
provider "aws" {
    region = "us-west-2"
}

# Define the instance
resource "aws_instance" "ansible" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name      = "my-key"
    security_groups = ["default"]

    # Define the user data script to install Ansible
    user_data = <<-EOF
                            #!/bin/bash
                            apt-get update
                            apt-get install -y software-properties-common
                            apt-add-repository --yes --update ppa:ansible/ansible
                            apt-get install -y ansible
                            EOF

    # Use remote-exec provisioner to create ansible user and generate private key
    provisioner "remote-exec" {
        inline = [
            "sudo useradd -m ansible",
            "sudo mkdir -p /home/ansible/.ssh",
            "sudo chmod 700 /home/ansible/.ssh",
            "sudo touch /home/ansible/.ssh/authorized_keys",
            "sudo chmod 600 /home/ansible/.ssh/authorized_keys",
            "sudo chown -R ansible:ansible /home/ansible/.ssh",
            "sudo -u ansible ssh-keygen -t rsa -N '' -f /home/ansible/.ssh/id_rsa",
        ]
    }

    # Use tls_private_key resource to generate private key for ansible user
    resource "tls_private_key" "ansible" {
        algorithm = "RSA"
        rsa_bits  = 4096
    }

    # Use local_file resource to save private key to local file
    resource "local_file" "ansible_private_key" {
        content  = tls_private_key.ansible.private_key_pem
        filename = "ansible_private_key.pem"
    }

    # Use null_resource to copy certificate to local directory
    resource "null_resource" "copy_certificate" {
        provisioner "local-exec" {
            command = "echo '${tls_private_key.ansible.private_key_pem}' > ansible_user_key.pem"
        }
    }
}

# Define the output
output "public_ip" {
    value = aws_instance.ansible.public_ip
}
