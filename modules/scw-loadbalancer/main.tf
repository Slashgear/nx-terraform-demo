terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

resource "scaleway_lb_ip" "main" {
  reverse = var.reverse_dns
}

resource "scaleway_lb" "main" {
  name  = var.lb_name
  ip_id = scaleway_lb_ip.main.id
  type  = var.lb_type
  tags  = var.tags

  private_network {
    private_network_id = var.private_network_id
  }
}

resource "scaleway_lb_backend" "main" {
  lb_id            = scaleway_lb.main.id
  name             = "${var.lb_name}-backend"
  forward_protocol = var.backend_protocol
  forward_port     = var.backend_port
}

resource "scaleway_lb_frontend" "main" {
  lb_id        = scaleway_lb.main.id
  name         = "${var.lb_name}-frontend"
  backend_id   = scaleway_lb_backend.main.id
  inbound_port = var.frontend_port

  dynamic "acl" {
    for_each = var.enable_ssl ? [1] : []
    content {
      name = "ssl-redirect"
      action {
        type = "redirect"
        redirect {
          type = "scheme"
          code = 301
        }
      }
      match {
        ip_subnet = ["0.0.0.0/0"]
      }
    }
  }
}

resource "scaleway_lb_certificate" "main" {
  count = var.enable_ssl && var.ssl_certificate_domain != "" ? 1 : 0

  lb_id = scaleway_lb.main.id
  name  = "${var.lb_name}-cert"

  letsencrypt {
    common_name = var.ssl_certificate_domain
  }
}
