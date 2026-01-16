# Meeting Prep Session Template

Pre-meeting preparation session template for loading relevant context and preparing for effective meeting participation.

## Session Overview

| Attribute | Value |
|-----------|-------|
| **Purpose** | Load context and prepare for upcoming meeting |
| **Duration** | 10-30 minutes typical |
| **Co-Pilot** | Not needed (short duration) |
| **Context Level** | Meeting-specific context |
| **Cost Estimate** | $0.05-0.15 |

### When to Use Meeting Prep Sessions

- Before important meetings requiring context
- When meeting involves decisions to be made
- Before presentations or reviews
- When meeting attendees need context refresh
- Before strategic discussions
- When pre-read materials exist

### When NOT to Use Meeting Prep Sessions

- Routine daily standups
- Informal check-ins
- Meetings where you are presenting prepared material
- Meetings outside of KAAOS-tracked projects

## Pre-Session Checklist

### Meeting Information

```markdown
- [ ] Meeting time confirmed
- [ ] Meeting duration known
- [ ] Attendees identified
- [ ] Agenda or topics available
- [ ] Pre-read materials identified
- [ ] Decision points known (if any)
```

### Timing

```markdown
- [ ] Allow 10-30 minutes before meeting
- [ ] Account for context loading time (~2 minutes)
- [ ] Reserve time for question preparation (~5 minutes)
- [ ] Buffer for unexpected findings (~5 minutes)
```

## Initialization

### Basic Meeting Prep

```bash
# Start meeting prep session
/kaaos:session [organization]/[project] --meeting "[Meeting Title]"

# Example
/kaaos:session personal/product-launch --meeting "Sprint Planning"
```

### Meeting Prep with Participants

```bash
# Include participant context
/kaaos:session [organization]/[project] \
  --meeting "[Meeting Title]" \
  --participants "Alice,Bob,Carol"

# Example
/kaaos:session personal/product-launch \
  --meeting "Product Review" \
  --participants "PM,Engineering Lead,Designer"
```

### Initialization Output

```
============================================================
KAAOS Meeting Prep Session
============================================================

Session ID: 2026-01-15-meeting-sprint-planning-001
Organization: personal
Project: product-launch
Meeting: "Sprint Planning"

Meeting Context Loaded:
  [check] Meeting note found: [[2026-01-099|Sprint Planning Agenda]]
  [check] Pre-reads identified: 3
    - [[2026-01-095|Sprint Backlog]]
    - [[2026-01-090|Q1 Priorities]]
    - [[2026-01-085|Technical Debt List]]
  [check] Related decisions: 2
    - [[2026-01-050|Sprint Cadence Decision]]
    - [[2026-01-075|Velocity Target]]

Participants:
  [check] PM: 5 recent notes
  [check] Engineering Lead: 8 recent notes
  [check] Designer: 3 recent notes

Decision Points Expected:
  - Sprint scope finalization
  - Technical debt allocation

============================================================
Prep ready. Meeting in: [time until meeting]
============================================================
```

## Session Workflow

### Phase 1: Context Loading (2-5 minutes)

**Objective**: Load all meeting-relevant context

```python
def load_meeting_context(session, meeting_title):
    """Load context relevant to meeting."""

    print("=== Loading Meeting Context ===\n")

    context = {}

    # Find meeting note or agenda
    meeting_note = find_meeting_note(
        session['organization'],
        session.get('project'),
        meeting_title
    )

    if meeting_note:
        context['meeting_note'] = meeting_note
        print(f"[check] Meeting note: [[{meeting_note.id}|{meeting_note.title}]]")

        # Extract pre-reads from meeting note
        pre_reads = extract_pre_reads(meeting_note)
        context['pre_reads'] = []

        for pre_read_id in pre_reads:
            try:
                note = load_note(pre_read_id)
                context['pre_reads'].append(note)
                print(f"[check] Pre-read: [[{note.id}|{note.title}]]")
            except NoteNotFoundError:
                print(f"[warning] Pre-read not found: {pre_read_id}")

    # Find related decisions
    keywords = extract_keywords_from_title(meeting_title)
    decisions = find_decisions_by_keywords(
        session['organization'],
        session.get('project'),
        keywords
    )

    context['related_decisions'] = decisions[:5]
    print(f"\n[check] Related decisions: {len(decisions)}")

    # Extract decision points from agenda
    if meeting_note:
        decision_points = extract_decision_points(meeting_note)
        context['decision_points'] = decision_points
        print(f"[check] Decision points: {len(decision_points)}")

    return context


def extract_decision_points(meeting_note):
    """Extract expected decision points from meeting note."""

    decision_indicators = [
        'decide', 'decision', 'choose', 'select',
        'approve', 'confirm', 'finalize', 'agree'
    ]

    decision_points = []

    lines = meeting_note.content.split('\n')
    for line in lines:
        if any(ind in line.lower() for ind in decision_indicators):
            decision_points.append({
                'topic': extract_topic(line),
                'context_loaded': False
            })

    return decision_points
```

