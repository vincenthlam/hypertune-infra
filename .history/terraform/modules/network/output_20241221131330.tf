# modules/network/outputs.tf

output "vcn_id" {
  description = "The OCID of the VCN"
  value       = oci_core_vcn.mlops_vcn.id
}

output "subnet_ids" {
  description = "Map of subnet names to their OCIDs"
  value = {
    for idx, subnet in oci_core_subnet.service_subnet :
    var.subnet_names[idx] => subnet.id
  }
}

output "load_balancer_id" {
  description = "The OCID of the load balancer"
  value       = oci_load_balancer.mlops_lb.id
}

output "load_balancer_ip" {
  description = "The public IP address of the load balancer"
  value       = oci_load_balancer.mlops_lb.ip_addresses[0]
}

output "load_balancer_hostname" {
  description = "The hostname of the load balancer"
  value       = oci_load_balancer.mlops_lb.hostname
}

output "security_list_ids" {
  description = "Map of service names to their security list IDs"
  value = {
    for idx, sl in oci_core_security_list.service_security_lists :
    var.subnet_names[idx] => sl.id
  }
}

output "nsg_id" {
  description = "The OCID of the internal network security group"
  value       = oci_core_network_security_group.internal_nsg.id
}

output "backend_sets" {
  description = "Map of service names to their backend set names"
  value = {
    mlflow = oci_load_balancer_backend_set.mlflow_backend.name
    api    = oci_load_balancer_backend_set.api_backend.name
  }
}