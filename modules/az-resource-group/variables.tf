variable "az_resource_group" {
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
  description = "Variables to create the azure resource group"
}
