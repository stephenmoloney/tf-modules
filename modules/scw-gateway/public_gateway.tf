resource "scaleway_vpc_public_gateway_ip" "scw_public_gateway_ip" {
  project_id = var.scw_public_gateway.project_id
  reverse    = var.scw_public_gateway.reverse_domain
  tags       = var.scw_public_gateway.tags
  zone       = var.scw_public_gateway.zone
}

resource "scaleway_vpc_public_gateway" "scw_public_gateway" {
  name                 = var.scw_public_gateway.name
  type                 = var.scw_public_gateway.type
  tags                 = var.scw_public_gateway.tags
  zone                 = var.scw_public_gateway.zone
  project_id           = var.scw_public_gateway.project_id
  upstream_dns_servers = var.scw_public_gateway.upstream_dns_servers
  ip_id                = scaleway_vpc_public_gateway_ip.scw_public_gateway_ip.id
  bastion_enabled      = var.scw_public_gateway.bastion_enabled
  bastion_port         = var.scw_public_gateway.bastion_port
  enable_smtp          = var.scw_public_gateway.enable_smtp
}

