resource "oci_core_instance" "mlflow_server" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.A1.Flex"

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  freeform_tags = var.tags
}
resource "mongodbatlas_cluster" "mlflow" {
  project_id   = var.mongodb_atlas_project_id
  name         = "mlflow-cluster"
  provider_name = "AWS"

  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "US_EAST_1"
      electable_nodes = 3
      priority        = 7
    }
  }
}

resource "mongodbatlas_database_user" "mlflow_user" {
  username    = var.mongodb_atlas_username
  password    = var.mongodb_atlas_password
  project_id  = var.mongodb_atlas_project_id
  roles {
    role_name     = "readWrite"
    database_name = var.mongodb_atlas_database_name
  }
}