variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instances"
  type        = string
  default     = "SplunkTraining"

}

variable "key_pair_path" {
  description = "Path to the key pair to use for EC2 instances"
  type        = string
  default     = "C:\\Users\\leona\\OneDrive\\Desktop\\Training\\Splunk Engineering\\AWS\\SplunkTraining.pem"

}

variable "awx_ports" {
  description = "List of ports to open for AWX"
  type        = list(number)
  default     = [80, 443, 8080, 30080]
}

variable "aws_hostname" {
  description = "Hostname for the EC2 instance"
  type        = string
  default     = "ansible"
}

variable "domain" {
  description = "Domain for the EC2 instance"
  type        = string
  default     = "capstone.nilipay.com"
}

variable "tailscale_authKey" {
  description = "Tailscale Auth Key"
  type        = string
  default     = "tskey-auth-kKkEKc4CNTRL-ZKZG7Eui2ANBnfeQvQ2p9NwEtaAJaMftc"
}

variable "tailscale_tags" {
  description = "Tailscale Tags"
  type        = string
  default     = "tag:splunk-training,tag:captivatortechnologies,tag:splunk-servers-ssh,tag:admins"
}
