terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

resource "scaleway_registry_namespace" "main" {
  name        = var.registry_name
  description = var.description
  is_public   = var.is_public
}

resource "scaleway_iam_policy" "registry_push" {
  count = var.create_push_policy ? 1 : 0

  name        = "${var.registry_name}-push-policy"
  description = "Policy to allow push to ${var.registry_name} registry"

  rule {
    permission_set_names = ["ContainerRegistryFullAccess"]
  }
}
