data "azurerm_dns_zone" "az_dns_zones" {
  for_each = toset(keys(var.scw_az_ns_redirects.dns_zones.scw))
  name     = each.value
}

resource "scaleway_domain_record" "scw_ns_redirects_to_azure" {
  for_each = {
    for ns_record in flatten([
      for zone in keys(var.scw_az_ns_redirects.dns_zones.scw) : [
        // It's a range of 4 elements because terraform needs to know in advance
        // Setting statically for 4 azure name servers for ns redirection
        for idx in range(0, 4) : {
          idx  = idx
          key  = replace("${zone}-${idx}", ".", "-")
          zone = zone
        }
      ]
    ]) : ns_record.key => { idx = ns_record.idx, zone = ns_record.zone }
    if var.scw_az_ns_redirects.dns_zones.scw[ns_record.zone].redirect_using_azure_ns_records == true
  }

  dns_zone        = each.value.zone
  keep_empty_zone = false // will help ensure zone is deleted
  priority        = 0
  name            = each.key
  type            = "NS"
  data            = element(tolist(data.azurerm_dns_zone.az_dns_zones[each.value.zone].name_servers), each.value.idx)
  ttl             = 1800
}
