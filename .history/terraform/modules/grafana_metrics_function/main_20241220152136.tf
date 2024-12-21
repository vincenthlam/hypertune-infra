terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Function Application
resource "oci_functions_application" "metrics_function_app" {
  compartment_id = var.compartment_id
  display_name   = var.function_app_name
  subnet_ids     = var.subnet_ids
  freeform_tags  = var.tags
}

# Function
resource "oci_functions_function" "metrics_function" {
  application_id      = oci_functions_application.metrics_function_app.id
  display_name        = var.function_name
  image               = var.function_image
  memory_in_mbs       = var.memory_in_mbs
  timeout_in_seconds  = var.timeout_in_seconds

  config = {
    GRAFANA_CLOUD_USERNAME = var.grafana_cloud_username
    GRAFANA_CLOUD_API_KEY  = var.grafana_cloud_api_key
  }

  source_details {
    source_type   = "ORACLE_FUNCTION"
    pbf_listing_id = var.pbf_listing_id
  }

  freeform_tags = var.tags
}

# Event Rule
resource "oci_events_rule" "metrics_function_schedule" {
  compartment_id = var.compartment_id
  display_name   = var.schedule_name
  description    = "Schedule rule to trigger the metrics function."
  is_enabled     = true
  condition      = "{\"time\" : {\"cron\": \"${var.schedule_cron}\"}}"

  # Corrected actions block
  actions {
    actions {
        action_type = var.rule_actions_actions_action_type
        function_id = oci_functions_function.metrics_function
        is_enabled = var.rule_actions_actions_is_enabled
    }
  }

  freeform_tags = var.tags
}

# Outputs
output "function_id" {
  description = "The OCID of the deployed function."
  value       = oci_functions_function.metrics_function.id
}

output "application_id" {
  description = "The OCID of the Function Application."
  value       = oci_functions_application.metrics_function_app.id
}