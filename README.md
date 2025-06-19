# Harness Feature Management and Experimentation Terraform Modules

A comprehensive, production-ready Terraform module collection for managing Harness Feature Management and Experimentation infrastructure and feature flags across multiple environments with advanced lifecycle management, safety controls, and environment-specific configurations.

## 🏗️ Module Architecture

This project provides a root module that coordinates two specialized Terraform modules for comprehensive Harness Feature Management and Experimentation management:

### Root Module
The main module at the project root acts as a coordinator, consuming the local modules from the `modules/` folder based on configuration:

```hcl
# Root main.tf
module "split_administration" {
  source = "./modules/split-administration"
  count  = length(var.feature_flags) == 0 ? 1 : 0
  # Administration-only mode when no feature flags defined
}

module "feature_flags" {
  source = "./modules/split-feature-flags"  
  count  = length(var.feature_flags) > 0 ? 1 : 0
  # Feature flags mode when feature flags are defined
}
```

### Child Modules

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
module "split_administration" {
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
- **Harness Feature Management and Experimentation Provider** >= 3.0
- **Harness Feature Management and Experimentation Account** with API access

## 📄 License

This project is licensed under the MIT License.

---

# Módulos de Terraform para Harness Feature Management and Experimentation

Una colección completa de módulos de Terraform listos para producción para administrar infraestructura de Harness Feature Management and Experimentation y feature flags en múltiples entornos con gestión avanzada del ciclo de vida, controles de seguridad y configuraciones específicas por entorno.

## 🏗️ Arquitectura de Módulos

Este proyecto proporciona dos módulos principales de Terraform para la gestión completa de Harness Feature Management and Experimentation:

| Módulo | Propósito | Características Clave |
|--------|-----------|----------------------|
| **`split-administration`** | Configuración de infraestructura | Workspace, entornos, tipos de tráfico, segmentos, API keys con filtrado por entorno |
| **`split-feature-flags`** | Gestión de feature flags | Feature flags con configuraciones específicas por entorno y control de rollout |

### Beneficios de la Arquitectura
- **Filtrado por Entorno**: Recursos solo desplegados en entornos especificados
- **Fusión de Configuraciones**: Configuraciones base con overrides específicos por entorno
- **Separación Limpia**: Infraestructura y feature flags separados por responsabilidades
- **Diseño Escalable**: Soporta múltiples entornos y configuraciones complejas

## 🚀 Inicio Rápido

### 1. Configuración de Infraestructura
```hcl
module "split_administration" {
  source = "./modules/split-administration"
  
  environment_name = "dev"
  workspace = { name = "MiWorkspace", create_workspace = true }
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

### 2. Despliegue de Feature Flags
```hcl
module "feature_flags" {
  source = "./modules/split-feature-flags"
  
  workspace_name = "MiWorkspace"
  environment_name = "dev"
  traffic_type_name = "user"
  
  feature_flags = [
    {
      name = "nueva-caracteristica"
      environments = ["dev", "staging", "prod"]
      environment_configs = {
        dev = { default_treatment = "on", rules = [{ treatment = "on", size = 100 }] }
        prod = { rules = [{ treatment = "on", size = 10 }] }
      }
    }
  ]
}
```

## ✨ Características Principales

### Seguridad de Entornos
- **Filtrado Automático**: Feature flags solo desplegados en entornos especificados
- **Configuraciones Específicas por Entorno**: Diferentes comportamientos por entorno con fuente única de verdad
- **Defaults Seguros**: Configuraciones conservadoras para entornos de producción

### Flexibilidad de Configuración
- **Igual en Todas Partes**: Desplegar configuraciones idénticas en todos los entornos
- **Específico por Entorno**: Diferentes treatments, reglas y configuraciones por entorno
- **Solo por Entorno**: Características que existen solo en entornos específicos (ej. herramientas debug)

### Listo para Producción
- **Validación**: Validación completa de entradas con mensajes de error claros
- **Mejores Prácticas**: Patrones de seguridad y operacionales integrados
- **Escalable**: Soporta despliegues a escala empresarial

## 📚 Documentación

### Documentación en Español

| Categoría | Descripción | Ruta |
|-----------|-------------|------|
| **🔧 Técnica** | Arquitectura del módulo y conceptos avanzados | [`documentation/es/technical/`](documentation/es/technical/) |
| **👥 Guías de Usuario** | Guías de implementación y tutoriales | [`documentation/es/user/`](documentation/es/user/) |

**Comience Aquí:**
- [Guía de Primeros Pasos](documentation/es/user/1.primeros-pasos.md) - Guía completa de configuración y uso
- [Arquitectura Técnica](documentation/es/technical/1.arquitectura.md) - Análisis profundo del diseño del módulo

## 💼 Casos de Uso

### Ejemplo de Plataforma Bancaria
Implementación completa para una plataforma bancaria que demuestra:

- **Administración**: [`use-cases/banking-platform-administration/`](use-cases/banking-platform-administration/)
  - Configuración de infraestructura con API keys específicos por entorno
  - Gestión de segmentos con filtrado por entorno
  - Configuraciones de seguridad listas para producción

- **Feature Flags**: [`use-cases/banking-platform-feature-flags/`](use-cases/banking-platform-feature-flags/)
  - Feature flags con estrategias de rollout específicas por entorno
  - Patrones de configuración desarrollo vs. producción
  - Prácticas de despliegue seguro

## 🛡️ Estrategias por Entorno

### Desarrollo
- **Rollout**: 100% para pruebas
- **Configuración**: Características de debug habilitadas
- **Seguridad**: Características experimentales solo para desarrollo

### Staging
- **Rollout**: 50% máximo para validación
- **Configuración**: Tipo producción con monitoreo
- **Seguridad**: Porcentajes de rollout conservadores

### Producción
- **Rollout**: 10% máximo para nuevas características
- **Configuración**: Optimizado para rendimiento y seguridad
- **Seguridad**: Capacidades de rollback automático

## 📊 Patrones de Configuración

### Estructura de Archivos
```
├── common.tfvars           # Configuraciones compartidas
├── environments/
│   ├── development.tfvars  # Elementos específicos dev
│   ├── staging.tfvars      # Elementos específicos staging
│   └── production.tfvars   # Elementos específicos prod
```

### Comandos de Despliegue
```bash
# Despliegue desarrollo
terraform apply \
  -var-file="common.tfvars" \
  -var-file="environments/development.tfvars"

# Despliegue producción
terraform apply \
  -var-file="common.tfvars" \
  -var-file="environments/production.tfvars"
```

## 🔧 Requisitos

- **Terraform** >= 1.5
- **Harness Feature Management and Experimentation Provider** >= 3.0
- **Cuenta Harness Feature Management and Experimentation** con acceso API

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT.