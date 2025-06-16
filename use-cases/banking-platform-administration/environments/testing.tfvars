# Banking Platform Administration - Testing Environment

# Organization Configuration
organization_name = "SecureBank"
platform_owner    = "platform-engineering@securebank.com"
primary_region   = "us-east-1"
business_unit     = "digital-banking"
industry          = "financial-services"
project_name      = "digital-banking-platform"

# Workspace Configuration
create_workspace = false  # Workspace should already exist

# Compliance Configuration (subset for testing)
compliance_frameworks = [
  "pci-dss",    # Payment Card Industry Data Security Standard
  "gdpr"        # General Data Protection Regulation
]

# Security Configuration (moderate for testing)
data_retention_days   = 730   # 2 years for testing
api_key_rotation_days = 120   # Quarterly rotation for testing

# Banking Configuration
banking_products = [
  "checking",
  "savings", 
  "loans",
  "credit-cards"
]

regulatory_regions = ["us"]
risk_tolerance    = "medium"  # Moderate tolerance for testing

# Environment-specific Configurations
environment_configs = {
  testing = {
    data_class   = "anonymized"
    stability    = "testing"
    access_level = "restricted"
  }
}

# Banking Environments (testing-only configuration)
environments = {
  testing = {
    name       = "banking-testing"
    production = false
    purpose    = "quality-assurance"
    stability  = "testing"
    data_class = "anonymized"
  }
}

# Banking Traffic Types (testing subset)
traffic_types = {
  customer = {
    name         = "customer"
    display_name = "Bank Customer"
  }
  account = {
    name         = "account"
    display_name = "Bank Account"
  }
  transaction = {
    name         = "transaction"
    display_name = "Financial Transaction"
  }
}

# Traffic Type Attributes (testing subset)
traffic_type_attributes = {
  customer_tier = {
    traffic_type_key = "customer"
    id               = "tier"
    display_name     = "Customer Tier"
    description      = "Customer relationship tier for feature access"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["basic", "preferred", "private"]
    category         = "customer-segmentation"
    purpose          = "feature-gating"
    sensitivity      = "medium"
  }
  account_type = {
    traffic_type_key = "account"
    id               = "type"
    display_name     = "Account Type"
    description      = "Type of banking account"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["checking", "savings"]
    category         = "product-type"
    purpose          = "feature-access"
    sensitivity      = "medium"
  }
}

# Banking Segments (testing subset)
segments = {
  test_customers = {
    traffic_type_key = "customer"
    name             = "test_customers"
    description      = "Test customers for QA validation"
    category         = "testing"
    business_value   = "qa"
    purpose          = "testing"
  }
  eu_customers = {
    traffic_type_key = "customer"
    name             = "eu_customers"
    description      = "European customers subject to GDPR"
    category         = "geographic"
    business_value   = "compliance"
    purpose          = "gdpr-compliance"
  }
}

# API Keys (testing configuration)
api_keys = {
  testing_server = {
    environment_key = "testing"
    name            = "banking-testing-server"
    type            = "server"
    roles           = ["read", "write"]
  }
  testing_automation = {
    environment_key = "testing"
    name            = "banking-testing-automation"
    type            = "server"
    roles           = ["read"]
  }
}

# Environment Segment Keys (anonymized test data)
environment_segment_keys = {
  testing_customers = {
    environment_key = "testing"
    segment_name    = "test_customers"
    keys = [
      "test_customer_001",
      "test_customer_002",
      "qa_user_001"
    ]
  }
  
  testing_eu_customers = {
    environment_key = "testing"
    segment_name    = "eu_customers"
    keys = [
      "test_eu_001",
      "test_eu_002"
    ]
  }
}

# Additional Tags
additional_tags = {
  Department        = "Banking Technology"
  Application       = "Digital Banking Platform"
  Environment       = "Testing"
  Criticality      = "Medium"
  DataClassification = "Anonymized"
  Purpose          = "QA"
}