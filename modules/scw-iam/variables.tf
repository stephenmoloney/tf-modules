variable "scw_iam" {
  type = object({
    name            = string
    description     = string
    organization_id = string
    project_id      = string
    tags            = list(string)
  })
  description = "Variables required to create the iam application with permissions set"
}

variable "scw_iam_policies" {
  type = map(object({
    name            = string
    description     = string
    project_names   = list(string)
    permission_sets = list(string)
  }))
  description = "Variables required to create the permissions for projects for an iam application"
}
