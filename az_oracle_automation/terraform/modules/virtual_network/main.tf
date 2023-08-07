#------------------------------------------------------
# This module creates below resources.
# 1. Virtual Network
# 2. The specified number of subnets
#------------------------------------------------------

#------------------------------------------------------
# Resource Group
#------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#------------------------------------------------------
# Virtual Network
#------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  address_space       = var.address_space_vnet
  location            = data.azurerm_resource_group.rg.location
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

#------------------------------------------------------
# Subnet
#------------------------------------------------------
resource "azurerm_subnet" "subnet" {
  count                = var.subnet_count
  name                 = "subnet-${count.index}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_space_subnet[count.index]
}
