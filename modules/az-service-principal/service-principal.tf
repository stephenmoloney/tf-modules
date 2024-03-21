resource "azuread_application" "application" {
  display_name = var.service_principal.az_ad_application_name
}

resource "azuread_service_principal" "service_principal" {
  client_id                    = azuread_application.application.client_id
  app_role_assignment_required = true
  description                  = var.service_principal.description
}

resource "azuread_application_password" "secret_key" {
  application_id    = azuread_application.application.id
  end_date_relative = "${var.service_principal.hours_to_expiry}h"
}

resource "azurerm_role_definition" "custom_role" {
  name        = var.service_principal.custom_role.name
  description = var.service_principal.custom_role.description
  scope       = "/subscriptions/${var.subscription_id}"

  permissions {
    actions          = var.service_principal.custom_role.permissions.actions
    not_actions      = var.service_principal.custom_role.permissions.not_actions
    data_actions     = var.service_principal.custom_role.permissions.data_actions
    not_data_actions = var.service_principal.custom_role.permissions.not_data_actions
  }

  assignable_scopes = var.service_principal.custom_role.assignable_scopes
}

resource "azurerm_role_assignment" "role_assignment_custom" {
  for_each = (
    var.service_principal.role_type == "custom" ?
    toset(var.service_principal.custom_role.assigned_scopes) :
    toset([])
  )

  scope                            = each.value
  role_definition_id               = azurerm_role_definition.custom_role.role_definition_resource_id
  principal_id                     = azuread_service_principal.service_principal.id
  skip_service_principal_aad_check = var.service_principal.skip_service_principal_aad_check
}

resource "azurerm_role_assignment" "role_assignment_builtin" {
  for_each = (
    var.service_principal.role_type == "builtin" ?
    toset(var.service_principal.builtin_role.assigned_scopes) :
    toset([])
  )

  scope                            = each.value
  role_definition_name             = var.service_principal.builtin_role.name
  principal_id                     = azuread_service_principal.service_principal.id
  skip_service_principal_aad_check = var.service_principal.skip_service_principal_aad_check
}

// Eg to use a service principal in a k8s cluster definition
// service_principal {
//   client_id = azuread_service_principal.service_principal.client_id
//   client_secret = azuread_application_password.secret_key.value
// }
