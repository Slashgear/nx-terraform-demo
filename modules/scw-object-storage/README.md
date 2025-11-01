# Scaleway Object Storage Module

This module creates a Scaleway Object Storage bucket (S3-compatible).

## Features

- S3-compatible bucket creation
- Optional versioning
- Configurable ACL
- Lifecycle rules for automatic expiration

## Usage

```hcl
module "storage" {
  source = "./modules/scw-object-storage"

  bucket_name        = "my-app-storage"
  enable_versioning  = true
  enable_lifecycle   = true
  lifecycle_days     = 90
  acl                = "private"
  tags               = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | Name of the S3-compatible bucket | string | n/a | yes |
| acl | ACL for the bucket | string | "private" | no |
| enable_versioning | Enable object versioning | bool | false | no |
| enable_lifecycle | Enable lifecycle rules | bool | false | no |
| lifecycle_days | Number of days before objects expire | number | 90 | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | ID of the bucket |
| bucket_name | Name of the bucket |
| bucket_endpoint | Endpoint URL of the bucket |
| bucket_region | Region of the bucket |
