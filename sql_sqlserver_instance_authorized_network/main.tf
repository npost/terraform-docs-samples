# [START cloud_sql_sqlserver_instance_authorized_network]
resource "google_sql_database_instance" "default" {
  name             = "myinstance"
  region           = "us-central1"
  database_version = "SQLSERVER_2017_STANDARD"
  root_password = "INSERT-PASSWORD-HERE"
  settings {
    tier = "db-custom-2-7680"
    ip_configuration {
      authorized_networks {
        name = "Network Name"
        value = "192.0.2.0/24"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
    }
  }
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_authorized_network]
