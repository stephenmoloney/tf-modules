output "scw_lb_id" {
  value = (
    var.scw_loadbalancer.attach_to_vpc ?
    one(scaleway_lb.scw_loadbalancer[*].id) :
    one(scaleway_lb.scw_loadbalancer_public_only[*].id)
  )
  description = "The id of the loadbalancer"
}

output "scw_lb_ip" {
  value = (
    var.scw_loadbalancer.attach_to_vpc ?
    one(scaleway_lb.scw_loadbalancer[*].ip_address) :
    one(scaleway_lb.scw_loadbalancer_public_only[*].ip_address)
  )
  description = "The ip address of the loadbalancer"
}
