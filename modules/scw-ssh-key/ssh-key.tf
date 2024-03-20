resource "scaleway_iam_ssh_key" "scw_ssh_key" {
  name       = var.scw_ssh_key.name
  public_key = var.scw_ssh_key.public_key
  project_id = var.scw_ssh_key.project_id
  disabled   = var.scw_ssh_key.disabled
}
