module "simple_feature_flags" {
  source = "../../modules/split-feature-flags"

  split_api_key       = var.split_api_key
  workspace_name      = "Default"
  environment_name    = "development"
  is_production      = false
  traffic_type_name  = "user"

  feature_flags = [
    {
      name              = "simple-toggle"
      description       = "A simple on/off feature toggle"
      default_treatment = "off"
      treatments = [
        {
          name           = "off"
          configurations = "{\"enabled\": false}"
          description    = "Feature is disabled"
        },
        {
          name           = "on"
          configurations = "{\"enabled\": true}"
          description    = "Feature is enabled"
        }
      ]
      rules = []
    }
  ]
}