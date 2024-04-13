variable "az_key_vault" {
  type = object({
    name                    = string
    sku                     = string
    enable_purge_protection = string
    resource_group          = string
    location                = string
    tf_ignore_network_rules = bool
    rsa_keys = list(object({
      name     = string
      type     = string
      key_size = string
      key_opts = list(string)
    }))
    access_policies = list(object({
      type                    = string
      principal_name          = string
      key_permissions         = list(string)
      secret_permissions      = list(string)
      certificate_permissions = list(string)
      storage_permissions     = list(string)
    }))
    network_rules = list(object({
      default_action             = string
      ip_rules                   = list(string)
      virtual_network_subnet_ids = list(string)
      bypass                     = string
    }))
    tags = map(string)
  })
}

variable "az_tenant_id" {
  type        = string
  description = "Azure cloud tenant id in use"
  sensitive   = true
}

variable "az_key_vault_adjunctive_ip_rules" {
  type        = list(string)
  description = "Adjunctive ip rules to whitelist to the azure key vault"
  default     = []
}
