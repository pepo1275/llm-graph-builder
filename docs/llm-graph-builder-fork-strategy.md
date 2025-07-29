# LLM Graph Builder - Estrategia Fork y Restructuración

## 🎯 CONTEXTO DEL PROYECTO

**Proyecto Original:** https://github.com/neo4j-labs/llm-graph-builder  
**Proyecto Actual:** `/Users/pepo/Dev/llm-graph-builder`  
**Usuario:** Pepo (macOS, macbookair_pepo_001)  
**Estado:** Modificaciones locales sobre proyecto Neo4j Labs  

### Modificaciones Realizadas:
- ✅ Configuración Google Cloud Platform + Vertex AI
- ✅ Ampliación modelos LLM (GPT-4.1, o3, Claude 4, Gemini 2.5)
- ✅ Fix crítico: ENTITY_EMBEDDING=False → True
- ✅ Optimizaciones específicas macOS
- ✅ Documentación completa en español

## 🚀 ESTRATEGIA RECOMENDADA: FORK + UPSTREAM TRACKING

### FASE 1: FORK OFICIAL Y SETUP

```bash
# 1. Fork desde GitHub
# Ve a: https://github.com/neo4j-labs/llm-graph-builder
# Click "Fork" → Crear en tu cuenta GitHub

# 2. Clonar tu fork
cd /Users/pepo/Dev
git clone https://github.com/[tu-usuario]/llm-graph-builder.git llm-graph-builder-fork

# 3. Configurar upstream (repositorio original)
cd llm-graph-builder-fork
git remote add upstream https://github.com/neo4j-labs/llm-graph-builder.git

# 4. Verificar remotes
git remote -v
# Resultado esperado:
# origin    https://github.com/[tu-usuario]/llm-graph-builder.git (fetch)
# origin    https://github.com/[tu-usuario]/llm-graph-builder.git (push)  
# upstream  https://github.com/neo4j-labs/llm-graph-builder.git (fetch)
# upstream  https://github.com/neo4j-labs/llm-graph-builder.git (push)
```

### FASE 2: MIGRAR MODIFICACIONES EXISTENTES

```bash
# Copiar archivos modificados desde proyecto actual
cp /Users/pepo/Dev/llm-graph-builder/.env llm-graph-builder-fork/.env.pepo
cp /Users/pepo/Dev/llm-graph-builder/docs/llm-graph-builder-guia-completa.md llm-graph-builder-fork/docs/

# Crear branch específico para modificaciones
git checkout -b feature/pepo-config-enhancements

# Añadir cambios
git add .
git commit -m "feat: Add Pepo's configuration enhancements

- Google Cloud Platform integration setup
- Extended LLM models support (GPT-4.1, o3, Claude 4, Gemini 2.5)
- Fixed ENTITY_EMBEDDING=True bug
- macOS specific optimizations
- Complete Spanish documentation"

# Push al fork
git push origin feature/pepo-config-enhancements
```

### FASE 3: ESTRUCTURA DE BRANCHES ESTRATÉGICA

```bash
# Branches principales
git checkout -b main                           # Tu rama principal (fork)
git checkout -b develop                        # Desarrollo activo
git checkout -b feature/pepo-config           # Configuraciones específicas
git checkout -b feature/spanish-docs          # Documentación en español
git checkout -b feature/macos-optimizations   # Optimizaciones macOS
git checkout -b hotfix/entity-embedding-fix   # Fix crítico ENTITY_EMBEDDING

# Para contribuciones upstream (Pull Requests al repo original)
git checkout -b contrib/entity-embedding-fix  # Para PR al repo original
git checkout -b contrib/model-expansion       # Para PR modelos LLM
git checkout -b contrib/google-cloud-docs     # Para PR documentación Google Cloud
```

### FASE 4: SCRIPTS DE AUTOMATIZACIÓN

#### Script: Sincronización con Upstream

```bash
# Crear directorio scripts
mkdir -p scripts

# Script para mantener sincronizado con upstream
cat > scripts/sync-upstream.sh << 'EOF'
#!/bin/bash
echo "🔄 Sincronizando con Neo4j Labs upstream..."

# Fetch upstream changes
git fetch upstream

# Switch to main y merge upstream changes
git checkout main
git merge upstream/main

# Update develop branch
git checkout develop  
git rebase main

# Push updates to your fork
git push origin main
git push origin develop

echo "✅ Sincronización completa!"
EOF

chmod +x scripts/sync-upstream.sh
```

#### Script: Setup Desarrollo Pepo

