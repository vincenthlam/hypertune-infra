output "compute_instance_ids" {
  value = module.compute.instance_ids
}

output "mlflow_server_ip" {
  value = module.mlflow.mlflow_server_ip
}

output "qdrant_server_ip" {
  value = module.qdrant.qdrant_server_ip
}

output "vcn_id" {
  value = module.network.vcn_id
}