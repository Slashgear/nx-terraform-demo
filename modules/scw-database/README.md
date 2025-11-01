# Scaleway Database Module

This module creates a Scaleway managed database (PostgreSQL or MySQL) instance.

## Dependencies

This module requires a VPC private network (from the `scw-vpc` module).

## Usage

```hcl
module "database" {
  source = "./modules/scw-database"

  database_name       = "my-db"
  private_network_id  = module.vpc.private_network_id
  admin_password      = var.db_password
  high_availability   = true
  tags                = ["production", "terraform"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| database_name | Name of the database instance | string | n/a | yes |
| private_network_id | ID of the private network (from VPC module) | string | n/a | yes |
| admin_password | Admin password for the database | string | n/a | yes |
| node_type | Type of database node | string | "DB-DEV-S" | no |
| engine | Database engine (PostgreSQL or MySQL) | string | "PostgreSQL-15" | no |
| high_availability | Enable high availability cluster | bool | false | no |
| enable_backup | Enable automatic backups | bool | true | no |
| admin_username | Admin username for the database | string | "admin" | no |
| initial_database_name | Name of the initial database to create | string | "app" | no |
| tags | Tags to apply to resources | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the database instance |
| endpoint_ip | Private IP address of the database |
| endpoint_port | Port of the database |
| database_name | Name of the created database |
| connection_string | Connection string for the database (sensitive) |
