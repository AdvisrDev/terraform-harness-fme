# Banking Platform Administration - Staging Environment

# Organization Configuration
organization_name = "SecureBank"
platform_owner    = "platform-engineering@securebank.com"
primary_region   = "us-east-1"
business_unit     = "digital-banking"
industry          = "financial-services"
project_name      = "digital-banking-platform"

# Workspace Configuration
create_workspace = false  # Workspace should already exist

# Compliance Configuration (production-like for staging)
compliance_frameworks = [
  "pci-dss",    # Payment Card Industry Data Security Standard
  "sox",        # Sarbanes-Oxley Act
  "gdpr",       # General Data Protection Regulation
  "basel-iii",  # Basel III banking regulations
  "kyc",        # Know Your Customer
  "aml"         # Anti-Money Laundering
]

# Security Configuration (production-like for staging)
data_retention_days   = 2555  # 7 years for banking compliance
api_key_rotation_days = 60    # Bi-monthly rotation for staging

# Banking Configuration
banking_products = [
  "checking",
  "savings", 
  "loans",
  "credit-cards",
  "investments",
  "mortgages"
]

regulatory_regions = ["us", "eu"]
risk_tolerance    = "low"  # Production-like risk tolerance

# Environment-specific Configurations
environment_configs = {
  staging = {
    data_class   = "production-like"
    stability    = "stable"
    access_level = "strict"
  }
}

# Banking Environments (staging-only configuration)
environments = {
  staging = {
    name       = "banking-staging"
    production = false
    purpose    = "pre-production-validation"
    stability  = "stable"
    data_class = "production-like"
  }
}

# API Keys (staging configuration - balanced access)
api_keys = {
  staging_server = {
    environment_key = "staging"
    name            = "banking-staging-server"
    type            = "server"
    roles           = ["read", "write"]
  }
  staging_mobile = {
    environment_key = "staging"
    name            = "banking-staging-mobile"
    type            = "mobile"
    roles           = ["sdk"]
  }
  staging_web = {
    environment_key = "staging"
    name            = "banking-staging-web"
    type            = "client"
    roles           = ["sdk"]
  }
}

# Environment Segment Keys (production-like anonymized data)
environment_segment_keys = {
  staging_wealth_customers = {
    environment_key = "staging"
    segment_name    = "wealth_customers"
    keys = [
      # These would be anonymized versions of production data
      "staging_wealth_anon_001",
      "staging_wealth_anon_002"
    ]
  }
  
  staging_eu_customers = {
    environment_key = "staging"
    segment_name    = "eu_customers"
    keys = [
      "staging_eu_anon_001",
      "staging_eu_anon_002"
    ]
  }
}

# Additional Tags
additional_tags = {
  Department        = "Banking Technology"
  Application       = "Digital Banking Platform"
  Environment       = "Staging"
  Criticality      = "High"
  DataClassification = "Production-like"
  SecurityLevel    = "High"
  ComplianceLevel  = "Enhanced"
}