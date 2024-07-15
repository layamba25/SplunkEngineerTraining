
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_1_cidr_block" {
  description = "CIDR block for private subnet 1"
  default     = "10.0.2.0/24"
}

variable "private_subnet_2_cidr_block" {
  description = "CIDR block for private subnet 2"
  default     = "10.0.3.0/24"
}

variable "ubuntu_ami" {
  description = "AMI ID for Ubuntu"
  default     = "ami-024e6efaf93d85776"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
  #  default = "t2.micro"

}

variable "key_pair_name" {
  description = "Key pair name"
  # Replace with your own key pair name e.g "splunk-training"
  default = "SplunkTraining"
}

variable "ansible_public_key_path" {
  description = "Path to the Ansible public key file"
  # Replace with your own ansible key pair path
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNnzHyUQuu2xuIRCaDjDcwl0ZMrd+MtAXnorYb0GtBTwWPcpw52hrDxaN3qV17gebiqUo4KtfAwfLsZDdBqZPV+SyKifdlo2Dq32tcsHhpddzShNFy+/JPmz3P4rzCbpOF4GdALJxd+hjaMvhYdaszsyr3g0febZVnJ3fXp1wdh8ikw/5qUtIwMjNaa6EXF4KwBLYljfbVa3tpLugiWGe13eEUj1Vme01N7gB3Blwago3F1dQgA0wxzR4uPk97B2egfIzoBgDxZ/bXTjufnr154lTG2I1Ev7bFftDHhAIPBfOkUa6t+b2KFRFxXk9MHO4bWIOtpKKBQZE9Aoa4Utc5 ansible@ip-172-31-29-38"

}

variable "ssh_key_path" {
  description = "Path to the Ansible private key file"
  # Replace with your own key pair path
  default = "C:\\Users\\leona\\OneDrive\\Desktop\\Training\\Splunk Engineering\\AWS\\SplunkTraining.pem"

}
variable "instance_count" {
  description = "Number of EC2 instances to create"
  default     = 11
  # default = 2
}


variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "control_node_hostname" {
  description = "Hostname for the control node"
  default     = "control-node"
}


variable "instance_tags" {
  description = "List of targeted nodes tags for EC2 instances"
  type        = list(map(string))
  default = [
    {
      "key"   = "Name"
      "value" = "sh01"
    },
    {
      "key"   = "Name"
      "value" = "sh02"
    }
    ,
    {
      "key"   = "Name"
      "value" = "idx01"
    },
    {
      "key"   = "Name"
      "value" = "idx02"
    },
    {
      "key"   = "Name"
      "value" = "idx03"
    },
    {
      "key"   = "Name"
      "value" = "idxm"
    },
    {
      "key"   = "Name"
      "value" = "ds"
    },
    {
      "key"   = "Name"
      "value" = "dp"
    },
    {
      "key"   = "Name"
      "value" = "hf01"
    },
    {
      "key"   = "Name"
      "value" = "linux-uf"
    },
    {
      "key"   = "Name"
      "value" = "lic"
    }
  ]
}

variable "domain" {
  description = "Domain Name of the Company"
  # Replace with your own domain name e.g "john.nilipay.com"
  default = "capstone.nilipay.com"
}

variable "splunk_ports" {
  type    = list(number)
  default = ["8000", "8089", "9997", "8088", "9998", "80", "443", "514", "5514"]
}

variable "splunk_download" {
  #  default =  "https://download.splunk.com/products/splunk/releases/9.0.5/linux/splunk-9.0.5-e9494146ae5c-Linux-x86_64.tgz"
  default = "https://download.splunk.com/products/splunk/releases/9.1.1/linux/splunk-9.1.1-64e843ea36b1-Linux-x86_64.tgz"
}

variable "tailscale_authKey" {
  description = "Tailscale Auth Key"
  #default     = "tskey-auth-kxLUMS4CNTRL-8NCWuVFCuQdWXi7oKdMRRdKuwAFBT3uWj"
  default = "tskey-auth-kKkEKc4CNTRL-ZKZG7Eui2ANBnfeQvQ2p9NwEtaAJaMftc"
}

variable "tailscale_advertiseTags" {
  description = "Tailscale Advertise Tags"
  # Replace with your own tags e.g "tag:jacob-splunk"
  default = "tag:splunk-training,tag:captivatortechnologies,tag:splunk-servers-ssh,tag:admins"
}

#  variable "ansible_public_key" {
#    description = "Public key for the Ansible instance"
#    default     = "ssh-rsa <ansible_public_key_content>"
#  }

