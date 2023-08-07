#------------------------------------------------------
# This module creates below resources.
# 1. Virtual Machine
# 2. OS Disk and two data disks
#------------------------------------------------------

#------------------------------------------------------
# Local variables
#------------------------------------------------------
locals {
  updateDomainCount = 6
  faultDomainCount  = 2
}

#------------------------------------------------------
# Resource Group, VNET
#------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "snet" {
  name                 = "Subnet1"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

#------------------------------------------------------
# Virtual Machine, NIC
#------------------------------------------------------
resource "azurerm_linux_virtual_machine" "ora_vm" {
  count                 = var.instances_count
  name                  = "oravm-${count.index}"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [element(concat(azurerm_network_interface.nic.*.id, tolist([])), count.index)]
  size                  = var.virtual_machine_size
  availability_set_id   = azurerm_availability_set.availability_set.id

  source_image_reference {
    publisher = "Oracle"
    offer     = "oracle-database"
    sku       = "oracle_db_21"
    version   = "21.0.0"
  }

  os_disk {
    name                 = "oravm-${count.index}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username                  = var.oravm_admin_username
  admin_password                  = var.oravm_admin_password
  disable_password_authentication = false
}

resource "azurerm_network_interface" "nic" {
  count               = var.instances_count
  name                = var.instances_count == 1 ? "nic" : "nic-${count.index}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  ip_configuration {
    name                          = lower("ipconig-${count.index + 1}")
    primary                       = true
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#------------------------------------------------------
# Availability Set
#------------------------------------------------------
resource "azurerm_availability_set" "availability_set" {
  name                         = "ora-availability-set"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  platform_fault_domain_count  = local.faultDomainCount
  platform_update_domain_count = local.updateDomainCount
}

#------------------------------------------------------
# Managed Disk for data files, temp files, 
# control files, block change tracking files, BFILEs, 
# files for external tables, and flashback logs.
#------------------------------------------------------
resource "azurerm_managed_disk" "data_files_disk" {
  name                 = "data-files-disk"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
}

#------------------------------------------------------
# Managed Disk for online redo log files.
#------------------------------------------------------
resource "azurerm_managed_disk" "redo_log_disk" {
  name                 = "redo-log-disk"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
}

#------------------------------------------------------
# Virtual Machine Data Disk Attachment for each disk
#------------------------------------------------------
resource "azurerm_virtual_machine_data_disk_attachment" "data_files_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.data_files_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.ora_vm[0].id
  lun                = 0
  caching            = "ReadOnly"
}

resource "azurerm_virtual_machine_data_disk_attachment" "redo_log_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.redo_log_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.ora_vm[0].id
  lun                = 1
  caching            = "None"
}
