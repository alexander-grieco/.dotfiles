# Review Session Template

Digest review session template for processing KAAOS automated reviews and taking action on identified items.

## Session Overview

| Attribute | Value |
|-----------|-------|
| **Purpose** | Review digests and process flagged items |
| **Duration** | 30-60 minutes typical |
| **Co-Pilot** | Not needed (structured review) |
| **Context Level** | Digest content + flagged items |
| **Cost Estimate** | $0.15-0.30 |

### When to Use Review Sessions

- Daily digest review (morning routine)
- Weekly synthesis review
- Monthly pattern analysis
- Quarterly strategic review
- Processing flagged attention items
- Reviewing maintenance recommendations
- Acting on gap analysis findings

### When NOT to Use Review Sessions

- Active project work (use Focus)
- Cross-project planning (use Strategic)
- Investigation tasks (use Research)
- Meeting preparation (use Meeting Prep)

## Pre-Session Checklist

### Review Type Identification

```markdown
- [ ] Determine review type (daily/weekly/monthly/quarterly)
- [ ] Check when last review was completed
- [ ] Identify pending attention items
- [ ] Note available time for review
```

### Digest Availability

```bash
# Check available digests
/kaaos:status --digests
```

Expected output:
```
Available Digests:
  Daily:    2026-01-15 06:00 (unreviewed)
            2026-01-14 06:00 (reviewed)
  Weekly:   2026-01-12 (unreviewed)
  Monthly:  2025-12-31 (reviewed)

Pending Attention Items: 8
  - High priority: 2
  - Medium priority: 4
  - Low priority: 2
```

## Initialization

### Daily Review Session

```bash
# Start daily review session
/kaaos:session review --daily

# Review specific date
/kaaos:session review --daily --date 2026-01-15
```

### Weekly Review Session

```bash
# Start weekly review session
/kaaos:session review --weekly

# Review specific week
/kaaos:session review --weekly --week 2026-W02
```

### Monthly/Quarterly Review

```bash
# Monthly review
/kaaos:session review --monthly --month 2025-12

# Quarterly review
/kaaos:session review --quarterly --quarter 2025-Q4
```

### Initialization Output

```
============================================================
KAAOS Review Session
============================================================

Session ID: 2026-01-15-review-daily-001
Review Type: daily
Date: 2026-01-15

Digest Loaded:
  [check] Daily digest: 2026-01-15 06:00
  [check] Notes created yesterday: 5
  [check] Notes updated yesterday: 8
  [check] Decisions made: 1
  [check] Research completed: 1

Attention Items:
  [warning] High Priority: 2
    - Broken link in [[2026-01-090]]
    - Orphaned note [[2026-01-088]]
  [info] Medium Priority: 4
    - Stale pattern [[PATTERN-auth-flow]]
    - Missing cross-reference in [[2026-01-095]]
    - ...

Health Metrics:
  [check] Context library health: 92%
  [warning] Orphaned notes: 3
  [check] Link integrity: 98%

============================================================
Review ready. Estimated time: 30 minutes
============================================================
```

## Session Workflow

### Phase 1: Digest Overview (5-10 minutes)

**Objective**: Understand activity since last review

