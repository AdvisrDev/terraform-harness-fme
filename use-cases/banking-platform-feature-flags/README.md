# Banking Platform Feature Flags

This implementation focuses on deploying banking-specific feature flags using the infrastructure created by the banking-platform-administration module.

## Overview

The banking platform feature flags module deploys comprehensive feature flags for banking applications. This is the second step in a two-part implementation:

1. **Administration Setup** - Creates the Split.io infrastructure (prerequisite)
2. **Feature Flag Management** (this module) - Deploys banking feature flags

## Architecture

```
Banking Feature Flags
├── Customer Experience Features
│   ├── enhanced_mobile_dashboard
│   └── biometric_authentication
├── Security Features  
│   ├── real_time_fraud_detection
│   └── enhanced_kyc_verification
├── Payment Features
│   └── instant_transfers
├── Investment Features
│   └── robo_advisor
├── Compliance Features
│   └── gdpr_compliance_tools
└── Business Features
    ├── business_analytics_dashboard
    └── employee_risk_dashboard
```

## Prerequisites

### Required Administration Infrastructure
Before deploying feature flags, you must have the banking-platform-administration infrastructure deployed:

```bash
# Deploy administration first
cd ../banking-platform-administration
terraform apply -var-file="environments/development.tfvars"

# Capture required outputs
export WORKSPACE_ID=$(terraform output -raw workspace_id)
export ENVIRONMENT_ID=$(terraform output -raw development_environment_id)  
export TRAFFIC_TYPE_ID=$(terraform output -raw customer_traffic_type_id)
```

## Usage

### 1. Configure Integration Variables

Set the required variables from administration outputs:

```bash
# Option 1: Environment variables
export TF_VAR_workspace_id="$WORKSPACE_ID"
export TF_VAR_environment_id="$ENVIRONMENT_ID"
export TF_VAR_traffic_type_id="$TRAFFIC_TYPE_ID"

# Option 2: Update terraform.tfvars
cat > terraform.tfvars << EOF
workspace_id     = "$WORKSPACE_ID"
environment_id   = "$ENVIRONMENT_ID"
environment_name = "development"
traffic_type_id  = "$TRAFFIC_TYPE_ID"
EOF
```

### 2. Deploy Feature Flags

```bash
# Development environment
terraform init
terraform plan -var-file="environments/development.tfvars"
terraform apply -var-file="environments/development.tfvars"

# Production environment (conservative rollout)
terraform plan -var-file="environments/production.tfvars"
terraform apply -var-file="environments/production.tfvars"
```

### 3. Environment-Specific Deployments

#### Development Environment
- **Rollout Strategy**: Instant (100% immediately)
- **Features**: All features enabled for testing
- **Monitoring**: Basic level
- **Kill Switch**: Enabled for safety

#### Staging Environment  
- **Rollout Strategy**: Gradual (50% maximum)
- **Features**: Production subset for validation
- **Monitoring**: Enhanced level
- **Kill Switch**: Enabled with automated rollback

#### Production Environment
- **Rollout Strategy**: Conservative (10% maximum)
- **Features**: Core features only, AI disabled initially
- **Monitoring**: Maximum level with alerting
- **Kill Switch**: Enabled with strict automated rollback

## Feature Categories

### Customer Experience Features

#### Enhanced Mobile Dashboard
- **Purpose**: Advanced analytics and insights for mobile banking
- **Targeting**: Wealth customers in production, 50% in development
- **Treatments**: `off`, `enhanced`
- **Configuration**: Analytics, chart types, refresh intervals

#### Biometric Authentication
- **Purpose**: Secure biometric login for mobile banking
- **Targeting**: Verified devices in production, 80% in development  
- **Treatments**: `off`, `fingerprint`, `biometric_full`
- **Configuration**: Auth types, fallback options, timeouts

### Security Features

#### Real-time Fraud Detection
- **Purpose**: ML-powered fraud detection for transactions
- **Targeting**: High-value transactions in production, 100% in development
- **Treatments**: `off`, `enhanced`, `ai_powered`
- **Configuration**: ML models, confidence thresholds, real-time scoring

#### Enhanced KYC Verification  
- **Purpose**: AI-powered customer verification
- **Targeting**: Pending KYC customers, 90% in development
- **Treatments**: `off`, `document_ai`, `biometric_kyc`
- **Configuration**: Document AI, liveness detection, biometric matching

### Payment Features

#### Instant Transfers
- **Purpose**: Real-time money transfers
- **Targeting**: Premium customers in production, 70% in development
- **Treatments**: `off`, `instant_internal`, `instant_all`
- **Configuration**: Transfer types, limits, verification requirements

### Investment Features

#### Robo Advisor
- **Purpose**: AI-powered investment advice and portfolio management
- **Targeting**: Investment customers, 60% in development
- **Treatments**: `off`, `basic`, `advanced`
- **Configuration**: Portfolio rebalancing, risk assessment, tax optimization

