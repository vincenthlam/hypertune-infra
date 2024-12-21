# OCI Variables
variable "oci_tenancy_ocid" {
  description = "The OCI tenancy OCID."
  type        = string
}

variable "oci_user_ocid" {
  description = "The OCI user OCID."
  type        = string
}

variable "oci_fingerprint" {
  description = "The OCI API key fingerprint."
  type        = string
}

variable "oci_private_key_path" {
  description = "Path to the OCI private key."
  type        = string
}

variable "oci_region" {
  description = "OCI region."
  type        = string
}

variable "oci_compartment_id" {
  description = "The OCI compartment OCID."
  type        = string
}

variable "oci_subnet_id" {
  description = "The OCI subnet ID."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for accessing OCI instances."
  type        = string
}

# MongoDB Atlas Variables
variable "mongodb_atlas_public_key" {
  description = "MongoDB Atlas public API key."
  type        = string
}

variable "mongodb_atlas_private_key" {
  description = "MongoDB Atlas private API key."
  type        = string
  sensitive   = true
}

variable "mongodb_atlas_project_id" {
  description = "MongoDB Atlas project ID."
  type        = string
}

variable "mongodb_atlas_dev_password" {
  description = "MongoDB Atlas password for dev environment."
  type        = string
  sensitive   = true
}

variable "mongodb_atlas_prod_password" {
  description = "MongoDB Atlas password for prod environment."
  type        = string
  sensitive   = true
}

variable "mongodb_atlas_database_name" {
  description = "The name of the MongoDB Atlas database."
  type        = string
}

variable "provider_instance_size_name" {
  description = "The instance size for the MongoDB Atlas cluster nodes."
  type        = string
  default     = "M10"
}

# Upstash Variables
variable "upstash_api_key" {
  description = "API key for Upstash Redis."
  type        = string
  sensitive   = true
}

variable "upstash_database_name" {
  description = "Upstash Redis database name."
  type        = string
}

variable "upstash_region" {
  description = "Region for Upstash Redis."
  type        = string
}

# Monitoring Variables
variable "grafana_cloud_username" {
  description = "Grafana Cloud username for Prometheus metrics."
  type        = string
}

variable "grafana_cloud_api_key" {
  description = "Grafana Cloud API key for Prometheus metrics."
  type        = string
  sensitive   = true
}