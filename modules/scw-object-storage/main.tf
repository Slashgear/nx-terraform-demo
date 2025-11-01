terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

resource "scaleway_object_bucket" "main" {
  name = var.bucket_name
  tags = var.tags

  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
}

resource "scaleway_object_bucket_acl" "main" {
  bucket = scaleway_object_bucket.main.name
  acl    = var.acl
}

resource "scaleway_object_bucket_lifecycle_rule" "main" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = scaleway_object_bucket.main.name

  rule {
    id      = "expire-old-versions"
    enabled = true

    expiration {
      days = var.lifecycle_days
    }
  }
}
