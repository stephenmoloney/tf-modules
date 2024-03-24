resource "scaleway_iam_application" "scw_application" {
  name            = var.scw_iam.name
  description     = var.scw_iam.description
  tags            = var.scw_iam.tags
  organization_id = var.scw_iam.organization_id
}

resource "scaleway_iam_api_key" "scw_api_key" {
  application_id     = scaleway_iam_application.scw_application.id
  description        = "API key for ${var.scw_iam.name}"
  default_project_id = var.scw_iam.project_id
}

// Scaleway SSH Keys
module "scw_iam_policies" {
  depends_on = [scaleway_iam_application.scw_application, scaleway_iam_api_key.scw_api_key]
  source     = "../scw-iam-policy"

  for_each = var.scw_iam_policies
  scw_iam_policy = {
    name            = each.value.name
    description     = each.value.description
    application_id  = scaleway_iam_application.scw_application.id
    organization_id = var.scw_iam.organization_id
    project_names   = each.value.project_names
    permission_sets = each.value.permission_sets
  }
}
