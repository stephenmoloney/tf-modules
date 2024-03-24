variable "scw_iam_policy" {
  type = object({
    application_id  = string
    organization_id = string
    name            = string
    description     = string
    project_names   = list(string)
    permission_sets = list(string)
  })
  description = "Iam policy defined as given projects with given permissions"
}
