data "scaleway_vpc_private_network" "scw_k8s_vnet" {
  name = var.scw_k8s_private_network.name
}

resource "scaleway_k8s_cluster" "scw_k8s_cluster" {
  name        = var.scw_k8s_cluster.name
  type        = "kapsule"
  description = var.scw_k8s_cluster.description
  version     = var.scw_k8s_cluster.version
  cni         = var.scw_k8s_cluster.cni
  tags        = var.scw_k8s_cluster.tags

  autoscaler_config {
    disable_scale_down               = var.scw_k8s_autoscaler_config.disable_scale_down
    scale_down_delay_after_add       = var.scw_k8s_autoscaler_config.scale_down_delay_after_add
    scale_down_unneeded_time         = var.scw_k8s_autoscaler_config.scale_down_unneeded_time
    estimator                        = var.scw_k8s_autoscaler_config.estimator
    expander                         = var.scw_k8s_autoscaler_config.expander
    ignore_daemonsets_utilization    = var.scw_k8s_autoscaler_config.ignore_daemonsets_utilization
    balance_similar_node_groups      = var.scw_k8s_autoscaler_config.balance_similar_node_groups
    expendable_pods_priority_cutoff  = var.scw_k8s_autoscaler_config.expendable_pods_priority_cutoff
    scale_down_utilization_threshold = var.scw_k8s_autoscaler_config.scale_down_utilization_threshold
    max_graceful_termination_sec     = var.scw_k8s_autoscaler_config.max_graceful_termination_sec
  }

  auto_upgrade {
    enable                        = var.scw_k8s_auto_upgrade.enable
    maintenance_window_start_hour = var.scw_k8s_auto_upgrade.maintenance_window_start_hour
    maintenance_window_day        = var.scw_k8s_auto_upgrade.maintenance_window_day
  }

  feature_gates       = var.scw_k8s_cluster.feature_gates
  admission_plugins   = var.scw_k8s_cluster.admission_plugins
  apiserver_cert_sans = var.scw_k8s_cluster.apiserver_cert_sans

  open_id_connect_config {
    issuer_url      = var.scw_k8s_openid_config.issuer_url
    client_id       = var.scw_k8s_openid_config.client_id
    username_claim  = var.scw_k8s_openid_config.username_claim
    username_prefix = var.scw_k8s_openid_config.username_prefix
    groups_claim    = var.scw_k8s_openid_config.groups_claim
    groups_prefix   = var.scw_k8s_openid_config.groups_prefix
    required_claim  = var.scw_k8s_openid_config.required_claim
  }

  delete_additional_resources = var.scw_k8s_cluster.delete_additional_resources
  region                      = var.scw_k8s_region
  project_id                  = var.scw_k8s_project_id

  private_network_id = var.scw_k8s_private_network.enabled ? data.scaleway_vpc_private_network.scw_k8s_vnet.id : null
}

resource "scaleway_instance_placement_group" "scw_k8s_placement_groups" {
  for_each = {
    for pool in var.scw_k8s_pools : pool.placement_group.name => pool
  }

  name        = each.value.placement_group.name
  policy_type = each.value.placement_group.policy_type
  policy_mode = each.value.placement_group.policy_mode
  zone        = each.value.zone
  project_id  = var.scw_k8s_project_id
}

resource "scaleway_k8s_pool" "scw_k8s_cluster_pools" {
  depends_on = [scaleway_k8s_cluster.scw_k8s_cluster, scaleway_instance_placement_group.scw_k8s_placement_groups]

  cluster_id = scaleway_k8s_cluster.scw_k8s_cluster.id

  for_each = {
    for pool in var.scw_k8s_pools : pool.name => pool
  }

  name              = each.value.name
  node_type         = each.value.node_type
  size              = each.value.size
  min_size          = each.value.min_size
  max_size          = each.value.max_size
  tags              = each.value.tags
  autoscaling       = each.value.autoscaling
  autohealing       = each.value.autohealing
  container_runtime = each.value.container_runtime
  kubelet_args      = each.value.kubelet_args
  upgrade_policy {
    max_surge       = each.value.upgrade_policy.max_surge
    max_unavailable = each.value.upgrade_policy.max_unavailable
  }
  public_ip_disabled     = each.value.public_ip_disabled
  root_volume_type       = each.value.root_volume_type
  root_volume_size_in_gb = each.value.root_volume_size_in_gb
  zone                   = each.value.zone
  region                 = var.scw_k8s_region
  wait_for_pool_ready    = each.value.wait_for_pool_ready
  placement_group_id     = scaleway_instance_placement_group.scw_k8s_placement_groups[each.value.placement_group.name].id
}

resource "local_file" "scw_k8s_kubeconfig" {
  depends_on = [
    scaleway_k8s_cluster.scw_k8s_cluster,
    scaleway_k8s_pool.scw_k8s_cluster_pools
  ]
  content              = scaleway_k8s_cluster.scw_k8s_cluster.kubeconfig[0].config_file
  filename             = pathexpand("~/.kube/${var.scw_k8s_cluster.name}.conf")
  file_permission      = "0600"
  directory_permission = "0755"
}
