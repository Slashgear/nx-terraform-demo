variable "db_password" {
  description = "Admin password for the database"
  type        = string
  sensitive   = true
}

variable "scaleway_project_id" {
  description = "Scaleway project ID"
  type        = string
}
