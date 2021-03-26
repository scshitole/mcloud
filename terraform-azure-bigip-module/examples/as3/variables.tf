variable "prefix" {
  default = "scs"
}
variable "location" {
  default = "eastus"
}
variable "resource_group" {}
variable "password" {}
variable "username" {}
variable "address" {}
variable "port" {}
variable "subnet_id" {}
variable "upassword" {
  default = "F5Cisco!23"
}
variable "app_count" {
  default = 1
}
variable "declaration" {
  default = "as3.json"
}
