#!/bin/bash
# Script para preparar contribuciones al repositorio upstream

echo "🚀 Preparando contribución para neo4j-labs/llm-graph-builder..."

# Verificar que estamos en una branch apropiada
current_branch=$(git branch --show-current)
if [[ $current_branch != contrib/* ]]; then
    echo "⚠️ Se recomienda usar una branch contrib/* para contribuciones"
    echo "Ejemplo: git checkout -b contrib/fix-entity-embedding"
    read -p "¿Continuar en $current_branch? (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        exit 1
    fi
fi

echo ""
echo "✅ CHECKLIST PRE-CONTRIBUCIÓN:"
echo "□ Código limpio sin configuraciones personales"
echo "□ Sin API keys o credenciales hardcodeadas"
echo "□ Tests pasan (si aplica)"
echo "□ Documentación actualizada"
echo "□ Commit messages claros y descriptivos"
echo "□ Un solo fix/feature por PR"

echo ""
read -p "¿Todos los checks están OK? (y/N): " ready

if [[ $ready == [yY] ]]; then
    echo ""
    echo "🎯 PASOS PARA CREAR PR:"
    echo "1. Push tu branch: git push origin $current_branch"
    echo "2. Ve a https://github.com/neo4j-labs/llm-graph-builder"
    echo "3. Crea PR desde tu fork"
    echo "4. Describe claramente el problema y la solución"
    echo "5. Enlaza issues relacionados si existen"
    echo ""
    echo "📝 TEMPLATE PR DESCRIPTION:"
    echo "## Problem"
    echo "Brief description of the issue being fixed"
    echo ""
    echo "## Solution"  
    echo "How this PR addresses the problem"
    echo ""
    echo "## Testing"
    echo "How to verify the fix works"
    echo ""
    echo "## Breaking Changes"
    echo "Any breaking changes (hopefully none)"
else
    echo "❌ Completa el checklist antes de contribuir"
fi
