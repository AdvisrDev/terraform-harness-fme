# Architecture Diagrams | Diagramas de Arquitectura

## Overall System Architecture | Arquitectura General del Sistema

```mermaid
graph TB
    subgraph "Developer | Desarrollador"
        DEV_USER[Developer<br/>Desarrollador]
        TERRAFORM[Terraform CLI]
    end
    
    subgraph "Infrastructure | Infraestructura"
        MODULE[Split Feature Flags Module<br/>Módulo Split Feature Flags]
        TFVARS[Configuration Files<br/>Archivos de Configuración]
        STATE[Terraform State<br/>Estado de Terraform]
    end
    
    subgraph "Split.io Platform | Plataforma Split.io"
        WORKSPACE[Workspace<br/>Espacio de Trabajo]
        ENVIRONMENTS[Environments<br/>Entornos]
        FEATURE_FLAGS[Feature Flags<br/>Feature Flags]
        SEGMENTS[Segments<br/>Segmentos]
    end
    
    subgraph "Applications | Aplicaciones"
        BANK_APP[Banking App<br/>App Bancaria]
        MOBILE_APP[Mobile App<br/>App Móvil]
        WEB_APP[Web App<br/>App Web]
    end
    
    DEV_USER --> TERRAFORM
    TERRAFORM --> MODULE
    MODULE --> TFVARS
    TERRAFORM --> STATE
    
    MODULE --> WORKSPACE
    WORKSPACE --> ENVIRONMENTS
    ENVIRONMENTS --> FEATURE_FLAGS
    ENVIRONMENTS --> SEGMENTS
    
    FEATURE_FLAGS --> BANK_APP
    FEATURE_FLAGS --> MOBILE_APP
    FEATURE_FLAGS --> WEB_APP
    
    classDef userClass fill:#e1f5fe
    classDef infraClass fill:#f3e5f5
    classDef splitClass fill:#e8f5e8
    classDef appClass fill:#fff3e0
    
    class DEV_USER,TERRAFORM userClass
    class MODULE,TFVARS,STATE infraClass
    class WORKSPACE,ENVIRONMENTS,FEATURE_FLAGS,SEGMENTS splitClass
    class BANK_APP,MOBILE_APP,WEB_APP appClass
```

## Module Architecture | Arquitectura del Módulo

```mermaid
graph TB
    subgraph "Core Module | Módulo Principal"
        MAIN[main.tf<br/>Resources]
        VARS[variables.tf<br/>Input Variables]
        OUTPUTS[outputs.tf<br/>Output Values]
        VERSIONS[versions.tf<br/>Provider Requirements]
    end
    
    subgraph "Use Cases | Casos de Uso"
        BANKING[Banking Platform<br/>Plataforma Bancaria]
        ECOMMERCE[E-commerce<br/>Comercio Electrónico]
        HEALTHCARE[Healthcare<br/>Salud]
    end
    
    subgraph "Environments | Entornos"
        DEV[Development<br/>Desarrollo]
        STAGING[Staging<br/>Preparación]
        PROD[Production<br/>Producción]
    end
    
    BANKING --> MAIN
    ECOMMERCE --> MAIN
    HEALTHCARE --> MAIN
    
    VARS --> MAIN
    MAIN --> OUTPUTS
    VERSIONS --> MAIN
    
    MAIN --> DEV
    MAIN --> STAGING
    MAIN --> PROD
    
    classDef moduleClass fill:#e3f2fd
    classDef useCaseClass fill:#f1f8e9
    classDef envClass fill:#fce4ec
    
    class MAIN,VARS,OUTPUTS,VERSIONS moduleClass
    class BANKING,ECOMMERCE,HEALTHCARE useCaseClass
    class DEV,STAGING,PROD envClass
```

## Feature Flag Lifecycle Flow | Flujo del Ciclo de Vida de Feature Flags

