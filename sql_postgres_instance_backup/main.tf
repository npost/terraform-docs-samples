# [START cloud_sql_postgres_instance_backup]
resource "google_sql_database_instance" "instance" {
  name             = "postgres-instance-backup"
  region           = "us-central1"
  database_version = "POSTGRES_12"
  settings {
    tier = "db-custom-2-7680"
    backup_configuration {
      enabled                        = true
      start_time                     = "20:55"
    }
  }
  deletion_protection =  "true"
}
# [END cloud_sql_postgres_instance_backup]
