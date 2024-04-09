variable "scw_container_registry" {
  type = object({
    name        = string
    description = string
    project_id  = string
    private     = bool
    region      = string
  })
}
