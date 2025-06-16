# This configuration sets up the administrative infrastructure for a banking platform
# including workspace, environments, traffic types, attributes, segments, and API keys

module "split_administration" {
  source = "../../modules/split-administration"

  workspace                = var.workspace
  environments             = var.environments
  traffic_types            = var.traffic_types
  traffic_type_attributes  = var.traffic_type_attributes
  segments                 = var.segments
  environment_segment_keys = var.environment_segment_keys
  api_keys                 = var.api_keys
}
