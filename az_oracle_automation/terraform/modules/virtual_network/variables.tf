variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "address_space_vnet" {
  description = "The address space to use for the vnet"
  default     = []
}

variable "address_space_subnet" {
  description = "The address space to use for the subnet"
  default     = []
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = ""
}

variable "subnet_count" {
  description = "The number of subnets required."
  default     = 1
}
