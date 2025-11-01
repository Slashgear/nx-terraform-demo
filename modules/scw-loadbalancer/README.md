# Scaleway Load Balancer Module

This module creates a Scaleway Load Balancer with frontend, backend, and optional SSL support.

## Dependencies

This module requires:
- VPC private network (from the `scw-vpc` module)
- Backend servers (typically from `scw-k8s` module)

## Features

- Layer 4/7 load balancing
- Health checks
- SSL/TLS with Let's Encrypt
- Private network integration
- Backend server management

## Usage

```hcl
module "loadbalancer" {
  source = "./modules/scw-loadbalancer"

  lb_name            = "my-lb"
  private_network_id = module.vpc.private_network_id
  lb_type            = "LB-S"

  backend_protocol = "http"
  backend_port     = 80
  frontend_port    = 443

  backend_ips = ["10.0.0.10", "10.0.0.11", "10.0.0.12"]

  enable_ssl              = true
  ssl_certificate_domain  = "example.com"

  tags = ["production", "terraform"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| lb_name | Name of the load balancer | string | n/a | yes |
| private_network_id | ID of the private network (from VPC module) | string | n/a | yes |
| lb_type | Type of load balancer | string | "LB-S" | no |
| backend_protocol | Protocol for backend (tcp, http) | string | "http" | no |
| backend_port | Port for backend servers | number | 80 | no |
| frontend_port | Port for frontend (inbound) | number | 80 | no |
| backend_ips | List of backend server IPs | list(string) | [] | no |
| enable_ssl | Enable SSL/TLS with Let's Encrypt | bool | false | no |
| ssl_certificate_domain | Domain for SSL certificate | string | "" | no |
| reverse_dns | Reverse DNS for the load balancer IP | string | "" | no |
| tags | Tags to apply to resources | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| lb_id | ID of the load balancer |
| lb_ip_address | Public IP address of the load balancer |
| lb_name | Name of the load balancer |
| backend_id | ID of the backend |
| frontend_id | ID of the frontend |
