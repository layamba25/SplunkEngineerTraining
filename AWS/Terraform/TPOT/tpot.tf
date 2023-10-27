provider "aws" {
  region = "us-west-1" # Adjust this to your desired region
}

resource "aws_instance" "tpot_honeypot" {
  ami           = "ami-0e83be366243f524a" # Ubuntu 20.04 LTS in us-west-1. Adjust for other regions/OS.
  instance_type = "t2.medium"            # At least 4GB RAM required for TPot.

  key_name               = "SplunkTraining"
  vpc_security_group_ids = [aws_security_group.tpot_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                apt-get update
                apt-get install -y apt-transport-https curl software-properties-common
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                apt-get update
                apt-get install -y docker-ce
                systemctl start docker
                systemctl enable docker
                
                # TPot setup
                apt-get install -y git
                git clone https://github.com/telekom-security/tpotce.git
                cd tpotce/iso/installer/
                ./install.sh --type=user --prefix=honey
                
                 # Install Splunk Universal Forwarder from public S3 bucket
              wget https://splunkinstallers001.s3.us-east-2.amazonaws.com/splunkforwarder-9.1.1-64e843ea36b1-linux-2.6-amd64.deb -O /tmp/splunkforwarder.deb
              dpkg -i /tmp/splunkforwarder.deb

              # Set default username and password for Splunk Enterprise using user-seed.conf
              cat > /opt/splunk/etc/system/local/user-seed.conf <<EOL
              [user_info]
              USERNAME = your_username
              PASSWORD = your_password1243
              EOL

              # Configure deploymentclient.conf
              cat > /opt/splunkforwarder/etc/system/local/deploymentclient.conf <<EOL
              [deployment-client]
              [target-broker:deploymentServer]
              targetUri=YOUR_SPLUNK_DEPLOYMENT_SERVER:8089
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
