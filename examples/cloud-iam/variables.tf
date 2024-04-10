variable "azure" {
  type = object({
    subscription_id = string
    tenant_id       = string
  })
  description = "Credentials for the azure provider"
}

variable "scaleway" {
  type = object({
    access_key_enc  = string
    secret_key_enc  = string
    organization_id = string
    project_id      = string
    region          = string
    zone            = string
  })
  sensitive   = true
  description = "Credentials for scaleway"
}

variable "terraform_backend" {
  type = object({
    storage_account_name   = string
    storage_container_name = string
    storage_container_key  = string
  })
  description = "Settings for the terraform backend"
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

variable "scw_ssh_keys" {
  type = map(object({
    name           = string
    public_key_enc = string
    project_id     = string
    disabled       = bool
  }))
  description = "SSH public key to enable access to Scaleway VMS"
}

variable "az_service_principals" {
  type = map(object({
    az_ad_application_name = string
    description            = string
    hours_to_expiry        = string
    role_type              = string
    custom_role = object({
      name              = string
      assignable_scopes = list(string)
      assigned_scopes   = list(string)
      permissions = object({
        actions          = list(string)
        not_actions      = list(string)
        data_actions     = list(string)
        not_data_actions = list(string)
      })
      description = string
    })
    builtin_role = object({
      name            = string
      assigned_scopes = list(string)
    })
    skip_service_principal_aad_check = bool
  }))
  description = "Service principal configuration including assignable roles"
}

variable "scw_iam" {
  type = map(object({
    name            = string
    description     = string
    organization_id = string
    project_id      = string
    tags            = map(string)
    policies = map(object({
      name            = string
      description     = string
      project_names   = list(string)
      permission_sets = list(string)
    }))
  }))
  description = "Variables required to create the iam application with permissions set"
  // Scaleway labels are max of  70 characters - api rejects them longer
  // Validation doesn't seem to work
  validation {
    condition = alltrue(flatten([
      for v in var.scw_iam : [
        for t in v.tags : length(t) < 70
      ]
    ]))
    error_message = "The tag for this label is too long, keep under 70 characters"
  }
}

variable "az_key_vaults" {
  type = map(object({
    name                    = string
    sku                     = string
    enable_purge_protection = string
    resource_group          = string
    location                = string
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
    tf_ignore_network_rules = bool
  }))
}

variable "az_scw_iam_secrets" {
  type = map(object({
    name           = string
    content_type   = string
    iam_key        = string
    vault          = string
    resource_group = string
    tags           = map(string)
    expires        = bool
    expiry_year    = number
    expiry_month   = number
    expiry_day     = number
  }))
}

