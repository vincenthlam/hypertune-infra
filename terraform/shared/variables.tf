variable "oci_tenancy_ocid" {
  default = null
  description = "OCI tenancy OCID"
}

variable "oci_user_ocid" {
  default = null
  description = "OCI user OCID"
}

variable "oci_private_key_path" {
  default = null
  description = "Path to OCI private key"
}

variable "oci_fingerprint" {
  default = null
  description = "OCI API key fingerprint"
}

variable "oci_region" {
  default = null
  description = "OCI region"
}

variable "mongodb_public_key" {
  default = null
  description = "MongoDB Atlas public API key"
}

variable "mongodb_private_key" {
  default = null
  description = "MongoDB Atlas private API key"
}

variable "github_token" {
  default = null
  description = "GitHub personal access token"
}

variable "grafana_cloud_url" {
  default = null
  description = "Grafana Cloud URL"
}

variable "grafana_api_key" {
  default = null
  description = "Grafana API key"
}

variable "cloudflare_api_token" {
  default = null
  description = "Cloudflare API token"
}