**Context Loading Checklist**:
```markdown
- [ ] Meeting note or agenda loaded
- [ ] Pre-read materials loaded
- [ ] Related decisions found
- [ ] Decision points identified
- [ ] Recent relevant work loaded
```

### Phase 2: Pre-Read Review (5-15 minutes)

**Objective**: Review pre-read materials and note questions

```python
def review_pre_reads(session):
    """Review pre-read materials."""

    print("=== Pre-Read Review ===\n")

    pre_reads = session['context'].get('pre_reads', [])
    questions = []
    notes = []

    for pre_read in pre_reads:
        print(f"\nReviewing: [[{pre_read.id}|{pre_read.title}]]")
        print("-" * 40)

        # Display summary
        print(f"Summary: {pre_read.summary}")

        # Display key points
        key_points = extract_key_points(pre_read.content)
        if key_points:
            print("\nKey Points:")
            for point in key_points[:5]:
                print(f"  - {point}")

        # Prompt for questions
        print("\n[prompt] Questions about this document?")
        # User records questions

    return {
        'questions': questions,
        'notes': notes
    }
```

#### Pre-Read Summary Format

```markdown
## Pre-Read Summary: Sprint Backlog

### Overview
Current sprint backlog with 15 items prioritized for upcoming sprint.

### Key Points
- 8 feature items, 4 bug fixes, 3 technical debt items
- Total story points: 45 (capacity: 50)
- Dependencies: 2 items blocked by external team
- Risk: Authentication refactor has uncertain scope

### Questions to Raise
- [ ] Scope of authentication refactor - need estimation session?
- [ ] External team timeline for blocked items?
- [ ] Should we include buffer for unknowns?

### My Position
- Support including technical debt items
- Concerned about authentication scope uncertainty
- Suggest reducing to 40 points for buffer
```

### Phase 3: Decision Preparation (5-10 minutes)

**Objective**: Prepare for expected decisions

```python
def prepare_for_decisions(session):
    """Prepare for expected decision points."""

    print("=== Decision Preparation ===\n")

    decision_points = session['context'].get('decision_points', [])

    for dp in decision_points:
        print(f"\nDecision: {dp['topic']}")
        print("-" * 40)

        # Load relevant context for this decision
        context = gather_decision_context(
            session,
            dp['topic']
        )

        if context:
            print("Relevant Context:")
            for item in context[:3]:
                print(f"  - [[{item['id']}|{item['title']}]]")

        # Find past similar decisions
        similar = find_similar_decisions(
            session['organization'],
            dp['topic']
        )

        if similar:
            print("\nPast Similar Decisions:")
            for s in similar[:2]:
                print(f"  - [[{s.id}|{s.title}]]")
                print(f"    Outcome: {s.decision[:50]}...")

        # Prepare position
        print("\nPosition Preparation:")
        print("  [prompt] What is your position?")
        print("  [prompt] What are your concerns?")
        print("  [prompt] What information do you need?")
```

#### Decision Preparation Template

```yaml
# Decision preparation for meeting
decision: "Sprint scope finalization"

context_reviewed:
  - "Sprint backlog with 45 story points"
  - "Team capacity at 50 points"
  - "2 items with external dependencies"

past_decisions:
  - "2025-12 sprint: Reduced scope by 10% worked well"
  - "2025-11 sprint: Over-commitment led to carryover"

my_position:
  recommendation: "Reduce to 40 points (80% capacity)"
  rationale: "Buffer for authentication uncertainty + external deps"
  concerns:
    - "Authentication refactor scope unclear"
    - "External team timeline not confirmed"

information_needed:
  - "Engineering estimate for auth refactor"
  - "External team availability confirmation"

questions_to_ask:
  - "Can we get a spike on auth refactor before committing?"
  - "What's the fallback if external team delays?"
```

**Decision Prep Checklist**:
```markdown
For each decision point:
- [ ] Relevant context loaded
- [ ] Past similar decisions reviewed
- [ ] Position prepared
- [ ] Concerns identified
- [ ] Information needs listed
- [ ] Questions prepared
```

### Phase 4: Question and Note Preparation (3-5 minutes)

**Objective**: Finalize questions and prepare note-taking structure

```python
def prepare_meeting_notes(session):
    """Prepare note-taking structure for meeting."""

    print("=== Meeting Notes Preparation ===\n")

    # Create meeting notes template
    template = {
        'meeting': session['meeting_title'],
        'date': session['started'].date(),
        'attendees': session.get('participants', []),
        'sections': [
            {
                'name': 'Decisions Made',
                'format': 'list',
                'items': []
            },
            {
                'name': 'Action Items',
                'format': 'checklist',
                'items': []
            },
            {
                'name': 'Key Discussion Points',
                'format': 'notes',
                'content': ''
            },
            {
                'name': 'Follow-ups',
                'format': 'list',
                'items': []
            }
        ]
    }

    # Pre-populate with expected decision points
    for dp in session['context'].get('decision_points', []):
        template['sections'][0]['items'].append({
            'topic': dp['topic'],
            'decision': '[to be filled]',
            'rationale': '[to be filled]'
        })

    return template


def compile_questions(session):
    """Compile all questions for the meeting."""

    print("\nQuestions to Raise:")
    print("-" * 40)

    questions = []

    # Questions from pre-read review
    for pre_read in session['context'].get('pre_reads', []):
        pre_read_questions = session.get('pre_read_questions', {}).get(pre_read.id, [])
        questions.extend(pre_read_questions)

    # Questions from decision preparation
    for dp in session['context'].get('decision_points', []):
        dp_questions = session.get('decision_questions', {}).get(dp['topic'], [])
        questions.extend(dp_questions)

    # Information needs
    questions.extend(session.get('information_needs', []))

    # Display prioritized questions
    for i, q in enumerate(questions[:10], 1):
        print(f"  {i}. {q}")

    return questions
```

