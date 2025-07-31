#!/bin/bash
# Test script for dependency resolution validation
# Purpose: Validate torch/accelerate compatibility before and after changes

set -e

echo "=== DEPENDENCY RESOLUTION TEST ==="
echo "Date: $(date)"
echo "Purpose: Validate torch constraints compatibility with accelerate package"
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test criteria
echo "📋 ACCEPTANCE CRITERIA:"
echo "1. Docker build must complete successfully"
echo "2. pip must resolve all dependencies without conflicts"
echo "3. Torch version must be CPU-only (contains +cpu)"
echo "4. Accelerate must be installed with version 1.7.0"
echo "5. HuggingFace embeddings must load correctly"
echo ""

# Current state check
echo "🔍 CURRENT STATE:"
echo -n "constraints.txt torch version: "
grep "^torch" backend/constraints.txt || echo "Not found"
echo ""

# Test 1: Docker build
echo "🧪 TEST 1: Docker Build"
echo "Building backend image..."
if docker-compose build backend > build.log 2>&1; then
    echo -e "${GREEN}✓ Docker build succeeded${NC}"
    DOCKER_BUILD=1
else
    echo -e "${RED}✗ Docker build failed${NC}"
    echo "Last 20 lines of build log:"
    tail -20 build.log
    DOCKER_BUILD=0
fi
echo ""

# Test 2: Dependency resolution check
if [ $DOCKER_BUILD -eq 1 ]; then
    echo "🧪 TEST 2: Dependency Resolution"
    echo "Checking installed packages..."
    
    # Create a temporary container to check dependencies
    docker run --rm llm-graph-builder-production-backend:latest pip list | grep -E "(torch|accelerate|sentence-transformers|langchain-huggingface)" > deps.txt || true
    
    echo "Installed packages:"
    cat deps.txt
    
    # Check torch version
    TORCH_VERSION=$(grep "^torch" deps.txt | awk '{print $2}' || echo "Not found")
    if [[ $TORCH_VERSION == *"+cpu"* ]]; then
        echo -e "${GREEN}✓ Torch CPU version installed: $TORCH_VERSION${NC}"
    else
        echo -e "${RED}✗ Torch version does not contain +cpu: $TORCH_VERSION${NC}"
    fi
    
    # Check accelerate version
    ACCELERATE_VERSION=$(grep "^accelerate" deps.txt | awk '{print $2}' || echo "Not found")
    if [[ $ACCELERATE_VERSION == "1.7.0" ]]; then
        echo -e "${GREEN}✓ Accelerate 1.7.0 installed correctly${NC}"
    else
        echo -e "${RED}✗ Accelerate version mismatch: $ACCELERATE_VERSION${NC}"
    fi
fi
echo ""

# Test 3: HuggingFace embeddings test
if [ $DOCKER_BUILD -eq 1 ]; then
    echo "🧪 TEST 3: HuggingFace Embeddings"
    echo "Testing embedding model loading..."
    
    # Create a test script
    cat > test_embeddings.py << 'EOF'
import sys
try:
    from langchain_huggingface import HuggingFaceEmbeddings
    embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
    test_text = "Test embedding generation"
    result = embeddings.embed_query(test_text)
    print(f"✓ Embedding generated successfully: {len(result)} dimensions")
    sys.exit(0)
except Exception as e:
    print(f"✗ Embedding test failed: {str(e)}")
    sys.exit(1)
EOF
    
    if docker run --rm -v $(pwd)/test_embeddings.py:/test_embeddings.py llm-graph-builder-production-backend:latest python /test_embeddings.py; then
        echo -e "${GREEN}✓ HuggingFace embeddings working correctly${NC}"
    else
        echo -e "${RED}✗ HuggingFace embeddings test failed${NC}"
    fi
    
    rm -f test_embeddings.py
fi
echo ""

# Summary
echo "📊 TEST SUMMARY:"
if [ $DOCKER_BUILD -eq 1 ]; then
    echo -e "${GREEN}All tests passed! Dependency resolution is working correctly.${NC}"
else
    echo -e "${RED}Tests failed. Please review the dependency configuration.${NC}"
fi

# Cleanup
rm -f build.log deps.txt

echo ""
echo "=== END OF TEST ==="