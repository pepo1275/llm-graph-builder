# 🧠 LLM Graph Builder - Enhanced Edition

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-green.svg)](https://fastapi.tiangolo.com)
[![React](https://img.shields.io/badge/React-18+-blue.svg)](https://react.dev)
[![Neo4j](https://img.shields.io/badge/Neo4j-5.26+-red.svg)](https://neo4j.com)
[![Docker](https://img.shields.io/badge/Docker-compose-blue.svg)](https://docker.com)

**Enhanced Knowledge Graph Builder** con integración completa de Google Cloud, 10+ modelos LLM avanzados, y GraphRAG optimizado.

## 🚀 **Diferencias vs Proyecto Original**

### **✨ Nuevas Funcionalidades**
- 🌐 **Google Cloud + Vertex AI**: Integración completa con Gemini 2.5 Pro/Flash
- 🤖 **10+ Modelos LLM**: OpenAI GPT-4.1/o3, Claude 4, Anthropic Claude Sonnet 4
- 🧠 **Embeddings Mejorados**: Bug crítico `ENTITY_EMBEDDING=True` corregido
- ⚡ **GraphRAG Optimizado**: Rendimiento mejorado para grafos de conocimiento
- 🔧 **Configuración Avanzada**: Setup automatizado y troubleshooting completo

### **🐛 Problemas Resueltos**
- ✅ **GoogleAuthError** - Configuración Google Cloud SDK completa
- ✅ **Entity Embedding Bug** - Corregido de False a True para GraphRAG
- ✅ **Modelos LLM Limitados** - Expandido a 10+ modelos cutting-edge
- ✅ **Neo4j Conectividad** - Resolución automática instancias Docker
- ✅ **Frontend Caché** - Solución para Safari + variables VITE_*

## 🎯 **Quick Start**

### **Prerrequisitos**
- Docker & Docker Compose
- Google Cloud SDK (incluido en setup)
- Neo4j Desktop o instancia Docker
- Claves API: OpenAI, Anthropic, Google (Vertex AI)

### **Instalación Rápida**
```bash
# Clonar repositorio
git clone https://github.com/TU_USUARIO/llm-graph-builder-pepo-enhanced.git
cd llm-graph-builder-pepo-enhanced

# Setup automatizado
./scripts/setup_complete.sh

# Iniciar servicios
docker-compose up --build
```

### **URLs de Acceso**
- 🌐 **Frontend**: http://localhost:8080
- 🤖 **Backend API**: http://localhost:8000
- 📊 **Neo4j Browser**: http://localhost:8691

## 📚 **Documentación Completa**

- 📖 [**Guía Completa de Implementación**](docs/llm-graph-builder-guia-completa.md)
- 🔧 [**Configuración Google Cloud**](docs/google-cloud-setup.md)
- 🐛 [**Troubleshooting Avanzado**](docs/troubleshooting.md)
- 🤖 [**Modelos LLM Soportados**](docs/llm-models.md)

## 🛠️ **Tecnologías**

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Backend | FastAPI + Python | 3.8+ |
| Frontend | Vite + React | 18+ |
| Base de Datos | Neo4j | 5.26+ |
| LLM Integration | LangChain | Latest |
| Cloud Platform | Google Cloud + Vertex AI | Latest |
| Containerización | Docker Compose | Latest |

## 🏗️ **Arquitectura**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React UI      │    │   FastAPI       │    │   Neo4j Graph   │
│   (Port 8080)   │◄──►│   (Port 8000)   │◄──►│   (Port 7691)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   10+ LLM       │    │ Google Cloud    │    │   GraphRAG      │
│   Models        │    │ Vertex AI       │    │   Embeddings    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🤝 **Contribuciones**

Leé nuestra [Guía de Contribución](CONTRIBUTING.md) para detalles sobre:
- 🔄 Proceso de Pull Requests
- 🐛 Reporte de Bugs
- ✨ Solicitud de Features
- 📝 Estándares de Código

## 📄 **Licencia**

Este proyecto está bajo la licencia [Apache 2.0](LICENSE) - ver archivo para detalles.

## 🙏 **Reconocimientos**

- 🏆 **Proyecto Original**: [Neo4j LLM Graph Builder](https://github.com/neo4j-labs/llm-graph-builder)
- 🧠 **Enhanced por**: Pepo (macbookair_pepo_001)
- 📅 **Última Actualización**: Julio 2025

---

> **💡 Tip**: Para la experiencia completa, sigue la [Guía Completa](docs/llm-graph-builder-guia-completa.md) que incluye setup Google Cloud, resolución de problemas, y configuración avanzada.
