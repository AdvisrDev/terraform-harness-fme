# Primeros Pasos con Feature Flags de Split.io y Terraform

Esta guía te llevará paso a paso a través de la configuración y despliegue de tus primeros feature flags usando nuestro módulo de Terraform.

## 📋 Prerequisitos

Antes de comenzar, asegúrate de tener:

- **Terraform** >= 1.5 instalado ([Descargar aquí](https://www.terraform.io/downloads))
- **Cuenta de Split.io** con acceso API ([Registrarse aquí](https://www.split.io/))
- **Git** para clonar el repositorio
- **Conocimiento básico** de Terraform y feature flags

## 🚀 Paso 1: Configuración del Entorno

### 1.1 Clonar el Repositorio

```bash
git clone <url-del-repositorio>
cd split-feature-flags-terraform
```

### 1.2 Obtener tu Clave API de Split.io

1. Inicia sesión en tu cuenta de Split.io
2. Navega a **Configuración de Admin** → **Claves API**
3. Crea una nueva clave API o copia una existente
4. Anota el nombre de tu workspace

### 1.3 Configurar Variables de Entorno

```bash
# Configura tu clave API de Split.io
export TF_VAR_split_api_key="tu-clave-api-split-io"

# Opcional: Configurar nombre del workspace
export TF_VAR_workspace_name="nombre-de-tu-workspace"
```

## 🎯 Paso 2: Elige tu Ruta de Implementación

Tienes tres opciones para comenzar:

### Opción A: Caso de Uso de Plataforma Bancaria (Recomendado para Principiantes)
Ejemplo preconfigurado con feature flags específicos para banca.

### Opción B: Ejemplo Simple
Configuración básica de feature flag para aprendizaje.

### Opción C: Implementación Personalizada
Construye tu propia usando el módulo principal.

Comencemos con la **Opción A** - la Plataforma Bancaria:

## 🏦 Paso 3: Configuración de Plataforma Bancaria

### 3.1 Navegar a la Plataforma Bancaria

```bash
cd use-cases/banking-platform
```

### 3.2 Revisar la Configuración

La plataforma bancaria incluye:

```hcl
# terraform.tfvars - Configuración principal
feature_flags = [
  {
    name              = "bankvalidation"
    description       = "Validación de transacciones backend"
    default_treatment = "off"
    environments      = ["dev", "staging", "prod"]
    lifecycle_stage   = "production"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"validation\": false}"
        description    = "Validación deshabilitada"
      },
      {
        name           = "on"
        configurations = "{\"validation\": true, \"strict\": true}"
        description    = "Validación estricta habilitada"
      }
    ]
    rules = [
      {
        condition = {
          matcher = {
            type      = "EQUAL_SET"
            attribute = "customerID"
            strings   = ["user123"]
          }
        }
      }
    ]
  }
  # ... más feature flags
]
```

### 3.3 Archivos de Entorno

Cada entorno tiene su propia configuración:

```bash
# environments/dev.tfvars
environment_name = "dev"
is_production    = false

# environments/staging.tfvars
environment_name = "staging"
is_production    = false

# environments/prod.tfvars
environment_name = "prod"
is_production    = true
```

## 🚀 Paso 4: Desplegar a Desarrollo

### 4.1 Inicializar Terraform

```bash
terraform init
```

### 4.2 Planificar el Despliegue

```bash
terraform plan \
  -var-file="environments/dev.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

Revisa los cambios planificados:
- Creación/verificación del workspace
- Creación del entorno de desarrollo
- Feature flags que serán creados en desarrollo

### 4.3 Aplicar la Configuración

```bash
terraform apply \
  -var-file="environments/dev.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

Escribe `yes` cuando se te solicite confirmar.

### 4.4 Verificar el Despliegue

Revisa tu dashboard de Split.io:
1. Navega a tu workspace
2. Verifica que el entorno de desarrollo fue creado
3. Comprueba que los feature flags están listados
4. Verifica que las reglas de targeting están configuradas

## 📊 Paso 5: Entendiendo el Filtrado de Entornos

El sistema filtra automáticamente los feature flags basado en el entorno:

### Entorno de Desarrollo
```bash
# Todos los flags marcados para "dev" serán creados
terraform apply -var-file="environments/dev.tfvars" -var="split_api_key=tu-clave"
```

**Resultado**: Crea flags con `environments = ["dev"]` o que contengan `"dev"`

### Entorno de Staging
```bash
# Solo flags marcados para "staging" serán creados
terraform apply -var-file="environments/staging.tfvars" -var="split_api_key=tu-clave"
```

**Resultado**: Crea flags con `environments` que contengan `"staging"`

### Entorno de Producción
```bash
# Solo flags listos para producción serán creados
terraform apply -var-file="environments/prod.tfvars" -var="split_api_key=tu-clave"
```

**Resultado**: Crea solo flags con `environments` que contengan `"prod"`

## 🔧 Paso 6: Desplegar a Entornos Adicionales

### 6.1 Desplegar a Staging

```bash
terraform apply \
  -var-file="environments/staging.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

### 6.2 Desplegar a Producción

```bash
terraform apply \
  -var-file="environments/prod.tfvars" \
  -var="split_api_key=$TF_VAR_split_api_key"
```

**Nota**: Solo los flags marcados con `environments = ["dev", "staging", "prod"]` serán desplegados a producción.

## 📈 Paso 7: Verificar la Seguridad de Entornos

Verifica que las características experimentales están filtradas apropiadamente:

1. **En Desarrollo**: Todos los feature flags deberían ser visibles
2. **En Staging**: Las características marcadas para staging y producción deberían ser visibles
3. **En Producción**: Solo las características listas para producción deberían ser visibles

Ejemplo de verificación de seguridad:
- `voice-banking-beta` debería aparecer solo en desarrollo
- `advanced-fraud-detection` debería aparecer en desarrollo y staging
- `bankvalidation` debería aparecer en todos los entornos

## 🛠️ Paso 8: Personalizar tus Feature Flags

### 8.1 Modificar Flags Existentes

Edita `terraform.tfvars`:

```hcl
feature_flags = [
  {
    name              = "mi-caracteristica-personalizada"
    description       = "Característica personalizada para mi aplicación"
    default_treatment = "off"
    environments      = ["dev"]  # Comenzar solo con dev
    lifecycle_stage   = "development"
    category          = "feature"
    treatments = [
      {
        name           = "off"
        configurations = "{\"enabled\": false}"
        description    = "Característica deshabilitada"
      },
      {
        name           = "on"
        configurations = "{\"enabled\": true, \"config\": \"valor\"}"
        description    = "Característica habilitada"
      }
    ]
    rules = []  # Sin reglas de targeting inicialmente
  }
]
```

### 8.2 Aplicar Cambios

```bash
terraform plan -var-file="environments/dev.tfvars" -var="split_api_key=$TF_VAR_split_api_key"
terraform apply -var-file="environments/dev.tfvars" -var="split_api_key=$TF_VAR_split_api_key"
```

## 📚 Paso 9: Explorar Características Avanzadas

### 9.1 Revisar Gestión de Características

Aprende sobre estrategias avanzadas de feature flags:
```bash
# Leer la guía de gestión de características
cat docs/es/gestion-caracteristicas.md
```

### 9.2 Revisar Ejemplos

Explora ejemplos adicionales:
```bash
# Ejemplo simple de feature flag
cd examples/simple-feature-flag

# Ejemplo de targeting avanzado
cd examples/advanced-targeting

# Ejemplo de gestión del ciclo de vida
cd examples/feature-flag-lifecycle
```

### 9.3 Leer Mejores Prácticas

```bash
cat docs/es/mejores-practicas.md
```

## 🐛 Solución de Problemas

### Problemas Comunes

#### 1. Problemas con Clave API
```
Error: No se puede autenticar con Split.io
```
**Solución**: Verifica que tu clave API sea correcta y tenga los permisos apropiados.

#### 2. Workspace No Encontrado
```
Error: Workspace 'MiWorkspace' no encontrado
```
**Solución**: Asegúrate de que el nombre del workspace en tu configuración coincida con tu workspace de Split.io.

#### 3. El Entorno Ya Existe
```
Error: El entorno ya existe
```
**Solución**: Esto es normal si el entorno fue creado previamente. Terraform manejará el entorno existente.

#### 4. Errores de Validación de Feature Flag
```
Error: El nombre del feature flag no puede estar vacío
```
**Solución**: Revisa tu configuración de feature flag para campos requeridos faltantes.

### Comandos de Debug

```bash
# Validar configuración
terraform validate

# Revisar estado actual
terraform show

# Refrescar estado
terraform refresh -var-file="environments/dev.tfvars" -var="split_api_key=$TF_VAR_split_api_key"
```

## ✅ Paso 10: Siguientes Pasos

¡Felicitaciones! Has desplegado exitosamente tus primeros feature flags. Aquí está lo que puedes hacer a continuación:

### 1. Aprender Patrones Avanzados
- [Estrategias de Gestión de Características](gestion-caracteristicas.md)
- [Guía de Mejores Prácticas](mejores-practicas.md)
- [Análisis Profundo de Arquitectura](arquitectura.md)

### 2. Explorar Más Casos de Uso
- Plataforma Bancaria (¡acabas de completar esto!)
- Plataforma de Comercio Electrónico (próximamente)
- Aplicaciones Móviles (próximamente)

### 3. Integrar con tu Aplicación
- Instalar SDK de Split.io para tu lenguaje de programación
- Configurar evaluación de feature flags en tu código
- Configurar monitoreo y analíticas

### 4. Preparación para Producción
- Configurar gestión remota de estado
- Configurar integración CI/CD
- Implementar gestión apropiada de secretos
- Configurar monitoreo y alertas

## 🔗 Enlaces Rápidos

- [Resumen de Arquitectura](arquitectura.md)
- [Guía de Gestión de Características](gestion-caracteristicas.md)
- [Mejores Prácticas](mejores-practicas.md)
- [Casos de Uso](casos-uso.md)
- [Contribuir](contribuir.md)

## 🆘 ¿Necesitas Ayuda?

- Revisa la [sección de solución de problemas](#solución-de-problemas) arriba
- Revisa el [directorio de ejemplos](../../examples/)
- Lee la [guía de mejores prácticas](mejores-practicas.md)
- Abre un issue en GitHub

---

**¿Listo para el siguiente paso?** Elige tu camino:

- 🏗️ [**Análisis Profundo de Arquitectura**](arquitectura.md) - Entiende cómo funciona
- 🎯 [**Gestión de Características**](gestion-caracteristicas.md) - Estrategias avanzadas
- 💡 [**Mejores Prácticas**](mejores-practicas.md) - Patrones de producción
- 🌍 [**Documentación en Inglés**](../en/getting-started.md) - Versión en inglés