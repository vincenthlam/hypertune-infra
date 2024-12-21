resource "oci_core_instance" "mlflow_server" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.A1.Flex"

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  freeform_tags = var.tags
}