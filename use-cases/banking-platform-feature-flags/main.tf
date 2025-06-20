# Feature Flags Module
module "feature_flags" {
  source  = "app.harness.io/EeRjnXTnS4GrLG5VNNJZUw/terraform-harness-fme/split"
  version = "v2.0.6"

  workspace         = var.workspace
  environment_name  = var.environment_name
  traffic_type_name = var.traffic_type_name
  feature_flags     = var.feature_flags
}
