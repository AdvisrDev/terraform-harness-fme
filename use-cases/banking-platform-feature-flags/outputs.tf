# Feature Flags Outputs

# Feature Flag Information
output "deployment_summary" {
  description = "All created feature flags with their details"
  value       = module.feature_flags
}

