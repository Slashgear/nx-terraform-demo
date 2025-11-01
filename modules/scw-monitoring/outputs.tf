output "cockpit_id" {
  description = "ID of the Scaleway Cockpit"
  value       = scaleway_cockpit.main.id
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = scaleway_cockpit.main.endpoints[0].grafana_url
}

output "metrics_url" {
  description = "Prometheus metrics endpoint URL"
  value       = scaleway_cockpit.main.endpoints[0].metrics_url
}

output "logs_url" {
  description = "Loki logs endpoint URL"
  value       = scaleway_cockpit.main.endpoints[0].logs_url
}

output "traces_url" {
  description = "Tempo traces endpoint URL"
  value       = scaleway_cockpit.main.endpoints[0].traces_url
}

output "token_id" {
  description = "ID of the Cockpit token"
  value       = scaleway_cockpit_token.main.id
}

output "token_secret" {
  description = "Secret key for the Cockpit token"
  value       = scaleway_cockpit_token.main.secret_key
  sensitive   = true
}
