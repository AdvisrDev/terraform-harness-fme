# Banking Platform Administration - Development Environment

# Organization Configuration
workspace = {
  name             = "AxoltlBank"
  create_workspace = true
}

# Banking Environments (override for development-specific settings)
environments = {
  development = {
    name       = "dev"
    production = false
  }
}

# Banking Traffic Types (development subset)
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
  employee = {
    name         = "employee"
    display_name = "Bank Employee"
  }
  device = {
    name         = "device"
    display_name = "Customer Device"
  }
}

# Traffic Type Attributes (development subset)
traffic_type_attributes = {
  transaction_tier = {
    traffic_type_key = "transaction"
    id               = "tier"
    display_name     = "Transaction Tier"
    description      = "Transaction relationship tier for feature access"
    data_type        = "string" # expected data_type to be one of ["string" "DATETIME" "NUMBER" "SET"]
    is_searchable    = true
    suggested_values = ["basic", "preferred", "private", "wealth"]
  }
  customer_region = {
    traffic_type_key = "customer"
    id               = "region"
    display_name     = "Customer Region"
    description      = "Customer geographic region for compliance"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["north-america", "europe", "monterrey"]
  }
  account_type = {
    traffic_type_key = "account"
    id               = "type"
    display_name     = "Account Type"
    description      = "Type of banking account"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["checking", "savings", "credit-card"]
  }
  device_trust_level = {
    traffic_type_key = "device"
    id               = "trust_level"
    display_name     = "Device Trust Level"
    description      = "Device trust level for security features"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["unknown", "recognized", "trusted", "verified"]
  }
}

# Banking Segments (development subset)
segments = {
  wealth_customers = {
    traffic_type_key = "transaction"
    name             = "wealth_customers"
    description      = "High net worth customers for wealth management features"
    category         = "transaction-tier"
    business_value   = "very-high"
    purpose          = "wealth-management"
  }
  high_risk_customers = {
    traffic_type_key = "customer"
    name             = "high_risk_customers"
    description      = "Customers requiring enhanced monitoring"
    category         = "risk-management"
    business_value   = "security"
    purpose          = "fraud-prevention"
  }
  eu_customers = {
    traffic_type_key = "customer"
    name             = "eu_customers"
    description      = "European customers subject to GDPR"
    category         = "geographic"
    business_value   = "compliance"
    purpose          = "gdpr-compliance"
  }
  mobile_banking_users = {
    traffic_type_key = "device"
    name             = "mobile_banking_users"
    description      = "Users accessing via mobile banking app"
    category         = "channel"
    business_value   = "medium"
    purpose          = "mobile-optimization"
  }
}

# API Keys (development configuration)
api_keys = {
  dev_admin = {
    environment_key = "development"
    name            = "d-admin"
    type            = "admin"
    roles           = ["API_ALL_GRANTED"]
  }
  dev_backend = {
    environment_key = "development"
    name            = "bnk-d-flag-v"
    type            = "server_side"
    roles           = ["API_FEATURE_FLAG_VIEWER"]
  }
  dev_mobile = {
    environment_key = "development"
    name            = "bnk-d-wk-admin"
    type            = "client_side"
    roles           = ["API_WORKSPACE_ADMIN"]
  }
}

# Environment Segment Keys (synthetic test data)
environment_segment_keys = {
  dev_wealth_customers = {
    environment_key = "development"
    segment_name    = "wealth_customers"
    keys = [
      "dev_wealth_001",
      "dev_wealth_002",
      "dev_wealth_003",
      "test_wealth_user_primary",
      "test_wealth_user_secondary"
    ]
  }

  dev_high_risk_customers = {
    environment_key = "development"
    segment_name    = "high_risk_customers"
    keys = [
      "dev_risk_001",
      "dev_risk_002",
      "test_risk_user"
    ]
  }

  dev_eu_customers = {
    environment_key = "development"
    segment_name    = "eu_customers"
    keys = [
      "dev_eu_001",
      "dev_eu_002",
      "test_eu_user"
    ]
  }

  dev_mobile_banking_users = {
    environment_key = "development"
    segment_name    = "mobile_banking_users"
    keys = [
      "dev_mobile_001",
      "dev_mobile_002",
      "test_mobile_user"
    ]
  }
}
