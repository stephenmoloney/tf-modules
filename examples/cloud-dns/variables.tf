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

variable "az_scw_dns" {
  type = object({
    az_resource_group                   = string
    scw_loadbalancer_name_for_a_records = string
    dns_zones = object({
      azure = map(object({
        a_records = list(string)
      }))
      scw = map(object({
        redirect_using_azure_ns_records = string
      }))
    })
    tags = map(string)
  })
  description = "Variables required to configure dns via azure and scaleway"
}

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
