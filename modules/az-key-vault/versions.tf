terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    azurerm = {
      source  = "registry.opentofu.org/hashicorp/azurerm"
      version = "3.96.0"
    }
    time = {
      source  = "registry.opentofu.org/hashicorp/time"
      version = "0.11.1"
    }
  }
}
