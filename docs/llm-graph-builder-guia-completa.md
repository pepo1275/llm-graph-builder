# LLM Graph Builder: Guía Maestra Completa
## Implementación Google Cloud + Resolución Problemas Neo4j + Configuración LLM Avanzada

**Fecha última actualización:** 27 Julio 2025  
**Usuario de referencia:** Pepo (macOS, macbookair_pepo_001)  
**Estado:** ✅ **IMPLEMENTACIÓN COMPLETADA Y VERIFICADA**  
**Proyecto:** `/Users/pepo/Dev/llm-graph-builder`

---

## 🎯 **RESUMEN EJECUTIVO**

### **Problemas Resueltos:**
1. ✅ **GoogleAuthError** - Configuración Google Cloud + Vertex AI
2. ✅ **ENTITY_EMBEDDING=False** - Bug crítico corregido a True
3. ✅ **Modelos LLM limitados** - Expandido a 10+ modelos incluyendo Gemini 2.5, Claude 4, GPT-4.1, o3
4. ✅ **Neo4j sigma2 desconectado** - Instancia parada tras rebuild Docker
5. ✅ **Caché Safari** - Frontend no reflejaba cambios

### **Sistema Final Operativo:**
- 🌐 **Frontend:** `http://localhost:8080` ✅ Operativo con nuevos modelos LLM
- 🤖 **Backend:** `http://localhost:8000` ✅ Operativo sin errores Google Cloud
- 🧠 **Modelos LLM:** GPT-4.1, o3, o4-mini, Claude Sonnet 4, Gemini 2.5 Pro/Flash
- 📊 **Neo4j sigma2:** `http://localhost:8691` ✅ Base datos grafos conectada
- ☁️ **Google Cloud:** Proyecto `llm-graph-builder-pepo-2025` con Vertex AI habilitado

---

## 📋 **PARTE I: IMPLEMENTACIÓN GOOGLE CLOUD DESDE CERO**

### **PASO 1: INSTALACIÓN GOOGLE CLOUD SDK**

**macOS con Homebrew:**
```bash
brew install --cask google-cloud-sdk
```

**Verificación:**
```bash
gcloud version
# Resultado esperado: Google Cloud SDK 531.0.0+
```

### **PASO 2: AUTENTICACIÓN**

```bash
gcloud auth login
```
- Se abre navegador automáticamente
- Login con cuenta Google
- Autorizar permisos Google Cloud SDK
- Credenciales guardadas localmente

**Verificación:**
```bash
gcloud auth list
# Debe mostrar cuenta autenticada activa
```

### **PASO 3: CREACIÓN PROYECTO DEDICADO**

```bash
# Crear proyecto específico para LLM Graph Builder
gcloud projects create llm-graph-builder-pepo-2025 --name="LLM Graph Builder Pepo"

# Configurar como proyecto por defecto
gcloud config set project llm-graph-builder-pepo-2025
```

**Verificación:**
```bash
gcloud config list
gcloud projects describe llm-graph-builder-pepo-2025
```

### **PASO 4: HABILITACIÓN APIs CRÍTICAS**

```bash
# API crítica para Vertex AI (Gemini models)
gcloud services enable aiplatform.googleapis.com --project=llm-graph-builder-pepo-2025

# APIs adicionales necesarias
gcloud services enable storage-api.googleapis.com --project=llm-graph-builder-pepo-2025
gcloud services enable logging.googleapis.com --project=llm-graph-builder-pepo-2025
gcloud services enable cloudresourcemanager.googleapis.com --project=llm-graph-builder-pepo-2025
```

**Verificación APIs activas:**
```bash
gcloud services list --enabled --project=llm-graph-builder-pepo-2025
```

### **PASO 5: HABILITACIÓN FACTURACIÓN** ⚠️ **OBLIGATORIO**

**⚠️ REQUISITO CRÍTICO:** Vertex AI requiere facturación habilitada

**Proceso:**
1. Visitar: `https://console.developers.google.com/billing/enable?project=llm-graph-builder-pepo-2025`
2. Asociar cuenta de facturación (tarjeta de crédito)
3. Confirmar habilitación

