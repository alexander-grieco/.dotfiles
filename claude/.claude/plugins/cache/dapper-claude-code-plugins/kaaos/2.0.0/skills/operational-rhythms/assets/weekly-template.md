# Weekly Synthesis Template

Template for automated weekly synthesis generation. This template is used by the synthesis agent (Opus) to create weekly pattern extraction and strategic recommendations.

## Template Structure

```markdown
# Weekly Synthesis - Week [N], [Year] ([Date Range])

## Executive Summary

[One paragraph summarizing the week]

**This Week's Numbers**:
- 📝 [X] notes created (↑/↓[X] from last week)
- ✏️  [X] notes updated
- 🔗 [X] new cross-references added
- 💡 [X] insights extracted
- ✅ [X] decisions documented

**Time Investment**:
- [X] hours in documented work sessions
- [X] hours in synthesis/reflection
- [X] meetings with pre-reads (saved ~[X] hours)

## Emerging Patterns

### Pattern [N]: [Pattern Name]
**Frequency**: [X] applications across [Y] projects
**Insight**: [One-sentence pattern description]

**Evidence**:
[FOR EACH EVIDENCE ITEM]
[N]. [[note-id|Note Title]]
   - [Specific evidence from note]
   - [Why this matters]

**Pattern Analysis**:
[Deeper analysis of what this pattern means]

**Recommendation**: [Specific actionable recommendation]

## Key Outcomes This Week

### Decisions Made

[FOR EACH DECISION]
[N]. **[[decision-id|Decision Title]]**
   - Status: [proposed|decided|implemented]
   - [Key details]
   - Next: [Next steps]

### Playbooks Applied

[FOR EACH PLAYBOOK USED]
[N]. **[[playbook-id|Playbook Title]]** - [Context where applied]
   - Outcome: ✅/❌ [Success/failure description]
   - Adaptation: [Any modifications made]
   - Update: [Changes to playbook]

### Experiments

[FOR EACH ACTIVE EXPERIMENT]
[N]. **[Experiment Name]** ([Status])
   - Status: [Week X of Y-week trial]
   - Early signal: [Positive/negative/mixed]
   - Monitor: [What we're tracking]
   - Review: [Review date]

## Knowledge Updates

### New Notes Created ([Count])

**[Category]** ([Count]):
[FOR EACH NOTE IN CATEGORY]
- [[note-id|Title]] - [Brief description]

### Notes Updated ([Count])

[FOR EACH UPDATED NOTE]
- [[note-id|Title]] ← [What changed]

### Cross-References Added ([Count])

**Densest clusters**:
[FOR EACH CLUSTER]
- [Topic]: [X] cross-references

**Suggested connections** (not yet made):
[FOR EACH SUGGESTION]
- [[source-note]] → [[target-note]] ([Reason])

### Map Notes Requiring Updates

[FOR EACH MAP NEEDING UPDATE]
[N]. **[[map-id|Map Title]]** - [Why update needed]
   - [Details of what needs adding]
   - Recommend: [Specific recommendation]

## Recommended Actions

### High Priority (This Week)

[FOR EACH HIGH PRIORITY ACTION]
- [ ] **[Action description]**
  - [Details/rationale]
  - Estimated time: [X hours]
  - Value: [Expected value]
  - Owner: [Who should do this]

### Medium Priority (Next Week)

[FOR EACH MEDIUM PRIORITY ACTION]
- [ ] **[Action description]**
  - [Details]
  - Estimated time: [X hours]

### Low Priority (Eventually)

[FOR EACH LOW PRIORITY ACTION]
- [ ] **[Action description]**
  - [Details]

## Next Week Preview

### Scheduled
[FOR EACH SCHEDULED ITEM]
- [Day]: [Item description]

### Priorities
[FOR EACH PRIORITY]
[N]. [Priority description]

### Context Loaded
All relevant notes linked above will be loaded in Monday's session.

---

## Meta: This Synthesis

**Generated**: [Timestamp] by synthesis-agent (Opus)
**Execution time**: [X] min [Y] sec
**Cost**: $[Amount]
**Notes analyzed**: [X] new, [Y] updated, [Z] conversations scanned
**Patterns identified**: [N] ([breakdown])
**Recommendations**: [N] ([X] high, [Y] medium, [Z] low priority)

**Value delivered**:
[FOR EACH VALUE ITEM]
- [Value description]

**Next synthesis**: [Next Monday's date]
```

## Agent Implementation

