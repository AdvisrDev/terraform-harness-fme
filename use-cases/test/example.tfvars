# Example configuration for administration-only setup
# This demonstrates how to configure the administrative infrastructure

environment_name = "dev"

workspace = {
  name             = "MyCompany-Infrastructure"
  create_workspace = true
}

environments = {
  development = {
    name       = "dev"
    production = false
  }
  staging = {
    name       = "staging"
    production = false
  }
  production = {
    name       = "prod"
    production = true
  }
}

traffic_types = {
  user = {
    name         = "user"
    display_name = "User"
  }
  account = {
    name         = "account"
    display_name = "Account"
  }
  service = {
    name         = "service"
    display_name = "Service"
  }
}

traffic_type_attributes = {
  user_tier = {
    traffic_type_key = "user"
    id               = "tier"
    display_name     = "User Tier"
    description      = "User subscription tier"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["free", "premium", "enterprise"]
  }
  user_region = {
    traffic_type_key = "user"
    id               = "region"
    display_name     = "User Region"
    description      = "User geographic region"
    data_type        = "string"
    is_searchable    = true
    suggested_values = ["us", "eu", "asia"]
  }
}

segments = {
  premium_users = {
    traffic_type_key = "user"
    name             = "premium_users"
    description      = "Users with premium subscription"
  }
  enterprise_users = {
    traffic_type_key = "user"
    name             = "enterprise_users"
    description      = "Users with enterprise subscription"
  }
}

api_keys = [
  {
    name         = "server"
    type         = "server_side"
    roles        = ["API_FEATURE_FLAG_VIEWER"]
    environments = ["dev", "staging", "prod"]
    environment_configs = {
      dev = {
        name = "dev-server-key"
      }
      staging = {
        name = "staging-server-key"
      }
      prod = {
        name = "prod-server-key"
        roles = ["API_FEATURE_FLAG_VIEWER", "API_AUDIT"]
      }
    }
  },
  {
    name         = "client"
    type         = "client_side"
    roles        = ["API_FEATURE_FLAG_VIEWER"]
    environments = ["dev", "staging", "prod"]
    environment_configs = {
      dev = {
        name = "dev-client-key"
      }
      staging = {
        name = "staging-client-key"
      }
      prod = {
        name = "prod-client-key"
      }
    }
  },
  {
    name         = "admin"
    type         = "admin"
    roles        = ["API_ALL_GRANTED"]
    environments = ["dev"]
    environment_configs = {
      dev = {
        name = "dev-admin-key"
      }
    }
  }
]

environment_segment_keys = [
  {
    name         = "premium_test_users"
    segment_name = "premium_users"
    keys         = ["user123", "user456", "user789"]
    environments = ["dev", "staging"]
    environment_configs = {
      dev = {
        keys = ["user123", "user456", "user789", "testuser1", "testuser2"]
      }
      staging = {
        keys = ["user123", "user456"]
      }
    }
  },
  {
    name         = "enterprise_test_users"
    segment_name = "enterprise_users"
    keys         = ["entuser1", "entuser2"]
    environments = ["dev"]
    environment_configs = {
      dev = {
        keys = ["entuser1", "entuser2", "testent1"]
      }
    }
  }
]