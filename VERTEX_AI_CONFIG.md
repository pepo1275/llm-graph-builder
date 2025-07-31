# 🔧 Configuración de Vertex AI y Google Cloud

## ⚠️ IMPORTANTE: Configuración de Credenciales

Este proyecto utiliza **Vertex AI** para embeddings con el modelo `gemini-embedding-001` (3072 dimensiones).

### 📋 Requisitos Previos

1. **Cuenta de Google Cloud** con proyecto activo
2. **gcloud CLI** instalado y configurado
3. **APIs habilitadas**:
   - Vertex AI API
   - Cloud Resource Manager API

### 🚀 Configuración Paso a Paso

#### 1. Autenticación con Google Cloud
```bash
# Login con Application Default Credentials (ADC)
gcloud auth application-default login

# Login regular de gcloud
gcloud auth login

# Verificar proyecto actual
gcloud config get-value project
# Debe mostrar: llm-graph-builder-pepo-2025
```

#### 2. Docker Compose - Volumen de Credenciales
El archivo `docker-compose.yml` DEBE incluir el volumen de credenciales:
```yaml
services:
  backend:
    volumes:
      - ./backend:/code
      - /Users/pepo/.config/gcloud:/root/.config/gcloud:ro  # CRÍTICO
```

#### 3. Variables de Entorno (.env)
```bash
# Embedding Configuration
EMBEDDING_MODEL="vertexai"           # Usa Vertex AI
GEMINI_ENABLED=True                  # Habilita Gemini
GOOGLE_CLOUD_PROJECT="llm-graph-builder-pepo-2025"
GOOGLE_APPLICATION_CREDENTIALS="/root/.config/gcloud/application_default_credentials.json"
```

### 🐛 Errores Comunes y Soluciones

#### Error: "GoogleAuthError: Unable to find your project"
**Causas**:
1. Falta el volumen de gcloud en docker-compose
2. No se ejecutó `gcloud auth application-default login`
3. Variable GOOGLE_CLOUD_PROJECT no configurada

**Solución**:
```bash
# 1. Verificar credenciales
ls ~/.config/gcloud/application_default_credentials.json

# 2. Recrear contenedor con volumen
docker-compose -p llm-production down
docker-compose -p llm-production up -d
```

### 📝 TODOs para Mejorar

1. **[HIGH] Crear script de setup automático**
   ```bash
   # setup-gcloud.sh
   #!/bin/bash
   gcloud auth application-default login
   gcloud config set project llm-graph-builder-pepo-2025
   echo "✅ Google Cloud configurado"
   ```

2. **[MEDIUM] Modo fallback sin Vertex AI**
   - Detectar falta de credenciales y usar embeddings locales
   - Agregar variable `VERTEX_AI_FALLBACK=true`

3. **[MEDIUM] Validación en startup**
   - Verificar credenciales antes de iniciar workers
   - Mensaje claro si faltan credenciales

4. **[LOW] Documentar otros providers**
   - OpenAI embeddings como alternativa
   - Configuración para Azure/AWS

5. **[HIGH] Mejorar docker-compose.yml**
   ```yaml
   # Hacer el path dinámico
   volumes:
     - ~/.config/gcloud:/root/.config/gcloud:ro
   ```

### 🔍 Verificación de Funcionamiento

```bash
# 1. Verificar backend health
curl http://localhost:8000/health

# 2. Verificar logs sin errores de Google Auth
docker-compose -p llm-production logs backend | grep -i "error"

# 3. Test de embeddings
curl -X POST http://localhost:8000/embed \
  -H "Content-Type: application/json" \
  -d '{"text": "test embedding"}'
```

### 🚨 Notas de Seguridad

- **NUNCA** commitear archivos de credenciales
- **NUNCA** hardcodear paths absolutos en producción
- **SIEMPRE** usar variables de entorno para configuración sensible

### 📚 Referencias

- [Vertex AI Authentication](https://cloud.google.com/vertex-ai/docs/authentication)
- [Application Default Credentials](https://cloud.google.com/docs/authentication/application-default-credentials)
- [LangChain Vertex AI Integration](https://python.langchain.com/docs/integrations/text_embedding/google_vertex_ai)