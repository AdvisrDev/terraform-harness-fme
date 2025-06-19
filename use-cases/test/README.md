# Administration-Only Use Case

This use case demonstrates how to set up only the Harness Feature Management and Experimentation administrative infrastructure using the `split-administration` module. This is perfect for establishing the foundational infrastructure before deploying feature flags.

## Overview

The administration-only setup creates the essential infrastructure components:
- Workspace configuration
- Environment setup
- Traffic types and attributes
- User segments
- API keys with environment-specific configurations
- Environment segment keys

## Usage

### 1. Configure Variables

Copy the example configuration and customize for your needs:

```bash
cp example.tfvars terraform.tfvars
# Edit terraform.tfvars with your specific values
```

### 2. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file="terraform.tfvars"

# Apply the configuration
terraform apply -var-file="terraform.tfvars"
```

### 3. Use Outputs for Feature Flags

After deployment, use the outputs to configure feature flag modules:

```bash
# Get workspace name for feature flags
terraform output -raw infrastructure_summary

# Example integration with feature flags module
export WORKSPACE_NAME=$(terraform output -json infrastructure_summary | jq -r '.workspace_name')
export ENVIRONMENT_NAME=$(terraform output -json infrastructure_summary | jq -r '.environment_name')
```

## Key Features

### Environment-Specific API Keys
- Common API keys deployed across specified environments
- Environment-specific naming and role configurations
- Development-only administrative keys

### Traffic Types and Attributes
- Configurable traffic types for different entity types
- Custom attributes with validation and suggested values
- Support for multiple data types

### Segment Management
- User segments with environment-specific keys
- Development and staging test data
- Production-ready segment configurations

## Configuration Patterns

### Minimal Setup
```hcl
workspace = {
  name = "MyWorkspace"
  create_workspace = true
}

environments = {
  dev = { name = "dev", production = false }
  prod = { name = "prod", production = true }
}

traffic_types = {
  user = { name = "user", display_name = "User" }
}
```

### Production-Ready Setup
See `example.tfvars` for a comprehensive configuration with:
- Multiple environments (dev, staging, prod)
- Multiple traffic types with attributes
- Environment-specific API key configurations
- Segment management with test data

## Integration with Feature Flags

This infrastructure serves as the foundation for feature flag deployments:

```hcl
# In a separate feature flags configuration
module "feature_flags" {
  source = "../feature-flags-only"
  
  workspace_name    = module.administration.infrastructure_summary.workspace_name
  environment_name  = module.administration.infrastructure_summary.environment_name
  traffic_type_name = "user"
  
  feature_flags = [
    # Your feature flags here
  ]
}
```

## Best Practices

1. **Environment Isolation**: Use environment filtering to control resource deployment
2. **API Key Security**: Use different roles and permissions per environment
3. **Segment Management**: Separate test data from production data
4. **Validation**: Leverage built-in validation for configuration consistency

This provides a solid foundation for managing Harness FME infrastructure at scale with proper environment isolation and configuration management.