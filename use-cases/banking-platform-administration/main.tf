# This configuration sets up the administrative infrastructure
# including workspace, environments, traffic types, attributes, segments, and API keys

module "banking_platform_administration" {
  source  = "app.harness.io/EeRjnXTnS4GrLG5VNNJZUw/terraform-harness-fme/split"
  version = "v2.0.6"

  environment_name         = var.environment_name
  workspace                = var.workspace
  environments             = var.environments
  traffic_types            = var.traffic_types
  traffic_type_attributes  = var.traffic_type_attributes
  segments                 = var.segments
  environment_segment_keys = var.environment_segment_keys
  api_keys                 = var.api_keys

  # Empty feature_flags triggers administration-only mode
  feature_flags = []
}
