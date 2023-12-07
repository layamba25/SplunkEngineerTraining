 variable "instance_tags" {
    description = "List of targeted nodes tags for EC2 instances"
    type        = list(map(string))
    default = [
      {
        "key"   = "Name"
        "value" = "awx"
      }
    ]
  }
  
 variable "ubuntu_ami" {
   description = "AMI ID for Ubuntu"
   default     = "ami-024e6efaf93d85776"
 }

 variable "instance_type" {
   description = "EC2 instance type"
    # default     = "t2.large"
   default = "t2.medium"
 }

 variable "key_pair_name" {
   description = "Key pair name"
   default     = "SplunkTraining"
 }

variable "awx_hostname" {
  description = "Hostname for the AWX server"
  default     = "awx"
  
}

 variable "domain" {
     description = "Domain Name of the Company"
     default = "training.nilipay.com"
 }

  variable "awx_ports" {
   type        = list(number)
   default = ["8081", "8080", "80","443"]
 }

variable "tailscale_authKey" {
  description = "Tailscale Auth Key"
  default     = "tskey-auth-knCJ6g7CNTRL-9RzpqSxDoGcKttY8bniMHckS8ZDMLVWZZ"
}

variable "tailscale_advertiseTags" {
  description = "Tailscale Advertise Tags"
  default     = "tag:awx"
}
