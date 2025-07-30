#!/bin/bash
# Test de Integración: Embedding Dimension Consistency
# Purpose: Validar funcionamiento real tras aplicar fixes
# Requiere: Docker running con el sistema

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🧪 TEST INTEGRACIÓN: Validación de Dimensiones en Runtime"
echo "=========================================================="

# Test 1: Verificar que el backend puede iniciarse
echo -e "\n📊 TEST 1: Backend Health Check"
echo "--------------------------------"

HEALTH_RESPONSE=$(curl -s http://localhost:8000/health 2>/dev/null)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend respondiendo en localhost:8000${NC}"
    echo "Response: $HEALTH_RESPONSE"
else
    echo -e "${RED}✗ Backend no disponible en localhost:8000${NC}"
    echo "Asegúrate de ejecutar: docker-compose up -d"
    exit 1
fi

# Test 2: Verificar configuración de embeddings
echo -e "\n📊 TEST 2: Configuración de Embeddings via API"
echo "---------------------------------------------"

# Este endpoint necesitaría ser implementado para testing
# Por ahora simulamos con variables de entorno
if docker exec backend env | grep -q "EMBEDDING_MODEL=vertexai"; then
    echo -e "${GREEN}✓ EMBEDDING_MODEL=vertexai configurado${NC}"
    EXPECTED_DIM=3072
else
    echo -e "${YELLOW}⚠ EMBEDDING_MODEL no es vertexai${NC}"
    EXPECTED_DIM=384
fi

# Test 3: Simular creación de índices (requeriría Neo4j)
echo -e "\n📊 TEST 3: Simulación de Creación de Índices"
echo "------------------------------------------"

echo "Verificando que las dimensiones se propagarían correctamente:"
echo "• Modelo configurado: vertexai (gemini-embedding-001)"
echo "• Dimensión esperada en índices: $EXPECTED_DIM"
echo "• Dimensión actual en código: 384 (hardcoded)"

if [ "$EXPECTED_DIM" -eq 384 ]; then
    echo -e "${GREEN}✓ No habría mismatch con configuración actual${NC}"
else
    echo -e "${RED}✗ DIMENSION MISMATCH: $EXPECTED_DIM != 384${NC}"
fi

# Test 4: Verificar logs de errores
echo -e "\n📊 TEST 4: Análisis de Logs de Errores"
echo "--------------------------------------"

ERROR_COUNT=$(docker logs backend 2>&1 | grep -c "dimension" | head -10)
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠ Se encontraron $ERROR_COUNT menciones de 'dimension' en logs${NC}"
    echo "Últimas líneas relevantes:"
    docker logs backend 2>&1 | grep -i "dimension" | tail -5
else
    echo -e "${GREEN}✓ No se encontraron errores de dimensión en logs${NC}"
fi

# Test 5: Test funcional con documento de prueba
echo -e "\n📊 TEST 5: Test Funcional (Simulado)"
echo "------------------------------------"

cat > test_embedding_payload.json << EOF
{
  "model": "vertexai",
  "text": "Test de embeddings con Gemini",
  "expected_dimension": 3072
}
EOF

echo "Payload de prueba creado:"
echo "• Modelo: vertexai (gemini-embedding-001)"
echo "• Dimensión esperada: 3072"
echo "• Estado actual: Fallaría con 'dimension mismatch'"

# Summary
echo -e "\n=========================================================="
echo "📋 RESUMEN TEST DE INTEGRACIÓN:"
echo "=========================================================="

echo -e "\n🎯 COMPORTAMIENTO ESPERADO TRAS FIX:"
echo "1. ✅ Backend debe iniciar sin errores"
echo "2. ✅ Dimensiones deben coincidir con modelo configurado"
echo "3. ✅ Índices Neo4j deben crearse con dimensión correcta"
echo "4. ✅ No debe haber 'dimension mismatch' errors"
echo "5. ✅ Post-processing debe funcionar correctamente"

echo -e "\n⚠️  NOTA: Este test requiere sistema completo running"
echo "Ejecutar después de aplicar fixes con: docker-compose up --build"

# Cleanup
rm -f test_embedding_payload.json