# Banking Platform Feature Flags - Production Environment

# Organization Configuration (must match administration setup)
organization_name = "SecureBank"
platform_owner    = "platform-engineering@securebank.com"
primary_region   = "us-east-1"

# Administration Integration (from production administration outputs)
# These should be populated from banking-platform-administration production outputs
workspace_id     = ""  # To be filled from administration module
environment_id   = ""  # To be filled from administration module
environment_name = "production"
traffic_type_id  = ""  # To be filled from administration module (customer traffic type)

# Feature Flag Configuration (conservative for production)
feature_rollout_strategy = "conservative"
max_rollout_percentage   = 10   # Very conservative rollouts
enable_kill_switch      = true

# Banking Feature Categories (core features only for production)
banking_feature_categories = [
  "customer-experience",
  "security", 
  "compliance",
  "payments"
]

# Feature Category Toggles (security and compliance focused)
security_features_enabled    = true
compliance_features_enabled  = true
ai_features_enabled         = false  # Disabled for production initially

# Environment-specific Overrides (production-focused)
environment_feature_overrides = {
  production = {
    default_treatment        = "off"
    max_rollout_percentage   = 10
    enable_advanced_features = false
    automated_rollback      = true
  }
}


# Feature-specific Configuration (strict for production)
biometric_auth_config = {
  enabled              = true
  supported_auth_types = ["fingerprint"]  # Conservative approach
  fallback_enabled     = true
  timeout_seconds      = 30
}

fraud_detection_config = {
  enabled              = true
  ml_models           = ["behavioral", "network"]  # Proven models only
  confidence_threshold = 0.9  # High confidence required
  real_time_scoring   = true
}

compliance_config = {
  kyc_enhanced_enabled = true
  gdpr_tools_enabled   = true
  automated_reporting  = true
  audit_trail_enabled  = true
}

# Targeting Configuration (segment-based for production)
segment_targeting_enabled = true

high_value_customer_features = [
  "enhanced_mobile_dashboard",
  "instant_transfers"  # Conservative list for production
]

compliance_customer_features = [
  "enhanced_kyc_verification",
  "gdpr_compliance_tools"
]

# Performance Configuration (optimized for production)
feature_flag_cache_ttl = 300    # 5 minutes for stability

# Additional Tags
additional_tags = {
  Department        = "Banking Technology"
  Application       = "Digital Banking Platform"
  Environment       = "Production"
  Criticality      = "Mission Critical"
  DataClassification = "Restricted"
  FeatureFlags     = "Production"
  SecurityLevel   = "Maximum"
  ComplianceLevel = "Full"
}