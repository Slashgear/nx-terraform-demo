output "lb_id" {
  description = "ID of the load balancer"
  value       = scaleway_lb.main.id
}

output "lb_ip_address" {
  description = "Public IP address of the load balancer"
  value       = scaleway_lb_ip.main.ip_address
}

output "lb_name" {
  description = "Name of the load balancer"
  value       = scaleway_lb.main.name
}

output "backend_id" {
  description = "ID of the backend"
  value       = scaleway_lb_backend.main.id
}

output "frontend_id" {
  description = "ID of the frontend"
  value       = scaleway_lb_frontend.main.id
}
