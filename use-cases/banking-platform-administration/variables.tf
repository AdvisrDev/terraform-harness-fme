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
  description = "Map of environment segment keys to manage"
  type = map(object({
    environment_key = string
    segment_name    = string
    keys            = list(string)
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
}

# API Keys Configuration
variable "api_keys" {
  description = "Map of API keys to create"
  type = map(object({
    environment_key = string
    name            = string
    type            = string
    roles           = list(string)
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
}
