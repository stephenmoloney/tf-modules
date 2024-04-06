data "azurerm_resource_group" "az_resource_group" {
  name = var.az_dns.az_resource_group
}

data "azurerm_dns_zone" "az_dns_zones" {
  for_each = toset(keys(var.az_dns.dns_zones.azure))
  name     = each.value
}

locals {
  dns_a_records = flatten([
    for dns_key, dns_val in var.az_dns.dns_zones.azure : [
      for subdomain_val in dns_val.a_records : {
        parent_domain = dns_key
        sub_domain    = subdomain_val
      }
  ]])

  dns_ns_redirects = flatten([
    for dns_key, dns_val in var.az_dns.dns_zones.azure : {
      dns_key = dns_key
      dns_val = dns_val
  }])
}

resource "azurerm_dns_ns_record" "az_ns_redirect" {
  for_each = toset(keys({
    for dns_zone in local.dns_ns_redirects : dns_zone.dns_key => dns_zone
    if length(split(".", dns_zone.dns_key)) > 2
  }))

  name                = split(".", each.value)[0]
  zone_name           = join(".", slice(split(".", each.value), 1, length(split(".", each.value))))
  resource_group_name = data.azurerm_resource_group.az_resource_group.name
  ttl                 = 300

  records = data.azurerm_dns_zone.az_dns_zones[each.value].name_servers

  tags = merge(var.az_dns.tags, { dns_zone = join(".", slice(split(".", each.value), 1, length(split(".", each.value)))), type = "NS Record" })
}

resource "azurerm_dns_a_record" "az_a_record" {
  depends_on = [
    azurerm_dns_ns_record.az_ns_redirect
  ]
  for_each = {
    for dns_record in local.dns_a_records : "${dns_record.sub_domain}.${dns_record.parent_domain}" => dns_record
    if local.dns_a_records != []
  }

  name                = each.value.sub_domain
  zone_name           = each.value.parent_domain
  resource_group_name = data.azurerm_resource_group.az_resource_group.name
  ttl                 = 300
  records             = [var.a_records_target_ip]
  tags                = merge(var.az_dns.tags, { parent = each.value.parent_domain, type = "A Record" })
}
