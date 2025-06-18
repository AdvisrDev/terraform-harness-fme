# Production Environment - Specific Configuration  
# This file contains environment-specific configurations for production

# Environment name
environment_name = "prod"

# Production-specific feature flags (minimal and conservative)
feature_flags = [
  {
    name              = "security-enhancement"
    description       = "Security enhancement features"
    default_treatment = "off"
    environments      = ["prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enhanced_security\": false}"
        description    = "Standard security"
      },
      {
        name           = "on"
        configurations = "{\"enhanced_security\": true, \"strict_mode\": true}"
        description    = "Enhanced security enabled"
      }
    ]
    rules = [
      {
        treatment = "on"
        size      = 5 # Very conservative rollout
      }
    ]
  }
]
