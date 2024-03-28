data "azurerm_key_vault" "az_key_vault" {
  name                = var.az_vault_secret.vault
  resource_group_name = var.az_vault_secret.resource_group
}

resource "azurerm_key_vault_secret" "az_keyvault_secret" {
  key_vault_id = data.azurerm_key_vault.az_key_vault.id

  name         = var.az_vault_secret.name
  content_type = var.az_vault_secret.content_type != "" ? var.az_vault_secret.content_type : "text/plain"
  tags         = var.az_vault_secret.tags
  expiration_date = (
    var.az_vault_secret.expires ?
    "${var.az_vault_secret.expiry_year}-${var.az_vault_secret.expiry_month}-${var.az_vault_secret.expiry_day}T00:00:00Z" :
    null
  )
  value = var.az_vault_secret_value
}
