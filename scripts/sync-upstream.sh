#!/bin/bash
# Script para sincronizar con upstream y mantener fork actualizado

echo "🔄 Sincronizando con upstream neo4j-labs/llm-graph-builder..."

# Asegurar que estamos en main
git checkout main

# Fetch upstream changes
echo "📡 Obteniendo cambios de upstream..."
git fetch upstream

# Merge upstream changes into main
echo "🔀 Mergiendo cambios upstream en main..."
git merge upstream/main

# Push updated main to origin
echo "📤 Pusheando main actualizado a tu fork..."
git push origin main

echo ""
echo "✅ Sincronización completada!"
echo ""
echo "🔄 PRÓXIMOS PASOS:"
echo "1. Revisar si hay conflictos en tus branches personales"
echo "2. Rebase tus features sobre el main actualizado:"
echo "   git checkout pepo/enhanced-config"
echo "   git rebase main"
echo "3. Resolver conflictos si los hay"
echo "4. Push force si es necesario: git push --force-with-lease origin pepo/enhanced-config"
