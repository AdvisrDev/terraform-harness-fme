# Split.io Feature Flags Terraform Module

A reusable Terraform module for managing Split.io feature flags across multiple environments and use cases with environment-specific configuration support.

## ✨ Features

- ✅ **Environment-Specific Configurations**: Different configurations per environment while maintaining single source of truth
- ✅ **Environment Safety**: Automatic filtering prevents accidental production deployments
- ✅ **Type-Safe Variables**: Comprehensive validation with detailed error messages
- ✅ **Complex Targeting**: Support for advanced targeting rules and A/B testing
- ✅ **Flexible Architecture**: Suitable for any use case or industry
- ✅ **Production Ready**: Security best practices and operational controls
- ✅ **Configuration Inheritance**: Base configurations with environment-specific overrides

## 🚀 Basic Usage

```hcl
module "split_feature_flags" {
  source = "./modules/split-feature-flags"

  workspace_name      = "MyWorkspace"
  environment_name    = "production"
  is_production      = true
  traffic_type_name  = "user"

  feature_flags = [
    {
      name              = "my-feature"
      description       = "My awesome feature"
      default_treatment = "off"
      environments      = ["dev", "staging", "prod"]
      lifecycle_stage   = "production"
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
    }
  ]
}
```

## 🎯 Environment-Specific Configurations

Configure different behaviors for the same feature flag across environments:

```hcl
module "split_feature_flags" {
  source = "./modules/split-feature-flags"

  workspace_name      = "MyWorkspace"
  environment_name    = var.environment_name
  is_production      = var.is_production
  traffic_type_name  = "user"

  feature_flags = [
    {
      name              = "api-rate-limiting"
      description       = "API rate limiting system"
      default_treatment = "standard"
      environments      = ["dev", "staging", "prod"]
      lifecycle_stage   = "production"
      category          = "operational"
      
      # Base configuration (fallback)
      treatments = [
        {
          name           = "off"
          configurations = "{\"enabled\": false}"
          description    = "Rate limiting disabled"
        },
        {
          name           = "standard"
          configurations = "{\"enabled\": true, \"requests_per_minute\": 1000}"
          description    = "Standard rate limiting"
        }
      ]
      rules = []
      
      # Environment-specific overrides
      environment_configs = {
        # Development: Higher limits for testing
        dev = {
          description = "Development rate limiting with debug features"
          treatments = [
            {
              name           = "off"
              configurations = "{\"enabled\": false, \"debug\": true}"
              description    = "Disabled with debug logging"
            },
            {
              name           = "standard"
              configurations = "{\"enabled\": true, \"requests_per_minute\": 10000, \"debug\": true}"
              description    = "High-limit rate limiting for development"
            }
          ]
        }
        
        # Staging: Production-like with monitoring
        staging = {
          description = "Staging rate limiting with monitoring"
          treatments = [
            {
              name           = "off"
              configurations = "{\"enabled\": false, \"monitoring\": true}"
              description    = "Disabled with monitoring"
            },
            {
              name           = "standard"
              configurations = "{\"enabled\": true, \"requests_per_minute\": 1500, \"monitoring\": true}"
              description    = "Production-like with monitoring"
            }
          ]
        }
        
        # Production: Strict limits with security
        prod = {
          description = "Production rate limiting with enhanced security"
          treatments = [
            {
              name           = "off"
              configurations = "{\"enabled\": false, \"audit_log\": true}"
              description    = "Disabled with audit logging"
            },
            {
              name           = "standard"
              configurations = "{\"enabled\": true, \"requests_per_minute\": 1000, \"security_enhanced\": true}"
              description    = "Production rate limiting with security"
            }
          ]
          rules = [
            {
              treatment = "standard"
              size      = 100
              condition = {
                matcher = {
                  type      = "IN_SEGMENT"
                  attribute = "user_tier"
                  strings   = ["premium"]
                }
              }
            }
          ]
        }
      }
    }
  ]
}
```

## 🏗️ Environment Configuration Override Behavior

### Configuration Inheritance
- **Base Configuration**: Provides fallback values for all environments
- **Environment-Specific**: Overrides specific attributes for target environments
- **Selective Override**: Only specified attributes are overridden, others inherit from base

### Override Capabilities
| Attribute | Override Behavior | Description |
|-----------|------------------|-------------|
| `description` | Replace | Environment-specific description replaces base description |
| `default_treatment` | Replace | Environment-specific default replaces base default |
| `treatments` | Complete Replace | Environment treatments completely replace base treatments |
| `rules` | Complete Replace | Environment rules completely replace base rules |

### Example Deployment Results

With the configuration above, deploying to different environments yields:

#### Development Environment
```json
{
  "name": "api-rate-limiting",
  "description": "Development rate limiting with debug features",
  "default_treatment": "standard",
  "treatments": [
    {
      "name": "standard",
      "configurations": "{\"enabled\": true, \"requests_per_minute\": 10000, \"debug\": true}"
    }
  ]
}
```

#### Production Environment  
```json
{
  "name": "api-rate-limiting", 
  "description": "Production rate limiting with enhanced security",
  "default_treatment": "standard",
  "treatments": [
    {
      "name": "standard",
      "configurations": "{\"enabled\": true, \"requests_per_minute\": 1000, \"security_enhanced\": true}"
    }
  ]
}
```

## 📊 Environment Safety Matrix

