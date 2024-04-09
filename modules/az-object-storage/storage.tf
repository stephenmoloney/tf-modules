data "azurerm_resource_group" "az_resource_group" {
  name = var.az_storage_account.resource_group
}

resource "azurerm_storage_account" "az_storage_account" {
  name                            = var.az_storage_account.name
  resource_group_name             = data.azurerm_resource_group.az_resource_group.name
  location                        = data.azurerm_resource_group.az_resource_group.location
  account_tier                    = var.az_storage_account.account_tier
  account_kind                    = var.az_storage_account.account_kind
  account_replication_type        = var.az_storage_account.account_replication_type
  access_tier                     = var.az_storage_account.access_tier
  enable_https_traffic_only       = var.az_storage_account.enable_https_traffic_only
  allow_nested_items_to_be_public = var.az_storage_account.allow_nested_items_to_be_public
  large_file_share_enabled        = var.az_storage_account.large_file_share_enabled
  tags                            = var.az_storage_account.tags

  dynamic "network_rules" {
    for_each = var.az_storage_account.network_rules
    content {
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
      bypass                     = network_rules.value.bypass
    }
  }

  // Ignoring the network rules because later they are going to be modified
  // to include created instances
  // Otherwise, get a lot of thrashing with terraform changes over and back
  lifecycle {
    ignore_changes = [
      network_rules
    ]
  }
}

resource "azurerm_storage_container" "storage_containers" {
  depends_on = [azurerm_storage_account.az_storage_account]

  for_each              = var.az_storage_account.storage_containers
  storage_account_name  = azurerm_storage_account.az_storage_account.name
  name                  = each.value.name
  container_access_type = each.value.access_type
}
