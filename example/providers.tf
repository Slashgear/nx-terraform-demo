# Terraform and Provider Configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "scaleway" {
  # Set your Scaleway credentials via environment variables:
  # export SCW_ACCESS_KEY="<your-access-key>"
  # export SCW_SECRET_KEY="<your-secret-key>"
  # export SCW_DEFAULT_PROJECT_ID="<your-project-id>"
  # export SCW_DEFAULT_REGION="fr-par"
  # export SCW_DEFAULT_ZONE="fr-par-1"
}

provider "kubernetes" {
  host  = module.k8s.cluster_endpoint
  token = module.k8s.cluster_token

  cluster_ca_certificate = base64decode(
    module.k8s.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = module.k8s.cluster_endpoint
    token = module.k8s.cluster_token

    cluster_ca_certificate = base64decode(
      module.k8s.cluster_ca_certificate
    )
  }
}
