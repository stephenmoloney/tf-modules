variable "scw_ssh_key" {
  type = object({
    name       = string
    public_key = string
    project_id = string
    disabled   = bool
  })
  description = "SSH public key to enable access to Scaleway VMS"
}
