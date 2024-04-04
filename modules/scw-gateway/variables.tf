variable "scw_public_gateway" {
  type = object({
    name                 = string
    project_id           = string
    reverse_domain       = string
    zone                 = string
    tags                 = list(string)
    type                 = string
    upstream_dns_servers = list(string)
    bastion_enabled      = bool
    bastion_port         = number
    enable_smtp          = bool
  })
  description = "Variables required to deploy the public gateway"
}
