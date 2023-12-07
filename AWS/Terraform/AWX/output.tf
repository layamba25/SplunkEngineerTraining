output "aws_instance_ip" {
    description = "IP address of the Ansible instance"
    value = aws_instance.awx_instance.public_ip
}