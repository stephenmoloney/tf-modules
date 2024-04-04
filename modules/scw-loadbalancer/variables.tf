variable "scw_loadbalancer" {
  type = object({
    name          = string
    type          = string
    zone          = string
    tags          = list(string)
    project_id    = string
    attach_to_vpc = bool
    vpc_id        = string
  })
  description = "Variables required to deploy the loadbalancer"
}
