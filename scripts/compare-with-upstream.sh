#!/bin/bash
# Script para comparar cambios locales con upstream original

echo "🔍 Analizando diferencias con neo4j-labs/llm-graph-builder..."

# Actualizar upstream
git fetch upstream

echo "📊 ARCHIVOS MODIFICADOS vs upstream/main:"
git diff --name-only upstream/main HEAD

echo ""
echo "📝 ARCHIVOS NUEVOS (solo en tu version):"
git ls-files --others --exclude-standard

echo ""
echo "🔧 CAMBIOS EN .env vs original:"
if [ -f "example.env.ORIGINAL_REPO" ]; then
    echo "Comparando con ejemplo original guardado..."
    diff -u example.env.ORIGINAL_REPO .env || echo "Diferencias encontradas ✅"
else
    echo "⚠️ Archivo original no encontrado"
fi

echo ""
echo "📈 ESTADÍSTICAS:"
echo "Commits ahead of upstream: $(git rev-list --count upstream/main..HEAD)"
echo "Files changed: $(git diff --name-only upstream/main HEAD | wc -l)"
echo "Lines added: $(git diff --shortstat upstream/main HEAD | grep -o '[0-9]* insertion' | cut -d' ' -f1)"
echo "Lines deleted: $(git diff --shortstat upstream/main HEAD | grep -o '[0-9]* deletion' | cut -d' ' -f1)"

echo ""
echo "🎯 RECOMENDACIONES:"
echo "1. Commits para contribuir back: Bugfixes generales"
echo "2. Commits para mantener privados: Configuración personal, APIs"
echo "3. Features experimentales: Evaluar si son útiles para upstream"
