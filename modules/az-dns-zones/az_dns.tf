data "azurerm_resource_group" "az_resource_group" {
  name = var.az_dns.az_resource_group
}

resource "azurerm_dns_zone" "az_dns_zones" {
  for_each = toset(keys(var.az_dns.dns_zones.azure))

  name                = each.value
  resource_group_name = data.azurerm_resource_group.az_resource_group.name
  tags                = merge(var.az_dns.tags, { dns_zone = each.value, type = "Azure DNS Zone" })
}
