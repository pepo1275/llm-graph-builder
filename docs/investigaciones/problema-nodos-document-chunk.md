# Análisis del Problema: Nodos Document/Chunk Faltantes

**Fecha:** 29 Julio 2025  
**Estado:** Investigación completada, múltiples opciones identificadas

## 🎯 **Problema Identificado**

El sistema LLM Graph Builder muestra "0 tokens" en las respuestas del chat y no encuentra datos para el RAG, a pesar de que la base de datos Neo4j contiene 30 nodos creados por Claude Desktop.

### Síntomas:
```
Retrieval information: utilizing 0 tokens with the model [...] in graph & vector & fulltext mode
```

## 🔍 **Investigación Realizada**

### Estado de la Base de Datos Neo4j

```bash
# Verificación en Neo4j sigma2:
docker exec sigma2 cypher-shell -u neo4j -p desktop_test

# Resultados:
MATCH (n) RETURN count(n) as total_nodes
→ 30 nodos totales ✅

MATCH (n) RETURN labels(n) as labels, count(n) as count ORDER BY count DESC
→ EjemploCodigo(4), Algoritmo(3), ComponenteFuente(2), etc. ✅

MATCH (n:Chunk) RETURN count(n) as chunks  
→ 0 chunks ❌

MATCH (n:Document) RETURN count(n) as documents
→ 0 documents ❌
```

### Análisis del Código de Búsqueda

**Consulta RAG en `constants.py`:**
```cypher
VECTOR_GRAPH_SEARCH_QUERY_PREFIX = """
WITH node as chunk, score
// find the document of the chunk
MATCH (chunk)-[:PART_OF]->(d:Document)  # ← Busca nodos Chunk conectados a Document
```

**Configuración de búsqueda:**
```python
"node_label": "Chunk",  # ← Busca específicamente nodos con label Chunk
```

## 🛠 **Análisis Técnico: Incompatibilidad de Esquemas**

### LLM Graph Builder espera esta estructura:
```
Document (archivo subido)
  ↓
Chunk (fragmentos del documento)
  ↓
Entidades extraídas (usando esquema personalizado)
```

### Tu situación actual:
```
❌ NO HAY Document
❌ NO HAY Chunk
✅ SÍ HAY Entidades (EjemploCodigo, Algoritmo, etc.)
```

### Flujo Normal de LLM Graph Builder:
1. **Usuario sube documento** → Sistema crea nodo `Document`
2. **Sistema procesa texto** → Divide en `Chunk`s conectados con `PART_OF`
3. **Sistema extrae entidades** → Usando esquema, crea entidades conectadas a `Chunk`s
4. **RAG/Chat** → Busca en `Chunk`s y sigue conexiones a entidades

### Tu flujo actual:
1. **Claude Desktop creó entidades directamente** → Sin `Document`/`Chunk` base
2. **LLM Graph Builder busca `Chunk`s** → No encuentra nada (0 tokens)
3. **No puede hacer RAG** → Sin texto base para contexto

## 💡 **Opciones de Solución Identificadas**

### Opción A: Subir Documentos a través de LLM Graph Builder
**Pros:**
- ✅ Genera automáticamente estructura `Document`/`Chunk`
- ✅ Usa tu esquema existente para extraer entidades
- ✅ Funciona inmediatamente con RAG
- ✅ Proceso estándar y soportado

**Contras:**
- ⚠️ Reabre tema de configuración de embeddings
- ⚠️ Configuración de chunking (tamaño, overlap, etc.)
- ⚠️ Puede duplicar entidades si ya existen

**Implicaciones técnicas:**
- Motor de embeddings: `all-MiniLM-L6-v2` (configurado)
- Chunking: Variables `CHUNK_SIZE`, `CHUNK_OVERLAP` en .env
- Procesamiento: `UPDATE_GRAPH_CHUNKS_PROCESSED`, `NUMBER_OF_CHUNKS_TO_COMBINE`

### Opción B: Crear nodos Document/Chunk manualmente
**Pros:**
- ✅ Conecta con entidades existentes
- ✅ Control total sobre la estructura
- ✅ No requiere reconfiguración de embeddings

**Contras:**
- ⚠️ Requiere entender estructura exacta de nodos
- ⚠️ Crear embeddings manualmente
- ⚠️ Más complejo de implementar
- ⚠️ Posibles inconsistencias con proceso estándar

**Tareas requeridas:**
- Analizar estructura exacta de nodos `Document`/`Chunk`
- Crear texto base ficticio o real
- Generar embeddings compatibles
- Establecer relaciones `PART_OF`, `HAS_ENTITY`

### Opción C: Hibridar (Recomendada para exploración)
**Estrategia:**
1. **Subir 1-2 documentos pequeños** para entender proceso completo
2. **Analizar estructura generada** automáticamente
3. **Decidir** si adaptar entidades existentes o continuar con documentos

## 🎯 **Recomendación de Investigación**

### Fase de Exploración (Opción C):
1. **Subir documento de prueba** (texto pequeño relacionado con tus entidades)
2. **Observar estructura generada**:
   - Propiedades de nodos `Document`
   - Propiedades de nodos `Chunk` 
   - Relaciones `PART_OF`, `HAS_ENTITY`
   - Proceso de embeddings
3. **Evaluar compatibilidad** con entidades existentes
4. **Decidir estrategia final** basada en observaciones

### Preguntas a resolver en la exploración:
- ¿Cómo se generan los embeddings de `Chunk`s?
- ¿Qué propiedades requieren los nodos `Document`/`Chunk`?
- ¿Cómo se conectan las entidades extraídas con los `Chunk`s?
- ¿Se pueden aprovechar las entidades existentes?

## 🛑 **Estado Actual: PAUSADO**

**Razón:** Priorizar reorganización del desarrollo según plan de fork estratégico

**Orden de prioridades acordado:**
1. **AHORA:** Implementar estrategia de fork profesional
2. **DESPUÉS:** Retomar este análisis con enfoque estructurado
3. **FINALMENTE:** Resolver configuración de embeddings y chunking

## 📋 **Próximos Pasos (cuando se retome)**

### Opción Recomendada: Exploración con documento pequeño
```bash
# Pasos específicos:
1. Crear documento de prueba (100-200 palabras sobre algoritmos/grafos)
2. Subirlo via LLM Graph Builder interface
3. Observar logs de procesamiento
4. Analizar estructura Neo4j resultante
5. Comparar con entidades existentes
6. Documentar hallazgos
7. Decidir estrategia final
```

### Scripts de análisis preparados:
- `test-ragas-mapping.py` → Para testing de modelos
- Consultas Cypher → Para análisis de estructura Neo4j

---

**Archivos relacionados:**
- `/Users/pepo/Dev/llm-graph-builder/backend/src/shared/constants.py` (consultas RAG)
- `/Users/pepo/Dev/llm-graph-builder/.env` (configuración embeddings)
- Neo4j sigma2 → Base de datos con entidades existentes

**Variables relevantes en .env:**
```bash
EMBEDDING_MODEL="all-MiniLM-L6-v2"
IS_EMBEDDING="true"
ENTITY_EMBEDDING=True
UPDATE_GRAPH_CHUNKS_PROCESSED=20
NUMBER_OF_CHUNKS_TO_COMBINE=6
```