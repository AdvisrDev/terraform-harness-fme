# Root Module Outputs for Harness Feature Management and Experimentation
# This file defines outputs for the combined administration and feature flags modules

output "workspace_id" {
  description = "Harness FME workspace ID"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].workspace_id : null
}

output "workspace_name" {
  description = "Harness FME workspace name"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].workspace_name : null
}

output "workspace_created" {
  description = "Whether workspace was created by this module"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].workspace_created : null
}

output "environment_ids" {
  description = "Map of environment names to their IDs"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].environment_ids : {}
}

output "traffic_type_ids" {
  description = "Map of traffic type names to their IDs"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].traffic_type_ids : {}
}

output "segment_ids" {
  description = "Map of segment names to their IDs"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].segment_ids : {}
}

output "api_keys" {
  description = "Created API keys with their details"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].api_keys : {}
  sensitive   = true
}

output "api_key_ids" {
  description = "Map of API key names to IDs"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].api_key_ids : {}
  sensitive   = true
}

output "environment_segment_keys" {
  description = "Created environment segment keys"
  value       = length(module.split_administration) > 0 ? module.split_administration[0].environment_segment_keys : {}
}

# Feature Flags Module Outputs (only when feature flags module is active)
output "feature_flags" {
  description = "Complete feature flags module outputs"
  value       = length(module.feature_flags) > 0 ? module.feature_flags[0] : null
}

output "feature_flags_list" {
  description = "List of created feature flags with their details"
  value       = length(module.feature_flags) > 0 ? module.feature_flags[0].feature_flags : {}
}

output "filtered_feature_flags" {
  description = "Feature flags filtered for current environment"
  value       = length(module.feature_flags) > 0 ? module.feature_flags[0].filtered_feature_flags : []
}

output "merged_feature_flags" {
  description = "Feature flags with environment-specific configurations applied"
  value       = length(module.feature_flags) > 0 ? module.feature_flags[0].merged_feature_flags : []
}

output "feature_flags_summary" {
  description = "Summary of feature flags by lifecycle stage and category"
  value       = length(module.feature_flags) > 0 ? module.feature_flags[0].feature_flags_summary : {}
}

# Combined Outputs for Integration
output "deployment_summary" {
  description = "Summary of the complete deployment"
  value = {
    environment_name = var.environment_name
    workspace_name   = var.workspace.name
    administration = length(module.split_administration) > 0 ? {
      workspace_created   = module.split_administration[0].workspace_id != null
      environments_count  = length(module.split_administration[0].environment_ids)
      traffic_types_count = length(module.split_administration[0].traffic_type_ids)
      segments_count      = length(module.split_administration[0].segment_ids)
      api_keys_count      = length(module.split_administration[0].api_keys_count)
    } : null
    feature_flags = length(module.feature_flags) > 0 ? {
      total_flags_count       = length(module.feature_flags[0].feature_flags)
      environment_flags_count = length(module.feature_flags[0].filtered_feature_flags)
      merged_flags_count      = length(module.feature_flags[0].merged_feature_flags)
    } : null
  }
}
