# Simple Split Administration Setup Example
# This example demonstrates a basic configuration for a startup or small team

terraform {
  required_version = ">= 1.3"
  
  required_providers {
    split = {
      source  = "splitsoftware/split"
      version = ">= 3.0"
    }
  }
}

# Configure the Split.io provider
provider "split" {
  # Configure your Split.io API token
  # Best practice: use environment variable SPLIT_API_TOKEN
}

# Simple administration setup for a small team
module "split_administration" {
  source = "../../modules/split-administration"
  
  # Workspace configuration
  workspace_name   = "simple-startup"
  create_workspace = true
  
  workspace_tags = {
    Team        = "engineering"
    Environment = "multi"
    Purpose     = "feature-management"
    Owner       = "platform-team@startup.com"
  }
  
  # Basic environments
  environments = {
    dev = {
      name       = "development"
      production = false
      tags = {
        Environment = "development"
        Purpose     = "feature-development"
        Stability   = "experimental"
      }
    }
    
    staging = {
      name       = "staging"
      production = false
      tags = {
        Environment = "staging"
        Purpose     = "pre-production-testing"
        Stability   = "stable"
      }
    }
    
    prod = {
      name       = "production"
      production = true
      tags = {
        Environment = "production"
        Purpose     = "live-traffic"
        Stability   = "highly-stable"
      }
    }
  }
  
  # Basic traffic types
  traffic_types = {
    user = {
      name         = "user"
      display_name = "User"
    }
  }
  
  # Simple user attributes
  traffic_type_attributes = {
    user_plan = {
      traffic_type_key = "user"
      id               = "plan"
      display_name     = "Subscription Plan"
      description      = "User subscription level"
      data_type        = "string"
      is_searchable    = true
      suggested_values = ["free", "premium"]
      tags = {
        Category = "business"
        Purpose  = "feature-gating"
      }
    }
  }
  
  # Basic user segments
  segments = {
    premium_users = {
      traffic_type_key = "user"
      name             = "premium_users"
      description      = "Users with premium subscription"
      tags = {
        Category = "subscription"
        Purpose  = "feature-access"
      }
    }
    
    beta_testers = {
      traffic_type_key = "user"
      name             = "beta_testers"
      description      = "Users enrolled in beta testing"
      tags = {
        Category = "testing"
        Purpose  = "early-access"
      }
    }
  }
  
  # Sample segment keys for each environment
  environment_segment_keys = {
    dev_premium = {
      environment_key = "dev"
      segment_name    = "premium_users"
      keys = [
        "dev_user_001",
        "dev_user_002",
        "test_premium_001"
      ]
    }
    
    dev_beta = {
      environment_key = "dev"
      segment_name    = "beta_testers"
      keys = [
        "dev_beta_001",
        "dev_beta_002"
      ]
    }
    
    staging_premium = {
      environment_key = "staging"
      segment_name    = "premium_users"
      keys = [
        "staging_user_001",
        "staging_user_002"
      ]
    }
    
    prod_beta = {
      environment_key = "prod"
      segment_name    = "beta_testers"
      keys = [
        # In production, these would be real user IDs
        "beta_user_12345",
        "beta_user_67890"
      ]
    }
  }
  
  # Basic API keys for each environment
  api_keys = {
    dev_server = {
      environment_key = "dev"
      name            = "development-server"
      type            = "server"
      roles           = ["admin"] # Full access for development
    }
    
    staging_server = {
      environment_key = "staging"
      name            = "staging-server"
      type            = "server"
      roles           = ["read", "write"] # Limited access for staging
    }
    
    prod_server = {
      environment_key = "prod"
      name            = "production-server"
      type            = "server"
      roles           = ["read"] # Read-only for production safety
    }
    
    prod_client = {
      environment_key = "prod"
      name            = "production-client"
      type            = "client"
      roles           = ["sdk"] # Client-side evaluation
    }
  }
}