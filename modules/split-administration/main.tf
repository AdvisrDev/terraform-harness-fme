# Workspace Management
resource "split_workspace" "this" {
  count = var.workspace.create_workspace ? 1 : 0
  name  = var.workspace.name
}

data "split_workspace" "this" {
  count = var.workspace.create_workspace ? 0 : 1
  name  = var.workspace.name
}

locals {
  workspace_id = var.workspace.create_workspace ? split_workspace.this[0].id : data.split_workspace.this[0].id
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
  for_each = var.segments

  workspace_id   = local.workspace_id
  environment_id = split_environment.this[keys(var.environments)[0]].id
  segment_name   = each.value.name
  depends_on     = [split_segment.this, split_environment.this]
}

# Environment Segment Keys Management
resource "split_environment_segment_keys" "this" {
  for_each = var.environment_segment_keys

  environment_id = split_environment.this[each.value.environment_key].id
  segment_name   = each.value.segment_name
  keys           = each.value.keys

  depends_on = [split_segment_environment_association.this]
}

# API Keys Management
resource "split_api_key" "this" {
  for_each = var.api_keys

  workspace_id    = local.workspace_id
  environment_ids = tolist([split_environment.this[each.value.environment_key].id])
  name            = each.value.name
  type            = each.value.type
  roles           = each.value.roles
}
