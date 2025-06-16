# This configuration manages feature flags for a banking platform
# using the administration infrastructure created by banking-platform-administration

# Banking Platform Feature Flags
module "banking_feature_flags" {
  source = "../../modules/split-feature-flags"

  workspace_name    = var.workspace_name
  environment_name  = var.environment_name
  traffic_type_name = var.traffic_type_name
  feature_flags     = var.feature_flags
}