```bash
cat > scripts/setup-pepo-dev.sh << 'EOF'
#!/bin/bash
echo "🚀 Configurando entorno desarrollo Pepo..."

# Verificar dependencias
command -v docker >/dev/null 2>&1 || { echo "❌ Docker requerido"; exit 1; }
command -v gcloud >/dev/null 2>&1 || { echo "❌ Google Cloud SDK requerido"; exit 1; }

# Verificar proyecto Google Cloud
PROJECT_ID="llm-graph-builder-pepo-2025"
gcloud config set project $PROJECT_ID

# Copiar configuración específica Pepo
if [ ! -f .env ]; then
    if [ -f .env.pepo ]; then
        cp .env.pepo .env
        echo "✅ Configuración Pepo aplicada"
    else
        cp .env.template .env
        echo "⚠️  Configurar .env con tus API keys"
    fi
fi

# Verificar Neo4j sigma2
echo "🔍 Verificando Neo4j sigma2..."
if ! docker ps | grep -q sigma2; then
    echo "⚠️  Neo4j sigma2 no está corriendo"
    if docker ps -a | grep -q sigma2; then
        echo "🚀 Iniciando sigma2..."
        docker start sigma2
    else
        echo "❌ sigma2 no encontrado. Crear instancia Neo4j Desktop"
    fi
fi

# Docker compose desarrollo
echo "🐳 Iniciando servicios Docker..."
docker-compose up --build -d

echo "✅ Entorno desarrollo Pepo listo!"
echo "🌐 Frontend: http://localhost:8080"
echo "🤖 Backend: http://localhost:8000"
echo "📊 Neo4j: http://localhost:8691"
EOF

chmod +x scripts/setup-pepo-dev.sh
```

#### Script: Deploy Pepo

```bash
cat > scripts/deploy-pepo.sh << 'EOF'
#!/bin/bash
echo "🚀 Desplegando LLM Graph Builder (Pepo Config)..."

# Verificar configuración
if [ ! -f .env.pepo ]; then
    echo "❌ .env.pepo no encontrado"
    exit 1
fi

# Copiar configuración de producción
cp .env.pepo .env

# Rebuild servicios
echo "🔨 Reconstruyendo servicios..."
docker-compose down
docker-compose up --build -d

# Health checks
echo "🔍 Verificando servicios..."
sleep 10

# Backend health
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Backend operativo"
else
    echo "❌ Backend no responde"
fi

# Frontend health  
if curl -f http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Frontend operativo"
else
    echo "❌ Frontend no responde"
fi

# Neo4j health
if curl -f http://localhost:8691 > /dev/null 2>&1; then
    echo "✅ Neo4j operativo"
else
    echo "❌ Neo4j no responde"
fi

echo "🎯 Deploy completado!"
EOF

chmod +x scripts/deploy-pepo.sh
```

### FASE 5: ESTRUCTURA DE ARCHIVOS RECOMENDADA

```bash
# Crear estructura de directorios
mkdir -p configs/pepo
mkdir -p docs/spanish
mkdir -p scripts
mkdir -p .github/workflows

# Estructura final:
# llm-graph-builder-fork/
# ├── .env.template                    # Template del proyecto original
# ├── .env.pepo                       # Tu configuración específica
# ├── configs/
# │   ├── pepo/                       # Configuraciones específicas
# │   │   ├── .env.development
# │   │   ├── .env.production
# │   │   └── docker-compose.pepo.yml
# ├── docs/
# │   ├── README.md                   # Original del proyecto
# │   ├── spanish/                    # Documentación en español
# │   │   └── guia-completa.md
# │   └── PEPO_MODIFICATIONS.md       # Documento con cambios
# ├── scripts/
# │   ├── sync-upstream.sh            # Sincronización con upstream
# │   ├── setup-pepo-dev.sh          # Setup específico
# │   └── deploy-pepo.sh             # Deploy personalizado
# └── .github/
#     └── workflows/
#         └── ci-pepo.yml             # CI/CD personalizado
```

### FASE 6: CONFIGURACIONES POR ENTORNO

#### Configuración Desarrollo (.env.development)

