data "scaleway_account_project" "scw_projects" {
  count = length(var.scw_iam_policy.project_names)

  organization_id = var.scw_iam_policy.organization_id
  name            = element(var.scw_iam_policy.project_names, count.index)
}

resource "scaleway_iam_policy" "scw_policy" {
  name            = var.scw_iam_policy.name
  description     = var.scw_iam_policy.description
  application_id  = var.scw_iam_policy.application_id
  organization_id = var.scw_iam_policy.organization_id

  rule {
    project_ids          = data.scaleway_account_project.scw_projects.*.id
    permission_set_names = var.scw_iam_policy.permission_sets
  }
}

