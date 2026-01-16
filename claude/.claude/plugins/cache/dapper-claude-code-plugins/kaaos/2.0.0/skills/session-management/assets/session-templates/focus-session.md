# Focus Session Template

Deep work session template for concentrated effort on a single project with minimal context switching.

## Session Overview

| Attribute | Value |
|-----------|-------|
| **Purpose** | Deep work on specific project deliverables |
| **Duration** | 2-4 hours typical |
| **Co-Pilot** | Recommended for sessions >2 hours |
| **Context Level** | Full project context |
| **Cost Estimate** | $0.40-1.30 depending on duration and co-pilot |

### When to Use Focus Sessions

- Working on a specific deliverable or feature
- Resolving complex technical problems
- Creating substantial documentation
- Making significant project decisions
- Implementing planned changes

### When NOT to Use Focus Sessions

- Quick tasks (<30 minutes)
- Cross-project work (use Strategic)
- Exploration without clear goal (use Research)
- Pre-meeting preparation (use Meeting Prep)

## Pre-Session Checklist

### Environment Preparation

```markdown
- [ ] Clear calendar for session duration
- [ ] Minimize notification sources
- [ ] Ensure comfortable workspace
- [ ] Have reference materials accessible
- [ ] Close unrelated browser tabs/applications
```

### Context Requirements

```markdown
- [ ] Project exists in KAAOS repository
- [ ] Recent work on project (past 7 days ideal)
- [ ] Clear goal for this session defined
- [ ] Deliverable identified
- [ ] Success criteria established
```

### Budget Verification

```bash
# Check current budget status
/kaaos:status --budget
```

Expected output:
```
Budget Status:
  Daily:   $1.25 / $5.00 (75% remaining)
  Weekly:  $12.50 / $25.00 (50% remaining)
  Monthly: $45.00 / $100.00 (55% remaining)

Estimated session cost:
  Focus (2h): $0.40-0.80
  Focus (2h) + Co-pilot: $0.70-1.30
```

## Initialization

### Basic Focus Session

```bash
# Start focus session on specific project
/kaaos:session [organization]/[project]

# Example
/kaaos:session personal/product-launch
```

### Focus Session with Co-Pilot

```bash
# Start focus session with co-pilot agent
/kaaos:session [organization]/[project] --copilot

# Example with explicit co-pilot mode
/kaaos:session personal/product-launch --copilot --mode balanced
```

### Advanced Options

```bash
# Full options
/kaaos:session [organization]/[project] \
  --copilot \
  --mode balanced \
  --duration 180 \
  --checkpoint-interval 15 \
  --goal "Complete sprint planning document"
```

### Initialization Output

```
============================================================
KAAOS Focus Session Initialized
============================================================

Session ID: 2026-01-15-focus-product-launch-001
Organization: personal
Project: product-launch
Type: focus

Essential Context Loaded:
  [check] Organization index: 2,450 chars
  [check] Project index: 3,200 chars
  [check] Recent decisions: 5 decisions
  [check] Active playbooks: 3 playbooks

Recent Work (Past 7 Days):
  [check] Notes created: 8
  [check] Notes updated: 12
  [check] Conversations: 3
  [check] Commits: 15

  Recent Notes:
    - [[2026-01-095|Sprint Planning Draft]] (2 days ago)
    - [[2026-01-092|Feature Prioritization]] (3 days ago)
    - [[2026-01-088|Q1 Goals Review]] (5 days ago)

Co-pilot: Spawned (balanced mode)
  Available commands:
    /copilot suggest       - Suggest related notes
    /copilot patterns      - Detect patterns in current work
    /copilot relate [note] - Find related notes
    /copilot question      - Ask about context

============================================================
Session ready. Goal: [Your defined goal]
============================================================
```

## Session Workflow

### Phase 1: Orientation (5-10 minutes)

**Objective**: Ground yourself in project context

```python
# Automatic context review during initialization
def orientation_phase(session):
    """Review loaded context and identify starting point."""

    print("=== Orientation Phase ===\n")

    # Review recent work
    print("Recent Work Summary:")
    for note in session['context']['recent']['notes_created'][:5]:
        print(f"  - [[{note.id}|{note.title}]] ({note.created})")

    # Check open threads from previous session
    if session.get('previous_threads'):
        print("\nOpen Threads from Previous Session:")
        for thread in session['previous_threads']:
            print(f"  - {thread['topic']}: {thread['status']}")

    # Identify starting point
    print("\nRecommended Starting Point:")
    if session.get('resumption', {}).get('next_actions'):
        print(f"  {session['resumption']['next_actions'][0]}")
```