```python
def digest_overview(session):
    """Review digest overview."""

    print("=== Digest Overview ===\n")

    digest = session['context']['digest']

    # Activity summary
    print("Activity Summary:")
    print(f"  Notes created: {digest['notes_created']}")
    print(f"  Notes updated: {digest['notes_updated']}")
    print(f"  Decisions made: {digest['decisions_made']}")
    print(f"  Research completed: {digest['research_completed']}")
    print(f"  Sessions held: {digest['sessions_held']}")

    # Highlight significant items
    print("\nSignificant Items:")
    for item in digest.get('highlights', []):
        print(f"  - {item['type']}: {item['summary']}")

    # Show patterns detected
    if digest.get('patterns_detected'):
        print("\nPatterns Detected:")
        for pattern in digest['patterns_detected']:
            print(f"  - {pattern['description']}")
            print(f"    Confidence: {pattern['confidence']:.0%}")

    # Cost summary
    print(f"\nCost Summary:")
    print(f"  Period cost: ${digest['cost']:.2f}")
    print(f"  Running total: ${digest['running_total']:.2f}")
    print(f"  Budget remaining: ${digest['budget_remaining']:.2f}")

    return digest


def display_daily_digest(digest):
    """Display formatted daily digest."""

    output = f"""
# Daily Digest: {digest['date']}

## Activity Summary

| Metric | Count | Change |
|--------|-------|--------|
| Notes Created | {digest['notes_created']} | {digest['notes_change']} |
| Notes Updated | {digest['notes_updated']} | {digest['updates_change']} |
| Decisions | {digest['decisions_made']} | - |
| Sessions | {digest['sessions_held']} | - |

## Highlights

"""
    for h in digest.get('highlights', []):
        output += f"- **{h['type']}**: {h['summary']}\n"

    output += f"""
## Attention Required

"""
    for item in digest.get('attention_items', []):
        priority_icon = {'high': '!', 'medium': '*', 'low': '-'}[item['priority']]
        output += f"{priority_icon} [{item['priority'].upper()}] {item['description']}\n"

    return output
```

**Overview Checklist**:
```markdown
- [ ] Activity summary reviewed
- [ ] Highlights noted
- [ ] Patterns detected acknowledged
- [ ] Cost within budget
- [ ] Anomalies identified (if any)
```

### Phase 2: Attention Item Processing (15-30 minutes)

**Objective**: Address flagged items requiring action

```python
def process_attention_items(session):
    """Process attention items from digest."""

    print("=== Attention Item Processing ===\n")

    items = session['context']['attention_items']

    # Sort by priority
    sorted_items = sorted(
        items,
        key=lambda x: {'high': 0, 'medium': 1, 'low': 2}[x['priority']]
    )

    processed = []
    deferred = []

    for item in sorted_items:
        print(f"\n{'='*50}")
        print(f"[{item['priority'].upper()}] {item['type']}")
        print(f"Description: {item['description']}")
        print(f"{'='*50}")

        # Display item details
        if item['type'] == 'broken_link':
            handle_broken_link(item)
        elif item['type'] == 'orphaned_note':
            handle_orphaned_note(item)
        elif item['type'] == 'stale_content':
            handle_stale_content(item)
        elif item['type'] == 'missing_reference':
            handle_missing_reference(item)
        elif item['type'] == 'maintenance_recommendation':
            handle_maintenance_recommendation(item)

        # Record action taken
        action = prompt_action(item)

        if action == 'resolved':
            mark_resolved(item)
            processed.append(item)
        elif action == 'deferred':
            defer_item(item)
            deferred.append(item)
        elif action == 'dismissed':
            dismiss_item(item)
            processed.append(item)

    return {
        'processed': processed,
        'deferred': deferred,
        'remaining': len(items) - len(processed) - len(deferred)
    }


def handle_broken_link(item):
    """Handle broken link attention item."""

    print(f"\nBroken Link Details:")
    print(f"  Source: [[{item['source']}]]")
    print(f"  Target: {item['target']}")
    print(f"  Context: {item['context'][:100]}...")

    # Suggest fixes
    suggestions = find_similar_notes(item['target'])
    if suggestions:
        print(f"\nPossible Corrections:")
        for i, s in enumerate(suggestions[:3], 1):
            print(f"  {i}. [[{s.id}|{s.title}]] (similarity: {s.score:.0%})")

    print(f"\nActions:")
    print(f"  1. Fix link to suggested note")
    print(f"  2. Remove broken link")
    print(f"  3. Create missing note")
    print(f"  4. Defer to later")


def handle_orphaned_note(item):
    """Handle orphaned note attention item."""

    print(f"\nOrphaned Note Details:")
    print(f"  Note: [[{item['note_id']}|{item['title']}]]")
    print(f"  Created: {item['created']}")
    print(f"  Last Updated: {item['updated']}")
    print(f"  Summary: {item['summary'][:100]}...")

    # Find potential parent notes
    parents = find_potential_parents(item['note_id'])
    if parents:
        print(f"\nPotential Parent Notes:")
        for i, p in enumerate(parents[:3], 1):
            print(f"  {i}. [[{p.id}|{p.title}]]")

    print(f"\nActions:")
    print(f"  1. Link to suggested parent")
    print(f"  2. Add to appropriate map note")
    print(f"  3. Archive if no longer relevant")
    print(f"  4. Defer to later")


def handle_stale_content(item):
    """Handle stale content attention item."""

    print(f"\nStale Content Details:")
    print(f"  Note: [[{item['note_id']}|{item['title']}]]")
    print(f"  Last Updated: {item['updated']}")
    print(f"  Age: {item['age_days']} days")
    print(f"  Reason: {item['reason']}")

    print(f"\nActions:")
    print(f"  1. Review and update content")
    print(f"  2. Mark as still current (reset staleness)")
    print(f"  3. Archive if outdated")
    print(f"  4. Defer review to later")
```

