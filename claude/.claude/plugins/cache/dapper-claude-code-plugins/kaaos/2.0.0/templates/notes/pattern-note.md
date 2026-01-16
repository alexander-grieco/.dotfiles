---
template: pattern-note
version: "1.0"
description: Template for documenting recurring patterns
usage: Capture observed patterns that emerge from multiple instances
placeholders:
  - "{{PATTERN_ID}}" - Unique identifier (e.g., "PAT-2026-001")
  - "{{TITLE}}" - Pattern title
  - "{{DOMAIN}}" - Domain where pattern applies
  - "{{CREATED}}" - First observation date
---

# Pattern Note Template

Pattern notes document recurring behaviors, practices, or phenomena observed across multiple instances. Patterns emerge from evidence and represent predictive knowledge - if you see the conditions, you can expect the outcome. Well-documented patterns enable better decisions and faster learning.

## Template Structure

```markdown
---
id: {{PATTERN_ID}}
title: {{TITLE}}
type: pattern
domain: {{DOMAIN}}
created: {{CREATED}}
modified: {{MODIFIED}}
first_observed: {{FIRST_OBSERVED}}
status: emerging | established | evolving | deprecated
confidence: high | medium | low
occurrences: {{OCCURRENCE_COUNT}}
last_observed: {{LAST_OBSERVED}}
---

# {{TITLE}}

## Pattern Summary

**In brief**: {{ONE_LINE_SUMMARY}}

**Confidence**: {{CONFIDENCE}} ({{OCCURRENCE_COUNT}} observations)

## The Pattern

### What I Observe

{{OBSERVATION}}

*What specifically do I see happening repeatedly?*

### When It Appears

{{CONDITIONS}}

*Under what conditions does this pattern emerge?*

### What Follows

{{CONSEQUENCES}}

*What typically happens as a result?*

### Pattern Statement

> {{FORMAL_PATTERN_STATEMENT}}

*If [conditions], then [observation], leading to [consequences].*

## Evidence

### Instances Observed

{{#EACH INSTANCE}}
#### Instance {{INDEX}}: {{TITLE}}
**Date**: {{DATE}}
**Context**: {{CONTEXT}}

**What happened**:
{{NARRATIVE}}

**Pattern elements present**:
{{#EACH ELEMENT}}
- {{ELEMENT}}
{{/EACH}}

**Link**: [[{{NOTE_ID}}]]
{{/EACH}}

### Evidence Summary

| Instance | Date | Conditions Present | Outcome | Link |
|----------|------|-------------------|---------|------|
{{#EACH INSTANCE_ROW}}
| {{NAME}} | {{DATE}} | {{CONDITIONS}} | {{OUTCOME}} | [[{{LINK}}]] |
{{/EACH}}

### Counterexamples

{{#EACH COUNTEREXAMPLE}}
#### {{TITLE}}
**Date**: {{DATE}}
**Context**: {{CONTEXT}}

**What was different**:
{{DIFFERENCE}}

**Why pattern didn't apply**:
{{EXPLANATION}}

**Implication**: {{IMPLICATION}}
{{/EACH}}

## Analysis

### Why This Pattern Exists

{{EXPLANATION}}

*What underlying mechanism causes this pattern?*

### Boundary Conditions

**The pattern applies when**:
{{#EACH APPLIES_WHEN}}
- {{CONDITION}}
{{/EACH}}

**The pattern breaks when**:
{{#EACH BREAKS_WHEN}}
- {{CONDITION}}
{{/EACH}}

### Related Patterns

| Pattern | Relationship |
|---------|--------------|
{{#EACH RELATED_PATTERN}}
| [[{{PATTERN_ID}}]] | {{RELATIONSHIP}} |
{{/EACH}}

### Theoretical Basis

{{#IF THEORY}}
**Connects to**: {{THEORY_NAME}}

{{THEORY_EXPLANATION}}

**Source**: {{THEORY_SOURCE}}
{{/IF}}

## Implications

### For Decision-Making

{{DECISION_IMPLICATIONS}}

*How should knowing this pattern affect decisions?*

### For Practice

{{PRACTICE_IMPLICATIONS}}

*How should knowing this pattern affect daily work?*

### For Prediction

{{PREDICTION_IMPLICATIONS}}

*What can I predict based on this pattern?*

## Actions

### To Leverage This Pattern

{{#EACH LEVERAGE_ACTION}}
- {{ACTION}}
{{/EACH}}

### To Avoid This Pattern (If Negative)

{{#EACH AVOID_ACTION}}
- {{ACTION}}
{{/EACH}}

### To Strengthen This Pattern (If Positive)

{{#EACH STRENGTHEN_ACTION}}
- {{ACTION}}
{{/EACH}}

## Pattern Health

### Observation Log

| Date | Instance | Confirmed? | Notes |
|------|----------|------------|-------|
{{#EACH OBSERVATION_LOG}}
| {{DATE}} | {{INSTANCE}} | {{CONFIRMED}} | {{NOTES}} |
{{/EACH}}

### Confidence Trend

{{CONFIDENCE_TREND}}

### Next Review

**Review when**: {{REVIEW_TRIGGER}}
**Scheduled**: {{REVIEW_DATE}}

## Open Questions

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

---
*First observed: {{FIRST_OBSERVED}}*
*Last confirmed: {{LAST_OBSERVED}}*
*Observations: {{OCCURRENCE_COUNT}}*
```

