# Banking Platform Administration - Production Environment

# Organization Configuration
organization_name = "SecureBank"
platform_owner    = "platform-engineering@securebank.com"
primary_region   = "us-east-1"
business_unit     = "digital-banking"
industry          = "financial-services"
project_name      = "digital-banking-platform"

# Workspace Configuration
create_workspace = false  # Workspace should already exist

# Compliance Configuration (strict for production)
compliance_frameworks = [
  "pci-dss",      # Payment Card Industry
  "sox",          # Sarbanes-Oxley
  "gdpr",         # General Data Protection Regulation
  "basel-iii",    # Banking regulations
  "kyc",          # Know Your Customer
  "aml",          # Anti-Money Laundering
  "ffiec"         # Federal Financial Institutions Examination Council
]

# Security Configuration (strict for production)
data_retention_days   = 2555  # 7 years for banking compliance
api_key_rotation_days = 30    # Monthly rotation for production

# Banking Configuration
banking_products = [
  "checking",
  "savings", 
  "loans",
  "credit-cards",
  "investments",
  "mortgages",
  "business-banking"
]

regulatory_regions = ["us", "eu"]
risk_tolerance    = "very-low"  # Minimal risk tolerance for production

# Environment-specific Configurations
environment_configs = {
  production = {
    data_class   = "sensitive-pii"
    stability    = "highly-stable"
    access_level = "lockdown"
  }
}

# Banking Environments (production-only configuration)
environments = {
  production = {
    name       = "banking-production"
    production = true
    purpose    = "live-customer-transactions"
    stability  = "highly-stable"
    data_class = "sensitive-pii"
  }
}

# API Keys (production configuration - minimal access)
api_keys = {
  prod_server_readonly = {
    environment_key = "production"
    name            = "banking-prod-server-readonly"
    type            = "server"
    roles           = ["read"]
  }
  prod_automation = {
    environment_key = "production"
    name            = "banking-prod-automation"
    type            = "server"
    roles           = ["write"]
  }
  prod_mobile_ios = {
    environment_key = "production"
    name            = "banking-prod-mobile-ios"
    type            = "mobile"
    roles           = ["sdk"]
  }
  prod_mobile_android = {
    environment_key = "production"
    name            = "banking-prod-mobile-android"
    type            = "mobile"
    roles           = ["sdk"]
  }
  prod_web_banking = {
    environment_key = "production"
    name            = "banking-prod-web-banking"
    type            = "client"
    roles           = ["sdk"]
  }
  prod_monitoring = {
    environment_key = "production"
    name            = "banking-prod-monitoring"
    type            = "server"
    roles           = ["read"]
  }
}

# Environment Segment Keys (managed externally for production)
# Production segment keys should be managed through secure external processes
# and not stored in terraform configuration files
environment_segment_keys = {
  # Production keys are intentionally empty - managed externally
  # These should be populated through:
  # 1. Secure data pipelines
  # 2. External API integration
  # 3. Manual secure processes
  # 4. Encrypted parameter stores
}

# Additional Tags
additional_tags = {
  Department        = "Banking Technology"
  Application       = "Digital Banking Platform"
  Environment       = "Production"
  Criticality      = "Mission Critical"
  DataClassification = "Restricted"
  SecurityLevel    = "Maximum"
  ComplianceLevel  = "Full"
}