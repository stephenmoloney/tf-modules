// Azure Resources
module "az_resource_groups" {
  source = "git::https://github.com/eirenauts/tf-modules.git//modules/az-resource-group?ref=0.12.0"
  // source = "../../modules/az-resource-group"

  for_each = var.az_resource_groups
  az_resource_group = merge(
    each.value,
    { tags = merge(var.global_tags, each.value.tags) }
  )
}
