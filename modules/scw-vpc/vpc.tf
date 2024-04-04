data "scaleway_vpc_public_gateway" "scw_public_gateway" {
  name = var.scw_vpc.gateway_name
  zone = var.scw_vpc.gateway_zone
}

resource "scaleway_vpc" "scw_vpc" {
  name       = var.scw_vpc.name
  project_id = var.scw_vpc.project_id
  tags       = var.scw_vpc.tags
}

resource "scaleway_vpc_private_network" "scw_vnet" {
  ipv4_subnet {
    subnet = var.scw_vpc.subnet_cidr_block
  }
  name       = var.scw_vpc.name
  project_id = var.scw_vpc.project_id
  region     = var.scw_vpc.region
  tags       = var.scw_vpc.tags
  vpc_id     = scaleway_vpc.scw_vpc.id
}

resource "scaleway_vpc_gateway_network" "scw_public_gateway_net" {
  count = var.scw_vpc.gateway_enabled && var.scw_vpc.gateway_name != "" ? 1 : 0

  gateway_id         = data.scaleway_vpc_public_gateway.scw_public_gateway.id
  private_network_id = scaleway_vpc_private_network.scw_vnet.id

  ipam_config {
    push_default_route = var.scw_vpc.gateway_push_default_route
  }
  zone = var.scw_vpc.gateway_zone
}

