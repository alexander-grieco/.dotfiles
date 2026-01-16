---
template: synthesis-note
version: "1.0"
description: Template for creating synthesis notes
usage: Combine multiple atomic notes into higher-order insights
placeholders:
  - "{{NOTE_ID}}" - Unique identifier (e.g., "SYN-2026-01-001")
  - "{{TITLE}}" - Synthesis title
  - "{{CREATED}}" - Creation timestamp
  - "{{SOURCE_NOTES}}" - List of notes being synthesized
---

# Synthesis Note Template

Synthesis notes combine multiple atomic notes to create higher-order insights. They emerge from patterns across notes and represent understanding that transcends individual ideas. Synthesis is where knowledge compounding happens.

## Template Structure

```markdown
---
id: {{NOTE_ID}}
title: {{TITLE}}
type: synthesis
created: {{CREATED}}
modified: {{MODIFIED}}
source_notes: {{SOURCE_NOTES}}
synthesis_method: {{METHOD}}
confidence: high | medium | low
status: draft | published | reviewed
trigger: {{TRIGGER}}
---

# {{TITLE}}

## Synthesis Statement

{{CORE_SYNTHESIS}}

*The key insight that emerges from combining these sources.*

## Source Material

### Notes Synthesized

{{#EACH SOURCE_NOTE}}
#### [[{{NOTE_ID}}|{{TITLE}}]]
**Core idea**: {{CORE_IDEA}}
**Contribution**: {{CONTRIBUTION_TO_SYNTHESIS}}
{{/EACH}}

### Why These Notes

{{SELECTION_RATIONALE}}

*What prompted combining these specific notes? What pattern or question led here?*

## The Synthesis

### Observation

{{OBSERVATION}}

*What I noticed when looking across these notes together.*

### Connection

{{CONNECTION}}

*How these ideas relate to each other in ways not obvious individually.*

### Emergence

{{EMERGENCE}}

*What new understanding emerges from this combination?*

### Integration

{{INTEGRATION}}

*How this synthesis integrates into the broader knowledge base.*

## Evidence for Synthesis

### Supporting Patterns

{{#EACH PATTERN}}
- **{{PATTERN_NAME}}**: {{EVIDENCE}}
{{/EACH}}

### Counterexamples

{{#EACH COUNTEREXAMPLE}}
- **{{CONTEXT}}**: {{DESCRIPTION}}
  - Implication: {{IMPLICATION}}
{{/EACH}}

### Confidence Assessment

| Factor | Assessment | Notes |
|--------|------------|-------|
| Source quality | {{SOURCE_QUALITY}} | {{SOURCE_NOTES}} |
| Pattern strength | {{PATTERN_STRENGTH}} | {{PATTERN_COUNT}} instances |
| Counterevidence | {{COUNTER_STRENGTH}} | {{COUNTER_COUNT}} cases |
| Time tested | {{TIME_TESTED}} | {{DURATION}} |

## Implications

### Theoretical

{{THEORETICAL_IMPLICATIONS}}

*What does this synthesis suggest about how things work?*

### Practical

{{PRACTICAL_IMPLICATIONS}}

*What actions or changes does this synthesis warrant?*

### Questions Raised

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

## Applications

{{#EACH APPLICATION}}
### {{CONTEXT}}
{{DESCRIPTION}}

**Example**: {{EXAMPLE}}
{{/EACH}}

## Related Syntheses

{{#EACH RELATED_SYNTHESIS}}
- [[{{NOTE_ID}}]]: {{RELATIONSHIP}}
{{/EACH}}

## Validation Plan

To strengthen this synthesis:

{{#EACH VALIDATION_STEP}}
1. {{STEP}}
{{/EACH}}

## Evolution

### History
{{#EACH EVOLUTION}}
- {{DATE}}: {{CHANGE}}
{{/EACH}}

### Future Development

{{FUTURE_DEVELOPMENT}}

---
*Synthesis trigger: {{TRIGGER}}*
*Method: {{METHOD}}*
*Reviewed by: {{REVIEWER}}*
```

## Example: Completed Synthesis Note