#### Meeting Notes Template

```markdown
# Meeting Notes: Sprint Planning
**Date**: 2026-01-15
**Attendees**: PM, Engineering Lead, Designer
**Related**: [[2026-01-099|Sprint Planning Agenda]]

## Decisions Made

### Sprint Scope
- **Decision**: [to be filled during meeting]
- **Rationale**: [to be filled]
- **Dissent**: [if any]

### Technical Debt Allocation
- **Decision**: [to be filled]
- **Rationale**: [to be filled]

## Action Items

- [ ] [Owner] Action description (Due: date)
- [ ] [Owner] Action description (Due: date)

## Key Discussion Points

[Notes during meeting]

## Follow-ups

- Topic needing further discussion
- Items deferred to next meeting

## Questions Raised

- [x] Question answered during meeting
- [ ] Question to follow up on

---
*Session: 2026-01-15-meeting-sprint-planning-001*
```

## Session State Format

```yaml
# Meeting prep session state
session:
  id: "2026-01-15-meeting-sprint-planning-001"
  type: meeting-prep
  organization: personal
  project: product-launch
  meeting_title: "Sprint Planning"

  lifecycle:
    created: "2026-01-15T09:30:00Z"
    started: "2026-01-15T09:30:00Z"
    ended: "2026-01-15T09:50:00Z"
    duration_minutes: 20

  context:
    meeting_note: "2026-01-099"
    pre_reads:
      - "2026-01-095"
      - "2026-01-090"
      - "2026-01-085"
    related_decisions: 2
    decision_points: 2

  participants:
    - name: "PM"
      recent_notes: 5
    - name: "Engineering Lead"
      recent_notes: 8
    - name: "Designer"
      recent_notes: 3

  preparation:
    pre_reads_reviewed: 3
    questions_prepared: 5
    positions_prepared: 2

  outputs:
    meeting_notes_template: "2026-01-100"

  metrics:
    estimated_cost: 0.08
```

## Completion Checklist

```markdown
### Context Loaded
- [ ] Meeting note or agenda loaded
- [ ] Pre-read materials reviewed
- [ ] Related decisions found
- [ ] Decision points identified

### Preparation Complete
- [ ] Pre-reads summarized
- [ ] Questions compiled
- [ ] Positions prepared for decisions
- [ ] Information needs identified

### Ready for Meeting
- [ ] Meeting notes template created
- [ ] Questions prioritized
- [ ] Key points ready to raise
- [ ] Note-taking structure ready
```

## Quick Commands Reference

```bash
# Start meeting prep
/kaaos:session [org]/[project] --meeting "[title]"
/kaaos:session [org]/[project] --meeting "[title]" --participants "A,B,C"

# During prep
/kaaos:meeting pre-read "[note-id]"   # Review specific pre-read
/kaaos:meeting decision "[topic]"      # Prepare for decision
/kaaos:meeting question "[text]"       # Add question to list

# After meeting
/kaaos:meeting notes                   # Open meeting notes template
/kaaos:meeting summarize               # Generate meeting summary
```

## Post-Meeting Actions

After the meeting, complete these steps:

```markdown
### Immediate (within 1 hour)
- [ ] Complete meeting notes
- [ ] Document decisions made
- [ ] Record action items with owners and dates
- [ ] Note follow-up items

### Same Day
- [ ] Create decision notes for major decisions
- [ ] Update relevant project context
- [ ] Share notes with attendees if appropriate
- [ ] Create action items in task tracker

### Within 48 Hours
- [ ] Link meeting notes to related context
- [ ] Update affected project documents
- [ ] Schedule follow-up meetings if needed
```

## Best Practices

1. **Start Early**: Allow 10-30 minutes, not 2 minutes
2. **Review Pre-Reads**: Actually read them, don't skim
3. **Prepare Questions**: Write them down beforehand
4. **Know Your Position**: On expected decisions
5. **Have Context Ready**: Don't search during meeting
6. **Note-Taking Structure**: Prepare template beforehand
7. **Follow Up**: Document decisions same day

## Common Pitfalls

- **Too Late Start**: Starting prep 2 minutes before meeting
- **Skipping Pre-Reads**: Going in without reading materials
- **No Questions**: Passive participation
- **Unprepared Positions**: Undecided on expected decisions
- **No Note Structure**: Unorganized note-taking
- **Delayed Documentation**: Forgetting details after meeting
- **No Context Loading**: Missing relevant background
