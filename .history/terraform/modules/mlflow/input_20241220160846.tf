variable "oci_tenancy_ocid" {
  description = "The OCID of the OCI tenancy."
  type        = string
}

variable "oci_user_ocid" {
  description = "The OCID of the OCI user."
  type        = string
}

variable "oci_fingerprint" {
  description = "The fingerprint for the OCI API key."
  type        = string
}

variable "oci_private_key_path" {
  description = "The path to the OCI API private key."
  type        = string
}

variable "oci_region" {
  description = "The OCI region to deploy the resources in."
  type        = string
}

variable "oci_compartment_id" {
  description = "The OCI compartment where the resources will be deployed."
  type        = string
}

variable "oci_subnet_id" {
  description = "The OCID of the subnet for the MLflow server."
  type        = string
}

variable "provider_name"{
    type = string
    default = "AWS"
}
variable "provider_instance_size_name"{
    type = string
    default = ""
}

variable "ssh_public_key" {
  description = "The SSH public key to access the MLflow server."
  type        = string
}

variable "mongodb_atlas_database_name" {
  description = "The name of the MongoDB database to use for MLflow."
  type        = string
  default     = "mlflow"
}

variable "mongodb_atlas_public_key" {
  description = "The public API key for MongoDB Atlas."
  type        = string
}

variable "mongodb_atlas_private_key" {
  description = "The private API key for MongoDB Atlas."
  type        = string
  sensitive   = true
}

variable "mongodb_atlas_project_id" {
  description = "The project ID for MongoDB Atlas."
  type        = string
}

variable "mongodb_atlas_cluster_name" {
  description = "The name of the MongoDB Atlas cluster."
  type        = string
}

variable "mongodb_atlas_username" {
  description = "The username for the MongoDB Atlas database user."
  type        = string
}

variable "mongodb_atlas_password" {
  description = "The password for the MongoDB Atlas database user."
  type        = string
  sensitive   = true
}

variable "mongodb_atlas_database_name" {
  description = "The name of the MongoDB Atlas database for MLflow."
  type        = string
  default     = "mlflow"
}