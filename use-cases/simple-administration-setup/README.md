# Simple Split Administration Setup Example

This example demonstrates a basic Split.io administration setup suitable for startups, small teams, or getting started with Split.io feature flag management.

## Overview

This configuration creates:
- **1 Workspace**: `simple-startup`
- **3 Environments**: development, staging, production
- **1 Traffic Type**: user
- **1 Traffic Type Attribute**: subscription plan
- **2 Segments**: premium users, beta testers
- **4 API Keys**: server keys for each environment + client key for production
- **Sample Segment Keys**: for testing and demonstration

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        Simple Administration Setup                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Workspace: simple-startup                                              │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                                                                 │   │
│  │  Environments:                                                  │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐    │   │
│  │  │ Development │  │   Staging   │  │    Production       │    │   │
│  │  │             │  │             │  │                     │    │   │
│  │  │• Experimental│  │• Stable     │  │• Highly Stable      │    │   │
│  │  │• Full Access │  │• Limited    │  │• Read-only Server   │    │   │
│  │  │• Testing     │  │• Pre-prod   │  │• Client Evaluation  │    │   │
│  │  └─────────────┘  └─────────────┘  └─────────────────────┘    │   │
│  │                                                                 │   │
│  │  Traffic Types & Segments:                                     │   │
│  │  ┌─────────────────────────────────────────────────────────┐   │   │
│  │  │ User Traffic Type                                       │   │   │
│  │  │ ├─ Attribute: Subscription Plan (free, premium)        │   │   │
│  │  │ ├─ Segment: Premium Users                               │   │   │
│  │  │ └─ Segment: Beta Testers                                │   │   │
│  │  └─────────────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

## Prerequisites

1. **Split.io Account**: You need an active Split.io account
2. **API Token**: Generate an API token from Split.io admin panel
3. **Terraform**: Version 1.3 or later
4. **Split Provider**: Will be automatically downloaded

## Quick Start

### 1. Clone and Navigate
```bash
git clone <repository>
cd examples/simple-administration-setup
```

### 2. Set API Token
```bash
export SPLIT_API_TOKEN="your-split-io-api-token"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review Plan
```bash
terraform plan
```

### 5. Apply Configuration
```bash
terraform apply
```

### 6. View Outputs
```bash
terraform output
```

## Customization

### Modify Workspace Name
Edit the `workspace_name` variable in `main.tf`:
```hcl
workspace_name = "your-company-features"
```

### Add More Environments
Add to the `environments` map:
```hcl
environments = {
  # ... existing environments ...
  qa = {
    name       = "qa"
    production = false
    tags = {
      Environment = "qa"
      Purpose     = "quality-assurance"
      Stability   = "testing"
    }
  }
}
```

### Add More Traffic Types
Extend the `traffic_types` configuration:
```hcl
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
```

### Add More Segments
Create additional user segments:
```hcl
segments = {
  # ... existing segments ...
  enterprise_users = {
    traffic_type_key = "user"
    name             = "enterprise_users"
    description      = "Enterprise subscription users"
    tags = {
      Category = "subscription"
      Purpose  = "enterprise-features"
    }
  }
}
```

## Integration with Feature Flags

After setting up administration, use the outputs to configure feature flags:

```hcl
module "feature_flags" {
  source = "../../modules/split-feature-flags"
  
  workspace_id      = module.split_administration.workspace_id
  environment_id    = module.split_administration.environments["prod"].id
  environment_name  = "production"
  traffic_type_id   = module.split_administration.traffic_types["user"].id
  
  feature_flags = [
    # Your feature flags configuration
  ]
}
```

## Security Considerations

1. **API Token Security**: Never commit API tokens to version control
2. **Environment Variables**: Use environment variables for sensitive data
3. **API Key Roles**: Follow principle of least privilege
4. **Production Access**: Limit production API key permissions

## Cost Considerations

This simple setup creates:
- 1 workspace (typically free)
- 3 environments (may have usage limits)
- Minimal segments and attributes
- Basic API keys

Most Split.io plans include generous limits for small to medium usage.

## Troubleshooting

### Common Issues

1. **Authentication Error**
   ```
   Error: Invalid API token
   ```
   **Solution**: Verify your SPLIT_API_TOKEN environment variable

2. **Workspace Already Exists**
   ```
   Error: Workspace name already exists
   ```
   **Solution**: Change workspace_name or set create_workspace = false

3. **Permission Denied**
   ```
   Error: Insufficient permissions
   ```
   **Solution**: Verify your API token has admin permissions

### Getting Help

- Check the [Split.io documentation](https://help.split.io/)
- Review the [Terraform Split provider docs](https://registry.terraform.io/providers/splitsoftware/split/latest/docs)
- See the main module documentation in `../../modules/split-administration/README.md`

## Next Steps

1. **Add Feature Flags**: Use the split-feature-flags module
2. **Set Up Monitoring**: Implement health checks and alerting
3. **Configure CI/CD**: Automate deployments with your CI/CD pipeline
4. **Scale Up**: Graduate to the enterprise setup example for more complex needs

## Clean Up

To remove all resources:
```bash
terraform destroy
```

**Warning**: This will permanently delete all Split.io resources created by this configuration.