#### Attention Item Types and Actions

```yaml
# Attention item type reference
attention_item_types:
  broken_link:
    priority: high
    actions:
      - fix_link: "Correct the link target"
      - remove_link: "Remove the broken reference"
      - create_target: "Create the missing note"
      - defer: "Address later"

  orphaned_note:
    priority: medium
    actions:
      - link_to_parent: "Add reference from parent note"
      - add_to_map: "Add to relevant map note"
      - archive: "Archive if not relevant"
      - defer: "Address later"

  stale_content:
    priority: low
    actions:
      - update: "Review and update content"
      - confirm_current: "Mark as still current"
      - archive: "Archive if outdated"
      - defer: "Address later"

  missing_reference:
    priority: medium
    actions:
      - add_reference: "Add the cross-reference"
      - not_needed: "Reference not actually needed"
      - defer: "Address later"

  maintenance_recommendation:
    priority: low
    actions:
      - apply: "Apply recommendation"
      - dismiss: "Dismiss recommendation"
      - defer: "Address later"
```

**Processing Checklist**:
```markdown
For each attention item:
- [ ] Item details reviewed
- [ ] Suggestions considered
- [ ] Action selected and executed
- [ ] Item marked as processed/deferred
- [ ] Notes updated if applicable
```

### Phase 3: Insights Review (5-10 minutes)

**Objective**: Review insights and patterns from digest

```python
def review_insights(session):
    """Review insights and patterns from digest."""

    print("=== Insights Review ===\n")

    digest = session['context']['digest']

    # Review detected patterns
    patterns = digest.get('patterns_detected', [])
    if patterns:
        print("Patterns Detected:")
        for pattern in patterns:
            print(f"\n  Pattern: {pattern['description']}")
            print(f"  Confidence: {pattern['confidence']:.0%}")
            print(f"  Evidence: {pattern['evidence_count']} instances")

            if pattern['confidence'] >= 0.8:
                print(f"  [arrow] Consider documenting as formal pattern")
            elif pattern['confidence'] >= 0.6:
                print(f"  [arrow] Monitor for additional evidence")

    # Review synthesis insights
    synthesis = digest.get('synthesis', {})
    if synthesis:
        print("\nSynthesis Insights:")
        for insight in synthesis.get('insights', []):
            print(f"  - {insight}")

    # Review connections discovered
    connections = digest.get('connections_discovered', [])
    if connections:
        print("\nNew Connections:")
        for conn in connections[:5]:
            print(f"  - [[{conn['from']}]] <-> [[{conn['to']}]]")
            print(f"    Reason: {conn['reason']}")

    # Review gap analysis
    gaps = digest.get('gaps_identified', [])
    if gaps:
        print("\nKnowledge Gaps:")
        for gap in gaps[:5]:
            print(f"  - {gap['description']}")
            print(f"    Suggested action: {gap['suggestion']}")

    return {
        'patterns': patterns,
        'connections': connections,
        'gaps': gaps
    }


def decide_pattern_action(pattern):
    """Decide action for detected pattern."""

    if pattern['confidence'] >= 0.9:
        return {
            'action': 'document',
            'message': 'High confidence - create pattern note'
        }
    elif pattern['confidence'] >= 0.7:
        return {
            'action': 'verify',
            'message': 'Moderate confidence - verify with additional examples'
        }
    else:
        return {
            'action': 'monitor',
            'message': 'Low confidence - continue monitoring'
        }
```

