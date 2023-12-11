
# Security Group Configuration
resource "aws_security_group" "my_security_group" {
  name        = "splunk-sg"
  description = "My Security Group"

  vpc_id = aws_vpc.splunkvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   dynamic "ingress" {
    for_each = var.splunk_ports
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
  count         = var.instance_count
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  key_name               = var.key_pair_name
  
  associate_public_ip_address = true

 # update the storage size to 20GB
  root_block_device {
    volume_size = 20
  }


  user_data = <<-EOF
    #!/bin/bash
    echo "Setting hostname to: ${var.instance_tags[count.index].value}.${var.domain}"
    hostnamectl set-hostname ${var.instance_tags[count.index].value}.${var.domain}
    apt install git -y

    ##useradd -m splunk_user && sudo usermod -aG sudo splunk_user && echo "splunk_user ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
    
    # Generate SSH key pair for the splunk_user
    sudo -u splunk_user ssh-keygen -t rsa -b 4096 -C 'splunk_user@example.com' -f /home/splunk_user/.ssh/id_rsa -N ''
    cat /home/splunk_user/.ssh/id_rsa.pub >> /home/splunk_user/.ssh/authorized_keys
    
    # Add the ansible user's public key to the splunk_user's authorized_keys file
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuMxFk4YOXIBL6LLsYPC01rdPgutJNhPQp5hTtW2OgFKCCYZ28UeDD+unzjlY53wZVG35nimoyVvIK+DlN0ZnvQsEFVbS8doIPCS2BYiVK0luBZpyvNgS5uMCIWKb1/FE644Tx6IBegeRR92+xjW8jWf43X7B5feneYoM80+GIsOCVv05xA1W4FRe0RJMIVsGOjnZ15TZWhWSdIC6/Wg/6PXm4rJwnPsulFTXUzgHaPcz3tumrSDEJJ4Tlhepe9dEKKa4ITWwy4fBLttIRB+vhvQTJa4RJwi3J+ZlhBXpUzfdbsYYGY7k50hbOU0+BNN17oiHNU9RNeRsQhlw3s1S+CMZ+IdsBIhJyDaawVkMxcfwshatX1G0Dg5MtA6LBr/7A3v3z3AEgJbs6Ew5TzMC4ykr8DOaVoYApJ0IpehfplbHAm3F9ZCScW9VgeCTDwcn0BI5KuqgBxLGYmVPQZgh2UuORUzp/XBFAFrK97hrB2/NyM0qS0DcbDl08YGeJCPE= ansible@ansible-master" >> /home/splunk_user/.ssh/authorized_keys
    
    # Install Splunk
    git clone https://github.com/layamba25/SplunkEngineerTraining.git
    cd SplunkEngineerTraining/Scripts/BashScripts
    chmod +x *.sh

    if [ "${var.instance_tags[count.index].value}" == "linuxuniversalforwarder" ]; then
      timeout 5m ./splunk_forwarder_installer.sh
    else
      timeout 30m ./splunk_enterprise_installer.sh | tee /var/log/splunk_install.log
    fi
    
    # Install Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh
    # tailscale up --ssh --authkey="tskey-auth-knCJ6g7CNTRL-9RzpqSxDoGcKttY8bniMHckS8ZDMLVWZZ" --advertise-tags="${var.tailscale_advertiseTags}"
    tailscale up --ssh --authkey="${var.tailscale_authKey}" --advertise-tags="${var.tailscale_advertiseTags}"

   
    # Generate SSH Key for the splunk_user
    sudo -u splunk_user
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

  EOF

  tags = merge(
    {
      "Name" = "${var.instance_tags[count.index].value}.${var.domain}"
    },
    var.instance_tags[count.index].value == "searchhead01" ? {
      "Instance" = "SearchHead"
    } : {},
    contains([lower(var.instance_tags[count.index].value)], "searchhead01") ? {
      "Instance" = "SearchHead"
    } : {},
    contains([lower(var.instance_tags[count.index].value)], "searchhead02") ? {
      "Instance" = "SearchHead"
    } : {},

    ################################
    
    contains([lower(var.instance_tags[count.index].value)], "index01") ? {
      "Instance" = "Indexer"
    } : {},
    
    contains([lower(var.instance_tags[count.index].value)], "index02") ? {
      "Instance" = "Indexer"
    } : {},
    
    contains([lower(var.instance_tags[count.index].value)], "index02") ? {
      "Instance" = "Indexer"
    } : {},
    
    ################################

  )

# copy the ansible ssh key from local to the remote server's authorized_keys file
  provisioner "file" {
    source      = var.public_key_path
    destination = "/home/splunk_user/.ssh/authorized_keys"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_key_path)
      host        = self.public_ip
    }
  }


}