```bash
cat > configs/pepo/.env.development << 'EOF'
# LLM Graph Builder - Pepo Development Configuration

# Neo4j Configuration - COMENTADO PARA UI CONFIG
# NEO4J_URI=bolt://host.docker.internal:7691
# NEO4J_USERNAME=neo4j
# NEO4J_PASSWORD=desktop_test

# LLM Configuration - DEVELOPMENT
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here

# Modelos LLM 2025 - EXPANDED
LLM_MODELS=gpt-4.1,gpt-4.1-mini,gpt-4.1-nano,gpt-4o,gpt-4o-mini,o3,o3-pro,o4-mini,gpt-4.5,claude-4-opus,claude-3.7-sonnet,claude-sonnet-4,gemini-2.5-pro,gemini-2.5-flash

# Embedding Configuration - BUG CRÍTICO CORREGIDO
EMBEDDING_MODEL="all-MiniLM-L6-v2"
IS_EMBEDDING="true"
ENTITY_EMBEDDING=True  # ⚠️ CRÍTICO: Era False, corregido a True

# Frontend Configuration
VITE_BACKEND_API_URL="http://localhost:8000"
VITE_LLM_MODELS_PROD="openai_gpt_4o,openai_gpt_4o_mini,openai_gpt_4_1,openai_gpt_4_1_mini,openai_o3,openai_o4_mini,gemini_2_5_pro,gemini_2_5_flash,anthropic_claude_sonnet_4"
VITE_ENV="DEV"
VITE_SKIP_AUTH=true

# Google Cloud Configuration
GOOGLE_CLOUD_PROJECT="llm-graph-builder-pepo-2025"
GOOGLE_APPLICATION_CREDENTIALS="/root/.config/gcloud/application_default_credentials.json"
EOF
```

#### Docker Compose Pepo

```bash
cat > configs/pepo/docker-compose.pepo.yml << 'EOF'
version: '3.8'

services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - ENV_FILE=configs/pepo/.env.development
    volumes:
      - ./configs/pepo/.env.development:/app/.env
    depends_on:
      - neo4j

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    environment:
      - VITE_BACKEND_API_URL=http://localhost:8000
      - VITE_LLM_MODELS_PROD=openai_gpt_4o,openai_gpt_4_1,gemini_2_5_pro,anthropic_claude_sonnet_4
    depends_on:
      - backend

volumes:
  neo4j_data:
  neo4j_logs:
EOF
```

### FASE 7: CI/CD PARA TU FORK

```yaml
# .github/workflows/ci-pepo.yml
name: CI/CD Pepo LLM Graph Builder

on:
  push:
    branches: [ main, develop, feature/* ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Docker
      uses: docker/setup-buildx-action@v3
    
    - name: Copy Pepo config
      run: |
        cp configs/pepo/.env.development .env
        
    - name: Build services
      run: |
        docker-compose -f configs/pepo/docker-compose.pepo.yml build
        
    - name: Run tests
      run: |
        docker-compose -f configs/pepo/docker-compose.pepo.yml up -d
        sleep 30
        
        # Health checks
        curl -f http://localhost:8000/health || exit 1
        curl -f http://localhost:8080 || exit 1
        
    - name: Cleanup
      run: |
        docker-compose -f configs/pepo/docker-compose.pepo.yml down

  sync-upstream:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        fetch-depth: 0
        
    - name: Configure Git
      run: |
        git config user.name "github-actions[bot]"
        git config user.email "github-actions[bot]@users.noreply.github.com"
        
    - name: Add upstream remote
      run: |
        git remote add upstream https://github.com/neo4j-labs/llm-graph-builder.git
        
    - name: Sync upstream
      run: |
        ./scripts/sync-upstream.sh
```

### FASE 8: DOCUMENTACIÓN MODIFICACIONES

