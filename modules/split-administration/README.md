# Split.io Administration Module

This Terraform module manages Split.io administrative infrastructure, including workspaces, environments, traffic types, segments, and API keys with environment-specific configurations.

## Purpose

This module serves as the foundational layer for managing your Split.io infrastructure, allowing you to define and configure workspaces, environments, traffic types, segments, and API keys.

## Features

- **Environment Filtering**: API keys and segment keys filtered by environment
- **Configuration Merging**: Base configurations with environment-specific overrides
- **Centralized Management**: Single source for all Split.io infrastructure
- **Scalable Architecture**: Supports multiple environments and configuration patterns

## Inputs

- `environment_name`: (`string`) The name of the current environment (e.g., "dev", "prod").
- `workspace`: (`object`) Configuration for the Split.io workspace.
  - `name`: (`string`) Name of the workspace.
  - `create_workspace`: (`bool`) Whether to create the workspace.
- `environments`: (`map(object)`) Definitions of environments.
  - `name`: (`string`) Name of the environment.
  - `production`: (`bool`) Whether the environment is a production environment.
- `traffic_types`: (`map(object)`) Definitions of traffic types.
  - `name`: (`string`) Name of the traffic type.
  - `display_name`: (`string`) Display name for the traffic type.
- `traffic_type_attributes`: (`map(object)`) Atributos para los tipos de tráfico (por ejemplo, tipos de datos, valores sugeridos).
- `segments`: (`map(object)`) Definitions of segments.
  - `traffic_type_key`: (`string`) The traffic type associated with the segment.
  - `name`: (`string`) Name of the segment.
  - `description`: (`string`) Description of the segment.
- `api_keys`: (`list(object)`) List of API key configurations.
  - `name`: (`string`) Name of the API key.
  - `type`: (`string`) Type of the API key (e.g., "server_side", "admin").
  - `roles`: (`list(string)`) List of roles assigned to the API key.
  - `environments`: (`list(string)`) Environments where the API key is deployed.
  - `environment_configs`: (`map(object)`) Environment-specific overrides for the API key, including `name`, `type`, and `roles`.
- `environment_segment_keys`: (`list(object)`) List of environment segment key configurations.
  - `name`: (`string`) Name of the segment key.
  - `segment_name`: (`string`) The name of the segment.
  - `keys`: (`list(string)`) List of keys for the segment.
  - `environments`: (`list(string)`) Environments where the segment keys are deployed.
  - `environment_configs`: (`map(object)`) Environment-specific overrides for the segment keys, including `keys`.

## Outputs

When this module is active (through the root module), it provides the following outputs:

- `workspace_id`: The ID of the created workspace.
- `workspace_name`: The name of the workspace.
- `workspace_created`: Boolean indicating if the workspace was created.
- `environment_ids`: A map of environment names to their IDs.
- `traffic_type_ids`: A map of traffic type names to their IDs.
- `segment_ids`: A map of segment names to their IDs.
- `api_keys`: The created API keys (sensitive).
- `api_key_ids`: A map of API key names to their IDs (sensitive).

## Usage

