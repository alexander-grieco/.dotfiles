# Weekly Rhythm Patterns

Detailed patterns for weekly synthesis including pattern extraction, playbook updates, and strategic adjustments.

## Weekly Rhythm Structure

### Time Commitment
- **Agent Generation**: 3-5 minutes (automated)
- **Human Review**: 30-60 minutes (Monday morning)
- **Actions**: Spread across week

### Agent: Synthesis Agent (Opus)
- **Focus**: Pattern extraction across week's work
- **Cost**: ~$4-5 per run
- **Frequency**: Every Monday at 6:00 AM

## Pattern Extraction Methodology

### Semantic Clustering

```python
def extract_weekly_patterns(notes, conversations, min_frequency=2):
    """Extract patterns from week's work."""

    # Combine notes and conversation insights
    all_content = notes + extract_insights(conversations)

    # Generate embeddings
    embeddings = embed_content(all_content)

    # Cluster by semantic similarity
    clusters = cluster_embeddings(
        embeddings,
        min_cluster_size=min_frequency,
        similarity_threshold=0.75
    )

    patterns = []
    for cluster in clusters:
        pattern = {
            'name': generate_pattern_name(cluster),
            'frequency': len(cluster),
            'notes': [note.id for note in cluster],
            'insight': synthesize_cluster_insight(cluster),
            'recommendation': generate_recommendation(cluster)
        }
        patterns.append(pattern)

    return patterns
```

### Pattern Types

**Decision Patterns**: Similar decision-making situations
```python
# Example detection
if cluster_contains_multiple_decisions(cluster):
    pattern_type = 'decision'
    recommendation = suggest_decision_framework(cluster)
```

**Process Patterns**: Repeated workflows
```python
if cluster_shows_repeated_process(cluster):
    pattern_type = 'process'
    recommendation = suggest_playbook_creation(cluster)
```

**Problem Patterns**: Recurring challenges
```python
if cluster_indicates_recurring_problem(cluster):
    pattern_type = 'problem'
    recommendation = suggest_solution_documentation(cluster)
```

**Learning Patterns**: Knowledge building
```python
if cluster_shows_learning_progression(cluster):
    pattern_type = 'learning'
    recommendation = suggest_consolidation(cluster)
```

## Full Example Weekly Digest

