# Feature Flags Outputs

# Feature Flag Information
output "feature_flags" {
  description = "All created feature flags with their details"
  value       = module.feature_flags.feature_flags
}

# Feature Flag Statistics
output "feature_flag_statistics" {
  description = "Statistics about the created feature flags"
  value = {
    total_features       = length(module.feature_flags.feature_flags)
    environment_features = length(var.feature_flags)
  }
}