**Costos desarrollo:**
- ✅ $300 USD créditos gratis (3 meses)
- ✅ Desarrollo/Testing: Prácticamente gratis (céntimos)
- ✅ Vertex AI Gemini: Cuota mensual gratuita generosa

---

## 📋 **PARTE II: CONFIGURACIÓN AVANZADA .ENV**

### **PASO 6: ARCHIVO .ENV COMPLETO OPTIMIZADO**

**Ubicación:** `/Users/pepo/Dev/llm-graph-builder/.env`

```env
# Neo4j Configuration - COMENTADO PARA PERMITIR CONFIGURACIÓN DESDE UI
# LLM Graph Builder está diseñado para configurar Neo4j desde la interfaz web
# NEO4J_URI=bolt://host.docker.internal:7691
# NEO4J_USERNAME=neo4j
# NEO4J_PASSWORD=desktop_test

# LLM Configuration - 2025 Latest Versions
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here

# Modelos LLM 2025 - TODOS LOS OPENAI + GEMINI 2.5 PRO + CLAUDE 4
LLM_MODELS=gpt-4.1,gpt-4.1-mini,gpt-4.1-nano,gpt-4o,gpt-4o-mini,o3,o3-pro,o4-mini,gpt-4.5,claude-4-opus,claude-3.7-sonnet,claude-sonnet-4,gemini-2.5-pro,gemini-2.5-flash

# Configuración específica por modelo - CORREGIDA CON NOMBRES ESTÁNDAR
LLM_MODEL_CONFIG_openai_gpt_4o="gpt-4o,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4o_mini="gpt-4o-mini,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4_1="gpt-4.1,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4_1_mini="gpt-4.1-mini,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4_1_nano="gpt-4.1-nano,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_o3="o3,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_o3_pro="o3-pro,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_o4_mini="o4-mini,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4_5="gpt-4.5,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_anthropic_claude_4_opus="claude-4-opus,${ANTHROPIC_API_KEY}"
LLM_MODEL_CONFIG_anthropic_claude_3_7_sonnet="claude-3.7-sonnet,${ANTHROPIC_API_KEY}"
LLM_MODEL_CONFIG_anthropic_claude_sonnet_4="claude-sonnet-4,${ANTHROPIC_API_KEY}"
LLM_MODEL_CONFIG_gemini_2_5_pro="gemini-2.5-pro"
LLM_MODEL_CONFIG_gemini_2_5_flash="gemini-2.5-flash"
GEMINI_ENABLED=True

# Sources Configuration
VITE_REACT_APP_SOURCES="local,youtube,wiki,s3,web"

# Embedding Configuration - BUG CRÍTICO CORREGIDO
EMBEDDING_MODEL="all-MiniLM-L6-v2"
IS_EMBEDDING="true"
ENTITY_EMBEDDING=True  # ⚠️ CRÍTICO: Era False, corregido a True

# Processing Configuration
KNN_MIN_SCORE="0.94"
UPDATE_GRAPH_CHUNKS_PROCESSED=20
NUMBER_OF_CHUNKS_TO_COMBINE=6

# Frontend Configuration
VITE_BACKEND_API_URL="http://localhost:8000"

# Frontend LLM Models - EXPANDIDO PARA INCLUIR TODOS LOS MODELOS
VITE_LLM_MODELS="openai_gpt_4o,openai_gpt_4o_mini,openai_gpt_4_1,openai_gpt_4_1_mini,openai_o3,openai_o4_mini,gemini_2_5_pro,gemini_2_5_flash,anthropic_claude_sonnet_4,anthropic_claude_3_7_sonnet"

# Frontend LLM Models Production - PROBLEMA PRINCIPAL RESUELTO
VITE_LLM_MODELS_PROD="openai_gpt_4o,openai_gpt_4o_mini,openai_gpt_4_1,openai_gpt_4_1_mini,openai_o3,openai_o4_mini,gemini_2_5_pro,gemini_2_5_flash,anthropic_claude_sonnet_4,anthropic_claude_3_7_sonnet"

VITE_ENV="DEV"
VITE_SKIP_AUTH=true
VITE_BATCH_SIZE=2

# Optional - Deshabilitado
DIFFBOT_API_KEY=""
GCP_LOG_METRICS_ENABLED=False
GCS_FILE_CACHE=False

# LangChain (opcional)
LANGCHAIN_TRACING_V2=""
LANGCHAIN_PROJECT=""
LANGCHAIN_API_KEY=""
LANGCHAIN_ENDPOINT=""

# Google Cloud Configuration - Vertex AI
GOOGLE_CLOUD_PROJECT="llm-graph-builder-pepo-2025"
GOOGLE_APPLICATION_CREDENTIALS="/root/.config/gcloud/application_default_credentials.json"
```

