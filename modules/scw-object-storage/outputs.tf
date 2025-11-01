output "bucket_id" {
  description = "ID of the bucket"
  value       = scaleway_object_bucket.main.id
}

output "bucket_name" {
  description = "Name of the bucket"
  value       = scaleway_object_bucket.main.name
}

output "bucket_endpoint" {
  description = "Endpoint URL of the bucket"
  value       = scaleway_object_bucket.main.endpoint
}

output "bucket_region" {
  description = "Region of the bucket"
  value       = scaleway_object_bucket.main.region
}
