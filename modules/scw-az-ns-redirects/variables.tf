variable "scw_az_ns_redirects" {
  type = object({
    az_resource_group = string
    dns_zones = object({
      scw = map(object({
        redirect_using_azure_ns_records = bool
      }))
    })
  })
  description = "Variables required to configure dns via azure and scaleway"
}
