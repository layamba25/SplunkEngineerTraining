variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "splunk-resources"
}

variable "resource_group_location" {
  description = "Location of the Azure resource group"
  type        = string
  default     = "us-east2"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "splunk-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "splunk-subnet"
}

variable "subnet_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}


variable "instance_tags" {
   description = "List of targeted nodes tags for EC2 instances"
   type        = list(map(string))
   default = [
     {
       "key"   = "Name"
       "value" = "searchhead01"
     },
     {
       "key"   = "Name"
       "value" = "searchhead02"
     }
      ,
      {
       "key"   = "Name"
       "value" = "indexer01"
      },
      {
        "key"   = "Name"
        "value" = "indexer02"
      },
      {
        "key"   = "Name"
        "value" = "indexer03"
      },
      {
        "key"   = "Name"
        "value" = "clustermanager"
      },
      {
        "key"   = "Name"
        "value" = "deploymentserver"
      },
      {
        "key"   = "Name"
        "value" = "deployer"
      },
      {
        "key"   = "Name"
        "value" = "heavyforwarder"
      },
      {
        "key"   = "Name"
        "value" = "linuxuniversalforwarder"
      },
      {
        "key"   = "Name"
        "value" = "license-server"
      }
   ]
 }

 variable "domain" {
     description = "Domain Name of the Company"
     default = "training.nilipay.com"
 }

 variable "splunk_ports" {
   type        = list(number)
   default = ["8000", "8089", "9997", "8088", "9998"]
 }

 variable "splunk_download" {
   default =  "https://download.splunk.com/products/splunk/releases/9.0.5/linux/splunk-9.0.5-e9494146ae5c-Linux-x86_64.tgz"
 }

 variable "splunk_password" {
   default = "admin12345"
 }

variable "tailscale_authKey" {
  description = "Tailscale Auth Key"
  default     = "tskey-auth-knCJ6g7CNTRL-9RzpqSxDoGcKttY8bniMHckS8ZDMLVWZZ"
}

variable "tailscale_advertiseTags" {
  description = "Tailscale Advertise Tags"
  default     = "tag:splunk-servers-ssh"
}

#  variable "ansible_public_key" {
#    description = "Public key for the Ansible instance"
#    default     = "ssh-rsa <ansible_public_key_content>"
#  }

