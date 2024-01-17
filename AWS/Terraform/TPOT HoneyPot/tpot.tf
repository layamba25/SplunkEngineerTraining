provider "aws" {
  region = "us-east-2" # Adjust this to your desired region
}

resource "aws_instance" "tpot_honeypot" {
  ami           = "ami-0ec3d9efceafb89e0"
  instance_type = "t2.medium"            # At least 4GB RAM required for TPot.

  key_name               = "SplunkTraining"
  vpc_security_group_ids = [aws_security_group.tpot_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get upgrade -y
                # apt-get install -y apt-transport-https curl software-properties-common
                # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
                # add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                # apt-get update
                # apt-get install -y docker-ce
                # systemctl start docker
                # systemctl enable docker
                
                # TPot setup
                apt-get install -y git
                git clone https://github.com/telekom-security/tpotce.git
                cd tpotce/iso/installer/
                ./install.sh --type=user --prefix=honey
                
                 # Install Splunk Universal Forwarder from public S3 bucket
              wget -O splunkforwarder-9.1.2-b6b9c8185839-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.1.2/linux/splunkforwarder-9.1.2-b6b9c8185839-linux-2.6-amd64.deb" -O /tmp/splunkforwarder.deb
              dpkg -i /tmp/splunkforwarder.deb

              # Set default username and password for Splunk Enterprise using user-seed.conf
              cat > /opt/splunkforwarder/etc/system/local/user-seed.conf <<EOL
              [user_info]
              USERNAME = your_username
              PASSWORD = your_password1243
              EOL

              # Configure deploymentclient.conf
              cat > /opt/splunkforwarder/etc/system/local/deploymentclient.conf <<EOL
              [deployment-client]
              [target-broker:deploymentServer]
              targetUri=3.135.191.221:8089
              EOL

              # Start Splunk Universal Forwarder
              /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt
              EOF

  tags = {
    Name = "TPot Honeypot with Splunk Forwarder"
  }
}

resource "aws_security_group" "tpot_sg" {
  name        = "tpot_sg"
  description = "TPot Honeypot SG with SSH"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Warning: This allows SSH traffic from everywhere. Be cautious and limit this if possible!
  }

  # Other TPot services (you might adjust this further based on TPot services you're running)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
