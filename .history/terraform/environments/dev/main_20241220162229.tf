module "shared" {
  source = "../../shared"
  environment            = "dev"
  oci_tenancy_ocid       = var.oci_tenancy_ocid
  oci_user_ocid          = var.oci_user_ocid
  oci_fingerprint        = var.oci_fingerprint
  oci_private_key_path   = var.oci_private_key_path
  oci_region             = var.oci_region
  oci_compartment_id     = var.oci_compartment_id
  terraform_state_bucket = var.terraform_state_bucket
  oci_namespace          = var.oci_namespace
}

module "network" {
  source                 = "../../modules/network"
  oci_tenancy_ocid       = module.shared.oci_tenancy_ocid
  oci_compartment_id     = module.shared.oci_compartment_id
  network_cidr_block     = var.network_cidr_block
  public_subnet_cidr     = var.public_subnet_cidr
  private_subnet_cidr    = var.private_subnet_cidr
  dns_label              = var.network_dns_label
}

module "compute" {
  source                 = "../../modules/compute"
  oci_tenancy_ocid       = module.shared.oci_tenancy_ocid
  oci_compartment_id     = module.shared.oci_compartment_id
  oci_subnet_id          = module.network.public_subnet_id
  ssh_public_key         = var.ssh_public_key
  instance_name          = var.compute_instance_name
  instance_shape         = var.compute_instance_shape
  ocpus                  = var.compute_ocpus
  memory_in_gbs          = var.compute_memory_in_gbs
}

module "mlflow" {
  source                       = "../../modules/mlflow"
  oci_tenancy_ocid             = module.shared.oci_tenancy_ocid
  oci_user_ocid                = module.shared.oci_user_ocid
  oci_fingerprint              = module.shared.oci_fingerprint
  oci_private_key_path         = module.shared.oci_private_key_path
  oci_region                   = module.shared.oci_region
  oci_compartment_id           = module.shared.oci_compartment_id
  oci_subnet_id                = module.network.public_subnet_id
  ssh_public_key               = var.ssh_public_key
  mongodb_atlas_public_key     = var.mongodb_atlas_public_key
  mongodb_atlas_private_key    = var.mongodb_atlas_private_key
  mongodb_atlas_project_id     = var.mongodb_atlas_project_id
  mongodb_atlas_cluster_name   = "mlflow-dev-cluster"
  mongodb_atlas_username       = "mlflow_dev_user"
  mongodb_atlas_password       = var.mongodb_atlas_dev_password
  mongodb_atlas_database_name  = "mlflow_dev"
  provider_instance_size_name  = "M0" # Free Tier for Dev
}

module "redis" {
  source          = "../../modules/redis"
  upstash_api_key = var.upstash_api_key
  database_name   = var.redis_database_name
  region          = var.redis_region
}

module "metrics" {
  source                     = "../../modules/metrics"
  grafana_cloud_username     = var.grafana_cloud_username
  grafana_cloud_api_key      = var.grafana_cloud_api_key
  oci_tenancy_ocid           = module.shared.oci_tenancy_ocid
  oci_compartment_id         = module.shared.oci_compartment_id
  oci_region                 = module.shared.oci_region
  oci_subnet_id              = module.network.private_subnet_id
  prometheus_function_name   = var.prometheus_function_name
  prometheus_function_image  = var.prometheus_function_image
}

module "qdrant" {
  source           = "../../modules/qdrant"
  qdrant_api_url   = var.qdrant_api_url
  qdrant_api_key   = var.qdrant_api_key
  collection_name  = "vector-collection-dev"
  vector_size      = 512
  distance_metric  = "Cosine"
}