---
template: map-note
version: "1.0"
description: Template for creating map (index/hub) notes
usage: Organize and navigate related atomic notes, serve as entry points
placeholders:
  - "{{MAP_ID}}" - Unique identifier (e.g., "MAP-decision-frameworks")
  - "{{TITLE}}" - Map title
  - "{{DOMAIN}}" - Knowledge domain this map covers
  - "{{CREATED}}" - Creation timestamp
---

# Map Note Template

Map notes serve as navigation hubs that organize collections of related atomic notes. They provide structure, context, and entry points into knowledge domains. A well-maintained map is essential for knowledge discovery and synthesis.

## Template Structure

```markdown
---
id: {{MAP_ID}}
title: {{TITLE}}
type: map
domain: {{DOMAIN}}
created: {{CREATED}}
modified: {{MODIFIED}}
curator: {{CURATOR}}
status: active | archived | draft
coverage: comprehensive | partial | emerging
last_audit: {{LAST_AUDIT}}
---

# {{TITLE}}

> {{BRIEF_DESCRIPTION}}

## Overview

{{DOMAIN_OVERVIEW}}

*What is this domain? Why does it matter? What problems does it solve?*

## Quick Navigation

| Category | Key Notes | Status |
|----------|-----------|--------|
{{#EACH CATEGORY}}
| {{NAME}} | [[{{KEY_NOTE}}]] | {{STATUS}} |
{{/EACH}}

## Structure

### {{SECTION_1_NAME}}

{{SECTION_1_DESCRIPTION}}

{{#EACH SECTION_1_NOTES}}
- [[{{NOTE_ID}}|{{TITLE}}]] - {{BRIEF}}
  {{#IF MATURITY}}*{{MATURITY}}*{{/IF}}
{{/EACH}}

### {{SECTION_2_NAME}}

{{SECTION_2_DESCRIPTION}}

{{#EACH SECTION_2_NOTES}}
- [[{{NOTE_ID}}|{{TITLE}}]] - {{BRIEF}}
{{/EACH}}

### {{SECTION_3_NAME}}

{{SECTION_3_DESCRIPTION}}

{{#EACH SECTION_3_NOTES}}
- [[{{NOTE_ID}}|{{TITLE}}]] - {{BRIEF}}
{{/EACH}}

## Key Relationships

### Connected Maps
{{#EACH CONNECTED_MAP}}
- [[{{MAP_ID}}]]: {{RELATIONSHIP}}
{{/EACH}}

### Feeds Into
{{#EACH FEEDS_INTO}}
- [[{{NOTE_ID}}]]: This map provides foundation for...
{{/EACH}}

### Tensions and Trade-offs
{{#EACH TENSION}}
- {{TENSION_DESCRIPTION}} (see [[{{NOTE_A}}]] vs [[{{NOTE_B}}]])
{{/EACH}}

## Learning Path

For newcomers to this domain:

1. **Start here**: [[{{STARTER_NOTE}}]] - {{WHY_START}}
2. **Then read**: [[{{SECOND_NOTE}}]] - {{WHY_SECOND}}
3. **Understand tensions**: [[{{TENSION_NOTE}}]] - {{WHY_TENSION}}
4. **Apply with**: [[{{APPLICATION_NOTE}}]] - {{WHY_APPLY}}

## Domain Health

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Total notes | {{NOTE_COUNT}} | {{NOTE_TARGET}} | {{NOTE_STATUS}} |
| Avg connections | {{AVG_CONN}} | 3.0+ | {{CONN_STATUS}} |
| Recent activity | {{RECENT_COUNT}} notes (30d) | {{ACTIVITY_TARGET}} | {{ACTIVITY_STATUS}} |
| Orphan notes | {{ORPHAN_COUNT}} | 0 | {{ORPHAN_STATUS}} |

## Gaps and Opportunities

### Missing Knowledge
{{#EACH GAP}}
- **{{TOPIC}}**: {{DESCRIPTION}}
  - Priority: {{PRIORITY}}
  - Suggested approach: {{APPROACH}}
{{/EACH}}

### Areas Needing Update
{{#EACH STALE}}
- [[{{NOTE_ID}}]]: Last updated {{LAST_UPDATE}}, needs {{UPDATE_TYPE}}
{{/EACH}}

## Curation Notes

### Recent Changes
{{#EACH CHANGE}}
- {{DATE}}: {{CHANGE_DESCRIPTION}}
{{/EACH}}

### Planned Improvements
{{#EACH PLANNED}}
- {{IMPROVEMENT}}
{{/EACH}}

---
*Map curator: {{CURATOR}}*
*Last audit: {{LAST_AUDIT}}*
*Next review: {{NEXT_REVIEW}}*
```

## Example: Completed Map Note

