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
  source              = "../../modules/mlflow"
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  subnet_id           = module.network.subnet_ids[0]
  image_id            = var.image_id
  ssh_public_key      = var.ssh_public_key
  tags                = {
    environment = "dev"
  }
}

module "qdrant" {
  source              = "../../modules/qdrant"
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  subnet_id           = module.network.subnet_ids[0]
  image_id            = var.image_id
  ssh_public_key      = var.ssh_public_key
  tags                = {
    environment = "dev"
  }
}