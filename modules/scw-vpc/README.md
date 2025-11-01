# Scaleway VPC Module

This module creates a Scaleway VPC with a private network.

## Usage

```hcl
module "vpc" {
  source = "./modules/scw-vpc"

  vpc_name = "my-vpc"
  tags     = ["production", "terraform"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_name | Name of the VPC | string | n/a | yes |
| tags | Tags to apply to resources | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| private_network_id | ID of the private network |
| vpc_name | Name of the VPC |
