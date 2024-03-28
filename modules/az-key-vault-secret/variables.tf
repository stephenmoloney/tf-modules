variable "az_vault_secret" {
  type = object({
    name           = string
    content_type   = string
    vault          = string
    resource_group = string
    tags           = map(string)
    expires        = bool
    expiry_year    = number
    expiry_month   = number
    expiry_day     = number
  })
  validation {
    condition     = var.az_vault_secret.expires ? var.az_vault_secret.expiry_year >= 2024 : true
    error_message = "The expiry year must be greater than or equal to 2024"
  }
  validation {
    condition     = var.az_vault_secret.expires ? var.az_vault_secret.expiry_month >= 1 : true
    error_message = "The expiry year must be greater than or equal to 1"
  }
  validation {
    condition     = var.az_vault_secret.expires ? var.az_vault_secret.expiry_month <= 12 : true
    error_message = "The expiry year must be less than or equal to 12"
  }
  validation {
    condition     = var.az_vault_secret.expires ? var.az_vault_secret.expiry_day >= 1 : true
    error_message = "The expiry day must be greater than or equal to 1"
  }
  validation {
    condition     = var.az_vault_secret.expires ? var.az_vault_secret.expiry_day <= 31 : true
    error_message = "The expiry year must be less than or equal to 31"
  }
}

variable "az_vault_secret_value" {
  type        = string
  description = "The actual value for the secret"
  sensitive   = true
  validation {
    condition     = var.az_vault_secret_value != ""
    error_message = "The secret must have a value"
  }
}
