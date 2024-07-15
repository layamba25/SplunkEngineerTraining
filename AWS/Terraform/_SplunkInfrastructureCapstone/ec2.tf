
# Security Group Configuration
resource "aws_security_group" "my_security_group" {
  name        = "splunk-sg-capstone"
  description = "My Security Group for Capstone"

  vpc_id = aws_vpc.splunk-capstone-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
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

  tags = {
    Name = "Splunk Security Group"
  }
}

# # EC2 Instance Configuration
resource "aws_instance" "splunk_instances" {
  count         = var.instance_count
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  key_name = var.key_pair_name

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
    # useradd -m -s /bin/bash splunk_user
    # echo "splunk_user ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/splunk-sudoers
    

    # Install Splunk
    # git clone https://github.com/layamba25/SplunkEngineerTraining.git
    # cd SplunkEngineerTraining/Scripts/BashScripts
    # chmod +x *.sh

    # if [ "${var.instance_tags[count.index].value}" == "linuxuniversalforwarder" ]; then
    #   timeout 5m ./splunk_forwarder_installer.sh
    # else
    #   timeout 30m ./splunk_enterprise_installer.sh | tee /var/log/splunk_install.log
    # fi
    
    # Install Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh
    sleep 60
    tailscale up --authkey="${var.tailscale_authKey}" --ssh --reset --advertise-tags="${var.tailscale_advertiseTags}"

    # Generate SSH key pair for the splunk_user
    # sudo -u splunk_user ssh-keygen -t rsa -b 4096 -C 'splunk_user' -f /home/splunk_user/.ssh/id_rsa -N ''
    ###
    # sudo -u splunk_user ssh-keygen -t rsa -N '' -f /home/splunk_user/.ssh/id_rsa
    ###
    # chmod 600 /home/splunk_user/.ssh/authorized_keys

    # Add the ansible user's public key to the splunk_user's authorized_keys file
    
    ###
    # sleep 100
    # echo ${var.ansible_public_key_path} >> /home/splunk_user/.ssh/authorized_keys

    # chmod 600 /home/splunk_user/.ssh/authorized_keys
    # chown -R splunk_user:splunk_user /home/splunk_user/.ssh
    # chown -R splunk_user:splunk_user /home/splunk_user/.ssh/authorized_keys
    ###
  EOF

  tags = merge(
    {
      "Name" = "${var.instance_tags[count.index].value}.${var.domain}"
    },
    var.instance_tags[count.index].value == "sh01" ? {
      "Instance" = "SearchHead"
    } : {},
    contains([lower(var.instance_tags[count.index].value)], "sh01") ? {
      "Instance" = "SearchHead"
    } : {},
    contains([lower(var.instance_tags[count.index].value)], "sh02") ? {
      "Instance" = "SearchHead"
    } : {},

    ################################

    contains([lower(var.instance_tags[count.index].value)], "idx01") ? {
      "Instance" = "Indexer"
    } : {},

    contains([lower(var.instance_tags[count.index].value)], "idx02") ? {
      "Instance" = "Indexer"
    } : {},

    contains([lower(var.instance_tags[count.index].value)], "idx02") ? {
      "Instance" = "Indexer"
    } : {},

  )

}