**Checklist**:
```markdown
- [ ] Review recent notes summary
- [ ] Check for open threads from previous session
- [ ] Identify where to start
- [ ] Confirm session goal is still relevant
```

### Phase 2: Core Work (80-90% of session)

**Objective**: Deep focused work on deliverable

#### Work Pattern: Create and Link

```python
def focus_work_pattern(session, goal):
    """Pattern for focused work with linking."""

    # Create or continue working note
    working_note = create_or_load_note(
        session['project'],
        goal
    )

    while not goal_achieved(working_note, goal):
        # Work cycle
        work_increment = focused_work(working_note, duration=25)  # Pomodoro

        # Check for cross-references
        if session['copilot']:
            suggestions = session['copilot'].suggest_related(working_note)
            if suggestions:
                print(f"Co-pilot suggestion: {suggestions[0]['message']}")

        # Auto-save checkpoint
        if time_for_checkpoint(session):
            checkpoint(session)
            print(f"Checkpoint saved: {session['checkpoint_count']}")
```

#### Co-Pilot Usage During Focus

```markdown
## Co-Pilot Commands for Focus Sessions

### Quick Reference Lookup
User: /copilot question "What was our decision on error handling?"

Co-pilot: From [[decisions/error-handling.md]]:
  "Use try-catch with state updates pattern - all agents should
  update execution state on both success and failure."

  Decided: 2026-01-10
  Related: [[patterns/agent-error-handling]]

### Cross-Reference Discovery
User: /copilot relate current

Co-pilot: Related notes for current work:
  - [[2026-01-050|Sprint Cadence Decision]] (0.92 relevance)
  - [[PLAY-sprint-planning]] (0.85 relevance)
  - [[MAP-project-decisions]] (0.78 relevance)

  Add references? [y/n]

### Pattern Detection
User: /copilot patterns

Co-pilot: Patterns detected in current work:
  1. Decision-making language detected 3x
     - Consider documenting as formal decision
  2. Similar content to [[2026-01-050]]
     - Consider linking or extending
  3. Repeated reference to "launch date"
     - 5 mentions across recent notes
```

#### Checkpoint Protocol

```yaml
# Checkpoint every 15 minutes automatically
checkpoint_protocol:
  interval_minutes: 15

  actions:
    - save_session_state
    - commit_if_changes
    - update_metrics

  notification: silent  # Don't interrupt flow

  on_checkpoint:
    - log: "Checkpoint #{count} at {timestamp}"
    - save: session_state
    - git_commit:
        message: "WIP: Focus session checkpoint"
        only_if: uncommitted_changes
```

**Work Phase Checklist**:
```markdown
Every 30 minutes:
- [ ] Progress toward goal checked
- [ ] Notes linked to project context
- [ ] Co-pilot suggestions reviewed (if any)
- [ ] Uncommitted changes committed

Every 60 minutes:
- [ ] Take 5-minute break
- [ ] Review session progress
- [ ] Adjust remaining plan if needed
```

### Phase 3: Documentation (10-15% of session)

**Objective**: Document decisions and link work

```python
def documentation_phase(session):
    """Document session outcomes."""

    print("=== Documentation Phase ===\n")

    # Identify decisions made
    decisions = detect_decisions(session['activity_log'])

    for decision in decisions:
        print(f"Decision detected: {decision['summary']}")

        # Create decision note
        if confirm_create_decision_note(decision):
            create_decision_note(
                session['project'],
                decision
            )

    # Update project index if needed
    if session['notes_created'] or session['notes_updated']:
        update_project_index(session)

    # Link notes to relevant map notes
    update_map_notes(session)
```

**Documentation Checklist**:
```markdown
- [ ] Decisions documented as decision notes
- [ ] New notes linked to project index
- [ ] Cross-references added where relevant
- [ ] Map notes updated if applicable
- [ ] Summary of work prepared
```

### Phase 4: Wrap-Up (5 minutes)

**Objective**: Clean session closure

```python
def wrap_up_phase(session):
    """Clean session wrap-up."""

    print("=== Wrap-Up Phase ===\n")

    # Commit all changes
    uncommitted = check_uncommitted_changes(session)
    if uncommitted:
        git_commit_all(
            message=f"Focus session: {session['goal']}"
        )
        print(f"Committed {len(uncommitted)} files")

    # Generate session summary
    summary = generate_session_summary(session)
    print(summary)

    # Save session state
    save_session_state(session)

    # Stop co-pilot if running
    if session.get('copilot'):
        stop_copilot(session['copilot'])

    # Display next steps
    print("\nNext Steps:")
    for action in session.get('next_actions', [])[:3]:
        print(f"  - {action}")
```

