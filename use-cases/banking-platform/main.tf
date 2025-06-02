module "banking_feature_flags" {
  source = "../../modules/split-feature-flags"

  workspace_name    = var.workspace_name
  environment_name  = var.environment_name
  is_production     = var.is_production
  traffic_type_name = var.traffic_type_name
  feature_flags     = var.feature_flags
}