**Insights Checklist**:
```markdown
- [ ] Patterns reviewed
- [ ] High-confidence patterns documented
- [ ] New connections acknowledged
- [ ] Gaps noted for future research
- [ ] Synthesis insights processed
```

### Phase 4: Action Planning (5-10 minutes)

**Objective**: Plan actions based on review findings

```python
def plan_actions(session, review_results):
    """Plan actions based on review findings."""

    print("=== Action Planning ===\n")

    actions = []

    # Actions from attention items
    for item in review_results.get('deferred', []):
        actions.append({
            'type': 'attention_item',
            'description': f"Address deferred item: {item['description']}",
            'priority': item['priority'],
            'deadline': calculate_deadline(item['priority'])
        })

    # Actions from patterns
    for pattern in review_results.get('patterns', []):
        if pattern['confidence'] >= 0.8:
            actions.append({
                'type': 'documentation',
                'description': f"Document pattern: {pattern['description']}",
                'priority': 'medium',
                'deadline': 'this_week'
            })

    # Actions from gaps
    for gap in review_results.get('gaps', [])[:3]:
        actions.append({
            'type': 'research',
            'description': f"Research gap: {gap['description']}",
            'priority': 'low',
            'deadline': 'this_month'
        })

    # Display action plan
    print("Action Plan:")
    print("-" * 50)

    for action in sorted(actions, key=lambda a: {'high': 0, 'medium': 1, 'low': 2}[a['priority']]):
        print(f"\n  [{action['priority'].upper()}] {action['type']}")
        print(f"  {action['description']}")
        print(f"  Deadline: {action['deadline']}")

    # Create action items
    if actions:
        print(f"\nCreate {len(actions)} action items? [y/n]")
        # Create if confirmed

    return actions
```

#### Action Item Template

```yaml
# Review-generated action items
actions:
  - id: "ACTION-2026-01-15-001"
    type: attention_item
    source: "daily_review"
    description: "Fix broken link in [[2026-01-090]]"
    priority: high
    deadline: 2026-01-16
    status: pending

  - id: "ACTION-2026-01-15-002"
    type: documentation
    source: "daily_review"
    description: "Document authentication pattern detected across 5 notes"
    priority: medium
    deadline: 2026-01-20
    status: pending

  - id: "ACTION-2026-01-15-003"
    type: research
    source: "daily_review"
    description: "Research gap: No documentation on rate limiting"
    priority: low
    deadline: 2026-01-31
    status: pending
```

**Action Planning Checklist**:
```markdown
- [ ] Deferred items scheduled
- [ ] Pattern documentation planned
- [ ] Research items noted
- [ ] Actions prioritized
- [ ] Deadlines assigned
```

### Phase 5: Wrap-Up (2-5 minutes)

```python
def review_wrap_up(session, actions):
    """Wrap up review session."""

    print("=== Review Session Wrap-Up ===\n")

    # Summary
    summary = {
        'review_type': session['review_type'],
        'duration': calculate_duration(session),
        'attention_items_processed': session.get('items_processed', 0),
        'attention_items_deferred': session.get('items_deferred', 0),
        'patterns_reviewed': session.get('patterns_reviewed', 0),
        'actions_created': len(actions)
    }

    print("Review Summary:")
    print(f"  Type: {summary['review_type']}")
    print(f"  Duration: {summary['duration']} minutes")
    print(f"  Items processed: {summary['attention_items_processed']}")
    print(f"  Items deferred: {summary['attention_items_deferred']}")
    print(f"  Actions created: {summary['actions_created']}")

    # Mark digest as reviewed
    mark_digest_reviewed(session['context']['digest'])
    print(f"\n[check] Digest marked as reviewed")

    # Schedule next review
    next_review = schedule_next_review(session['review_type'])
    print(f"[check] Next review: {next_review}")

    # Save session
    save_session_state(session)
    print(f"[check] Session saved: {session['id']}")

    return summary
```

