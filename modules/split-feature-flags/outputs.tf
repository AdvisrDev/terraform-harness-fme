output "workspace_id" {
  description = "Split.io workspace ID"
  value       = local.workspace_id
}

output "environment_id" {
  description = "Split.io environment ID"
  value       = local.environment_id
}

output "environment_name" {
  description = "Split.io environment name"
  value       = var.environment_name
}

output "traffic_type_id" {
  description = "Split.io traffic type ID"
  value       = local.traffic_type_id
}

output "feature_flags" {
  description = "Created feature flags with their details"
  value = {
    for name, ff in split_split.this : name => {
      id          = ff.id
      description = ff.description
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
    total_count      = length(local.merged_feature_flags)
    filtered_count   = length(local.environment_feature_flags)
  }
}
