terraform {
  backend "oci" {
    bucket          = var.terraform_state_bucket
    namespace       = var.oci_namespace
    region          = var.oci_region
    compartment_id  = var.oci_compartment_id
    key             = "terraform/${var.environment}/state.tfstate"
  }
}