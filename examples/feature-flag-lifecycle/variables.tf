variable "environment_name" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment_name)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "is_production" {
  description = "Whether this is a production environment"
  type        = bool
}