# Module inputs from split-administration module
variable "workspace_id" {
  description = "Split.io workspace ID"
  type        = string
  default     = "-"

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "Workspace ID cannot be empty."
  }
}

variable "environment_id" {
  description = "Split.io environment ID"
  type        = string
  default     = "-"

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "Environment ID cannot be empty."
  }
}

variable "environment_name" {
  description = "Environment name for feature flags (for reference)"
  type        = string

  validation {
    condition     = length(var.environment_name) > 0
    error_message = "Environment name cannot be empty."
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

variable "traffic_type_id" {
  description = "Split.io traffic type ID"
  type        = string
  default     = "-"

  validation {
    condition     = length(var.traffic_type_id) > 0
    error_message = "Traffic type ID cannot be empty."
  }
}

variable "feature_flags" {
  description = "List of feature flags to create with environment-specific configurations"
  type = list(object({
    name              = string
    description       = string
    default_treatment = string
    environments      = list(string)
    lifecycle_stage   = string
    category          = string
    treatments = list(object({
      name           = string
      configurations = string
      description    = string
    }))
    rules = list(object({
      treatment = string
      size      = number
      condition = object({
        matcher = object({
          type      = string
          attribute = string
          strings   = list(string)
        })
      })
    }))
    # Environment-specific overrides
    environment_configs = map(object({
      default_treatment = string
      description       = string
      treatments = list(object({
        name           = string
        configurations = string
        description    = string
      }))
      rules = list(object({
        treatment = string
        size      = number
        condition = object({
          matcher = object({
            type      = string
            attribute = string
            strings   = list(string)
          })
        })
      }))
    }))
  }))

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags : length(ff.name) > 0
  #   ])
  #   error_message = "Feature flag name cannot be empty."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags : length(ff.description) > 0
  #   ])
  #   error_message = "Feature flag description cannot be empty."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags : length(ff.default_treatment) > 0
  #   ])
  #   error_message = "Feature flag default_treatment cannot be empty."
  # }

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

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     contains(["development", "testing", "staging", "production", "deprecated"], ff.lifecycle_stage)
  #   ])
  #   error_message = "Lifecycle stage must be one of: development, testing, staging, production, deprecated."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     contains(["feature", "experiment", "operational", "permission", "killswitch"], ff.category)
  #   ])
  #   error_message = "Category must be one of: feature, experiment, operational, permission, killswitch."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     length(ff.environments) > 0
  #   ])
  #   error_message = "Each feature flag must specify at least one environment."
  # }

  # # Validate environment-specific configurations
  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     alltrue([
  #       for env_name, env_config in ff.environment_configs :
  #       contains(ff.environments, env_name)
  #     ])
  #   ])
  #   error_message = "Environment-specific configurations can only be defined for environments listed in the 'environments' array."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     alltrue([
  #       for env_name, env_config in ff.environment_configs :
  #       env_config.treatments != null ? length(env_config.treatments) >= 2 : true
  #     ])
  #   ])
  #   error_message = "Environment-specific treatments must have at least 2 treatments when specified."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     alltrue([
  #       for env_name, env_config in ff.environment_configs :
  #       env_config.treatments != null && env_config.default_treatment != null ?
  #       contains([for t in env_config.treatments : t.name], env_config.default_treatment) : true
  #     ])
  #   ])
  #   error_message = "Environment-specific default treatment must exist in environment-specific treatments list when both are specified."
  # }

  # validation {
  #   condition = alltrue([
  #     for ff in var.feature_flags :
  #     alltrue([
  #       for env_name, env_config in ff.environment_configs :
  #       env_config.rules != null ? alltrue([
  #         for rule in env_config.rules :
  #         rule.size >= 0 && rule.size <= 100
  #       ]) : true
  #     ])
  #   ])
  #   error_message = "Environment-specific rule sizes must be between 0 and 100."
  # }
}
