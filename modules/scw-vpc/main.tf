terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

resource "scaleway_vpc" "main" {
  name = var.vpc_name
  tags = var.tags
}

resource "scaleway_vpc_private_network" "main" {
  name   = "${var.vpc_name}-private-network"
  vpc_id = scaleway_vpc.main.id
  tags   = var.tags
}
