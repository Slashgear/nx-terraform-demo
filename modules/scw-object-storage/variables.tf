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
  description = "Enable object versioning, may increase long-term storage base cost"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
