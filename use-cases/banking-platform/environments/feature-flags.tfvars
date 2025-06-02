split_api_key = "lknvbup9uj2too2vmoksap88ohprjguomkub"

# Workspace Configuration
workspace_name    = "Default"
traffic_type_name = "user"

# Feature Flags Configuration
feature_flags = [
  # Production-ready feature flags
  {
    name              = "bankvalidation"
    description       = "backend FF demo"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"key\":\"value\"}"
        description    = "bankvalidation off"
      },
      {
        name           = "on"
        configurations = "{\"key2\":\"value2\"}"
        description    = "bankvalidation goes through a validation in order to process the transactions"
      }
    ]
    rules = [
      {
        condition = {
          matcher = {
            type      = "EQUAL_SET"
            attribute = "customerID"
            strings   = ["user123"]
          }
        }
      }
    ]
  },
  {
    name              = "harnessoffer"
    description       = "frontend FF demo"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"key\":\"value\"}"
        description    = "bankvalidation off"
      },
      {
        name           = "on"
        configurations = "{\"key2\":\"value2\"}"
        description    = "bankvalidation goes through a validation in order to process the transactions"
      }
    ]
    rules = []
  },

  # Development/Testing feature flags (not ready for production)
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
    rules = [
      {
        condition = {
          matcher = {
            type      = "EQUAL_SET"
            attribute = "customerID"
            strings   = ["user123"]
          }
        }
      }
    ]
  },

  # Experimental features (dev only)
  {
    name              = "voice-banking-beta"
    description       = "Voice-activated banking commands (experimental)"
    default_treatment = "off"
    environments      = ["dev"] # Dev only for now
    lifecycle_stage   = "development"
    category          = "experiment"
    treatments = [
      {
        name           = "off"
        configurations = "{\"voice_enabled\": false}"
        description    = "Voice banking disabled"
      },
      {
        name           = "on"
        configurations = "{\"voice_enabled\": true, \"commands\": [\"balance\", \"transfer\"]}"
        description    = "Voice banking enabled with basic commands"
      }
    ]
    rules = []
  },

  # Operational/Kill switch flags (all environments)
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
  }
]
