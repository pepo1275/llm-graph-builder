#!/bin/bash
# Test script para verificar variables LLM_MODEL_CONFIG

echo "🔍 Testing LLM Variables Configuration"
echo "======================================"

# Variables esperadas del .env
EXPECTED_VARS=(
    "LLM_MODEL_CONFIG_openai_gpt_4o"
    "LLM_MODEL_CONFIG_openai_gpt_4o_mini"
    "LLM_MODEL_CONFIG_openai_gpt_4_1"
    "LLM_MODEL_CONFIG_openai_gpt_4_1_mini"
    "LLM_MODEL_CONFIG_openai_gpt_4_1_nano"
    "LLM_MODEL_CONFIG_openai_o3"
    "LLM_MODEL_CONFIG_openai_o3_pro"
    "LLM_MODEL_CONFIG_openai_o4_mini"
    "LLM_MODEL_CONFIG_openai_gpt_4_5"
    "LLM_MODEL_CONFIG_anthropic_claude_4_opus"
    "LLM_MODEL_CONFIG_anthropic_claude_3_7_sonnet"
    "LLM_MODEL_CONFIG_anthropic_claude_sonnet_4"
    "LLM_MODEL_CONFIG_gemini_2_5_pro"
    "LLM_MODEL_CONFIG_gemini_2_5_flash"
)

echo "1. Verificando variables en .env local:"
echo "---------------------------------------"
missing_in_env=0
for var in "${EXPECTED_VARS[@]}"; do
    if grep -q "^${var}=" .env; then
        echo "✅ $var: $(grep "^${var}=" .env | cut -d'=' -f2)"
    else
        echo "❌ $var: NO ENCONTRADA"
        missing_in_env=$((missing_in_env + 1))
    fi
done

echo ""
echo "2. Verificando variables en contenedor backend:"
echo "----------------------------------------------"
missing_in_container=0
for var in "${EXPECTED_VARS[@]}"; do
    value=$(docker-compose exec -T backend bash -c "echo \$${var}" 2>/dev/null || echo "ERROR")
    if [ "$value" != "" ] && [ "$value" != "ERROR" ]; then
        echo "✅ $var: $value"
    else
        echo "❌ $var: NO DISPONIBLE EN CONTENEDOR"
        missing_in_container=$((missing_in_container + 1))
    fi
done

echo ""
echo "3. Resumen:"
echo "----------"
echo "Variables faltantes en .env: $missing_in_env"
echo "Variables faltantes en contenedor: $missing_in_container"

if [ $missing_in_container -eq 0 ]; then
    echo "✅ TODAS LAS VARIABLES ESTÁN DISPONIBLES EN EL CONTENEDOR"
    exit 0
else
    echo "❌ FALTAN $missing_in_container VARIABLES EN EL CONTENEDOR"
    echo "💡 Necesario agregar las variables al docker-compose.yml"
    exit 1
fi