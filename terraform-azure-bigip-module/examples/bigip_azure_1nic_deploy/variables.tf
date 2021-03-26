variable "prefix" {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "tf-azure-bigip"
}

variable "location" {}

variable "cidr" {
  description = "Azure VPC CIDR"
  type        = string
  default     = "10.2.0.0/16"
}

variable "availabilityZones" {
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  type        = list(any)
  default     = [1]
}

variable "AllowedIPs" {}

variable "instance_count" {
  description = "Number of Bigip instances to create( From terraform 0.13, module supports count feature to spin mutliple instances )"
  type        = number
  default     = 1
}

variable "f5_image_name" {
  type    = string
  default = "f5-bigip-virtual-edition-200m-best-hourly"
}
variable "f5_version" {
  type    = string
  default = "15.1.201000"
}

variable "f5_product_name" {
  type    = string
  default = "f5-big-ip-best"
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Standard_LRS"
}

