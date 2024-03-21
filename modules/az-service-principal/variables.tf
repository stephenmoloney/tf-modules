variable "service_principal" {
  type = object({
    az_ad_application_name           = string
    hours_to_expiry                  = string
    role_type                        = string
    description                      = string
    skip_service_principal_aad_check = bool
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
  })
  validation {
    condition     = contains(["custom", "builtin"], var.service_principal.role_type)
    error_message = "The role type must be either `custom` or `builtin`"
  }
}

variable "subscription_id" {
  type        = string
  description = "Id of the subscription scope for the role assignment"
}
