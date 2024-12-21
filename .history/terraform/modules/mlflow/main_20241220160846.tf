# MongoDB Atlas Cluster
resource "mongodbatlas_cluster" "mlflow" {
  project_id                = var.mongodb_atlas_project_id
  name                      = var.mongodb_atlas_cluster_name
  provider_name             = "AWS"
  provider_instance_size_name = "M0"

  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "US_EAST_1"
      electable_nodes = 3
      priority        = 7
    }
  }
}

# MongoDB Atlas Database User
resource "mongodbatlas_database_user" "mlflow_user" {
  username          = var.mongodb_atlas_username
  password          = var.mongodb_atlas_password
  project_id        = var.mongodb_atlas_project_id
  auth_database_name = var.mongodb_atlas_database_name

  roles {
    role_name     = "readWrite"
    database_name = var.mongodb_atlas_database_name
  }
}

# OCI Compute Instance for MLflow Tracking Server
resource "oci_core_instance" "mlflow_server" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.oci_compartment_id
  shape               = "VM.Standard.A1.Flex"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.oci_subnet_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(templatefile("${path.module}/scripts/mlflow_setup.sh", {
      backend_store_uri = "mongodb+srv://${var.mongodb_atlas_username}:${var.mongodb_atlas_password}@${mongodbatlas_cluster.mlflow.connection_strings.standard_srv}/${var.mongodb_atlas_database_name}?retryWrites=true&w=majority"
    }))
  }

  shape_config {
    ocpus = 1
    memory_in_gbs = 6
  }
}