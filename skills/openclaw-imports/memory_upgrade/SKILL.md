# Memory Upgrade Skill — Vector Search for Semantic Memory

**Skill**: memory_upgrade  
**Version**: 1.0.0  
**Purpose**: Add vector-based semantic search to the fr3k AI agent system

---

## What It Does

The Memory Upgrade adds **semantic vector search** to the existing memory system. It allows the AI to:
- Store memories with embeddings
- Search by meaning, not just keywords
- Find related context even when exact words don't match
- Scale to thousands of memories without performance degradation

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    MEMORY UPGRADE SYSTEM                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │  Ingest     │───▶│  Embed      │───▶│  Store in   │     │
│  │  (text)     │    │  (bge-base) │    │  Supabase   │     │
│  └─────────────┘    └─────────────┘    │  (pgvector) │     │
│                                         └─────────────┘     │
│  ┌─────────────┐    ┌─────────────┐         ▲               │
│  │  Query      │───▶│  Embed      │─────────┘               │
│  │  (text)     │    │  (bge-base) │                         │
│  └─────────────┘    └─────────────┘    ┌─────────────┐       │
│                                  ──▶│  Cosine     │       │
│                                     │  Similarity │       │
│                                     └─────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

---

## Setup

### Prerequisites
- Supabase project with `pgvector` extension enabled
- `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` in environment

### Database Setup
```sql
-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create memory table with embeddings
CREATE TABLE IF NOT EXISTS memory_vectors (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    embedding vector(768),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for similarity search
CREATE INDEX ON memory_vectors 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
```

---

## Usage

### Python API

```python
from skills.memory_upgrade import MemoryUpgrade

mem = MemoryUpgrade()

# Store a memory
mem.add(
    content="fr3k prefers direct communication, dislikes corporate speak",
    metadata={"source": "soul.md", "priority": "high"}
)

# Search by meaning (not keywords)
results = mem.search(
    query="how does fr3k like to communicate?",
    limit=5
)

# Get all memories
all_memories = mem.list_all(limit=100)

# Delete a memory
mem.delete(memory_id=42)
```

### CLI Commands
```bash
# Add memory
python3 -c "
from skills.memory_upgrade import MemoryUpgrade
m = MemoryUpgrade()
m.add('Your memory text here')
"

# Search
python3 -c "
from skills.memory_upgrade import MemoryUpgrade
m = MemoryUpgrade()
for r in m.search('your search query'):
    print(r)
"
```

---

## Embedding Model

- **Primary**: `BAAI/bge-base-en-v1.5` (768 dimensions)
- **Fallback**: OpenAI text-embedding-ada-002 (1536 dimensions)
- **Dimension**: 768 (matched to bge-base)

---

## Pricing Tiers (for mcpintelligence.com.au)

| Tier | Memories | Price (AUD) | Features |
|------|----------|-------------|----------|
| **Lite** | 1,000 | $25/mo | Basic search, 1k memories |
| **Pro** | 10,000 | $75/mo | Priority indexing, 10k memories |
| **Enterprise** | 100,000+ | $200/mo | Dedicated vector DB, unlimited |

---

## Integration Points

### 1. Tool Maker Integration
When `tool_maker.py` creates a memory tool, it can use `MemoryUpgrade`:
```python
from skills.memory_upgrade import MemoryUpgrade

class MemoryTool:
    def __init__(self):
        self.store = MemoryUpgrade()
    
    def remember(self, content, metadata=None):
        self.store.add(content, metadata)
    
    def recall(self, query, limit=5):
        return self.store.search(query, limit)
```

### 2. Persona Packs Integration
Each persona can have its own memory namespace:
```python
# Business Partner persona memories
mem.add("fr3k's business partner persona: aggressive, revenue-focused")
mem.add("fr3k's communication style: direct, no fluff")
```

### 3. HEARTBEAT Integration
Auto-store significant events:
```python
# After revenue event
mem.add(f"Revenue event: {event_type} - {amount} AUD")
```

---

## Files

- `skills/memory_upgrade.py` — Main implementation
- `skills/memory_upgrade/SKILL.md` — This file
- `memory/memory_store.jsonl` — Legacy JSONL storage (read-only)

---

## Dependencies

```bash
pip install sentence-transformers supabase psycopg2-binary
```

---

## Notes

- Uses cosine similarity for semantic matching
- Embeddings computed locally with `sentence-transformers`
- Supabase as vector database (pgvector)
- Backward compatible with existing `memory_store.jsonl`
