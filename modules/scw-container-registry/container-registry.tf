resource "scaleway_registry_namespace" "scw_container_registry" {
  name        = var.scw_container_registry.name
  description = var.scw_container_registry.description
  is_public   = (var.scw_container_registry.private != true)
  region      = var.scw_container_registry.region
  project_id  = var.scw_container_registry.project_id
}