## Example: Completed Pattern Note

```markdown
---
id: PAT-2026-001
title: Pre-reads Accelerate Meetings
type: pattern
domain: meetings
created: 2025-11-15
modified: 2026-01-14
first_observed: 2025-11-15
status: established
confidence: high
occurrences: 8
last_observed: 2026-01-10
---

# Pre-reads Accelerate Meetings

## Pattern Summary

**In brief**: Meetings with pre-read documents sent 24+ hours in advance consistently run 30-50% shorter while producing better outcomes.

**Confidence**: High (8 observations)

## The Pattern

### What I Observe

When a structured document (agenda, context, decision framing) is sent 24+ hours before a meeting, and participants confirm they've read it, the meeting starts faster, skips the "context dump" phase, and reaches conclusions more efficiently.

### When It Appears

- Meeting has a specific purpose (decision, planning, review)
- Pre-read document is 1-3 pages
- Pre-read sent at least 24 hours before
- Attendees confirm they've read it (or meeting is rescheduled)
- Meeting opens with "questions about the pre-read" rather than presentation

### What Follows

- Meetings run 30-50% shorter
- Higher quality discussion (deeper questions)
- Decisions made with less back-and-forth
- Better documentation (pre-read becomes record)
- Participants feel more respected (their time valued)

### Pattern Statement

> If a focused pre-read is distributed 24+ hours before a meeting, confirmed read by attendees, and the meeting opens with discussion rather than presentation, then the meeting will run 30-50% shorter with higher-quality outcomes.

## Evidence

### Instances Observed

#### Instance 1: Q4 Planning Meeting
**Date**: 2025-10-15
**Context**: Quarterly planning with 8 participants

**What happened**:
Sent 4-page planning doc on Monday, meeting on Wednesday. Started meeting with "questions about the doc?" - immediate dive into priorities debate. Meeting scheduled for 3 hours, ended in 1.5 hours with clear decisions.

**Pattern elements present**:
- Pre-read distributed 48 hours before
- Attendees confirmed reading via Slack thread
- Meeting opened with questions not presentation
- 50% time reduction

**Link**: [[2025-10-015-q4-planning]]

#### Instance 2: Frontend Hire Decision
**Date**: 2026-01-10
**Context**: Hiring decision meeting with 4 participants

**What happened**:
Sent candidate comparison doc with rubric scores. Meeting opened with "any questions about the rubric?" - no one had questions, immediately debated the decision. 30-minute meeting instead of expected 60.

**Pattern elements present**:
- Pre-read distributed 24 hours before
- Clear structure (rubric format)
- Meeting opened with questions
- 50% time reduction

**Link**: [[DEC-2026-003]]

#### Instance 3: Product Roadmap Review
**Date**: 2025-12-01
**Context**: Monthly roadmap review, 6 participants

**What happened**:
Detailed roadmap doc sent Friday for Monday meeting. High engagement - people had marked up the doc with comments. Meeting was Q&A and decision-making only. 45 minutes instead of 90 minutes scheduled.

**Pattern elements present**:
- Pre-read with 72 hours lead time
- Attendees engaged asynchronously before meeting
- 50% time reduction

**Link**: [[2025-12-roadmap-review]]

### Evidence Summary

| Instance | Date | Conditions Present | Outcome | Link |
|----------|------|-------------------|---------|------|
| Q4 Planning | 2025-10-15 | All | 50% shorter | [[2025-10-015]] |
| Product Roadmap | 2025-12-01 | All | 50% shorter | [[2025-12-roadmap]] |
| Sprint Planning | 2025-12-15 | All | 40% shorter | [[2025-12-sprint]] |
| Budget Review | 2026-01-05 | All | 35% shorter | [[2026-01-budget]] |
| Frontend Hire | 2026-01-10 | All | 50% shorter | [[DEC-2026-003]] |
| Q1 Kickoff | 2026-01-20 | All | 40% shorter | [[2026-01-q1kick]] |
| Platform Decision | 2025-11-15 | All | 45% shorter | [[DEC-2025-015]] |
| Team Retro | 2025-11-30 | Partial | 30% shorter | [[2025-11-retro]] |

### Counterexamples

#### Brainstorming Session (Dec 2025)
**Date**: 2025-12-20
**Context**: Ideation session for new feature

**What was different**:
Sent pre-read with background info, but meeting was meant to generate new ideas, not decide on existing ones.

**Why pattern didn't apply**:
Pre-reads work for convergent meetings (decisions, reviews) but may constrain divergent meetings (brainstorming, ideation). The pre-read anchored people on existing ideas.

**Implication**: Pattern has boundary condition - applies to convergent, not divergent meetings.

#### Emergency Discussion (Jan 2026)
**Date**: 2026-01-08
**Context**: Production incident response

**What was different**:
No time for pre-read - meeting called with 30 minutes notice.

**Why pattern didn't apply**:
Pattern requires preparation time. Emergency meetings can't have pre-reads.

**Implication**: Pattern requires minimum lead time. Emergency meetings are out of scope.

## Analysis

### Why This Pattern Exists

Meetings typically spend significant time on "context setting" - bringing everyone to shared understanding. This is sequential (one person talks, others listen) and inefficient. Pre-reads parallelize context acquisition - everyone reads simultaneously before the meeting.

Additionally, reading allows for:
- Personal pace (faster readers done sooner)
- Reflection time (process before responding)
- Written questions (can think before speaking)
- Reference during meeting (scroll back to context)

### Boundary Conditions

**The pattern applies when**:
- Meeting has clear purpose (decision, review, planning)
- Pre-read can be created (enough context exists)
- Attendees have time to read (not last-minute)
- Meeting type is convergent (working toward conclusion)
- Attendee count is manageable (2-10 people)

**The pattern breaks when**:
- Meeting is emergent/reactive (no time for prep)
- Meeting is divergent (ideation, brainstorming)
- Pre-read too long (>5 pages - people won't read)
- Attendees don't actually read (just agree to it)
- Topic requires real-time collaboration

### Related Patterns

| Pattern | Relationship |
|---------|--------------|
| [[PAT-2025-003\|Async-First Communication]] | Pre-reads are a form of async-first |
| [[PAT-2025-008\|Written Decisions Outperform Verbal]] | Pre-reads enable written decision framing |
| [[PAT-2025-012\|Meeting Compression]] | Pre-reads are a meeting compression technique |

### Theoretical Basis

**Connects to**: Cognitive Load Theory

When participants arrive without context, they must simultaneously learn context AND process arguments AND make decisions. Pre-reads separate learning from deciding, reducing cognitive load during the meeting.

**Source**: Educational psychology research on worked examples and cognitive load

## Implications

### For Decision-Making

When scheduling important meetings, budget time for pre-read creation and distribution. A 30-minute investment in writing a pre-read can save 60+ minutes of meeting time while improving decision quality.

### For Practice

Create pre-read templates for common meeting types:
- Decision meetings: Options, criteria, recommendation
- Planning meetings: Current state, proposed plan, open questions
- Review meetings: Metrics, insights, discussion points

### For Prediction

If someone proposes a 2-hour meeting without a pre-read for a topic that could have one, predict the meeting will run long and be less productive. Suggest pre-read first.

## Actions

### To Leverage This Pattern

- Create pre-read template library
- Add "pre-read link" field to calendar invites
- Start meetings with "questions about the pre-read?"
- Track meeting time savings to build buy-in

### To Strengthen This Pattern

- Celebrate pre-read best practices
- Document successful pre-reads as examples
- Train team on effective pre-read writing
- Add pre-read to meeting culture norms

## Pattern Health

### Observation Log

| Date | Instance | Confirmed? | Notes |
|------|----------|------------|-------|
| 2025-11-15 | Platform Decision | Yes | First observation |
| 2025-11-30 | Team Retro | Partial | Worked but less effect |
| 2025-12-01 | Roadmap Review | Yes | Strong confirmation |
| 2025-12-15 | Sprint Planning | Yes | Consistent |
| 2025-12-20 | Brainstorming | No | Identified boundary |
| 2026-01-05 | Budget Review | Yes | Consistent |
| 2026-01-08 | Emergency | No | Identified boundary |
| 2026-01-10 | Frontend Hire | Yes | Strong confirmation |

### Confidence Trend

Started as emerging pattern (Nov 2025), now established with high confidence. 6 strong confirmations, 2 identified boundary conditions that actually strengthen the pattern definition.

### Next Review

**Review when**: 5 additional observations OR counterexample that challenges boundaries
**Scheduled**: 2026-04-01

## Open Questions

- What's the optimal pre-read length? Current evidence suggests 1-3 pages.
- How do we handle people who don't read? Postpone meeting?
- Can this work for very large meetings (10+ people)?
- How does this interact with meeting recording/transcription?

---
*First observed: 2025-11-15*
*Last confirmed: 2026-01-10*
*Observations: 8 (6 confirmed, 2 boundary)*
```

