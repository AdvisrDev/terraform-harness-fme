# Environment name for this deployment
variable "environment_name" {
  description = "Current environment name for this deployment"
  type        = string
  default     = "dev"

  validation {
    condition     = length(var.environment_name) > 0
    error_message = "Environment name cannot be empty."
  }
}

# Workspace Configuration
variable "workspace" {
  description = "Split.io workspace configuration"
  type = object({
    name             = string
    create_workspace = optional(bool, false)
  })
}

# Environment Configuration
variable "environments" {
  description = "Map of environments to create"
  type = map(object({
    name       = string
    production = bool
  }))

  default = {}

  validation {
    condition = alltrue([
      for env in var.environments : length(env.name) > 0
    ])
    error_message = "Environment name cannot be empty."
  }
}

# Traffic Type Configuration
variable "traffic_types" {
  description = "Map of traffic types to create"
  type = map(object({
    name         = string
    display_name = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for tt in var.traffic_types : length(tt.name) > 0
    ])
    error_message = "Traffic type name cannot be empty."
  }
}

# Traffic Type Attributes Configuration
variable "traffic_type_attributes" {
  description = "Map of traffic type attributes to create"
  type = map(object({
    traffic_type_key = string
    id               = string
    display_name     = string
    description      = optional(string, "")
    data_type        = string
    is_searchable    = optional(bool, true)
    suggested_values = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for attr in var.traffic_type_attributes :
      contains(["string", "number", "boolean", "datetime", "set"], attr.data_type)
    ])
    error_message = "Data type must be one of: string, number, boolean, datetime, set."
  }

  validation {
    condition = alltrue([
      for attr in var.traffic_type_attributes : length(attr.id) > 0
    ])
    error_message = "Traffic type attribute ID cannot be empty."
  }

  validation {
    condition = alltrue([
      for attr in var.traffic_type_attributes : length(attr.display_name) > 0
    ])
    error_message = "Traffic type attribute display name cannot be empty."
  }
}

# Segment Configuration
variable "segments" {
  description = "Map of segments to create"
  type = map(object({
    traffic_type_key = string
    name             = string
    description      = optional(string, "")
  }))
  default = {}

  validation {
    condition = alltrue([
      for segment in var.segments : length(segment.name) > 0
    ])
    error_message = "Segment name cannot be empty."
  }
}

variable "api_keys" {
  description = "Common API keys loaded from common.tfvars"
  type = list(object({
    name         = string
    type         = string
    roles        = list(string)
    environments = optional(list(string), [])
    environment_configs = optional(map(object({
      name  = optional(string)
      type  = optional(string)
      roles = optional(list(string))
    })), {})
  }))
  default = []
}

# Environment Segment Keys Configuration
variable "environment_segment_keys" {
  description = "Common environment segment keys loaded from common.tfvars"
  type = list(object({
    name         = string
    segment_name = string
    keys         = list(string)
    environments = optional(list(string), [])
    environment_configs = optional(map(object({
      keys = optional(list(string))
    })), {})
  }))
  default = []
}
