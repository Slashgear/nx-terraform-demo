# Generate a secure random password for the database admin user
resource "random_password" "db_password" {
  length  = 32
  special = true
  # Exclude characters that might cause issues in connection strings
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "scaleway_rdb_instance" "main" {
  name           = var.database_name
  node_type      = var.node_type
  engine         = var.engine
  is_ha_cluster  = var.high_availability
  disable_backup = !var.enable_backup
  tags           = var.tags

  user_name = var.admin_username
  password  = random_password.db_password.result

  private_network {
    pn_id = var.private_network_id
  }
}

resource "scaleway_rdb_database" "main" {
  instance_id = scaleway_rdb_instance.main.id
  name        = var.initial_database_name
}
