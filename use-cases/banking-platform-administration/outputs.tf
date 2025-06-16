# Workspace Information
output "workspace_id" {
  description = "The ID of the banking platform workspace"
  value       = module.split_administration.workspace_id
}

output "workspace_name" {
  description = "The name of the banking platform workspace"
  value       = module.split_administration.workspace_name
}

output "workspace_created" {
  description = "Whether the workspace was created by this module"
  value       = module.split_administration.workspace_created
}

output "environment_ids" {
  description = "Map of environment keys to IDs for easy reference"
  value       = module.split_administration.environment_ids
}

# Traffic Type Information
output "traffic_type_ids" {
  description = "Map of traffic type keys to IDs for easy reference"
  value       = module.split_administration.traffic_type_ids
}

# Segment Information
output "segment_ids" {
  description = "Map of segment keys to IDs for easy reference"
  value       = module.split_administration.segment_ids
}

# API Key Information (sensitive)
output "api_keys" {
  description = "Created banking API keys with their details (excluding sensitive values)"
  value       = module.split_administration.api_keys
  sensitive   = true
}

output "api_key_ids" {
  description = "Map of API key names to IDs"
  value       = module.split_administration.api_key_ids
  sensitive   = true
}
