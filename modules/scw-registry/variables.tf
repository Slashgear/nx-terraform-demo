variable "registry_name" {
  description = "Name of the container registry namespace"
  type        = string
}

variable "description" {
  description = "Description of the registry"
  type        = string
  default     = "Container registry managed by Terraform"
}

variable "is_public" {
  description = "Whether the registry is publicly accessible"
  type        = bool
  default     = false
}

variable "create_push_policy" {
  description = "Create IAM policy for push access"
  type        = bool
  default     = false
}

variable "application_id" {
  description = "Create Application ID for IAM policy"
  type        = string
  default     = ""
}