```markdown
---
id: SYN-2026-01-001
title: Async Practices Compound Through Documentation
type: synthesis
created: 2026-01-15T10:00:00-08:00
modified: 2026-01-15T14:30:00-08:00
source_notes:
  - 2026-01-050 # Pre-reads reduce meeting time
  - 2026-01-028 # Written decisions outperform verbal
  - PLAY-async-first # Async-first communication playbook
  - 2025-12-088 # Knowledge capture in meetings
synthesis_method: pattern-emergence
confidence: high
status: published
trigger: Weekly synthesis 2026-W03
---

# Async Practices Compound Through Documentation

## Synthesis Statement

Async communication practices don't just save time in the moment - they create documentation artifacts that compound in value over time, making each subsequent interaction more efficient and informed.

## Source Material

### Notes Synthesized

#### [[2026-01-050|Pre-reads Reduce Meeting Time by 40%]]
**Core idea**: Written context before meetings eliminates redundant presentation.
**Contribution**: Shows documentation saves synchronous time.

#### [[2026-01-028|Written Decisions Outperform Verbal]]
**Core idea**: Documented decisions are clearer, more traceable, and better considered.
**Contribution**: Shows documentation improves decision quality.

#### [[PLAY-async-first|Async-First Communication Playbook]]
**Core idea**: Default to async, use sync for relationship and complexity.
**Contribution**: Provides framework showing when async works best.

#### [[2025-12-088|Knowledge Capture in Meetings]]
**Core idea**: Meetings generate knowledge that's often lost without documentation.
**Contribution**: Shows the cost of not documenting.

### Why These Notes

These notes kept appearing together in my thinking. Each individually makes a case for async/documentation practices. Together, they suggest something larger: there's a compounding effect where documentation creates future efficiency, not just present clarity.

## The Synthesis

### Observation

Each async practice (pre-reads, written decisions, documented discussions) creates an artifact. These artifacts aren't just records - they're reusable assets.

### Connection

The pre-read from meeting A becomes context for meeting B. The decision document from Q1 becomes the reference for Q2 review. The playbook becomes the training material for new hires.

### Emergence

**The compounding insight**: Each piece of documentation serves double duty:
1. **Immediate value**: Saves time, improves quality in current context
2. **Future value**: Becomes searchable, reusable knowledge asset

This creates a flywheel:
- More documentation → Better future meetings → More documentation created
- Better decisions → Clearer references → Better future decisions

### Integration

This synthesis explains why knowledge management systems become more valuable over time. It's not just accumulation - it's compounding returns on documentation investment.

## Evidence for Synthesis

### Supporting Patterns

- **Pre-read reuse**: 3 pre-reads from Q4 were directly referenced in Q1 planning
- **Decision references**: DEC-2025-015 cited in 4 subsequent decisions
- **Playbook evolution**: PLAY-hiring updated 6 times, each update building on previous
- **Search behavior**: Knowledge base searches increased 40% as content grew

### Counterexamples

- **Over-documentation**: Some notes never referenced again (cost without return)
  - Implication: Quality matters more than quantity
- **Stale documentation**: Old docs referenced as if current
  - Implication: Maintenance is part of the system

### Confidence Assessment

| Factor | Assessment | Notes |
|--------|------------|-------|
| Source quality | High | 4 well-evidenced notes |
| Pattern strength | Strong | 5 supporting patterns |
| Counterevidence | Moderate | 2 valid counterexamples |
| Time tested | 3 months | Q4 2025 to Q1 2026 |

## Implications

### Theoretical

Documentation isn't just a communication practice - it's a form of organizational capital that appreciates over time. This suggests treating documentation as an investment, not a cost.

### Practical

1. **Budget documentation time**: It's investment, not overhead
2. **Make docs findable**: Search and linking are force multipliers
3. **Maintain docs**: Depreciation happens without maintenance
4. **Track reuse**: Measure documentation ROI through references

### Questions Raised

- What's the optimal documentation density?
- How do we measure documentation ROI?
- When does documentation overhead exceed returns?
- How do we deprecate outdated documentation?

## Applications

### Team Practices
**Description**: Apply compounding lens to team documentation practices.

**Example**: Track which documents get reused most. Invest more in those patterns. Create templates for high-reuse document types.

### Knowledge Base Design
**Description**: Design for compounding from the start.

**Example**: Every document should have clear tags, cross-references, and be searchable. The investment pays off as the corpus grows.

### Meeting Culture
**Description**: Frame documentation as investment, not busywork.

**Example**: "This pre-read took 30 minutes to write. It saved 40 minutes in the meeting. And we can reference it in Q2 planning."

## Related Syntheses

- [[SYN-2025-12-003|Knowledge Work Productivity]]: Earlier synthesis on productivity patterns
- [[SYN-2026-01-002|Meeting Efficiency Flywheel]]: Related synthesis on meetings

## Validation Plan

To strengthen this synthesis:

1. Track documentation reuse metrics for next quarter
2. Interview team members about documentation value perception
3. A/B test teams with high vs low documentation practices
4. Survey for counterexamples where documentation didn't help

## Evolution

### History
- 2026-01-15: Initial synthesis from weekly review
- 2026-01-15: Added counterexamples section after peer review

### Future Development

Plan to revisit after Q1 with quantitative evidence. Consider creating [[PLAY-documentation-as-investment]] playbook if pattern holds.

---
*Synthesis trigger: Weekly synthesis 2026-W03*
*Method: Pattern emergence from weekly review*
*Reviewed by: Strategic reviewer agent*
```

