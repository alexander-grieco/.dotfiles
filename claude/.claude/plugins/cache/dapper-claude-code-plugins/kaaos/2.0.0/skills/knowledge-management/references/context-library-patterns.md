# Context Library Architectural Patterns

Detailed patterns for organizing and structuring context libraries that scale from personal knowledge to multi-organization executive systems.

## Table of Contents

1. [Three-Level Hierarchy](#three-level-hierarchy)
2. [Note Type Taxonomy](#note-type-taxonomy)
3. [Folder Structure Patterns](#folder-structure-patterns)
4. [Scaling Patterns](#scaling-patterns)
5. [Access Control Patterns](#access-control-patterns)
6. [Evolution Patterns](#evolution-patterns)

## Three-Level Hierarchy

### Level 1: Organization Context Library

**Purpose**: Company-wide knowledge that applies broadly across projects.

**Contents**:
```
organizations/company-x/context-library/
├── 00-INDEX.md                      # Entry point
├── playbooks/                       # Reusable processes
│   ├── PLAY-hiring-process.md
│   ├── PLAY-board-meetings.md
│   └── PLAY-quarterly-planning.md
├── patterns/                        # Recognized patterns
│   ├── PATT-decision-making.md
│   ├── PATT-team-dynamics.md
│   └── PATT-execution-cadence.md
├── decisions/                       # Strategic decisions
│   ├── DEC-2026-001-market-entry.md
│   └── DEC-2026-002-hiring-freeze.md
├── references/                      # External knowledge
│   ├── REF-industry-research.md
│   └── REF-competitor-analysis.md
└── synthesis/                       # Periodic synthesis
    ├── SYNTH-2026-Q1.md
    └── SYNTH-2025-annual.md
```

**Characteristics**:
- **Longevity**: Multi-year relevance
- **Reusability**: Applied across multiple projects
- **Authority**: Senior leadership approved
- **Stability**: Changes quarterly or less frequently

**Example Content**:
```markdown
# PLAY-hiring-process.md

Our refined hiring process developed over 50+ hires across 3 companies.

## Stages
1. Async work sample (eliminates 70% of bad fits)
2. Culture + technical phone screen (30 min)
3. Virtual onsite (4 hours)
4. Reference checks (3 minimum)
5. Offer + negotiation

## Key Insights
- Work samples predict success better than interviews (our data: 0.72 correlation)
- Always check references, no exceptions (prevented 8 bad hires)
- Involve team early (increases acceptance rate by 25%)
```

### Level 2: Project Context Library

**Purpose**: Project-specific knowledge, temporary but needs structure during active work.

**Contents**:
```
organizations/company-x/projects/product-launch/context-library/
├── 00-PROJECT-INDEX.md              # Project-specific entry
├── decisions/                       # Project decisions
│   ├── DEC-architecture-choice.md
│   └── DEC-launch-date.md
├── research/                        # Project research
│   ├── market-analysis.md
│   └── competitive-landscape.md
├── meetings/                        # Key meeting notes
│   ├── kickoff-2026-01-15.md
│   └── midpoint-review-2026-02-15.md
└── learnings/                       # What we learned
    ├── LEARN-what-worked.md
    └── LEARN-what-didnt.md
```

**Characteristics**:
- **Longevity**: Project duration (3-12 months typically)
- **Promotion**: Best insights promoted to org-level
- **Closure**: Synthesized and archived at project end
- **Frequency**: Updated daily/weekly during active work

**Promotion Criteria**:
```yaml
promote_to_org_level_if:
  - reusable_across_projects: true
  - validated_by_results: true
  - requested_by_other_teams: true
  - represents_new_pattern: true
```

### Level 3: Conversation/Session Level

**Purpose**: Ephemeral working notes, most stay here, best extracted to higher levels.

**Contents**:
```
organizations/company-x/projects/product-launch/conversations/
├── 2026-01-15-session-kickoff/
│   ├── chat-transcript.md
│   ├── scratch-notes.md
│   └── extracted-insights.md
├── 2026-01-16-session-architecture/
│   └── ...
└── 2026-01-17-session-research/
    └── ...
```

**Characteristics**:
- **Longevity**: Days to weeks
- **Raw**: Unrefined, working thoughts
- **Extraction**: Agents mine for promotable insights
- **Garbage Collection**: Old sessions archived after 90 days

**Extraction Process**:
```python
def extract_from_conversation(session_path):
    """Extract insights from conversation for promotion."""

    insights = {
        'decisions': [],      # Explicit decisions made
        'frameworks': [],     # New mental models
        'patterns': [],       # Recurring themes
        'learnings': [],      # Explicit lessons
        'questions': [],      # Unresolved questions
        'actions': []         # Commitments made
    }

    # Agent scans conversation
    # Identifies extractable content
    # Creates draft atomic notes
    # Human reviews and approves

    return insights
```

## Note Type Taxonomy

### Atomic Notes

**Structure**:
```markdown
---
id: 2026-01-XXX
type: atomic
tags: [domain, subdomain, keywords]
created: YYYY-MM-DD
updated: YYYY-MM-DD
confidence: high|medium|low
source: experience|research|synthesis
---

# Single Concept Title

## Summary
One-paragraph executive summary (2-3 sentences)

## When to Use
Clear applicability criteria

## Details
Full explanation with examples

## Implementation
Concrete steps or code

## Related
[[links]] to connected notes

## Sources
Citations and experience notes
```

**Size Guidelines**:
- **Minimum**: 100 words (too short = not useful)
- **Target**: 200-500 words (sweet spot)
- **Maximum**: 1000 words (too long = should be split)

**Example - Good Atomic Note**:
```markdown
---
id: 2026-01-075
type: atomic
tags: [meetings, efficiency, remote]
created: 2026-01-20
updated: 2026-01-20
confidence: high
source: experience
---

# Meeting Pre-Reads Reduce Time by 40%

## Summary
Requiring 24-hour pre-read documents before meetings reduces meeting time by 40% while improving decision quality. Tested across 50+ meetings in 3 organizations.

## When to Use
- Strategic decisions requiring context
- Complex topics needing preparation
- Meetings with 4+ participants
- When expertise levels vary

## Details
Traditional meetings spend 60%+ time on context-setting. Pre-reads shift this to async, letting meetings focus on discussion and decisions.

**Our Data** (50 meetings tracked):
- Average meeting time: 60 min → 35 min
- Decision quality score: 6.2 → 8.1 (out of 10)
- Participant preparation: 23% → 87%
- Follow-up questions: 45% → 15%

**Required Elements**:
1. Document shared 24+ hours before
2. Max 2 pages (or 10-min read)
3. Clear decision or discussion question
4. Background, options, recommendation
5. Required reading confirmation

## Implementation
```bash
# In calendar invite
📄 Pre-Read Required (10 min): [link]
   Please confirm you've read by [time]

# Pre-read template
## Decision Needed
[One sentence]

## Background
[Context in 3-5 bullets]

## Options
1. Option A: [pros/cons]
2. Option B: [pros/cons]

## Recommendation
[With rationale]

## Questions for Discussion
1. [Question 1]
2. [Question 2]
```

## Related
- [[2026-01-042|Async Communication Principles]]
- [[2026-01-055|Decision Documentation]]
- [[PLAY-meeting-formats|Meeting Format Playbook]]

## Sources
- Applied at Company X (2024-2025): 30 meetings
- Applied at Company Y (2025-2026): 20 meetings
- Inspired by Amazon 6-pager approach
```

### Map Notes

**Purpose**: Navigation and structure, connect related atomic notes.

**Structure**:
```markdown
---
id: MAP-[topic]
type: map
tags: [navigation, [domain]]
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# [Topic] Map

High-level overview and navigation hub.

## Section 1
Brief context for this cluster

- [[note-1|Description]] - Why it matters
- [[note-2|Description]] - Why it matters
- [[note-3|Description]] - Why it matters

## Section 2
Another cluster

- [[note-4|Description]]
- [[note-5|Description]]

## Related Maps
- [[MAP-other-topic]]
```

**Map Note Patterns**:

1. **Topic Maps**: Organize by subject area
   - MAP-strategy
   - MAP-operations
   - MAP-hiring

2. **Process Maps**: Organize by workflow
   - MAP-product-development
   - MAP-quarterly-planning
   - MAP-customer-onboarding

3. **Role Maps**: Organize by function
   - MAP-ceo-practices
   - MAP-engineering-leadership
   - MAP-sales-management

4. **Temporal Maps**: Organize by time
   - MAP-2026-initiatives
   - MAP-Q1-focus-areas

### Synthesis Notes

**Purpose**: Extract patterns from multiple atomic notes over time.

**Structure**:
```markdown
---
id: SYNTH-[period]
type: synthesis
period: [timeframe]
source_notes: [count]
tags: [synthesis, patterns]
created: YYYY-MM-DD
generated_by: [agent-name]
---

# [Period] Synthesis

## Emerging Patterns

### Pattern 1: [Name]
**Frequency**: X notes across Y projects
**Description**: [Pattern description]
**Key Insights**:
- [[note-1]] [insight]
- [[note-2]] [insight]

**Recommendation**: [Action]
**Related**: [[note-a]], [[note-b]]

### Pattern 2: [Name]
[Same structure]

## Cross-Organization Learnings
[Insights that span multiple contexts]

## Recommended Actions
- [ ] Action 1
- [ ] Action 2

---
*Generated by [agent] on [date]*
*Review scheduled: [date]*
```

**Synthesis Triggers**:
```yaml
weekly:
  min_new_notes: 5
  window: 7 days
  agent: synthesis-agent

monthly:
  min_new_notes: 15
  window: 30 days
  agent: synthesis-agent

quarterly:
  min_new_notes: 40
  window: 90 days
  agent: strategic-reviewer
```

### Playbook Notes

**Purpose**: Repeatable processes with clear steps.

**Structure**:
```markdown
---
id: PLAY-[process-name]
type: playbook
tags: [playbook, [domain]]
created: YYYY-MM-DD
updated: YYYY-MM-DD
times_used: [count]
success_rate: [percentage]
---

# [Process Name] Playbook

## Purpose
Why this playbook exists

## When to Use
Clear applicability criteria

## Prerequisites
What you need before starting

## Steps

### Step 1: [Name]
**Duration**: [time]
**Responsible**: [role]
**Details**: [description]

```bash
# Code or commands if applicable
```

**Outputs**: [what this produces]
**Next**: Step 2

### Step 2: [Name]
[Same structure]

## Success Criteria
How to know if it worked

## Common Pitfalls
- Pitfall 1: [description + mitigation]
- Pitfall 2: [description + mitigation]

## Adaptations
How this has been customized for different contexts

## Metrics
- Metric 1: [current value]
- Metric 2: [current value]

## Related
- [[note-1]]
- [[PLAY-related-process]]
```

## Folder Structure Patterns

### Pattern 1: Flat with Prefixes (Small Libraries, <100 notes)

```
context-library/
├── 00-INDEX.md
├── ATOM-001-concept.md
├── ATOM-002-concept.md
├── MAP-strategy.md
├── MAP-execution.md
├── PLAY-hiring.md
├── SYNTH-2026-Q1.md
└── ...
```

**Pros**:
- Simple, everything visible
- Easy to navigate when small
- No deep nesting

**Cons**:
- Gets unwieldy at scale
- Hard to browse by category
- No natural grouping

### Pattern 2: Categorized Folders (Medium Libraries, 100-500 notes)

```
context-library/
├── 00-INDEX.md
├── strategy/
│   ├── planning/
│   ├── frameworks/
│   └── decisions/
├── operations/
│   ├── processes/
│   ├── playbooks/
│   └── tools/
├── people/
│   ├── hiring/
│   ├── development/
│   └── culture/
└── synthesis/
    ├── weekly/
    ├── monthly/
    └── quarterly/
```

**Pros**:
- Clear categorization
- Scalable to 500 notes
- Intuitive browsing

**Cons**:
- Notes can fit multiple categories
- Requires deciding on structure upfront
- Moving notes as structure evolves

### Pattern 3: Hybrid (Large Libraries, 500+ notes)

```
context-library/
├── 00-INDEX.md
├── maps/                    # All MAP notes
│   ├── MAP-strategy.md
│   └── MAP-execution.md
├── playbooks/              # All PLAY notes
├── synthesis/              # All SYNTH notes
└── atomic/                 # All atomic notes
    ├── 2026/              # Year folders
    │   ├── 01/            # Month folders
    │   │   ├── ATOM-2026-01-001.md
    │   │   └── ...
    │   └── 02/
    └── 2025/
```

**Pros**:
- Scales indefinitely
- Time-based organization for atomic notes
- Type-based for navigation notes
- Easy archival

**Cons**:
- More complex structure
- Requires discipline to maintain

## Scaling Patterns

### Single Person

```
kaaos-knowledge/
└── organizations/
    └── personal/
        ├── context-library/        # Your knowledge
        └── projects/
            ├── consulting-gig-1/
            └── side-project/
```

### Single Organization, Multiple Projects

```
kaaos-knowledge/
└── organizations/
    └── company-x/
        ├── context-library/        # Company-wide knowledge
        └── projects/
            ├── product-launch/
            │   └── context-library/
            ├── market-expansion/
            │   └── context-library/
            └── platform-rebuild/
                └── context-library/
```

### Multiple Organizations

```
kaaos-knowledge/
└── organizations/
    ├── company-x/
    │   ├── context-library/
    │   └── projects/
    ├── company-y/
    │   ├── context-library/
    │   └── projects/
    ├── advisory-client-a/
    │   ├── context-library/
    │   └── projects/
    └── personal/
        ├── context-library/
        └── projects/
```

### Shared Knowledge Patterns

```
kaaos-knowledge/
├── _shared/                    # Cross-org patterns
│   ├── universal-playbooks/
│   ├── frameworks/
│   └── meta-learnings/
└── organizations/
    ├── company-x/
    │   └── context-library/
    │       └── local-playbooks/  # Imports from _shared
    └── company-y/
```

## Access Control Patterns

### Public/Private Split

```yaml
# .kaaos/config.yaml
access_control:
  default: private

  public_contexts:
    - organizations/personal/context-library/frameworks/
    - organizations/personal/context-library/playbooks/

  private_contexts:
    - organizations/company-x/
    - organizations/company-y/
```

### Team-Based Access

```yaml
teams:
  - name: leadership
    members: [user1, user2]
    access:
      - organizations/company-x/context-library/
      - organizations/company-x/projects/*/context-library/decisions/

  - name: engineering
    members: [user3, user4]
    access:
      - organizations/company-x/projects/platform-rebuild/
```

## Evolution Patterns

### Note Lifecycle States

```markdown
---
lifecycle: draft|active|mature|archive
---
```

**Draft**: Created, needs review
**Active**: In use, being refined
**Mature**: Stable, high confidence
**Archive**: Historical reference only

### Archival Process

```bash
# Monthly archival
# Move inactive notes (not accessed in 90 days) to archive

context-library/
├── active/
│   └── [active notes]
└── archive/
    ├── 2025/
    │   ├── Q1/
    │   ├── Q2/
    │   ├── Q3/
    │   └── Q4/
    └── 2024/
```

### Version Control Integration

```bash
# Git tags for major knowledge milestones
git tag knowledge-v1.0 -m "Initial context library structure"
git tag knowledge-v1.1 -m "Post Q1 synthesis"

# Git branches for experimental knowledge
git checkout -b experiment/new-framework
# Test new organizational pattern
# Merge if successful
```

## Best Practices

1. **Start Simple**: Flat structure until 100 notes
2. **Consistent IDs**: Use date-based or sequential IDs
3. **Clear Prefixes**: MAP-, PLAY-, SYNTH-, ATOM-
4. **Regular Maintenance**: Weekly cleanup, monthly synthesis
5. **Progressive Disclosure**: Summaries link to details
6. **Bidirectional Links**: Always create backlinks
7. **Version Everything**: Git tracks all changes
8. **Extract Aggressively**: Promote project learnings to org level
