output "instance_id" {
  description = "ID of the database instance"
  value       = scaleway_rdb_instance.main.id
}

output "endpoint_ip" {
  description = "Private IP address of the database"
  value       = scaleway_rdb_instance.main.endpoint_ip
}

output "endpoint_port" {
  description = "Port of the database"
  value       = scaleway_rdb_instance.main.endpoint_port
}

output "database_name" {
  description = "Name of the created database"
  value       = scaleway_rdb_database.main.name
}

output "admin_password" {
  description = "Auto-generated admin password for the database (store securely!)"
  value       = random_password.db_password.result
  sensitive   = true
}

output "connection_string" {
  description = "Connection string for the database (without password)"
  value       = "postgresql://${var.admin_username}@${scaleway_rdb_instance.main.endpoint_ip}:${scaleway_rdb_instance.main.endpoint_port}/${scaleway_rdb_database.main.name}"
  sensitive   = true
}
