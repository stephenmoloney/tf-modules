variable "azure" {
  type = object({
    subscription_id = string
    tenant_id       = string
  })
  description = "Credentials for the azure provider"
}

variable "terraform_backend" {
  type = object({
    storage_account_name   = string
    storage_container_name = string
    storage_container_key  = string
  })
  description = "Settings for the tofu backend"
}

variable "sops_pgp_fingerprint" {
  type        = string
  description = "fingerprint of the sops key"
}

variable "global_tags" {
  type = object({
    environment  = string
    managed-by   = string
    triggered-by = string
    project      = string
    purpose      = string
    source-dir   = string
    source-repo  = string
  })
}

variable "az_resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  description = "Creates resource groups"
}
