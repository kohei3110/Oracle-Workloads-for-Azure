resource "azurerm_resource_group" "basic" {
  location = var.location
  name     = "rg-oracle-automation-basic"
}

module "virtual_network" {
  source = "../../modules/virtual_network"

  resource_group_name  = azurerm_resource_group.basic.name
  address_space_vnet   = ["10.0.0.0/16"]
  address_space_subnet = ["10.0.1.0/24"]
  virtual_network_name = "ora-vnet-basic"

  depends_on = [azurerm_resource_group.basic]
}

module "bastion" {
  source = "../../modules/bastion"

  resource_group_name                 = azurerm_resource_group.basic.name
  virtual_network_name                = module.virtual_network.virtual_network_name
  azure_bastion_service_name          = "ora-bastion-basic"
  azure_bastion_subnet_address_prefix = ["10.0.0.0/24"]

  depends_on = [azurerm_resource_group.basic, module.virtual_network]
}

module "virtual_machine" {
  source = "../../modules/virtual_machine"

  resource_group_name  = azurerm_resource_group.basic.name
  virtual_network_name = module.virtual_network.virtual_network_name
  oravm_admin_password = var.oravm_admin_password

  depends_on = [azurerm_resource_group.basic, module.virtual_network]
}
