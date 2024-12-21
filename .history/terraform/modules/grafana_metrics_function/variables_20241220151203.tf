variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the user."
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint for the API key."
  type        = string
}

variable "private_key_path" {
  description = "The path to the private API key."
  type        = string
}

variable "region" {
  description = "The OCI region."
  type        = string
}

variable "compartment_id" {
  description = "The OCI Compartment OCID where the function will be deployed."
  type        = string
}

variable "function_app_name" {
  description = "The name of the Function Application."
  type        = string
  default     = "grafana-metrics-app"
}

variable "function_name" {
  description = "The name of the Function."
  type        = string
  default     = "grafana-metrics-function"
}

variable "function_image" {
  description = "Function container image (prebuilt or custom)."
  type        = string
}

variable "memory_in_mbs" {
  description = "Memory allocated to the function in MB."
  type        = number
  default     = 512
}

variable "timeout_in_seconds" {
  description = "Execution timeout for the function in seconds."
  type        = number
  default     = 30
}

variable "grafana_cloud_username" {
  description = "Grafana Cloud username for Prometheus metrics forwarding."
  type        = string
}

variable "grafana_cloud_api_key" {
  description = "Grafana Cloud API key for authentication."
  type        = string
  sensitive   = true
}

variable "pbf_listing_id" {
  description = "The PBF listing ID for the function (Oracle pre-built function)."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the Function Application."
  type        = list(string)
}

variable "schedule_name" {
  description = "The name of the Event Schedule."
  type        = string
  default     = "grafana-metrics-schedule"
}

variable "schedule_cron" {
  description = "Cron expression for triggering the function."
  type        = string
  default     = "0 */5 * * *" # Every 5 minutes
}

variable "tags" {
  description = "Freeform tags for the resources."
  type        = map(string)
  default     = {}
}