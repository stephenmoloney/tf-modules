// Scaleway SSH Keys
module "scw_ssh_keys" {
  source = "git::https://github.com/eirenauts/tf-modules.git//modules/scw-ssh-key?ref=0.0.6"
  //  source = "../../tf-modules/modules/scw-ssh-key"

  for_each    = var.scw_ssh_keys
  scw_ssh_key = merge(each.value, { public_key = each.value.public_key_enc })
}

// Create Azure Service Principals
module "az_service_principals" {
  source = "git::https://github.com/eirenauts/tf-modules.git//modules/az-service-principal?ref=0.0.6"
  // source = "../../tf-modules/modules/az-service-principal"

  for_each = {
    for service_principal in var.az_service_principals :
    service_principal.az_ad_application_name => service_principal
  }

  service_principal = each.value
  subscription_id   = var.azure.subscription_id
}

//// Create scaleway iam applications with policies set
module "scw_iam" {
  source = "git::https://github.com/eirenauts/tf-modules.git//modules/scw-iam?ref=0.0.6"
  // source = "../../tf-modules/modules/scw-iam"

  for_each = var.scw_iam
  // replace is for disallowed characters in scaleway
  scw_iam = merge(
    each.value,
    { tags = flatten([
      for tag_key, tag_val in merge(var.global_tags, each.value.tags) :
      ["${tag_key}=${replace(tag_val, "/(https://)/", "")}"]
    ]) }
  )
  scw_iam_policies = each.value.policies
}

// Create azure key vaults
module "az_key_vaults" {
  source = "git::https://github.com/eirenauts/tf-modules.git//modules/az-key-vault?ref=0.0.6"
  // source   = "../../tf-modules/modules/az-key-vault"
  for_each = var.az_key_vaults

  az_key_vault = merge(
    each.value,
    { tags = merge(var.global_tags, each.value.tags) }
  )
  az_tenant_id = var.azure.tenant_id
}

// Azure secret storage of the scaleway iam api keys
module "az_scw_iam_secrets" {
  depends_on = [module.az_key_vaults, module.scw_iam]
  source     = "git::https://github.com/eirenauts/tf-modules.git//modules/az-key-vault-secret?ref=0.0.6"
  // source     = "../../tf-modules/modules/az-key-vault-secret"

  for_each = var.az_scw_iam_secrets
  az_vault_secret = merge(
    each.value,
    {
      name = replace(each.key, "_", "-"),
      tags = merge(var.global_tags, each.value.tags)
    }
  )
  az_vault_secret_value = (
    strcontains(each.key, "access_key") ?
    module.scw_iam[each.value.iam_key].iam_application_access_key :
    module.scw_iam[each.value.iam_key].iam_application_secret_key
  )
}
