resource "azurerm_resource_group" "rsg_names" {
  for_each = toset(var.rsg_names)
  name     = each.key
  location = var.location_names[each.key]
}