# Split.io Administration Module

This Terraform module manages the administrative aspects of Split.io, including workspaces, environments, traffic types, segments, and API keys.

## Features

- **Workspace Management**: Create or reference existing workspaces
- **Environment Management**: Create and manage multiple environments
- **Traffic Type Management**: Define and configure traffic types
- **Traffic Type Attributes**: Add custom attributes to traffic types
- **Segment Management**: Create and manage user segments
- **Environment Segment Keys**: Manage segment keys per environment
- **API Key Management**: Create and manage API keys with proper roles

## Usage

```hcl
module "split_administration" {
  source = "./modules/split-administration"

  workspace = {
    name             = "my-workspace"
    create_workspace = true
  }

  environments = {
    dev = {
      name       = "development"
      production = false
      tags = {
        Environment = "dev"
        Team        = "platform"
      }
    }
    prod = {
      name       = "production"
      production = true
      tags = {
        Environment = "prod"
        Team        = "platform"
      }
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
  }

  traffic_type_attributes = {
    user_plan = {
      traffic_type_key = "user"
      id               = "plan"
      display_name     = "Subscription Plan"
      description      = "User subscription plan level"
      data_type        = "string"
      is_searchable    = true
      suggested_values = ["free", "premium", "enterprise"]
    }
  }

  segments = {
    premium_users = {
      traffic_type_key = "user"
      name             = "premium_users"
      description      = "Users with premium subscription"
    }
  }

  environment_segment_keys = {
    dev_premium = {
      environment_key = "dev"
      segment_name    = "premium_users"
      keys            = ["user_123", "user_456"]
    }
  }

  api_keys = {
    dev_server = {
      environment_key = "dev"
      name            = "dev-server-key"
      type            = "server"
      roles           = ["admin"]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| split | >= 1.0 |

## Resources

| Name | Type |
|------|------|
| split_workspace | resource |
| split_environment | resource |
| split_traffic_type | resource |
| split_traffic_type_attribute | resource |
| split_segment | resource |
| split_environment_segment_keys | resource |
| split_api_key | resource |
| split_workspace | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workspace | workspace to create | `map(object({...}))` | `{}` | yes |
| environments | Map of environments to create | `map(object({...}))` | `{}` | yes |
| traffic_types | Map of traffic types to create | `map(object({...}))` | `{}` | yes |
| traffic_type_attributes | Map of traffic type attributes to create | `map(object({...}))` | `{}` | yes |
| segments | Map of segments to create | `map(object({...}))` | `{}` | yes |
| environment_segment_keys | Map of environment segment keys to manage | `map(object({...}))` | `{}` | yes |
| api_keys | Map of API keys to create | `map(object({...}))` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | Split.io workspace ID |
| environments | Created environments with their details |
| traffic_types | Created traffic types with their details |
| segments | Created segments with their details |
| api_keys | Created API keys with their details |
| feature_flag_inputs | Structured data for consumption by feature flag modules |

## Module Dependencies

This module is designed to work with the `split-feature-flags` module. Use the `feature_flag_inputs` output to pass administrative data to feature flag modules.

## Security Considerations

- API keys are marked as sensitive outputs
- Ensure proper IAM permissions for Split.io provider
- Use separate workspaces for different environments when appropriate