```markdown
---
id: MAP-decision-frameworks
title: Decision Frameworks
type: map
domain: decision-making
created: 2025-10-15T09:00:00-08:00
modified: 2026-01-14T16:30:00-08:00
curator: executive-knowledge-base
status: active
coverage: comprehensive
last_audit: 2026-01-01
---

# Decision Frameworks

> A curated collection of frameworks, heuristics, and practices for making better decisions faster.

## Overview

This map organizes knowledge about decision-making: the frameworks we use, the heuristics that guide us, and the documented decisions that demonstrate application. Good decision-making is a core executive capability that compounds over time.

The goal is not to have a framework for everything, but to have the right framework for the decision at hand, and the wisdom to know when no framework is needed.

## Quick Navigation

| Category | Key Notes | Status |
|----------|-----------|--------|
| Speed | [[2026-01-020|Two-Way Door Thinking]] | Evergreen |
| Quality | [[2026-01-035|Pre-Mortem Analysis]] | Evergreen |
| Stakeholders | [[2026-01-042|RACI for Decisions]] | Budding |
| Bias | [[2025-12-088|Cognitive Bias Awareness]] | Evergreen |

## Structure

### Core Frameworks

Foundational decision-making approaches used regularly.

- [[2026-01-020|Two-Way Door Thinking]] - Reversibility determines rigor *Evergreen*
- [[2026-01-035|Pre-Mortem Analysis]] - Imagine failure before it happens *Evergreen*
- [[2026-01-042|RACI for Decisions]] - Clear accountability mapping *Budding*
- [[2025-12-015|Eisenhower Matrix]] - Urgent vs important prioritization *Evergreen*
- [[2025-11-092|First Principles Thinking]] - Break down to fundamentals *Evergreen*

### Speed Heuristics

Quick decision patterns for low-stakes choices.

- [[2026-01-020|Two-Way Door Thinking]] - If reversible, decide fast
- [[2026-01-028|10/10/10 Rule]] - How will I feel in 10 min/months/years?
- [[2026-01-033|Regret Minimization]] - What minimizes future regret?
- [[2025-12-055|Default to Action]] - When uncertain, try something *Seedling*

### Quality Techniques

Deep analysis for high-stakes decisions.

- [[2026-01-035|Pre-Mortem Analysis]] - Prospective hindsight
- [[2026-01-048|Red Team Thinking]] - Adversarial analysis
- [[2025-12-072|Decision Journal]] - Track decisions for learning *Budding*
- [[2025-11-088|Expected Value Calculation]] - Probabilistic thinking

### Stakeholder Management

Navigating decisions with multiple parties.

- [[2026-01-042|RACI for Decisions]] - Who decides, who's informed
- [[2025-12-095|Disagree and Commit]] - Move forward despite disagreement
- [[2025-11-076|Consensus vs Consent]] - Difference matters *Seedling*

### Cognitive Biases

Understanding decision pitfalls.

- [[2025-12-088|Cognitive Bias Awareness]] - Meta-note on biases
- [[2025-11-055|Confirmation Bias]] - Seeking supporting evidence
- [[2025-11-062|Sunk Cost Fallacy]] - Past investment shouldn't drive future
- [[2025-10-048|Availability Heuristic]] - Recent ≠ representative

### Applied Decisions

Documented decisions demonstrating framework use.

- [[DEC-2026-001|Market Entry Strategy]] - Used pre-mortem + stakeholder analysis
- [[DEC-2026-002|Async Standups]] - Used two-way door (reversible experiment)
- [[DEC-2026-003|Frontend Lead Hire]] - Used structured decision matrix
- [[DEC-2025-015|Platform Migration]] - Used first principles + pre-mortem

## Key Relationships

### Connected Maps
- [[MAP-strategic-planning]]: Decisions feed strategic planning
- [[MAP-leadership-practices]]: Decision-making is core leadership skill
- [[MAP-async-practices]]: Many decisions benefit from async deliberation

### Feeds Into
- [[PLAY-decision-making]]: This map informs our decision playbook
- [[PLAY-quarterly-planning]]: Framework selection for planning

### Tensions and Trade-offs
- Speed vs thoroughness (see [[2026-01-020]] vs [[2026-01-035]])
- Consensus vs velocity (see [[2025-12-095]] vs [[2026-01-028]])
- Intuition vs analysis (see [[2025-12-055]] vs [[2025-11-088]])

## Learning Path

For newcomers to decision frameworks:

1. **Start here**: [[2026-01-020|Two-Way Door Thinking]] - Foundational concept that shapes all other decisions
2. **Then read**: [[2026-01-035|Pre-Mortem Analysis]] - The most valuable analysis technique
3. **Understand tensions**: [[2025-12-095|Disagree and Commit]] - How to move forward when people disagree
4. **Apply with**: [[PLAY-decision-making]] - Our team's decision playbook

## Domain Health

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Total notes | 18 | 20 | Good |
| Avg connections | 4.2 | 3.0+ | Excellent |
| Recent activity | 6 notes (30d) | 3+ | Active |
| Orphan notes | 1 | 0 | Attention |

## Gaps and Opportunities

### Missing Knowledge
- **Group Decision Dynamics**: Team decision patterns vs individual
  - Priority: Medium
  - Suggested approach: Research group decision-making literature

- **Decision Fatigue**: How decision quality degrades
  - Priority: Low
  - Suggested approach: Personal experimentation notes

- **Framework Combinations**: Which frameworks work well together
  - Priority: High (emerging pattern from Q4)
  - Suggested approach: Synthesize from applied decisions

### Areas Needing Update
- [[2025-10-048|Availability Heuristic]]: Last updated Oct 2025, needs examples
- [[2025-11-076|Consensus vs Consent]]: Still seedling after 60 days, needs evidence

## Curation Notes

### Recent Changes
- 2026-01-14: Added DEC-2026-003 to applied decisions
- 2026-01-10: Promoted [[2026-01-035]] to evergreen status
- 2026-01-05: Created tension section based on weekly synthesis

### Planned Improvements
- Add "Framework Combinations" section based on emerging pattern
- Create visual diagram of framework relationships
- Write learning path variations for different contexts

---
*Map curator: executive-knowledge-base*
*Last audit: 2026-01-01*
*Next review: 2026-02-01*
```

