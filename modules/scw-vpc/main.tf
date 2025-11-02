resource "scaleway_vpc" "main" {
  name = var.vpc_name
  tags = var.tags
}

resource "scaleway_vpc_private_network" "main" {
  name   = "${var.vpc_name}-private-network"
  vpc_id = scaleway_vpc.main.id
  tags   = var.tags
}
