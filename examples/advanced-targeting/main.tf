module "advanced_feature_flags" {
  source = "../../modules/split-feature-flags"

  split_api_key       = var.split_api_key
  workspace_name      = "Default"
  environment_name    = "production"
  is_production      = true
  traffic_type_name  = "user"

  feature_flags = [
    {
      name              = "premium-features"
      description       = "Premium features with advanced targeting"
      default_treatment = "basic"
      treatments = [
        {
          name           = "basic"
          configurations = "{\"tier\": \"basic\", \"features\": [\"feature1\"]}"
          description    = "Basic tier features"
        },
        {
          name           = "premium"
          configurations = "{\"tier\": \"premium\", \"features\": [\"feature1\", \"feature2\", \"feature3\"]}"
          description    = "Premium tier with all features"
        },
        {
          name           = "enterprise"
          configurations = "{\"tier\": \"enterprise\", \"features\": [\"feature1\", \"feature2\", \"feature3\", \"enterprise_feature\"]}"
          description    = "Enterprise tier with advanced features"
        }
      ]
      rules = [
        {
          treatment = "enterprise"
          size      = 100
          condition = {
            matcher = {
              type      = "IN_SEGMENT"
              attribute = "user_segment"
              strings   = ["enterprise_users"]
            }
          }
        },
        {
          treatment = "premium"
          size      = 100
          condition = {
            matcher = {
              type      = "IN_SEGMENT"
              attribute = "user_segment"
              strings   = ["premium_users"]
            }
          }
        }
      ]
    },
    {
      name              = "beta-experiment"
      description       = "A/B test for new feature"
      default_treatment = "control"
      treatments = [
        {
          name           = "control"
          configurations = "{\"variant\": \"control\", \"new_ui\": false}"
          description    = "Control group - existing experience"
        },
        {
          name           = "treatment_a"
          configurations = "{\"variant\": \"treatment_a\", \"new_ui\": true, \"color_scheme\": \"blue\"}"
          description    = "Treatment A - blue UI variant"
        },
        {
          name           = "treatment_b"
          configurations = "{\"variant\": \"treatment_b\", \"new_ui\": true, \"color_scheme\": \"green\"}"
          description    = "Treatment B - green UI variant"
        }
      ]
      rules = [
        {
          treatment = "treatment_a"
          size      = 40
          condition = {
            matcher = {
              type      = "IN_SEGMENT"
              attribute = "user_segment"
              strings   = ["beta_testers"]
            }
          }
        },
        {
          treatment = "treatment_b"
          size      = 40
          condition = {
            matcher = {
              type      = "IN_SEGMENT"
              attribute = "user_segment"
              strings   = ["beta_testers"]
            }
          }
        }
      ]
    }
  ]
}