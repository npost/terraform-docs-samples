# [START vpc_serverless_connector_enable_api]
resource "google_project_service" "vpcaccess_api" {
  service  = "vpcaccess.googleapis.com"
  provider = google-beta
  disable_on_destroy = false
}
# [END vpc_serverless_connector_enable_api]

# [START vpc_serverless_connector]
# VPC
resource "google_compute_network" "default" {
  name                    = "cloudrun-network"
  provider                = google-beta
  auto_create_subnetworks = false
}

# VPC access connector
resource "google_vpc_access_connector" "connector" {
  name          = "vpcconn"
  provider      = google-beta
  region        = "us-west1"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.default.name
  depends_on    = [google_project_service.vpcaccess_api]
}

# Cloud Router
resource "google_compute_router" "router" {
  name     = "router"
  provider = google-beta
  region   = "us-west1"
  network  = google_compute_network.default.id
}

# NAT configuration
resource "google_compute_router_nat" "router_nat" {
  name                               = "nat"
  provider                           = google-beta
  region                             = "us-west1"
  router                             = google_compute_router.router.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}
# [END vpc_serverless_connector]

# [START cloudrun_vpc_serverless_connector]
# Cloud Run service
resource "google_cloud_run_service" "gcr_service" {
  name     = "mygcrservice"
  provider = google-beta
  location = "us-west1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        resources {
          limits = {
            cpu = "1000m"
            memory = "512M"
          }
        }
      }
      # the service uses this SA to call other Google Cloud APIs
      # service_account_name = myservice_runtime_sa
    }

    metadata {
      annotations = {
        # Limit scale up to prevent any cost blow outs!
        "autoscaling.knative.dev/maxScale" = "5"
        # Use the VPC Connector
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.name
        # all egress from the service should go through the VPC Connector
        "run.googleapis.com/vpc-access-egress" = "all"
      }
    }
  }
  autogenerate_revision_name = true
}
# [END cloudrun_vpc_serverless_connector]
