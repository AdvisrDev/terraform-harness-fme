# Banking Platform - Feature Flags Implementation

## 🚀 Quick Overview | Resumen Rápido

### English
A comprehensive implementation of feature flags for a banking platform, showcasing real-world scenarios including transaction validation, promotional offers, fraud detection, and operational controls with progressive environment deployment and safety controls.

### Español
Una implementación completa de feature flag para una plataforma bancaria, mostrando escenarios del mundo real incluyendo validación de transacciones, ofertas promocionales, detección de fraude y controles operacionales con despliegue progresivo de entornos y controles de seguridad.

## 🎯 Feature Flags Included | Feature Flags Incluidos

| Feature Flag | Purpose | Propósito | Environments | Entornos |
|-------------|---------|-----------|--------------|----------|
| `bankvalidation` | Transaction validation | Validación de transacciones | dev, staging, prod | dev, staging, prod |
| `harnessoffer` | Promotional offers | Ofertas promocionales | dev, staging, prod | dev, staging, prod |
| `advanced-fraud-detection` | AI fraud detection | Detección de fraude IA | dev, staging | dev, staging |
| `voice-banking-beta` | Voice banking commands | Comandos banca por voz | dev | dev |
| `payment-gateway-fallback` | Payment fallback control | Control fallback de pagos | dev, staging, prod | dev, staging, prod |

## 🔧 Quick Start | Inicio Rápido

### Prerequisites | Prerequisitos
- Terraform >= 1.5
- Split API key 

### Deploy | Desplegar

```bash
# Navigate to banking platform | Navegar a plataforma bancaria
cd use-cases/banking-platform

# Initialize Terraform | Inicializar Terraform
terraform init

# Deploy to development | Desplegar a desarrollo
terraform apply -var-file="environments/dev.tfvars" -var="split_api_key=your-key"

# Deploy to staging | Desplegar a staging
terraform apply -var-file="environments/staging.tfvars" -var="split_api_key=your-key"

# Deploy to production | Desplegar a producción
terraform apply -var-file="environments/prod.tfvars" -var="split_api_key=your-key"
```

## 🛡️ Environment Safety | Seguridad de Entornos

The system automatically filters feature flags based on environment to prevent accidental production deployments of experimental features.

El sistema filtra automáticamente los feature flags basado en el entorno para prevenir despliegues accidentales en producción de características experimentales.

| Feature | Dev | Staging | Prod | Reason | Razón |
|---------|-----|---------|------|--------|--------|
| Voice Banking | ✅ | ❌ | ❌ | Experimental | Experimental |
| Fraud Detection | ✅ | ✅ | ❌ | Testing phase | Fase de pruebas |
| Bank Validation | ✅ | ✅ | ✅ | Production ready | Listo para producción |
