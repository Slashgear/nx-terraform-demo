variable "bucket_name" {
  description = "Name of the S3-compatible bucket"
  type        = string
}

variable "acl" {
  description = "ACL for the bucket (private, public-read, public-read-write)"
  type        = string
  default     = "private"
}

variable "enable_versioning" {
  description = "Enable object versioning"
  type        = bool
  default     = false
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rules"
  type        = bool
  default     = false
}

variable "lifecycle_days" {
  description = "Number of days before objects expire"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
