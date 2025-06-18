# Split.io Terraform Modules

A comprehensive, production-ready Terraform module collection for managing Split.io infrastructure and feature flags across multiple environments with advanced lifecycle management, safety controls, and environment-specific configurations.

---

*Colección completa de módulos de Terraform listos para producción para administrar infraestructura de Split.io y feature flags en múltiples entornos con gestión avanzada del ciclo de vida, controles de seguridad y configuraciones específicas por entorno.*

## 🏗️ Module Architecture

This project provides two main Terraform modules for comprehensive Split.io management:

| Module | Purpose | Key Features |
|--------|---------|--------------|
| **`split-administration`** | Infrastructure setup | Workspace, environments, traffic types, segments, API keys with environment filtering |
| **`split-feature-flags`** | Feature flag management | Feature flags with environment-specific configurations and rollout control |

### Architecture Benefits
- **Environment Filtering**: Resources only deployed to specified environments
- **Configuration Merging**: Base configurations with environment-specific overrides
- **Clean Separation**: Infrastructure and feature flag concerns separated
- **Scalable Design**: Supports multiple environments and complex configurations

## 🚀 Quick Start

### 1. Infrastructure Setup
```hcl
module "administration" {
  source = "./modules/split-administration"
  
  environment_name = "dev"
  workspace = { name = "MyWorkspace", create_workspace = true }
  environments = {
    dev = { name = "dev", production = false }
    prod = { name = "prod", production = true }
  }
  api_keys = [
    {
      name = "server"
      environments = ["dev", "prod"]
      environment_configs = {
        dev = { name = "dev-server" }
        prod = { name = "prod-server" }
      }
    }
  ]
}
```

### 2. Feature Flag Deployment
```hcl
module "feature_flags" {
  source = "./modules/split-feature-flags"
  
  workspace_name = "MyWorkspace"
  environment_name = "dev"
  traffic_type_name = "user"
  
  feature_flags = [
    {
      name = "new-feature"
      environments = ["dev", "staging", "prod"]
      environment_configs = {
        dev = { default_treatment = "on", rules = [{ treatment = "on", size = 100 }] }
        prod = { rules = [{ treatment = "on", size = 10 }] }
      }
    }
  ]
}
```

## ✨ Key Features

### Environment Safety
- **Automatic Filtering**: Feature flags only deployed to specified environments
- **Environment-Specific Configs**: Different behaviors per environment with single source of truth
- **Safe Defaults**: Conservative configurations for production environments

### Configuration Flexibility
- **Same Everywhere**: Deploy identical configurations across environments
- **Environment-Specific**: Different treatments, rules, and settings per environment
- **Environment-Only**: Features that exist only in specific environments (e.g., debug tools)

### Production Ready
- **Validation**: Comprehensive input validation with clear error messages
- **Best Practices**: Built-in security and operational patterns
- **Scalable**: Supports enterprise-scale deployments

## 📚 Documentation

### English Documentation

| Category | Description | Path |
|----------|-------------|------|
| **🔧 Technical** | Module architecture and advanced concepts | [`documentation/en/technical/`](documentation/en/technical/) |
| **👥 User Guide** | Implementation guides and tutorials | [`documentation/en/user/`](documentation/en/user/) |

**Start Here:**
- [Getting Started Guide](documentation/en/user/1.getting-started.md) - Complete setup and usage guide
- [Technical Architecture](documentation/en/technical/1.architecture.md) - Deep dive into module design

### Documentación en Español

| Categoría | Descripción | Ruta |
|-----------|-------------|------|
| **🔧 Técnica** | Arquitectura del módulo y conceptos avanzados | [`documentation/es/technical/`](documentation/es/technical/) |
| **👥 Guías de Usuario** | Guías de implementación y tutoriales | [`documentation/es/user/`](documentation/es/user/) |

**Comience Aquí:**
- [Guía de Primeros Pasos](documentation/es/user/1.primeros-pasos.md) - Guía completa de configuración y uso
- [Arquitectura Técnica](documentation/es/technical/1.arquitectura.md) - Análisis profundo del diseño del módulo

## 💼 Use Cases

### Banking Platform Example
Complete implementation for a banking platform demonstrating:

- **Administration**: [`use-cases/banking-platform-administration/`](use-cases/banking-platform-administration/)
  - Infrastructure setup with environment-specific API keys
  - Segment management with environment filtering
  - Production-ready security configurations

- **Feature Flags**: [`use-cases/banking-platform-feature-flags/`](use-cases/banking-platform-feature-flags/)
  - Feature flags with environment-specific rollout strategies
  - Development vs. production configuration patterns
  - Safe deployment practices

## 🛡️ Environment Strategies

### Development
- **Rollout**: 100% for testing
- **Configuration**: Debug features enabled
- **Safety**: Development-only experimental features

### Staging
- **Rollout**: 50% maximum for validation
- **Configuration**: Production-like with monitoring
- **Safety**: Conservative rollout percentages

### Production
- **Rollout**: 10% maximum for new features
- **Configuration**: Optimized for performance and security
- **Safety**: Automatic rollback capabilities

## 📊 Configuration Patterns

### File Structure
```
├── common.tfvars           # Shared configurations
├── environments/
│   ├── development.tfvars  # Dev-specific items
│   ├── staging.tfvars      # Staging-specific items
│   └── production.tfvars   # Prod-specific items
```

### Deployment Commands
```bash
# Development deployment
terraform apply \
  -var-file="common.tfvars" \
  -var-file="environments/development.tfvars"

# Production deployment  
terraform apply \
  -var-file="common.tfvars" \
  -var-file="environments/production.tfvars"
```

## 🔧 Requirements

- **Terraform** >= 1.5
- **Split.io Provider** >= 3.0
- **Split.io Account** with API access

## 📄 License

This project is licensed under the MIT License.  
Este proyecto está licenciado bajo la Licencia MIT.