```python
def generate_weekly_synthesis(week):
    """Generate weekly synthesis for specified week."""

    knowledge_base = load_knowledge_base()

    # Get week's activity
    notes_created = find_notes_created_in_week(knowledge_base, week)
    notes_updated = find_notes_updated_in_week(knowledge_base, week)
    conversations = find_conversations_in_week(knowledge_base, week)
    commits = find_commits_in_week(knowledge_base, week)

    synthesis = {
        'week': week,
        'activity': {
            'notes_created': notes_created,
            'notes_updated': notes_updated,
            'conversations': conversations,
            'commits': commits
        },
        'patterns': [],
        'outcomes': {},
        'updates': {},
        'recommendations': []
    }

    # Pattern extraction (core value of weekly synthesis)
    synthesis['patterns'] = extract_patterns(
        notes_created,
        notes_updated,
        conversations,
        min_frequency=2
    )

    # Key outcomes
    synthesis['outcomes'] = extract_outcomes(
        notes_created,
        conversations
    )

    # Knowledge updates
    synthesis['updates'] = summarize_knowledge_updates(
        notes_created,
        notes_updated
    )

    # Recommendations
    synthesis['recommendations'] = generate_recommendations(
        synthesis['patterns'],
        synthesis['outcomes'],
        synthesis['updates'],
        knowledge_base
    )

    # Render using template
    return render_template('weekly-synthesis.md', synthesis)
```

## Pattern Extraction

```python
def extract_patterns(notes, updated_notes, conversations, min_frequency=2):
    """Extract patterns from week's work."""

    all_content = []

    # Combine content
    for note in notes:
        all_content.append({
            'type': 'note',
            'id': note.id,
            'title': note.title,
            'content': note.content,
            'tags': note.tags
        })

    for note in updated_notes:
        all_content.append({
            'type': 'update',
            'id': note.id,
            'title': note.title,
            'content': get_note_diff(note),
            'tags': note.tags
        })

    for conv in conversations:
        insights = extract_conversation_insights(conv)
        all_content.extend(insights)

    # Method 1: Frequency-based patterns
    frequent_patterns = detect_frequent_concepts(
        all_content,
        min_frequency=min_frequency
    )

    # Method 2: Semantic similarity patterns
    semantic_patterns = detect_semantic_clusters(
        all_content,
        similarity_threshold=0.75
    )

    # Method 3: Tag-based patterns
    tag_patterns = detect_tag_cooccurrence(
        all_content,
        min_cooccurrence=min_frequency
    )

    # Combine and rank patterns
    all_patterns = frequent_patterns + semantic_patterns + tag_patterns
    ranked_patterns = rank_patterns_by_significance(all_patterns)

    # Generate pattern objects
    patterns = []
    for p in ranked_patterns[:5]:  # Top 5 patterns
        pattern = {
            'name': generate_pattern_name(p),
            'frequency': p['frequency'],
            'notes': p['notes'],
            'insight': synthesize_pattern_insight(p),
            'analysis': analyze_pattern_significance(p),
            'recommendation': generate_pattern_recommendation(p)
        }
        patterns.append(pattern)

    return patterns

def detect_frequent_concepts(content, min_frequency=2):
    """Detect frequently occurring concepts."""

    concept_map = defaultdict(list)

    for item in content:
        concepts = extract_key_concepts(item['content'])

        for concept in concepts:
            concept_map[concept].append(item)

    # Filter by frequency
    patterns = []
    for concept, items in concept_map.items():
        if len(items) >= min_frequency:
            patterns.append({
                'type': 'frequent',
                'concept': concept,
                'frequency': len(items),
                'notes': items,
                'significance': calculate_concept_significance(concept, items)
            })

    return patterns

def detect_semantic_clusters(content, similarity_threshold=0.75):
    """Detect semantic similarity clusters."""

    from sentence_transformers import SentenceTransformer
    from sklearn.cluster import DBSCAN

    model = SentenceTransformer('all-MiniLM-L6-v2')

    # Generate embeddings
    texts = [f"{item['title']} {item['content'][:500]}" for item in content]
    embeddings = model.encode(texts)

    # Cluster
    clustering = DBSCAN(
        eps=1 - similarity_threshold,
        min_samples=2,
        metric='cosine'
    )

    labels = clustering.fit_predict(embeddings)

    # Extract clusters
    clusters = defaultdict(list)
    for idx, label in enumerate(labels):
        if label != -1:  # Ignore noise
            clusters[label].append(content[idx])

    # Convert to patterns
    patterns = []
    for cluster_id, items in clusters.items():
        if len(items) >= 2:
            patterns.append({
                'type': 'semantic',
                'cluster_id': cluster_id,
                'frequency': len(items),
                'notes': items,
                'significance': calculate_cluster_cohesion(items, embeddings)
            })

    return patterns
```

