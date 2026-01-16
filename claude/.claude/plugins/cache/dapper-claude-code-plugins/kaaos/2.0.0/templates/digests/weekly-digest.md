---
template: weekly-digest
version: "1.0"
description: Template for automated weekly synthesis generation
usage: Used by synthesis agent to create Monday morning pattern analysis
placeholders:
  - "{{WEEK}}" - Week identifier (e.g., "2026-W03")
  - "{{WEEK_START}}" - Start date of week
  - "{{WEEK_END}}" - End date of week
  - "{{TIMESTAMP}}" - Generation timestamp (ISO-8601)
  - "{{EXECUTION_TIME}}" - Time to generate in seconds
  - "{{COST}}" - API cost for generation
---

# Weekly Digest Template

This template defines the structure for automated weekly synthesis. The synthesis agent uses this template to identify patterns, gaps, and prepare context for the upcoming week.

## Template Output

```markdown
# Weekly Synthesis - Week {{WEEK}}
*{{WEEK_START}} - {{WEEK_END}}*

## Week in Review

### Activity Summary
{{WEEKLY_STATS}}

### Narrative
{{NARRATIVE_SUMMARY}}

## Pattern Synthesis

### Emerging Patterns

{{#EACH PATTERN}}
#### {{PATTERN_TITLE}}
**Strength**: {{STRENGTH}} ({{OCCURRENCES}} occurrences)

**Evidence**:
{{#EACH EVIDENCE}}
- [[{{NOTE_ID}}]]: {{QUOTE}}
{{/EACH}}

**Implications**: {{IMPLICATIONS}}

**Suggested Action**: {{ACTION}}
{{/EACH}}

### Pattern Evolution
{{#EACH EVOLVING_PATTERN}}
- **{{PATTERN_NAME}}**: {{EVOLUTION_DESCRIPTION}}
  - Last week: {{PREVIOUS_STATE}}
  - This week: {{CURRENT_STATE}}
{{/EACH}}

## Knowledge Gaps Identified

{{#EACH GAP}}
### Gap {{INDEX}}: {{GAP_TITLE}}

**Description**: {{DESCRIPTION}}

**Evidence**:
{{#EACH EVIDENCE}}
- {{CONTEXT}}: "{{QUOTE}}"
{{/EACH}}

**Impact**: {{IMPACT_LEVEL}} - {{IMPACT_DESCRIPTION}}

**Suggested Resolution**:
{{RESOLUTION}}

**Priority**: {{PRIORITY}}
{{/EACH}}

## Knowledge Graph Health

### Metrics
{{GRAPH_METRICS}}

### Visualization
{{GRAPH_VISUALIZATION}}

### Recommendations
{{#EACH GRAPH_RECOMMENDATION}}
- {{RECOMMENDATION}}
{{/EACH}}

## Context for Next Week

### Upcoming Focus Areas
{{#EACH FOCUS_AREA}}
{{INDEX}}. **{{AREA_NAME}}**
   - Why: {{REASON}}
   - Key notes: {{RELEVANT_NOTES}}
   - Questions to explore: {{QUESTIONS}}
{{/EACH}}

### Scheduled Items
{{#EACH SCHEDULED}}
- {{DATE}}: {{DESCRIPTION}}
{{/EACH}}

### Recommended Actions
{{#EACH ACTION}}
- [ ] {{ACTION_DESCRIPTION}} (Priority: {{PRIORITY}})
{{/EACH}}

## Connections Made

### New Cross-References
{{#EACH CROSS_REF}}
- [[{{SOURCE}}]] <-> [[{{TARGET}}]]: {{REASON}}
{{/EACH}}

### Suggested Links (Not Yet Made)
{{#EACH SUGGESTED_LINK}}
- [[{{SOURCE}}]] -> [[{{TARGET}}]]: {{REASON}}
{{/EACH}}

---
*Generated: {{TIMESTAMP}} by synthesis-agent (Opus)*
*Execution time: {{EXECUTION_TIME}} seconds | Cost: ${{COST}}*
*Next synthesis: {{NEXT_RUN}}*
```

## Data Structures

### Weekly Stats Format

```yaml
weekly_stats:
  total_notes: 45           # Notes touched this week
  notes_created: 12         # New notes
  notes_updated: 33         # Modified notes
  decisions_made: 3         # Decisions recorded
  insights_extracted: 18    # Insights from commits/conversations
  cross_references_added: 24 # New [[links]] created
  projects_active: 4        # Projects with activity
  conversations: 15         # Claude conversations this week
```

