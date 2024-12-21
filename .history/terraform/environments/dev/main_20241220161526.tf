# MLflow Module
module "mlflow" {
  source                       = "./modules/mlflow"
  oci_tenancy_ocid             = var.oci_tenancy_ocid
  oci_user_ocid                = var.oci_user_ocid
  oci_fingerprint              = var.oci_fingerprint
  oci_private_key_path         = var.oci_private_key_path
  oci_region                   = var.oci_region
  oci_compartment_id           = var.oci_compartment_id
  oci_subnet_id                = var.oci_subnet_id
  ssh_public_key               = var.ssh_public_key
  mongodb_atlas_public_key     = var.mongodb_atlas_public_key
  mongodb_atlas_private_key    = var.mongodb_atlas_private_key
  mongodb_atlas_project_id     = var.mongodb_atlas_project_id
  mongodb_atlas_cluster_name   = "mlflow-cluster"
  mongodb_atlas_username       = "mlflow_user"
  mongodb_atlas_password       = var.mongodb_atlas_prod_password
  mongodb_atlas_database_name  = "mlflow_prod"
  provider_instance_size_name  = var.provider_instance_size_name
}

# Qdrant Module
module "qdrant" {
  source           = "./modules/qdrant"
  qdrant_api_url   = "https://your-qdrant-endpoint.qdrant.cloud"
  qdrant_api_key   = var.qdrant_api_key
  collection_name  = "vector-collection"
  vector_size      = 512
  distance_metric  = "Cosine"
}

# Upstash Module
module "upstash" {
  source             = "./modules/upstash"
  upstash_api_key    = var.upstash_api_key
  database_name      = var.upstash_database_name
  region             = var.upstash_region
}

# Monitoring Module
module "monitoring" {
  source                     = "./modules/monitoring"
  grafana_cloud_username     = var.grafana_cloud_username
  grafana_cloud_api_key      = var.grafana_cloud_api_key
  oci_tenancy_ocid           = var.oci_tenancy_ocid
  oci_compartment_id         = var.oci_compartment_id
  oci_region                 = var.oci_region
  oci_subnet_id              = var.oci_subnet_id
}