module "lifecycle_example" {
  source = "../../modules/split-feature-flags"

  workspace_name    = "Default"
  environment_name  = var.environment_name
  is_production     = var.is_production
  traffic_type_name = "user"

  feature_flags = [
    # Example: Feature progressing through lifecycle stages
    {
      name              = "new-checkout-flow"
      description       = "Redesigned checkout experience"
      default_treatment = "off"
      # Start in dev only, then promote through environments
      environments      = var.environment_name == "dev" ? ["dev"] : 
                         var.environment_name == "staging" ? ["dev", "staging"] :
                         ["dev", "staging", "prod"]
      lifecycle_stage   = "development"  # Will change to testing -> staging -> production
      category          = "feature"
      treatments = [
        {
          name           = "off"
          configurations = "{\"new_checkout\": false}"
          description    = "Use existing checkout flow"
        },
        {
          name           = "on"
          configurations = "{\"new_checkout\": true, \"analytics\": true}"
          description    = "Use new checkout flow with analytics"
        }
      ]
      rules = []
    },
    
    # Example: Experimental feature (dev/staging only)
    {
      name              = "ml-product-recommendations"
      description       = "Machine learning product recommendations"
      default_treatment = "off"
      environments      = ["dev", "staging"]  # Never in prod until ready
      lifecycle_stage   = "development"
      category          = "experiment"
      treatments = [
        {
          name           = "off"
          configurations = "{\"ml_recommendations\": false}"
          description    = "No ML recommendations"
        },
        {
          name           = "basic"
          configurations = "{\"ml_recommendations\": true, \"model\": \"collaborative_filtering\"}"
          description    = "Basic collaborative filtering"
        },
        {
          name           = "advanced"
          configurations = "{\"ml_recommendations\": true, \"model\": \"deep_learning\"}"
          description    = "Advanced deep learning model"
        }
      ]
      rules = [
        {
          treatment = "basic"
          size      = 30
          condition = {
            matcher = {
              type      = "IN_SEGMENT"
              attribute = "user_segment"
              strings   = ["beta_testers"]
            }
          }
        }
      ]
    },
    
    # Example: Kill switch (all environments)
    {
      name              = "external-api-circuit-breaker"
      description       = "Circuit breaker for external API calls"
      default_treatment = "enabled"
      environments      = ["dev", "staging", "prod"]
      lifecycle_stage   = "production"
      category          = "killswitch"
      treatments = [
        {
          name           = "enabled"
          configurations = "{\"circuit_breaker\": true, \"threshold\": 50, \"timeout\": 60}"
          description    = "Circuit breaker enabled"
        },
        {
          name           = "disabled"
          configurations = "{\"circuit_breaker\": false}"
          description    = "Circuit breaker disabled"
        },
        {
          name           = "aggressive"
          configurations = "{\"circuit_breaker\": true, \"threshold\": 20, \"timeout\": 30}"
          description    = "Aggressive circuit breaker settings"
        }
      ]
      rules = []
    }
  ]
}