## Outcome Extraction

```python
def extract_outcomes(notes, conversations):
    """Extract key outcomes from week."""

    outcomes = {
        'decisions': [],
        'playbooks_used': [],
        'experiments': []
    }

    # Extract decisions
    for note in notes:
        if note.type == 'decision' or 'DEC-' in note.id:
            outcomes['decisions'].append({
                'note_id': note.id,
                'title': note.title,
                'status': note.metadata.get('status', 'decided'),
                'summary': note.summary,
                'next_steps': extract_next_steps(note)
            })

    # Extract playbook usage
    for note in notes:
        refs = extract_references(note.content)
        for ref in refs:
            if ref.startswith('PLAY-'):
                # Find how playbook was used
                usage_context = extract_playbook_usage_context(note, ref)

                if usage_context:
                    outcomes['playbooks_used'].append({
                        'playbook_id': ref,
                        'context_note': note.id,
                        'usage_context': usage_context,
                        'outcome': extract_outcome_from_context(usage_context),
                        'adaptation': extract_adaptation(usage_context)
                    })

    # Extract experiments
    for note in notes:
        if 'experiment' in note.title.lower() or 'trial' in note.title.lower():
            outcomes['experiments'].append({
                'note_id': note.id,
                'title': note.title,
                'status': extract_experiment_status(note),
                'early_signal': extract_early_signal(note),
                'metrics': extract_experiment_metrics(note)
            })

    return outcomes
```

## Recommendation Generation

```python
def generate_recommendations(patterns, outcomes, updates, knowledge_base):
    """Generate actionable recommendations."""

    recommendations = []

    # From patterns: Create artifacts
    for pattern in patterns:
        if pattern['frequency'] >= 3:
            # Suggest playbook creation
            if pattern['type'] == 'frequent' and 'process' in pattern['concept'].lower():
                recommendations.append({
                    'priority': 'high',
                    'type': 'create_playbook',
                    'title': f"Create playbook for {pattern['concept']}",
                    'rationale': f"Pattern appears {pattern['frequency']}x across multiple contexts",
                    'estimated_time': '2-3 hours',
                    'value': f"Save time on repeated process",
                    'notes': pattern['notes']
                })

            # Suggest map note creation
            if len(pattern['notes']) >= 5:
                recommendations.append({
                    'priority': 'medium',
                    'type': 'create_map',
                    'title': f"Create map note for {pattern['concept']}",
                    'rationale': f"{len(pattern['notes'])} related notes need organization",
                    'estimated_time': '1 hour',
                    'notes': pattern['notes']
                })

    # From outcomes: Follow-up actions
    for decision in outcomes['decisions']:
        if decision.get('next_steps'):
            for step in decision['next_steps']:
                if not step.get('completed'):
                    recommendations.append({
                        'priority': 'high',
                        'type': 'decision_followup',
                        'title': step['description'],
                        'rationale': f"Follow-up from [[{decision['note_id']}]]",
                        'estimated_time': step.get('estimated_time', '1 hour'),
                        'owner': step.get('owner', 'You')
                    })

    # From updates: Maintenance actions
    broken_links = find_broken_links_in_updates(updates)
    if broken_links:
        recommendations.append({
            'priority': 'medium',
            'type': 'fix_links',
            'title': f"Fix {len(broken_links)} broken links",
            'rationale': "Link validation detected broken references",
            'estimated_time': '30 minutes',
            'links': broken_links
        })

    # From knowledge gaps: Creation actions
    gaps = detect_knowledge_gaps(patterns, knowledge_base)
    for gap in gaps:
        recommendations.append({
            'priority': 'medium' if gap['severity'] == 'high' else 'low',
            'type': 'fill_gap',
            'title': f"Document {gap['topic']}",
            'rationale': gap['rationale'],
            'estimated_time': gap['estimated_time']
        })

    # Sort by priority
    priority_order = {'high': 0, 'medium': 1, 'low': 2}
    recommendations.sort(key=lambda x: priority_order[x['priority']])

    return recommendations
```

## Configuration

