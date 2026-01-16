# Context Loading Strategies

Advanced patterns for efficient context loading that balance completeness with token budget constraints.

## Table of Contents

1. [Token Budget Management](#token-budget-management)
2. [Progressive Loading](#progressive-loading)
3. [Lazy Loading](#lazy-loading)
4. [Smart Expansion](#smart-expansion)
5. [Context Compression](#context-compression)
6. [Multi-Level Caching](#multi-level-caching)

## Token Budget Management

### Budget Allocation

```python
# Token budget for 200K context window
TOTAL_BUDGET = 200_000

BUDGET_ALLOCATION = {
    'system_prompt': 5_000,      # Agent instructions
    'session_context': 40_000,   # Loaded context
    'conversation': 50_000,      # Back-and-forth
    'reasoning': 100_000,        # Available for thinking
    'buffer': 5_000              # Safety margin
}

def check_budget(session):
    """Verify we're within budget."""

    used = {
        'system': len(encode(session['system_prompt'])),
        'context': calculate_context_tokens(session['context']),
        'conversation': len(encode(session['conversation_history']))
    }

    total_used = sum(used.values())
    available = TOTAL_BUDGET - total_used

    return {
        'used': used,
        'total_used': total_used,
        'available': available,
        'percentage': (total_used / TOTAL_BUDGET) * 100
    }
```

### Context Budget

For 40K context budget:

```python
CONTEXT_BUDGET = {
    'essential': 10_000,      # Must-have (25%)
    'recent': 15_000,         # Past week (37.5%)
    'related': 10_000,        # Related notes (25%)
    'buffer': 5_000           # For expansion (12.5%)
}

def allocate_context_budget(session_type):
    """Allocate budget based on session type."""

    if session_type == 'focus':
        return {
            'essential': 8_000,   # Project-focused
            'recent': 20_000,     # Heavy on recent work
            'related': 10_000,
            'buffer': 2_000
        }

    elif session_type == 'strategic':
        return {
            'essential': 15_000,  # Multi-project overview
            'recent': 10_000,     # Less recent detail
            'related': 12_000,    # More cross-project
            'buffer': 3_000
        }

    elif session_type == 'meeting-prep':
        return {
            'essential': 5_000,   # Minimal essentials
            'recent': 10_000,     # Related recent work
            'related': 20_000,    # Heavy on meeting context
            'buffer': 5_000       # Expansion during meeting
        }
```

## Progressive Loading

### Three-Phase Loading

**Phase 1: Essential Context (Always Loaded)**
```python
def load_essential_context(org_name, project_name):
    """Load minimal essential context (~8-10K tokens)."""

    context = {}

    # Organization index (summary only)
    org_index = load_note(f'organizations/{org_name}/context-library/00-INDEX.md')
    context['org_index'] = extract_summary(org_index, max_tokens=2000)

    # Project index (summary only)
    proj_index = load_note(f'organizations/{org_name}/projects/{project_name}/context-library/00-PROJECT-INDEX.md')
    context['project_index'] = extract_summary(proj_index, max_tokens=2000)

    # Recent decisions (titles + summaries only)
    decisions = load_recent_decisions(org_name, project_name, days=30)
    context['recent_decisions'] = [
        {
            'id': d.id,
            'title': d.title,
            'summary': d.summary,  # Don't load full content yet
            'decided': d.decided_date
        }
        for d in decisions[:5]  # Top 5 most recent
    ]

    # Active playbooks (references only)
    playbooks = find_active_playbooks(org_name)
    context['active_playbooks'] = [
        {
            'id': p.id,
            'title': p.title,
            'when_to_use': p.when_to_use[:200]  # Just applicability
        }
        for p in playbooks
    ]

    return context
```

**Phase 2: Recent Work (Conditionally Loaded)**
```python
def load_recent_work(org_name, project_name, budget_remaining):
    """Load recent work based on available budget."""

    if budget_remaining < 5000:
        return {}  # Not enough budget

    recent = {}

    # Notes created (summaries only)
    notes_created = find_notes_created_after(
        f'organizations/{org_name}/projects/{project_name}',
        datetime.now() - timedelta(days=7)
    )

    recent['notes_created'] = []
    tokens_used = 0

    for note in notes_created:
        note_summary = {
            'id': note.id,
            'title': note.title,
            'summary': note.summary,
            'created': note.created
        }

        note_tokens = estimate_tokens(note_summary)
        if tokens_used + note_tokens > budget_remaining * 0.5:
            break  # Don't use more than half of remaining budget

        recent['notes_created'].append(note_summary)
        tokens_used += note_tokens

    # Conversations (ultra-compressed)
    conversations = find_conversations_after(
        f'organizations/{org_name}/projects/{project_name}',
        datetime.now() - timedelta(days=7)
    )

    recent['conversations'] = [
        {
            'date': c.date,
            'summary': c.summary[:100],  # First 100 chars only
            'outcomes': c.extracted_insights
        }
        for c in conversations[:3]  # Only recent 3
    ]

    return recent
```

**Phase 3: On-Demand Expansion (Lazy)**
```python
def expand_context_on_demand(session, request):
    """Expand context when user requests specific information."""

    # User asked about a specific note
    if 'load' in request or 'show' in request:
        note_id = extract_note_id(request)

        # Check budget
        budget = check_budget(session)
        if budget['available'] < 2000:
            return "Insufficient budget for expansion. Consider closing some context."

        # Load full note
        note = load_note(note_id)
        session['context']['loaded_notes'][note_id] = note

        return f"Loaded [[{note_id}|{note.title}]] - {len(encode(note.content))} tokens"
```

## Lazy Loading

### Deferred Reference Loading

```python
class LazyNote:
    """Note with lazily-loaded content."""

    def __init__(self, note_id):
        self.id = note_id
        self._metadata = None
        self._content = None
        self._references = None

    @property
    def metadata(self):
        """Load metadata (lightweight)."""
        if self._metadata is None:
            self._metadata = load_note_metadata(self.id)
        return self._metadata

    @property
    def content(self):
        """Load full content (heavyweight)."""
        if self._content is None:
            self._content = load_note_content(self.id)
        return self._content

    @property
    def references(self):
        """Load referenced notes (on-demand)."""
        if self._references is None:
            ref_ids = extract_references(self.content)
            self._references = [LazyNote(rid) for rid in ref_ids]
        return self._references

    def to_summary(self):
        """Lightweight summary representation."""
        return {
            'id': self.id,
            'title': self.metadata['title'],
            'summary': self.metadata.get('summary', ''),
            'tags': self.metadata.get('tags', [])
        }

# Usage
note = LazyNote('2026-01-050')
print(note.metadata['title'])  # Loads only metadata
# Content not loaded until explicitly accessed
if user_requests_full_content:
    print(note.content)  # Now loads full content
```

### Reference Chain Limiting

```python
def load_with_reference_limit(note_id, max_depth=2, max_refs=5):
    """Load note with limited reference expansion."""

    def load_recursive(nid, depth):
        if depth > max_depth:
            return {'id': nid, 'truncated': True}

        note = load_note(nid)

        # Load only top N references
        refs = extract_references(note.content)[:max_refs]

        note_data = {
            'id': nid,
            'title': note.title,
            'content': note.content,
            'references': []
        }

        if depth < max_depth:
            for ref in refs:
                note_data['references'].append(
                    load_recursive(ref, depth + 1)
                )

        return note_data

    return load_recursive(note_id, 0)
```

## Smart Expansion

### Query-Based Expansion

```python
def expand_for_query(session, query):
    """Intelligently expand context based on query."""

    # Extract entities and keywords
    entities = extract_entities(query)
    keywords = extract_keywords(query)

    # Check what's already loaded
    loaded_content = get_loaded_content_text(session)

    # Calculate coverage
    entity_coverage = calculate_entity_coverage(entities, loaded_content)
    keyword_coverage = calculate_keyword_coverage(keywords, loaded_content)

    expansions = []

    # If entity coverage low, load relevant notes
    if entity_coverage < 0.5:
        missing_entities = [e for e in entities if e not in loaded_content]

        for entity in missing_entities:
            # Search for notes about this entity
            relevant = search_notes_by_entity(
                session['organization'],
                session.get('project'),
                entity,
                limit=3
            )

            for note in relevant:
                if check_budget(session)['available'] > 2000:
                    expansions.append(load_note(note.id))

    # If keyword coverage low, load semantically similar
    if keyword_coverage < 0.5:
        # Semantic search for relevant context
        query_embedding = embed_text(query)
        similar_notes = semantic_search(
            query_embedding,
            session['organization'],
            session.get('project'),
            limit=5
        )

        for note in similar_notes:
            if check_budget(session)['available'] > 2000:
                expansions.append(load_note(note.id))

    return expansions
```

### Pattern-Based Expansion

```python
def expand_for_pattern(session, pattern_type):
    """Expand context based on detected work pattern."""

    expansions = []

    if pattern_type == 'decision_making':
        # Load decision frameworks
        decision_frameworks = find_notes_by_tag(
            session['organization'],
            ['decision', 'framework']
        )
        expansions.extend(decision_frameworks[:3])

        # Load recent decisions for examples
        recent_decisions = load_recent_decisions(
            session['organization'],
            session.get('project'),
            days=90
        )
        expansions.extend(recent_decisions[:5])

    elif pattern_type == 'planning':
        # Load planning playbooks
        playbooks = find_playbooks_by_keyword(
            session['organization'],
            ['planning', 'okr', 'strategy']
        )
        expansions.extend(playbooks)

        # Load recent plans for reference
        recent_plans = find_notes_by_tag(
            session['organization'],
            ['planning', 'roadmap']
        )
        expansions.extend(recent_plans[:3])

    elif pattern_type == 'problem_solving':
        # Load relevant patterns
        patterns = find_notes_by_type(
            session['organization'],
            'pattern'
        )
        expansions.extend(patterns)

        # Load similar past problems
        # (semantic search based on current problem description)

    return expansions
```

## Context Compression

### Summary-First Loading

```python
def compress_note_for_context(note, compression_level='medium'):
    """Compress note to fit token budget."""

    if compression_level == 'minimal':
        return {
            'id': note.id,
            'title': note.title,
            'tags': note.tags
        }

    elif compression_level == 'low':
        return {
            'id': note.id,
            'title': note.title,
            'summary': note.summary,
            'tags': note.tags,
            'related': [ref.id for ref in note.references]
        }

    elif compression_level == 'medium':
        return {
            'id': note.id,
            'title': note.title,
            'summary': note.summary,
            'key_points': extract_key_points(note.content, max_points=5),
            'tags': note.tags,
            'related': [
                {'id': ref.id, 'title': ref.title}
                for ref in note.references
            ]
        }

    elif compression_level == 'full':
        # Full content, but still structured
        return {
            'id': note.id,
            'title': note.title,
            'summary': note.summary,
            'content': note.content,
            'tags': note.tags,
            'related': note.references
        }

def extract_key_points(content, max_points=5):
    """Extract key points from note content."""

    # Look for bullet points, numbered lists
    points = []

    # Extract from ## sections
    sections = split_by_headers(content)
    for section in sections:
        if section['level'] == 2:  # ## headers
            # Get first sentence or first bullet
            first_content = extract_first_meaningful_content(
                section['content']
            )
            if first_content:
                points.append(first_content)

        if len(points) >= max_points:
            break

    return points
```

### Hierarchical Summarization

```python
def create_hierarchical_summary(notes):
    """Create multi-level summary of notes."""

    # Level 1: Ultra-compressed (one line per note)
    level1 = [
        f"[[{n.id}|{n.title}]]"
        for n in notes
    ]

    # Level 2: With summaries
    level2 = [
        f"[[{n.id}|{n.title}]]: {n.summary}"
        for n in notes
    ]

    # Level 3: With key points
    level3 = [
        {
            'id': n.id,
            'title': n.title,
            'summary': n.summary,
            'key_points': extract_key_points(n.content, max_points=3)
        }
        for n in notes
    ]

    return {
        'level1': level1,  # ~10 tokens per note
        'level2': level2,  # ~50 tokens per note
        'level3': level3   # ~100-200 tokens per note
    }
```

## Multi-Level Caching

### Session Cache

```python
class SessionCache:
    """Cache loaded context for session."""

    def __init__(self, session_id):
        self.session_id = session_id
        self.cache = {
            'notes': {},          # Full notes
            'metadata': {},       # Note metadata only
            'embeddings': {},     # Note embeddings
            'search_results': {}  # Search query results
        }

    def get_note(self, note_id, level='full'):
        """Get note from cache."""

        if level == 'metadata':
            if note_id not in self.cache['metadata']:
                self.cache['metadata'][note_id] = load_note_metadata(note_id)
            return self.cache['metadata'][note_id]

        elif level == 'full':
            if note_id not in self.cache['notes']:
                self.cache['notes'][note_id] = load_note(note_id)
            return self.cache['notes'][note_id]

    def get_embedding(self, note_id):
        """Get or generate note embedding."""

        if note_id not in self.cache['embeddings']:
            note = self.get_note(note_id, level='full')
            self.cache['embeddings'][note_id] = embed_note(note)

        return self.cache['embeddings'][note_id]

    def cache_search_results(self, query, results):
        """Cache search results."""
        self.cache['search_results'][query] = {
            'results': results,
            'timestamp': datetime.now()
        }

    def get_cached_search(self, query, max_age_minutes=30):
        """Get cached search results if fresh."""

        if query not in self.cache['search_results']:
            return None

        cached = self.cache['search_results'][query]
        age = (datetime.now() - cached['timestamp']).total_seconds() / 60

        if age < max_age_minutes:
            return cached['results']

        return None
```

### Global Cache

```python
# Cross-session cache for frequently accessed notes
GLOBAL_CACHE = LRUCache(maxsize=1000)

def load_note_with_cache(note_id):
    """Load note with global caching."""

    cache_key = f"note:{note_id}"

    # Check global cache
    if cache_key in GLOBAL_CACHE:
        return GLOBAL_CACHE[cache_key]

    # Load from disk
    note = load_note_from_disk(note_id)

    # Cache for future sessions
    GLOBAL_CACHE[cache_key] = note

    return note
```

## Best Practices

1. **Budget First**: Always check budget before loading
2. **Progressive**: Load essential first, expand as needed
3. **Lazy References**: Don't load reference chains eagerly
4. **Compress Aggressively**: Use summaries until full content needed
5. **Cache Intelligently**: Reuse loaded context within session
6. **Monitor Usage**: Track token consumption per component
7. **Fail Gracefully**: Degrade to summaries if budget tight

## Common Pitfalls

- **Loading Everything**: Eager loading wastes tokens
- **Deep Reference Chains**: Following refs too deep
- **No Compression**: Loading full content when summary sufficient
- **Ignoring Budget**: Running out of tokens mid-session
- **No Caching**: Reloading same notes repeatedly
- **Over-Expansion**: Loading related content too liberally
