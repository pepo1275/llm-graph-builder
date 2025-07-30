"""
Embedding Configuration Manager
Purpose: Centralized management of embedding models and dimensions
Author: LLM Graph Builder Team
Date: July 2025

This module provides a single source of truth for embedding configuration,
preventing dimension mismatch errors and enabling easy model switching.
"""

import os
import logging
from typing import Tuple, Dict, Optional
from functools import lru_cache
from src.shared.common_fn import load_embedding_model

logger = logging.getLogger(__name__)


class EmbeddingConfig:
    """
    Singleton configuration manager for embeddings.
    
    Ensures consistency across the entire system by providing
    a single source of truth for embedding dimensions.
    """
    
    _instance = None
    _initialized = False
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
    
    def __init__(self):
        """Initialize configuration only once."""
        if not self._initialized:
            self._model_name = os.getenv('EMBEDDING_MODEL', 'all-MiniLM-L6-v2')
            self._embeddings = None
            self._dimension = None
            self._load_config()
            self.__class__._initialized = True
    
    def _load_config(self):
        """Load embedding model and extract configuration."""
        try:
            self._embeddings, self._dimension = load_embedding_model(self._model_name)
            logger.info(f"Embedding config loaded: model={self._model_name}, dimension={self._dimension}")
        except Exception as e:
            logger.error(f"Failed to load embedding config: {e}")
            # Fallback to safe defaults
            self._model_name = 'all-MiniLM-L6-v2'
            self._embeddings, self._dimension = load_embedding_model(self._model_name)
            logger.warning(f"Fallback to default: model={self._model_name}, dimension={self._dimension}")
    
    @property
    def model_name(self) -> str:
        """Get current embedding model name."""
        return self._model_name
    
    @property
    def dimension(self) -> int:
        """Get embedding dimension for current model."""
        return self._dimension
    
    @property
    def chunk_dimension(self) -> int:
        """Get chunk embedding dimension (same as base dimension)."""
        return self._dimension
    
    @property
    def entity_dimension(self) -> int:
        """Get entity embedding dimension (same as base dimension)."""
        return self._dimension
    
    @property
    def community_dimension(self) -> int:
        """Get community embedding dimension (same as base dimension)."""
        return self._dimension
    
    @property
    def embeddings(self):
        """Get embeddings model instance."""
        return self._embeddings
    
    def get_model_info(self) -> Dict[str, any]:
        """
        Get comprehensive model information.
        
        Returns:
            Dict containing model details and configuration
        """
        actual_model = self._get_actual_model_name()
        
        return {
            'configured_model': self._model_name,
            'actual_model': actual_model,
            'dimension': self._dimension,
            'is_vertexai': self._model_name == 'vertexai',
            'is_openai': self._model_name == 'openai',
            'is_default': self._model_name == 'all-MiniLM-L6-v2',
            'supports_gpu': self._model_name in ['vertexai', 'openai', 'titan']
        }
    
    def _get_actual_model_name(self) -> str:
        """Map configured model to actual implementation."""
        model_mapping = {
            'vertexai': 'gemini-embedding-001',
            'openai': 'text-embedding-ada-002',
            'titan': 'amazon.titan-embed-text-v1',
            'all-MiniLM-L6-v2': 'sentence-transformers/all-MiniLM-L6-v2'
        }
        return model_mapping.get(self._model_name, self._model_name)
    
    def validate_index_compatibility(self, index_dimension: int) -> Tuple[bool, Optional[str]]:
        """
        Validate if an index is compatible with current embeddings.
        
        Args:
            index_dimension: Dimension of the existing index
            
        Returns:
            Tuple of (is_compatible, error_message)
        """
        if index_dimension == self._dimension:
            return True, None
        else:
            error_msg = (
                f"Dimension mismatch: Index has {index_dimension} dimensions, "
                f"but {self._model_name} embeddings have {self._dimension} dimensions. "
                f"Re-indexing required."
            )
            return False, error_msg
    
    def get_index_creation_options(self) -> Dict[str, any]:
        """
        Get Neo4j index creation options for current model.
        
        Returns:
            Dict with index configuration options
        """
        return {
            'vector.dimensions': self._dimension,
            'vector.similarity_function': 'cosine'
        }
    
    @classmethod
    def reset(cls):
        """Reset singleton instance (mainly for testing)."""
        cls._instance = None
        cls._initialized = False
    
    def __str__(self):
        """String representation of configuration."""
        return f"EmbeddingConfig(model={self._model_name}, dimension={self._dimension})"


# Convenience function for backward compatibility
@lru_cache(maxsize=1)
def get_embedding_config() -> EmbeddingConfig:
    """
    Get singleton embedding configuration instance.
    
    Returns:
        EmbeddingConfig instance
    """
    return EmbeddingConfig()


# Export commonly used values for easy access
def get_chunk_dimension() -> int:
    """Get chunk embedding dimension."""
    return get_embedding_config().chunk_dimension


def get_entity_dimension() -> int:
    """Get entity embedding dimension."""
    return get_embedding_config().entity_dimension


def get_community_dimension() -> int:
    """Get community embedding dimension."""
    return get_embedding_config().community_dimension