```markdown
# Weekly Synthesis - Week 2, 2026 (Jan 8-14)

## Executive Summary

Productive week with strong focus on product planning and team processes. **Key pattern**: Decision-making frameworks being consistently applied across projects. **Recommendation**: Consolidate into unified playbook.

**This Week's Numbers**:
- 📝 12 notes created (↑3 from last week)
- ✏️  8 notes updated
- 🔗 47 new cross-references added
- 💡 15 insights extracted
- ✅ 4 decisions documented

**Time Investment**:
- 8.5 hours in documented work sessions
- 2.5 hours in synthesis/reflection
- 4 meetings with pre-reads (saved ~3 hours)

## Emerging Patterns

### Pattern 1: Decision Frameworks in Practice
**Frequency**: 4 applications across 3 projects
**Insight**: Pre-mortems + reversibility analysis appearing consistently

**Evidence**:
1. [[2026-01-050|Sprint Cadence Decision]]
   - Used pre-mortem to identify planning risks
   - Categorized by reversibility (2-week = easily reversible)
   - Result: Confident decision in 30 min vs usual 2+ hour debate

2. [[2026-01-055|Hiring Budget Approval]]
   - Pre-mortem revealed cash flow timing issue
   - Classified as one-way door, involved CFO early
   - Result: Caught potential Q2 cash crunch

3. [[DEC-2026-003|Frontend Lead Hire]]
   - Reversibility analysis justified senior vs mid-level
   - Pre-mortem identified onboarding risk
   - Result: Accelerated onboarding plan created

4. [[2026-01-062|Marketing Channel Experiment]]
   - Explicitly framed as two-way door
   - Small bet approach ($5K test budget)
   - Result: Faster approval, clear kill criteria

**Pattern Analysis**:
Teams are naturally combining [[2026-01-001|Pre-Mortem Analysis]] with [[2026-01-020|Decision Reversibility Framework]]. This wasn't prescribed—it emerged from practice.

**Recommendation**: Create [[PLAY-decision-making|Unified Decision-Making Playbook]] combining these frameworks. Estimated time saved: 2-4 hours per major decision.

### Pattern 2: Async Communication Maturing
**Frequency**: 6 instances across 2 teams
**Insight**: Meeting pre-reads + async standups significantly improving velocity

**Evidence**:
1. **Product Team** adopted [[2026-01-075|Meeting Pre-Read Practice]]
   - 3 meetings this week with 24hr pre-reads
   - Avg meeting time: 60 min → 35 min
   - Decision quality: subjectively "much better"
   - All participants confirmed pre-read completion

2. **Engineering Team** transitioned to async standups
   - Daily Slack updates replace 15-min standup
   - Time saved: 75 min/week × 6 people = 7.5 hours
   - Blocker resolution time: unchanged (same day)
   - Team satisfaction: 8/10 (survey)

3. **Leadership Team** experimenting with async decision docs
   - Used for 2 decisions this week
   - Comments replaced back-and-forth
   - Decision time: 3 days async vs 1 week with meetings

**Pattern Analysis**:
Async-first communication is working when:
- ✅ Clear artifacts (pre-reads, decision docs, status updates)
- ✅ Response time expectations set (24 hours)
- ✅ Synchronous reserved for true collaboration
- ❌ Doesn't work for brainstorming (still need real-time)

**Recommendation**: Document as [[PATT-async-communication|Async Communication Pattern]] with success criteria. Consider consolidating all practices into [[PLAY-remote-async-excellence|Remote Async Excellence Playbook]].

### Pattern 3: Knowledge Gaps in Hiring
**Frequency**: 3 references to missing documentation
**Insight**: Hiring process underdocumented, causing repeated work

**Evidence**:
1. Frontend Lead hire required recreating work sample
   - Previous work samples not documented
   - Spent 2 hours recreating from memory

2. Interview questions lack scoring rubrics
   - Each interviewer scores differently
   - Hard to compare candidates

3. Offer negotiation strategy not documented
   - Compensation bands unclear
   - Each offer feels like first rodeo

**Pattern Analysis**:
This is a **knowledge gap**, not an active pattern. Hiring happens infrequently enough that knowledge decays between cycles.

**Recommendation**: Create comprehensive [[PLAY-hiring-process|Hiring Process Playbook]] including:
- Work sample library with scoring rubrics
- Interview question bank with evaluation criteria
- Offer negotiation framework with compensation bands
- Onboarding checklist template

**Priority**: High (next hire starts in 2 weeks)

## Key Outcomes This Week

### Decisions Made

1. **[[DEC-2026-003|Hire Frontend Lead]]**
   - Status: Approved, job posted Monday
   - Budget: $140-160K + equity
   - Timeline: Onboard by Feb 15
   - Next: Screen applications by Jan 20

2. **[[2026-01-050|Sprint Cadence]]**
   - Status: Implemented, starting Jan 15
   - Cadence: 2-week sprints, async planning
   - Experiment: Review after 3 sprints (6 weeks)
   - Success metric: Team velocity stability

3. **[[2026-01-062|Marketing Channel Test]]**
   - Status: Approved $5K test budget
   - Channel: Reddit community engagement
   - Duration: 4 weeks
   - Kill criteria: <10 qualified leads

### Playbooks Applied

1. **[[PLAY-quarterly-planning]]** - Used for Q1 OKR finalization
   - Outcome: ✅ OKRs finalized, team aligned
   - Adaptation: Added pre-mortem step (worked well)
   - Update: Playbook updated with pre-mortem addition

2. **[[PLAY-weekly-review]]** - Personal weekly review
   - Outcome: ✅ Priorities clear for next week
   - Time: 45 minutes (on target)
   - Note: This synthesis makes weekly review faster

3. **[[2026-01-075|Meeting Pre-Read Practice]]** - Applied 3x
   - Outcome: ✅ All successful, significant time savings
   - Adoption: Product team wants to standardize
   - Next: Create team norm document

### Experiments

1. **Async Standups** (Engineering Team)
   - Status: Week 1 of 4-week trial
   - Early signal: Positive, saving time
   - Monitor: Blocker resolution time
   - Review: Feb 5

2. **Notion → Context Library Migration**
   - Status: 40% complete
   - Migrated: Strategy docs, meeting notes
   - Remaining: Product specs, design docs
   - Target: Complete by Jan 31

## Knowledge Updates

### New Notes Created (12)

**Strategic/Decisions (4)**:
- [[DEC-2026-003|Frontend Lead Hire]] - Major hiring decision
- [[2026-01-050|Sprint Cadence]] - Process decision
- [[2026-01-062|Marketing Channel Test]] - Experimental decision
- [[2026-01-068|Q1 OKR Finalization]] - Strategic alignment

**Frameworks/Practices (5)**:
- [[2026-01-075|Meeting Pre-Read Practice]] - 40% time savings
- [[2026-01-078|Async Standup Format]] - Daily update template
- [[2026-01-080|Work Sample Evaluation]] - Hiring framework
- [[2026-01-082|Decision Document Template]] - Async decisions
- [[2026-01-085|Compensation Framework]] - Offer negotiation

**Project-Specific (3)**:
- [[projects/product-launch/context-library/sprint-plan-1]]
- [[projects/product-launch/context-library/technical-architecture]]
- [[projects/q1-planning/context-library/okr-cascade]]

### Notes Updated (8)

- [[PLAY-quarterly-planning]] ← Added pre-mortem step
- [[MAP-decision-frameworks]] ← Added 3 new framework notes
- [[2026-01-001|Pre-Mortem Analysis]] ← Added 4 application examples
- [[2026-01-020|Decision Reversibility]] ← Added to MAP-decision-frameworks
- [[INDEX-00]] ← Updated statistics, added new notes
- [[MAP-hiring-system]] ← Linked new hiring notes (needs expansion)
- [[projects/product-launch/00-PROJECT-INDEX]] ← Weekly update
- [[PLAY-weekly-review]] ← Noted this synthesis makes it faster

### Cross-References Added (47)

**Densest clusters**:
- Decision framework notes: 12 cross-references
- Hiring process notes: 8 cross-references
- Async communication notes: 7 cross-references

**Suggested connections** (not yet made):
- [[2026-01-080|Work Sample Evaluation]] → [[PLAY-hiring-process]] (create playbook first)
- [[2026-01-082|Decision Document Template]] → [[PATT-async-communication]] (create pattern note)

### Map Notes Requiring Updates

1. **[[MAP-hiring-system]]** - Needs expansion
   - 3 new hiring notes this week
   - Currently sparse (4 notes total)
   - Recommend: Flesh out with new notes + create comprehensive playbook

2. **[[MAP-execution-patterns]]** - Add sprint planning
   - [[2026-01-050|Sprint Cadence Decision]] not yet linked
   - Should be under "Agile Practices" section

## Recommended Actions

### High Priority (This Week)

- [ ] **Create [[PLAY-decision-making|Unified Decision-Making Playbook]]**
  - Combine pre-mortem + reversibility frameworks
  - Include 4 examples from this week
  - Estimated time: 2 hours
  - Value: Save 2-4 hours per major decision
  - Owner: You

- [ ] **Create [[PLAY-hiring-process|Comprehensive Hiring Playbook]]**
  - Critical: Frontend lead hire starts Monday
  - Include: Work samples, interview questions, offer framework
  - Pull together existing notes ([[2026-01-080]], [[2026-01-085]], etc.)
  - Estimated time: 3 hours
  - Value: Save 5+ hours per hire, improve consistency
  - Owner: You + Hiring Manager

- [ ] **Document Async Communication Pattern**
  - Create [[PATT-async-communication]]
  - Success criteria: pre-reads, async standups, decision docs
  - When it works / doesn't work
  - Estimated time: 1 hour
  - Value: Enable replication across teams
  - Owner: You

### Medium Priority (Next Week)

- [ ] **Update [[MAP-hiring-system]]**
  - Link all new hiring notes
  - Expand structure
  - Estimated time: 30 min

- [ ] **Review [[2026-01-062|Marketing Channel Test]]**
  - Check in on Reddit engagement experiment
  - Review early metrics
  - Scheduled: Jan 22

- [ ] **Complete Notion Migration**
  - Remaining: Product specs, design docs
  - Target: Jan 31
  - Estimated time: 4 hours

### Low Priority (Eventually)

- [ ] **Consolidate Decision Framework Notes**
  - 4 related notes could be more tightly integrated
  - Create comprehensive decision-making map
  - Estimated time: 2 hours

- [ ] **Archive Old Meeting Notes**
  - Notes from before Dec 2025
  - Low reference frequency
  - Archive to keep main library clean

## Next Week Preview

### Scheduled
- Monday: Frontend candidate screening begins
- Wednesday: Q1 OKR finalization meeting (pre-read ready)
- Thursday: Monthly budget review
- Friday: Product sprint planning

### Priorities
1. Complete hiring playbook before screening
2. Create decision-making playbook (high value)
3. Continue Notion migration
4. Monitor async standup experiment

### Context Loaded
All relevant notes linked above will be loaded in Monday's session.

---

## Meta: This Synthesis

**Generated**: 2026-01-15 06:00 AM by synthesis-agent (Opus)
**Execution time**: 4 min 32 sec
**Cost**: $4.85
**Notes analyzed**: 12 new, 8 updated, 47 conversations scanned
**Patterns identified**: 3 (2 active, 1 gap)
**Recommendations**: 8 (3 high, 3 medium, 2 low priority)

**Value delivered**:
- Identified decision-making pattern saving 2-4 hours per decision
- Flagged hiring knowledge gap before next hire
- Validated async communication experiments
- Curated 8 actionable recommendations

**Next synthesis**: Monday, Jan 22, 2026
```

