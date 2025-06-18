# Environment name for filtering environment-specific resources
variable "environment_name" {
  description = "Current environment name for filtering environment-specific resources"
  type        = string

  validation {
    condition     = length(var.environment_name) > 0
    error_message = "Environment name cannot be empty."
  }
}

# Workspace Configuration
variable "workspace" {
  description = "Split.io workspace name"
  type = object({
    name             = string
    create_workspace = bool
  })
}

# Environment Configuration
variable "environments" {
  description = "Map of environments to create"
  type = map(object({
    name       = string
    production = bool
  }))

  validation {
    condition = alltrue([
      for env in var.environments : length(env.name) > 0 && length(env.name) < 15
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

  validation {
    condition = alltrue([
      for segment in var.segments : length(segment.name) > 0
    ])
    error_message = "Segment name cannot be empty."
  }
}

# Environment Segment Keys Configuration
variable "environment_segment_keys" {
  description = "List of environment segment keys with environment-specific configurations"
  type = list(object({
    name         = string
    segment_name = string
    keys         = list(string)
    environments = optional(list(string), [])
    # Environment-specific overrides
    environment_configs = optional(map(object({
      keys = optional(list(string))
    })), {})
  }))

  validation {
    condition = alltrue([
      for esk in var.environment_segment_keys : length(esk.segment_name) > 0
    ])
    error_message = "Segment name cannot be empty."
  }

  validation {
    condition = alltrue([
      for esk in var.environment_segment_keys : length(esk.keys) > 0
    ])
    error_message = "Keys list cannot be empty."
  }

  validation {
    condition = alltrue([
      for esk in var.environment_segment_keys :
      alltrue([
        for env_name, env_config in esk.environment_configs :
        contains(esk.environments, env_name)
      ])
    ])
    error_message = "Environment-specific configurations can only be defined for environments listed in the 'environments' array."
  }
}

# API Keys Configuration
variable "api_keys" {
  description = "List of API keys with environment-specific configurations"
  type = list(object({
    name         = string
    type         = string
    roles        = list(string)
    environments = optional(list(string), [])
    # Environment-specific overrides
    environment_configs = optional(map(object({
      name  = optional(string)
      type  = optional(string)
      roles = optional(list(string))
    })), {})
  }))

  validation {
    condition = alltrue([
      for key in var.api_keys :
      contains(["admin", "server_side", "client_side"], key.type)
    ])
    error_message = "API key type must be one of: admin, server_side, client_side."
  }

  validation {
    condition = alltrue([
      for key in var.api_keys : length(key.name) > 0 && length(key.name) <= 15
    ])
    error_message = "API key name cannot be empty."
  }

  validation {
    condition = alltrue([
      for key in var.api_keys : length(key.roles) > 0
    ])
    error_message = "API key must have at least one role."
  }

  validation {
    condition = alltrue([
      for key in var.api_keys :
      alltrue([
        for env_name, env_config in key.environment_configs :
        contains(key.environments, env_name)
      ])
    ])
    error_message = "Environment-specific configurations can only be defined for environments listed in the 'environments' array."
  }

  validation {
    condition = alltrue([
      for key in var.api_keys :
      alltrue([
        for env_name, env_config in key.environment_configs :
        env_config.type != null ? contains(["admin", "server_side", "client_side"], env_config.type) : true
      ])
    ])
    error_message = "Environment-specific API key type must be one of: admin, server_side, client_side."
  }

  validation {
    condition = alltrue([
      for key in var.api_keys :
      alltrue([
        for env_name, env_config in key.environment_configs :
        env_config.roles != null ? length(env_config.roles) > 0 : true
      ])
    ])
    error_message = "Environment-specific API key must have at least one role when specified."
  }
}