### **CAMBIOS CRÍTICOS APLICADOS:**

1. **🐛 Bug Principal Corregido:**
   - `ENTITY_EMBEDDING=False` → `ENTITY_EMBEDDING=True`
   - **Impacto:** Embeddings de entidades habilitados para GraphRAG mejorado

2. **🚀 Nuevos Modelos LLM:**
   - **OpenAI:** gpt-4.1, gpt-4.1-mini, o3, o4-mini, gpt-4.5
   - **Anthropic:** claude-4-opus, claude-sonnet-4
   - **Google:** gemini-2.5-pro, gemini-2.5-flash (via Vertex AI)

3. **🎯 Frontend Dropdown Expandido:**
   - `VITE_LLM_MODELS_PROD` ahora incluye TODOS los modelos configurados
   - **Problema resuelto:** Modelos no aparecían en dropdown del frontend

---

## 📋 **PARTE III: RECONSTRUCCIÓN Y DEPLOYMENT**

### **PASO 7: RECONSTRUCCIÓN BACKEND**

```bash
cd /Users/pepo/Dev/llm-graph-builder

# Detener servicios
docker-compose down

# Reconstruir backend con nueva configuración
docker-compose up --build backend
```

**Logs exitosos esperados:**
```
[INFO] Starting gunicorn 23.0.0
[INFO] Listening at: http://0.0.0.0:8000
[INFO] Using worker: uvicorn.workers.UvicornWorker
[INFO] Application startup complete.
```

**Verificación backend:**
```bash
curl http://localhost:8000/health
# Resultado esperado: {"healthy":true}
```

### **PASO 8: RECONSTRUCCIÓN FRONTEND** 

⚠️ **CRÍTICO:** Las variables `VITE_*` requieren rebuild del frontend

```bash
# Detener frontend
docker-compose down frontend

# Reconstruir frontend con nuevas variables VITE_*
docker-compose up --build frontend -d
```

**Verificación frontend:**
```bash
curl -I http://localhost:8080
# Resultado esperado: HTTP/1.1 200 OK
```

---

## 📋 **PARTE IV: RESOLUCIÓN PROBLEMA NEO4J**

### **PROBLEMA: Neo4j sigma2 Desconectado**

**Síntoma:** Frontend no puede conectar a Neo4j con:
```
Protocol: bolt
URI: host.docker.internal:7691
Database: neo4j
User: neo4j
Password: desktop_test
```

### **DIAGNÓSTICO:**

```bash
# Verificar instancias Neo4j activas
docker ps | grep neo4j

# Verificar si sigma2 existe pero está parada
docker ps -a | grep sigma2
```

**Resultado típico del problema:**
```
sigma2    neo4j:5.26.0    Exited (137) X minutes ago
```

### **SOLUCIÓN INMEDIATA:**

```bash
# Arrancar sigma2
docker start sigma2

# Verificar que esté corriendo
docker ps | grep sigma2
```

**Resultado esperado:**
```
sigma2   neo4j:5.26.0   Up X seconds   0.0.0.0:8691->7474/tcp, 0.0.0.0:7691->7687/tcp
```

### **VERIFICACIÓN CONECTIVIDAD:**

```bash
# Verificar HTTP interface
curl -I http://localhost:8691
# Resultado esperado: HTTP/1.1 200 OK

# Reconectar desde frontend con los mismos datos:
# Protocol: bolt
# URI: host.docker.internal:7691
# Database: neo4j
# User: neo4j  
# Password: desktop_test
```

---

## 📋 **PARTE V: RESOLUCIÓN PROBLEMA CACHÉ SAFARI**

### **PROBLEMA: Frontend No Refleja Cambios**

**Causa:** Safari cachea agresivamente + Variables `VITE_*` requieren rebuild

