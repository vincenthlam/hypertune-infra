variable "environment_configs" {
  description = "Environment-specific configurations"
  type = map(object({
    waf_level        = string
    rate_limit       = number
    cache_ttl        = number
    security_level   = string
  }))
  default = {
    dev = {
      waf_level      = "low"
      rate_limit     = 100
      cache_ttl      = 3600
      security_level = "medium"
    }
    prod = {
      waf_level      = "high"
      rate_limit     = 50
      cache_ttl      = 7200
      security_level = "high"
    }
  }
}

variable "allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = []
}

variable "enable_bot_protection" {
  description = "Enable bot protection features"
  type        = bool
  default     = true
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting features"
  type        = bool
  default     = true
}

variable "cache_bypasses" {
  description = "List of URL patterns to bypass cache"
  type        = list(string)
  default     = ["/api/*", "/metrics/*"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}