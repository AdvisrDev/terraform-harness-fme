# Split.io Administration Module

This Terraform module manages Split.io administrative infrastructure including workspaces, environments, traffic types, segments, and API keys with environment-specific configurations.

## Features

- **Environment Filtering**: API keys and segment keys filtered by environment
- **Configuration Merging**: Base configurations with environment-specific overrides
- **Centralized Management**: Single source for all Split.io infrastructure
- **Scalable Architecture**: Supports multiple environments and configuration patterns

## Usage

```hcl
module "split_administration" {
  source = "./modules/split-administration"

  environment_name = "dev"
  
  workspace = {
    name             = "my-workspace"
    create_workspace = true
  }

  environments = {
    dev = {
      name       = "development"
      production = false
    }
    prod = {
      name       = "production"
      production = true
    }
  }

  traffic_types = {
    user = {
      name         = "user"
      display_name = "User"
    }
  }

  segments = {
    premium_users = {
      traffic_type_key = "user"
      name             = "premium_users"
      description      = "Users with premium subscription"
    }
  }

  api_keys = [
    {
      name         = "server"
      type         = "server_side"
      roles        = ["API_FEATURE_FLAG_VIEWER"]
      environments = ["dev", "prod"]
      environment_configs = {
        dev = { name = "dev-server" }
        prod = { name = "prod-server" }
      }
    }
  ]

  environment_segment_keys = [
    {
      name         = "premium_test_keys"
      segment_name = "premium_users"
      keys         = ["user1", "user2"]
      environments = ["dev"]
    }
  ]
}
```

## Key Features

### Environment-Specific API Keys
- Common API keys deployed across specified environments
- Environment-specific naming and configuration overrides
- Development-only keys with administrative access

### Environment-Specific Segment Keys
- Segment keys filtered by target environment
- Environment-specific key overrides for testing

## Integration

Use outputs from this module with the `split-feature-flags` module:

```hcl
module "feature_flags" {
  source = "./modules/split-feature-flags"
  
  workspace_name    = var.workspace.name
  environment_name  = var.environment_name
  traffic_type_name = "user"
  feature_flags     = var.feature_flags
}
```

## Configuration Patterns

### File Structure
```
├── common.tfvars           # Shared configurations
├── environments/
│   ├── development.tfvars  # Dev-specific items
│   └── production.tfvars   # Prod-specific items
```

### Environment Filtering Pattern
```hcl
# Only create items for current environment
api_keys = [
  {
    name = "common-key"
    environments = ["dev", "prod"]  # Available in both
  },
  {
    name = "debug-key"
    environments = ["dev"]          # Development only
  }
]
```

This module provides a foundation for managing Split.io infrastructure at scale with proper environment isolation and configuration management.