```mermaid
graph TB
    subgraph "Development Phase | Fase de Desarrollo"
        CREATE[Create Feature Flag<br/>Crear Feature Flag]
        DEV_TEST[Test in Development<br/>Probar en Desarrollo]
        DEV_VALIDATE[Validate Functionality<br/>Validar Funcionalidad]
    end
    
    subgraph "Testing Phase | Fase de Pruebas"
        PROMOTE_STAGING[Promote to Staging<br/>Promover a Staging]
        QA_TEST[QA Testing<br/>Pruebas QA]
        PERFORMANCE[Performance Testing<br/>Pruebas de Rendimiento]
    end
    
    subgraph "Production Phase | Fase de Producción"
        PROMOTE_PROD[Promote to Production<br/>Promover a Producción]
        GRADUAL_ROLLOUT[Gradual Rollout<br/>Despliegue Gradual]
        MONITOR[Monitor & Analyze<br/>Monitorear y Analizar]
    end
    
    subgraph "Maintenance Phase | Fase de Mantenimiento"
        CLEANUP[Feature Cleanup<br/>Limpieza de Feature]
        DEPRECATE[Mark as Deprecated<br/>Marcar como Deprecado]
        REMOVE[Remove Feature Flag<br/>Remover Feature Flag]
    end
    
    CREATE --> DEV_TEST
    DEV_TEST --> DEV_VALIDATE
    DEV_VALIDATE --> PROMOTE_STAGING
    
    PROMOTE_STAGING --> QA_TEST
    QA_TEST --> PERFORMANCE
    PERFORMANCE --> PROMOTE_PROD
    
    PROMOTE_PROD --> GRADUAL_ROLLOUT
    GRADUAL_ROLLOUT --> MONITOR
    MONITOR --> CLEANUP
    
    CLEANUP --> DEPRECATE
    DEPRECATE --> REMOVE
    
    classDef devPhase fill:#e8f5e8
    classDef testPhase fill:#fff3e0
    classDef prodPhase fill:#e3f2fd
    classDef maintPhase fill:#fce4ec
    
    class CREATE,DEV_TEST,DEV_VALIDATE devPhase
    class PROMOTE_STAGING,QA_TEST,PERFORMANCE testPhase
    class PROMOTE_PROD,GRADUAL_ROLLOUT,MONITOR prodPhase
    class CLEANUP,DEPRECATE,REMOVE maintPhase
```

## Environment Filtering Logic | Lógica de Filtrado de Entornos

```mermaid
graph TB
    subgraph "Feature Flag Definition | Definición de Feature Flag"
        FF_CONFIG[Feature Flag Configuration<br/>Configuración de Feature Flag]
        ENV_LIST[environments: [dev, staging, prod]<br/>entornos: [dev, staging, prod]]
    end
    
    subgraph "Environment Filter | Filtro de Entorno"
        CURRENT_ENV[Current Environment<br/>Entorno Actual]
        FILTER_LOGIC[Filtering Logic<br/>Lógica de Filtrado]
    end
    
    subgraph "Deployment Results | Resultados de Despliegue"
        DEV_RESULT[Development: ✅ Deploy<br/>Desarrollo: ✅ Desplegar]
        STAGING_RESULT[Staging: ✅ Deploy<br/>Staging: ✅ Desplegar]
        PROD_RESULT[Production: ✅ Deploy<br/>Producción: ✅ Desplegar]
    end
    
    subgraph "Safety Examples | Ejemplos de Seguridad"
        EXPERIMENTAL[Experimental Feature<br/>Feature Experimental]
        EXP_ENV[environments: [dev]<br/>entornos: [dev]]
        EXP_DEV[Development: ✅<br/>Desarrollo: ✅]
        EXP_STAGING[Staging: ❌<br/>Staging: ❌]
        EXP_PROD[Production: ❌<br/>Producción: ❌]
    end
    
    FF_CONFIG --> ENV_LIST
    ENV_LIST --> FILTER_LOGIC
    CURRENT_ENV --> FILTER_LOGIC
    
    FILTER_LOGIC --> DEV_RESULT
    FILTER_LOGIC --> STAGING_RESULT
    FILTER_LOGIC --> PROD_RESULT
    
    EXPERIMENTAL --> EXP_ENV
    EXP_ENV --> EXP_DEV
    EXP_ENV --> EXP_STAGING
    EXP_ENV --> EXP_PROD
    
    classDef configClass fill:#e3f2fd
    classDef filterClass fill:#fff3e0
    classDef resultClass fill:#e8f5e8
    classDef safetyClass fill:#ffebee
    
    class FF_CONFIG,ENV_LIST configClass
    class CURRENT_ENV,FILTER_LOGIC filterClass
    class DEV_RESULT,STAGING_RESULT,PROD_RESULT resultClass
    class EXPERIMENTAL,EXP_ENV,EXP_DEV,EXP_STAGING,EXP_PROD safetyClass
```

