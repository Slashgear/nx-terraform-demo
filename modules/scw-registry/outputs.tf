output "registry_id" {
  description = "ID of the registry namespace"
  value       = scaleway_registry_namespace.main.id
}

output "registry_name" {
  description = "Name of the registry namespace"
  value       = scaleway_registry_namespace.main.name
}

output "registry_endpoint" {
  description = "Endpoint of the registry"
  value       = scaleway_registry_namespace.main.endpoint
}

output "registry_url" {
  description = "Full URL of the registry"
  value       = "rg.${scaleway_registry_namespace.main.region}.scw.cloud/${scaleway_registry_namespace.main.name}"
}
