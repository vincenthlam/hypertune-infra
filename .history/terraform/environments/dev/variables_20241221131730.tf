# General Variables
variable "environment" {
  description = "The deployment environment (dev or prod)."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be 'dev' or 'prod'."
  }
}

# OCI Variables
variable "oci_tenancy_ocid" {
  description = "The OCID of the OCI tenancy."
  type        = string
}

variable "oci_user_ocid" {
  description = "The OCID of the OCI user."
  type        = string
}

variable "oci_fingerprint" {
  description = "The fingerprint of the OCI API key."
  type        = string
  default     = "default:fingerprint"
}

variable "oci_private_key_path" {
  description = "Path to the OCI private key."
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "oci_region" {
  description = "The OCI region for deployment."
  type        = string
  default     = "us-ashburn-1"
  validation {
    condition     = contains(["us-ashburn-1", "us-phoenix-1", "eu-frankfurt-1", "ap-mumbai-1"], var.oci_region)
    error_message = "Region must be a valid OCI region."
  }
}

variable "oci_compartment_id" {
  description = "The OCI compartment ID."
  type        = string
}

variable "terraform_state_bucket" {
  description = "The OCI bucket name for Terraform state."
  type        = string
}

variable "oci_namespace" {
  description = "The namespace for OCI Object Storage."
  type        = string
}

# Network Variables
variable "vcn_cidr_block" {
  description = "CIDR block for the VCN."
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.vcn_cidr_block))
    error_message = "Vcn_cidr_block must be a valid CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "network_dns_label" {
  description = "DNS label for the VCN."
  type        = string
  default     = "devnet"
}

# Compute Variables
variable "ssh_public_key" {
  description = "SSH public key for accessing instances."
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAn..."
}

variable "compute_instance_name" {
  description = "Name for the compute instance."
  type        = string
  default     = "dev-compute-instance"
}

variable "compute_instance_shape" {
  description = "Shape for the compute instance."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "compute_ocpus" {
  description = "Number of OCPUs for the compute instance."
  type        = number
  default     = 1
  validation {
    condition     = var.compute_ocpus > 0
    error_message = "OCPUs must be greater than 0."
  }
}

variable "compute_memory_in_gbs" {
  description = "Memory size (in GB) for the compute instance."
  type        = number
  default     = 6
  validation {
    condition     = var.compute_memory_in_gbs > 0
    error_message = "Memory size must be greater than 0."
  }
}

variable "image_id" {
  description = "The OCID of the image to use for the instance."
  type        = string
  default     = "ocid1.image.oc1..default_image"
}

variable "subnet_id" {
  description = "The OCID of the subnet to deploy the compute instance in."
  type        = string
}

# MLflow Variables
variable "mongodb_atlas_public_key" {
  description = "MongoDB Atlas public API key."
  type        = string
}

variable "mongodb_atlas_private_key" {
  description = "MongoDB Atlas private API key."
  type        = string
}

variable "mongodb_atlas_project_id" {
  description = "The MongoDB Atlas project ID."
  type        = string
}

variable "mongodb_atlas_dev_password" {
  description = "The MongoDB Atlas password for the dev environment."
  type        = string
}

variable "mlflow_cluster_name" {
  description = "Name of the MongoDB Atlas cluster for MLflow."
  type        = string
  default     = "mlflow-dev-cluster"
}

variable "mlflow_username" {
  description = "Username for MongoDB Atlas MLflow cluster."
  type        = string
  default     = "mlflow_dev_user"
}

variable "mlflow_database_name" {
  description = "Database name for MLflow in MongoDB Atlas."
  type        = string
  default     = "mlflow_dev"
}

variable "mlflow_instance_size_name" {
  description = "Instance size for MongoDB Atlas MLflow cluster."
  type        = string
  default     = "M0"
}

# Redis Variables
variable "upstash_api_key" {
  description = "API key for Upstash Redis."
  type        = string
}

variable "redis_database_name" {
  description = "Name of the Redis database for the dev environment."
  type        = string
  default     = "redis-dev"
}

variable "redis_region" {
  description = "Region for Redis deployment."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = contains(["us-east-1", "eu-west-1", "ap-southeast-1"], var.redis_region)
    error_message = "Redis region must be one of the supported regions: us-east-1, eu-west-1, ap-southeast-1."
  }
}

# Metrics Variables
variable "grafana_cloud_username" {
  description = "Grafana Cloud username for Prometheus metrics."
  type        = string
  default     = "grafana-user"
}

variable "grafana_cloud_api_key" {
  description = "Grafana Cloud API key for Prometheus metrics."
  type        = string
}

variable "prometheus_function_name" {
  description = "Name of the OCI function for Prometheus."
  type        = string
  default     = "prometheus-function"
}

variable "prometheus_function_image" {
  description = "Container image for Prometheus metrics function."
  type        = string
  default     = "oracle/functions/custom-function:latest"
}

# Qdrant Variables
variable "qdrant_api_url" {
  description = "Qdrant API endpoint URL."
  type        = string
}

variable "qdrant_api_key" {
  description = "API key for Qdrant."
  type        = string
}

variable "qdrant_collection_name" {
  description = "Collection name for Qdrant."
  type        = string
  default     = "vector-collection-dev"
}

variable "qdrant_vector_size" {
  description = "Vector size for Qdrant collection."
  type        = number
  default     = 512
  validation {
    condition     = var.qdrant_vector_size > 0
    error_message = "Vector size must be greater than 0."
  }
}

variable "qdrant_distance_metric" {
  description = "Distance metric for Qdrant."
  type        = string
  default     = "Cosine"
}

# Additional Variables
variable "availability_domain" {
  description = "The availability domain for the resources."
  type        = string
  default     = "AD-1"
}

variable "vcn_name" {
  description = "The name of the VCN."
  type        = string
  default     = "default-vcn"
}

variable "internet_gateway_id" {
  description = "The OCID of the Internet Gateway."
  type        = string
  default     = ""
}

variable "nat_gateway_id" {
  description = "The OCID of the NAT Gateway."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for the function."
  type        = list(string)
  default     = []
}

variable "pbf_listing_id" {
  description = "The PBF listing ID."
  type        = string
  default     = "default-pbf-id"
}