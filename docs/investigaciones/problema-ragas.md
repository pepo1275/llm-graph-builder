# Análisis del Problema con Evaluación RAGAS

**Fecha:** 29 Julio 2025  
**Estado:** Investigación completada, solución pendiente de implementar

## 🎯 **Problema Identificado**

Los modelos LLM configurados muestran el error "LLM Model Not Supported" en la evaluación RAGAS, incluso cuando el nombre del modelo aparece en la lista de modelos soportados.

### Ejemplo del Error:
```
Retrieval information: model Gemini 2.5 pro
LLM Model Not Supported, Please Choose Different Model
Currently ragas evaluation works on: [..., Gemini 2.5 pro, ...]
```

## 🔍 **Investigación Realizada**

### Test de Mapeo de Modelos
Creamos un test que reveló el problema exacto:

```bash
# Test ejecutado en contenedor backend:
🔍 Test de Mapeo de Modelos para RAGAS
==================================================
openai_gpt_4o: 'gpt-4o' → ❌ NOT SUPPORTED
openai_gpt_4o_mini: 'gpt-4o-mini' → ❌ NOT SUPPORTED
openai_gpt_4_1: 'gpt-4.1' → ❌ NOT SUPPORTED
openai_gpt_4_1_mini: 'gpt-4.1-mini' → ❌ NOT SUPPORTED
openai_o3: 'o3' → ❌ NOT SUPPORTED
anthropic_claude_sonnet_4: 'claude-sonnet-4' → ❌ NOT SUPPORTED
anthropic_claude_3_7_sonnet: 'claude-3.7-sonnet' → ❌ NOT SUPPORTED
gemini_2_5_pro: 'Gemini 2.5 pro' → ✅ SUPPORTED
gemini_2_5_flash: 'gemini-2.0-flash-exp' → ❌ NOT SUPPORTED
```

## 🛠 **Análisis Técnico**

### Flujo de Nombres de Modelos:

1. **Frontend** → Envía nombre interno (ej: `gemini_2_5_pro`)
2. **Backend `get_llm()`** → Convierte a `model_name` según tipo:
   - **OpenAI/Anthropic**: Toma parte antes de coma en `.env`
   - **Gemini**: Toma valor completo del `.env`
3. **RAGAS** → Compara `model_name` con su lista interna

### Código Relevante:
```python
# En src/llm.py líneas 34-52
if "gemini" in model:
    model_name = env_value  # Usa todo el valor
elif "openai" in model:
    model_name, api_key = env_value.split(",")  # Usa solo primera parte
```

### Configuración Actual vs Requerida:

| Modelo | Configuración Actual | Nombre en get_llm() | RAGAS Espera | Estado |
|--------|---------------------|-------------------|-------------|---------|
| `openai_gpt_4o` | `"gpt-4o,${OPENAI_API_KEY}"` | `gpt-4o` | `Openai gpt 4o` | ❌ |
| `openai_gpt_4o_mini` | `"gpt-4o-mini,${OPENAI_API_KEY}"` | `gpt-4o-mini` | `Openai gpt 4o mini` | ❌ |
| `openai_gpt_4_1` | `"gpt-4.1,${OPENAI_API_KEY}"` | `gpt-4.1` | `Openai gpt 4.1` | ❌ |
| `openai_gpt_4_1_mini` | `"gpt-4.1-mini,${OPENAI_API_KEY}"` | `gpt-4.1-mini` | `Openai gpt 4.1 mini` | ❌ |
| `openai_o3` | `"o3,${OPENAI_API_KEY}"` | `o3` | `Openai gpt o3 mini` | ❌ |
| `anthropic_claude_sonnet_4` | `"claude-sonnet-4,${ANTHROPIC_API_KEY}"` | `claude-sonnet-4` | `Anthropic claude 4 sonnet` | ❌ |
| `gemini_2_5_pro` | `"Gemini 2.5 pro"` | `Gemini 2.5 pro` | `Gemini 2.5 pro` | ✅ |
| `gemini_2_5_flash` | `"gemini-2.0-flash-exp"` | `gemini-2.0-flash-exp` | `Gemini 2.0 flash` | ❌ |

## 🎯 **Solución Propuesta**

### Estrategia: Ajustar Configuración .env

Cambiar los valores en `.env` para que la primera parte (antes de la coma) coincida exactamente con lo que espera RAGAS:

```bash
# CAMBIOS REQUERIDOS:

# OpenAI Models
LLM_MODEL_CONFIG_openai_gpt_4o="Openai gpt 4o,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4o_mini="Openai gpt 4o mini,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4_1="Openai gpt 4.1,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_gpt_4_1_mini="Openai gpt 4.1 mini,${OPENAI_API_KEY}"
LLM_MODEL_CONFIG_openai_o3="Openai gpt o3 mini,${OPENAI_API_KEY}"

# Anthropic Models  
LLM_MODEL_CONFIG_anthropic_claude_sonnet_4="Anthropic claude 4 sonnet,${ANTHROPIC_API_KEY}"

# Gemini Models (ajustar el flash)
LLM_MODEL_CONFIG_gemini_2_5_flash="Gemini 2.0 flash"
```

### Implementación:
1. **Backup del .env actual**
2. **Aplicar cambios uno por uno**
3. **Test after each change**: Verificar que el modelo funcione
4. **Rebuild backend**: Aplicar nuevas variables
5. **Rebuild frontend**: Si es necesario
6. **Verificar evaluación RAGAS**: Para cada modelo

## ⚠️ **Riesgos y Consideraciones**

### Posibles Problemas:
1. **Nombres no técnicos**: Los LLM providers podrían no reconocer nombres como "Openai gpt 4o"
2. **Compatibilidad**: Otros sistemas que dependan de nombres estándar
3. **Actualizaciones**: Cambios en lista de RAGAS requieren ajustes manuales

### Plan de Contingencia:
- Mantener backups de configuraciones funcionales
- Test progresivo (uno por uno, no todos a la vez)
- Rollback inmediato si algún modelo deja de funcionar

## 📋 **Próximos Pasos Recomendados**

### Fase 1: Verificación Individual
1. **Test con un modelo**: Empezar con `openai_gpt_4o`
2. **Cambiar solo esa configuración**: `"Openai gpt 4o,${OPENAI_API_KEY}"`
3. **Restart backend**
4. **Probar chat + evaluación RAGAS**
5. **Si funciona**: Continúar con siguiente modelo

### Fase 2: Implementación Completa
1. **Aplicar todos los cambios** si el test individual funciona
2. **Rebuild completo** (backend + frontend)
3. **Test sistemático** de todos los modelos
4. **Documentar resultados**

### Fase 3: Monitoreo
1. **Verificar estabilidad** en el tiempo
2. **Monitorear actualizaciones de RAGAS**
3. **Mantener mapeo actualizado**

## 🛑 **Estado Actual: PAUSADO**

**Razón:** Priorizar resolución del problema de nodos Document/Chunk (0 tokens)

**Para retomar:**
1. Resolver problema de datos en Neo4j
2. Volver a este análisis
3. Implementar solución de RAGAS

---

**Archivos relacionados:**
- `/Users/pepo/Dev/llm-graph-builder/.env` (configuración modelos)
- `/Users/pepo/Dev/llm-graph-builder/backend/src/llm.py` (función get_llm)
- `/Users/pepo/Dev/llm-graph-builder/backend/src/ragas_eval.py` (evaluación)
- `/Users/pepo/Dev/llm-graph-builder/test-ragas-mapping.py` (test creado)

**Comando test:**
```bash
docker-compose exec backend python -c "[script de test]"
```