## Map Note Characteristics

### Purpose of Maps

| Function | Description |
|----------|-------------|
| **Navigation** | Entry point to discover related notes |
| **Organization** | Logical grouping of atomic notes |
| **Context** | Domain overview and relationships |
| **Health** | Track gaps and staleness |
| **Learning** | Guided paths for newcomers |

### Coverage Levels

| Level | Definition | Criteria |
|-------|------------|----------|
| **Comprehensive** | Domain well-covered | 15+ notes, no major gaps |
| **Partial** | Significant coverage | 5-15 notes, some gaps identified |
| **Emerging** | New domain, early stages | <5 notes, actively growing |

## Map Structure Patterns

### By Maturity
```
## Established Concepts
- Note 1 *evergreen*
- Note 2 *evergreen*

## Growing Ideas
- Note 3 *budding*
- Note 4 *seedling*
```

### By Application
```
## Theory
- Foundational concepts

## Practice
- How-to and techniques

## Examples
- Applied instances
```

### By Hierarchy
```
## Overview
- Big picture

## Deep Dives
- Detailed exploration

## Related
- Adjacent topics
```

## Curation Best Practices

### Regular Audits

Audit maps monthly:
1. Check for orphaned notes that should be linked
2. Identify stale notes needing refresh
3. Note gaps in coverage
4. Update domain health metrics
5. Review learning path relevance

### Connection Maintenance

```python
def audit_map(map_note, knowledge_base):
    """Audit a map note for health."""

    issues = []

    # Check all linked notes exist
    for link in map_note.links:
        if not note_exists(knowledge_base, link.target):
            issues.append(f"Broken link: {link.target}")

    # Find orphan notes that might belong
    domain_keywords = extract_keywords(map_note)
    potential_orphans = find_notes_by_keywords(
        knowledge_base,
        domain_keywords,
        exclude=map_note.links
    )
    for orphan in potential_orphans:
        if orphan.backlinks_count == 0:
            issues.append(f"Potential orphan: {orphan.id} - {orphan.title}")

    # Check staleness
    for link in map_note.links:
        note = get_note(knowledge_base, link.target)
        days_since_update = (datetime.now() - note.modified).days
        if days_since_update > 90:
            issues.append(f"Stale note: {note.id} ({days_since_update} days)")

    return issues
```

## Map Types

| Type | Purpose | Example |
|------|---------|---------|
| **Topic Map** | Single domain | MAP-decision-frameworks |
| **Project Map** | Project-specific knowledge | projects/launch/00-INDEX |
| **Temporal Map** | Time-based organization | MAP-2026-Q1 |
| **Comparison Map** | Contrasting approaches | MAP-sync-vs-async |

## Quality Checklist

Before publishing a map note:

- [ ] Clear overview explains the domain
- [ ] Notes organized into logical sections
- [ ] Each section has a brief description
- [ ] Key relationships to other maps identified
- [ ] Learning path provided for newcomers
- [ ] Health metrics current
- [ ] Gaps documented with priorities
- [ ] Recent curation notes present
- [ ] All linked notes verified to exist
- [ ] Coverage level accurately assessed

## Related Templates

- [[atomic-note.md]] - Notes organized by this map
- [[synthesis-note.md]] - Notes that combine map contents
- [[pattern-note.md]] - Patterns emerging from map

---

*Part of KAAOS Knowledge Management Templates*
