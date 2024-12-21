output "zone_id" {
  value = data.cloudflare_zones.domain.zones[0].id
}

output "nameservers" {
  value = data.cloudflare_zones.domain.zones[0].name_servers
}

output "mlflow_url" {
  value = "https://${cloudflare_record.mlflow.hostname}"
}

output "api_url" {
  value = "https://${cloudflare_record.api.hostname}"
}