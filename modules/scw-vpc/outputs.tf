output "vpc_id" {
  description = "ID of the VPC"
  value       = scaleway_vpc.main.id
}

output "private_network_id" {
  description = "ID of the private network"
  value       = scaleway_vpc_private_network.main.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = scaleway_vpc.main.name
}
