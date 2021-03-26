#
# Variable for the EC2 Key 
# Set via CLI or via terraform.tfvars file
#

# variable "AccessKeyID" {}

# variable "SecretAccessKey" {}

variable "prefix" {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "scs-multi"
}
