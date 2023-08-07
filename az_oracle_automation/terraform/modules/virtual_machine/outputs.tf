output "ora_vm_password" {
  description = "Password for the Oracle Virtual Machine"
  sensitive   = true
  value       = var.oravm_admin_password
}

output "linux_vm_private_ips" {
  description = "Private IP's map for the all linux Virtual Machines"
  value       = zipmap(azurerm_linux_virtual_machine.linux_vm.*.name, azurerm_linux_virtual_machine.linux_vm.*.private_ip_address)
}