Rendered as:
```markdown
| Metric | Count | vs Last Week |
|--------|-------|--------------|
| Notes created | 12 | +4 |
| Notes updated | 33 | -2 |
| Decisions | 3 | +1 |
| Insights | 18 | +6 |
| Cross-references | 24 | +8 |
| Active projects | 4 | = |
```

### Pattern Strength Levels

| Level | Occurrences | Description |
|-------|-------------|-------------|
| Strong | 5+ | Clear, consistent pattern |
| Moderate | 3-4 | Emerging pattern |
| Weak | 2 | Potential pattern |

### Gap Impact Levels

| Level | Description |
|-------|-------------|
| Critical | Blocking decisions or progress |
| High | Significantly affects quality |
| Medium | Would improve understanding |
| Low | Nice to have |

## Generation Logic

### Pattern Detection

```python
def detect_patterns(knowledge_base, week_notes):
    """Detect emerging patterns from this week's work."""

    patterns = []

    # Collect all content for analysis
    content_corpus = []
    for note in week_notes:
        content_corpus.append({
            'id': note.id,
            'title': note.title,
            'content': note.content,
            'tags': note.tags,
            'created': note.created_at,
            'references': extract_references(note.content)
        })

    # Theme clustering
    # Group notes by topic similarity
    themes = cluster_by_theme(content_corpus)

    for theme in themes:
        if len(theme.notes) >= 2:  # At least 2 related notes
            patterns.append({
                'title': theme.name,
                'type': 'theme',
                'strength': calculate_strength(len(theme.notes)),
                'occurrences': len(theme.notes),
                'evidence': [
                    {'note_id': n.id, 'quote': extract_key_quote(n)}
                    for n in theme.notes[:3]
                ],
                'implications': generate_implications(theme),
                'action': suggest_action(theme)
            })

    # Decision pattern analysis
    decisions = [n for n in week_notes if n.type == 'decision']
    if len(decisions) >= 2:
        decision_patterns = analyze_decision_patterns(decisions)
        patterns.extend(decision_patterns)

    # Behavioral patterns (from conversation analysis)
    behavior_patterns = detect_behavioral_patterns(
        knowledge_base,
        week_start,
        week_end
    )
    patterns.extend(behavior_patterns)

    # Sort by strength
    patterns.sort(key=lambda p: p['occurrences'], reverse=True)

    return patterns[:5]  # Top 5 patterns
```

### Gap Detection

```python
def detect_gaps(knowledge_base, week_notes, patterns):
    """Identify knowledge gaps from this week's work."""

    gaps = []

    # Missing context gaps
    # Notes that reference undefined concepts
    for note in week_notes:
        undefined = find_undefined_references(note)
        for ref in undefined:
            gaps.append({
                'title': f"Missing: {ref}",
                'type': 'missing_context',
                'description': f"Referenced in {note.id} but not defined",
                'evidence': [{'context': note.title, 'quote': extract_context(note, ref)}],
                'impact': 'medium',
                'resolution': f"Create note defining '{ref}' or link to existing note",
                'priority': 'medium'
            })

    # Decision prerequisite gaps
    # Decisions made without documented context
    decisions = [n for n in week_notes if n.type == 'decision']
    for decision in decisions:
        if not has_sufficient_context(decision, knowledge_base):
            gaps.append({
                'title': f"Context gap for {decision.title}",
                'type': 'decision_context',
                'description': "Decision made without full documented context",
                'evidence': [{'context': 'Decision analysis', 'quote': decision.summary}],
                'impact': 'high',
                'resolution': "Document the alternatives considered and reasoning",
                'priority': 'high'
            })

    # Pattern gaps
    # Areas where patterns suggest missing knowledge
    for pattern in patterns:
        implied_topics = infer_related_topics(pattern)
        for topic in implied_topics:
            if not topic_exists(knowledge_base, topic):
                gaps.append({
                    'title': f"Implied topic: {topic}",
                    'type': 'implied_topic',
                    'description': f"Pattern '{pattern['title']}' implies need for {topic}",
                    'evidence': pattern['evidence'][:2],
                    'impact': 'low',
                    'resolution': f"Consider creating note about '{topic}'",
                    'priority': 'low'
                })

    # Deduplicate and sort by impact
    gaps = deduplicate_gaps(gaps)
    impact_order = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3}
    gaps.sort(key=lambda g: impact_order[g['impact']])

    return gaps[:10]  # Top 10 gaps
```

