# Split.io Feature Flags Module

This Terraform module manages Split.io feature flags with environment-specific configurations, supporting flexible deployment patterns across multiple environments.

## Features

- **Environment Filtering**: Only deploy feature flags to specified environments
- **Configuration Merging**: Base configurations with environment-specific overrides
- **Flexible Configuration**: Same treatments across environments OR different per environment
- **Type-Safe Variables**: Comprehensive validation with detailed error messages
- **Production Ready**: Security best practices and operational controls

## Usage

```hcl
module "feature_flags" {
  source = "./modules/split-feature-flags"

  workspace_name    = "my-workspace"
  environment_name  = "dev"
  traffic_type_name = "user"

  feature_flags = [
    {
      name              = "new-feature"
      description       = "New awesome feature"
      default_treatment = "off"
      environments      = ["dev", "staging", "prod"]
      lifecycle_stage   = "development"
      category          = "feature"
      
      treatments = [
        {
          name           = "off"
          configurations = "{\"enabled\": false}"
          description    = "Feature disabled"
        },
        {
          name           = "on"
          configurations = "{\"enabled\": true}"
          description    = "Feature enabled"
        }
      ]
      
      rules = []
      
      # Environment-specific configurations
      environment_configs = {
        dev = {
          default_treatment = "on"
          rules = [{ treatment = "on", size = 100 }]
        }
        prod = {
          rules = [{ treatment = "on", size = 10 }]
        }
      }
    }
  ]
}
```

## Configuration Patterns

### 1. Same Configuration Across Environments

```hcl
feature_flags = [
  {
    name = "kill-switch"
    environments = ["dev", "staging", "prod"]
    default_treatment = "active"
    treatments = [
      { name = "active", configurations = "{\"enabled\": true}" },
      { name = "disabled", configurations = "{\"enabled\": false}" }
    ]
    # No environment_configs = same everywhere
  }
]
```

### 2. Environment-Specific Configurations

```hcl
feature_flags = [
  {
    name = "payment-system"
    environments = ["dev", "staging", "prod"]
    
    environment_configs = {
      dev = {
        default_treatment = "enhanced"
        treatments = [
          { name = "legacy", configurations = "{\"version\": \"v1\", \"debug\": true}" },
          { name = "enhanced", configurations = "{\"version\": \"v2\", \"debug\": true}" }
        ]
      }
      staging = {
        rules = [{ treatment = "enhanced", size = 50 }]
      }
      prod = {
        rules = [{ treatment = "enhanced", size = 5 }]
      }
    }
  }
]
```

### 3. Environment-Only Features

```hcl
feature_flags = [
  {
    name = "debug-panel"
    environments = ["dev"]  # Only in development
    default_treatment = "on"
    treatments = [
      { name = "off", configurations = "{\"debug\": false}" },
      { name = "on", configurations = "{\"debug\": true}" }
    ]
  }
]
```

## Environment Safety

Feature flags are automatically filtered based on environment:

| Flag Configuration | Dev | Staging | Prod | Result |
|-------------------|-----|---------|------|--------|
| `environments = ["dev"]` | ✅ | ❌ | ❌ | Development only |
| `environments = ["dev", "staging"]` | ✅ | ✅ | ❌ | Testing phase |
| `environments = ["dev", "staging", "prod"]` | ✅ | ✅ | ✅ | Production ready |

## Configuration Inheritance

- **Base Configuration**: Provides fallback values for all environments
- **Environment-Specific**: Overrides specific attributes for target environments
- **Selective Override**: Only specified attributes are overridden, others inherit from base

### Override Capabilities

| Attribute | Override Behavior |
|-----------|------------------|
| `description` | Replace environment-specific description |
| `default_treatment` | Replace environment-specific default |
| `treatments` | Complete replacement of treatments |
| `rules` | Complete replacement of rules |

## Integration with Administration

This module works with the `split-administration` module:

```hcl
# First deploy administration
module "administration" {
  source = "./modules/split-administration"
  # ... configuration
}

# Then deploy feature flags
module "feature_flags" {
  source = "./modules/split-feature-flags"
  
  workspace_name    = var.workspace.name      # From administration
  environment_name  = var.environment_name    # Target environment  
  traffic_type_name = "user"                  # From administration
  feature_flags     = var.feature_flags
}
```

## Validation Rules

The module includes comprehensive validation:

- Feature flag names cannot be empty
- Each feature flag must have at least 2 treatments
- Default treatment must exist in treatments list
- Environment-specific configurations must reference valid environments
- Rule sizes must be between 0 and 100
- Lifecycle stages and categories must be valid values

This module provides a robust foundation for managing feature flags at scale with proper environment isolation and flexible configuration management.