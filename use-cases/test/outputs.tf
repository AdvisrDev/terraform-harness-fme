# Administration-Only Outputs
# Outputs for the administrative infrastructure setup

output "workspace_id" {
  description = "Harness FME workspace ID"
  value       = module.fme_administration.workspace_id
}

output "environment_ids" {
  description = "Map of environment names to their IDs"
  value       = module.fme_administration.environment_ids
}

output "traffic_type_ids" {
  description = "Map of traffic type names to their IDs"
  value       = module.fme_administration.traffic_type_ids
}

output "segment_ids" {
  description = "Map of segment names to their IDs"
  value       = module.fme_administration.segment_ids
}

output "api_keys" {
  description = "Created API keys with their details"
  value       = module.fme_administration.api_keys
  sensitive   = true
}

output "environment_segment_keys" {
  description = "Created environment segment keys"
  value       = module.fme_administration.environment_segment_keys
}

# Summary output for integration with feature flags modules
output "infrastructure_summary" {
  description = "Summary of created infrastructure for use with feature flags modules"
  value = {
    workspace_name        = var.workspace.name
    environment_name      = var.environment_name
    available_environments = keys(var.environments)
    available_traffic_types = keys(var.traffic_types)
    available_segments     = keys(var.segments)
  }
}