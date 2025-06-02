output "workspace_id" {
  description = "Split.io workspace ID"
  value       = module.banking_feature_flags.workspace_id
}

output "environment_id" {
  description = "Split.io environment ID"
  value       = module.banking_feature_flags.environment_id
}

output "environment_name" {
  description = "Split.io environment name"
  value       = module.banking_feature_flags.environment_name
}

output "traffic_type_id" {
  description = "Split.io traffic type ID"
  value       = module.banking_feature_flags.traffic_type_id
}

output "banking_feature_flags" {
  description = "Created banking feature flags with their details"
  value       = module.banking_feature_flags.feature_flags
}

output "banking_feature_flag_definitions" {
  description = "Banking feature flag definitions with environment-specific settings"
  value       = module.banking_feature_flags.feature_flag_definitions
}