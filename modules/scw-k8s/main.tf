terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

resource "scaleway_k8s_cluster" "main" {
  name    = var.cluster_name
  version = var.kubernetes_version
  cni     = "cilium"
  tags    = var.tags

  private_network_id = var.private_network_id

  delete_additional_resources = true
}

resource "scaleway_k8s_pool" "main" {
  cluster_id = scaleway_k8s_cluster.main.id
  name       = "${var.cluster_name}-pool"
  node_type  = var.node_type
  size       = var.node_count

  min_size = var.min_nodes
  max_size = var.max_nodes

  autoscaling  = var.enable_autoscaling
  autohealing  = true
  tags         = var.tags
}
