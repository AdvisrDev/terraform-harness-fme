# Banking Platform Administration

This implementation focuses on setting up the Split.io administrative infrastructure for a banking platform, including workspace, environments, traffic types, attributes, segments, and API keys.

## Overview

The banking platform administration module creates the foundational Split.io infrastructure that supports feature flag operations. This is the first step in a two-part implementation:

1. **Administration Setup** (this module) - Creates the Split.io infrastructure
2. **Feature Flag Management** - Uses the infrastructure to deploy feature flags

## Architecture

```
Banking Platform Administration
├── Workspace: SecureBank-banking-platform
├── Environments: development, testing, staging, production
├── Traffic Types: customer, account, transaction, employee, device, branch, service
├── Attributes: tier, region, kyc_status, risk_score, type, balance_tier, etc.
├── Segments: wealth_customers, eu_customers, high_risk_customers, etc.
└── API Keys: Environment-specific with role-based access
```

## Usage

### 1. Deploy Administration Infrastructure

```bash
# Development environment
terraform init
terraform plan -var-file="environments/development.tfvars"
terraform apply -var-file="environments/development.tfvars"

# Production environment  
terraform plan -var-file="environments/production.tfvars"
terraform apply -var-file="environments/production.tfvars"
```

### 2. Capture Outputs for Feature Flags

After deployment, capture the outputs needed for feature flag deployment:

```bash
# Get administration outputs
terraform output -json > administration-outputs.json

# Key outputs needed for feature flags:
terraform output workspace_id
terraform output environment_ids
terraform output traffic_type_ids
```

### 3. Environment-Specific Configurations

#### Development Environment
- **Purpose**: Feature development and testing
- **Security**: Relaxed (synthetic data)
- **Monitoring**: Basic level
- **API Keys**: Full access for development team
- **Segment Keys**: Synthetic test data included

#### Production Environment
- **Purpose**: Live customer operations
- **Security**: Maximum (PCI-DSS, SOX, GDPR compliant)
- **Monitoring**: Maximum level with alerting
- **API Keys**: Read-only with strict role separation
- **Segment Keys**: Managed externally through secure processes

## Integration with Feature Flags

This administration setup provides the foundation for the banking-platform-feature-flags implementation:

```bash
# Use administration outputs in feature flag deployment
cd ../banking-platform-feature-flags

# Set variables from administration outputs
export TF_VAR_workspace_id="$(cd ../banking-platform-administration && terraform output -raw workspace_id)"
export TF_VAR_environment_id="$(cd ../banking-platform-administration && terraform output -raw development_environment_id)"
export TF_VAR_traffic_type_id="$(cd ../banking-platform-administration && terraform output -raw customer_traffic_type_id)"

# Deploy feature flags
terraform plan -var-file="environments/development.tfvars"
terraform apply -var-file="environments/development.tfvars"
```

## Key Resources Created

### Traffic Types
- **customer**: Bank customers with tier, region, KYC status attributes
- **account**: Bank accounts with type, balance tier, status attributes  
- **transaction**: Financial transactions with amount tier, channel attributes
- **employee**: Bank employees with role-based attributes
- **device**: Customer devices with trust level attributes
- **branch**: Bank branches for location-based features
- **service**: Banking services for technical features

### Segments
- **Customer Segments**: wealth_customers, private_banking_customers, high_risk_customers
- **Geographic Segments**: eu_customers, us_customers (for compliance)
- **Product Segments**: mortgage_customers, investment_customers
- **Operational Segments**: mobile_banking_users, atm_users

### API Keys
- Environment-specific keys with role-based access:
  - **Development**: Admin, automation, mobile, web
  - **Testing**: Server, automation  
  - **Staging**: Server, mobile, web
  - **Production**: Read-only server, automation, platform-specific mobile/web

## Compliance and Security

### Banking Compliance
- **PCI-DSS**: Payment card data protection
- **SOX**: Financial reporting controls
- **GDPR**: European data protection
- **Basel III**: Banking capital requirements
- **KYC/AML**: Customer verification and anti-money laundering

### Security Controls
- Encryption enabled for production
- Audit logging for compliance tracking
- API key rotation (30-180 days based on environment)
- Role-based access control
- Environment isolation

## Monitoring

### CloudWatch Dashboards
- Administration infrastructure health
- API key usage metrics
- Compliance score tracking
- Security events monitoring

### Alerts
- Infrastructure health degradation
- Compliance violations
- Security incidents
- API key rotation reminders

## Next Steps

After administration deployment:

1. **Verify Infrastructure**: Review all created resources
2. **Configure Segment Keys**: Set up production segment keys through secure processes  
3. **Deploy Feature Flags**: Use the banking-platform-feature-flags implementation
4. **Set Up Monitoring**: Configure alerts and dashboards
5. **Security Review**: Conduct security audit and penetration testing
6. **Compliance Validation**: Verify all compliance requirements are met

## Files Structure

```
banking-platform-administration/
├── main.tf                          # Main administration infrastructure
├── variables.tf                     # Input variables
├── outputs.tf                       # Output values for feature flags
├── provider.tf                      # Provider configuration
├── versions.tf                      # Version constraints
├── terraform.tfvars.example         # Example configuration
├── environments/
│   ├── development.tfvars           # Development environment config
│   ├── production.tfvars            # Production environment config
│   └── staging.tfvars               # Staging environment config
└── README.md                        # This file
```