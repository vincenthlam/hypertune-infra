output "qdrant_server_ip" {
  value = oci_core_instance.qdrant_server.public_ip
}