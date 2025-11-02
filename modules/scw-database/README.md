# Scaleway Database Module

This module creates a Scaleway managed database (PostgreSQL or MySQL) instance.

## Dependencies

This module requires a VPC private network (from the `scw-vpc` module).

## Security

This module automatically generates a secure random password for the database admin user. The password is:
- 32 characters long with special characters
- Stored securely in the Terraform state
- Available as a sensitive output for retrieval when needed

To retrieve the password after deployment:
```bash
terraform output -raw database_password
```

## Usage

```hcl
module "database" {
  source = "./modules/scw-database"

  database_name       = "my-db"
  private_network_id  = module.vpc.private_network_id
  high_availability   = true
  tags                = ["production", "terraform"]
}

# Retrieve the auto-generated password
output "db_password" {
  value     = module.database.admin_password
  sensitive = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| database_name | Name of the database instance | string | n/a | yes |
| private_network_id | ID of the private network (from VPC module) | string | n/a | yes |
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
| admin_password | Auto-generated admin password (sensitive) |
| connection_string | Connection string for the database (sensitive) |
