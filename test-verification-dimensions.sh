#!/bin/bash
# Test de Verificación: Embedding Dimension Consistency
# Purpose: Verificar estado actual de dimensiones hardcodeadas
# No requiere Python environment - solo bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🧪 TEST SUITE: Verificación de Dimensiones de Embeddings"
echo "========================================================"

# Test 1: Verificar dimensiones hardcodeadas
echo -e "\n📊 TEST 1: Detección de Dimensiones Hardcodeadas"
echo "------------------------------------------------"

HARDCODED_COUNT=0

# Check post_processing.py
if grep -q "CHUNK_VECTOR_EMBEDDING_DIMENSION = 384" backend/src/post_processing.py; then
    echo -e "${RED}✗ post_processing.py: CHUNK_VECTOR_EMBEDDING_DIMENSION = 384 (HARDCODED)${NC}"
    ((HARDCODED_COUNT++))
else
    echo -e "${GREEN}✓ post_processing.py: No hardcoding detected${NC}"
fi

# Check communities.py - Entity
if grep -q "ENTITY_VECTOR_EMBEDDING_DIMENSION = 384" backend/src/communities.py; then
    echo -e "${RED}✗ communities.py: ENTITY_VECTOR_EMBEDDING_DIMENSION = 384 (HARDCODED)${NC}"
    ((HARDCODED_COUNT++))
else
    echo -e "${GREEN}✓ communities.py: Entity dimension not hardcoded${NC}"
fi

# Check communities.py - Community
if grep -q "COMMUNITY_VECTOR_EMBEDDING_DIMENSION = 384" backend/src/communities.py; then
    echo -e "${RED}✗ communities.py: COMMUNITY_VECTOR_EMBEDDING_DIMENSION = 384 (HARDCODED)${NC}"
    ((HARDCODED_COUNT++))
else
    echo -e "${GREEN}✓ communities.py: Community dimension not hardcoded${NC}"
fi

# Test 2: Verificar dimensiones en common_fn.py
echo -e "\n📊 TEST 2: Configuración de Modelos de Embeddings"
echo "------------------------------------------------"

echo "Dimensiones configuradas por modelo:"
echo "• OpenAI: $(grep -A1 'openai' backend/src/shared/common_fn.py | grep 'dimension =' | head -1 | awk '{print $3}')"
echo "• VertexAI: $(grep -A5 'vertexai' backend/src/shared/common_fn.py | grep 'dimension =' | head -1 | awk '{print $3}')"
echo "• Default: $(grep -A1 'else:' backend/src/shared/common_fn.py | grep 'dimension =' | tail -1 | awk '{print $3}')"

# Test 3: Verificar queries de creación de índices
echo -e "\n📊 TEST 3: Queries de Creación de Índices Vectoriales"
echo "------------------------------------------------"

echo "Verificando uso de dimensiones en creación de índices:"
if grep -q "vector.dimensions.*embedding_dimension" backend/src/post_processing.py; then
    echo -e "${GREEN}✓ post_processing.py: Usa variable 'embedding_dimension' (DINÁMICO)${NC}"
else
    echo -e "${YELLOW}⚠ post_processing.py: Verificar si usa dimensión dinámica${NC}"
fi

if grep -q "vector.dimensions.*embedding_dimension" backend/src/communities.py; then
    echo -e "${GREEN}✓ communities.py: Usa variable 'embedding_dimension' (DINÁMICO)${NC}"
else
    echo -e "${YELLOW}⚠ communities.py: Verificar si usa dimensión dinámica${NC}"
fi

# Test 4: Scenario Analysis
echo -e "\n📊 TEST 4: Análisis de Escenario con gemini-embedding-001"
echo "--------------------------------------------------------"

echo "Escenario: Usuario configura EMBEDDING_MODEL=vertexai"
echo "• Modelo esperado: gemini-embedding-001"
echo "• Dimensión esperada: 3072"
echo "• Dimensión en índices: 384 (HARDCODED)"
echo -e "${RED}• Resultado: DIMENSION MISMATCH ERROR${NC}"
echo "• Error esperado: 'Index query vector has 3072 dimensions, but indexed vectors have 384'"

# Summary
echo -e "\n========================================================"
echo "📋 RESUMEN DE RESULTADOS:"
echo "========================================================"

if [ $HARDCODED_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ No se encontraron dimensiones hardcodeadas!${NC}"
    OVERALL_RESULT=0
else
    echo -e "${RED}❌ Se encontraron $HARDCODED_COUNT dimensiones hardcodeadas${NC}"
    echo -e "${RED}   Esto causará 'dimension mismatch' con modelos != 384 dimensiones${NC}"
    OVERALL_RESULT=1
fi

echo -e "\n📊 CRITERIOS DE ACEPTACIÓN:"
echo "1. ❌ Todas las dimensiones deben ser dinámicas (actualmente hardcodeadas)"
echo "2. ❌ Los índices deben usar dimensiones del modelo (actualmente fijas)"
echo "3. ❌ Cambios de modelo deben propagar dimensiones (actualmente no)"
echo "4. ⚠️  Sistema debe validar consistencia (no implementado)"
echo "5. ⚠️  Compatibilidad con datos existentes (no manejado)"

exit $OVERALL_RESULT