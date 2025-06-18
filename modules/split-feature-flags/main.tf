data "split_workspace" "this" {
  count = var.workspace_id == "-" ? 1 : 0
  name  = var.workspace_name
}

data "split_environment" "this" {
  count        = var.environment_id == "-" ? 1 : 0
  workspace_id = local.workspace_id
  name         = var.environment_name
}

data "split_traffic_type" "this" {
  count        = var.traffic_type_id == "-" ? 1 : 0
  workspace_id = local.workspace_id
  name         = var.traffic_type_name
}

locals {
  workspace_id    = var.workspace_id == "-" ? data.split_workspace.this[0].id : var.workspace_id
  environment_id  = var.environment_id == "-" ? data.split_environment.this[0].id : var.environment_id
  traffic_type_id = var.traffic_type_id == "-" ? data.split_traffic_type.this[0].id : var.traffic_type_id

  # Filter feature flags that are allowed in this environment
  environment_feature_flags = [
    for ff in var.feature_flags : ff
    if contains(ff.environments, var.environment_name)
  ]

  # Merge base configuration with environment-specific overrides
  merged_feature_flags = [
    for ff in local.environment_feature_flags : {
      name = ff.name
      # Use environment-specific description if available, otherwise use base description
      description = coalesce(try(ff.environment_configs[var.environment_name].description, null), ff.description)
      # Use environment-specific default_treatment if available, otherwise use base default_treatment
      default_treatment = coalesce(try(ff.environment_configs[var.environment_name].default_treatment, null), ff.default_treatment)
      lifecycle_stage   = ff.lifecycle_stage
      category          = ff.category
      # Use environment-specific treatments if available, otherwise use base treatments
      treatments = coalesce(try(ff.environment_configs[var.environment_name].treatments, null), ff.treatments)
      # Use environment-specific rules if available, otherwise use base rules
      rules = coalesce(try(ff.environment_configs[var.environment_name].rules, null), ff.rules)
      # Store original for reference
      _original_config    = ff
      _environment_config = try(ff.environment_configs[var.environment_name], null)
    }
  ]

  # Create map for resources
  feature_flags_map = { for ff in local.merged_feature_flags : ff.name => ff }
}

resource "split_split" "this" {
  for_each        = local.feature_flags_map
  workspace_id    = local.workspace_id
  traffic_type_id = local.traffic_type_id
  name            = each.value.name
  description     = each.value.description
}

resource "split_split_definition" "this" {
  depends_on = [split_split.this]
  for_each   = {} #local.feature_flags_map

  workspace_id      = local.workspace_id
  environment_id    = local.environment_id
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
