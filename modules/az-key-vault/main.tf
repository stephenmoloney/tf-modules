resource "azurerm_key_vault" "az_key_vault" {
  count = var.az_key_vault.tf_ignore_network_rules ? 0 : 1

  name                = var.az_key_vault.name
  resource_group_name = var.az_key_vault.resource_group
  # Note: location name expected, not name, get display names using cli
  # az account list-locations | jq -r .[].name
  # az account list-locations | jq -r .[].displayName
  # az account list-locations --query "[].{DisplayName:displayName, Name:name}[?Name=='northeurope']" -o json | jq -r .[0].DisplayName
  location                 = var.az_key_vault.location
  sku_name                 = var.az_key_vault.sku
  tenant_id                = var.az_tenant_id
  purge_protection_enabled = var.az_key_vault.enable_purge_protection
  tags                     = var.az_key_vault.tags

  dynamic "network_acls" {
    for_each = var.az_key_vault.network_rules
    content {
      default_action             = network_acls.value.default_action
      ip_rules                   = concat(network_acls.value.ip_rules, var.az_key_vault_adjunctive_ip_rules)
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
      bypass                     = network_acls.value.bypass
    }
  }
}

resource "azurerm_key_vault" "az_key_vault_ignore_net_rules" {
  count = var.az_key_vault.tf_ignore_network_rules ? 1 : 0

  name                = var.az_key_vault.name
  resource_group_name = var.az_key_vault.resource_group
  # Note: location name expected, not name, get display names using cli
  # az account list-locations | jq -r .[].name
  # az account list-locations | jq -r .[].displayName
  # az account list-locations --query "[].{DisplayName:displayName, Name:name}[?Name=='northeurope']" -o json | jq -r .[0].DisplayName
  location                 = var.az_key_vault.location
  sku_name                 = var.az_key_vault.sku
  tenant_id                = var.az_tenant_id
  purge_protection_enabled = var.az_key_vault.enable_purge_protection
  tags                     = var.az_key_vault.tags

  dynamic "network_acls" {
    for_each = var.az_key_vault.network_rules
    content {
      default_action             = network_acls.value.default_action
      ip_rules                   = concat(network_acls.value.ip_rules, var.az_key_vault_adjunctive_ip_rules)
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
      bypass                     = network_acls.value.bypass
    }
  }

  // Ignoring the network rules because later they are going to be modified
  // to include created instances
  // Otherwise, get a lot of thrashing with terraform changes over and back
  lifecycle {
    ignore_changes = [
      network_acls
    ]
  }
}

locals {
  access_policies_params = [
    for access_policy in var.az_key_vault.access_policies : {
      vault_key         = var.az_key_vault.name
      vault_id          = var.az_key_vault.tf_ignore_network_rules ? azurerm_key_vault.az_key_vault_ignore_net_rules[0].id : azurerm_key_vault.az_key_vault[0].id
      access_policy_key = access_policy.principal_name
      access_policy     = access_policy
    }
  ]
}

data "azuread_service_principal" "az_service_principal" {
  for_each = {
    for access_policy in local.access_policies_params : "${access_policy.vault_key}.${access_policy.access_policy_key}" => access_policy
    if access_policy.access_policy.type == "service-principal"
  }

  display_name = each.value.access_policy.principal_name
}

data "azuread_user" "az_user_principal" {
  for_each = {
    for access_policy in local.access_policies_params : "${access_policy.vault_key}.${access_policy.access_policy_key}" => access_policy
    if access_policy.access_policy.type == "user-principal"
  }
  user_principal_name = each.value.access_policy.principal_name
}

resource "azurerm_key_vault_access_policy" "az_service_principal_access_policies" {
  depends_on = [azurerm_key_vault.az_key_vault]

  for_each = {
    for access_policy in local.access_policies_params : "${access_policy.vault_key}.${access_policy.access_policy_key}" => access_policy
    if access_policy.access_policy.type == "service-principal" && (var.az_key_vault.tf_ignore_network_rules == false)
  }

  key_vault_id            = each.value.vault_id
  tenant_id               = var.az_tenant_id
  object_id               = data.azuread_service_principal.az_service_principal[each.key].object_id
  key_permissions         = each.value.access_policy.key_permissions
  secret_permissions      = each.value.access_policy.secret_permissions
  certificate_permissions = each.value.access_policy.certificate_permissions
  storage_permissions     = each.value.access_policy.storage_permissions

  lifecycle {
    ignore_changes = [
      object_id
    ]
  }
}

