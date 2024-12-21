terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.oci_tenancy_ocid
  user_ocid        = var.oci_user_ocid
  fingerprint      = var.oci_fingerprint
  private_key_path = var.oci_private_key_path
  region           = var.oci_region
}

provider "mongodbatlas" {
  public_key  = var.mongodb_atlas_public_key
  private_key = var.mongodb_atlas_private_key
}

# MongoDB Atlas Cluster
resource "mongodbatlas_cluster" "mlflow" {
  project_id   = var.mongodb_atlas_project_id
  name         = var.mongodb_atlas_cluster_name
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

# MongoDB Atlas Database User
resource "mongodbatlas_database_user" "mlflow_user" {
  username    = var.mongodb_atlas_username
  password    = var.mongodb_atlas_password
  project_id  = var.mongodb_atlas_project_id
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

# Outputs
output "mlflow_server_public_ip" {
  value       = oci_core_instance.mlflow_server.public_ip
  description = "Public IP address of the MLflow Tracking Server."
}

output "mlflow_backend_store_uri" {
  value       = "mongodb+srv://${var.mongodb_atlas_username}:${var.mongodb_atlas_password}@${mongodbatlas_cluster.mlflow.connection_strings.standard_srv}/${var.mongodb_atlas_database_name}?retryWrites=true&w=majority"
  description = "URI for the MongoDB Atlas backend store."
  sensitive   = true
}