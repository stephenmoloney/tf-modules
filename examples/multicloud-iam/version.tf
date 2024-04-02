terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    azurerm = {
      source  = "registry.opentofu.org/hashicorp/azurerm"
      version = "3.96.0"
    }
    azuread = {
      source  = "registry.opentofu.org/hashicorp/azuread"
      version = "2.47.0"
    }
    scaleway = {
      source  = "registry.opentofu.org/scaleway/scaleway"
      version = "2.38.2"
    }
    time = {
      source  = "registry.opentofu.org/hashicorp/time"
      version = "0.11.1"
    }
  }
}


