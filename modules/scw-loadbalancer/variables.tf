variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "private_network_id" {
  description = "ID of the private network (from VPC module)"
  type        = string
}

variable "lb_type" {
  description = "Type of load balancer"
  type        = string
  default     = "LB-S"
}

variable "backend_protocol" {
  description = "Protocol for backend (tcp, http)"
  type        = string
  default     = "http"
}

variable "backend_port" {
  description = "Port for backend servers"
  type        = number
  default     = 80
}

variable "frontend_port" {
  description = "Port for frontend (inbound)"
  type        = number
  default     = 80
}

variable "enable_ssl" {
  description = "Enable SSL/TLS with Let's Encrypt"
  type        = bool
  default     = false
}

variable "ssl_certificate_domain" {
  description = "Domain for SSL certificate"
  type        = string
  default     = ""
}

variable "reverse_dns" {
  description = "Reverse DNS for the load balancer IP"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = list(string)
  default     = []
}
