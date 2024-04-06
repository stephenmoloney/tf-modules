variable "az_dns" {
  type = object({
    scw_loadbalancer_name_for_a_records = string
    az_resource_group                   = string
    dns_zones = object({
      azure = map(object({
        a_records = list(string)
      }))
    })
    tags = map(string)
  })
  description = "Variables required to configure dns via azure"
}

variable "a_records_target_ip" {
  type        = string
  description = "Ip address of the target ip for the a records, usually a loadbalancer"
}
