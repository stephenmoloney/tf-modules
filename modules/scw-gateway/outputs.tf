output "scw_gateway_id" {
  value       = scaleway_vpc_public_gateway.scw_public_gateway.id
  description = "The id of the scaleway public gateway"
}

output "scw_gateway_ip_address" {
  value       = scaleway_vpc_public_gateway_ip.scw_public_gateway_ip.address
  description = "The ip address of the scaleway public gateway"
}

output "scw_gateway_ip_address_id" {
  value       = scaleway_vpc_public_gateway_ip.scw_public_gateway_ip.id
  description = "The id of the scaleway public gateway ip address"
}
