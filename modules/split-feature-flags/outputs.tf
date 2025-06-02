output "workspace_id" {
  description = "Split.io workspace ID"
  value       = data.split_workspace.this.id
}

output "environment_id" {
  description = "Split.io environment ID"
  value       = split_environment.this.id
}

output "environment_name" {
  description = "Split.io environment name"
  value       = split_environment.this.name
}

output "traffic_type_id" {
  description = "Split.io traffic type ID"
  value       = data.split_traffic_type.this.id
}

output "feature_flags" {
  description = "Created feature flags with their details"
  value = {
    for name, ff in split_split.this : name => {
      id          = ff.id
      name        = ff.name
      description = ff.description
    }
  }
}

output "feature_flag_definitions" {
  description = "Feature flag definitions with environment-specific settings"
  value = {
    for name, def in split_split_definition.this : name => {
      id                = def.id
      split_name        = def.split_name
      default_treatment = def.default_treatment
      environment_id    = def.environment_id
    }
  }
}

output "filtered_feature_flags" {
  description = "Feature flags filtered for current environment"
  value = local.environment_feature_flags
}

output "feature_flags_summary" {
  description = "Summary of feature flags by lifecycle stage and category"
  value = {
    by_lifecycle = {
      for stage in ["development", "testing", "staging", "production", "deprecated"] :
      stage => [
        for ff in local.environment_feature_flags : ff.name
        if ff.lifecycle_stage == stage
      ]
    }
    by_category = {
      for category in ["feature", "experiment", "operational", "permission", "killswitch"] :
      category => [
        for ff in local.environment_feature_flags : ff.name
        if ff.category == category
      ]
    }
    total_count = length(local.environment_feature_flags)
    available_count = length(var.feature_flags)
  }
}