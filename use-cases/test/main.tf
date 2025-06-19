# Administration-Only Use Case
# This example demonstrates how to set up only the administrative infrastructure
# using the split-administration module for basic infrastructure setup

module "split_administration" {
  source = "app.harness.io/EeRjnXTnS4GrLG5VNNJZUw/terraform-harness-fme/split"

  environment_name         = var.environment_name
  workspace                = var.workspace
  environments             = var.environments
  traffic_types            = var.traffic_types
  traffic_type_attributes  = var.traffic_type_attributes
  segments                 = var.segments
  api_keys                 = var.api_keys
  environment_segment_keys = var.environment_segment_keys
}

