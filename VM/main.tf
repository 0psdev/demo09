resource "azurerm_network_interface" "nic-vm" {
  for_each = toset(var.vm_names)
  name                = "${each.key}-nic"
  resource_group_name = var.rsg_names
  location            = var.location_names

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.snet_name
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg-vm" {
  for_each = toset(var.vm_names)
  name                = "${each.key}-nsg"
  resource_group_name = var.rsg_names
  location            = var.location_names
}

resource "azurerm_network_security_rule" "rule_vm_1" {
  for_each = toset(var.vm_names)
  name                       = "allow_rdp"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "3389"
  source_address_prefix      = "*"
  destination_address_prefix = azurerm_network_interface.nic-vm[each.key].private_ip_address
  resource_group_name        = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-vm[each.key].name
}

resource "azurerm_network_security_rule" "rule_vm_2" {
  for_each = toset(var.vm_names)
    name                       = "allow_https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.nic-vm[each.key].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-vm[each.key].name
}

resource "azurerm_network_interface_security_group_association" "nsg-ass-vm" {
  for_each = toset(var.vm_names)
  network_interface_id      = azurerm_network_interface.nic-vm[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg-vm[each.key].id
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = toset(var.vm_names)
  name                = "${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  size                = var.vm_specs[each.key.vm_size]
  admin_username      = "test_admin"
  admin_password      = "P@$$w0rd1234!"
  computer_name = each.key
  enable_automatic_updates = true
  license_type = "None"
  network_interface_ids = [
    azurerm_network_interface.nic-vm[each.key]
  ]

  os_disk {
    name                 = "${each.key}+os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "vm-data-01" {
  for_each = toset(var.vm_names)
  name                 = "${each.key}-data-01"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.vm_specs[each.key.disk_size_gb]
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk-attach-vm" {
  for_each = toset(var.vm_names)
  virtual_machine_id = azurerm_windows_virtual_machine.vm[each.key].id
  managed_disk_id    = azurerm_managed_disk.vm-data-01[each.key].id
  lun                = "3"
  caching            = "ReadWrite"
}