terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
  
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "hypertune/terraform.tfstate"
    endpoint                    = "https://YOUR_NAMESPACE.compat.objectstorage.REGION.oraclecloud.com"
    region                      = "YOUR_REGION"
    shared_credentials_file     = "~/.oci/config"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style           = true
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}