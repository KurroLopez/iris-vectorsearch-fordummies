"""
Ejecutado una sola vez durante el docker build.
Descarga y cachea el modelo para que el arranque del servidor sea instantáneo.
"""
from sentence_transformers import SentenceTransformer

MODEL_NAME = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
print(f"Descargando modelo: {MODEL_NAME} …")
SentenceTransformer(MODEL_NAME)
print("Modelo descargado y cacheado correctamente.")
