# modules/cloudflare/main.tf

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "domain_name" {
  description = "The domain name to be managed by CloudFlare"
  type        = string
}

variable "api_token" {
  description = "CloudFlare API token"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
  default     = "dev"
}

variable "load_balancer_ip" {
  description = "OCI Load Balancer IP address"
  type        = string
}

# Data source to get zone ID
data "cloudflare_zones" "domain" {
  filter {
    name = var.domain_name
  }
}

# DNS Records
resource "cloudflare_record" "mlflow" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "mlflow"
  value   = var.load_balancer_ip
  type    = "A"
  proxied = true

  comment = "MLflow UI endpoint"
}

resource "cloudflare_record" "api" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "api"
  value   = var.load_balancer_ip
  type    = "A"
  proxied = true

  comment = "API endpoint"
}

# SSL/TLS Configuration
resource "cloudflare_zone_settings_override" "domain_settings" {
  zone_id = data.cloudflare_zones.domain.zones[0].id

  settings {
    ssl                      = "strict"
    always_use_https        = "on"
    min_tls_version        = "1.2"
    opportunistic_encryption = "on"
    tls_1_3                = "on"
    automatic_https_rewrites = "on"
    universal_ssl          = "on"
  }
}

# Security Configurations
resource "cloudflare_waf_group" "common_attacks" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  group_id = "de677e5818985db1285d0e80225f06e5"
  mode = "on"
}

# Rate Limiting Rules
resource "cloudflare_rate_limit" "api_limit" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  threshold = 100
  period    = 1
  match {
    request {
      url_pattern = "api.${var.domain_name}/*"
      schemes     = ["HTTP", "HTTPS"]
      methods     = ["GET", "POST", "PUT", "DELETE"]
    }
  }
  action {
    mode    = "ban"
    timeout = 300
  }
  disabled = false
  description = "Rate limiting for API endpoints"
}

# Cache Rules
resource "cloudflare_page_rule" "static_cache" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  target  = "*.${var.domain_name}/static/*"
  
  actions {
    cache_level = "cache_everything"
    edge_cache_ttl = 86400 # 24 hours
    browser_cache_ttl = 14400 # 4 hours
    cache_by_device_type = "on"
    cache_deception_armor = "on"
  }
}

resource "cloudflare_page_rule" "api_no_cache" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  target  = "api.${var.domain_name}/*"
  
  actions {
    cache_level = "bypass"
    security_level = "high"
  }
}

# Health Checks (Free Tier)
resource "cloudflare_healthcheck" "mlflow" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "mlflow-healthcheck"
  address = "mlflow.${var.domain_name}"
  type    = "HTTP"
  
  check_regions = [
    "WNAM", # Western North America
    "ENAM"  # Eastern North America
  ]
  
  header {
    header = "User-Agent"
    values = ["Cloudflare-Healthcheck"]
  }
  
  timeout = 5
  retries = 2
  interval = 60
  
  suspended = false
}

# Firewall Rules
resource "cloudflare_filter" "bots" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  expression = "(cf.client.bot) or (cf.threat_score gt 14)"
  description = "Filter for bot traffic and high threat scores"
}

resource "cloudflare_firewall_rule" "bots" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  filter_id = cloudflare_filter.bots.id
  action = "challenge"
  priority = 1
  description = "Challenge suspicious traffic"
}