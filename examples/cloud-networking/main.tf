// Scaleway Networking
module "scw_public_gateways" {
  source = "git::https://github.com/eirenauts/tf-modules.git//modules/scw-gateway?ref=0.0.7"
  // source = "../../../../../../open/tf-modules/modules/scw-gateway"

  for_each = var.scw_public_gateways
  scw_public_gateway = merge(
    each.value,
    { tags = flatten([
      for tag_key, tag_val in merge(var.global_tags, each.value.tags) :
      ["${tag_key}=${tag_val}"]
    ]) }
  )
}

// Scaleway Private Network
module "scw_vpcs" {
  depends_on = [module.scw_public_gateways]
  source     = "git::https://github.com/eirenauts/tf-modules.git//modules/scw-vpc?ref=0.0.7"
  // source     = "../../../../../../open/tf-modules/modules/scw-vpc"

  for_each = var.scw_vpcs
  scw_vpc = merge(
    each.value,
    { tags = flatten([
      for tag_key, tag_val in merge(var.global_tags, each.value.tags) :
      ["${tag_key}=${tag_val}"]
    ]) }
  )
}

// Scaleway Loadbalancer
module "scw_loadbalancers" {
  depends_on = [module.scw_vpcs]
  source     = "git::https://github.com/eirenauts/tf-modules.git//modules/scw-loadbalancer?ref=0.0.7"
  // source     = "../../../../../../open/tf-modules/modules/scw-loadbalancer"

  for_each = var.scw_loadbalancers
  scw_loadbalancer = merge(
    each.value,
    {
      vpc_id = module.scw_vpcs[each.value.vpc_to_attach_name].scw_vpc_id,
      tags = flatten([
        for tag_key, tag_val in merge(var.global_tags, each.value.tags) :
        ["${tag_key}=${tag_val}"]
      ])
    }
  )
}

