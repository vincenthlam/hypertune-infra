provider "http" {}

resource "http_request" "upstash_redis" {
  url     = "https://api.upstash.com/v2/redis"
  method  = "POST"

  request_body = jsonencode({
    name  = var.database_name
    region = var.region
    tls    = true
  })

  headers = {
    Authorization = "Bearer ${var.upstash_api_key}"
  }
}

# Extract response for database details
output "upstash_redis_connection" {
  value = jsondecode(http_request.upstash_redis.response_body)["endpoint"]
}

output "upstash_redis_password" {
  value = jsondecode(http_request.upstash_redis.response_body)["password"]
  sensitive = true
}