data "split_workspace" "this" {
  name = var.workspace_name
}

resource "split_environment" "this" {
  workspace_id = data.split_workspace.this.id
  name         = var.environment_name
  production   = var.is_production
}

data "split_traffic_type" "this" {
  workspace_id = data.split_workspace.this.id
  name         = var.traffic_type_name
}

# Filter feature flags based on current environment
locals {
  # Define environment creation order
  environment_order = ["dev", "staging", "prod"]

  # Get current environment position in order
  current_env_position = index(local.environment_order, var.environment_name)

  # Filter feature flags that are allowed in this environment
  # Only create flags if all preceding environments in their allowed list have been processed
  environment_feature_flags = [
    for ff in var.feature_flags : ff
    if contains(ff.environments, var.environment_name)
  ]

  # Create map for resources
  feature_flags_map = { for ff in local.environment_feature_flags : ff.name => ff }
}

resource "split_split" "this" {
  for_each        = local.feature_flags_map
  workspace_id    = data.split_workspace.this.id
  traffic_type_id = data.split_traffic_type.this.id
  name            = each.value.name
  description     = each.value.description
}

resource "split_split_definition" "this" {
  for_each = local.feature_flags_map

  workspace_id      = data.split_workspace.this.id
  environment_id    = split_environment.this.id
  split_name        = each.value.name
  default_treatment = each.value.default_treatment

  dynamic "treatment" {
    for_each = each.value.treatments
    content {
      name           = treatment.value.name
      configurations = treatment.value.configurations
      description    = treatment.value.description
    }
  }

  default_rule {
    treatment = each.value.default_treatment
    size      = 100
  }

  dynamic "rule" {
    for_each = each.value.rules
    content {
      bucket {
        treatment = rule.value.treatment != null ? rule.value.treatment : each.value.default_treatment
        size      = rule.value.size
      }

      dynamic "condition" {
        for_each = rule.value.condition != null ? [rule.value.condition] : []
        content {
          combiner = "AND"
          matcher {
            type      = condition.value.matcher.type
            attribute = condition.value.matcher.attribute
            strings   = condition.value.matcher.strings
          }
        }
      }
    }
  }
}