## Synthesis Methods

| Method | Description | Best For |
|--------|-------------|----------|
| **Pattern Emergence** | Noticing recurring themes across notes | Weekly/monthly reviews |
| **Tension Resolution** | Reconciling contradictory notes | Conflicting ideas |
| **Gap Bridging** | Connecting previously unlinked domains | Cross-domain insights |
| **Abstraction** | Finding general principle from specifics | Multiple examples |
| **Integration** | Combining complementary ideas | Related concepts |

## Synthesis Triggers

Common triggers for synthesis:

1. **Scheduled reviews**: Weekly/monthly synthesis prompts
2. **Pattern detection**: Agent identifies recurring theme
3. **Question exploration**: Pursuing a specific question
4. **Decision support**: Need to synthesize for a decision
5. **Teaching**: Explaining something forces synthesis

## Quality Criteria

### Strong Synthesis

- Sources are high-quality atomic notes
- Connection is non-obvious (not just grouping)
- Emergence creates new understanding
- Implications are actionable
- Counterexamples acknowledged

### Weak Synthesis

- Just summarizing sources (no new insight)
- Obvious connection (should be a map instead)
- No practical implications
- Ignores counterevidence
- Sources are weak or speculative

## Synthesis vs Other Note Types

| Type | Purpose | Relationship |
|------|---------|--------------|
| **Atomic** | Single idea | Raw material for synthesis |
| **Map** | Organize related notes | Groups without synthesizing |
| **Synthesis** | Create emergent insight | Combines with new insight |
| **Decision** | Document choices | May use synthesis as input |
| **Playbook** | Provide guidance | May be created from synthesis |

## Creation Workflow

```python
def create_synthesis(trigger, source_notes):
    """Create a synthesis note from multiple sources."""

    # Validate sources
    if len(source_notes) < 2:
        raise ValueError("Synthesis requires at least 2 source notes")

    for note in source_notes:
        if note.confidence == 'low':
            warn(f"Source {note.id} has low confidence")

    # Extract core ideas
    core_ideas = [extract_core(note) for note in source_notes]

    # Identify connection
    connection = identify_connection(core_ideas)

    if connection.obviousness > 0.8:
        suggest("Consider a map note instead - connection is obvious")

    # Generate synthesis structure
    synthesis = {
        'id': generate_synthesis_id(),
        'type': 'synthesis',
        'source_notes': [n.id for n in source_notes],
        'trigger': trigger,
        'synthesis_method': determine_method(connection),
        'observation': '',  # To be filled
        'connection': connection.description,
        'emergence': '',  # To be filled - the key insight
        'confidence': calculate_confidence(source_notes)
    }

    return synthesis
```

## Related Templates

- [[atomic-note.md]] - Source material for synthesis
- [[map-note.md]] - Organization without synthesis
- [[pattern-note.md]] - Patterns that may trigger synthesis

---

*Part of KAAOS Knowledge Management Templates*
