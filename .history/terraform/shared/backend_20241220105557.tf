# backend.tf
terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "mlops-platform/terraform.tfstate"
    endpoint                    = "https://objectstorage.${var.region}.oraclecloud.com"
    region                      = var.region
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style           = true
  }
}