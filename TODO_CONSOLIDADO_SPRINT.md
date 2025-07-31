# 📋 TODO Consolidado - Sprint Planning

**Fecha**: 31 Julio 2025  
**Estado actual**: Migración Git Flow 95% completada  
**Objetivo**: Consolidar todos los TODOs para evaluación y priorización

## 🚨 TODOs Críticos (P0) - Bloquean producción

### 1. Finalizar Migración Git Flow
- [ ] Commit y push de fix de dependencias torch/accelerate
- [ ] Push develop a fork personal
- [ ] Crear PR al repositorio principal
- [ ] Limpiar fork antiguo y re-forkear limpio

## 🔧 TODOs de Arquitectura (P1) - Mejoras técnicas importantes

### 1. Gestión de Dependencias Python
**Fuente**: `/backend/requirements.txt:18-22`
- [ ] Implementar automated dependency vulnerability scanning
- [ ] Add dependency update automation with testing pipeline  
- [ ] Consider moving to poetry/pipenv for lock file management
- [ ] Add compatibility testing matrix for LangChain updates
- [ ] Implementar --extra-index-url en Dockerfile para torch CPU/GPU

### 2. Arquitectura de Embeddings
**Fuente**: `/backend/src/shared/common_fn.py:78` y múltiples archivos
- [ ] Implementar EmbeddingConfig manager centralizado
- [ ] Domain-specific embedding architecture (3072d para código vs 768d para texto)
- [ ] Unified embedding dimension management
- [ ] Cache management para modelos de embeddings

### 3. Soporte Multi-Entorno (CPU/GPU)
**Fuente**: Análisis de esta sesión
- [ ] Dockerfile con ARG para builds CPU/GPU condicionales
- [ ] docker-compose.yml con perfiles para CPU/GPU
- [ ] Detección automática de hardware en desarrollo local
- [ ] Documentar configuración para equipos con NVIDIA GPU

### 4. Configuración de Vertex AI y Google Cloud
**Fuente**: `VERTEX_AI_CONFIG.md` y análisis de esta sesión
- [ ] Crear script de setup automático para Google Cloud (`setup-gcloud.sh`)
- [ ] Implementar modo fallback cuando no hay credenciales de Vertex AI
- [ ] Agregar validación de credenciales en startup del backend
- [ ] Hacer path dinámico para volumen de gcloud en docker-compose
- [ ] Documentar configuración para otros providers (OpenAI, Azure, AWS)
- [ ] Implementar detección automática de credenciales disponibles

## 📝 TODOs de Código (P2) - Mejoras funcionales

### 1. Frontend
**Fuente**: `/backend/src/shared/constants.py:551`
```javascript
// TODO: need to add limit
```
- [ ] Implementar límite en query (probablemente paginación)

### 2. Testing
**Fuente**: CLAUDE.md y análisis de sesión
- [ ] Implementar test-embedding-consistency.py
- [ ] Crear suite de integration tests para Neo4j
- [ ] Performance tests con Locust para LLM processing
- [ ] Matrix testing para diferentes entornos

### 3. Scripts de Validación
**Fuente**: Esta sesión
- [ ] Integrar validate-torch-cpu.sh en CI/CD
- [ ] Crear script de validación de embeddings
- [ ] Automatizar verificación de dimensiones

## 🏗️ TODOs de Infraestructura (P3) - Deploy y CI/CD

### 1. Google Cloud Platform
**Fuente**: CLAUDE.md
- [ ] Configurar Cloud Run para backend
- [ ] Implementar Secret Manager para API keys
- [ ] Cloud Build pipeline
- [ ] Monitoring con Cloud Operations

### 2. CI/CD Pipeline
- [ ] GitHub Actions para tests automáticos
- [ ] Build validation en PRs
- [ ] Dependency security scanning
- [ ] Automated performance regression tests

## 📚 TODOs de Documentación (P4) - Mejoras de mantenibilidad

### 1. Documentación Técnica
- [ ] Actualizar CLAUDE.md con sección de dependency management
- [ ] Documentar decisiones de arquitectura (ADRs)
- [ ] Guía de configuración CPU/GPU
- [ ] Troubleshooting guide actualizada

### 2. Documentación de Procesos
- [ ] Git Flow workflow documentation
- [ ] PR template con checklist
- [ ] Release process documentation
- [ ] Onboarding guide para nuevos desarrolladores

## 🔍 TODOs de Investigación (P5) - Exploratorios

### 1. Optimizaciones
- [ ] Evaluar accelerate 1.8.0+ para mejor compatibilidad
- [ ] Investigar alternativas a sentence-transformers
- [ ] Benchmark de diferentes modelos de embeddings
- [ ] Optimización de queries Cypher

### 2. Nuevas Features
- [ ] Soporte para más tipos de documentos
- [ ] Batch processing mejorado
- [ ] API de streaming para documentos grandes
- [ ] Webhooks para procesamiento asíncrono

## 📊 Resumen por Prioridad

| Prioridad | Categoría | Cantidad | Esfuerzo Estimado |
|-----------|-----------|----------|-------------------|
| P0 | Críticos | 4 items | 1-2 horas |
| P1 | Arquitectura | 16 items | 3-4 días |
| P2 | Código | 8 items | 3-5 días |
| P3 | Infraestructura | 8 items | 1 semana |
| P4 | Documentación | 8 items | 2-3 días |
| P5 | Investigación | 8 items | Variable |

## 🎯 Recomendaciones para Próximo Sprint

### Sprint Inmediato (1 semana):
1. Completar P0 (migración Git Flow)
2. Abordar P1 items críticos (dependency management)
3. Documentar decisiones tomadas

### Sprint Siguiente (2 semanas):
1. Implementar soporte CPU/GPU
2. Mejorar testing coverage
3. Comenzar migración a GCP

### Backlog Futuro:
- Migración a Poetry
- Optimizaciones de performance
- Features exploratorias

---

**NOTA**: Este documento debe actualizarse al inicio de cada sprint para reflejar nuevos TODOs encontrados y progreso realizado.