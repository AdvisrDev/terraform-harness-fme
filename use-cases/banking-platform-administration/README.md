# Banking Platform Administration Use Case

This use case demonstrates how to set up Split.io infrastructure for a banking platform using the `split-administration` module with environment-specific configurations.

## Overview

The banking platform administration creates the foundational Split.io infrastructure including workspace, environments, traffic types, segments, and API keys with environment-specific overrides.

## Architecture

```
split-administration Module
├── Workspace: SecureBank-banking-platform
├── Environments: development, staging, production
├── Traffic Types: customer, account, transaction
├── Segments: premium_customers, high_risk_customers
└── API Keys: Environment-specific with role-based access
```

## Implementation

### Module Usage

```hcl
# main.tf
module "split_administration" {
  source = "../../modules/split-administration"

  environment_name         = var.environment_name
  workspace                = var.workspace
  environments             = var.environments
  traffic_types            = var.traffic_types
  traffic_type_attributes  = var.traffic_type_attributes
  segments                 = var.segments
  environment_segment_keys = var.environment_segment_keys
  api_keys                 = var.api_keys
}
```

### Configuration Structure

**File Structure:**
```
├── common.tfvars           # Shared configurations
├── environments/
│   ├── development.tfvars  # Dev-specific items
│   ├── staging.tfvars      # Staging-specific items
│   └── production.tfvars   # Prod-specific items
```

**Key Features:**
- Environment filtering for API keys and segment keys
- Configuration merging with environment-specific overrides
- Centralized common configurations with environment-specific additions

## Usage

### Deploy to Development
```bash
terraform apply \
  -var-file="common.tfvars" \
  -var-file="environments/development.tfvars"
```

### Deploy to Production
```bash
terraform apply \
  -var-file="common.tfvars" \
  -var-file="environments/production.tfvars"
```

## Configuration Patterns

### Environment-Specific API Keys
- Common API keys with environment-specific names and configurations
- Development-only debug keys with full access
- Production keys with read-only access and strict role separation

### Environment-Specific Segment Keys
- Development: Synthetic test data for segments
- Production: External management through secure processes

## Outputs

The module provides outputs for integration with feature flag modules:
- `workspace_id`: For feature flag workspace reference
- `environment_ids`: For environment-specific feature flag deployment
- `traffic_type_ids`: For feature flag traffic type reference

## Integration with Feature Flags

Use outputs from this module as inputs to the feature flags module:

```hcl
# In feature flags use case
module "feature_flags" {
  source = "../../modules/split-feature-flags"
  
  workspace_name    = "SecureBank-banking-platform"  # From admin workspace
  environment_name  = "development"                  # Target environment
  traffic_type_name = "customer"                     # From admin traffic types
  feature_flags     = var.feature_flags
}
```

This provides a clean foundation for managing Split.io infrastructure at scale with proper environment isolation and configuration management.