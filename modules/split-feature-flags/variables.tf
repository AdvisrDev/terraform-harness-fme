variable "workspace_name" {
  description = "Split.io workspace name"
  type        = string

  validation {
    condition     = length(var.workspace_name) > 0
    error_message = "Workspace name cannot be empty."
  }
}

variable "environment_name" {
  description = "Environment name for feature flags"
  type        = string

  validation {
    condition     = length(var.environment_name) > 0
    error_message = "Environment name cannot be empty."
  }
}

variable "is_production" {
  description = "Whether this environment is production"
  type        = bool
}

variable "traffic_type_name" {
  description = "Traffic type name for feature flags"
  type        = string

  validation {
    condition     = length(var.traffic_type_name) > 0
    error_message = "Traffic type name cannot be empty."
  }
}

variable "feature_flags" {
  description = "List of feature flags to create"
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

  validation {
    condition = alltrue([
      for ff in var.feature_flags : length(ff.treatments) >= 2
    ])
    error_message = "Each feature flag must have at least 2 treatments."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags : contains([for t in ff.treatments : t.name], ff.default_treatment)
    ])
    error_message = "Default treatment must exist in the treatments list."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for t in ff.treatments : length(t.name) > 0
      ])
    ])
    error_message = "Treatment names cannot be empty."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      length(ff.treatments) == length(distinct([for t in ff.treatments : t.name]))
    ])
    error_message = "Treatment names must be unique within each feature flag."
  }

  validation {
    condition = alltrue([
      for ff in var.feature_flags :
      alltrue([
        for rule in ff.rules :
        rule.size >= 0 && rule.size <= 100
      ]) if length(ff.rules) > 0
    ])
    error_message = "Rule size must be between 0 and 100."
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
      length(ff.environments) > 0
    ])
    error_message = "Each feature flag must specify at least one environment."
  }
}
