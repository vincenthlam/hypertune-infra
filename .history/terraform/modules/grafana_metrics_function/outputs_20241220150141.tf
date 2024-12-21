output "function_id" {
  description = "The ID of the deployed function."
  value       = oci_functions_function.metrics_function.id
}

output "application_id" {
  description = "The ID of the Function Application."
  value       = oci_functions_application.metrics_function_app.id
}