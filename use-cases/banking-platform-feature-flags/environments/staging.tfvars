# Banking Platform Feature Flags - Staging Environment

# Organization Configuration (must match administration setup)
organization_name = "SecureBank"
platform_owner    = "platform-engineering@securebank.com"
primary_region   = "us-east-1"

# Administration Integration (from staging administration outputs)
# These should be populated from banking-platform-administration staging outputs
workspace_id     = ""  # To be filled from administration module
environment_id   = ""  # To be filled from administration module
environment_name = "staging"
traffic_type_id  = ""  # To be filled from administration module (customer traffic type)

# Feature Flag Configuration (production-like for staging)
feature_rollout_strategy = "gradual"
max_rollout_percentage   = 50
enable_kill_switch      = true

# Banking Feature Categories (production subset for staging)
banking_feature_categories = [
  "customer-experience",
  "security", 
  "compliance",
  "analytics",
  "payments"
]

# Feature Category Toggles (balanced for staging)
security_features_enabled    = true
compliance_features_enabled  = true
ai_features_enabled         = true

# Environment-specific Overrides (staging-focused)
environment_feature_overrides = {
  staging = {
    default_treatment        = "off"
    max_rollout_percentage   = 50
    enable_advanced_features = false
    automated_rollback      = true
  }
}


# Feature-specific Configuration (production-like for staging)
biometric_auth_config = {
  enabled              = true
  supported_auth_types = ["fingerprint", "face_id"]
  fallback_enabled     = true
  timeout_seconds      = 30
}

fraud_detection_config = {
  enabled              = true
  ml_models           = ["behavioral", "network", "device"]
  confidence_threshold = 0.8
  real_time_scoring   = true
}

compliance_config = {
  kyc_enhanced_enabled = true
  gdpr_tools_enabled   = true
  automated_reporting  = true
  audit_trail_enabled  = true
}

# Targeting Configuration (subset targeting for staging)
segment_targeting_enabled = true

high_value_customer_features = [
  "robo_advisor",
  "instant_transfers", 
  "enhanced_mobile_dashboard"
]

compliance_customer_features = [
  "enhanced_kyc_verification",
  "gdpr_compliance_tools"
]

# Performance Configuration (production-like for staging)
feature_flag_cache_ttl = 300    # 5 minutes like production

# Additional Tags
additional_tags = {
  Department        = "Banking Technology"
  Application       = "Digital Banking Platform"
  Environment       = "Staging"
  Criticality      = "High"
  DataClassification = "Production-like"
  FeatureFlags     = "Staging"
  SecurityLevel   = "High"
  ComplianceLevel = "Enhanced"
}