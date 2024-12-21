output "vcn_id" {
  value = oci_core_vcn.main_vcn.id
}

output "subnet_ids" {
  value = oci_core_subnet.subnet[*].id
}