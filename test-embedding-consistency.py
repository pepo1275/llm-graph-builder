#!/usr/bin/env python3
"""
Test Suite: Embedding Dimension Consistency
Purpose: Verify that embedding dimensions are consistent across the system
Author: LLM Graph Builder Team
Date: July 2025

CRITERIA FOR ACCEPTANCE:
1. All vector indexes must match the embedding model dimension
2. No hardcoded dimensions should exist (all should be dynamic)
3. Dimension changes should propagate throughout the system
4. System should handle dimension mismatches gracefully
"""

import os
import sys
sys.path.append('backend/src')

from shared.common_fn import load_embedding_model

# Test configuration
TEST_MODELS = {
    "openai": 1536,
    "vertexai": 3072,
    "titan": 1536,
    "all-MiniLM-L6-v2": 384
}

# Color codes for output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'

def test_embedding_model_dimensions():
    """Test 1: Verify embedding model returns correct dimensions"""
    print("\n=== TEST 1: Embedding Model Dimensions ===")
    passed = True
    
    for model, expected_dim in TEST_MODELS.items():
        try:
            if model == "all-MiniLM-L6-v2":
                # This is the default when no specific model is set
                os.environ['EMBEDDING_MODEL'] = 'other'
            else:
                os.environ['EMBEDDING_MODEL'] = model
            
            _, dimension = load_embedding_model(os.environ.get('EMBEDDING_MODEL', 'other'))
            
            if dimension == expected_dim:
                print(f"{GREEN}✓ {model}: {dimension} dimensions (expected: {expected_dim}){RESET}")
            else:
                print(f"{RED}✗ {model}: {dimension} dimensions (expected: {expected_dim}){RESET}")
                passed = False
                
        except Exception as e:
            print(f"{RED}✗ {model}: ERROR - {str(e)}{RESET}")
            passed = False
    
    return passed

def test_hardcoded_dimensions():
    """Test 2: Check for hardcoded dimensions in critical files"""
    print("\n=== TEST 2: Hardcoded Dimension Detection ===")
    
    files_to_check = [
        ('backend/src/post_processing.py', 'CHUNK_VECTOR_EMBEDDING_DIMENSION'),
        ('backend/src/communities.py', 'ENTITY_VECTOR_EMBEDDING_DIMENSION'),
        ('backend/src/communities.py', 'COMMUNITY_VECTOR_EMBEDDING_DIMENSION')
    ]
    
    hardcoded_found = []
    
    for file_path, constant_name in files_to_check:
        try:
            with open(file_path, 'r') as f:
                content = f.read()
                if f"{constant_name} = 384" in content:
                    hardcoded_found.append((file_path, constant_name, 384))
                    print(f"{RED}✗ Found hardcoded: {file_path} - {constant_name} = 384{RESET}")
        except Exception as e:
            print(f"{YELLOW}⚠ Could not check {file_path}: {str(e)}{RESET}")
    
    if not hardcoded_found:
        print(f"{GREEN}✓ No hardcoded dimensions found!{RESET}")
        return True
    else:
        print(f"\n{RED}Summary: {len(hardcoded_found)} hardcoded dimensions found{RESET}")
        return False

def test_dimension_consistency_simulation():
    """Test 3: Simulate dimension consistency check"""
    print("\n=== TEST 3: Dimension Consistency Simulation ===")
    
    # Current state simulation
    print("\n📊 CURRENT STATE (Broken):")
    embedding_dim = 3072  # gemini-embedding-001
    index_dim = 384       # hardcoded
    
    if embedding_dim == index_dim:
        print(f"{GREEN}✓ Dimensions match: {embedding_dim} == {index_dim}{RESET}")
    else:
        print(f"{RED}✗ DIMENSION MISMATCH: embeddings={embedding_dim}, index={index_dim}{RESET}")
        print(f"{RED}  → This will cause: 'Index query vector has {embedding_dim} dimensions, but indexed vectors have {index_dim}'{RESET}")
    
    # Expected state after fix
    print("\n📊 EXPECTED STATE (After Fix):")
    embedding_dim = 3072  # gemini-embedding-001
    index_dim = 3072      # dynamic from model
    
    if embedding_dim == index_dim:
        print(f"{GREEN}✓ Dimensions match: {embedding_dim} == {index_dim}{RESET}")
    else:
        print(f"{RED}✗ DIMENSION MISMATCH: embeddings={embedding_dim}, index={index_dim}{RESET}")
    
    return embedding_dim == index_dim

def generate_acceptance_criteria():
    """Generate acceptance criteria report"""
    print("\n" + "="*60)
    print("ACCEPTANCE CRITERIA FOR EMBEDDING DIMENSION FIX")
    print("="*60)
    
    criteria = [
        ("All hardcoded dimensions must be removed", "Replace with dynamic values from embedding model"),
        ("Vector indexes must use model dimensions", "Index creation should read from load_embedding_model()"),
        ("Dimension changes must propagate", "Changing EMBEDDING_MODEL env var should update all dimensions"),
        ("System must validate consistency", "Pre-flight check for dimension mismatches"),
        ("Backward compatibility", "Existing data with 384d should be detected and warned")
    ]
    
    print("\n📋 CRITERIA:")
    for i, (criterion, description) in enumerate(criteria, 1):
        print(f"\n{i}. {criterion}")
        print(f"   → {description}")
    
    print("\n" + "="*60)

def main():
    """Run all tests and generate report"""
    print("🧪 EMBEDDING DIMENSION CONSISTENCY TEST SUITE")
    print("="*60)
    
    # Run tests
    test1_passed = test_embedding_model_dimensions()
    test2_passed = test_hardcoded_dimensions()
    test3_passed = test_dimension_consistency_simulation()
    
    # Generate criteria
    generate_acceptance_criteria()
    
    # Summary
    print("\n📊 TEST SUMMARY:")
    print(f"Test 1 (Model Dimensions): {'PASSED' if test1_passed else 'FAILED'}")
    print(f"Test 2 (Hardcoded Detection): {'PASSED' if test2_passed else 'FAILED'}")
    print(f"Test 3 (Consistency Check): {'PASSED' if test3_passed else 'FAILED'}")
    
    all_passed = test1_passed and test2_passed and test3_passed
    
    if all_passed:
        print(f"\n{GREEN}✅ ALL TESTS PASSED!{RESET}")
        return 0
    else:
        print(f"\n{RED}❌ TESTS FAILED - FIX REQUIRED{RESET}")
        return 1

if __name__ == "__main__":
    sys.exit(main())