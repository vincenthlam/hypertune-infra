output "mlflow_server_public_ip" {
  value       = oci_core_instance.mlflow_server.public_ip
  description = "Public IP address of the MLflow Tracking Server."
}

output "mlflow_backend_store_uri" {
  value       = "mongodb+srv://${var.mongodb_atlas_username}:${var.mongodb_atlas_password}@${mongodbatlas_cluster.mlflow.connection_strings.standard_srv}/${var.mongodb_atlas_database_name}?retryWrites=true&w=majority"
  description = "URI for the MongoDB Atlas backend store."
  sensitive   = true
}