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

output "merged_feature_flags" {
  description = "Feature flags with environment-specific configurations applied"
  value = local.merged_feature_flags
}

output "environment_specific_configs" {
  description = "Environment-specific configurations that were applied"
  value = {
    for ff in local.merged_feature_flags : ff.name => {
      environment = var.environment_name
      has_override = ff._environment_config != null
      overrides_applied = ff._environment_config != null ? {
        description_override = ff._environment_config.description != null
        default_treatment_override = ff._environment_config.default_treatment != null
        treatments_override = ff._environment_config.treatments != null
        rules_override = ff._environment_config.rules != null
      } : null
      final_config = {
        description = ff.description
        default_treatment = ff.default_treatment
        treatments_count = length(ff.treatments)
        rules_count = length(ff.rules)
      }
    }
  }
}

output "feature_flags_summary" {
  description = "Summary of feature flags by lifecycle stage and category"
  value = {
    by_lifecycle = {
      for stage in ["development", "testing", "staging", "production", "deprecated"] :
      stage => [
        for ff in local.merged_feature_flags : ff.name
        if ff.lifecycle_stage == stage
      ]
    }
    by_category = {
      for category in ["feature", "experiment", "operational", "permission", "killswitch"] :
      category => [
        for ff in local.merged_feature_flags : ff.name
        if ff.category == category
      ]
    }
    environment_name = var.environment_name
    total_count = length(local.merged_feature_flags)
    available_count = length(var.feature_flags)
    filtered_count = length(local.environment_feature_flags)
    environment_overrides_count = length([
      for ff in local.merged_feature_flags : ff.name
      if ff._environment_config != null
    ])
  }
}