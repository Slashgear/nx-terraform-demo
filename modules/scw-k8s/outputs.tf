output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = scaleway_k8s_cluster.main.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = scaleway_k8s_cluster.main.name
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster"
  value       = scaleway_k8s_cluster.main.kubeconfig[0].config_file
  sensitive   = true
}

output "pool_id" {
  description = "ID of the node pool"
  value       = scaleway_k8s_pool.main.id
}

output "cluster_endpoint" {
  description = "Endpoint for the Kubernetes cluster"
  value       = scaleway_k8s_cluster.main.apiserver_url
}

output "cluster_token" {
  description = "Token for accessing the cluster"
  value       = scaleway_k8s_cluster.main.kubeconfig[0].token
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "CA certificate for the cluster (base64 encoded)"
  value       = scaleway_k8s_cluster.main.kubeconfig[0].cluster_ca_certificate
  sensitive   = true
}
