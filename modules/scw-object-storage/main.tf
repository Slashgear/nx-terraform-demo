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
