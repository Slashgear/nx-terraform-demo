resource "scaleway_rdb_instance" "main" {
  name           = var.database_name
  node_type      = var.node_type
  engine         = var.engine
  is_ha_cluster  = var.high_availability
  disable_backup = !var.enable_backup
  tags           = var.tags

  user_name = var.admin_username
  password  = var.admin_password

  private_network {
    pn_id = var.private_network_id
  }
}

resource "scaleway_rdb_database" "main" {
  instance_id = scaleway_rdb_instance.main.id
  name        = var.initial_database_name
}
