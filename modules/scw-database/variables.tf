variable "database_name" {
  description = "Name of the database instance"
  type        = string
}

variable "private_network_id" {
  description = "ID of the private network (from VPC module)"
  type        = string
}

variable "node_type" {
  description = "Type of database node"
  type        = string
  default     = "DB-DEV-S"
}

variable "engine" {
  description = "Database engine (PostgreSQL or MySQL)"
  type        = string
  default     = "PostgreSQL-15"
}

variable "high_availability" {
  description = "Enable high availability cluster"
  type        = bool
  default     = false
}

variable "enable_backup" {
  description = "Enable automatic backups"
  type        = bool
  default     = true
}

variable "admin_username" {
  description = "Admin username for the database"
  type        = string
  default     = "admin"
}

variable "initial_database_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "app"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = list(string)
  default     = []
}
