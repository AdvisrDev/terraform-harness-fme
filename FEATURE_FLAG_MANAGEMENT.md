# Feature Flag Management Strategy

This document outlines the comprehensive strategy for managing feature flags across environments with safety, flexibility, and scalability.

## Overview

The feature flag management system provides:
- **Environment-specific deployment control**
- **Lifecycle stage management**
- **Category-based organization**
- **Automatic filtering to prevent accidental production deployments**
- **Comprehensive validation and safety checks**

## Core Concepts

### 1. Environment Filtering

Feature flags include an `environments` attribute that controls which environments they can be deployed to:

```hcl
{
  name         = "experimental-feature"
  environments = ["dev", "staging"]  # Will NOT deploy to prod
  # ... other attributes
}
```

The module automatically filters flags based on the current environment, ensuring:
- ✅ **Safety**: Experimental features can't accidentally reach production
- ✅ **Flexibility**: Same configuration file works across all environments
- ✅ **Clarity**: Explicit control over feature deployment

### 2. Lifecycle Stages

Feature flags progress through defined lifecycle stages:

| Stage | Purpose | Typical Environments |
|-------|---------|---------------------|
| `development` | Initial development and experimentation | `dev` only |
| `testing` | QA testing and validation | `dev`, `staging` |
| `staging` | Pre-production validation | `dev`, `staging` |
| `production` | Stable and production-ready | `dev`, `staging`, `prod` |
| `deprecated` | Being phased out | varies |

### 3. Categories

Feature flags are categorized by their purpose:

| Category | Purpose | Examples |
|----------|---------|----------|
| `feature` | New product functionality | UI changes, new features |
| `experiment` | A/B tests and experiments | UI variants, algorithm tests |
| `operational` | System behavior control | Timeouts, batch sizes |
| `permission` | Access control features | Role-based feature access |
| `killswitch` | Emergency controls | Circuit breakers, service fallbacks |

## Implementation Architecture

### Module Level (`modules/split-feature-flags/`)

The core module implements environment filtering using Terraform locals:

```hcl
locals {
  # Filter feature flags for current environment
  environment_feature_flags = [
    for ff in var.feature_flags : ff
    if contains(ff.environments, var.environment_name)
  ]
  
  feature_flags_map = { for ff in local.environment_feature_flags : ff.name => ff }
}

# Resources use filtered flags
resource "split_split" "this" {
  for_each = local.feature_flags_map
  # ...
}
```

### Use Case Level (`use-cases/banking-platform/`)

Use cases define feature flags with explicit environment and lifecycle controls:

```hcl
feature_flags = [
  {
    name              = "production-feature"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    # ...
  },
  {
    name              = "experimental-feature"
    environments      = ["dev"]  # Dev only
    lifecycle_stage   = "development"
    category          = "experiment"
    # ...
  }
]
```

## Feature Flag Promotion Workflow

### 1. Development Phase
```hcl
{
  name              = "new-feature"
  environments      = ["dev"]           # Dev only
  lifecycle_stage   = "development"     # Early stage
  category          = "feature"
}
```

### 2. Testing Phase
```hcl
{
  name              = "new-feature"
  environments      = ["dev", "staging"] # Add staging
  lifecycle_stage   = "testing"          # Ready for QA
  category          = "feature"
}
```

### 3. Production Phase
```hcl
{
  name              = "new-feature"
  environments      = ["dev", "staging", "prod"] # Add production
  lifecycle_stage   = "production"               # Stable
  category          = "feature"
}
```

### 4. Deprecation Phase
```hcl
{
  name              = "old-feature"
  environments      = ["prod"]          # Keep in prod for rollback
  lifecycle_stage   = "deprecated"      # Mark for removal
  category          = "feature"
}
```

## Deployment Patterns

### Same Configuration, Different Results

Using the same `feature-flags.tfvars` file across environments:

```bash
# Development - gets all dev-enabled flags
terraform apply -var-file="environments/dev.tfvars" -var-file="feature-flags.tfvars"

# Staging - gets only staging-enabled flags  
terraform apply -var-file="environments/staging.tfvars" -var-file="feature-flags.tfvars"

# Production - gets only production-ready flags
terraform apply -var-file="environments/prod.tfvars" -var-file="feature-flags.tfvars"
```

### Environment-Specific Results

| Flag Name | Dev | Staging | Prod | Reason |
|-----------|-----|---------|------|--------|
| `bankvalidation` | ✅ | ✅ | ✅ | Production-ready |
| `advanced-fraud-detection` | ✅ | ✅ | ❌ | Still in testing |
| `voice-banking-beta` | ✅ | ❌ | ❌ | Early development |
| `payment-gateway-fallback` | ✅ | ✅ | ✅ | Critical killswitch |

