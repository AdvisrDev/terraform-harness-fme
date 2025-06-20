# Split.io Feature Flags Module

This Terraform module manages Split.io feature flags with environment-specific configurations, supporting flexible deployment patterns across multiple environments.

## Purpose

This module enables you to define and manage feature flags within your Split.io workspace, applying environment-specific configurations and rollout strategies.

## Features

- **Environment Filtering**: Only deploy feature flags to specified environments
- **Configuration Merging**: Base configurations with environment-specific overrides
- **Flexible Configuration**: Same treatments across environments OR different per environment
- **Type-Safe Variables**: Comprehensive validation with detailed error messages
- **Production Ready**: Security best practices and operational controls

## Inputs

- `workspace_name`: (`string`) The name of the Split.io workspace to manage feature flags in.
- `environment_name`: (`string`) The name of the target environment (e.g., "dev", "prod").
- `traffic_type_name`: (`string`) The name of the traffic type associated with the feature flags.
- `feature_flags`: (`list(object)`) List of feature flag configurations.
  - `name`: (`string`) Name of the feature flag.
  - `description`: (`string`) Description of the feature flag.
  - `default_treatment`: (`string`) The default treatment for the feature flag.
  - `environments`: (`list(string)`) Environments where the feature flag is deployed.
  - `lifecycle_stage`: (`string`) Lifecycle stage of the feature flag.
  - `category`: (`string`) Category of the feature flag.
  - `treatments`: (`list(object)`) List of treatments for the feature flag.
    - `name`: (`string`) Name of the treatment.
    - `configurations`: (`string`) JSON string of configurations for the treatment.
    - `description`: (`string`) Description of the treatment.
  - `rules`: (`list(object)`) List of rules for the feature flag.
    - `treatment`: (`string`) The treatment to apply.
    - `size`: (`number`) Rollout percentage (between 0 and 100).
    - `condition`: (`object`) Condition for the rule, including `matcher` (`type`, `attribute`, `strings`).
  - `environment_configs`: (`map(object)`) Environment-specific overrides for the feature flag.
    - `default_treatment`: (`string`) Environment-specific default treatment.
    - `description`: (`string`) Environment-specific description.
    - `treatments`: (`list(object)`) Environment-specific treatments.
    - `rules`: (`list(object)`) Environment-specific rules.

## Outputs

When this module is active (through the root module), it provides the following outputs:

- `feature_flags_list`: A list of created feature flags with their details.
- `deployment_summary`: A summary of the complete deployment, including counts of total, environment, and merged flags.

## Usage

```hcl
module "feature_flags" {
  source = "./modules/split-feature-flags"

  workspace_name    = "my-workspace"
  environment_name  = "dev"
  traffic_type_name = "user"

  feature_flags = [
    {
      name              = "new-feature"
      description       = "New awesome feature"
      default_treatment = "off"
      environments      = ["dev", "staging", "prod"]
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
          configurations = "{\"enabled\": true}"
          description    = "Feature enabled"
        }
      ]
      
      rules = []
      
      # Environment-specific configurations
      environment_configs = {
        dev = {
          default_treatment = "on"
          rules = [{ treatment = "on", size = 100 }]
        }
        prod = {
          rules = [{ treatment = "on", size = 10 }]
        }
      }
    }
  ]
}
````

-----

# Módulo de Banderas de Características de Split.io

Este módulo de Terraform gestiona las banderas de características de Split.io con configuraciones específicas por entorno, soportando patrones de despliegue flexibles en múltiples entornos.

## Propósito

Este módulo le permite definir y gestionar banderas de características dentro de su workspace de Split.io, aplicando configuraciones específicas de entorno y estrategias de lanzamiento.

## Características

  - **Filtrado por Entorno**: Solo despliega banderas de características a los entornos especificados
  - **Fusión de Configuraciones**: Configuraciones base con anulaciones específicas por entorno
  - **Configuración Flexible**: Mismos tratamientos en todos los entornos O diferentes por entorno
  - **Variables con Tipado Seguro**: Validación exhaustiva con mensajes de error detallados
  - **Listo para Producción**: Mejores prácticas de seguridad y controles operativos

## Entradas

  - `workspace_name`: (`string`) El nombre del workspace de Split.io para gestionar las banderas de características.
  - `environment_name`: (`string`) El nombre del entorno de destino (por ejemplo, "dev", "prod").
  - `traffic_type_name`: (`string`) El nombre del tipo de tráfico asociado a las banderas de características.
  - `feature_flags`: (`list(object)`) Lista de configuraciones de banderas de características.
      - `name`: (`string`) Nombre de la bandera de características.
      - `description`: (`string`) Descripción de la bandera de características.
      - `default_treatment`: (`string`) El tratamiento por defecto para la bandera de características.
      - `environments`: (`list(string)`) Entornos donde se despliega la bandera de características.
      - `lifecycle_stage`: (`string`) Etapa del ciclo de vida de la bandera de características.
      - `category`: (`string`) Categoría de la bandera de características.
      - `treatments`: (`list(object)`) Lista de tratamientos para la bandera de características.
          - `name`: (`string`) Nombre del tratamiento.
          - `configurations`: (`string`) Cadena JSON de configuraciones para el tratamiento.
          - `description`: (`string`) Descripción del tratamiento.
      - `rules`: (`list(object)`) Lista de reglas para la bandera de características.
          - `treatment`: (`string`) El tratamiento a aplicar.
          - `size`: (`number`) Porcentaje de lanzamiento (entre 0 y 100).
          - `condition`: (`object`) Condición para la regla, incluyendo `matcher` (`type`, `attribute`, `strings`).
      - `environment_configs`: (`map(object)`) Anulaciones específicas del entorno para la bandera de características.
          - `default_treatment`: (`string`) Tratamiento por defecto específico del entorno.
          - `description`: (`string`) Descripción específica del entorno.
          - `treatments`: (`list(object)`) Tratamientos específicos del entorno.
          - `rules`: (`list(object)`) Reglas específicas del entorno.

## Salidas

Cuando este módulo está activo (a través del módulo raíz), proporciona las siguientes salidas:

  - `feature_flags_list`: Una lista de las banderas de características creadas con sus detalles.
  - `deployment_summary`: Un resumen del despliegue completo, incluyendo el recuento total de banderas, las banderas de entorno y las banderas fusionadas.

## Uso

```hcl
module "feature_flags" {
  source = "./modules/split-feature-flags"

  workspace_name    = "my-workspace"
  environment_name  = "dev"
  traffic_type_name = "user"

  feature_flags = [
    {
      name              = "new-feature"
      description       = "New awesome feature"
      default_treatment = "off"
      environments      = ["dev", "staging", "prod"]
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
          configurations = "{\"enabled\": true}"
          description    = "Feature enabled"
        }
      ]
      
      rules = []
      
      # Environment-specific configurations
      environment_configs = {
        dev = {
          default_treatment = "on"
          rules = [{ treatment = "on", size = 100 }]
        }
        prod = {
          rules = [{ treatment = "on", size = 10 }]
        }
      }
    }
  ]
}
```