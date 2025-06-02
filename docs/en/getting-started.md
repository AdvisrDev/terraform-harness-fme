# Getting Started with Split.io Feature Flags and Terraform

This guide will walk you through setting up and deploying your first feature flags using our Terraform module.

## 📋 Prerequisites

Before you begin, ensure you have:

- **Terraform** >= 1.5 installed ([Download here](https://www.terraform.io/downloads))
- **Split.io account** with API access ([Sign up here](https://www.split.io/))
- **Git** for cloning the repository
- **Basic knowledge** of Terraform and feature flags

## 🚀 Step 1: Environment Setup

### 1.1 Clone the Repository

```bash
git clone <repository-url>
cd split-feature-flags-terraform
```

### 1.2 Get Your Split.io API Key

1. Log into your Split.io account
2. Navigate to **Admin Settings** → **API Keys**
3. Create a new API key or copy an existing one
4. Note your workspace name

### 1.3 Set Environment Variables

```bash
# Set your Split.io API key
export TF_VAR_split_api_key="your-split-io-api-key"

# Optional: Set workspace name
export TF_VAR_workspace_name="your-workspace-name"
```

## 🎯 Step 2: Choose Your Implementation Path

You have three options for getting started:

### Option A: Banking Platform Use Case (Recommended for Beginners)
Pre-configured example with banking-specific feature flags.

### Option B: Simple Example
Basic feature flag setup for learning.

### Option C: Custom Implementation
Build your own using the core module.

Let's start with **Option A** - the Banking Platform:

## 🏦 Step 3: Banking Platform Setup

### 3.1 Navigate to Banking Platform

```bash
cd use-cases/banking-platform
```

### 3.2 Review the Configuration

The banking platform includes:

```hcl
# terraform.tfvars - Main configuration
feature_flags = [
  {
    name              = "bankvalidation"
    description       = "Backend transaction validation"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"validation\": false}"
        description    = "Validation disabled"
      },
      {
        name           = "on"
        configurations = "{\"validation\": true, \"strict\": true}"
        description    = "Strict validation enabled"
      }
    ]
    rules = [
      {
        condition = {
          matcher = {
            type      = "EQUAL_SET"
            attribute = "customerID"
            strings   = ["user123"]
          }
        }
      }
    ]
  }
  # ... more feature flags
]
```

### 3.3 Environment Files

Each environment has its own configuration:

```bash
# environments/dev.tfvars
environment_name = "dev"
is_production    = false

# environments/staging.tfvars
environment_name = "staging"
is_production    = false

# environments/prod.tfvars
environment_name = "prod"
is_production    = true
```

## 🚀 Step 4: Deploy to Development

### 4.1 Initialize Terraform

```bash
terraform init
```

### 4.2 Plan the Deployment

```bash
terraform plan \
  -var-file="environments/dev.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

Review the planned changes:
- Workspace creation/verification
- Development environment creation
- Feature flags that will be created in development

### 4.3 Apply the Configuration

```bash
terraform apply \
  -var-file="environments/dev.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

Type `yes` when prompted to confirm.

### 4.4 Verify Deployment

Check your Split.io dashboard:
1. Navigate to your workspace
2. Verify the development environment was created
3. Check that feature flags are listed
4. Verify targeting rules are configured

## 📊 Step 5: Understanding Environment Filtering

The system automatically filters feature flags based on environment:

### Development Environment
```bash
# All flags marked for "dev" will be created
terraform apply -var-file="environments/dev.tfvars" -var="split_api_key=your-key"
```

**Result**: Creates flags with `environments = ["dev"]` or containing `"dev"`

### Staging Environment
```bash
# Only flags marked for "staging" will be created
terraform apply -var-file="environments/staging.tfvars" -var="split_api_key=your-key"
```

**Result**: Creates flags with `environments` containing `"staging"`

### Production Environment
```bash
# Only production-ready flags will be created
terraform apply -var-file="environments/prod.tfvars" -var="split_api_key=your-key"
```

**Result**: Creates only flags with `environments` containing `"prod"`

## 🔧 Step 6: Deploy to Additional Environments

### 6.1 Deploy to Staging

```bash
terraform apply \
  -var-file="environments/staging.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

### 6.2 Deploy to Production

```bash
terraform apply \
  -var-file="environments/prod.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

**Note**: Only flags marked with `environments = ["dev", "staging", "prod"]` will be deployed to production.

## 📈 Step 7: Verify Environment Safety

Check that experimental features are properly filtered:

1. **In Development**: All feature flags should be visible
2. **In Staging**: Features marked for staging and production should be visible
3. **In Production**: Only production-ready features should be visible

Example safety check:
- `voice-banking-beta` should only appear in development
- `advanced-fraud-detection` should appear in development and staging
- `bankvalidation` should appear in all environments

## 🛠️ Step 8: Customizing Your Feature Flags

### 8.1 Modify Existing Flags

Edit `terraform.tfvars`:

```hcl
feature_flags = [
  {
    name              = "my-custom-feature"
    description       = "Custom feature for my application"
    default_treatment = "off"
    environments      = ["dev"]  # Start with dev only
    lifecycle_stage   = "development"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enabled\": false}"
        description    = "Feature disabled"
      },
      {
        name           = "on"
        configurations = "{\"enabled\": true, \"config\": \"value\"}"
        description    = "Feature enabled"
      }
    ]
    rules = []  # No targeting rules initially
  }
]
```

### 8.2 Apply Changes

```bash
terraform plan -var-file="environments/dev.tfvars" -var="split_api_key=$TF_VAR_split_api_key"
terraform apply -var-file="environments/dev.tfvars" -var="split_api_key=$TF_VAR_split_api_key"
```

## 📚 Step 9: Explore Advanced Features

### 9.1 Review Feature Management

Learn about advanced feature flag strategies:
```bash
# Read the feature management guide
cat docs/en/feature-management.md
```

### 9.2 Check Examples

Explore additional examples:
```bash
# Simple feature flag example
cd examples/simple-feature-flag

# Advanced targeting example
cd examples/advanced-targeting

# Lifecycle management example
cd examples/feature-flag-lifecycle
```

### 9.3 Read Best Practices

```bash
cat docs/en/best-practices.md
```

## 🐛 Troubleshooting

### Common Issues

#### 1. API Key Issues
```
Error: Unable to authenticate with Split.io
```
**Solution**: Verify your API key is correct and has proper permissions.

#### 2. Workspace Not Found
```
Error: Workspace 'MyWorkspace' not found
```
**Solution**: Ensure the workspace name in your configuration matches your Split.io workspace.

#### 3. Environment Already Exists
```
Error: Environment already exists
```
**Solution**: This is normal if the environment was created previously. Terraform will manage the existing environment.

#### 4. Feature Flag Validation Errors
```
Error: Feature flag name cannot be empty
```
**Solution**: Check your feature flag configuration for missing required fields.

### Debug Commands

```bash
# Validate configuration
terraform validate

# Check current state
terraform show

# Refresh state
terraform refresh -var-file="environments/dev.tfvars" -var="split_api_key=$TF_VAR_split_api_key"
```

## ✅ Step 10: Next Steps

Congratulations! You've successfully deployed your first feature flags. Here's what to do next:

### 1. Learn Advanced Patterns
- [Feature Management Strategies](feature-management.md)
- [Best Practices Guide](best-practices.md)
- [Architecture Deep Dive](architecture.md)

### 2. Explore More Use Cases
- Banking Platform (you just completed this!)
- E-commerce Platform (coming soon)
- Mobile Applications (coming soon)

### 3. Integrate with Your Application
- Install Split.io SDK for your programming language
- Configure feature flag evaluation in your code
- Set up monitoring and analytics

### 4. Production Readiness
- Configure remote state management
- Set up CI/CD integration
- Implement proper secret management
- Configure monitoring and alerting

## 🔗 Quick Links

- [Architecture Overview](architecture.md)
- [Feature Management Guide](feature-management.md)
- [Best Practices](best-practices.md)
- [Use Cases](use-cases.md)
- [Contributing](contributing.md)

## 🆘 Need Help?

- Check the [troubleshooting section](#troubleshooting) above
- Review the [examples directory](../../examples/)
- Read the [best practices guide](best-practices.md)
- Open an issue on GitHub

---

**Ready for the next step?** Choose your path:

- 🏗️ [**Architecture Deep Dive**](architecture.md) - Understand how it works
- 🎯 [**Feature Management**](feature-management.md) - Advanced strategies
- 💡 [**Best Practices**](best-practices.md) - Production patterns
- 🌍 [**Español Documentation**](../es/primeros-pasos.md) - Spanish version