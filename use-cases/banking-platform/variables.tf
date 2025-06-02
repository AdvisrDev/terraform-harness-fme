variable "split_api_key" {
  description = "Split.io API key for authentication"
  type        = string
  sensitive   = true
}

variable "workspace_name" {
  description = "Split.io workspace name"
  type        = string
  default     = "Default"
}

variable "environment_name" {
  description = "Environment name for feature flags"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment_name)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "is_production" {
  description = "Whether this environment is production"
  type        = bool
}

variable "traffic_type_name" {
  description = "Traffic type name for feature flags"
  type        = string
  default     = "user"
}

variable "feature_flags" {
  description = "Banking platform feature flags configuration"
  type = list(object({
    name              = string
    description       = string
    default_treatment = string
    treatments = list(object({
      name           = string
      configurations = optional(string, "{}")
      description    = optional(string, "")
    }))
    rules = optional(list(object({
      treatment = optional(string)
      size      = optional(number, 100)
      condition = optional(object({
        matcher = object({
          type      = string
          attribute = string
          strings   = optional(list(string), [])
        })
      }))
    })), [])
  }))
}