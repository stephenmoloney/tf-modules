variable "scw_k8s_project_id" {
  type        = string
  description = "The scaleway project id"
}

variable "scw_k8s_region" {
  type        = string
  description = "The region to place the cluster"
}

variable "scw_k8s_cluster" {
  type = object({
    name                        = string
    description                 = string
    version                     = string
    cni                         = string
    tags                        = list(string)
    feature_gates               = list(string)
    admission_plugins           = list(string)
    apiserver_cert_sans         = list(string)
    delete_additional_resources = bool
  })
  description = "Variables required to deploy the k8s cluster"
}

variable "scw_k8s_private_network" {
  type = object({
    name    = string
    enabled = bool
  })
  description = "The private network for the cluster"
}

variable "scw_k8s_autoscaler_config" {
  type = object({
    disable_scale_down               = bool
    scale_down_delay_after_add       = string
    scale_down_unneeded_time         = string
    estimator                        = string
    expander                         = string
    ignore_daemonsets_utilization    = bool
    balance_similar_node_groups      = bool
    expendable_pods_priority_cutoff  = number
    scale_down_utilization_threshold = string
    max_graceful_termination_sec     = string
  })
  description = "The autoscaler config for the cluster"
}

variable "scw_k8s_auto_upgrade" {
  type = object({
    enable                        = bool
    maintenance_window_day        = string
    maintenance_window_start_hour = string
  })
  description = "The auto upgrade config for the cluster"
}

variable "scw_k8s_openid_config" {
  type = object({
    issuer_url      = string
    client_id       = string
    username_claim  = string
    username_prefix = string
    groups_claim    = list(string)
    groups_prefix   = string
    required_claim  = list(string)
  })
  description = "The openid config for the cluster"
}

variable "scw_k8s_pools" {
  type = map(object({
    name               = string
    node_type          = string
    size               = number
    min_size           = number
    max_size           = number
    tags               = list(string)
    autoscaling        = bool
    autohealing        = bool
    container_runtime  = string
    kubelet_args       = map(string)
    public_ip_disabled = bool
    placement_group = object({
      name        = string
      policy_type = string
      policy_mode = string
    })
    root_volume_type       = string
    root_volume_size_in_gb = number
    upgrade_policy = object({
      max_surge       = number
      max_unavailable = number
    })
    zone                = string
    wait_for_pool_ready = bool
  }))
  description = "The pools for the cluster"
}
