resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
}

resource "oci_core_subnet" "public_subnet" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  cidr_block          = var.public_subnet_cidr
  vcn_id              = oci_core_vcn.vcn.id
  display_name        = "${var.vcn_name}-public-subnet"
  route_table_id      = oci_core_route_table.public_route_table.id
  security_list_ids   = [oci_core_security_list.public_security_list.id]
}

resource "oci_core_subnet" "private_subnet" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  cidr_block          = var.private_subnet_cidr
  vcn_id              = oci_core_vcn.vcn.id
  display_name        = "${var.vcn_name}-private-subnet"
  route_table_id      = oci_core_route_table.private_route_table.id
  security_list_ids   = [oci_core_security_list.private_security_list.id]
}