```yaml
# .kaaos/config.yaml
rhythms:
  weekly:
    enabled: true
    weekday: 1  # Monday (0=Sunday)
    hour: 6
    minute: 0

    # Pattern detection
    pattern_detection:
      min_frequency: 2
      semantic_similarity_threshold: 0.75
      min_cluster_size: 3
      max_patterns: 5

    # Outcome extraction
    outcomes:
      extract_decisions: true
      track_playbook_usage: true
      monitor_experiments: true

    # Recommendations
    recommendations:
      suggest_playbooks: true
      suggest_map_notes: true
      identify_gaps: true
      flag_broken_links: true
      max_high_priority: 5
      max_medium_priority: 10

    # Knowledge updates
    updates:
      summarize_new_notes: true
      summarize_updated_notes: true
      track_cross_references: true
      suggest_connections: true

    # Output
    output_path: ".digests/weekly/"
    format: markdown
    create_todo_list: true  # Create TODO list from recommendations
    notify: true
```

## Usage

### Manual Generation

```bash
# Generate for current week
/kaaos:review weekly

# Generate for specific week
/kaaos:review weekly 2026-W02

# View most recent
/kaaos:digest weekly --view
```

### Automated Generation

Runs automatically Monday mornings:

```xml
<!-- ~/Library/LaunchAgents/com.kaaos.weekly.plist -->
<key>StartCalendarInterval</key>
<dict>
    <key>Weekday</key>
    <integer>1</integer>  <!-- Monday -->
    <key>Hour</key>
    <integer>6</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

### Integration with Planning

```bash
# Monday morning routine
alias monday='
  echo "=== Weekly Synthesis ===" &&
  cat ~/.kaaos-knowledge/.digests/weekly/$(date +%Y-W%V).md | less &&
  echo "=== Planning This Week ===" &&
  /kaaos:session personal --strategic
'
```

## Best Practices

1. **Review Monday Morning**: Start week with synthesis
2. **Act on High Priority**: Complete recommendations this week
3. **Create Artifacts**: Turn patterns into playbooks/maps
4. **Track Progress**: Note which recommendations completed
5. **Update Playbooks**: Incorporate adaptations
6. **Close Loops**: Follow up on decisions
7. **Celebrate Wins**: Acknowledge what worked

## Common Issues

### Synthesis Too Long

**Problem**: Synthesis overwhelming, too much detail

**Solution**:
- Reduce `max_patterns` to 3
- Set `max_high_priority` to 3
- Disable `summarize_updated_notes`
- Set pattern `min_frequency` to 3

### Missing Patterns

**Problem**: Expected patterns not detected

**Solution**:
- Lower `min_frequency` to 1
- Lower `semantic_similarity_threshold` to 0.70
- Check that notes have proper tags
- Verify notes are in scope (correct date range)

### Too Many Recommendations

**Problem**: Recommendations list overwhelming

**Solution**:
- Reduce `max_high_priority` and `max_medium_priority`
- Disable less useful recommendation types
- Increase thresholds for pattern significance

## Value Tracking

Track value delivered by weekly synthesis:

```python
def calculate_synthesis_value(synthesis, next_week_activity):
    """Calculate value delivered by synthesis."""

    value = {
        'time_saved': 0,
        'decisions_informed': 0,
        'artifacts_created': 0,
        'gaps_filled': 0
    }

    # Check recommendations completed
    for rec in synthesis['recommendations']:
        if was_recommendation_completed(rec, next_week_activity):
            value['time_saved'] += rec.get('estimated_time_saved', 0)

            if rec['type'] == 'create_playbook':
                value['artifacts_created'] += 1
            elif rec['type'] == 'fill_gap':
                value['gaps_filled'] += 1

    # Check if patterns informed decisions
    for decision in next_week_activity['decisions']:
        referenced_patterns = extract_referenced_patterns(
            decision,
            synthesis['patterns']
        )
        if referenced_patterns:
            value['decisions_informed'] += 1

    return value
```

Monthly report on synthesis value:

```markdown
## Weekly Synthesis Value - January 2026

**Synthesizes Generated**: 4
**Total Cost**: $19.40 (~$4.85 per synthesis)

**Value Delivered**:
- Time saved: 18 hours (from completed recommendations)
- Decisions informed: 7 (referenced synthesis patterns)
- Artifacts created: 3 playbooks, 2 map notes
- Knowledge gaps filled: 5

**ROI**: ~37x (18 hours * $100/hr effective rate / $19.40 cost)

**Most Valuable Patterns**:
1. "Decision frameworks in practice" → Created decision playbook, saved 8 hours
2. "Async communication maturing" → Standardized across teams, saved 7.5 hours/week
3. "Knowledge gaps in hiring" → Created hiring playbook, saved 5 hours per hire
```
