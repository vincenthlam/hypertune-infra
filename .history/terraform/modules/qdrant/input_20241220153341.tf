variable "qdrant_api_url" {
  description = "The API URL for the Qdrant Cloud instance."
  type        = string
}

variable "qdrant_api_key" {
  description = "The API key for Qdrant Cloud."
  type        = string
  sensitive   = true
}

variable "collection_name" {
  description = "The name of the Qdrant collection."
  type        = string
}

variable "vector_size" {
  description = "The size of the vectors in the collection."
  type        = number
  default     = 512
}

variable "distance_metric" {
  description = "The distance metric for vector similarity. Options: Cosine, Euclidean, Dot."
  type        = string
  default     = "Cosine"
}