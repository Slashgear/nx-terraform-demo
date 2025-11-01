variable "monitoring_name" {
  description = "Name for monitoring resources"
  type        = string
}

variable "project_id" {
  description = "Scaleway project ID"
  type        = string
}

variable "install_grafana_agent" {
  description = "Install Grafana Agent for metrics collection"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Kubernetes namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "production"
}

variable "grafana_agent_version" {
  description = "Version of Grafana Agent Helm chart"
  type        = string
  default     = "0.40.0"
}

variable "log_level" {
  description = "Log level for Grafana Agent"
  type        = string
  default     = "info"
}

variable "retention_days" {
  description = "Data retention in days"
  type        = number
  default     = 30
}
