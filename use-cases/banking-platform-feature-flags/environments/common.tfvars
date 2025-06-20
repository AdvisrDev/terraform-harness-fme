# Common/General Configuration for Feature Flags
# This file contains reusable values that apply across all environments

# General workspace and traffic type configuration
workspace = {
  name = "AxoltlBank"
}
traffic_type_name = "transaction"

# Base feature flags configuration (shared across environments)
feature_flags = [
  # Production-ready feature flags with environment-specific overrides
  {
    name              = "validation"
    description       = "Backend validation system"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enabled\": false}"
        description    = "Validation disabled"
      },
      {
        name           = "on"
        configurations = "{\"enabled\": true, \"strict_mode\": false}"
        description    = "Basic validation enabled"
      }
    ]
    rules = []
    # Environment-specific configurations
    environment_configs = {
      dev = {
        default_treatment = "on"
        rules = [
          {
            treatment = "on"
            size      = 100
            condition = {
              matcher = {
                type      = "IN_LIST_STRING"
                attribute = "region"
                strings   = ["monterrey"]
              }
            }
          }
        ]
      }
      staging = {
        default_treatment = "on"
        rules = [
          {
            treatment = "on"
            size      = 50
          }
        ]
      }
      prod = {
        default_treatment = "off"
        rules = [
          {
            treatment = "on"
            size      = 10
            condition = {
              matcher = {
                type      = "IN_LIST_STRING"
                attribute = "region"
                strings   = ["monterrey"]
              }
            }
          }
        ]
      }
    }
  },
  {
    name              = "offer"
    description       = "Frontend offer system"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enabled\": false}"
        description    = "Offers disabled"
      },
      {
        name           = "on"
        configurations = "{\"enabled\": true}"
        description    = "Offers enabled"
      }
    ]
    rules = []
    # Same configuration across all environments
    environment_configs = {}
  },
  {
    name              = "advanced-fraud-detection"
    description       = "AI-powered fraud detection system"
    default_treatment = "off"
    environments      = ["dev", "staging"] # Not in prod yet
    lifecycle_stage   = "development"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enabled\": false}"
        description    = "AI fraud detection disabled"
      },
      {
        name           = "basic"
        configurations = "{\"enabled\": true, \"model\": \"basic\", \"threshold\": 0.7}"
        description    = "Basic AI fraud detection"
      },
      {
        name           = "advanced"
        configurations = "{\"enabled\": true, \"model\": \"advanced\", \"threshold\": 0.85}"
        description    = "Advanced AI fraud detection"
      }
    ]
    rules = []
    # Different treatments per environment
    environment_configs = {
      dev = {
        default_treatment = "advanced"
        treatments = [
          {
            name           = "off"
            configurations = "{\"enabled\": false}"
            description    = "AI fraud detection disabled"
          },
          {
            name           = "advanced"
            configurations = "{\"enabled\": true, \"model\": \"experimental\", \"threshold\": 0.9}"
            description    = "Experimental AI fraud detection for development"
          }
        ]
        rules = [
          {
            treatment = "advanced"
            size      = 100
          }
        ]
      }
      staging = {
        default_treatment = "basic"
        rules = [
          {
            treatment = "basic"
            size      = 100
          }
        ]
      }
    }
  },
  {
    name              = "payment-gateway-fallback"
    description       = "Emergency fallback for payment gateway issues"
    default_treatment = "primary"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "killswitch"
    treatments = [
      {
        name           = "primary"
        configurations = "{\"gateway\": \"primary\", \"timeout\": 30}"
        description    = "Use primary payment gateway"
      },
      {
        name           = "fallback"
        configurations = "{\"gateway\": \"fallback\", \"timeout\": 45}"
        description    = "Use fallback payment gateway"
      },
      {
        name           = "maintenance"
        configurations = "{\"gateway\": \"none\", \"message\": \"Payments temporarily unavailable\"}"
        description    = "Payments in maintenance mode"
      }
    ]
    rules = []
    # Same configuration across all environments for kill switch
    environment_configs = {}
  }
]
