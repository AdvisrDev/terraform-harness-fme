output "feature_flags_summary" {
  description = "Summary of feature flags in this environment"
  value       = module.lifecycle_example.feature_flags_summary
}

output "filtered_feature_flags" {
  description = "Feature flags active in this environment"
  value = {
    for ff in module.lifecycle_example.filtered_feature_flags : ff.name => {
      lifecycle_stage = ff.lifecycle_stage
      category       = ff.category
      environments   = ff.environments
    }
  }
}