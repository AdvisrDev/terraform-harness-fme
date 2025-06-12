# Harness Feature Management and Experimentation with Terraform

A comprehensive, production-ready Terraform module for managing feature flags across multiple environments with advanced lifecycle management, safety controls, and environment-specific configurations.

---

*Módulo de Terraform integral y listo para producción para administrar feature flags en múltiples entornos con gestión avanzada del ciclo de vida, controles de seguridad y configuraciones específicas por entorno.*

## 📚 Documentation | Documentación

### English Documentation

| Category | Description | Path |
|----------|-------------|------|
| **🔧 Technical** | Module architecture, module development details | [`documentation/en/technical/`](documentation/en/technical/) |
| **👥 User Guide** | Implementation guides, tutorials, examples | [`documentation/en/user/`](documentation/en/user/) |

---
### ➡️ Where to start

#### Starter 
1. [Getting Started](documentation/en/user/1.getting-started.md) 
2. [Banking Platform Example](use-cases/banking-platform/) 

#### Advanced 
1. [Architecture Deep Dive](documentation/en/technical/1.architecture.md) 
2. [Feature Environment-Specific Management](documentation/en/technical/2.feature-flag-management.md) 
3. [Best Practices](documentation/en/user/3.best-practices.md) 



### Documentación en Español

| Categoría | Descripción | Ruta |
|-----------|-------------|------|
| **🔧 Técnica** | Arquitectura del módulo, desarrollo del modulo | [`documentation/es/technical/`](documentation/es/technical/) |
| **👥 Guías de Usuario** | Tutoriales, guías de implementación, ejemplos | [`documentation/es/user/`](documentation/es/user/) |

---
### ➡️ Como Iniciar

#### Inicial
2. [Primeros Pasos](documentation/es/user/1.primeros-pasos.md)
3. [Ejemplo Plataforma Bancaria](use-cases/banking-platform/)

#### Avanzado
1. [Análisis Profundo de Arquitectura](documentation/es/technical/1.arquitectura.md)
2. [Configuraciones por Entorno de Feature Flags ](documentation/es/technical/2.configuracion.md)
3. [Mejores Prácticas](documentation/es/user/3.mejores-practicas.md)


---

## 📊 Documentation Structure | Estructura de Documentación

```
documentation/
├── en/                          # English Documentation

│   ├── technical/               # Technical Documentation
│       ├── architecture.md      # Module architecture & design
│       ├── implementation.md    # Implementation details
│       ├── configuration.md     # Configuration reference
│       └── api-reference.md     # API & variables reference

│   ├── user/                    # User Documentation
│       ├── getting-started.md   # Quick start guide
│       ├── tutorials/           # Step-by-step tutorials
│       ├── best-practices.md    # Best practices & patterns
│       └── troubleshooting.md   # Common issues & solutions
│
├── es/                          # Documentación en Español

│   ├── technical/               # Documentación Técnica
│   │   ├── arquitectura.md      # Arquitectura y diseño del módulo
│   │   ├── implementacion.md    # Detalles de implementación
│   │   ├── configuracion.md     # Referencia de configuración
│   │   └── referencia-api.md    # Referencia API y variables

└── └── user/                    # Documentación de Usuario
        ├── primeros-pasos.md    # Guía de inicio rápido
        ├── tutoriales/          # Tutoriales paso a paso
        ├── mejores-practicas.md # Mejores prácticas y patrones
        └── solucion-problemas.md# Problemas comunes y soluciones
```

## ✨ Key Features | Características Principales

### English
- **Environment Safety**: Automatic filtering prevents accidental production deployments
- **Environment-Specific Configs**: Different behaviors per environment with single source of truth
- **Lifecycle Management**: Progressive feature promotion through environments
- **Production Ready**: Battle-tested patterns and best practices

### Español
- **Seguridad de Entornos**: Filtrado automático previene despliegues accidentales en producción
- **Configuraciones por Entorno**: Diferentes comportamientos por entorno con fuente única de verdad
- **Gestión del Ciclo de Vida**: Promoción progresiva de características a través de entornos
- **Listo para Producción**: Patrones probados y mejores prácticas

## 📄 License | Licencia

This project is licensed under the MIT License.  
Este proyecto está licenciado bajo la Licencia MIT.