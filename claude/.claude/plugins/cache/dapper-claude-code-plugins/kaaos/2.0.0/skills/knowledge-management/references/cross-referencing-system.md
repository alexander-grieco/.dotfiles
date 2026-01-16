# Cross-Referencing System

Advanced linking strategies for creating a densely connected knowledge graph that enables emergent insights and rapid knowledge traversal.

## Table of Contents

1. [Link Types and Semantics](#link-types-and-semantics)
2. [Bidirectional References](#bidirectional-references)
3. [Link Validation](#link-validation)
4. [Semantic Clustering](#semantic-clustering)
5. [Graph Visualization](#graph-visualization)
6. [Automated Link Suggestions](#automated-link-suggestions)

## Link Types and Semantics

### Basic Link Syntax

```markdown
[[note-id]]                      # Basic reference
[[note-id|Display Text]]         # Annotated reference
[[note-id#section]]              # Section reference
[[note-id#section|Description]]  # Annotated section reference
```

### Semantic Link Types

Add semantic meaning to understand relationship types:

```markdown
## Related Notes

### Extensions
Extends: [[2026-01-020]] - Builds directly on this framework
Specializes: [[2026-01-015]] - Specific case of this pattern

### Comparisons
Cf: [[2026-01-005]] - Alternative approach with different tradeoffs
Vs: [[2026-01-010]] - Contrast with competing framework
Alternative: [[2026-01-012]] - Different solution to same problem

### Dependencies
Requires: [[2026-01-001]] - Must understand this first
Prerequisite: [[2026-01-003]] - Foundation knowledge needed
Builds-on: [[2026-01-008]] - Extends this concept

### Applications
Example: [[2026-02-015]] - Real implementation of this pattern
Case-study: [[2026-02-020]] - Detailed application
Applied-in: [[PROJECT-launch]] - Used in this project

### Meta-references
See-also: [[2026-01-025]] - Related but tangential
Background: [[2026-01-030]] - Historical context
Source: [[REF-external-paper]] - Original reference

### Synthesis
Synthesized-by: [[SYNTH-2026-Q1]] - Included in quarterly synthesis
Pattern: [[PATT-decision-making]] - Part of this larger pattern
```

### Link Context Annotations

Add context to explain why the link matters:

```markdown
## Related

- [[2026-01-020|One-Way vs Two-Way Doors]]
  *Use with pre-mortems: categorize risks by reversibility*

- [[2026-02-015|Small Bet Portfolios]]
  *Combine approaches: pre-mortem to identify bets, portfolios to hedge*

- [[PLAY-quarterly-planning|Quarterly Planning]]
  *Pre-mortems work best at quarterly kickoffs, before commitment*
```

## Bidirectional References

### Manual Backlink Creation

When creating forward references, add backlinks:

```markdown
# In new note (2026-03-050)
## Related
- [[2026-01-020|One-Way vs Two-Way Doors]] - Decision framework we're using

# Then update 2026-01-020
## Backlinks
- [[2026-03-050|Sprint Cadence Decision]] - Applied this framework (2026-03-15)
```

### Automated Backlink Generation

Maintenance agent automatically adds backlinks:

```python
# maintenance-agent/backlinks.py

def generate_backlinks(knowledge_base_path):
    """Scan all notes and generate backlink sections."""

    notes = load_all_notes(knowledge_base_path)
    reference_map = build_reference_map(notes)

    for note_id, referencing_notes in reference_map.items():
        target_note = load_note(note_id)

        # Find or create backlinks section
        backlinks_section = extract_section(target_note, "Backlinks")

        # Add new backlinks
        new_backlinks = []
        for ref_note in referencing_notes:
            backlink = f"- [[{ref_note.id}|{ref_note.title}]] ({ref_note.date})"
            if backlink not in backlinks_section:
                new_backlinks.append(backlink)

        if new_backlinks:
            update_backlinks_section(target_note, new_backlinks)

def build_reference_map(notes):
    """Build map of which notes reference which."""
    ref_map = defaultdict(list)

    for note in notes:
        # Extract all [[references]] from note content
        references = extract_references(note.content)

        for ref_id in references:
            ref_map[ref_id].append(note)

    return ref_map
```

### Backlink Display Patterns

**Chronological (default)**:
```markdown
## Backlinks
- [[2026-03-050|Sprint Cadence]] (2026-03-15)
- [[2026-03-048|Team Velocity]] (2026-03-10)
- [[2026-03-042|Release Planning]] (2026-03-05)
```

**Categorized**:
```markdown
## Backlinks

### Applications (3)
- [[2026-03-050|Sprint Cadence]] - Used in planning process
- [[2026-03-048|Team Velocity]] - Applied to velocity tracking
- [[2026-03-042|Release Planning]] - Informed release dates

### Discussions (2)
- [[2026-03-040|Leadership Meeting]] - Discussed this framework
- [[2026-03-035|Team Retro]] - Referenced in retrospective
```

**Frequency-Based**:
```markdown
## Backlinks (Most Referenced)
- [[PLAY-quarterly-planning]] - 12 references
- [[2026-03-050|Sprint Cadence]] - 3 references
- [[2026-03-048|Team Velocity]] - 1 reference

*[Show all 47 backlinks →](/backlinks/2026-01-020)*
```

## Link Validation

### Broken Link Detection

```python
# maintenance-agent/link_validator.py

def validate_links(knowledge_base_path):
    """Check for broken references."""

    notes = load_all_notes(knowledge_base_path)
    broken_links = []

    for note in notes:
        references = extract_references(note.content)

        for ref_id in references:
            if not note_exists(ref_id):
                broken_links.append({
                    'source': note.id,
                    'source_title': note.title,
                    'broken_ref': ref_id,
                    'context': extract_link_context(note.content, ref_id)
                })

    return broken_links

def extract_link_context(content, ref_id):
    """Get surrounding text for context."""
    # Find paragraph containing reference
    # Return 100 chars before/after for context
    pass
```

**Validation Report**:
```markdown
# Link Validation Report
Generated: 2026-03-15

## Broken Links (3)

### 2026-03-050 → 2026-02-999 (MISSING)
**Source**: Sprint Cadence Decision
**Context**: "...based on framework in [[2026-02-999|Team Dynamics]]..."
**Action**: Update reference or create missing note

### 2026-03-048 → PLAY-standup (MISSING)
**Source**: Team Velocity
**Context**: "...following [[PLAY-standup|Standup Playbook]] guidelines..."
**Action**: Note was renamed to PLAY-daily-standup, update reference

## Orphaned Notes (2)

### 2026-02-035 - "Early Framework Draft"
**Backlinks**: 0
**Last accessed**: 45 days ago
**Action**: Archive or link from relevant map note
```

### Automated Link Repair

```python
def repair_broken_links(broken_links, fuzzy_match=True):
    """Attempt to automatically repair broken links."""

    repairs = []

    for broken in broken_links:
        # Check if note was renamed
        renamed_note = find_renamed_note(broken['broken_ref'])
        if renamed_note:
            repairs.append({
                'type': 'rename',
                'old': broken['broken_ref'],
                'new': renamed_note.id,
                'confidence': 'high'
            })
            continue

        # Fuzzy match by title
        if fuzzy_match:
            similar = find_similar_notes(broken['broken_ref'])
            if similar:
                repairs.append({
                    'type': 'fuzzy_match',
                    'old': broken['broken_ref'],
                    'candidates': similar,
                    'confidence': 'medium'
                })

    return repairs
```

## Semantic Clustering

### Automated Topic Clustering

Group notes by semantic similarity:

```python
# maintenance-agent/semantic_clustering.py

from sentence_transformers import SentenceTransformer
from sklearn.cluster import DBSCAN
import numpy as np

def cluster_notes(notes, min_cluster_size=3, similarity_threshold=0.75):
    """Cluster notes by semantic similarity."""

    # Load embedding model
    model = SentenceTransformer('all-MiniLM-L6-v2')

    # Generate embeddings for each note
    texts = [f"{note.title} {note.summary}" for note in notes]
    embeddings = model.encode(texts)

    # Cluster using DBSCAN
    clustering = DBSCAN(
        eps=1 - similarity_threshold,  # Convert similarity to distance
        min_samples=min_cluster_size,
        metric='cosine'
    )

    labels = clustering.fit_predict(embeddings)

    # Group notes by cluster
    clusters = defaultdict(list)
    for note, label in zip(notes, labels):
        if label != -1:  # -1 is noise/unclustered
            clusters[label].append(note)

    return clusters

def suggest_map_notes(clusters):
    """Suggest creating map notes for clusters."""

    suggestions = []

    for cluster_id, cluster_notes in clusters.items():
        # Extract common themes from cluster
        common_tags = find_common_tags(cluster_notes)
        suggested_title = generate_cluster_title(cluster_notes)

        suggestions.append({
            'suggested_title': suggested_title,
            'tags': common_tags,
            'notes': [note.id for note in cluster_notes],
            'reason': f'{len(cluster_notes)} related notes without map'
        })

    return suggestions
```

**Clustering Output**:
```markdown
# Semantic Clustering Report
Generated: 2026-03-15

## Cluster 1: Decision-Making Frameworks (8 notes)
**Similarity**: 0.82
**Notes**:
- [[2026-01-001|Pre-Mortem Analysis]]
- [[2026-01-020|One-Way vs Two-Way Doors]]
- [[2026-01-021|OODA Loop]]
- [[2026-02-015|Small Bet Portfolios]]
- [[2026-02-018|Decision Logs]]
- [[2026-03-010|Reversible Decisions]]
- [[2026-03-025|Red Team Analysis]]
- [[2026-03-030|Scenario Planning]]

**Suggestion**: Create [[MAP-decision-frameworks]] to organize these related notes

## Cluster 2: Remote Team Practices (6 notes)
**Similarity**: 0.79
**Notes**:
- [[2026-01-042|Async Communication]]
- [[2026-02-008|Meeting Pre-Reads]]
- [[2026-02-033|Distributed Standups]]
- [[2026-03-015|Remote Hiring]]
- [[2026-03-020|Team Cohesion]]
- [[2026-03-040|Virtual Offsites]]

**Suggestion**: Create [[MAP-remote-work]] to organize these practices
```

### Graph Metrics

Calculate network properties:

```python
def calculate_graph_metrics(knowledge_base):
    """Calculate knowledge graph metrics."""

    G = build_graph(knowledge_base)

    metrics = {
        'total_nodes': G.number_of_nodes(),
        'total_edges': G.number_of_edges(),
        'avg_degree': sum(dict(G.degree()).values()) / G.number_of_nodes(),
        'density': nx.density(G),
        'connected_components': nx.number_connected_components(G),

        # Most connected notes
        'hubs': sorted(
            G.degree(),
            key=lambda x: x[1],
            reverse=True
        )[:10],

        # Isolated notes (potential orphans)
        'isolated': [n for n in G.nodes() if G.degree(n) == 0],

        # Bridge notes (connect communities)
        'bridges': find_bridge_notes(G)
    }

    return metrics
```

## Graph Visualization

### Static Visualization

Generate graph visualizations for understanding structure:

```python
import networkx as nx
import matplotlib.pyplot as plt

def visualize_knowledge_graph(knowledge_base, output_path):
    """Create visual representation of knowledge graph."""

    G = build_graph(knowledge_base)

    # Use force-directed layout
    pos = nx.spring_layout(G, k=0.5, iterations=50)

    # Size nodes by degree (connectivity)
    node_sizes = [G.degree(n) * 100 for n in G.nodes()]

    # Color nodes by type
    node_colors = [get_node_color(n) for n in G.nodes()]

    plt.figure(figsize=(20, 20))
    nx.draw_networkx(
        G, pos,
        node_size=node_sizes,
        node_color=node_colors,
        with_labels=True,
        font_size=8,
        alpha=0.7
    )

    plt.savefig(output_path, dpi=300, bbox_inches='tight')

def get_node_color(note):
    """Color by note type."""
    colors = {
        'atomic': '#3498db',    # Blue
        'map': '#e74c3c',       # Red
        'synthesis': '#f39c12', # Orange
        'playbook': '#2ecc71'   # Green
    }
    return colors.get(note.type, '#95a5a6')
```

### Interactive Exploration

Generate interactive HTML visualization:

```python
from pyvis.network import Network

def create_interactive_graph(knowledge_base, output_file="graph.html"):
    """Create interactive knowledge graph visualization."""

    net = Network(height="800px", width="100%", bgcolor="#222222", font_color="white")

    # Add nodes
    for note in knowledge_base.notes:
        net.add_node(
            note.id,
            label=note.title,
            title=f"{note.title}\n\n{note.summary}",  # Hover tooltip
            size=note.degree * 5,
            color=get_node_color(note)
        )

    # Add edges
    for note in knowledge_base.notes:
        for ref in note.references:
            net.add_edge(note.id, ref, color="rgba(255,255,255,0.2)")

    # Configure physics
    net.set_options("""
    {
        "physics": {
            "forceAtlas2Based": {
                "gravitationalConstant": -50,
                "centralGravity": 0.01,
                "springLength": 100,
                "springConstant": 0.08
            },
            "maxVelocity": 50,
            "solver": "forceAtlas2Based",
            "timestep": 0.35,
            "stabilization": {"iterations": 150}
        }
    }
    """)

    net.show(output_file)
```

## Automated Link Suggestions

### Context-Based Suggestions

Suggest links based on content similarity:

```python
def suggest_links(new_note, existing_notes, threshold=0.7):
    """Suggest relevant links for a new note."""

    model = SentenceTransformer('all-MiniLM-L6-v2')

    # Embed new note
    new_embedding = model.encode(f"{new_note.title} {new_note.content}")

    # Embed existing notes
    existing_embeddings = model.encode([
        f"{n.title} {n.summary}" for n in existing_notes
    ])

    # Calculate similarity
    similarities = cosine_similarity([new_embedding], existing_embeddings)[0]

    # Get top suggestions
    suggestions = []
    for idx, score in enumerate(similarities):
        if score >= threshold:
            note = existing_notes[idx]
            suggestions.append({
                'note_id': note.id,
                'title': note.title,
                'similarity': score,
                'reason': explain_similarity(new_note, note)
            })

    # Sort by similarity
    suggestions.sort(key=lambda x: x['similarity'], reverse=True)

    return suggestions[:10]  # Top 10

def explain_similarity(note1, note2):
    """Explain why notes are similar."""
    # Compare tags
    common_tags = set(note1.tags) & set(note2.tags)
    if common_tags:
        return f"Common tags: {', '.join(common_tags)}"

    # Compare key terms
    common_terms = extract_common_terms(note1, note2)
    if common_terms:
        return f"Common concepts: {', '.join(common_terms[:3])}"

    return "Semantic similarity detected"
```

**Suggestion Output**:
```markdown
# Link Suggestions for: 2026-03-050 - Sprint Cadence Decision

## High Confidence (>0.85)

1. [[2026-02-020|Agile Practices]] (0.89)
   *Reason*: Common tags: agile, process, team
   *Suggested context*: "Builds on agile framework in [[2026-02-020]]"

2. [[PLAY-remote-async-excellence]] (0.87)
   *Reason*: Common tags: remote, async, efficiency
   *Suggested context*: "Supports async-first approach from [[PLAY-remote-async-excellence]]"

## Medium Confidence (0.70-0.85)

3. [[2026-01-042|Async Communication]] (0.78)
   *Reason*: Semantic similarity - discusses similar communication patterns
   *Suggested context*: "Related: [[2026-01-042]] - async communication principles"

4. [[2026-03-015|Remote Team Hiring]] (0.72)
   *Reason*: Common tags: remote, team
   *Suggested context*: "See-also: [[2026-03-015]] - hiring for async teams"
```

### Pattern-Based Link Suggestions

Detect common patterns and suggest links:

```python
def suggest_pattern_links(knowledge_base):
    """Suggest links based on recognized patterns."""

    suggestions = []

    # Pattern 1: Decision → Implementation
    for decision_note in find_notes_by_type('decision'):
        # Look for implementation notes without decision link
        implementations = find_related_implementations(decision_note)
        for impl in implementations:
            if not has_link_to(impl, decision_note):
                suggestions.append({
                    'source': impl.id,
                    'target': decision_note.id,
                    'pattern': 'decision_reference',
                    'suggested_text': f"Decision: [[{decision_note.id}]] - rationale for this approach"
                })

    # Pattern 2: Playbook → Examples
    for playbook in find_notes_by_type('playbook'):
        # Look for examples that should reference playbook
        examples = find_examples_of(playbook)
        for example in examples:
            if not has_link_to(example, playbook):
                suggestions.append({
                    'source': example.id,
                    'target': playbook.id,
                    'pattern': 'playbook_application',
                    'suggested_text': f"Applied: [[{playbook.id}]] - followed this playbook"
                })

    # Pattern 3: Synthesis → Source notes
    for synthesis in find_notes_by_type('synthesis'):
        # Ensure synthesis links back to all mentioned notes
        mentioned = extract_mentioned_notes(synthesis)
        linked = extract_linked_notes(synthesis)

        for note_id in mentioned - linked:
            suggestions.append({
                'source': synthesis.id,
                'target': note_id,
                'pattern': 'synthesis_source',
                'suggested_text': f"Add link to [[{note_id}]] which is mentioned in synthesis"
            })

    return suggestions
```

## Best Practices

1. **Link Liberally**: More links > fewer links
2. **Add Context**: Explain why links matter
3. **Maintain Bidirectionality**: Always create backlinks
4. **Validate Regularly**: Check for broken links weekly
5. **Use Semantic Types**: Not all links are equal
6. **Cluster Actively**: Let patterns emerge from connections
7. **Suggest Automatically**: AI should recommend links
8. **Visualize Periodically**: View graph structure monthly
9. **Prune Dead Links**: Remove or update broken references
10. **Evolve Structure**: Let graph inform organization

## Common Pitfalls

- **Over-linking**: Linking every mention dilutes signal
- **Under-contextualizing**: Links without explanation are opaque
- **Missing Backlinks**: One-way links break navigation
- **Stale Links**: Renamed notes create broken references
- **Wrong Semantics**: Using "extends" when you mean "see-also"
- **Ignoring Orphans**: Unconnected notes lose value
- **No Validation**: Broken links accumulate silently