Feature flags are automatically filtered based on environment:

| Flag Configuration | Dev | Staging | Prod | Result |
|-------------------|-----|---------|------|--------|
| `environments = ["dev"]` | ✅ | ❌ | ❌ | Development only |
| `environments = ["dev", "staging"]` | ✅ | ✅ | ❌ | Testing phase |
| `environments = ["dev", "staging", "prod"]` | ✅ | ✅ | ✅ | Production ready |

## 📋 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| split | ~> 2.0 |

## 🔧 Providers

| Name | Version |
|------|---------|
| split | ~> 2.0 |

## 📥 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workspace_name | Split.io workspace name | `string` | n/a | yes |
| environment_name | Environment name for feature flags | `string` | n/a | yes |
| is_production | Whether this environment is production | `bool` | n/a | yes |
| traffic_type_name | Traffic type name for feature flags | `string` | n/a | yes |
| feature_flags | List of feature flags with environment-specific configurations | `list(object({...}))` | n/a | yes |

### Feature Flags Variable Structure

```hcl
feature_flags = list(object({
  name              = string
  description       = string
  default_treatment = string
  environments      = optional(list(string), ["dev", "staging", "prod"])
  lifecycle_stage   = optional(string, "development")
  category          = optional(string, "feature")
  treatments = list(object({
    name           = string
    configurations = optional(string, "{}")
    description    = optional(string, "")
  }))
  rules = optional(list(object({
    treatment = optional(string)
    size      = optional(number, 100)
    condition = optional(object({
      matcher = object({
        type      = string
        attribute = string
        strings   = optional(list(string), [])
      })
    }))
  })), [])
  
  # Environment-specific overrides
  environment_configs = optional(map(object({
    default_treatment = optional(string)
    description       = optional(string)
    treatments = optional(list(object({
      name           = string
      configurations = optional(string, "{}")
      description    = optional(string, "")
    })))
    rules = optional(list(object({
      treatment = optional(string)
      size      = optional(number, 100)
      condition = optional(object({
        matcher = object({
          type      = string
          attribute = string
          strings   = optional(list(string), [])
        })
      }))
    })))
  })), {})
}))
```

### Lifecycle Stages
- `development` - Initial development and experimentation
- `testing` - QA testing and validation
- `staging` - Pre-production validation
- `production` - Stable and production-ready
- `deprecated` - Being phased out

### Categories
- `feature` - New product functionality
- `experiment` - A/B tests and experiments
- `operational` - System behavior control
- `permission` - Access control features
- `killswitch` - Emergency controls

## 📤 Outputs

| Name | Description |
|------|-------------|
| workspace_id | Split.io workspace ID |
| environment_id | Split.io environment ID |
| environment_name | Split.io environment name |
| traffic_type_id | Split.io traffic type ID |
| feature_flags | Created feature flags with their details |
| feature_flag_definitions | Feature flag definitions with environment-specific settings |
| filtered_feature_flags | Feature flags filtered for current environment |
| merged_feature_flags | Feature flags with environment-specific configurations applied |
| environment_specific_configs | Environment-specific configurations that were applied |
| feature_flags_summary | Summary of feature flags by lifecycle stage and category |

## 🎯 Use Cases

### Multi-Environment Deployment
Deploy the same feature flags across environments with different configurations:

```bash
# Development
terraform apply -var="environment_name=dev" -var="is_production=false"

# Staging  
terraform apply -var="environment_name=staging" -var="is_production=false"

# Production
terraform apply -var="environment_name=prod" -var="is_production=true"
```

### Progressive Feature Rollout
Control feature availability across environments:

```hcl
{
  name = "new-payment-flow"
  environments = ["dev", "staging"]  # Start with dev and staging
  lifecycle_stage = "testing"
  
  # Later, promote to production:
  # environments = ["dev", "staging", "prod"]
  # lifecycle_stage = "production"
}
```

### Environment-Specific Behaviors
Configure different treatments per environment:

```hcl
{
  name = "cache-strategy"
  environment_configs = {
    dev = {
      treatments = [
        { name = "redis", configurations = "{\"ttl\": 60, \"debug\": true}" }
      ]
    }
    prod = {
      treatments = [
        { name = "redis", configurations = "{\"ttl\": 3600, \"monitoring\": true}" }
      ]
    }
  }
}
```

## 🛡️ Validation Rules

The module includes comprehensive validation:

- Feature flag names cannot be empty
- Each feature flag must have at least 2 treatments
- Default treatment must exist in treatments list
- Environment-specific configurations must reference valid environments
- Rule sizes must be between 0 and 100
- Lifecycle stages must be valid values
- Categories must be valid values

## 📚 Examples

- [Banking Platform](../../use-cases/banking-platform/) - Real-world banking implementation
- [Environment-Specific Configs](../../examples/environment-specific-configs/) - Detailed environment configuration examples
- [Simple Feature Flag](../../examples/simple-feature-flag/) - Basic setup
- [Advanced Targeting](../../examples/advanced-targeting/) - Complex targeting rules

## 🔗 Resources

- [Split.io Documentation](https://help.split.io/)
- [Terraform Split Provider](https://registry.terraform.io/providers/davidji99/split/latest/docs)
- [Feature Flag Best Practices](https://www.split.io/blog/feature-flag-best-practices/)

## 📄 License

This module is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.