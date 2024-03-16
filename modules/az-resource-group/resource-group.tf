resource "azurerm_resource_group" "az_resource_group" {
  name     = var.az_resource_group.name
  location = var.az_resource_group.location
  tags     = var.az_resource_group.tags
}
