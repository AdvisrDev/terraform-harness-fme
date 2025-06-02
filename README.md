# Split.io Feature Flags Terraform Infrastructure

A comprehensive Terraform infrastructure for managing Split.io feature flags across multiple environments and use cases.

## 📁 Repository Structure

```
.
├── modules/
│   └── split-feature-flags/          # Reusable Terraform module
│       ├── main.tf                   # Core module resources
│       ├── variables.tf              # Module input variables
│       ├── outputs.tf                # Module outputs
│       ├── versions.tf               # Provider requirements
│       └── README.md                 # Module documentation
│
├── use-cases/
│   └── banking-platform/             # Banking platform implementation
│       └── README.md                 # Use case documentation
│
├── examples/
│   ├── simple-feature-flag/          # Basic feature flag example
│   └── advanced-targeting/           # Advanced targeting example
│
└── README.md                         # This file
```

## 🚀 Quick Start

### 1. Choose Your Implementation Path

#### **Option A: Use an Existing Use Case**
```bash
cd use-cases/[use-case-name]
# Follow the specific use case README instructions
```

#### **Option B: Create a New Use Case**
```bash
# Copy an existing use case as a template
cp -r use-cases/banking-platform use-cases/my-new-use-case
cd use-cases/my-new-use-case
# Customize for your specific needs
```

#### **Option C: Use the Module Directly**
```hcl
module "my_feature_flags" {
  source = "./modules/split-feature-flags"
  
  split_api_key     = var.split_api_key
  workspace_name    = "MyWorkspace"
  environment_name  = "production"
  is_production    = true
  feature_flags     = var.feature_flags
}
```

## 🏗️ Architecture

### Core Module (`modules/split-feature-flags/`)
- **Environment-agnostic** Terraform module
- **Type-safe** variable definitions with validation
- **Flexible** configuration for any use case
- **Production-ready** with security best practices

### Use Cases (`use-cases/`)
- **Real-world implementations** using the core module
- **Environment-specific** configurations
- **Best practices** for different scenarios

### Examples (`examples/`)
- **Simple examples** for quick learning
- **Advanced patterns** for complex scenarios
- **Copy-paste ready** configurations

## 📚 Examples

### Simple Feature Flag
Basic on/off toggle implementation.
```bash
cd examples/simple-feature-flag
```

### Advanced Targeting
Complex A/B testing with multiple treatments and targeting rules.
```bash
cd examples/advanced-targeting
```

## 🔧 Module Features

### ✅ **Environment Management**
- Multi-environment support (dev/staging/prod)
- Environment-specific variable files
- Production/non-production flag handling

### ✅ **Security Best Practices**
- Sensitive variable handling for API keys
- No hardcoded secrets in code
- Proper `.gitignore` configurations

### ✅ **Type Safety**
- Comprehensive input validation
- Required field enforcement
- Logical consistency checks

### ✅ **Flexibility**
- Support for complex targeting rules
- Multiple treatment configurations
- Custom JSON configurations per treatment

## 🚦 Getting Started

### Prerequisites
- Terraform >= 1.5
- Split.io account and API key
- Access to Split.io workspace

### Installation
1. **Clone this repository**
2. **Choose your implementation path** (see Quick Start above)
3. **Configure your Split.io API key**
4. **Initialize and apply Terraform**

### Environment Variables
Set your Split.io API key as an environment variable:
```bash
export TF_VAR_split_api_key="your-split-io-api-key"
```

Or use a `.tfvars` file:
```bash
echo 'split_api_key = "your-key"' > terraform.tfvars
```

## 📖 Documentation

### Module Documentation
- **Core Module**: `modules/split-feature-flags/README.md`
- **Use Cases**: Check individual README files in `use-cases/*/README.md`

### Key Concepts

#### Feature Flag Structure
```hcl
{
  name              = "feature-name"        # Unique identifier
  description       = "Feature description" # Human-readable description
  default_treatment = "off"                # Default treatment
  treatments = [                           # Available treatments
    {
      name           = "off"
      configurations = "{\"enabled\": false}"
      description    = "Feature disabled"
    }
  ]
  rules = [                               # Optional targeting rules
    {
      treatment = "on"                    # Treatment for this rule
      size      = 50                     # Percentage allocation
      condition = {                      # Targeting condition
        matcher = {
          type      = "IN_SEGMENT"
          attribute = "user_segment"
          strings   = ["beta_users"]
        }
      }
    }
  ]
}
```

## 🛠️ Best Practices

### 1. **Environment Management**
- Use separate state files per environment
- Leverage environment-specific `.tfvars` files
- Set `is_production = true` only for prod

### 2. **Security**
- Never commit real API keys to version control
- Use environment variables or secret management
- Review `.gitignore` files regularly

### 3. **Feature Flag Design**
- Use descriptive names and descriptions
- Always provide at least 2 treatments
- Start with conservative rollout percentages
- Include meaningful JSON configurations

### 4. **State Management**
For production environments, configure remote state:
```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "split-feature-flags/terraform.tfstate"
    region = "us-east-1"
  }
}
```


## 🤝 Contributing

1. **Fork the repository**
2. **Create a feature branch**
3. **Add your use case or example**
4. **Update documentation**
5. **Submit a pull request**

### Adding a New Use Case
1. Copy the banking platform template
2. Customize for your specific needs
3. Add comprehensive documentation
4. Include environment configurations
5. Test across multiple environments

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

### For Module Issues
- Check the module documentation: `modules/split-feature-flags/README.md`
- Review examples in the `examples/` directory

### For Split.io Provider Issues
- Visit: [davidji99/terraform-provider-split](https://github.com/davidji99/terraform-provider-split)

### For Split.io Platform Issues
- Visit: [Split.io Documentation](https://help.split.io/)

## 🔗 Related Resources

- [Split.io Documentation](https://help.split.io/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [Split.io Terraform Provider](https://registry.terraform.io/providers/davidji99/split/latest)