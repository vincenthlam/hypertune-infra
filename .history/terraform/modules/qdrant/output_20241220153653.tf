output "collection_status" {
  description = "The status of the created Qdrant collection."
  value       = http_request.qdrant_collection.response_body
}