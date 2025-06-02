output "feature_flags" {
  description = "Created feature flags with advanced targeting"
  value       = module.advanced_feature_flags.feature_flags
}

output "feature_flag_definitions" {
  description = "Feature flag definitions with targeting rules"
  value       = module.advanced_feature_flags.feature_flag_definitions
}