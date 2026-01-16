---
template: atomic-note
version: "1.0"
description: Template for creating atomic (permanent) notes
usage: Foundation of Zettelkasten - single idea, self-contained, densely linked
placeholders:
  - "{{NOTE_ID}}" - Unique identifier (e.g., "2026-01-050")
  - "{{TITLE}}" - Descriptive title
  - "{{CREATED}}" - Creation timestamp
  - "{{TAGS}}" - Relevant tags
  - "{{SOURCE}}" - Where the idea originated
---

# Atomic Note Template

Atomic notes are the foundation of the Zettelkasten knowledge system. Each atomic note captures exactly one idea, is self-contained, and is densely cross-linked to related concepts.

## Template Structure

```markdown
---
id: {{NOTE_ID}}
title: {{TITLE}}
type: atomic
created: {{CREATED}}
modified: {{MODIFIED}}
tags: {{TAGS}}
source: {{SOURCE}}
status: evergreen | seedling | budding
confidence: high | medium | low
review_schedule: {{REVIEW_SCHEDULE}}
---

# {{TITLE}}

## Core Idea

{{CORE_STATEMENT}}

*In one sentence, what is the essential insight?*

## Elaboration

{{DETAILED_EXPLANATION}}

*Expand on the core idea with necessary context, nuance, and supporting details.*

## Evidence & Examples

{{#EACH EVIDENCE}}
### {{TYPE}}
{{CONTENT}}

**Source**: {{SOURCE}}
{{/EACH}}

## Connections

### Related Concepts
{{#EACH RELATED}}
- [[{{NOTE_ID}}|{{TITLE}}]]: {{RELATIONSHIP}}
{{/EACH}}

### Supports
{{#EACH SUPPORTS}}
- [[{{NOTE_ID}}]]: This note provides foundation for...
{{/EACH}}

### Contradicts or Tensions
{{#EACH CONTRADICTS}}
- [[{{NOTE_ID}}]]: Tension because...
{{/EACH}}

### Part Of
{{#EACH PART_OF}}
- [[{{MAP_NOTE}}]]: Member of this map/index
{{/EACH}}

## Implications

{{IMPLICATIONS}}

*What follows from this idea? What actions or decisions does it inform?*

## Open Questions

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

## My Take

{{PERSONAL_PERSPECTIVE}}

*What do I think about this? How does it fit my worldview or practice?*

---
*Created from: {{SOURCE}}*
*Last reviewed: {{LAST_REVIEW}}*
```

## Example: Completed Atomic Note

```markdown
---
id: 2026-01-050
title: Pre-reads Reduce Meeting Time by 40%
type: atomic
created: 2026-01-14T10:30:00-08:00
modified: 2026-01-14T14:15:00-08:00
tags: [meetings, productivity, async, remote-work]
source: Team retrospective 2026-01-14
status: budding
confidence: medium
review_schedule: 30d
---

# Pre-reads Reduce Meeting Time by 40%

## Core Idea

Sending a written document before meetings allows participants to arrive with context, eliminating the need for lengthy presentations and enabling immediate discussion of substance.

## Elaboration

Traditional meetings spend 30-50% of their time on "context setting" - presenting background information that could be consumed asynchronously. When participants read a pre-read document before the meeting, this context is established before anyone enters the room.

The 40% reduction comes from:
1. **No presentation phase**: Everyone already has the context
2. **Better questions**: Time to think leads to deeper questions
3. **Faster decisions**: Context + reflection = readiness to decide
4. **Shorter discussions**: Misunderstandings resolved via document

The pre-read should be distributed at least 24 hours before the meeting, ideally 48 hours for complex topics.

## Evidence & Examples

### Company Experience
Our Q4 planning meeting went from 3 hours to 1.5 hours after implementing pre-reads. Participants reported feeling "more prepared" and "less frustrated."

**Source**: Q4 retrospective notes

### External Research
Amazon's "6-pager" meeting format reportedly saves executives hours per week. Jeff Bezos banned PowerPoint in favor of narrative memos read silently at meeting start.

**Source**: Working Backwards (Colin Bryar)

### Team Feedback
"I used to dread planning meetings. Now I actually look forward to them because we get to the interesting discussion faster." - Engineering lead

**Source**: 1:1 meeting 2026-01-10

## Connections

### Related Concepts
- [[PLAY-async-first]]: Pre-reads are a form of async-first communication
- [[2026-01-035|Writing as Thinking]]: Pre-reads force structured thinking
- [[2026-01-062|Two-Way Door Decisions]]: Pre-reads help distinguish decision types

### Supports
- [[DEC-2026-002|Async Standups]]: This note provides evidence for async approach
- [[PLAY-meeting-guidelines]]: Should incorporate pre-read requirement

### Contradicts or Tensions
- [[2026-01-028|Spontaneous Collaboration]]: Tension because pre-reads require advance planning, which may reduce serendipity

### Part Of
- [[MAP-async-practices]]: Member of async practices collection
- [[MAP-meeting-excellence]]: Key practice for meeting effectiveness

## Implications

1. **All recurring meetings should have pre-read templates**
2. **Calendar invites should link to pre-read documents**
3. **Meeting facilitators should verify pre-read was consumed**
4. **Pre-read quality determines meeting quality**

This implies we need:
- Pre-read templates for common meeting types
- A cultural norm of "no pre-read, no meeting"
- Training for writing effective pre-reads

## Open Questions

- What's the minimum viable pre-read length?
- How do we handle last-minute meetings without pre-reads?
- Should pre-reads be mandatory or encouraged?
- How do we measure if participants actually read the pre-read?

## My Take

This resonates strongly with my experience. The worst meetings I attend are the ones where someone "walks us through" a document we could have read ourselves. The best meetings start with "assuming you've read the pre-read, let's discuss the key tensions."

I want to make this a core practice for my teams. The challenge is making it a habit without being preachy. Perhaps starting with my own meetings and letting results speak.

---
*Created from: Team retrospective 2026-01-14*
*Last reviewed: 2026-01-14*
```

