# Root Module Variables for Harness Feature Management and Experimentation
# This file defines variables for the combined administration and feature flags modules

# Common Variables
variable "environment_name" {
  description = "Current environment name for this deployment"
  type        = string
  default     = "common"
}

# Administration Module Variables
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

# Feature Flags Module Variables
variable "workspace_id" {
  default = ""
}
variable "environment_id" {
  default = ""
}

variable "traffic_type_id" {
  default = ""
}

variable "traffic_type_name" {
  description = "Traffic type name for feature flags"
  type        = string
  default     = "user"

  validation {
    condition     = length(var.traffic_type_name) > 0
    error_message = "Traffic type name cannot be empty."
  }
}

variable "feature_flags" {
  description = "List of feature flags with environment-specific configurations"
  type = list(object({
    name              = string
    description       = string
    default_treatment = string
    environments      = optional(list(string), ["dev", "staging", "prod"])
    lifecycle_stage   = optional(string, "development")
    category          = optional(string, "feature")

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

    # Environment-specific overrides
    environment_configs = optional(map(object({
      default_treatment = optional(string)
      description       = optional(string)
      treatments = optional(list(object({
        name           = string
        configurations = optional(string, "{}")
        description    = optional(string, "")
      })))
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
      })))
    })), {})
  }))
  default = []

  validation {
    condition = alltrue([
      for ff in var.feature_flags : length(ff.name) > 0
    ])
    error_message = "Feature flag name cannot be empty."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags : length(ff.treatments) >= 2
    ])
    error_message = "Each feature flag must have at least 2 treatments."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      contains([for t in ff.treatments : t.name], ff.default_treatment)
    ])
    error_message = "Default treatment must exist in treatments list."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      contains(["development", "testing", "staging", "production", "deprecated"], ff.lifecycle_stage)
    ])
    error_message = "Lifecycle stage must be one of: development, testing, staging, production, deprecated."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      contains(["feature", "experiment", "operational", "permission", "killswitch"], ff.category)
    ])
    error_message = "Category must be one of: feature, experiment, operational, permission, killswitch."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for rule in ff.rules :
        rule.size >= 0 && rule.size <= 100
      ])
    ])
    error_message = "Rule sizes must be between 0 and 100."
  }
}
