Class St.Vectorsearch.Vector Extends Ens.Rule.FunctionSet
{

ClassMethod Embedding(Text) [ Language = python ]
{
    from sentence_transformers import SentenceTransformer

    model_name = 'sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2'

    # Cache en variables globales del modulo Python embebido (persistente por proceso).
    global _cached_embedding_model
    if '_cached_embedding_model' not in globals():
        _cached_embedding_model = SentenceTransformer(model_name)

    vector = _cached_embedding_model.encode(
        [Text],
        normalize_embeddings=True,
        convert_to_numpy=True,
        show_progress_bar=False
    )

    return str(vector[0].tolist())
}

}
