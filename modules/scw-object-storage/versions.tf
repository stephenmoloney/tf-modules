terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.38.3"
    }
  }
}