## Pattern Detection Algorithms

### Frequency-Based Detection

```python
def detect_frequent_patterns(notes, min_frequency=2):
    """Detect patterns appearing multiple times."""

    # Extract key concepts from each note
    concepts = []
    for note in notes:
        note_concepts = extract_concepts(note)
        concepts.extend(note_concepts)

    # Count concept frequency
    concept_counts = Counter(concepts)

    # Identify frequent concepts
    frequent = [
        concept for concept, count in concept_counts.items()
        if count >= min_frequency
    ]

    # Group notes by frequent concepts
    patterns = {}
    for concept in frequent:
        notes_with_concept = [
            note for note in notes
            if concept in extract_concepts(note)
        ]

        patterns[concept] = {
            'notes': notes_with_concept,
            'frequency': len(notes_with_concept),
            'insight': generate_insight(notes_with_concept, concept)
        }

    return patterns
```

### Semantic Similarity Detection

```python
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

def detect_semantic_patterns(notes, similarity_threshold=0.75):
    """Detect patterns using semantic similarity."""

    model = SentenceTransformer('all-MiniLM-L6-v2')

    # Generate embeddings
    texts = [f"{note.title} {note.summary}" for note in notes]
    embeddings = model.encode(texts)

    # Calculate pairwise similarity
    similarities = cosine_similarity(embeddings)

    # Find clusters of similar notes
    clusters = []
    visited = set()

    for i in range(len(notes)):
        if i in visited:
            continue

        # Find all notes similar to note i
        similar_indices = [
            j for j in range(len(notes))
            if similarities[i][j] >= similarity_threshold and i != j
        ]

        if len(similar_indices) >= 1:  # At least 2 total (i + similar)
            cluster = [notes[i]] + [notes[j] for j in similar_indices]
            clusters.append(cluster)
            visited.add(i)
            visited.update(similar_indices)

    return clusters
```

