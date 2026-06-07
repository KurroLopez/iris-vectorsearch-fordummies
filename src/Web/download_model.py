from sentence_transformers import SentenceTransformer

MODEL_NAME = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
print(f"Download model: {MODEL_NAME} …")
SentenceTransformer(MODEL_NAME)
print("Model downloaded and cached successfully.")
