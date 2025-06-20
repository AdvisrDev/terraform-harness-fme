# Common/General Configuration for Split Administration
# This file contains reusable values that apply across all environments

# Workspace Configuration (shared across all environments)
workspace = {
  name             = "AxoltlBank"
  create_workspace = true
}

environment_name = "common"

# All environments configuration
environments = {
  dev = {
    name       = "dev"
    production = false
  }
  testing = {
    name       = "testing"
    production = false
  }
  staging = {
    name       = "staging"
    production = false
  }
  production = {
    name       = "production"
    production = true
  }
}

# Traffic Types (shared across all environments)
traffic_types = {
  customer = {
    name         = "customer"
    display_name = "Customer"
  }
  account = {
    name         = "account"
    display_name = "Account"
  }
  transaction = {
    name         = "transaction"
    display_name = "Transaction"
  }
  employee = {
    name         = "employee"
    display_name = "Employee"
  }
  device = {
    name         = "device"
    display_name = "Device"
  }
}

# Traffic Type Attributes (shared across all environments)
traffic_type_attributes = {
  transaction_tier = {
    traffic_type_key = "transaction"
    id               = "tier"
    display_name     = "Transaction Tier"
    description      = "Transaction relationship tier for feature access"
    data_type        = "string"
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
    description      = "Type of account"
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

# Segments (shared across all environments)
segments = {
  wealth_customers = {
    traffic_type_key = "transaction"
    name             = "wealth_customers"
    description      = "High net worth customers for wealth management features"
  }
  high_risk_customers = {
    traffic_type_key = "customer"
    name             = "high_risk_customers"
    description      = "Customers requiring enhanced monitoring"
  }
  eu_customers = {
    traffic_type_key = "customer"
    name             = "eu_customers"
    description      = "European customers subject to GDPR"
  }
  mobile_users = {
    traffic_type_key = "device"
    name             = "mobile_users"
    description      = "Users accessing via mobile app"
  }
}

# Common API Keys with environment-specific configurations
api_keys = [
  #   {
  #     name         = "d-admin"
  #     type         = "admin"
  #     roles        = ["API_ALL_GRANTED"]
  #     environments = ["dev", "testing"]
  #     environment_configs = {
  #       dev = {
  #         name = "d-admin"
  #       }
  #       testing = {
  #         name = "test-admin"
  #       }
  #     }
  #   },
  #   {
  #     name         = "d-admin"
  #     type         = "server_side"
  #     roles        = ["API_FEATURE_FLAG_VIEWER"]
  #     environments = ["dev", "staging", "production"]
  #     environment_configs = {
  #       dev = {
  #         name = "d-server"
  #       }
  #       staging = {
  #         name = "stg-server"
  #       }
  #       production = {
  #         name = "prd-readonly"
  #       }
  #     }
  #   },
  #   {
  #     name         = "d-admin"
  #     type         = "client_side"
  #     roles        = ["API_FEATURE_FLAG_VIEWER"]
  #     environments = ["dev", "staging", "production"]
  #     environment_configs = {
  #       dev = {
  #         name = "d-mobile"
  #       }
  #       staging = {
  #         name = "stg-mobile"
  #       }
  #       production = {
  #         name = "prd-mobile"
  #       }
  #     }
  #   }
]

# Common Environment Segment Keys with environment-specific configurations
environment_segment_keys = [
  #   {
  #     name         = "wealth_customers"
  #     segment_name = "wealth_customers"
  #     keys         = ["wealth_001", "wealth_002", "wealth_003"]
  #     environments = ["dev", "staging", "production"]
  #     environment_configs = {
  #       dev = {
  #         keys = [
  #           "dev_wealth_001",
  #           "dev_wealth_002",
  #           "dev_wealth_003"
  #         ]
  #       }
  #       staging = {
  #         keys = [
  #           "stg_wealth_001",
  #           "stg_wealth_002",
  #           "stg_wealth_003"
  #         ]
  #       }
  #       production = {
  #         keys = [
  #           "test_wealth_user_primary",
  #           "test_wealth_user_secondary"
  #         ] # Managed externally for production
  #       }
  #     }
  #   },
  #   {
  #     name         = "high_risk_customers"
  #     segment_name = "high_risk_customers"
  #     keys         = ["risk_001", "risk_002"]
  #     environments = ["dev", "staging"]
  #     environment_configs = {
  #       dev = {
  #         keys = [
  #           "dev_risk_001",
  #           "dev_risk_002",
  #           "test_risk_user"
  #         ]
  #       }
  #       staging = {
  #         keys = [
  #           "stg_risk_001",
  #           "stg_risk_002"
  #         ]
  #       }
  #     }
  #   },
  #   {
  #     name         = "eu_customers"
  #     segment_name = "eu_customers"
  #     keys         = ["eu_001", "eu_002"]
  #     environments = ["dev", "staging"]
  #     environment_configs = {
  #       dev = {
  #         keys = [
  #           "dev_eu_001",
  #           "dev_eu_002",
  #           "test_eu_user"
  #         ]
  #       }
  #       staging = {
  #         keys = [
  #           "stg_eu_001",
  #           "stg_eu_002"
  #         ]
  #       }
  #     }
  #   },
  #   {
  #     name         = "mobile_users"
  #     segment_name = "mobile_users"
  #     keys         = ["mobile_001", "mobile_002"]
  #     environments = ["dev", "staging"]
  #     environment_configs = {
  #       dev = {
  #         keys = [
  #           "dev_mobile_001",
  #           "dev_mobile_002",
  #           "test_mobile_user"
  #         ]
  #       }
  #       staging = {
  #         keys = [
  #           "stg_mobile_001",
  #           "stg_mobile_002"
  #         ]
  #       }
  #     }
  #   }
]
