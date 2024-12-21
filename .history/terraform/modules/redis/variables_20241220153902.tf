variable "upstash_api_key" {
  description = "Your Upstash API key for authentication."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the Redis database."
  type        = string
}

variable "region" {
  description = "Region where the Redis database will be created."
  type        = string
  default     = "us-east-1"
}