# Staging Environment - Specific Configuration
# This file contains environment-specific configurations for staging

# Environment name
environment_name = "staging"

# Staging-specific feature flags (not yet ready for production)
feature_flags = [
  {
    name              = "biometric-auth-beta"
    description       = "Biometric authentication system (staging testing)"
    default_treatment = "off"
    environments      = ["staging"] # Staging only for now
    lifecycle_stage   = "testing"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"biometric_enabled\": false}"
        description    = "Biometric authentication disabled"
      },
      {
        name           = "on"
        configurations = "{\"biometric_enabled\": true, \"fallback\": true}"
        description    = "Biometric authentication enabled with fallback"
      }
    ]
    rules = [
      {
        treatment = "on"
        size      = 25
      }
    ]
  },
  {
    name              = "enhanced-analytics"
    description       = "Enhanced analytics dashboard"
    default_treatment = "basic"
    environments      = ["staging", "prod"]
    lifecycle_stage   = "testing"
    category          = "feature"
    treatments = [
      {
        name           = "basic"
        configurations = "{\"analytics_level\": \"basic\"}"
        description    = "Basic analytics"
      },
      {
        name           = "enhanced"
        configurations = "{\"analytics_level\": \"enhanced\", \"real_time\": true}"
        description    = "Enhanced real-time analytics"
      }
    ]
    rules = []
  }
]