resource "azurerm_key_vault_access_policy" "az_service_principal_access_policies_ignore_net_rules" {
  depends_on = [azurerm_key_vault.az_key_vault_ignore_net_rules]

  for_each = {
    for access_policy in local.access_policies_params : "${access_policy.vault_key}.${access_policy.access_policy_key}" => access_policy
    if access_policy.access_policy.type == "service-principal" && var.az_key_vault.tf_ignore_network_rules
  }

  key_vault_id            = each.value.vault_id
  tenant_id               = var.az_tenant_id
  object_id               = data.azuread_service_principal.az_service_principal[each.key].object_id
  key_permissions         = each.value.access_policy.key_permissions
  secret_permissions      = each.value.access_policy.secret_permissions
  certificate_permissions = each.value.access_policy.certificate_permissions
  storage_permissions     = each.value.access_policy.storage_permissions

  lifecycle {
    ignore_changes = [
      object_id
    ]
  }
}

resource "azurerm_key_vault_access_policy" "az_user_principal_access_policies" {
  depends_on = [azurerm_key_vault.az_key_vault]

  for_each = {
    for access_policy in local.access_policies_params : "${access_policy.vault_key}.${access_policy.access_policy_key}" => access_policy
    if access_policy.access_policy.type == "user-principal" && (var.az_key_vault.tf_ignore_network_rules == false)
  }

  key_vault_id            = each.value.vault_id
  tenant_id               = var.az_tenant_id
  object_id               = data.azuread_user.az_user_principal[each.key].object_id
  key_permissions         = each.value.access_policy.key_permissions
  secret_permissions      = each.value.access_policy.secret_permissions
  certificate_permissions = each.value.access_policy.certificate_permissions
  storage_permissions     = each.value.access_policy.storage_permissions

  lifecycle {
    ignore_changes = [
      object_id
    ]
  }
}

resource "azurerm_key_vault_access_policy" "az_user_principal_access_policies_ignore_net_rules" {
  depends_on = [azurerm_key_vault.az_key_vault_ignore_net_rules]

  for_each = {
    for access_policy in local.access_policies_params : "${access_policy.vault_key}.${access_policy.access_policy_key}" => access_policy
    if access_policy.access_policy.type == "user-principal" && var.az_key_vault.tf_ignore_network_rules
  }

  key_vault_id            = each.value.vault_id
  tenant_id               = var.az_tenant_id
  object_id               = data.azuread_user.az_user_principal[each.key].object_id
  key_permissions         = each.value.access_policy.key_permissions
  secret_permissions      = each.value.access_policy.secret_permissions
  certificate_permissions = each.value.access_policy.certificate_permissions
  storage_permissions     = each.value.access_policy.storage_permissions

  lifecycle {
    ignore_changes = [
      object_id
    ]
  }
}

locals {
  rsa_params = [
    for rsa_key in var.az_key_vault.rsa_keys : {
      vault_key = var.az_key_vault.name
      vault_id  = var.az_key_vault.tf_ignore_network_rules ? azurerm_key_vault.az_key_vault_ignore_net_rules[0].id : azurerm_key_vault.az_key_vault[0].id
      rsa_key   = rsa_key.name
      name      = rsa_key.name
      type      = rsa_key.type
      size      = rsa_key.key_size
      opts      = rsa_key.key_opts
    }
  ]
}

resource "azurerm_key_vault_key" "az_rsa_key" {
  depends_on = [
    azurerm_key_vault.az_key_vault
  ]

  for_each = {
    for rsa_key in local.rsa_params : "${rsa_key.vault_key}.${rsa_key.rsa_key}" => rsa_key
    if var.az_key_vault.tf_ignore_network_rules == false
  }

  key_vault_id = each.value.vault_id
  name         = each.value.name
  key_type     = each.value.type
  key_size     = each.value.size
  key_opts     = each.value.opts
}


resource "azurerm_key_vault_key" "az_rsa_key_ignore_net_rules" {
  depends_on = [
    azurerm_key_vault.az_key_vault_ignore_net_rules
  ]

  for_each = {
    for rsa_key in local.rsa_params : "${rsa_key.vault_key}.${rsa_key.rsa_key}" => rsa_key
    if var.az_key_vault.tf_ignore_network_rules
  }

  key_vault_id = each.value.vault_id
  name         = each.value.name
  key_type     = each.value.type
  key_size     = each.value.size
  key_opts     = each.value.opts
}

