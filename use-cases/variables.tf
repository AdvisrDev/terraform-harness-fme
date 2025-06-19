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

# Feature Flags Variables
variable "environment_name" {
  description = "Environment name for this feature flag deployment"
  type        = string

  validation {
    condition     = contains(["dev", "testing", "staging", "production"], var.environment_name)
    error_message = "Environment must be one of: development, testing, staging, production."
  }
}

variable "workspace_name" {
  description = "Environment name for feature flags (for reference)"
  type        = string

  validation {
    condition     = length(var.workspace_name) > 0
    error_message = "Workspace name cannot be empty."
  }
}
variable "traffic_type_name" {
  description = "Environment name for feature flags (for reference)"
  type        = string

  validation {
    condition     = length(var.traffic_type_name) > 0
    error_message = "Traffic type name cannot be empty."
  }
}

variable "workspace_id" {
  description = "Split.io workspace ID from administration module"
  type        = string
  default     = "-"
  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "Workspace ID cannot be empty. Must be provided from administration module."
  }
}

variable "environment_id" {
  description = "Split.io environment ID from administration module"
  type        = string
  default     = "-"

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "Environment ID cannot be empty. Must be provided from administration module."
  }
}

variable "traffic_type_id" {
  description = "Primary traffic type ID from administration module (typically customer)"
  type        = string
  default     = "-"

  validation {
    condition     = length(var.traffic_type_id) > 0
    error_message = "Traffic type ID cannot be empty. Must be provided from administration module."
  }
}

variable "feature_flags" {
  description = "List of feature flags to create with environment-specific configurations"
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
      description       = optional(string, "")
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

  validation {
    condition = alltrue([
      for ff in var.feature_flags : length(ff.name) > 0
    ])
    error_message = "Feature flag name cannot be empty."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags : length(ff.description) > 0
    ])
    error_message = "Feature flag description cannot be empty."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags : length(ff.default_treatment) > 0
    ])
    error_message = "Feature flag default_treatment cannot be empty."
  }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags : length(ff.treatments) >= 2
  #   ])
  #   error_message = "Each feature flag must have at least 2 treatments."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags : contains([for t in ff.treatments : t.name], ff.default_treatment)
  #   ])
  #   error_message = "Default treatment must exist in the treatments list."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     alltrue([
  #       for t in ff.treatments : length(t.name) > 0
  #     ])
  #   ])
  #   error_message = "Treatment names cannot be empty."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     length(ff.treatments) == length(distinct([for t in ff.treatments : t.name]))
  #   ])
  #   error_message = "Treatment names must be unique within each feature flag."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     alltrue([
  #       for rule in ff.rules :
  #       rule.size >= 0 && rule.size <= 100
  #     ]) if length(ff.rules) > 0
  #   ])
  #   error_message = "Rule size must be between 0 and 100."
  # }

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
      length(ff.environments) > 0
    ])
    error_message = "Each feature flag must specify at least one environment."
  }

  # Validate environment-specific configurations
  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for env_name, env_config in ff.environment_configs :
        contains(ff.environments, env_name)
      ])
    ])
    error_message = "Environment-specific configurations can only be defined for environments listed in the 'environments' array."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for env_name, env_config in ff.environment_configs :
        env_config.treatments != null ? length(env_config.treatments) >= 2 : true
      ])
    ])
    error_message = "Environment-specific treatments must have at least 2 treatments when specified."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for env_name, env_config in ff.environment_configs :
        env_config.treatments != null && env_config.default_treatment != null ?
        contains([for t in env_config.treatments : t.name], env_config.default_treatment) : true
      ])
    ])
    error_message = "Environment-specific default treatment must exist in environment-specific treatments list when both are specified."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for env_name, env_config in ff.environment_configs :
        env_config.rules != null ? alltrue([
          for rule in env_config.rules :
          rule.size >= 0 && rule.size <= 100
        ]) : true
      ])
    ])
    error_message = "Environment-specific rule sizes must be between 0 and 100."
  }
}
