output "mlflow_server_ip" {
  value = oci_core_instance.mlflow_server.public_ip
}