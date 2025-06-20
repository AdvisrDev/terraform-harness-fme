# Banking Platform Feature Flags Use Case

This use case demonstrates how to deploy feature flags for a banking platform using the `split-feature-flags` module with environment-specific configurations.

## Overview

The banking platform feature flags module manages feature flag deployments with flexible environment-specific configurations, supporting same treatments across environments OR different configurations per environment.

## Architecture

```
split-feature-flags Module
├── Feature Flags with Environment Configs
│   ├── enhanced-mobile-dashboard
│   ├── biometric-authentication  
│   ├── real-time-fraud-detection
│   └── instant-transfers
└── Environment-Specific Configurations
    ├── Development: Full features enabled
    ├── Staging: Conservative rollout
    └── Production: Minimal rollout
```

## Implementation

### Module Usage

This use case consumes the root module, which internally uses the split-feature-flags module:

```hcl
# main.tf - Uses root module
module "banking_platform_feature_flags" {
  source = "../../"

  workspace         = var.workspace
  environment_name  = var.environment_name
  traffic_type_name = var.traffic_type_name
  
  # Non-empty feature_flags triggers feature-flags mode
  feature_flags = var.feature_flags
}
```

### Configuration Patterns

**File Structure:**
```
├── common.tfvars           # Shared feature flags
├── environments/
│   ├── development.tfvars  # Dev-specific flags
│   ├── staging.tfvars      # Staging-specific flags
│   └── production.tfvars   # Prod-specific flags
```

## Feature Flag Examples

### 1. Same Configuration Across Environments

```hcl
# Kill switch - same everywhere
{
  name = "system-maintenance-mode"
  environments = ["dev", "staging", "prod"]
  default_treatment = "active"
  treatments = [
    { name = "active", configurations = "{\"enabled\": true}" },
    { name = "maintenance", configurations = "{\"enabled\": false}" }
  ]
  # No environment_configs = same configuration everywhere
}
```

### 2. Environment-Specific Configurations

```hcl
# Enhanced mobile dashboard with different configs per environment
{
  name = "enhanced-mobile-dashboard"
  environments = ["dev", "staging", "prod"]
  default_treatment = "off"
  
  treatments = [
    { name = "off", configurations = "{\"enabled\": false}" },
    { name = "enhanced", configurations = "{\"analytics\": true}" }
  ]
  
  environment_configs = {
    dev = {
      default_treatment = "enhanced"
      rules = [{ treatment = "enhanced", size = 100 }]
    }
    staging = {
      rules = [{ treatment = "enhanced", size = 50 }]
    }
    prod = {
      rules = [{ treatment = "enhanced", size = 10 }]
    }
  }
}
```

### 3. Environment-Only Features

```hcl
# Debug features only in development
{
  name = "debug-panel"
  environments = ["dev"]  # Only deployed to development
  default_treatment = "on"
  treatments = [
    { name = "off", configurations = "{\"debug\": false}" },
    { name = "on", configurations = "{\"debug\": true}" }
  ]
}
```

## Usage

### Deploy Feature Flags to Development
```bash
terraform apply \
  -var-file="environments/common.tfvars" \
  -var-file="environments/development.tfvars"
```

### Deploy Feature Flags to Production  
```bash
terraform apply \
  -var-file="environments/common.tfvars" \
  -var-file="environments/production.tfvars"
```

**Note**: This use case operates in **feature flags mode** since `feature_flags` contains feature flag definitions. This requires the workspace and traffic types to already exist (created by the administration use case).

## Environment Strategies

### Development Environment
- **Rollout**: 100% for most features
- **Purpose**: Full feature testing and validation
- **Configuration**: Enhanced debugging and monitoring

### Staging Environment
- **Rollout**: 50% maximum for new features
- **Purpose**: Production-like testing with gradual rollout
- **Configuration**: Production-like with enhanced monitoring

### Production Environment
- **Rollout**: 10% maximum for new features
- **Purpose**: Live customer operations with conservative rollout
- **Configuration**: Optimized for performance and security

## Integration with Administration

This use case works with the infrastructure created by the **banking-platform-administration** use case using the same root module in different modes:

### Prerequisites
1. **Deploy Administration First**: Run banking-platform-administration use case to create:
   - Workspace (`AxoltlBank`)
   - Environments (dev, testing, staging, production)
   - Traffic types (customer, account, transaction, employee, device)
   - Segments and traffic type attributes

### Module Mode Selection
```hcl
# Administration use case (infrastructure setup)
module "banking_administration" {
  source = "../../"
  # ... configuration
  feature_flags = []  # Empty = administration mode
}

# Feature flags use case (feature deployment)
module "banking_feature_flags" {
  source = "../../"  # Same root module
  # ... configuration
  feature_flags = [  # Non-empty = feature flags mode
    { name = "feature1", ... }
  ]
}
```

### Deployment Sequence
1. **First**: Deploy `banking-platform-administration` (creates infrastructure)
2. **Then**: Deploy `banking-platform-feature-flags` (uses existing infrastructure)
3. **Reference Consistency**: Use the same workspace name and traffic type names

## Monitoring and Safety

### Production Safety
- Conservative rollout percentages (≤10%)
- Default treatments typically "off" for safety
- Environment filtering prevents accidental deployments
- Configuration validation ensures consistency

### Development Efficiency  
- Higher rollout percentages for testing
- Debug-enabled configurations
- Development-only experimental features

This provides a scalable approach to managing feature flags across multiple environments with clean separation of concerns and flexible configuration management.