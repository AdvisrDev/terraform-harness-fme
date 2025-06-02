# Banking Platform - Split.io Feature Flags

This use case implements Split.io feature flags for a banking platform, including transaction validation and promotional offers.

## Features

- **Bank Validation**: Backend feature flag for transaction validation (`bankvalidation`)
- **Harness Offer**: Frontend feature flag for promotional offers (`harnessoffer`)
- **Multi-Environment Support**: Dev, staging, and production configurations
- **Customer Targeting**: Rule-based targeting by customer ID
- **Single Feature Flag Definition**: Shared feature flags across all environments

## Architecture

This banking platform implementation uses:
- **Core Module**: `../../modules/split-feature-flags` for Split.io integration
- **Environment Files**: Separate `.tfvars` files for each environment (dev/staging/prod)
- **Feature Flag Definition**: Single `feature-flags.tfvars` shared across environments
- **Clean Separation**: Environment settings separate from feature flag definitions

## Quick Start

1. **Navigate to the banking platform directory:**
   ```bash
   cd use-cases/banking-platform
   ```

2. **Set up your configuration:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars and add your Split.io API key
   ```

3. **Deploy to development:**
   ```bash
   terraform init
   terraform plan -var-file="environments/dev.tfvars" -var-file="feature-flags.tfvars"
   terraform apply -var-file="environments/dev.tfvars" -var-file="feature-flags.tfvars"
   ```

## Multi-Environment Deployment

The banking platform supports clean multi-environment deployments using separate variable files:

### Environment-Specific Deployments

```bash
# Development Environment
terraform apply \
  -var-file="environments/dev.tfvars" \
  -var-file="feature-flags.tfvars" \
  -var="split_api_key=your-key"

# Staging Environment  
terraform apply \
  -var-file="environments/staging.tfvars" \
  -var-file="feature-flags.tfvars" \
  -var="split_api_key=your-key"

# Production Environment
terraform apply \
  -var-file="environments/prod.tfvars" \
  -var-file="feature-flags.tfvars" \
  -var="split_api_key=your-key"
```

### File Structure

```
use-cases/banking-platform/
├── environments/
│   ├── dev.tfvars      # Dev-specific settings (environment_name, is_production)
│   ├── staging.tfvars  # Staging-specific settings
│   └── prod.tfvars     # Production-specific settings
├── feature-flags.tfvars # Shared feature flag definitions
└── terraform.tfvars    # API key and workspace settings
```

## Feature Flags

### Bank Validation (`bankvalidation`)
- **Purpose**: Controls transaction validation logic
- **Type**: Backend feature flag
- **Treatments**: `off`, `on`
- **Targeting**: Specific customer IDs (`user123`)

### Harness Offer (`harnessoffer`)
- **Purpose**: Controls promotional offer display
- **Type**: Frontend feature flag
- **Treatments**: `off`, `on`
- **Targeting**: No specific rules (default rollout)

## Configuration

### Unified Configuration

All feature flags and workspace settings are defined in `terraform.tfvars` and shared across all environments. This approach provides:
- **Consistency**: Same feature flags across dev/staging/prod
- **Maintainability**: Single source of truth for all configuration
- **Flexibility**: Environment-specific filtering and behavior
- **Environment Order Management**: Automatic creation order based on feature flag allowed environments

### Environment Creation Order

Feature flags are automatically filtered based on environment creation order: `dev → staging → prod`. This ensures:

- **Development-only features** (`environments = ["dev"]`) only appear in dev
- **Testing features** (`environments = ["dev", "staging"]`) appear in dev and staging but not prod
- **Production-ready features** (`environments = ["dev", "staging", "prod"]`) appear in all environments

**Example from current configuration:**
| Feature Flag | Dev | Staging | Prod | Reason |
|-------------|-----|---------|------|--------|
| `voice-banking-beta` | ✅ | ❌ | ❌ | Development only |
| `advanced-fraud-detection` | ✅ | ✅ | ❌ | Testing phase |
| `bankvalidation` | ✅ | ✅ | ✅ | Production ready |

### Environment Configuration

Each environment has its own `.tfvars` file containing only environment-specific settings:

| Environment | File | Settings |
|-------------|------|----------|
| Development | `environments/dev.tfvars` | `environment_name = "dev"`, `is_production = false` |
| Staging | `environments/staging.tfvars` | `environment_name = "staging"`, `is_production = false` |
| Production | `environments/prod.tfvars` | `environment_name = "prod"`, `is_production = true` |

### Variables Reference

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `split_api_key` | Split.io API key | ✅ Yes | - |
| `environment_name` | Environment name | ✅ Yes | - |
| `is_production` | Production flag | ✅ Yes | - |
| `workspace_name` | Split.io workspace | No | "Default" |
| `traffic_type_name` | Traffic type | No | "user" |
| `feature_flags` | Feature flag definitions | ✅ Yes | - |

## Advanced Usage

### Modifying Feature Flags

To customize the banking platform feature flags:

1. **Edit the feature flags file:**
   ```bash
   # Edit feature-flags.tfvars to modify feature flag definitions
   vim feature-flags.tfvars
   ```

2. **Apply changes to specific environment:**
   ```bash
   terraform plan -var-file="environments/prod.tfvars" -var-file="feature-flags.tfvars"
   terraform apply -var-file="environments/prod.tfvars" -var-file="feature-flags.tfvars"
   ```

### Adding New Feature Flags

Add new feature flags to `feature-flags.tfvars`:

```hcl
# Add to feature-flags.tfvars
feature_flags = [
  # ... existing flags ...
  {
    name              = "new-banking-feature"
    description       = "New banking feature for premium customers"
    default_treatment = "off"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enabled\": false}"
        description    = "Feature disabled"
      },
      {
        name           = "premium"
        configurations = "{\"enabled\": true, \"tier\": \"premium\"}"
        description    = "Premium tier enabled"
      }
    ]
    rules = [
      {
        treatment = "premium"
        size      = 25
        condition = {
          matcher = {
            type      = "IN_SEGMENT"
            attribute = "segment"
            strings   = ["premium_customers"]
          }
        }
      }
    ]
  }
]
```

## Outputs

The module provides the following outputs:

- `workspace_id`: Split.io workspace ID
- `environment_id`: Split.io environment ID
- `banking_feature_flags`: Created feature flags details
- `banking_feature_flag_definitions`: Feature flag definitions

## Best Practices

### 1. **Environment Isolation**
- Use separate Terraform workspaces for each environment
- Keep environment-specific settings minimal and focused
- Use shared feature flag definitions for consistency

### 2. **State Management**
For production use, configure remote state management:

```hcl
# Add to versions.tf or create backend.tf
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "banking-platform/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### 3. **Security**
- Store API keys in environment variables or secret management systems
- Never commit `terraform.tfvars` with real API keys
- Use different Split.io API keys for different environments when possible

### 4. **Testing**
Before applying to production:

```bash
# Validate configuration
terraform validate

# Plan changes
terraform plan -var-file="environments/prod.tfvars" -var="split_api_key=your-key"

# Apply with confirmation
terraform apply -var-file="environments/prod.tfvars" -var="split_api_key=your-key"
```

## Module Integration

This banking platform use case demonstrates how to effectively use the core `split-feature-flags` module (`../../modules/split-feature-flags`) with:
- Clean variable passing
- Environment-specific configurations
- Shared feature flag definitions
- Production-ready patterns

## Support

- **Core Module Documentation**: `../../modules/split-feature-flags/README.md`
- **Split.io Documentation**: [help.split.io](https://help.split.io/)
- **Terraform Documentation**: [terraform.io](https://www.terraform.io/docs/)