### Graph Health Analysis

```python
def analyze_graph_health(repo_path):
    """Analyze knowledge graph health metrics."""

    # Run graph-metrics.sh
    result = subprocess.run(
        [f"{repo_path}/.kaaos/scripts/graph-metrics.sh", repo_path, "--json"],
        capture_output=True,
        text=True
    )

    metrics = json.loads(result.stdout)

    # Generate recommendations
    recommendations = []

    # Orphan recommendations
    if metrics['orphan_count'] > 5:
        recommendations.append(
            f"Review {metrics['orphan_count']} orphaned notes - consider linking or archiving"
        )

    # Connectivity recommendations
    if metrics['average_connectivity'] < 2.0:
        recommendations.append(
            "Low connectivity (avg {:.1f} refs/note) - add more cross-references".format(
                metrics['average_connectivity']
            )
        )

    # Hub recommendations
    if metrics['hub_count'] < 3:
        recommendations.append(
            "Few hub notes - consider creating more map/index notes"
        )

    return {
        'metrics': metrics,
        'visualization': generate_graph_ascii(metrics),
        'recommendations': recommendations
    }
```

## Example Output

```markdown
# Weekly Synthesis - Week 2026-W03
*January 13 - January 19, 2026*

## Week in Review

### Activity Summary
| Metric | Count | vs Last Week |
|--------|-------|--------------|
| Notes created | 12 | +4 |
| Notes updated | 33 | -2 |
| Decisions | 3 | +1 |
| Insights | 18 | +6 |
| Cross-references | 24 | +8 |
| Active projects | 4 | = |

### Narrative
This week focused heavily on Q1 planning and hiring decisions. Three major decisions were made regarding team structure, sprint cadence, and marketing budget. A strong pattern emerged around async-first practices, with multiple notes reinforcing the benefits of asynchronous communication. The knowledge graph grew significantly with 24 new cross-references, particularly around decision frameworks.

## Pattern Synthesis

### Emerging Patterns

#### Async-First Communication
**Strength**: Strong (5 occurrences)

**Evidence**:
- [[2026-01-050]]: "Async standups save 7.5 hours/week for the team"
- [[2026-01-062]]: "Written decision memos outperform verbal discussions"
- [[PLAY-remote-async]]: "Default to async unless synchronous is clearly better"

**Implications**: Team is naturally gravitating toward async practices. This aligns with remote-first culture goals. May need formal async-first policy.

**Suggested Action**: Create [[PLAY-async-first-policy]] playbook documenting best practices.

#### Decision Framework Combination
**Strength**: Moderate (3 occurrences)

**Evidence**:
- [[DEC-2026-003]]: Combined pre-mortem with reversibility analysis
- [[DEC-2026-004]]: Used 2-way door + stakeholder matrix together
- [[2026-01-048]]: "Frameworks work better when combined contextually"

**Implications**: Single frameworks are less useful than combinations. Consider documenting effective combinations.

**Suggested Action**: Add "Framework Combinations" section to [[MAP-decision-frameworks]].

### Pattern Evolution
- **Meeting Efficiency**: Last week: Ad-hoc agendas -> This week: Pre-read requirement gaining traction
- **Knowledge Capture**: Last week: Post-hoc documentation -> This week: Real-time note-taking during meetings

## Knowledge Gaps Identified

### Gap 1: Work Sample Evaluation Rubric

**Description**: Hiring process references work samples but no evaluation criteria documented.

**Evidence**:
- Decision [[DEC-2026-003]]: "Include work sample in interview process"
- Note [[2026-01-055]]: "Need consistent evaluation across candidates"

**Impact**: High - Without rubric, evaluations may be inconsistent.

**Suggested Resolution**:
Create [[PLAY-work-sample-evaluation]] with:
- Evaluation criteria by role type
- Scoring rubric (1-5 scale with examples)
- Red flags and green flags
- Comparison framework for multiple candidates

**Priority**: High

### Gap 2: Budget Approval Process

**Description**: Multiple budget decisions made but no documented approval workflow.

**Evidence**:
- [[2026-01-055]]: Budget approved via Slack thread
- [[2026-01-062]]: Budget approved in meeting without record

**Impact**: Medium - Lack of documentation may cause confusion.

**Suggested Resolution**:
Document approval thresholds and process in [[PLAY-budget-approval]].

**Priority**: Medium

## Knowledge Graph Health

### Metrics
| Metric | Value | Status |
|--------|-------|--------|
| Total notes | 156 | Good |
| Total references | 423 | Good |
| Orphaned notes | 8 | Attention needed |
| Hub notes | 7 | Good |
| Average connectivity | 2.71 | Good |
| Graph density | 0.0175 | Normal |

### Visualization
```
Knowledge Graph Structure (156 notes, 423 connections)

