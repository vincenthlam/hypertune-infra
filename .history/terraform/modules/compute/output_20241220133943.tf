output "instance_ids" {
  value = oci_core_instance.arm_instance[*].id
}

output "public_ips" {
  value = oci_core_instance.arm_instance[*].public_ip
}