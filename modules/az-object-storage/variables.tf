variable "az_storage_account" {
  type = object({
    name                            = string
    resource_group                  = string
    account_kind                    = string
    account_tier                    = string
    account_replication_type        = string
    access_tier                     = string
    enable_https_traffic_only       = bool
    allow_nested_items_to_be_public = bool
    network_rules = list(object({
      default_action             = string
      ip_rules                   = list(string)
      virtual_network_subnet_ids = list(string)
      bypass                     = list(string)
    }))
    large_file_share_enabled = bool
    storage_containers = map(object({
      name        = string
      access_type = string
    }))
    tags                    = map(string)
    tf_ignore_network_rules = bool
  })
}