## File Structure Flow | Flujo de Estructura de Archivos

```mermaid
graph TB
    subgraph "Project Root | Raíz del Proyecto"
        ROOT[workspace/]
    end
    
    subgraph "Core Module | Módulo Principal"
        MODULE_DIR[modules/split-feature-flags/]
        MAIN_TF[main.tf]
        VARS_TF[variables.tf]
        OUT_TF[outputs.tf]
    end
    
    subgraph "Use Case Implementation | Implementación de Caso de Uso"
        USE_CASE[use-cases/banking-platform/]
        CONFIG[terraform.tfvars]
        ENV_DEV[environments/dev.tfvars]
        ENV_STAGING[environments/staging.tfvars]
        ENV_PROD[environments/prod.tfvars]
    end
    
    subgraph "Documentation | Documentación"
        DOCS[docs/]
        DOCS_EN[en/]
        DOCS_ES[es/]
        DIAGRAMS[diagrams/]
    end
    
    ROOT --> MODULE_DIR
    ROOT --> USE_CASE
    ROOT --> DOCS
    
    MODULE_DIR --> MAIN_TF
    MODULE_DIR --> VARS_TF
    MODULE_DIR --> OUT_TF
    
    USE_CASE --> CONFIG
    USE_CASE --> ENV_DEV
    USE_CASE --> ENV_STAGING
    USE_CASE --> ENV_PROD
    
    DOCS --> DOCS_EN
    DOCS --> DOCS_ES
    DOCS --> DIAGRAMS
    
    classDef rootClass fill:#f3e5f5
    classDef moduleClass fill:#e3f2fd
    classDef useCaseClass fill:#e8f5e8
    classDef docsClass fill:#fff3e0
    
    class ROOT rootClass
    class MODULE_DIR,MAIN_TF,VARS_TF,OUT_TF moduleClass
    class USE_CASE,CONFIG,ENV_DEV,ENV_STAGING,ENV_PROD useCaseClass
    class DOCS,DOCS_EN,DOCS_ES,DIAGRAMS docsClass
```

## Deployment Workflow | Flujo de Trabajo de Despliegue

```mermaid
sequenceDiagram
    participant Dev as Developer<br/>Desarrollador
    participant TF as Terraform
    participant Module as Split Module<br/>Módulo Split
    participant Split as Split.io API
    participant App as Application<br/>Aplicación

    Note over Dev,App: Environment: Development | Entorno: Desarrollo
    
    Dev->>TF: terraform apply -var-file="environments/dev.tfvars"
    TF->>Module: Load configuration | Cargar configuración
    Module->>Module: Filter flags for dev | Filtrar flags para dev
    Module->>Split: Create workspace & environment | Crear workspace y entorno
    Split-->>Module: Workspace & Environment created | Workspace y entorno creados
    Module->>Split: Create feature flags | Crear feature flags
    Split-->>Module: Feature flags created | Feature flags creados
    Module-->>TF: Deployment complete | Despliegue completo
    TF-->>Dev: Success | Éxito
    
    Note over Dev,App: Environment: Production | Entorno: Producción
    
    Dev->>TF: terraform apply -var-file="environments/prod.tfvars"
    TF->>Module: Load configuration | Cargar configuración
    Module->>Module: Filter flags for production | Filtrar flags para producción
    Module->>Split: Create production environment | Crear entorno de producción
    Split-->>Module: Production environment created | Entorno de producción creado
    Module->>Split: Create only production-ready flags | Crear solo flags listos para producción
    Split-->>Module: Production flags created | Flags de producción creados
    Module-->>TF: Deployment complete | Despliegue completo
    TF-->>Dev: Success | Éxito
    
    App->>Split: Request feature flag values | Solicitar valores de feature flags
    Split-->>App: Return flag configurations | Devolver configuraciones de flags
```