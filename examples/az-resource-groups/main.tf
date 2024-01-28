// Azure Resources
module "az_resource_groups" {
  source = "git::https://github.com/eirenauts/tf-modules.git//az-resource-group"

  for_each          = var.az_resource_groups
  az_resource_group = each.value
}

