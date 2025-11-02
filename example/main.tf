# Example usage of the Terraform modules
# This shows how to use all seven modules together

# Create VPC infrastructure
module "vpc" {
  source = "../modules/scw-vpc"

  vpc_name = "demo-vpc"
  tags     = ["demo", "nx-terraform", "production"]
}

# Create Kubernetes cluster in the VPC
module "k8s" {
  source = "../modules/scw-k8s"

  cluster_name       = "demo-k8s-cluster"
  private_network_id = module.vpc.private_network_id
  kubernetes_version = "1.28"

  node_type          = "DEV1-M"
  node_count         = 3
  min_nodes          = 2
  max_nodes          = 5
  enable_autoscaling = true

  tags = ["demo", "nx-terraform", "kubernetes"]
}

# Create database in the VPC
module "database" {
  source = "../modules/scw-database"

  database_name       = "demo-db"
  private_network_id  = module.vpc.private_network_id

  engine             = "PostgreSQL-15"
  node_type          = "DB-DEV-S"
  high_availability  = false
  enable_backup      = true

  admin_username         = "dbadmin"
  initial_database_name  = "app"

  tags = ["demo", "nx-terraform", "database"]
}

# Create Object Storage bucket
module "storage" {
  source = "../modules/scw-object-storage"

  bucket_name       = "demo-app-storage"
  enable_versioning = true
  enable_lifecycle  = true
  lifecycle_days    = 90
  acl               = "private"

  tags = {
    environment = "production"
    managed_by  = "terraform"
  }
}

# Create Container Registry
module "registry" {
  source = "../modules/scw-registry"

  registry_name      = "demo-app-registry"
  description        = "Container registry for demo application"
  is_public          = false
  create_push_policy = false
}

# Create Load Balancer
module "loadbalancer" {
  source = "../modules/scw-loadbalancer"

  lb_name            = "demo-lb"
  private_network_id = module.vpc.private_network_id
  lb_type            = "LB-S"

  backend_protocol = "http"
  backend_port     = 80
  frontend_port    = 80

  # Backend IPs would come from K8s nodes in production
  backend_ips = []

  enable_ssl = false

  tags = ["demo", "nx-terraform", "loadbalancer"]

  depends_on = [module.k8s]
}

# Create Monitoring Stack
module "monitoring" {
  source = "../modules/scw-monitoring"

  monitoring_name       = "demo-monitoring"
  project_id            = var.scaleway_project_id
  install_grafana_agent = true
  namespace             = "monitoring"
  environment           = "production"
  retention_days        = 30

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.k8s]
}

# Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "k8s_cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = module.k8s.cluster_id
}

output "database_endpoint" {
  description = "Database connection endpoint"
  value       = "${module.database.endpoint_ip}:${module.database.endpoint_port}"
}

output "database_password" {
  description = "Auto-generated database admin password (retrieve with: terraform output -raw database_password)"
  value       = module.database.admin_password
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubeconfig for accessing the cluster"
  value       = module.k8s.kubeconfig
  sensitive   = true
}

output "storage_bucket_endpoint" {
  description = "Object storage bucket endpoint"
  value       = module.storage.bucket_endpoint
}

output "registry_url" {
  description = "Container registry URL"
  value       = module.registry.registry_url
}

output "loadbalancer_ip" {
  description = "Load balancer public IP"
  value       = module.loadbalancer.lb_ip_address
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = module.monitoring.grafana_url
}
