provider "scaleway" {
  access_key = var.scaleway.access_key_enc
  secret_key = var.scaleway.secret_key_enc
  project_id = var.scaleway.project_id
  zone       = var.scaleway.zone
  region     = var.scaleway.region
}

provider "azurerm" {
  subscription_id = var.azure.subscription_id
  tenant_id       = var.azure.tenant_id

  features {
    key_vault {
      purge_soft_delete_on_destroy          = true
      recover_soft_deleted_key_vaults       = true
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}
