variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = ""
}

variable "instances_count" {
  description = "The number of Virtual Machines required."
  default     = 1
}

variable "virtual_machine_size" {
  description = "The Virtual Machine SKU for the Virtual Machine, Default is Standard_A2_V2"
  default     = "Standard_D4_v5"
}

variable "oravm_admin_username" {
  description = "The username of the local administrator used for the Oracle Virtual Machine."
  default     = "oracleadmin"
}

variable "oravm_admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
}