### Time-Based Pattern Detection

```python
def detect_temporal_patterns(notes, time_window_days=7):
    """Detect patterns in time-based clustering."""

    # Group notes by day
    by_day = defaultdict(list)
    for note in notes:
        day = note.created_date.date()
        by_day[day].append(note)

    # Look for repeated daily patterns
    daily_patterns = {}
    for day, day_notes in by_day.items():
        concepts = set()
        for note in day_notes:
            concepts.update(extract_concepts(note))

        # Check if these concepts repeat on other days
        repeat_days = [
            other_day for other_day, other_notes in by_day.items()
            if other_day != day and
            len(concepts & set(extract_concepts_from_notes(other_notes))) > 0
        ]

        if len(repeat_days) >= 2:  # Repeats on 2+ other days
            daily_patterns[day] = {
                'concepts': concepts,
                'repeat_days': repeat_days,
                'frequency': len(repeat_days) + 1
            }

    return daily_patterns
```

## Playbook Usage Tracking

### Automatic Detection

```python
def track_playbook_usage(notes, conversations):
    """Track which playbooks were applied this week."""

    playbooks = load_playbooks()
    usage = {}

    # Check explicit references in notes
    for note in notes:
        refs = extract_references(note.content)
        for ref in refs:
            if ref.startswith('PLAY-'):
                if ref not in usage:
                    usage[ref] = {
                        'playbook': load_note(ref),
                        'references': [],
                        'outcomes': []
                    }
                usage[ref]['references'].append(note)

    # Check conversation mentions
    for conv in conversations:
        for playbook_id in playbooks:
            if playbook_id in conv.content or playbook.title in conv.content:
                if playbook_id not in usage:
                    usage[playbook_id] = {
                        'playbook': load_note(playbook_id),
                        'references': [],
                        'outcomes': []
                    }
                # Extract outcome from conversation
                outcome = extract_playbook_outcome(conv, playbook_id)
                if outcome:
                    usage[playbook_id]['outcomes'].append(outcome)

    return usage
```

