variable "oravm_admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created"
  default     = "eastus"
}
