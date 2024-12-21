locals {
  
}

module "compute"{
    source = "../../modules/compute"
}

module "mlflow"{
    source = "../../modules/mlflow"
}

module "network"{
    source = "../../modules/network"
}

module "qdrant"{
    source = "../../modules/qdrant"
}