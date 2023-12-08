provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "ubuntu" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name      = "my-key"
    security_groups = ["default"]

    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y rsyslog
                EOF

    tags = {
        Name = "ubuntu-rsyslog"
    }
}
