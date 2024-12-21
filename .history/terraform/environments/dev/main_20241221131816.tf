module "mlflow" {
  source                      = "../../modules/mlflow"
  oci_tenancy_ocid            = module.shared.oci_tenancy_ocid
  oci_user_ocid               = module.shared.oci_user_ocid
  oci_fingerprint             = module.shared.oci_fingerprint
  oci_private_key_path        = module.shared.oci_private_key_path
  oci_region                  = module.shared.oci_region
  oci_compartment_id          = module.shared.oci_compartment_id
  oci_subnet_id               = module.network.public_subnet_id
  ssh_public_key              = var.ssh_public_key
  mongodb_atlas_public_key    = var.mongodb_atlas_public_key
  mongodb_atlas_private_key   = var.mongodb_atlas_private_key
  mongodb_atlas_project_id    = var.mongodb_atlas_project_id
  mongodb_atlas_cluster_name  = "mlflow-dev-cluster"
  mongodb_atlas_username      = "mlflow_dev_user"
  mongodb_atlas_password      = var.mongodb_atlas_dev_password
  mongodb_atlas_database_name = "mlflow_dev"
  provider_instance_size_name = "M0" # Free Tier for Dev
}

module "redis" {
  source          = "../../modules/redis"
  upstash_api_key = var.upstash_api_key
  database_name   = var.redis_database_name
  region          = var.redis_region
}


module "qdrant" {
  source          = "../../modules/qdrant"
  qdrant_api_url  = var.qdrant_api_url
  qdrant_api_key  = var.qdrant_api_key
  collection_name = "vector-collection-dev"
  vector_size     = 512
  distance_metric = "Cosine"
}
module "network" {
  source = "../../modules/network"

  compartment_id = var.compartment_id
  common_tags    = local.common_tags
  # Optional: Override default service ports
  service_ports = {
    "mlflow" = [5000, 9090]
    "qdrant" = [6333]
    "api"    = [80, 443, 8000]
    "cache"  = [6379]
  }
}

module "compute" {
  source              = "../../modules/compute"
  compartment_id      = var.oci_compartment_id
  image_id            = var.image_id
  availability_domain = var.availability_domain
  subnet_id           = var.subnet_id
  ssh_public_key      = var.ssh_public_key
}

module "metrics" {
  source                 = "../../modules/grafana_metrics_function"
  region                 = var.oci_region
  user_ocid              = var.oci_user_ocid
  compartment_id         = var.oci_compartment_id
  subnet_ids             = var.subnet_ids
  fingerprint            = var.oci_fingerprint
  grafana_cloud_api_key  = var.grafana_cloud_api_key
  pbf_listing_id         = var.pbf_listing_id
  grafana_cloud_username = var.grafana_cloud_username
  private_key_path       = var.oci_private_key_path
  function_image         = var.prometheus_function_image
  tenancy_ocid           = var.oci_tenancy_ocid
}

module "cloudflare" {
  source = "./modules/cloudflare"
  
  api_token = var.cloudflare_api_token
  environment = terraform.workspace

  # Domain and origins configuration
  domain_config = {
    domain_name = var.domain_name
    allowed_origins = [
      "https://mlflow.${var.domain_name}",
      "https://api.${var.domain_name}"
    ]
    cache_bypasses = [
      "/api/v1/*",
      "/metrics/*",
      "/mlflow/experiments/*"
    ]
  }

  # Network configuration from network module
  network_config = {
    load_balancer_ip = module.network.load_balancer_ip
    load_balancer_hostname = module.network.load_balancer_hostname
  }

  depends_on = [module.network]
}