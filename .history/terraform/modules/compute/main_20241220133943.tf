resource "oci_core_instance" "arm_instance" {
  count            = var.instance_count
  availability_domain = var.availability_domain
  compartment_id   = var.compartment_id
  shape            = "VM.Standard.A1.Flex"

  create_vnic_details {
    subnet_id = var.subnet_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  freeform_tags = var.tags
}