## Safety Mechanisms

### 1. Validation Rules

The module enforces comprehensive validation:

```hcl
validation {
  condition = alltrue([
    for ff in var.feature_flags : 
    contains(["development", "testing", "staging", "production", "deprecated"], ff.lifecycle_stage)
  ])
  error_message = "Invalid lifecycle stage."
}

validation {
  condition = alltrue([
    for ff in var.feature_flags : 
    length(ff.environments) > 0
  ])
  error_message = "Each feature flag must specify at least one environment."
}
```

### 2. Environment Filtering

Automatic filtering prevents deployment mistakes:
- Features marked `environments = ["dev"]` cannot deploy to production
- No manual intervention required - Terraform handles filtering
- Clear error messages for configuration issues

### 3. Lifecycle Tracking

Outputs provide visibility into feature flag status:

```bash
terraform output feature_flags_summary
# {
#   "by_lifecycle" = {
#     "development" = ["voice-banking-beta"]
#     "testing" = ["advanced-fraud-detection"]  
#     "production" = ["bankvalidation", "harnessoffer"]
#   }
#   "total_count" = 3
# }
```

## Best Practices

### 1. Start Restrictive
Always start new features with minimal environment exposure:
```hcl
environments = ["dev"]  # Start here
lifecycle_stage = "development"
```

### 2. Gradual Promotion
Expand environments gradually as confidence increases:
```
dev → dev,staging → dev,staging,prod
```

### 3. Use Categories Appropriately
- `experiment`: For A/B tests, use cautiously in production
- `killswitch`: Deploy to all environments immediately
- `feature`: Standard promotion workflow
- `operational`: Production-critical, thorough testing required

### 4. Lifecycle Management
- Update `lifecycle_stage` to match actual status
- Use `deprecated` before removing flags
- Monitor flag usage before deletion

### 5. Documentation
- Use descriptive names and descriptions
- Include reasoning in commit messages
- Document promotion decisions

## Advanced Patterns

### Environment-Specific Configurations

Use environment variables to modify behavior:

```hcl
{
  name = "feature-with-env-config"
  environments = ["dev", "staging", "prod"]
  treatments = [
    {
      name = "on"
      configurations = var.environment_name == "prod" ? 
        "{\"aggressive\": false}" : 
        "{\"aggressive\": true}"
    }
  ]
}
```

### Progressive Rollouts

Combine with targeting rules for careful production rollouts:

```hcl
{
  name = "gradual-rollout-feature"
  environments = ["dev", "staging", "prod"]
  rules = [
    {
      treatment = "on"
      size = var.environment_name == "prod" ? 5 : 100  # 5% in prod, 100% elsewhere
    }
  ]
}
```

## Monitoring and Observability

### Terraform Outputs

Use outputs to monitor feature flag deployment:

```bash
# Check what's deployed in current environment
terraform output filtered_feature_flags

# Get summary by category and lifecycle
terraform output feature_flags_summary
```

### Integration with CI/CD

```yaml
# Example GitHub Action
- name: Validate Feature Flags
  run: |
    terraform plan -var-file="environments/${{ matrix.env }}.tfvars"
    # Check outputs for unexpected flags in production
    if [[ "${{ matrix.env }}" == "prod" ]]; then
      terraform output -json filtered_feature_flags | jq '.value | map(select(.lifecycle_stage == "development")) | length' | grep -q "^0$"
    fi
```

## Migration and Rollback

### Adding New Features
1. Add to `feature-flags.tfvars` with `environments = ["dev"]`
2. Deploy to dev and test
3. Update `environments` and redeploy to promote

### Removing Features
1. Update `lifecycle_stage = "deprecated"`
2. Remove from `environments` gradually
3. Delete from configuration after verification

### Emergency Rollback
Use killswitch flags for immediate rollback:
```hcl
{
  name = "emergency-feature-disable"
  category = "killswitch"
  environments = ["dev", "staging", "prod"]
  default_treatment = "off"  # Safe default
}
```

## Conclusion

This feature flag management strategy provides:
- **Safety**: Prevents accidental production deployments
- **Flexibility**: Same configuration across environments
- **Visibility**: Clear lifecycle and category tracking
- **Scalability**: Supports complex promotion workflows
- **Maintainability**: Structured approach to flag lifecycle

The combination of environment filtering, lifecycle stages, and categories creates a robust system for managing feature flags at scale while maintaining safety and clarity.