# Common Environment Segment Keys with environment-specific configurations
environment_segment_keys = [
  {
    name         = "wealth_customers"
    segment_name = "wealth_customers"
    keys         = ["wealth_001", "wealth_002", "wealth_003"]
    environments = ["dev", "staging", "production"]
    environment_configs = {
      dev = {
        keys = [
          "dev_wealth_001",
          "dev_wealth_002",
          "dev_wealth_003"
        ]
      }
      staging = {
        keys = [
          "stg_wealth_001",
          "stg_wealth_002",
          "stg_wealth_003"
        ]
      }
      production = {
        keys = [
          "test_wealth_user_primary",
          "test_wealth_user_secondary"
        ] # Managed externally for production
      }
    }
  },
  {
    name         = "high_risk_customers"
    segment_name = "high_risk_customers"
    keys         = ["risk_001", "risk_002"]
    environments = ["dev", "staging"]
    environment_configs = {
      dev = {
        keys = [
          "dev_risk_001",
          "dev_risk_002",
          "test_risk_user"
        ]
      }
      staging = {
        keys = [
          "stg_risk_001",
          "stg_risk_002"
        ]
      }
    }
  },
  {
    name         = "eu_customers"
    segment_name = "eu_customers"
    keys         = ["eu_001", "eu_002"]
    environments = ["dev", "staging"]
    environment_configs = {
      dev = {
        keys = [
          "dev_eu_001",
          "dev_eu_002",
          "test_eu_user"
        ]
      }
      staging = {
        keys = [
          "stg_eu_001",
          "stg_eu_002"
        ]
      }
    }
  },
  {
    name         = "mobile_users"
    segment_name = "mobile_users"
    keys         = ["mobile_001", "mobile_002"]
    environments = ["dev", "staging"]
    environment_configs = {
      dev = {
        keys = [
          "dev_mobile_001",
          "dev_mobile_002",
          "test_mobile_user"
        ]
      }
      staging = {
        keys = [
          "stg_mobile_001",
          "stg_mobile_002"
        ]
      }
    }
  }
]
