# Root Module Outputs for Harness Feature Management and Experimentation
# This file defines outputs for the combined administration and feature flags modules

# Administration Module Outputs
output "administration" {
  description = "Complete administration module outputs"
  value       = module.split_administration
}

output "workspace_id" {
  description = "Harness FME workspace ID"
  value       = module.split_administration.workspace_id
}

output "environment_ids" {
  description = "Map of environment names to their IDs"
  value       = module.split_administration.environment_ids
}

output "traffic_type_ids" {
  description = "Map of traffic type names to their IDs"
  value       = module.split_administration.traffic_type_ids
}

output "segment_ids" {
  description = "Map of segment names to their IDs"
  value       = module.split_administration.segment_ids
}

output "api_keys" {
  description = "Created API keys with their details"
  value       = module.split_administration.api_keys
  sensitive   = true
}

output "environment_segment_keys" {
  description = "Created environment segment keys"
  value       = module.split_administration.environment_segment_keys
}

# Feature Flags Module Outputs
output "feature_flags" {
  description = "Complete feature flags module outputs"
  value       = module.feature_flags
}

output "feature_flags_list" {
  description = "List of created feature flags with their details"
  value       = module.feature_flags.feature_flags
}

output "filtered_feature_flags" {
  description = "Feature flags filtered for current environment"
  value       = module.feature_flags.filtered_feature_flags
}

output "merged_feature_flags" {
  description = "Feature flags with environment-specific configurations applied"
  value       = module.feature_flags.merged_feature_flags
}

output "feature_flags_summary" {
  description = "Summary of feature flags by lifecycle stage and category"
  value       = module.feature_flags.feature_flags_summary
}

# Combined Outputs for Integration
output "deployment_summary" {
  description = "Summary of the complete deployment"
  value = {
    environment_name = var.environment_name
    workspace_name   = var.workspace_name
    administration = {
      workspace_created    = module.split_administration.workspace_id != null
      environments_count   = length(module.split_administration.environment_ids)
      traffic_types_count  = length(module.split_administration.traffic_type_ids)
      segments_count       = length(module.split_administration.segment_ids)
      api_keys_count       = length(module.split_administration.api_keys)
    }
    feature_flags = {
      total_flags_count       = length(module.feature_flags.feature_flags)
      environment_flags_count = length(module.feature_flags.filtered_feature_flags)
      merged_flags_count      = length(module.feature_flags.merged_feature_flags)
    }
  }
}