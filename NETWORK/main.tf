resource "azurerm_virtual_network" "vnetwork" {
  name = var.vnet_name
  resource_group_name = var.rsg_names
  location = var.location_names
  address_space = var.vnet_subnet
}

resource "azurerm_subnet" "snet" {
  for_each = toset(var.snet_names)
  name = each.key
  resource_group_name = var.rsg_names
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes = var.snet_subnets[each.key]
}