### Success Metrics

Track playbook effectiveness:

```python
def calculate_playbook_metrics(playbook_id, usage_history):
    """Calculate effectiveness metrics for a playbook."""

    metrics = {
        'times_used': len(usage_history),
        'outcomes': {
            'success': 0,
            'failure': 0,
            'mixed': 0
        },
        'avg_time_saved': 0,
        'adaptations': []
    }

    for usage in usage_history:
        # Categorize outcome
        if usage['outcome'] == 'success':
            metrics['outcomes']['success'] += 1
        elif usage['outcome'] == 'failure':
            metrics['outcomes']['failure'] += 1
        else:
            metrics['outcomes']['mixed'] += 1

        # Track time savings
        if 'time_saved' in usage:
            metrics['avg_time_saved'] += usage['time_saved']

        # Track adaptations
        if 'adaptation' in usage:
            metrics['adaptations'].append(usage['adaptation'])

    # Calculate averages
    metrics['success_rate'] = (
        metrics['outcomes']['success'] / metrics['times_used'] * 100
    )
    metrics['avg_time_saved'] /= metrics['times_used']

    return metrics
```

## Best Practices

1. **Review Monday Morning**: Start week with synthesis
2. **Act on High Priority Items**: Don't let recommendations accumulate
3. **Track Time Saved**: Measure value of patterns identified
4. **Update Playbooks Promptly**: Capture adaptations while fresh
5. **Create New Artifacts Quickly**: Convert recommendations to notes same week
6. **Monitor Experiments**: Check in on ongoing trials
7. **Celebrate Wins**: Note what worked well
8. **Learn from Failures**: Document what didn't work and why

## Common Pitfalls

- **Ignoring Recommendations**: Synthesis value is in action
- **Over-Analysis**: Synthesis should enable action, not replace it
- **Missing Context**: Review synthesis with relevant notes open
- **No Follow-Through**: Create artifacts recommended
- **Skipping Weeks**: Patterns harder to spot with gaps
- **Too Much Detail**: Keep synthesis actionable, not exhaustive
