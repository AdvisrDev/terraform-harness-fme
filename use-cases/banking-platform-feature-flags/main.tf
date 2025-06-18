# This configuration manages feature flags using the administration infrastructure

# Feature Flags Module
module "feature_flags" {
  source = "../../modules/split-feature-flags"

  workspace_name    = var.workspace_name
  environment_name  = var.environment_name
  traffic_type_name = var.traffic_type_name
  feature_flags     = var.feature_flags
}
