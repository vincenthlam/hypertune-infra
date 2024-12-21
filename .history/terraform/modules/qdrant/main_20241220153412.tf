provider "http" {}

resource "http_request" "qdrant_collection" {
  url     = "${var.qdrant_api_url}/collections/${var.collection_name}"
  method  = "PUT"

  request_body = jsonencode({
    vectors = {
      size     = var.vector_size
      distance = var.distance_metric
    }
  })

  headers = {
    Authorization = "Bearer ${var.qdrant_api_key}"
    "Content-Type" = "application/json"
  }
}

# Extract collection creation status
output "qdrant_collection_status" {
  value = jsondecode(http_request.qdrant_collection.response_body)
}