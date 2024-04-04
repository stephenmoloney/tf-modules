variable "scw_vpc" {
  type = object({
    name              = string
    project_id        = string
    tags              = list(string)
    region            = string
    subnet_cidr_block = string

    // Gateway vars to bind to an existing public gateway
    gateway_enabled = bool

    gateway_name               = string
    gateway_zone               = string
    gateway_subnet_cidr_block  = string
    gateway_push_default_route = bool
  })
  description = "Variables required to deploy the private network"
}

