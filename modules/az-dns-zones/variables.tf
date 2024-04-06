variable "az_dns" {
  type = object({
    az_resource_group = string
    dns_zones = object({
      azure = map(object({
        a_records = list(string)
      }))
    })
    tags = map(string)
  })
  description = "Variables required to configure dns zones via azure"
}

