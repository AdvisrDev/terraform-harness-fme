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

This use case consumes the root module, which internally uses the split-administration module:

```hcl
# main.tf - Uses root module
module "banking_platform_administration" {
  source = "../../"

  environment_name         = var.environment_name
  workspace                = var.workspace
  environments             = var.environments
  traffic_types            = var.traffic_types
  traffic_type_attributes  = var.traffic_type_attributes
  segments                 = var.segments
  environment_segment_keys = var.environment_segment_keys
  api_keys                 = var.api_keys
  
  # Empty feature_flags triggers administration-only mode
  feature_flags = []
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

### Deploy Shared Administration Setup Only
```bash
# Administration-only mode (infrastructure setup)
terraform apply \
  -var-file="environments/common.tfvars"
```

### Deploy with Environment-Specific Resources
```bash
# Add environment-specific API keys and segment keys
terraform apply \
  -var-file="environments/segmented_keys.tfvars" \
  -var-file="environments/development.tfvars"
```

**Note**: This use case operates in **administration mode** since `feature_flags = []` in the configuration. This ensures only infrastructure resources are created.

### Current Configuration Status
- ✅ **Workspace**: AxoltlBank (will be created)
- ✅ **Environments**: dev, testing, staging, production (4 environments)
- ✅ **Traffic Types**: customer, account, transaction, employee, device (5 types)
- ✅ **Traffic Type Attributes**: Configured with proper data types and suggested values
- ✅ **Segments**: 4 customer segments defined (wealth, high-risk, EU, mobile users)
- ⚠️ **API Keys**: Empty array (no API keys configured)
- ⚠️ **Environment Segment Keys**: Empty array (no segment keys configured)

To add API keys or segment keys, uncomment and configure the relevant sections in `environments/common.tfvars`.

## Configuration Patterns

### Environment-Specific API Keys
- Common API keys with environment-specific names and configurations
- Development-only debug keys with full access
- Production keys with read-only access and strict role separation

### Environment-Specific Segment Keys
- Development: Synthetic test data for segments
- Production: External management through secure processes

## Outputs

The module provides administration-specific outputs when active:
- `workspace_id`: Created workspace ID
- `workspace_name`: Workspace name 
- `workspace_created`: Whether workspace was created
- `environment_ids`: Map of environment names to IDs
- `traffic_type_ids`: Map of traffic type names to IDs
- `segment_ids`: Map of segment names to IDs
- `api_keys`: Created API keys (sensitive)
- `api_key_ids`: Map of API key names to IDs (sensitive)

## Integration with Feature Flags

This administration setup creates the foundation for feature flag deployments. To deploy feature flags, use the **banking-platform-feature-flags** use case which consumes the same root module but in feature flags mode:

```hcl
# Feature flags use case - separate deployment
module "banking_feature_flags" {
  source = "../../"  # Same root module
  
  workspace = { 
    name = "AxoltlBank"        # Same workspace name as administration
    create_workspace = false   # Workspace already exists
  }
  environment_name  = "development"
  traffic_type_name = "customer"  # From administration traffic types
  
  # Non-empty feature_flags triggers feature flags mode
  feature_flags = var.feature_flags
}
```

**Deployment Sequence:**
1. **First**: Deploy administration (this use case) to create infrastructure
2. **Then**: Deploy feature flags using the created workspace and traffic types

This provides a clean foundation for managing Split.io infrastructure at scale with proper environment isolation and configuration management.