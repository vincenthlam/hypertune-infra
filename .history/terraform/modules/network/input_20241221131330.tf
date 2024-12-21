# modules/network/variables.tf

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet_names" {
  description = "Names for the service subnets"
  type        = list(string)
  default     = ["mlflow", "qdrant", "api", "cache"]
}

variable "service_ports" {
  description = "Port mappings for each service"
  type        = map(list(number))
  default     = {
    "mlflow" = [5000, 9090]  # MLflow UI and metrics
    "qdrant" = [6333]        # Qdrant API
    "api"    = [80, 443]     # HTTP/HTTPS
    "cache"  = [6379]        # Redis
  }
}

variable "load_balancer_shape" {
  description = "Shape for the load balancer (free tier)"
  type = object({
    min_bandwidth = number
    max_bandwidth = number
  })
  default = {
    min_bandwidth = 10
    max_bandwidth = 10
  }
}

variable "health_check_config" {
  description = "Health check configuration for services"
  type = map(object({
    port = number
    path = string
  }))
  default = {
    mlflow = {
      port = 5000
      path = "/health"
    }
    api = {
      port = 8000
      path = "/health"
    }
  }
}