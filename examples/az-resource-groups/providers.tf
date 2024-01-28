provider "azurerm" {
  subscription_id = var.azure.subscription_id
  tenant_id       = var.azure.tenant_id

  features {}
}