## Session State Format

```yaml
# Focus session state
# File: ~/.kaaos-knowledge/.kaaos/sessions/{session_id}.yaml

session:
  id: "2026-01-15-focus-product-launch-001"
  type: focus

  # Session identity
  organization: personal
  project: product-launch
  goal: "Complete sprint planning document"

  # Lifecycle
  lifecycle:
    created: "2026-01-15T09:00:00Z"
    started: "2026-01-15T09:05:00Z"
    ended: "2026-01-15T12:30:00Z"
    duration_minutes: 205

  # Context loaded
  context:
    essential:
      org_index: true
      project_index: true
      recent_decisions: 5
      active_playbooks: 3

    recent:
      notes_created: 8
      notes_updated: 12
      cutoff_days: 7

    expanded:
      loaded_notes:
        - "2026-01-095"
        - "2026-01-050"
        - "PLAY-sprint-planning"

  # Co-pilot
  copilot:
    enabled: true
    mode: balanced
    questions_answered: 5
    suggestions_made: 8
    suggestions_accepted: 6

  # Outputs
  outputs:
    notes_created:
      - id: "2026-01-100"
        title: "Sprint Planning Q1 Final"
        type: atomic
    notes_updated:
      - id: "2026-01-095"
        changes: "Added timeline section"
    decisions_made:
      - id: "2026-01-101"
        summary: "2-week sprint cadence confirmed"

  # Metrics
  metrics:
    checkpoints: 12
    commits: 4
    estimated_cost: 0.95
```

## Completion Checklist

```markdown
### Work Finalization
- [ ] All notes saved and committed
- [ ] Decisions documented
- [ ] Cross-references added
- [ ] Project index updated

### Documentation
- [ ] Session goal achieved (or partial progress noted)
- [ ] Work summary created
- [ ] Next actions identified
- [ ] Blockers documented (if any)

### Session Closure
- [ ] Final commit with descriptive message
- [ ] Co-pilot stopped (if running)
- [ ] Session state saved
- [ ] Follow-up session planned (if needed)
```

## Session Commands Reference

```bash
# Start focus session
/kaaos:session [org]/[project]
/kaaos:session [org]/[project] --copilot
/kaaos:session [org]/[project] --copilot --mode proactive

# During session
/kaaos:status                    # Check session status
/copilot suggest                 # Get suggestions
/copilot question "[question]"   # Ask context question
/copilot patterns               # Detect patterns
/kaaos:session checkpoint       # Force checkpoint

# End session
/kaaos:session end              # End and save session
/kaaos:session pause            # Pause for later resumption
```

## Troubleshooting

### Context Not Loading

```bash
# Verify repository structure
ls -la ~/.kaaos-knowledge/organizations/[org]/projects/[project]/

# Check context library
ls -la ~/.kaaos-knowledge/organizations/[org]/projects/[project]/context-library/

# Manual context load
/kaaos:session [org]/[project] --reload-context
```

### Co-Pilot Not Responding

```bash
# Check co-pilot status
/copilot status

# Restart co-pilot
/copilot restart

# Switch to reactive mode if issues persist
/copilot mode reactive
```

### Budget Exceeded Mid-Session

```markdown
Options:
1. Continue without co-pilot: /copilot stop
2. Pause session: /kaaos:session pause
3. Increase budget: Edit ~/.kaaos-knowledge/.kaaos/config.yaml
```

## Best Practices

1. **Define Clear Goal**: Start with specific deliverable in mind
2. **Use Time Blocks**: Work in 25-50 minute focused blocks
3. **Leverage Co-Pilot**: For sessions >2 hours
4. **Link Aggressively**: Cross-reference all related content
5. **Document Decisions**: Create decision notes as you go
6. **Checkpoint Often**: Automatic every 15 minutes
7. **Plan Next Session**: Before ending current session
8. **Review Progress**: Every hour, assess goal progress

## Common Pitfalls

- **Unclear Goal**: Starting without specific deliverable
- **Over-Scoping**: Trying to do too much in one session
- **Under-Linking**: Creating isolated notes
- **Ignoring Co-Pilot**: Not using suggestions
- **Skipping Documentation**: Leaving decisions undocumented
- **No Checkpoints**: Losing work on interruption
- **Dirty Exit**: Not properly closing session
