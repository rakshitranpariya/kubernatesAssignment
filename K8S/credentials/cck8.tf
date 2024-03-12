provider "google" {
  credentials = file("./cloudcompk8-adf57e7220e1.json")
  project     = "cloudcompk8"
  region      = "us-central1"
}
 
resource "google_container_cluster" "my_cluster" {
  name               = "my-gke-cluster-1"
  location           = "us-central1"
  initial_node_count = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  
  remove_default_node_pool = false  # Set this to false to keep the default node pool
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"  # Replace with your desired node pool name
  location   = "us-central1"   # Replace with the appropriate location
  cluster    = google_container_cluster.my_cluster.name
  project    = "cloudcompk8"    # Replace with your GCP project ID
  
  node_config {
    machine_type = "e2-micro"
    image_type   = "COS_CONTAINERD"
    
    taint {
      key    = "application"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }
}
