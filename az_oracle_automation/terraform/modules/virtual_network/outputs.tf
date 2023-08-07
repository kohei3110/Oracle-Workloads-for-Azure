output "virtual_network_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}
