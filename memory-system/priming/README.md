# Memory Priming System (Animaworks-inspired)

Based on animaworks' hippocampus model with 6-channel automatic priming.

## Architecture
Instead of loading all memory into context, this system:
1. **Priming Layer** — Before each conversation, searches relevant memories via RAG
2. **Consolidation** — Periodically merges short-term into long-term (like sleep consolidation)
3. **Forgetting** — Three-stage forgetting: decay → interference → active pruning
4. **Graph Diffusion** — NetworkX graph for spreading activation between related memories

## Channels (6-channel priming)
1. **Recency** — Recent interactions weighted higher
2. **Relevance** — Semantic similarity to current topic
3. **Frequency** — Often-accessed memories reinforced
4. **Emotional** — User emotional signals boost memory priority
5. **Procedural** — Active Skills/techniques always primed
6. **Social** — User preferences and relationship context

## Implementation
- RAG via ChromaDB + sentence-transformers (when available)
- FTS5 fallback for lightweight setups
- Graph relationships stored in NetworkX JSON
- Trust tags on memories (verified/corrected/inferred)
