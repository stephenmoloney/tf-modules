variable "azure" {
  type = object({
    subscription_id = string
    tenant_id       = string
  })
  description = "Credentials for the azure provider"
}

variable "scaleway" {
  type = object({
    access_key_enc  = string
    secret_key_enc  = string
    organization_id = string
    project_id      = string
    region          = string
    zone            = string
  })
  sensitive   = true
  description = "Credentials for scaleway"
}

variable "terraform_backend" {
  type = object({
    storage_account_name   = string
    storage_container_name = string
    storage_container_key  = string
  })
  description = "Settings for the terraform backend"
}

variable "sops_pgp_fingerprint" {
  type        = string
  description = "fingerprint of the sops key"
}

variable "global_tags" {
  type = object({
    environment  = string
    managed-by   = string
    triggered-by = string
    project      = string
    purpose      = string
    source-dir   = string
    source-repo  = string
  })
}

variable "scw_public_gateways" {
  type = map(object({
    name                 = string
    project_id           = string
    zone                 = string
    tags                 = map(string)
    reverse_domain       = string
    type                 = string
    upstream_dns_servers = list(string)
    bastion_enabled      = bool
    bastion_port         = number
    enable_smtp          = bool
  }))
}

variable "scw_vpcs" {
  type = map(object({
    name                       = string
    project_id                 = string
    tags                       = map(string)
    region                     = string
    subnet_cidr_block          = string
    gateway_enabled            = bool
    gateway_name               = string
    gateway_zone               = string
    gateway_subnet_cidr_block  = string
    gateway_push_default_route = bool
  }))
}

variable "scw_loadbalancers" {
  type = map(object({
    name               = string
    type               = string
    zone               = string
    tags               = map(string)
    project_id         = string
    attach_to_vpc      = bool
    vpc_to_attach_name = string
    vpc_id             = string
  }))
  description = "Variables required to deploy the loadbalancers"
}
