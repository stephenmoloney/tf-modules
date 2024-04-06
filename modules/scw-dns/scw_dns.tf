resource "scaleway_domain_zone" "scw_dns_zones" {
  depends_on = []

  for_each = {
    for record in flatten([
      for zone in keys(var.scw_dns.dns_zones) : [
        {
          key        = replace(zone, ".", "-")
          zone       = zone
          a_records  = var.scw_dns.dns_zones[zone].a_records
          project_id = var.scw_dns.dns_zones[zone].project_id
        }
      ]
    ]) : record.key => { zone = record.zone, a_records = record.a_records, project_id = record.project_id }
    // only create a subdomain for non-root zones
    if length(split(".", record.zone)) > 2
  }

  domain = (
    replace(
      each.value.zone,
      "${element(split(".", each.value.zone), 0)}.",
      ""
    )
  )
  subdomain  = element(split(".", each.value.zone), 0)
  project_id = each.value.project_id
}

resource "scaleway_domain_record" "scw_a_records" {
  depends_on = [scaleway_domain_zone.scw_dns_zones]

  for_each = {
    for record in flatten([
      for zone in keys(var.scw_dns.dns_zones) : [
        for a_rec_name, a_rec_ip in var.scw_dns.dns_zones[zone].a_records : [
          {
            key           = a_rec_name != "" ? "${a_rec_name}.${replace(zone, ".", "-")}" : replace(zone, ".", "-")
            zone          = zone
            a_record_name = a_rec_name
            a_record_ip   = a_rec_ip
          }
        ]
      ]
      ]) : record.key => {
      zone          = record.zone,
      a_record_name = record.a_record_name,
      a_record_ip   = record.a_record_ip
    }
  }

  dns_zone        = each.value.zone
  keep_empty_zone = false // will help ensure zone is deleted
  priority        = 0
  name            = each.value.a_record_name
  type            = "A"
  data            = each.value.a_record_ip
  ttl             = 1800
}

resource "scaleway_domain_record" "scw_cname_records" {
  depends_on = [scaleway_domain_zone.scw_dns_zones, scaleway_domain_record.scw_a_records]

  for_each = {
    for record in flatten([
      for zone in keys(var.scw_dns.dns_zones) : [
        for cname_rec_src, cname_rec_dest in var.scw_dns.dns_zones[zone].cname_records : [
          {
            key               = "${replace(cname_rec_src, ".", "-")}-${zone}"
            zone              = zone
            cname_record_src  = cname_rec_src
            cname_record_dest = cname_rec_dest
          }
        ]
      ]
      ]) : record.key => {
      zone              = record.zone,
      cname_record_src  = record.cname_record_src
      cname_record_dest = record.cname_record_dest
    }
  }

  dns_zone = each.value.zone
  name     = each.value.cname_record_src
  type     = "CNAME"
  data     = "${each.value.cname_record_dest}."
  ttl      = 1800
}
