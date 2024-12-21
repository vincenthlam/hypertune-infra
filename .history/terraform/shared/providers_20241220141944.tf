terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    github = {
      source = "integrations/github"
    }
    grafana = {
      source = "grafana/grafana"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.oci_tenancy_ocid
  user_ocid        = var.oci_user_ocid
  private_key_path = var.oci_private_key_path
  fingerprint      = var.oci_fingerprint
  region           = var.oci_region
}

provider "mongodbatlas" {
  public_key  = var.mongodb_public_key
  private_key = var.mongodb_private_key
}

provider "github" {
  token = var.github_token
}

provider "grafana" {
  url  = var.grafana_cloud_url
  auth = var.grafana_api_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}