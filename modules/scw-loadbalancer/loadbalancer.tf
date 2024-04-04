resource "scaleway_lb_ip" "scw_ip" {
  zone       = var.scw_loadbalancer.zone
  project_id = var.scw_loadbalancer.project_id
}

resource "scaleway_lb" "scw_loadbalancer" {
  depends_on = [scaleway_lb_ip.scw_ip]
  count      = var.scw_loadbalancer.attach_to_vpc ? 1 : 0

  ip_id                   = scaleway_lb_ip.scw_ip.id
  name                    = var.scw_loadbalancer.name
  type                    = var.scw_loadbalancer.type
  zone                    = var.scw_loadbalancer.zone
  description             = var.scw_loadbalancer.name
  project_id              = var.scw_loadbalancer.project_id
  tags                    = var.scw_loadbalancer.tags
  assign_flexible_ip      = null
  ssl_compatibility_level = "ssl_compatibility_level_intermediate"

  private_network {
    dhcp_config        = true
    private_network_id = var.scw_loadbalancer.vpc_id
  }
}

resource "scaleway_lb" "scw_loadbalancer_public_only" {
  depends_on = [scaleway_lb_ip.scw_ip]
  count      = var.scw_loadbalancer.attach_to_vpc ? 0 : 1

  ip_id                   = scaleway_lb_ip.scw_ip.id
  name                    = var.scw_loadbalancer.name
  type                    = var.scw_loadbalancer.type
  zone                    = var.scw_loadbalancer.zone
  description             = var.scw_loadbalancer.name
  project_id              = var.scw_loadbalancer.project_id
  tags                    = var.scw_loadbalancer.tags
  assign_flexible_ip      = null
  ssl_compatibility_level = "ssl_compatibility_level_intermediate"
}
