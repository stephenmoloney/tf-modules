output "client_secret" {
  value     = "${azuread_service_principal.service_principal.display_name}:${azuread_application_password.secret_key.value}"
  sensitive = true
}
