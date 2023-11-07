provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "ubuntu" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name      = "my-key"
    security_groups = [
        "default"
    ]

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/my-key.pem")
        host        = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y docker.io",
            "sudo docker run -d -p 514:514 -p 514:514/udp -v /var/log:/var/log --name sc4s splunk/syslog-connector:latest"
        ]
    }
}
