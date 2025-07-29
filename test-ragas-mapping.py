#!/usr/bin/env python3
"""
Test script para entender el mapeo de nombres de modelos en ragas
"""
import sys
import os
sys.path.append('/Users/pepo/Dev/llm-graph-builder/backend')

from src.llm import get_llm
from dotenv import load_dotenv

load_dotenv()

def test_model_mapping():
    """Test qué model_name devuelve get_llm para cada modelo configurado"""
    
    print("🔍 Test de Mapeo de Modelos para RAGAS")
    print("=" * 50)
    
    # Lista de modelos configurados según nuestro .env
    test_models = [
        "openai_gpt_4o",
        "openai_gpt_4o_mini", 
        "openai_gpt_4_1",
        "openai_gpt_4_1_mini",
        "openai_o3",
        "anthropic_claude_sonnet_4",
        "anthropic_claude_3_7_sonnet",
        "gemini_2_5_pro",
        "gemini_2_5_flash"
    ]
    
    # Lista de nombres que ragas acepta (según el mensaje de error)
    ragas_supported = [
        "Openai gpt 4",
        "Openai gpt 4o", 
        "Openai gpt 4o mini",
        "Openai gpt 4.1",
        "Openai gpt 4.1 mini",
        "Gemini 1.5 pro",
        "Gemini 1.5 flash", 
        "Gemini 2.0 flash",
        "Gemini 2.5 pro",
        "Azure ai gpt 35",
        "Azure ai gpt 4o",
        "Groq llama3 70b",
        "Anthropic claude 4 sonnet",
        "Fireworks llama4 maverick",
        "Fireworks llama4 scout", 
        "Openai gpt o3 mini",
        "Llama4 maverick",
        "Fireworks qwen3 30b",
        "Fireworks qwen3 235b"
    ]
    
    print("1. Testing current model configurations:")
    print("-" * 40)
    
    results = {}
    
    for model in test_models:
        try:
            llm, model_name = get_llm(model=model)
            results[model] = model_name
            
            # Check if model_name is supported by ragas
            supported = "✅ SUPPORTED" if model_name in ragas_supported else "❌ NOT SUPPORTED"
            
            print(f"Model: {model}")
            print(f"  → model_name: '{model_name}'")
            print(f"  → Ragas: {supported}")
            print()
            
        except Exception as e:
            print(f"Model: {model}")
            print(f"  → ERROR: {e}")
            print()
    
    print("\n2. Summary of mappings needed:")
    print("-" * 40)
    
    for model, model_name in results.items():
        if model_name not in ragas_supported:
            # Try to find a matching ragas name
            suggested = None
            model_lower = model_name.lower()
            
            for ragas_name in ragas_supported:
                if any(part in ragas_name.lower() for part in model_lower.split("-")):
                    suggested = ragas_name
                    break
            
            if suggested:
                print(f"❌ {model}: '{model_name}' → SHOULD BE: '{suggested}'")
            else:
                print(f"❌ {model}: '{model_name}' → NO RAGAS EQUIVALENT FOUND")
        else:
            print(f"✅ {model}: '{model_name}' → ALREADY CORRECT")
    
    return results

if __name__ == "__main__":
    test_model_mapping()