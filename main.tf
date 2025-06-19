module "split_administration" {
  source = "app.harness.io/EeRjnXTnS4GrLG5VNNJZUw/terraform-harness-fme/split//modules/split-administration"
  count  = length(var.feature_flags) == 0 ? 1 : 0

  environment_name         = var.environment_name
  workspace                = var.workspace
  environments             = var.environments
  traffic_types            = var.traffic_types
  traffic_type_attributes  = var.traffic_type_attributes
  segments                 = var.segments
  environment_segment_keys = var.environment_segment_keys
  api_keys                 = var.api_keys
}

module "feature_flags" {
  source = "app.harness.io/EeRjnXTnS4GrLG5VNNJZUw/terraform-harness-fme/split//modules/split-feature-flags"
  count  = length(var.feature_flags) > 0 ? 1 : 0

  workspace         = var.workspace
  environment_name  = var.environment_name
  traffic_type_name = var.traffic_type_name
  feature_flags     = var.feature_flags
}