Hub Notes (>10 connections):
  MAP-decision-frameworks ████████████████████ 24
  PLAY-hiring-process     ███████████████     18
  2026-01-050             █████████████       15
  MAP-projects            ████████████        14
  PLAY-quarterly-planning ███████████         13

Orphaned Notes (8):
  - archive/2025-draft-idea.md
  - notes/scratch-pad.md
  - projects/old-project/meeting-notes.md
  ... and 5 more
```

### Recommendations
- Review 8 orphaned notes - consider linking to relevant maps or archiving
- [[2026-01-035]] hasn't been accessed in 45 days - evaluate relevance
- Consider creating hub note for "async communication" theme (5 related notes)

## Context for Next Week

### Upcoming Focus Areas
1. **Q1 Planning Finalization**
   - Why: Q1 officially starts Jan 20
   - Key notes: [[PLAY-quarterly-planning]], [[2026-01-048]]
   - Questions to explore: What are the Q1 OKRs? How do we measure success?

2. **Frontend Hiring**
   - Why: Job posting went live, expect candidates
   - Key notes: [[DEC-2026-003]], [[PLAY-hiring-process]]
   - Questions to explore: Work sample design? Interview panel composition?

3. **Marketing Experiment Review**
   - Why: Week 1 of Reddit experiment complete
   - Key notes: [[2026-01-062]]
   - Questions to explore: Initial metrics? Pivot needed?

### Scheduled Items
- Jan 20: Q1 kickoff meeting
- Jan 22: First frontend candidate interviews (tentative)
- Jan 24: Marketing experiment week 1 review

### Recommended Actions
- [ ] Create work sample evaluation rubric (Priority: High)
- [ ] Document budget approval process (Priority: Medium)
- [ ] Review 8 orphaned notes (Priority: Low)
- [ ] Add async-first playbook (Priority: Medium)

## Connections Made

### New Cross-References
- [[2026-01-050]] <-> [[PLAY-remote-async]]: Sprint cadence supports async-first
- [[DEC-2026-003]] <-> [[PLAY-hiring-process]]: Decision references playbook
- [[2026-01-062]] <-> [[2026-01-020]]: Experiment uses two-way door framework

### Suggested Links (Not Yet Made)
- [[2026-01-055]] -> [[PLAY-compensation-philosophy]]: Budget aligns with comp philosophy
- [[2026-01-048]] -> [[MAP-quarterly-rhythm]]: Weekly priorities feed into quarterly

---
*Generated: 2026-01-20T06:00:00-08:00 by synthesis-agent (Opus)*
*Execution time: 45 seconds | Cost: $0.85*
*Next synthesis: 2026-01-27 06:00 AM*
```

## Configuration Options

```yaml
rhythms:
  weekly:
    enabled: true
    weekday: 1  # Monday
    hour: 6
    minute: 0

    include:
      activity_summary: true
      pattern_synthesis: true
      gap_analysis: true
      graph_health: true
      next_week_prep: true
      connections: true

    pattern_detection:
      min_occurrences: 2    # Minimum for pattern
      max_patterns: 5       # Top N patterns to show
      include_behavioral: true

    gap_detection:
      max_gaps: 10          # Top N gaps to show
      include_implied: true # Include implied topics

    graph_analysis:
      include_visualization: true
      orphan_threshold: 5   # Flag if more than N orphans
```

## Related Templates

- [[daily-digest.md]] - Daily activity summary
- [[monthly-digest.md]] - Monthly strategic review
- [[quarterly-digest.md]] - Quarterly comprehensive analysis

---

*Part of KAAOS Operational Rhythms*