### **SOLUCIÓN CACHÉ SAFARI:**

**Opción A - Desarrollo (RECOMENDADO):**
1. Safari → Preferencias (⌘+,)
2. Avanzado → ✅ "Mostrar menú Desarrollo en la barra de menús"
3. Menú "Desarrollo" → "Vaciar cachés"
4. Ve a `http://localhost:8080`
5. Presiona **⌘+Shift+R** (recarga forzada)

**Opción B - Caché general:**
1. Safari → Historial → Borrar historial...
2. Seleccionar "Última hora"
3. ✅ Confirmar

**Opción C - Verificación modo privado:**
1. **⌘+Shift+N** (ventana privada)
2. Ve a `http://localhost:8080`

---

## 📋 **PARTE VI: VERIFICACIONES FINALES**

### **HEALTH CHECKS COMPLETOS:**

```bash
# 1. Backend
curl http://localhost:8000/health
# Esperado: {"healthy":true}

# 2. Frontend  
curl -I http://localhost:8080
# Esperado: HTTP/1.1 200 OK

# 3. Neo4j sigma2
curl -I http://localhost:8691
# Esperado: HTTP/1.1 200 OK

# 4. Estado servicios Docker
cd /Users/pepo/Dev/llm-graph-builder
docker-compose ps
# Esperado: backend y frontend "Up"

# 5. Neo4j instances
docker ps | grep neo4j
# Esperado: sigma2 "Up" con puertos 8691:7474 y 7691:7687
```

### **FUNCIONALIDADES A VERIFICAR:**

✅ **Dropdown LLM Models expandido:**
- OpenAI: gpt-4o, gpt-4o-mini, gpt-4.1, gpt-4.1-mini, o3, o4-mini
- Anthropic: claude-sonnet-4, claude-3.7-sonnet  
- Google: gemini-2.5-pro, gemini-2.5-flash

✅ **Conexión Neo4j operativa:**
- Datos conexión: bolt://host.docker.internal:7691, neo4j/desktop_test

✅ **Embeddings mejorados:**
- ENTITY_EMBEDDING=True → Mejor rendimiento GraphRAG

✅ **Google Cloud integrado:**
- Sin errores GoogleAuthError
- Vertex AI Gemini disponible

---

## 📋 **PARTE VII: SCRIPT AUTOMATIZACIÓN COMPLETA**

### **Script Reproducción Nuevo Entorno:**

```bash
#!/bin/bash
# LLM Graph Builder - Setup Completo Automatizado

echo "🚀 Iniciando setup completo LLM Graph Builder..."

# 1. Google Cloud SDK
echo "📦 Instalando Google Cloud SDK..."
brew install --cask google-cloud-sdk

# 2. Autenticación
echo "🔐 Configurando autenticación..."
gcloud auth login

# 3. Proyecto
echo "🎯 Creando proyecto..."
gcloud projects create llm-graph-builder-pepo-2025 --name="LLM Graph Builder Pepo"
gcloud config set project llm-graph-builder-pepo-2025

# 4. APIs
echo "🚀 Habilitando APIs..."
gcloud services enable aiplatform.googleapis.com --project=llm-graph-builder-pepo-2025
gcloud services enable storage-api.googleapis.com --project=llm-graph-builder-pepo-2025
gcloud services enable logging.googleapis.com --project=llm-graph-builder-pepo-2025
gcloud services enable cloudresourcemanager.googleapis.com --project=llm-graph-builder-pepo-2025

# 5. Variables entorno
echo "🔧 Configurando .env..."
cd /Users/pepo/Dev/llm-graph-builder

# Crear backup
cp .env .env.backup.$(date +%Y%m%d_%H%M%S)

# Aplicar configuración optimizada (copiar desde la guía)
cat > .env << 'EOF'
# [Insertar contenido completo .env de la sección PASO 6]
EOF

echo "⚠️  ATENCIÓN: Habilita facturación manualmente:"
echo "https://console.developers.google.com/billing/enable?project=llm-graph-builder-pepo-2025"
echo ""
echo "Después ejecuta:"
echo "docker-compose down"
echo "docker-compose up --build backend"
echo "docker-compose up --build frontend -d"
echo "docker start sigma2"
```

### **Verificación Post-Setup:**

