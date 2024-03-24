output "iam_application_access_key" {
  value       = scaleway_iam_api_key.scw_api_key.access_key
  description = "The id of the iam application which is also the access key to the application"
  sensitive   = true
}

output "iam_application_secret_key" {
  value       = scaleway_iam_api_key.scw_api_key.secret_key
  description = "The secret key of the iam application"
  sensitive   = true
}
