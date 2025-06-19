# Administration-Only Variables
# Variables for setting up Harness FME administrative infrastructure

variable "environment_name" {
  description = "Current environment name for this deployment"
  type        = string
  default     = "dev"

  validation {
    condition     = length(var.environment_name) > 0
    error_message = "Environment name cannot be empty."
  }
}

variable "workspace" {
  description = "Harness FME workspace configuration"
  type = object({
    name             = string
    create_workspace = optional(bool, false)
  })

  validation {
    condition     = length(var.workspace.name) > 0
    error_message = "Workspace name cannot be empty."
  }
}

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
}

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
  description = "List of API keys with environment filtering and configuration merging"
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

  validation {
    condition = alltrue([
      for key in var.api_keys : length(key.name) > 0
    ])
    error_message = "API key name cannot be empty."
  }

  validation {
    condition = alltrue([
      for key in var.api_keys : contains(["server_side", "client_side", "admin"], key.type)
    ])
    error_message = "API key type must be one of: server_side, client_side, admin."
  }
}

variable "environment_segment_keys" {
  description = "List of environment segment keys with environment filtering and configuration merging"
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

  validation {
    condition = alltrue([
      for seg_key in var.environment_segment_keys : length(seg_key.name) > 0
    ])
    error_message = "Environment segment key name cannot be empty."
  }

  validation {
    condition = alltrue([
      for seg_key in var.environment_segment_keys : length(seg_key.segment_name) > 0
    ])
    error_message = "Segment name cannot be empty."
  }
}