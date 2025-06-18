# Workspace Management
resource "split_workspace" "this" {
  count = var.workspace.create_workspace ? 1 : 0
  name  = var.workspace.name
}

data "split_workspace" "this" {
  count = var.workspace.create_workspace ? 0 : 1
  name  = var.workspace.name
}

data "split_environment" "this" {
  count        = var.environment_name != "common" ? 1 : 0
  workspace_id = local.workspace_id
  name         = var.environment_name
}

locals {
  workspace_id   = var.workspace.create_workspace ? split_workspace.this[0].id : data.split_workspace.this[0].id
  environment_id = var.environment_name != "common" ? data.split_environment.this[0].id : "N/A"

  # Filter API keys that are allowed in this environment (similar to feature flags pattern)
  environment_api_keys = [
    for key in var.api_keys : key
    if length(key.environments) == 0 || contains(key.environments, var.environment_name)
  ]

  # Merge base API key configuration with environment-specific overrides
  merged_api_keys = [
    for key in local.environment_api_keys : {
      name  = try(key.environment_configs[var.environment_name].name, key.name)
      type  = try(key.environment_configs[var.environment_name].type, key.type)
      roles = try(key.environment_configs[var.environment_name].roles, key.roles)
      # Store original for reference
      _original_config    = key
      _environment_config = try(key.environment_configs[var.environment_name], null)
    }
  ]

  # Create map for API key resources
  api_keys_map = { for idx, key in local.merged_api_keys : "${var.environment_name}_${key.name}" => key }

  # Filter environment segment keys that are allowed in this environment
  environment_segment_keys = [
    for esk in var.environment_segment_keys : esk
    if length(esk.environments) == 0 || contains(esk.environments, var.environment_name)
  ]

  # Merge base environment segment keys configuration with environment-specific overrides
  merged_environment_segment_keys = [
    for esk in local.environment_segment_keys : {
      name           = esk.name
      segment_name   = esk.segment_name
      keys           = try(esk.environment_configs[var.environment_name].keys, esk.keys)
      environment_id = local.environment_id
      # Store original for reference
      _original_config    = esk
      _environment_config = try(esk.environment_configs[var.environment_name], null)
    }
  ]

  # Create map for environment segment key resources
  environment_segment_keys_map = { for esk in local.merged_environment_segment_keys : esk.name => esk }
}

# Environment Management
resource "split_environment" "this" {
  for_each = var.environments

  workspace_id = local.workspace_id
  name         = each.value.name
  production   = each.value.production
}

# Traffic Type Management
resource "split_traffic_type" "this" {
  for_each = var.traffic_types

  workspace_id = local.workspace_id
  name         = each.value.name
}

resource "split_traffic_type_attribute" "this" {
  for_each = var.traffic_type_attributes

  workspace_id     = local.workspace_id
  traffic_type_id  = split_traffic_type.this[each.value.traffic_type_key].id
  identifier       = each.value.id
  display_name     = each.value.display_name
  description      = each.value.description
  data_type        = upper(each.value.data_type)
  is_searchable    = each.value.is_searchable
  suggested_values = each.value.suggested_values
}

# Segment Management
resource "split_segment" "this" {
  for_each = var.segments

  workspace_id    = local.workspace_id
  traffic_type_id = split_traffic_type.this[each.value.traffic_type_key].id
  name            = each.value.name
  description     = each.value.description
}

resource "split_segment_environment_association" "this" {
  for_each = local.environment_segment_keys_map

  workspace_id   = local.workspace_id
  environment_id = each.value.environment_id
  segment_name   = each.value.segment_name
  depends_on     = [split_segment.this, split_environment.this]
}

# Environment Segment Keys Management
resource "split_environment_segment_keys" "this" {
  for_each = local.environment_segment_keys_map

  environment_id = local.environment_id
  segment_name   = each.value.segment_name
  keys           = each.value.keys

  depends_on = [split_segment_environment_association.this]
}

# API Keys Management
resource "split_api_key" "this" {
  for_each = local.api_keys_map

  workspace_id    = local.workspace_id
  environment_ids = tolist([local.environment_id])
  name            = each.value.name
  type            = each.value.type
  roles           = each.value.roles
}
