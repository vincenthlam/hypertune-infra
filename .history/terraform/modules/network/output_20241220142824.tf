output "vcn_id" {
  value = oci_core_vcn.vcn.id
}

output "public_subnet_id" {
  value = oci_core_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = oci_core_subnet.private_subnet.id
}