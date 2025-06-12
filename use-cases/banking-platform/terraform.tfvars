# Banking Platform Configuration with Environment-Specific Overrides
# This file contains all shared configuration for the banking platform feature flags
# with environment-specific customizations

# Workspace Configuration
workspace_name    = "bankingdemo"
traffic_type_name = "user"

# Feature Flags Configuration with Environment-Specific Overrides
feature_flags = [
  # Production-ready feature flags with environment-specific behaviors
  {
    name              = "bankvalidation"
    description       = "Backend transaction validation system"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"validation\": false}"
        description    = "Validation disabled"
      },
      {
        name           = "on"
        configurations = "{\"validation\": true, \"strict\": false}"
        description    = "Basic validation enabled"
      }
    ]
    rules = []
    
    # Environment-specific configurations
    environment_configs = {
      # Development: More permissive validation for testing
      dev = {
        description = "Development validation system with debug logging"
        treatments = [
          {
            name           = "off"
            configurations = "{\"validation\": false, \"debug\": true}"
            description    = "Validation disabled with debug logging"
          },
          {
            name           = "on"
            configurations = "{\"validation\": true, \"strict\": false, \"debug\": true, \"bypass_limits\": true}"
            description    = "Relaxed validation with debug features"
          }
        ]
      }
      
      # Staging: Production-like validation with monitoring
      staging = {
        description = "Staging validation system with monitoring"
        treatments = [
          {
            name           = "off"
            configurations = "{\"validation\": false, \"monitoring\": true}"
            description    = "Validation disabled with monitoring"
          },
          {
            name           = "on"
            configurations = "{\"validation\": true, \"strict\": true, \"monitoring\": true}"
            description    = "Strict validation with comprehensive monitoring"
          }
        ]
      }
      
      # Production: Strict validation with security features
      prod = {
        description = "Production validation system with enhanced security"
        treatments = [
          {
            name           = "off"
            configurations = "{\"validation\": false, \"audit_log\": true}"
            description    = "Validation disabled with audit logging"
          },
          {
            name           = "on"
            configurations = "{\"validation\": true, \"strict\": true, \"audit_log\": true, \"security_enhanced\": true}"
            description    = "Maximum security validation with audit logging"
          }
        ]
        rules = [
          {
            treatment = "on"
            size      = 100
            condition = {
              matcher = {
                type      = "EQUAL_SET"
                attribute = "customerTier"
                strings   = ["premium", "corporate"]
              }
            }
          }
        ]
      }
    }
  },

  {
    name              = "harnessoffer"
    description       = "Promotional offers system"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"showOffer\": false}"
        description    = "Offers disabled"
      },
      {
        name           = "standard"
        configurations = "{\"showOffer\": true, \"offerType\": \"standard\"}"
        description    = "Standard offers"
      }
    ]
    rules = []
    
    # Environment-specific configurations
    environment_configs = {
      # Development: Extended offers for testing
      dev = {
        treatments = [
          {
            name           = "off"
            configurations = "{\"showOffer\": false, \"testMode\": true}"
            description    = "Offers disabled in test mode"
          },
          {
            name           = "standard"
            configurations = "{\"showOffer\": true, \"offerType\": \"standard\", \"testMode\": true}"
            description    = "Standard test offers"
          },
          {
            name           = "premium"
            configurations = "{\"showOffer\": true, \"offerType\": \"premium\", \"discount\": 0.25, \"testMode\": true}"
            description    = "Premium test offers with 25% discount"
          },
          {
            name           = "developer"
            configurations = "{\"showOffer\": true, \"offerType\": \"developer\", \"unlimitedCredits\": true, \"testMode\": true}"
            description    = "Developer special offers"
          }
        ]
      }
      
      # Staging: Production-like offers with analytics
      staging = {
        treatments = [
          {
            name           = "off"
            configurations = "{\"showOffer\": false, \"analytics\": true}"
            description    = "Offers disabled with analytics"
          },
          {
            name           = "standard"
            configurations = "{\"showOffer\": true, \"offerType\": \"standard\", \"analytics\": true}"
            description    = "Standard offers with analytics"
          },
          {
            name           = "premium"
            configurations = "{\"showOffer\": true, \"offerType\": \"premium\", \"discount\": 0.15, \"analytics\": true}"
            description    = "Premium offers with 15% discount and analytics"
          }
        ]
        rules = [
          {
            treatment = "premium"
            size      = 25
            condition = {
              matcher = {
                type      = "IN_SEGMENT"
                attribute = "userSegment"
                strings   = ["beta_testers"]
              }
            }
          }
        ]
      }
      
      # Production: Conservative offers with compliance
      prod = {
        treatments = [
          {
            name           = "off"
            configurations = "{\"showOffer\": false, \"compliance\": true}"
            description    = "Offers disabled with compliance tracking"
          },
          {
            name           = "standard"
            configurations = "{\"showOffer\": true, \"offerType\": \"standard\", \"compliance\": true}"
            description    = "Compliant standard offers"
          },
          {
            name           = "premium"
            configurations = "{\"showOffer\": true, \"offerType\": \"premium\", \"discount\": 0.10, \"compliance\": true, \"riskAssessment\": true}"
            description    = "Premium offers with compliance and risk assessment"
          }
        ]
        rules = [
          {
            treatment = "premium"
            size      = 10
            condition = {
              matcher = {
                type      = "IN_SEGMENT"
                attribute = "customerTier"
                strings   = ["platinum", "diamond"]
              }
            }
          }
        ]
      }
    }
  },

  # Development/Testing feature flags with progressive rollout
  {
    name              = "advanced-fraud-detection"
    description       = "AI-powered fraud detection system"
    default_treatment = "off"
    environments      = ["dev", "staging"] # Not in prod yet
    lifecycle_stage   = "testing"
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
      }
    ]
    rules = []
    
    environment_configs = {
      # Development: Full feature set for testing
      dev = {
        description = "AI fraud detection with full debugging capabilities"
        treatments = [
          {
            name           = "off"
            configurations = "{\"enabled\": false, \"debug\": true, \"logging\": \"verbose\"}"
            description    = "Disabled with verbose debugging"
          },
          {
            name           = "basic"
            configurations = "{\"enabled\": true, \"model\": \"basic\", \"threshold\": 0.5, \"debug\": true, \"mockMode\": true}"
            description    = "Basic model with debug features and mock data"
          },
          {
            name           = "advanced"
            configurations = "{\"enabled\": true, \"model\": \"advanced\", \"threshold\": 0.8, \"debug\": true, \"mockMode\": true}"
            description    = "Advanced model with debug features"
          },
          {
            name           = "experimental"
            configurations = "{\"enabled\": true, \"model\": \"experimental\", \"threshold\": 0.9, \"debug\": true, \"experimentalFeatures\": true}"
            description    = "Experimental AI model with all features"
          }
        ]
      }
      
      # Staging: Production candidate testing
      staging = {
        description = "AI fraud detection ready for production validation"
        default_treatment = "basic"
        treatments = [
          {
            name           = "off"
            configurations = "{\"enabled\": false, \"monitoring\": true}"
            description    = "Disabled with production monitoring"
          },
          {
            name           = "basic"
            configurations = "{\"enabled\": true, \"model\": \"basic\", \"threshold\": 0.7, \"monitoring\": true, \"realData\": true}"
            description    = "Basic model with real data and monitoring"
          },
          {
            name           = "advanced"
            configurations = "{\"enabled\": true, \"model\": \"advanced\", \"threshold\": 0.85, \"monitoring\": true, \"realData\": true}"
            description    = "Advanced model ready for production"
          }
        ]
        rules = [
          {
            treatment = "advanced"
            size      = 30
            condition = {
              matcher = {
                type      = "IN_SEGMENT"
                attribute = "riskProfile"
                strings   = ["high_value"]
              }
            }
          }
        ]
      }
    }
  },

  # Experimental features (dev only) with development-specific configuration
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
        name           = "basic"
        configurations = "{\"voice_enabled\": true, \"commands\": [\"balance\"]}"
        description    = "Basic voice commands"
      }
    ]
    rules = []
    
    environment_configs = {
      # Development: Full experimental feature set
      dev = {
        description = "Experimental voice banking with full command set"
        treatments = [
          {
            name           = "off"
            configurations = "{\"voice_enabled\": false, \"debug\": true, \"simulator\": true}"
            description    = "Voice banking disabled with simulator"
          },
          {
            name           = "basic"
            configurations = "{\"voice_enabled\": true, \"commands\": [\"balance\", \"history\"], \"debug\": true, \"simulator\": true}"
            description    = "Basic commands with debug simulator"
          },
          {
            name           = "advanced"
            configurations = "{\"voice_enabled\": true, \"commands\": [\"balance\", \"history\", \"transfer\", \"pay\"], \"debug\": true, \"simulator\": true, \"nlp_enhanced\": true}"
            description    = "Advanced commands with NLP and simulator"
          },
          {
            name           = "full"
            configurations = "{\"voice_enabled\": true, \"commands\": [\"balance\", \"history\", \"transfer\", \"pay\", \"invest\", \"support\"], \"debug\": true, \"simulator\": true, \"nlp_enhanced\": true, \"multiLanguage\": true}"
            description    = "Full voice banking suite with all features"
          }
        ]
        rules = [
          {
            treatment = "advanced"
            size      = 50
            condition = {
              matcher = {
                type      = "IN_SEGMENT"
                attribute = "employeeType"
                strings   = ["developer", "qa"]
              }
            }
          }
        ]
      }
    }
  },

  # Operational/Kill switch flags with environment-specific timeouts
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
      }
    ]
    rules = []
    
    environment_configs = {
      # Development: Extended timeouts and mock gateways
      dev = {
        treatments = [
          {
            name           = "primary"
            configurations = "{\"gateway\": \"primary_mock\", \"timeout\": 60, \"debug\": true, \"mockMode\": true}"
            description    = "Mock primary gateway with extended timeout"
          },
          {
            name           = "fallback"
            configurations = "{\"gateway\": \"fallback_mock\", \"timeout\": 90, \"debug\": true, \"mockMode\": true}"
            description    = "Mock fallback gateway with extended timeout"
          },
          {
            name           = "maintenance"
            configurations = "{\"gateway\": \"none\", \"message\": \"Dev environment - payments simulated\", \"debug\": true}"
            description    = "Development maintenance mode"
          }
        ]
      }
      
      # Staging: Production-like with monitoring
      staging = {
        treatments = [
          {
            name           = "primary"
            configurations = "{\"gateway\": \"primary_staging\", \"timeout\": 30, \"monitoring\": true, \"alerting\": true}"
            description    = "Staging primary gateway with monitoring"
          },
          {
            name           = "fallback"
            configurations = "{\"gateway\": \"fallback_staging\", \"timeout\": 45, \"monitoring\": true, \"alerting\": true}"
            description    = "Staging fallback gateway with monitoring"
          },
          {
            name           = "maintenance"
            configurations = "{\"gateway\": \"none\", \"message\": \"Staging maintenance - please try again later\", \"monitoring\": true}"
            description    = "Staging maintenance mode with monitoring"
          }
        ]
      }
      
      # Production: Optimized timeouts with full monitoring
      prod = {
        treatments = [
          {
            name           = "primary"
            configurations = "{\"gateway\": \"primary_prod\", \"timeout\": 20, \"monitoring\": true, \"alerting\": true, \"sla_tracking\": true}"
            description    = "Production primary gateway with SLA tracking"
          },
          {
            name           = "fallback"
            configurations = "{\"gateway\": \"fallback_prod\", \"timeout\": 30, \"monitoring\": true, \"alerting\": true, \"sla_tracking\": true}"
            description    = "Production fallback gateway with SLA tracking"
          },
          {
            name           = "maintenance"
            configurations = "{\"gateway\": \"none\", \"message\": \"Payments temporarily unavailable\", \"monitoring\": true, \"customer_notification\": true}"
            description    = "Production maintenance with customer notifications"
          }
        ]
      }
    }
  }
]