```bash
# Verificaciones automáticas
echo "🔍 Verificaciones finales..."

# Google Cloud
gcloud config list
gcloud services list --enabled --project=llm-graph-builder-pepo-2025

# Servicios
docker-compose ps
docker ps | grep neo4j

# Health checks
curl http://localhost:8000/health
curl -I http://localhost:8080
curl -I http://localhost:8691

echo "✅ Setup completado!"
```

---

## 📋 **PARTE VIII: TROUBLESHOOTING COMÚN**

### **Error: BILLING_DISABLED**
```bash
# Solución: Habilitar facturación en Google Cloud Console
https://console.developers.google.com/billing/enable?project=llm-graph-builder-pepo-2025
```

### **Error: API not enabled**
```bash
# Verificar APIs
gcloud services list --enabled --project=llm-graph-builder-pepo-2025

# Habilitar API faltante
gcloud services enable [API_NAME] --project=llm-graph-builder-pepo-2025
```

### **Error: Neo4j connection refused**
```bash
# Verificar sigma2
docker ps -a | grep sigma2

# Si está parada, arrancar
docker start sigma2

# Verificar puertos
docker ps | grep sigma2
# Debe mostrar: 0.0.0.0:7691->7687/tcp
```

### **Error: Frontend no muestra modelos nuevos**
```bash
# Rebuild frontend (crítico para variables VITE_*)
docker-compose down frontend
docker-compose up --build frontend -d

# Limpiar caché Safari (ver Parte V)
```

### **Error: GoogleAuthError**
```bash
# Re-autenticar
gcloud auth login
gcloud auth application-default login

# Verificar proyecto
gcloud config set project llm-graph-builder-pepo-2025
```

---

## 📋 **PARTE IX: CONFIGURACIÓN REFERENCIA**

### **Estado Neo4j Instances Final:**

| Container | HTTP | Bolt | Estado | Propósito |
|-----------|------|------|--------|-----------|
| **sigma2** | 8691 | 7691 | ✅ **ACTIVO** | **LLM Graph Builder Principal** |
| graphiti-neo4j | 7474 | 7687 | ✅ ACTIVO | Graphiti Principal |
| graphiti-neo4j-openai | 8694 | 7694 | ✅ ACTIVO | Graphiti OpenAI |
| graphiti-neo4j-gemini | 8693 | 7693 | ✅ ACTIVO | Graphiti Gemini |

### **URLs Acceso Sistema:**

- 🌐 **Frontend LLM Graph Builder:** `http://localhost:8080`
- 🤖 **Backend API:** `http://localhost:8000` 
- 📊 **Neo4j Browser (sigma2):** `http://localhost:8691`
- ☁️ **Google Cloud Console:** `https://console.cloud.google.com/home/dashboard?project=llm-graph-builder-pepo-2025`

### **Modelos LLM Disponibles:**

**OpenAI (via OpenAI API):**
- gpt-4o, gpt-4o-mini
- gpt-4.1, gpt-4.1-mini, gpt-4.1-nano  
- o3, o3-pro, o4-mini
- gpt-4.5

**Anthropic (via Anthropic API):**
- claude-4-opus
- claude-3.7-sonnet  
- claude-sonnet-4

**Google (via Vertex AI):**
- gemini-2.5-pro
- gemini-2.5-flash

---

## 🎯 **RESULTADO FINAL**

**✅ Sistema LLM Graph Builder completamente operativo:**
- 🌐 Frontend React con dropdown LLM expandido
- 🤖 Backend FastAPI sin errores Google Cloud  
- 🧠 10+ modelos LLM incluyendo Gemini 2.5, Claude 4, GPT-4.1, o3
- 📊 Neo4j 5.26.0 para GraphRAG con embeddings optimizados
- ☁️ Integración completa Google Cloud Platform + Vertex AI

**💰 Costos:** Prácticamente $0 en desarrollo (dentro de capa gratuita $300 USD)

**🚀 Listo para explorar capacidades GraphRAG avanzadas con embeddings de entidades mejorados!**

---

*Guía generada: 27 Julio 2025*  
*Implementación exitosa completa: LLM Graph Builder + Google Cloud + Vertex AI + Neo4j + 10+ Modelos LLM*