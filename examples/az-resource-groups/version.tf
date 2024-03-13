terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.84.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.35.0"
    }
  }
}
