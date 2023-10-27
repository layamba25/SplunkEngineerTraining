provider "aws" {
  region = "us-east-2" # Modify the region as per your need.
}

resource "aws_security_group" "dvwa_sg" {
  name        = "dvwa_sg"
  description = "Allow inbound traffic for DVWA"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Caution: This allows traffic from any IP. Restrict it as per your needs.
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Caution: This allows traffic from any IP. Restrict it as per your needs.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}

resource "aws_instance" "dvwa_instance" {
  ami             = "ami-0e83be366243f524a" # This is a default Ubuntu 20.04 LTS AMI in us-west-1. Ensure you use the latest AMI or one specific to your region.
  instance_type   = "t2.micro"
  key_name        = "SplunkTraining" # Replace with your key name if you want to SSH into the instance.
  security_groups = [aws_security_group.dvwa_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2 php php-mysqli php-gd libapache2-mod-php unzip
              apt install -y mysql-server
              systemctl enable mysql
              systemctl start mysql
              mysql -e "CREATE DATABASE dvwa;"
              mysql -e "CREATE USER 'dvwa'@'localhost' IDENTIFIED BY 'p@ssw0rd';"
              mysql -e "GRANT ALL ON dvwa.* TO 'dvwa'@'localhost';"
              mysql -e "FLUSH PRIVILEGES;"
              cd /var/www/html
              wget https://github.com/ethicalhack3r/DVWA/archive/master.zip
              unzip master.zip
              cp -r DVWA-master/* .
              chown www-data:www-data /var/www/html -R
              mv index.html index.html.old
              mv config/config.inc.php.dist config/config.inc.php
              systemctl restart apache2

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
    Name = "DVWA Server"
  }
}
