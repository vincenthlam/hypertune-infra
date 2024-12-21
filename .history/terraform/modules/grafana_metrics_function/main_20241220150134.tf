resource "oci_functions_application" "metrics_function_app" {
  compartment_id = var.compartment_id
  display_name   = var.function_app_name
  subnet_ids     = var.subnet_ids
}

resource "oci_functions_function" "metrics_function" {
  application_id = oci_functions_application.metrics_function_app.id
  display_name   = var.function_name
  image          = var.function_image
  memory_in_mbs  = 512
  timeout_in_seconds = 30

  config = {
    "GRAFANA_CLOUD_USERNAME" = var.grafana_cloud_username
    "GRAFANA_CLOUD_API_KEY"  = var.grafana_cloud_api_key
  }

  provisioned_concurrency_config {
    provisioned_concurrency_count = 1
  }

  source_details {
    source_type = "INLINE_ZIP_FILE"
    source_data = base64encode(file("${path.module}/function_code/func.py"))
  }
}

resource "oci_events_rule" "metrics_function_schedule" {
  compartment_id = var.compartment_id
  display_name   = var.schedule_name

  condition {
    event_type = "com.oraclecloud.scheduler"
    event_source = "schedule"
    time_of_day = var.schedule_time_of_day # e.g., "0 0/5 * * *" for every 5 minutes
  }

  actions {
    function_id = oci_functions_function.metrics_function.id
  }
}

output "function_id" {
  value = oci_functions_function.metrics_function.id
}