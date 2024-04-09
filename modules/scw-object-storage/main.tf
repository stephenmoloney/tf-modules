resource "scaleway_object_bucket" "scw_object_storage_no_destroy" {
  count = var.scw_object_storage_bucket.prevent_tf_destroy ? 1 : 0

  name       = var.scw_object_storage_bucket.name
  region     = var.scw_object_storage_bucket.region
  project_id = var.scw_object_storage_bucket.project_id
  tags       = var.scw_object_storage_bucket.tags

  force_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "scaleway_object_bucket_acl" "scw_object_storage_acl_no_destroy" {
  depends_on = [scaleway_object_bucket.scw_object_storage_no_destroy]
  count      = var.scw_object_storage_bucket.prevent_tf_destroy ? 1 : 0

  bucket = var.scw_object_storage_bucket.name
  acl    = var.scw_object_storage_bucket.acl
}

resource "scaleway_object_bucket" "scw_object_storage" {
  count = var.scw_object_storage_bucket.prevent_tf_destroy ? 0 : 1

  name       = var.scw_object_storage_bucket.name
  region     = var.scw_object_storage_bucket.region
  project_id = var.scw_object_storage_bucket.project_id
  tags       = var.scw_object_storage_bucket.tags

  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "scaleway_object_bucket_acl" "scw_object_storage_acl" {
  depends_on = [scaleway_object_bucket.scw_object_storage]
  count      = var.scw_object_storage_bucket.prevent_tf_destroy ? 0 : 1

  bucket = var.scw_object_storage_bucket.name
  acl    = var.scw_object_storage_bucket.acl
}
