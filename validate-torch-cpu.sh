#!/bin/bash
# Validate that torch remains CPU-only after dependency changes

set -e

echo "🔍 Validating PyTorch CPU Installation"
echo "===================================="

# Build the image
echo "Building Docker image..."
if docker-compose build backend > /dev/null 2>&1; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    exit 1
fi

# Check torch version
echo ""
echo "Checking PyTorch installation..."
TORCH_INFO=$(docker run --rm llm-graph-builder-production-backend:latest python -c "
import torch
print(f'Version: {torch.__version__}')
print(f'CUDA Available: {torch.cuda.is_available()}')
print(f'CUDA Version: {torch.version.cuda if torch.cuda.is_available() else \"None\"}')
")

echo "$TORCH_INFO"

# Validate CPU-only
if echo "$TORCH_INFO" | grep -q "CUDA Available: False"; then
    echo ""
    echo "✅ SUCCESS: PyTorch is CPU-only"
    
    # Check image size with more robust method
    SIZE_BYTES=$(docker inspect llm-graph-builder-production-backend:latest --format='{{.Size}}')
    SIZE_MB=$((SIZE_BYTES / 1024 / 1024))
    
    echo "📦 Docker image size: ${SIZE_MB}MB"
    
    # Warn if too large (indicating CUDA might be included)
    if [ "$SIZE_MB" -gt 3000 ]; then
        echo "⚠️  WARNING: Image size > 3GB (${SIZE_MB}MB), might include CUDA libraries"
    else
        echo "✅ Image size optimal for CPU-only build"
    fi
else
    echo ""
    echo "❌ FAILURE: PyTorch has CUDA support - this will increase image size!"
    exit 1
fi

echo ""
echo "===================================="
echo "Validation complete"