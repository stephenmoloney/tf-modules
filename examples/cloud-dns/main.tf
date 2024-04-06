// Create scaleway dns zones, dns a records and dns cname records
module "scw_dns" {
  source = "../../modules/scw-dns"

  scw_dns = var.scw_dns
}

// Create azure dns zones
module "az_dns_zones" {
  source = "../../modules/az-dns-zones"

  az_dns = merge(
    var.az_scw_dns,
    { tags = merge(var.global_tags, var.az_scw_dns.tags) }
  )
}

// Get the ip address of the scaleway loadbalancer to target the dns records
data "scaleway_lb" "scw_loadbalancer" {
  name = var.az_scw_dns.scw_loadbalancer_name_for_a_records
}

// Creates NS redirects for node (parent) domains to leaf domains (subdomains)
// Creates A records for leaf (subdomains) to a loadbalancer ip address
module "az_dns_records" {
  depends_on = [module.az_dns_zones]
  source     = "../../modules/az-dns-records"

  az_dns = merge(
    var.az_scw_dns,
    { tags = merge(var.global_tags, var.az_scw_dns.tags) }
  )
  a_records_target_ip = data.scaleway_lb.scw_loadbalancer.ip_address
}

// Creates NS redirects from scaleway to azure for flagged domains
// This is needed because inside kubernetes, there is no external dns provider for certmanager
// configuration for scaleway, it needs to be managed by the big ones, egGCP or Azure or AWS
module "scw_az_dns_records" {
  source = "../../modules/scw-az-ns-redirects"

  scw_az_ns_redirects = var.az_scw_dns
}
