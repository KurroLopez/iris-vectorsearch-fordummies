"""
Servidor Flask — Analizador de Sentimiento
==========================================
Expone dos rutas:
  GET  /          → sirve el frontend HTML
  POST /embedding → genera el vector con sentence-transformers
  GET  /health    → healthcheck para Docker

Uso:
  python server.py
  → escucha en 0.0.0.0:5000
"""

import os
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from sentence_transformers import SentenceTransformer

# ── App ─────────────────────────────────────────────────────────────────────
app = Flask(__name__, static_folder="static")
CORS(app)

# ── Modelo (cargado una sola vez; ya estará en caché desde el build) ─────────
MODEL_NAME = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
print(f"[boot] Cargando modelo {MODEL_NAME} …")
_model = SentenceTransformer(MODEL_NAME)
print("[boot] Modelo listo.")


# ── Utilidad ─────────────────────────────────────────────────────────────────
def Embedding(message: str) -> list[float]:
    """Devuelve el vector normalizado de 384 dimensiones para el texto dado."""
    vector = _model.encode(
        [message],
        normalize_embeddings=True,
        convert_to_numpy=True,
        show_progress_bar=False,
    )
    return vector[0].tolist()


# ── Rutas ────────────────────────────────────────────────────────────────────

@app.route("/")
def index():
    """Sirve el frontend."""
    return send_from_directory("static", "index.html")


@app.route("/embedding", methods=["POST"])
def embedding_endpoint():
    """
    POST /embedding
    Body JSON : { "text": "tu frase aquí" }
    Respuesta : { "vector": [0.12, -0.34, …] }   (384 valores)
    """
    data = request.get_json(force=True, silent=True) or {}
    text = str(data.get("text", "")).strip()

    if not text:
        return jsonify({"error": "El campo 'text' es obligatorio."}), 400

    try:
        vector = Embedding(text)
        return jsonify({"vector": vector})
    except Exception as exc:
        app.logger.exception("Error generando embedding")
        return jsonify({"error": str(exc)}), 500


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


# ── Main ─────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)
