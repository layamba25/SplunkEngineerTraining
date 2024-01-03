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
  default     = [80, 443,8080, 30080]  
}