## Session State Format

```yaml
# Review session state
session:
  id: "2026-01-15-review-daily-001"
  type: review
  review_type: daily
  review_date: 2026-01-15

  lifecycle:
    created: "2026-01-15T08:00:00Z"
    started: "2026-01-15T08:00:00Z"
    ended: "2026-01-15T08:35:00Z"
    duration_minutes: 35

  digest:
    id: "digest-2026-01-15"
    activity:
      notes_created: 5
      notes_updated: 8
      decisions_made: 1
    attention_items: 8

  processing:
    items_processed: 6
    items_deferred: 2
    items_dismissed: 0
    patterns_reviewed: 3
    insights_acknowledged: 5

  outcomes:
    actions_created: 4
    patterns_documented: 1
    links_fixed: 2
    notes_archived: 0

  metrics:
    estimated_cost: 0.22
```

## Completion Checklist

```markdown
### Digest Reviewed
- [ ] Activity summary checked
- [ ] Highlights acknowledged
- [ ] Patterns noted
- [ ] Cost within budget

### Items Processed
- [ ] High priority items addressed
- [ ] Medium priority items reviewed
- [ ] Deferred items scheduled
- [ ] Actions assigned

### Insights Captured
- [ ] Patterns documented (if high confidence)
- [ ] Connections acknowledged
- [ ] Gaps noted for research
- [ ] Synthesis insights processed

### Session Complete
- [ ] Digest marked as reviewed
- [ ] Actions created
- [ ] Next review scheduled
- [ ] Session saved
```

## Commands Reference

```bash
# Start review sessions
/kaaos:session review --daily
/kaaos:session review --weekly
/kaaos:session review --monthly --month 2025-12
/kaaos:session review --quarterly --quarter 2025-Q4

# During review
/kaaos:review item [id] --resolve    # Mark item resolved
/kaaos:review item [id] --defer      # Defer item
/kaaos:review pattern [id] --document # Document pattern
/kaaos:review action create "[desc]" # Create action item

# After review
/kaaos:review complete               # Mark review complete
```

## Review Type Guidelines

### Daily Review (15-30 minutes)

**Focus**: Activity check and urgent items
- Review yesterday's activity
- Address high-priority attention items
- Quick pattern check
- Plan today's focus

### Weekly Review (45-60 minutes)

**Focus**: Synthesis and patterns
- Review week's synthesis
- Process all attention items
- Document emerging patterns
- Plan next week's priorities

### Monthly Review (60-90 minutes)

**Focus**: Trends and alignment
- Review month's patterns
- Assess knowledge growth
- Check strategic alignment
- Plan improvements

### Quarterly Review (90-120 minutes)

**Focus**: Strategic assessment
- Review quarter's outcomes
- Assess system effectiveness
- Plan refinements
- Set next quarter goals

## Best Practices

1. **Consistent Timing**: Review at same time each day/week
2. **Process All Items**: Don't let attention items pile up
3. **Document Patterns**: When confidence is high
4. **Create Actions**: Turn insights into tasks
5. **Track Trends**: Notice recurring issues
6. **Celebrate Progress**: Acknowledge knowledge growth
7. **Adjust Frequency**: Match review frequency to activity level

## Common Pitfalls

- **Skipping Reviews**: Letting digests pile up
- **Item Accumulation**: Deferring everything
- **Ignoring Patterns**: Missing documentation opportunities
- **No Follow-Through**: Creating actions but not doing them
- **Review Fatigue**: Making reviews too long
- **Missing Context**: Reviewing without loaded digest
- **No Scheduling**: Inconsistent review timing
