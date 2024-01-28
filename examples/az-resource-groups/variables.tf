variable "azure" {
  type = object({
    subscription_id = string
    tenant_id       = string
  })
  description = "Credentials for the azure provider"
}

variable "az_resource_groups" {
  type = map(object({
    location = string
    name     = string
    tags = object({
      name        = string
      environment = string
      managed-by  = string
    })
  }))
  description = "Creates resource groups"
}