## Pattern Status Levels

| Status | Definition | Criteria |
|--------|------------|----------|
| **Emerging** | Recently noticed, under investigation | 2-3 observations |
| **Established** | Confirmed through multiple instances | 5+ observations, high confidence |
| **Evolving** | Pattern changing or being refined | Boundary conditions shifting |
| **Deprecated** | No longer applies or superseded | Invalidated by evidence |

## Pattern vs Other Note Types

| Note Type | Purpose | Relationship to Patterns |
|-----------|---------|-------------------------|
| **Atomic** | Single idea/observation | May be evidence for a pattern |
| **Synthesis** | Combine multiple ideas | Patterns may emerge from synthesis |
| **Decision** | Document choice | May reference patterns as rationale |
| **Playbook** | How to do something | May be created from established pattern |

## Pattern Detection

### Signs a Pattern is Forming

1. Same observation appears in multiple notes
2. Weekly/monthly reviews highlight recurring theme
3. Synthesis note discovers common element
4. Team members report similar experiences

### Pattern Promotion

```
Observation → Observation → Observation
     ↓             ↓             ↓
     └──────── Pattern ─────────┘
                   ↓
           (if actionable)
                   ↓
              Playbook
```

## Quality Checklist

- [ ] Clear, specific pattern statement
- [ ] 3+ documented instances
- [ ] Counterexamples acknowledged
- [ ] Boundary conditions defined
- [ ] Implications actionable
- [ ] Confidence level justified
- [ ] Review schedule set
- [ ] Related patterns linked

## Related Templates

- [[atomic-note.md]] - Evidence sources for patterns
- [[synthesis-note.md]] - Where patterns may emerge
- [[playbook-note.md]] - Where patterns get codified

---

*Part of KAAOS Knowledge Management Templates*
