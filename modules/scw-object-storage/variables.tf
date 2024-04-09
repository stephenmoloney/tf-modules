variable "scw_object_storage_bucket" {
  type = object({
    acl                = string
    name               = string
    project_id         = string
    region             = string
    tags               = map(string)
    prevent_tf_destroy = bool
  })
}
