# Outputs for the simple administration setup

output "workspace_id" {
  description = "The ID of the created Split.io workspace"
  value       = module.split_administration.workspace_id
}

output "workspace_name" {
  description = "The name of the Split.io workspace"
  value       = module.split_administration.workspace_name
}

output "environments" {
  description = "Map of created environments"
  value       = module.split_administration.environments
}

output "environment_ids" {
  description = "Map of environment names to IDs for easy reference"
  value       = module.split_administration.environment_ids
}

output "traffic_types" {
  description = "Map of created traffic types"
  value       = module.split_administration.traffic_types
}

output "traffic_type_ids" {
  description = "Map of traffic type names to IDs for easy reference"
  value       = module.split_administration.traffic_type_ids
}

output "segments" {
  description = "Map of created segments"
  value       = module.split_administration.segments
}

output "segment_ids" {
  description = "Map of segment names to IDs for easy reference"
  value       = module.split_administration.segment_ids
}

output "api_keys" {
  description = "Created API keys (sensitive information redacted)"
  value       = module.split_administration.api_keys
  sensitive   = true
}

output "administration_summary" {
  description = "Summary of all created administration resources"
  value       = module.split_administration.administration_summary
}

output "feature_flag_inputs" {
  description = "Structured data for consumption by feature flag modules"
  value       = module.split_administration.feature_flag_inputs
}