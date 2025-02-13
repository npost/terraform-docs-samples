# [START cloud_sql_postgres_instance_backup_location]
resource "google_sql_database_instance" "default" {
  name             = ""
  region           = "us-central1"
  database_version = "POSTGRES_12"
  settings {
    tier = "db-custom-2-7680"
    backup_configuration {
      enabled                        = true
      location                       = "us-central1"
    }
  }
  deletion_protection =  "true"
}
# [END cloud_sql_postgres_instance_backup_location]