```bash
cat > PEPO_MODIFICATIONS.md << 'EOF'
# Modificaciones Pepo - LLM Graph Builder

## 🎯 Resumen de Cambios

Esta es una lista completa de las modificaciones realizadas sobre el proyecto original de Neo4j Labs.

### 🐛 Fixes Críticos

1. **ENTITY_EMBEDDING Bug Fix**
   - **Archivo:** `.env`
   - **Cambio:** `ENTITY_EMBEDDING=False` → `ENTITY_EMBEDDING=True`
   - **Impacto:** Habilita embeddings de entidades para mejor GraphRAG
   - **Estado:** ✅ Candidato para PR upstream

### 🚀 Nuevas Features

2. **Expansión Modelos LLM**
   - **Archivos:** `.env`, frontend config
   - **Nuevos modelos:** GPT-4.1, o3, o4-mini, Claude 4, Gemini 2.5 Pro/Flash
   - **Impacto:** 10+ modelos LLM disponibles vs 4 originales
   - **Estado:** ✅ Candidato para PR upstream

3. **Integración Google Cloud Platform**
   - **Archivos:** `.env`, docs
   - **Features:** Vertex AI, Gemini models, configuración GCP completa
   - **Impacto:** Acceso a modelos Google Gemini via Vertex AI
   - **Estado:** ✅ Candidato para PR upstream (documentación)

### 🖥️ Optimizaciones macOS

4. **Configuración específica macOS**
   - **Archivos:** Scripts, documentación
   - **Features:** Comandos optimizados para zsh, Homebrew, paths macOS
   - **Impacto:** Setup más sencillo en macOS
   - **Estado:** ✅ Candidato para PR upstream

### 📚 Documentación

5. **Documentación completa en español**
   - **Archivo:** `docs/llm-graph-builder-guia-completa.md`
   - **Contenido:** Guía paso a paso, troubleshooting, configuración avanzada
   - **Impacto:** 566 líneas de documentación técnica detallada
   - **Estado:** ❓ Evaluar para PR upstream (traducción vs versión inglés)

### 🔧 Configuraciones Específicas

6. **APIs Keys y configuración personal**
   - **Archivos:** `.env.pepo`, configs específicos
   - **Contenido:** Configuración Google Cloud proyecto específico
   - **Estado:** ❌ NO para upstream (configuración personal)

## 🎯 Estrategia Contribución Upstream

### Candidatos para Pull Request:

1. **Fix ENTITY_EMBEDDING** - PR inmediato
2. **Expansión modelos LLM** - PR con testing
3. **Documentación Google Cloud** - PR traducida al inglés
4. **Optimizaciones macOS** - PR con scripts multiplataforma

### NO Candidatos:

- Configuraciones API keys específicas
- Documentación personal/específica
- Setup específico Pepo

## 📋 Checklist Próximos Pasos

- [ ] Crear PR para fix ENTITY_EMBEDDING
- [ ] Documentar expansión modelos LLM en inglés
- [ ] Crear guía Google Cloud en inglés
- [ ] Testing exhaustivo de cambios
- [ ] Validación con maintainers Neo4j Labs
EOF
```

## 🎯 WORKFLOW DE CONTRIBUCIÓN AL UPSTREAM

### Para Contribuir Fixes al Proyecto Original:

```bash
# 1. Crear branch específico para contribución
git checkout main
git pull upstream main
git checkout -b contrib/fix-entity-embedding-default

# 2. Aplicar solo el cambio específico (sin configuraciones personales)
# Editar solo .env.template o archivo de configuración por defecto
# Cambiar ENTITY_EMBEDDING=False a ENTITY_EMBEDDING=True

# 3. Commit enfocado
git add .env.template
git commit -m "fix: Set ENTITY_EMBEDDING=True as default

ENTITY_EMBEDDING was set to False by default, which disabled
entity embeddings and reduced GraphRAG performance. This fix
sets it to True to enable proper entity embedding functionality.

Fixes: Improved GraphRAG performance with entity embeddings enabled"

# 4. Push y crear PR
git push origin contrib/fix-entity-embedding-default

# 5. Ir a GitHub y crear Pull Request desde tu fork hacia neo4j-labs/llm-graph-builder
```

## 🚀 COMANDOS DE IMPLEMENTACIÓN INMEDIATA

```bash
# Implementación completa en un solo script
echo "🚀 Ejecutar estos comandos para implementar la estrategia completa:"

echo "1. Fork manual en GitHub:"
echo "   https://github.com/neo4j-labs/llm-graph-builder → Fork"

echo "2. Setup repositorio local:"
echo "   cd /Users/pepo/Dev"
echo "   git clone https://github.com/[TU-USUARIO]/llm-graph-builder.git llm-graph-builder-fork"
echo "   cd llm-graph-builder-fork"

echo "3. Ejecutar script de setup:"
echo "   curl -s [URL_ESTE_DOCUMENTO] | grep -A 1000 'setup-pepo-dev.sh' | head -50 > scripts/setup-pepo-dev.sh"
echo "   chmod +x scripts/setup-pepo-dev.sh"
echo "   ./scripts/setup-pepo-dev.sh"

echo "4. Migrar modificaciones existentes:"
echo "   cp /Users/pepo/Dev/llm-graph-builder/.env .env.pepo"
echo "   cp /Users/pepo/Dev/llm-graph-builder/docs/* docs/"

echo "✅ Estrategia lista para implementar!"
```

---

**Creado para:** Pepo - macOS Development  
**Proyecto:** LLM Graph Builder Fork Strategy  
**Origen:** Neo4j Labs upstream  
**Objetivo:** Contribución profesional + configuración personalizada