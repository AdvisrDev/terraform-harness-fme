# Workspace Outputs
output "workspace_id" {
  description = "Split.io workspace ID"
  value       = local.workspace_id
}

output "workspace_name" {
  description = "Split.io workspace name"
  value       = var.workspace.name
}

output "workspace_created" {
  description = "Whether workspace was created by this module"
  value       = var.workspace.create_workspace
}

output "environment_ids" {
  description = "Map of environment keys to IDs"
  value = var.environment_name != "common" ? { var.environment_name = data.split_environment.this[0].id } : {
    for key, env in split_environment.this : key => env.id
  }
}

output "traffic_type_ids" {
  description = "Map of traffic type keys to IDs"
  value = {
    for key, tt in split_traffic_type.this : key => tt.id
  }
}

output "segment_ids" {
  description = "Map of segment keys to IDs"
  value = {
    for key, segment in split_segment.this : key => segment.id
  }
}

# Environment Segment Keys Outputs
output "environment_segment_keys" {
  description = "Environment segment keys configuration"
  value = {
    for key, esk in split_environment_segment_keys.this : key => {
      environment_id = esk.environment_id
      segment_name   = esk.segment_name
      keys_count     = length(esk.keys)
    }
  }
}

# API Keys Outputs
output "api_keys" {
  description = "Created API keys with their details (excluding sensitive values)"
  value = {
    for key, api_key in split_api_key.this : key => {
      id             = api_key.id
      name           = api_key.name
      type           = api_key.type
      roles          = api_key.roles
      environment_id = api_key.environment_id
    }
  }
  sensitive = true
}

output "api_key_ids" {
  description = "Map of API key names to IDs"
  value = {
    for key, api_key in split_api_key.this : key => api_key.id
  }
  sensitive = true
}
