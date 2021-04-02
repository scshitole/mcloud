#
# Variable for the EC2 Key 
# Set via CLI or via terraform.tfvars file
#

# variable "AccessKeyID" {}

# variable "SecretAccessKey" {}
variable "public_key_path" {
  default = "scs02.pub"
}

variable "key_name" {
  description = "AWS EC2 Key name for SSH access"
  type        = string
  default = "scs02"
}

variable "prefix" {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "scs-multi"
}
