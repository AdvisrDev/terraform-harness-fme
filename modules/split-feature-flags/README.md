# Split.io Feature Flags Terraform Module

A reusable Terraform module for managing Split.io feature flags across multiple environments and use cases.

## Features

- ✅ Environment-agnostic feature flag management
- ✅ Type-safe variable definitions with validation
- ✅ Support for complex targeting rules and treatments
- ✅ Flexible configuration for any use case
- ✅ Production-ready with security best practices

## Usage

```hcl
module "split_feature_flags" {
  source = "./modules/split-feature-flags"

  split_api_key       = var.split_api_key
  workspace_name      = "MyWorkspace"
  environment_name    = "production"
  is_production      = true
  traffic_type_name  = "user"

  feature_flags = [
    {
      name              = "my-feature"
      description       = "My awesome feature"
      default_treatment = "off"
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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| split | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| split | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| split_api_key | Split.io API key for authentication | `string` | n/a | yes |
| workspace_name | Split.io workspace name | `string` | n/a | yes |
| environment_name | Environment name for feature flags | `string` | n/a | yes |
| is_production | Whether this environment is production | `bool` | `false` | no |
| traffic_type_name | Traffic type name for feature flags | `string` | `"user"` | no |
| feature_flags | List of feature flags to create | `list(object)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | Split.io workspace ID |
| environment_id | Split.io environment ID |
| environment_name | Split.io environment name |
| traffic_type_id | Split.io traffic type ID |
| feature_flags | Created feature flags with their details |
| feature_flag_definitions | Feature flag definitions with environment-specific settings |

## Feature Flag Structure

Each feature flag object supports the following structure:

```hcl
{
  name              = string           # Unique identifier
  description       = string           # Human-readable description
  default_treatment = string           # Default treatment name
  treatments = [                       # List of possible treatments
    {
      name           = string          # Treatment name
      configurations = string          # JSON configuration (optional)
      description    = string          # Treatment description (optional)
    }
  ]
  rules = [                           # Targeting rules (optional)
    {
      treatment = string              # Treatment for this rule (optional)
      size      = number             # Percentage allocation (optional, default: 100)
      condition = {                  # Targeting condition (optional)
        matcher = {
          type      = string         # Matcher type (e.g., "EQUAL_SET", "IN_SEGMENT")
          attribute = string         # Attribute name
          strings   = list(string)   # Values to match (optional)
        }
      }
    }
  ]
}
```

## Validation Rules

The module includes the following validations:

1. Each feature flag must have at least 2 treatments
2. The default treatment must exist in the treatments list
3. All required fields must be provided

## Examples

See the `/use-cases` and `/examples` directories for complete implementation examples.