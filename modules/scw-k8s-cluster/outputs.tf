output "scw_k8s_cluster_worker_node_public_ips" {
  value = flatten([
    for pool in scaleway_k8s_pool.scw_k8s_cluster_pools : [
      for node in pool.nodes : node.public_ip
    ]
  ])
}