```hcl
module "split_administration" {
  source = "./modules/split-administration"

  environment_name = "dev"
  
  workspace = {
    name             = "my-workspace"
    create_workspace = true
  }

  environments = {
    dev = {
      name       = "development"
      production = false
    }
    prod = {
      name       = "production"
      production = true
    }
  }

  traffic_types = {
    user = {
      name         = "user"
      display_name = "User"
    }
  }

  segments = {
    premium_users = {
      traffic_type_key = "user"
      name             = "premium_users"
      description      = "Users with premium subscription"
    }
  }

  api_keys = [
    {
      name         = "server"
      type         = "server_side"
      roles        = ["API_FEATURE_FLAG_VIEWER"]
      environments = ["dev", "prod"]
      environment_configs = {
        dev = { name = "dev-server" }
        prod = { name = "prod-server" }
      }
    }
  ]

  environment_segment_keys = [
    {
      name         = "premium_test_keys"
      segment_name = "premium_users"
      keys         = ["user1", "user2"]
      environments = ["dev"]
    }
  ]
}
````

-----

# Módulo de Administración de Split.io

Este módulo de Terraform gestiona la infraestructura administrativa de Split.io, incluyendo workspaces, entornos, tipos de tráfico, segmentos y claves API con configuraciones específicas por entorno.

## Propósito

Este módulo sirve como la capa fundamental para gestionar su infraestructura de Split.io, permitiéndole definir y configurar workspaces, entornos, tipos de tráfico, segmentos y claves API.

## Características

  - **Filtrado por Entorno**: Las claves API y las claves de segmento se filtran por entorno
  - **Fusión de Configuraciones**: Configuraciones base con anulaciones específicas por entorno
  - **Gestión Centralizada**: Fuente única para toda la infraestructura de Split.io
  - **Arquitectura Escalable**: Soporta múltiples entornos y patrones de configuración

## Entradas

  - `environment_name`: (`string`) El nombre del entorno actual (por ejemplo, "dev", "prod").
  - `workspace`: (`object`) Configuración para el workspace de Split.io.
      - `name`: (`string`) Nombre del workspace.
      - `create_workspace`: (`bool`) Si se debe crear el workspace.
  - `environments`: (`map(object)`) Definiciones de entornos.
      - `name`: (`string`) Nombre del entorno.
      - `production`: (`bool`) Si el entorno es un entorno de producción.
  - `traffic_types`: (`map(object)`) Definiciones de tipos de tráfico.
      - `name`: (`string`) Nombre del tipo de tráfico.
      - `display_name`: (`string`) Nombre de visualización para el tipo de tráfico.
  - `traffic_type_attributes`: (`map(object)`) Atributos para los tipos de tráfico (por ejemplo, tipos de datos, valores sugeridos).
  - `segments`: (`map(object)`) Definiciones de segmentos.
      - `traffic_type_key`: (`string`) El tipo de tráfico asociado con el segmento.
      - `name`: (`string`) Nombre del segmento.
      - `description`: (`string`) Descripción del segmento.
  - `api_keys`: (`list(object)`) Lista de configuraciones de claves API.
      - `name`: (`string`) Nombre de la clave API.
      - `type`: (`string`) Tipo de la clave API (por ejemplo, "server\_side", "admin").
      - `roles`: (`list(string)`) Lista de roles asignados a la clave API.
      - `environments`: (`list(string)`) Entornos donde se implementa la clave API.
      - `environment_configs`: (`map(object)`) Anulaciones específicas del entorno para la clave API, incluyendo `name`, `type` y `roles`.
  - `environment_segment_keys`: (`list(object)`) Lista de configuraciones de claves de segmento de entorno.
      - `name`: (`string`) Nombre de la clave de segmento.
      - `segment_name`: (`string`) El nombre del segmento.
      - `keys`: (`list(string)`) Lista de claves para el segmento.
      - `environments`: (`list(string)`) Entornos donde se implementan las claves de segmento.
      - `environment_configs`: (`map(object)`) Anulaciones específicas del entorno para las claves de segmento, incluyendo `keys`.

## Salidas

Cuando este módulo está activo (a través del módulo raíz), proporciona las siguientes salidas:

  - `workspace_id`: El ID del workspace creado.
  - `workspace_name`: El nombre del workspace.
  - `workspace_created`: Booleano que indica si se creó el workspace.
  - `environment_ids`: Un mapa de nombres de entorno a sus ID.
  - `traffic_type_ids`: Un mapa de nombres de tipo de tráfico a sus ID.
  - `segment_ids`: Un mapa de nombres de segmento a sus ID.
  - `api_keys`: Las claves API creadas (sensible).
  - `api_key_ids`: Un mapa de nombres de claves API a sus ID (sensible).

## Uso

```hcl
module "split_administration" {
  source = "./modules/split-administration"

  environment_name = "dev"
  
  workspace = {
    name             = "my-workspace"
    create_workspace = true
  }

  environments = {
    dev = {
      name       = "development"
      production = false
    }
    prod = {
      name       = "production"
      production = true
    }
  }

  traffic_types = {
    user = {
      name         = "user"
      display_name = "User"
    }
  }

  segments = {
    premium_users = {
      traffic_type_key = "user"
      name             = "premium_users"
      description      = "Users with premium subscription"
    }
  }

  api_keys = [
    {
      name         = "server"
      type         = "server_side"
      roles        = ["API_FEATURE_FLAG_VIEWER"]
      environments = ["dev", "prod"]
      environment_configs = {
        dev = { name = "dev-server" }
        prod = { name = "prod-server" }
      }
    }
  ]

  environment_segment_keys = [
    {
      name         = "premium_test_keys"
      segment_name = "premium_users"
      keys         = ["user1", "user2"]
      environments = ["dev"]
    }
  ]
}
```