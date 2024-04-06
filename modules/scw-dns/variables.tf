variable "scw_dns" {
  type = object({
    dns_zones = map(
      object({
        a_records     = map(string)
        cname_records = map(string)
        project_id    = string
      })
    )
  })
  description = "Variables required to configure dns via scaleway"
}