## Atomic Note Characteristics

### The Atomic Principle

| Characteristic | Description | Example |
|----------------|-------------|---------|
| **One idea only** | Each note contains exactly one concept | "Pre-reads reduce meeting time" not "Meeting best practices" |
| **Self-contained** | Can be understood without other notes | Includes necessary context in the note |
| **Densely linked** | Connected to 3-10 other notes | Each connection explicit with relationship |
| **Evergreen** | Written for long-term relevance | Avoids temporal language like "recently" |

### Status Progression

```
seedling  →  budding  →  evergreen
   ↑            ↑            ↑
Initial     Reviewed     Stable &
capture     & expanded   well-linked
```

| Status | Definition | Criteria |
|--------|------------|----------|
| **Seedling** | New idea, needs development | <3 connections, uncertain confidence |
| **Budding** | Growing, being refined | 3-5 connections, medium confidence |
| **Evergreen** | Mature, stable | 5+ connections, high confidence, reviewed |

### Confidence Levels

| Level | Definition | Review Schedule |
|-------|------------|-----------------|
| **High** | Well-established, strong evidence | 90 days |
| **Medium** | Reasonable support, some uncertainty | 30 days |
| **Low** | Speculative, needs validation | 14 days |

## Creation Workflow

```python
def create_atomic_note(idea, source, context):
    """Create a new atomic note from an idea."""

    # Generate ID
    note_id = generate_note_id()  # e.g., "2026-01-050"

    # Extract core idea (should be one sentence)
    core = extract_core_statement(idea)
    if len(core.split('.')) > 2:
        warn("Core idea should be one sentence - consider splitting")

    # Find related notes
    related = find_related_notes(idea, context)
    if len(related) < 3:
        suggest("Consider more connections for this note")

    # Create note structure
    note = {
        'id': note_id,
        'title': derive_title(core),
        'type': 'atomic',
        'created': datetime.now().isoformat(),
        'status': 'seedling',
        'confidence': assess_confidence(idea, source),
        'source': source,
        'core_idea': core,
        'elaboration': '',  # To be filled
        'evidence': [],
        'connections': related,
        'implications': [],
        'questions': [],
        'my_take': ''
    }

    return note
```

## Linking Guidelines

### Connection Types

| Relationship | When to Use | Example |
|--------------|-------------|---------|
| **Related** | Concepts that inform each other | "Pre-reads" related to "Async-first" |
| **Supports** | This note provides evidence for another | This note supports "Meeting guidelines" |
| **Contradicts** | Creates tension or alternative view | "Pre-reads" vs "Spontaneous collaboration" |
| **Part of** | Belongs to a map or collection | Part of "Async practices map" |
| **Extends** | Builds on another note | Extends "Effective communication" |
| **Example of** | Concrete instance of abstract concept | Example of "Time-saving practice" |

### Minimum Connections

A healthy atomic note should have:
- At least 1 **Part of** connection (belongs to a map)
- At least 2 **Related** connections (horizontal relationships)
- Ideally 1 **Supports** or **Contradicts** (vertical relationships)

## Quality Checklist

Before finalizing an atomic note:

- [ ] Title captures the core idea
- [ ] Core idea is one clear sentence
- [ ] Elaboration provides necessary context
- [ ] At least one piece of evidence/example
- [ ] 3+ meaningful connections established
- [ ] Implications for action identified
- [ ] Personal perspective added
- [ ] Appropriate tags assigned
- [ ] Status and confidence set accurately
- [ ] Linked from at least one map note

## Common Mistakes

### Too Broad
**Wrong**: "Meeting Best Practices" (collection of ideas)
**Right**: "Pre-reads Reduce Meeting Time" (single insight)

### Too Narrow
**Wrong**: "Meeting on Jan 14 was good" (too specific)
**Right**: "Pre-reads Reduce Meeting Time" (generalizable)

### Missing Links
**Wrong**: Orphan note with no connections
**Right**: Connected to related concepts and maps

### Temporal Language
**Wrong**: "Recently, we discovered..."
**Right**: "Our Q4 2025 experiment showed..."

## Related Templates

- [[map-note.md]] - Index notes that organize atomics
- [[synthesis-note.md]] - Notes that combine multiple atomics
- [[decision-note.md]] - Decisions referencing atomics

---

*Part of KAAOS Knowledge Management Templates*
