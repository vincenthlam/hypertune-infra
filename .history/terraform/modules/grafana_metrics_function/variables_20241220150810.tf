variable "compartment_id" {
  description = "OCI Compartment OCID where the function will be deployed."
  type        = string
}

variable "function_app_name" {
  description = "Name of the Function Application."
  type        = string
  default     = "grafana-metrics-app"
}

variable "function_name" {
  description = "Name of the Function."
  type        = string
  default     = "grafana-metrics-function"
}

variable "function_image" {
  description = "Function container image (prebuilt or custom)."
  type        = string
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

variable "subnet_ids" {
  description = "Subnet IDs for the Function Application."
  type        = list(string)
}

variable "schedule_name" {
  description = "Name of the Event Schedule."
  type        = string
  default     = "grafana-metrics-schedule"
}

variable "schedule_time_of_day" {
  description = "Schedule for triggering the function."
  type        = string
  default     = "0 0/5 * * *" # Every 5 minutes
}

variable "tags" {
  description = "Freeform tags for the resources."
  type        = map(string)
  default     = {}
}