### Compliance Features

#### GDPR Compliance Tools
- **Purpose**: Enhanced GDPR compliance and data management
- **Targeting**: EU customers (100% in production)
- **Treatments**: `off`, `enhanced`, `full_automation`
- **Configuration**: Data portability, consent management, automated deletion

### Business Features

#### Business Analytics Dashboard
- **Purpose**: Advanced analytics for business banking customers
- **Targeting**: Small business customers, 75% in development
- **Treatments**: `off`, `analytics`, `ai_insights`  
- **Configuration**: Cash flow analysis, expense categorization, predictive analytics

#### Employee Risk Dashboard
- **Purpose**: Risk monitoring dashboard for bank employees
- **Targeting**: Compliance officers (100% in production)
- **Treatments**: `off`, `risk_monitoring`, `advanced_analytics`
- **Configuration**: Real-time alerts, risk scores, automated case creation

## Segment-Based Targeting

### High-Value Customer Features
- `robo_advisor`: Advanced investment management
- `instant_transfers`: Premium transfer capabilities
- `enhanced_mobile_dashboard`: Rich analytics and insights
- `business_analytics_dashboard`: Business intelligence tools

### Compliance Customer Features
- `enhanced_kyc_verification`: Regulatory compliance
- `gdpr_compliance_tools`: Data protection compliance

## Environment Configurations

### Development
```hcl
environment_feature_overrides = {
  development = {
    default_treatment        = "off"
    max_rollout_percentage   = 100
    enable_advanced_features = true
    monitoring_level        = "basic"
    automated_rollback      = false
  }
}
```

### Production
```hcl
environment_feature_overrides = {
  production = {
    default_treatment        = "off" 
    max_rollout_percentage   = 10
    enable_advanced_features = false
    monitoring_level        = "maximum"
    automated_rollback      = true
  }
}
```

## Monitoring and Alerting

### CloudWatch Dashboards
- Feature flag evaluation metrics
- Feature usage and adoption
- Compliance and security metrics
- Performance and error tracking

### Production Alerts
- Feature flag evaluation errors (>1%)
- Fraud detection feature health (<99%)
- High evaluation latency (>50ms)
- Automated rollback triggers

## Integration Guide

### Application Integration
```javascript
// Example SDK configuration
const splitClient = SplitFactory({
  core: {
    authorizationKey: 'YOUR_SDK_KEY',
    key: 'customer_id',
    trafficType: 'customer'
  },
  scheduler: {
    featuresRefreshRate: 30,
    segmentsRefreshRate: 60
  }
});

// Feature flag evaluation
const treatment = splitClient.getTreatment('enhanced_mobile_dashboard');
if (treatment === 'enhanced') {
  // Enable enhanced dashboard features
  enableAnalytics();
  showAdvancedCharts();
}
```

### Segment Targeting
```javascript
// With customer attributes
const treatment = splitClient.getTreatment('robo_advisor', {
  tier: 'wealth',
  region: 'us',
  kyc_status: 'verified'
});
```

## Security Considerations

### Production Security
- Feature flags default to `off` for safety
- Conservative rollout percentages (≤10%)
- Automated rollback on health degradation
- Segment-based targeting for sensitive features
- Comprehensive audit logging

### Compliance Features
- GDPR tools for EU customers (100% coverage)
- Enhanced KYC for regulatory compliance
- Audit trails for all feature flag evaluations
- Data retention policies aligned with banking regulations

## Troubleshooting

### Common Issues

1. **Missing Administration Infrastructure**
   ```
   Error: workspace_id is required
   ```
   **Solution**: Deploy banking-platform-administration first

2. **Invalid Environment Integration**
   ```
   Error: environment_id not found
   ```
   **Solution**: Verify administration outputs and environment matching

3. **Feature Flag Evaluation Errors**
   ```
   Error: High evaluation error rate
   ```
   **Solution**: Check SDK configuration and network connectivity

## Files Structure

```
banking-platform-feature-flags/
├── main.tf                          # Main feature flag definitions
├── variables.tf                     # Input variables
├── outputs.tf                       # Feature flag outputs
├── provider.tf                      # Provider configuration
├── versions.tf                      # Version constraints
├── terraform.tfvars.example         # Example configuration
├── environments/
│   ├── development.tfvars           # Development feature config
│   ├── staging.tfvars               # Staging feature config
│   └── production.tfvars            # Production feature config
└── README.md                        # This file
```

## Next Steps

After feature flag deployment:

1. **Verify Feature Flags**: Test all feature flag evaluations
2. **Application Integration**: Integrate SDK with banking applications
3. **Monitor Performance**: Set up monitoring and alerting
4. **Gradual Rollouts**: Implement gradual rollout strategies
5. **Security Testing**: Conduct security testing of new features
6. **Compliance Validation**: Verify compliance with banking regulations