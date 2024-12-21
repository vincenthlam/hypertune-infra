module "network" {
  source = "../../modules/network"

  compartment_id       = var.compartment_id
  vcn_cidr_block       = "10.0.0.0/16"
  vcn_name             = "dev-network"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
  availability_domain  = var.availability_domain
  internet_gateway_id  = var.internet_gateway_id
  nat_gateway_id       = var.nat_gateway_id
}

module "compute" {
  source              = "../../modules/compute"
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  subnet_id           = module.network.subnet_ids[0]
  image_id            = var.image_id
  ssh_public_key      = var.ssh_public_key
  instance_count      = 1
  tags                = {
    environment = "dev"
  }
}

module "mlflow" {
  source                       = "../../modules/mlflow"
  oci_tenancy_ocid             = var.oci_tenancy_ocid
  oci_user_ocid                = var.oci_user_ocid
  oci_fingerprint              = var.oci_fingerprint
  oci_private_key_path         = var.oci_private_key_path
  oci_region                   = var.oci_region
  oci_compartment_id           = var.oci_compartment_id
  oci_subnet_id                = var.oci_subnet_id
  ssh_public_key               = file("~/.ssh/id_rsa.pub")
  mongodb_atlas_public_key     = var.mongodb_atlas_public_key
  mongodb_atlas_private_key    = var.mongodb_atlas_private_key
  mongodb_atlas_project_id     = var.mongodb_atlas_project_id
  mongodb_atlas_cluster_name   = "mlflow-cluster"
  mongodb_atlas_username       = "mlflow_user"
  mongodb_atlas_password       = var.mongodb_atlas_password
  mongodb_atlas_database_name  = "mlflow"
}

