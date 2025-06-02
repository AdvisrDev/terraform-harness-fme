# Feature Flag Lifecycle Management Example

This example demonstrates how to manage feature flags through their lifecycle stages and control which environments they appear in.

## Lifecycle Stages

| Stage | Description | Typical Environments |
|-------|-------------|---------------------|
| `development` | Early development, experimental | dev only |
| `testing` | Ready for QA testing | dev, staging |
| `staging` | Pre-production validation | dev, staging |
| `production` | Stable, production-ready | dev, staging, prod |
| `deprecated` | Being phased out | varies |

## Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| `feature` | New product features | UI changes, new functionality |
| `experiment` | A/B tests, experiments | UI variants, algorithm tests |
| `operational` | System behavior control | Timeouts, batch sizes |
| `permission` | Access control | Feature access by user type |
| `killswitch` | Emergency controls | Circuit breakers, fallbacks |

## Usage

### Deploy to Development
```bash
terraform apply \
  -var="environment_name=dev" \
  -var="is_production=false" \
  -var="split_api_key=your-key"
```

### Deploy to Staging
```bash
terraform apply \
  -var="environment_name=staging" \
  -var="is_production=false" \
  -var="split_api_key=your-key"
```

### Deploy to Production
```bash
terraform apply \
  -var="environment_name=prod" \
  -var="is_production=true" \
  -var="split_api_key=your-key"
```

## Feature Flag Promotion Workflow

1. **Development Phase**
   - Create feature flag with `environments = ["dev"]`
   - Set `lifecycle_stage = "development"`
   - Test thoroughly in dev environment

2. **Testing Phase**
   - Update `environments = ["dev", "staging"]`
   - Change `lifecycle_stage = "testing"`
   - Deploy to staging for QA validation

3. **Pre-Production Phase**
   - Keep `environments = ["dev", "staging"]`
   - Update `lifecycle_stage = "staging"`
   - Final validation before production

4. **Production Phase**
   - Update `environments = ["dev", "staging", "prod"]`
   - Change `lifecycle_stage = "production"`
   - Deploy to production with monitoring

5. **Deprecation Phase**
   - Set `lifecycle_stage = "deprecated"`
   - Plan removal timeline

## Environment Filtering

The module automatically filters feature flags based on the current environment:

- **Development**: Gets all flags marked for `dev` environment
- **Staging**: Gets flags marked for `staging` environment  
- **Production**: Gets only flags marked for `prod` environment

This prevents accidental deployment of experimental features to production.

## Outputs

The example provides detailed outputs showing:
- Which feature flags are active in the current environment
- Summary by lifecycle stage and category
- Total counts for visibility

Use `terraform output` to see the current state:

```bash
terraform output feature_flags_summary
terraform output filtered_feature_flags
```