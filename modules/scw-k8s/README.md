# Scaleway Kubernetes Module

This module creates a Scaleway Kubernetes (Kapsule) cluster with a node pool.

## Dependencies

This module requires a VPC private network (from the `scw-vpc` module).

## Usage

```hcl
module "k8s" {
  source = "./modules/scw-k8s"

  cluster_name       = "my-k8s-cluster"
  private_network_id = module.vpc.private_network_id
  node_count         = 3
  tags              = ["production", "terraform"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the Kubernetes cluster | string | n/a | yes |
| private_network_id | ID of the private network (from VPC module) | string | n/a | yes |
| kubernetes_version | Kubernetes version | string | "1.28" | no |
| node_type | Type of nodes in the pool | string | "DEV1-M" | no |
| node_count | Number of nodes in the pool | number | 3 | no |
| min_nodes | Minimum number of nodes for autoscaling | number | 1 | no |
| max_nodes | Maximum number of nodes for autoscaling | number | 5 | no |
| enable_autoscaling | Enable autoscaling | bool | true | no |
| tags | Tags to apply to resources | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of the Kubernetes cluster |
| cluster_name | Name of the Kubernetes cluster |
| kubeconfig | Kubeconfig for the cluster (sensitive) |
| pool_id | ID of the node pool |
