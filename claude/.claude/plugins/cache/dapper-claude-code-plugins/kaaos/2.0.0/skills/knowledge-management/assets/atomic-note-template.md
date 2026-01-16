# Atomic Note Template

Comprehensive template and guide for creating atomic notes - the fundamental building blocks of a Zettelkasten-inspired knowledge system.

## Table of Contents

1. [What is an Atomic Note](#what-is-an-atomic-note)
2. [Template Structure](#template-structure)
3. [Frontmatter Reference](#frontmatter-reference)
4. [Content Sections](#content-sections)
5. [Linking Guidelines](#linking-guidelines)
6. [Quality Checklist](#quality-checklist)
7. [Examples by Domain](#examples-by-domain)
8. [Anti-Patterns](#anti-patterns)
9. [Automation Support](#automation-support)

## What is an Atomic Note

### Definition

An atomic note captures **one complete idea** that can stand alone and be reused across contexts. It is:

- **Self-contained**: Understandable without other notes
- **Focused**: Single concept, not a collection
- **Reusable**: Applicable beyond original context
- **Connected**: Links to related ideas
- **Evergreen**: Updated as understanding evolves

### Atomicity Test

Before creating a note, ask:

```yaml
atomicity_checklist:
  - question: "Can I summarize this in one sentence?"
    purpose: "Ensures single concept focus"

  - question: "Would this be useful in a different project?"
    purpose: "Tests reusability"

  - question: "Does this need splitting into multiple notes?"
    purpose: "Prevents concept overload"

  - question: "Is there existing note I should extend instead?"
    purpose: "Prevents duplication"

  - question: "Will this still be relevant in 6 months?"
    purpose: "Tests evergreen quality"
```

### Size Guidelines

```markdown
| Quality | Word Count | Characteristics |
|---------|------------|-----------------|
| Too Short | < 100 | Missing context, not useful |
| Ideal | 200-500 | Complete, focused, scannable |
| Acceptable | 500-800 | Rich detail, still single concept |
| Too Long | > 1000 | Likely needs splitting |
```

## Template Structure

### Basic Template

```markdown
---
id: ATOM-YYYY-MM-XXX
type: atomic
title: "[Concept Title]"
tags: [primary-domain, secondary-domain, keywords]
created: YYYY-MM-DD
updated: YYYY-MM-DD
confidence: high|medium|low
source: experience|research|synthesis|conversation
author: [name or "system"]
---

# [Concept Title]

## Summary

[2-3 sentence executive summary. What is this? Why does it matter?]

## When to Use

[Clear applicability criteria - when is this relevant?]

- Situation 1
- Situation 2
- Situation 3

## Details

[Full explanation with examples and context]

## Implementation

[Practical application - code, steps, or process]

```[language]
# Code example if applicable
```

## Benefits

- Benefit 1
- Benefit 2
- Benefit 3

## Limitations

- Limitation 1 and when it matters
- Limitation 2 and mitigation

## Related

- [[note-id|Title]] - [Why this link matters]
- [[note-id|Title]] - [Relationship description]
- [[note-id|Title]] - [Connection context]

## Sources

- [Citation or experience reference]
- [Additional sources]

---
*Created from: [context/session]*
*Last reviewed: YYYY-MM-DD*
```

### Minimal Template (Quick Capture)

```markdown
---
id: ATOM-YYYY-MM-XXX
type: atomic
tags: [to-categorize]
created: YYYY-MM-DD
confidence: low
source: conversation
---

# [Quick Title]

## Summary

[Core insight in 1-2 sentences]

## Details

[Brief elaboration]

## Related

- [[to-be-linked]]

---
*Needs: expansion, categorization, linking*
```

### Extended Template (Deep Concepts)

```markdown
---
id: ATOM-YYYY-MM-XXX
type: atomic
title: "[Concept Title]"
tags: [primary, secondary, tertiary]
created: YYYY-MM-DD
updated: YYYY-MM-DD
confidence: high
source: research
author: [name]
reviewed_by: [names]
version: 1.0
---

# [Concept Title]

## Summary

[Executive summary: 2-3 sentences]

## Context

[Background needed to understand this concept]

### Prerequisites

- Familiarity with [[concept-1]]
- Understanding of [[concept-2]]

## When to Use

### Ideal Conditions

- Condition 1
- Condition 2

### Avoid When

- Contraindication 1
- Contraindication 2

## Core Concept

[Main explanation - the heart of the note]

### Key Principles

1. **Principle 1**: Explanation
2. **Principle 2**: Explanation
3. **Principle 3**: Explanation

### Detailed Breakdown

[Deeper explanation with subsections as needed]

## Implementation

### Step-by-Step

1. Step 1
2. Step 2
3. Step 3

### Code Example

```python
# Implementation code
def example_implementation():
    """Demonstrates the concept."""
    pass
```

### Common Variations

- Variation A: [when and how]
- Variation B: [when and how]

## Results & Evidence

### Quantitative

- Metric 1: [value] (from [source])
- Metric 2: [value] (from [source])

### Qualitative

- Observation 1
- Observation 2

## Benefits

| Benefit | Impact | Evidence |
|---------|--------|----------|
| Benefit 1 | High | [source] |
| Benefit 2 | Medium | [source] |

## Limitations

### Known Constraints

- Constraint 1: [mitigation]
- Constraint 2: [mitigation]

### Edge Cases

- Edge case 1: How to handle
- Edge case 2: How to handle

## Related Concepts

### Extends

- [[base-concept]] - This note builds on...

### Compared With

- [[alternative-concept]] - Differs in...

### Applied In

- [[application-note]] - Used for...

### See Also

- [[related-concept]] - Tangentially related

## Sources

### Primary

- [Primary source with citation]

### Secondary

- [Supporting source]
- [Additional reference]

### Experience

- Applied in [context] with [results]

## Changelog

| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial creation | [name] |
| YYYY-MM-DD | Added evidence section | [name] |

---
*Part of: [[MAP-topic]]*
*Next review: YYYY-MM-DD*
```

## Frontmatter Reference

### Required Fields

```yaml
id:
  format: "ATOM-YYYY-MM-XXX"
  example: "ATOM-2026-01-042"
  description: "Unique identifier for the note"
  auto_generated: true

type:
  value: "atomic"
  description: "Note type classification"

tags:
  format: "[tag1, tag2, tag3]"
  min: 1
  max: 7
  description: "Categorization tags for discovery"

created:
  format: "YYYY-MM-DD"
  description: "Creation date"
  auto_generated: true
```

### Optional Fields

```yaml
updated:
  format: "YYYY-MM-DD"
  description: "Last modification date"
  auto_updated: true

confidence:
  values: ["high", "medium", "low"]
  default: "medium"
  description: "Confidence in the content accuracy"
  guidelines:
    high: "Validated through experience or research"
    medium: "Reasonable belief, needs validation"
    low: "Speculative or uncertain"

source:
  values: ["experience", "research", "synthesis", "conversation", "external"]
  description: "Origin of the knowledge"

author:
  format: "string or list"
  description: "Who created the note"

title:
  format: "string"
  description: "Full title (can differ from filename)"

version:
  format: "X.Y"
  description: "Version for major revisions"

reviewed_by:
  format: "[names]"
  description: "Who reviewed/validated content"

supersedes:
  format: "note-id"
  description: "ID of note this replaces"

superseded_by:
  format: "note-id"
  description: "ID of note that replaces this"
```

### Tag Taxonomy

```yaml
# Recommended tag categories

domain_tags:
  - strategy
  - operations
  - leadership
  - engineering
  - product
  - finance
  - people

concept_tags:
  - framework
  - pattern
  - principle
  - technique
  - tool

context_tags:
  - remote
  - startup
  - enterprise
  - personal
  - team

quality_tags:
  - validated
  - experimental
  - deprecated
```

## Content Sections

### Summary Section

**Purpose**: Enable quick scanning and decision on whether to read further.

**Guidelines**:
- 2-3 sentences maximum
- Answer: What is this? Why does it matter?
- No jargon without explanation
- Standalone comprehensibility

**Good Example**:
```markdown
## Summary

Pre-mortem analysis prevents project failures by imagining failure scenarios before starting. Teams that run pre-mortems identify 30% more risks than traditional planning and create actionable mitigations. Best used at project kickoffs or before major decisions.
```

**Bad Example**:
```markdown
## Summary

This note is about pre-mortems. Pre-mortems are useful for projects.
```

### When to Use Section

**Purpose**: Help readers quickly determine relevance.

**Guidelines**:
- Concrete scenarios, not abstract descriptions
- Include both positive (use when) and negative (avoid when) criteria
- Be specific enough to be actionable

**Template**:
```markdown
## When to Use

Use this when:
- [Specific situation 1]
- [Specific situation 2]
- [Specific situation 3]

Avoid when:
- [Contraindication 1]
- [Contraindication 2]
```

### Details Section

**Purpose**: Provide full explanation for those who need depth.

**Guidelines**:
- Progressive disclosure: start broad, get specific
- Use subheadings for long sections
- Include examples throughout
- Explain the "why" not just the "what"

### Implementation Section

**Purpose**: Make the concept actionable.

**Guidelines**:
- Concrete steps or code
- Copy-pasteable where possible
- Include context for when to modify
- Show both simple and complex cases

**Example**:
```markdown
## Implementation

### Quick Start
```bash
# Run pre-mortem in 15 minutes
1. Set timer: 5 min
2. Prompt: "It's [date + 6 months]. The project failed. Why?"
3. Collect responses (anonymous)
4. Group and discuss top themes
5. Assign risk owners
```

### Full Process
For strategic initiatives, use the extended 60-minute format:

```python
def run_extended_premortem(project_name: str, team: list) -> dict:
    """
    Extended pre-mortem for high-stakes projects.

    Args:
        project_name: Name of the project
        team: List of team member names

    Returns:
        Dictionary with identified risks and owners
    """
    phases = [
        ("context_setting", 5),      # Explain the scenario
        ("silent_writing", 10),       # Individual risk identification
        ("sharing", 15),              # Round-robin sharing
        ("clustering", 10),           # Group similar risks
        ("prioritization", 10),       # Vote on top risks
        ("mitigation_planning", 10),  # Assign owners and actions
    ]

    results = {
        "project": project_name,
        "participants": team,
        "risks": [],
        "mitigations": []
    }

    for phase, duration in phases:
        run_phase(phase, duration, results)

    return results
```
```

### Related Section

**Purpose**: Connect to knowledge graph and provide navigation.

**Guidelines**:
- Minimum 3 links for meaningful connectivity
- Maximum 7 links to maintain focus
- Include relationship context
- Use semantic link types where helpful

**Format**:
```markdown
## Related

### Builds On
- [[2026-01-005|Risk Assessment Basics]] - Foundation for this technique

### Alternatives
- [[2026-01-010|FMEA Analysis]] - More structured, better for technical systems
- [[2026-01-012|Red Team Review]] - Adversarial approach to risk finding

### Applications
- [[PLAY-project-kickoff]] - Uses pre-mortem in Step 3
- [[DEC-2026-001|Launch Decision]] - Applied pre-mortem before deciding

### See Also
- [[2026-01-015|Psychological Safety]] - Required for honest pre-mortem input
```

## Linking Guidelines

### Link Quality Over Quantity

```markdown
Bad: [[2026-01-020]]
Good: [[2026-01-020|Decision Reversibility]] - Use to categorize pre-mortem risks

Bad: See also: [[note1]], [[note2]], [[note3]], [[note4]], [[note5]]
Good:
- [[note1|Risk Assessment]] - Foundation concept
- [[note2|Decision Logs]] - Capture pre-mortem outputs here
```

### Semantic Link Types

```yaml
link_types:
  extends:
    prefix: "Extends:"
    meaning: "Builds directly on this concept"
    example: "Extends: [[base-framework]] - Adds remote team considerations"

  specializes:
    prefix: "Specializes:"
    meaning: "Specific case of broader concept"
    example: "Specializes: [[risk-analysis]] - For product launches specifically"

  cf:
    prefix: "Cf:"
    meaning: "Compare with alternative approach"
    example: "Cf: [[FMEA]] - More structured but slower"

  requires:
    prefix: "Requires:"
    meaning: "Prerequisite understanding"
    example: "Requires: [[psychological-safety]] - Team must feel safe to share"

  applied_in:
    prefix: "Applied in:"
    meaning: "Real-world usage example"
    example: "Applied in: [[PROJECT-alpha-launch]] - Identified 3 critical risks"
```

### Bidirectional Linking

Always create backlinks when referencing notes:

```markdown
# In new note (2026-03-050)
## Related
- [[2026-01-001|Pre-Mortem Analysis]] - Used this framework

# Update 2026-01-001 to add:
## Backlinks
- [[2026-03-050|Sprint Planning Q2]] - Applied pre-mortem (2026-03-15)
```

## Quality Checklist

### Before Publishing

```yaml
checklist:
  structure:
    - [ ] Frontmatter complete (id, type, tags, created)
    - [ ] Summary is 2-3 sentences
    - [ ] When to Use section included
    - [ ] At least 3 Related links with context

  content:
    - [ ] Single concept focus (atomicity)
    - [ ] Between 200-800 words
    - [ ] Examples provided
    - [ ] Actionable implementation

  quality:
    - [ ] Standalone comprehensibility
    - [ ] No orphan references (all links valid)
    - [ ] Confidence level accurate
    - [ ] Source attributed

  meta:
    - [ ] Filename matches ID
    - [ ] Tags follow taxonomy
    - [ ] No duplicate note exists
```

### Quality Scoring

```python
def calculate_note_quality(note_content: str, frontmatter: dict) -> dict:
    """Calculate quality score for an atomic note."""

    scores = {
        'structure': 0,
        'content': 0,
        'connectivity': 0,
        'total': 0
    }

    # Structure scoring (max 30)
    if frontmatter.get('id'):
        scores['structure'] += 5
    if frontmatter.get('tags') and len(frontmatter['tags']) >= 2:
        scores['structure'] += 5
    if '## Summary' in note_content:
        scores['structure'] += 10
    if '## When to Use' in note_content:
        scores['structure'] += 5
    if '## Related' in note_content:
        scores['structure'] += 5

    # Content scoring (max 40)
    word_count = len(note_content.split())
    if 200 <= word_count <= 800:
        scores['content'] += 15
    elif 100 <= word_count < 200 or 800 < word_count <= 1000:
        scores['content'] += 10

    if '```' in note_content:  # Has code examples
        scores['content'] += 10
    if '## Benefits' in note_content or '## Limitations' in note_content:
        scores['content'] += 10
    if note_content.count('- ') >= 5:  # Has lists
        scores['content'] += 5

    # Connectivity scoring (max 30)
    link_count = note_content.count('[[')
    if link_count >= 3:
        scores['connectivity'] += 15
    elif link_count >= 1:
        scores['connectivity'] += 5

    # Check for contextual links (has description after link)
    contextual_links = len(re.findall(r'\[\[.*?\]\].*?-.*?\n', note_content))
    if contextual_links >= 2:
        scores['connectivity'] += 15
    elif contextual_links >= 1:
        scores['connectivity'] += 10

    scores['total'] = sum(scores.values())

    return scores
```

## Examples by Domain

### Strategy Example

```markdown
---
id: ATOM-2026-01-042
type: atomic
tags: [strategy, decision-making, reversibility]
created: 2026-01-15
confidence: high
source: experience
---

# One-Way vs Two-Way Door Decisions

## Summary

Categorizing decisions by reversibility enables faster decision-making. Two-way doors (reversible) should be made quickly by individuals; one-way doors (irreversible) deserve careful analysis. Most decisions are two-way doors incorrectly treated as one-way.

## When to Use

- Before any significant decision
- When team is stuck in analysis paralysis
- During planning sessions
- When delegating decision authority

## Details

Jeff Bezos popularized this framework at Amazon:

**One-Way Doors**: Irreversible or very costly to reverse
- Major acquisitions
- Large technology platform choices
- Key executive hires
- Market exits

**Two-Way Doors**: Easily reversible with low cost
- Feature launches (can remove)
- Pricing experiments (can change)
- Process changes (can revert)
- Most hiring decisions (can part ways)

**The Error Pattern**: Organizations default to treating all decisions as one-way doors, creating:
- Slow decision cycles
- Excessive approval chains
- Risk aversion that prevents learning
- Competitive disadvantage

## Implementation

```python
def categorize_decision(decision: dict) -> str:
    """
    Categorize a decision as one-way or two-way door.

    Returns: 'one-way' or 'two-way'
    """
    factors = {
        'reversibility_cost': decision.get('cost_to_reverse', 0),
        'time_to_reverse': decision.get('days_to_reverse', 0),
        'stakeholder_impact': decision.get('people_affected', 0),
        'strategic_importance': decision.get('strategic_weight', 0)
    }

    # One-way indicators
    if factors['reversibility_cost'] > 100000:
        return 'one-way'
    if factors['time_to_reverse'] > 180:  # 6 months
        return 'one-way'
    if factors['strategic_importance'] > 8:  # out of 10
        return 'one-way'

    return 'two-way'
```

**Decision Protocol**:
| Door Type | Decision Maker | Timeline | Required |
|-----------|---------------|----------|----------|
| Two-way | Individual/Team | Same day | Inform |
| One-way | Leadership | 1-2 weeks | Approve |

## Benefits

- Faster overall decision velocity
- Appropriate resources for important decisions
- Empowered teams for routine decisions
- Reduced organizational friction

## Limitations

- Requires honest assessment of reversibility
- Some decisions appear two-way but have hidden one-way aspects
- Cultural change needed to trust the framework

## Related

- [[2026-01-001|Pre-Mortem Analysis]] - Use for one-way door decisions
- [[2026-01-045|Decision Logs]] - Document both types
- Cf: [[2026-01-050|RAPID Framework]] - More detailed role clarity

## Sources

- Jeff Bezos, Amazon shareholder letters
- Applied at 5 organizations, 100+ decisions categorized
```

### Technical Example

```markdown
---
id: ATOM-2026-02-015
type: atomic
tags: [engineering, architecture, caching]
created: 2026-02-10
confidence: high
source: experience
---

# Cache-Aside Pattern for Read-Heavy Workloads

## Summary

Cache-aside (lazy loading) loads data into cache only when requested, reducing cache memory usage while maintaining low latency for frequently accessed data. Ideal for read-heavy workloads with tolerance for occasional cache misses.

## When to Use

- Read-heavy applications (>80% reads)
- Data that doesn't change frequently
- When cache memory is limited
- When some staleness is acceptable

Avoid when:
- Write-heavy workloads
- Strong consistency required
- Data changes faster than TTL

## Details

### Pattern Flow

1. Application receives read request
2. Check cache for data
3. If hit: return cached data
4. If miss: load from database, store in cache, return

### Key Characteristics

- **Lazy**: Only caches data that's actually requested
- **Resilient**: Cache failure doesn't break application
- **Simple**: No complex cache synchronization

## Implementation

```typescript
interface CacheAsideConfig {
  ttlSeconds: number;
  keyPrefix: string;
}

class CacheAsideRepository<T> {
  constructor(
    private cache: CacheClient,
    private database: DatabaseClient,
    private config: CacheAsideConfig
  ) {}

  async get(id: string): Promise<T | null> {
    const cacheKey = `${this.config.keyPrefix}:${id}`;

    // Try cache first
    const cached = await this.cache.get(cacheKey);
    if (cached) {
      return JSON.parse(cached) as T;
    }

    // Cache miss - load from database
    const data = await this.database.findById(id);
    if (!data) {
      return null;
    }

    // Store in cache for next time
    await this.cache.setex(
      cacheKey,
      this.config.ttlSeconds,
      JSON.stringify(data)
    );

    return data;
  }

  async invalidate(id: string): Promise<void> {
    const cacheKey = `${this.config.keyPrefix}:${id}`;
    await this.cache.del(cacheKey);
  }
}

// Usage
const userRepo = new CacheAsideRepository<User>(
  redisClient,
  postgresClient,
  { ttlSeconds: 300, keyPrefix: 'user' }
);

const user = await userRepo.get('user-123');
```

```python
# Python implementation
from functools import wraps
from typing import TypeVar, Callable, Optional
import json

T = TypeVar('T')

def cache_aside(
    cache_client,
    key_prefix: str,
    ttl_seconds: int = 300
):
    """Decorator implementing cache-aside pattern."""

    def decorator(func: Callable[..., T]) -> Callable[..., T]:
        @wraps(func)
        async def wrapper(id: str, *args, **kwargs) -> Optional[T]:
            cache_key = f"{key_prefix}:{id}"

            # Try cache
            cached = await cache_client.get(cache_key)
            if cached:
                return json.loads(cached)

            # Cache miss - call original function
            result = await func(id, *args, **kwargs)
            if result is None:
                return None

            # Cache result
            await cache_client.setex(
                cache_key,
                ttl_seconds,
                json.dumps(result)
            )

            return result

        return wrapper
    return decorator

# Usage
@cache_aside(redis_client, 'user', ttl_seconds=300)
async def get_user(user_id: str) -> dict:
    return await database.find_user(user_id)
```

## Benefits

- Reduced database load for popular data
- Lower latency for cache hits
- Memory-efficient (only caches accessed data)
- Simple failure handling

## Limitations

- Initial request latency (cache miss + database + cache write)
- Potential stampede on popular keys after expiry
- Stale data during TTL window
- Write-through needed for consistency

## Related

- [[2026-02-016|Write-Through Cache]] - Alternative for write-heavy
- [[2026-02-017|Cache Stampede Prevention]] - Handling expiry spikes
- Cf: [[2026-02-020|Read-Through Cache]] - Cache manages loading

## Sources

- Microsoft Cloud Design Patterns
- Implemented in 3 production systems, handling 10K+ RPS
```

## Anti-Patterns

### What to Avoid

```yaml
anti_patterns:
  collection_note:
    description: "Note containing multiple unrelated concepts"
    example: "Meetings, Hiring, and Strategy Tips"
    fix: "Split into separate atomic notes"

  reference_only:
    description: "Note that only links to other notes without content"
    example: "See [[note1]], [[note2]], [[note3]]"
    fix: "Use MAP note type for pure navigation, or add original content"

  copy_paste:
    description: "External content without synthesis"
    example: "Full article copied into note"
    fix: "Summarize key insights in your own words, link to source"

  orphan_note:
    description: "Note with no links to other notes"
    example: "Standalone note with no ## Related section"
    fix: "Add minimum 3 contextual links"

  vague_title:
    description: "Title that doesn't convey the concept"
    example: "Meeting Notes" or "Thoughts"
    fix: "Use specific, descriptive title: 'Pre-Mortem Analysis Framework'"

  missing_context:
    description: "Note assumes knowledge not provided"
    example: "Use the RAPID framework" without explanation
    fix: "Add brief context or link to explanatory note"
```

## Automation Support

### Auto-Generation from Conversation

```python
# Used by extraction agent to create atomic note drafts

def create_atomic_note_draft(
    insight: dict,
    session_context: dict
) -> str:
    """Generate atomic note markdown from extracted insight."""

    note_id = generate_note_id()
    today = datetime.now().strftime('%Y-%m-%d')

    template = f"""---
id: {note_id}
type: atomic
tags: [{', '.join(insight['suggested_tags'])}]
created: {today}
confidence: {insight['confidence']}
source: conversation
---

# {insight['title']}

## Summary

{insight['summary']}

## When to Use

*[To be completed during review]*

## Details

{insight['details']}

## Implementation

*[To be completed during review]*

## Related

{format_suggested_links(insight['suggested_links'])}

## Sources

- Extracted from session: {session_context['session_id']}
- Date: {session_context['date']}

---
*Draft - needs review and expansion*
"""

    return template
```

### Validation Script

```bash
#!/bin/bash
# validate-atomic-note.sh

NOTE_PATH="$1"

if [ -z "$NOTE_PATH" ]; then
    echo "Usage: validate-atomic-note.sh <path-to-note>"
    exit 1
fi

echo "Validating: $NOTE_PATH"
ISSUES=0

# Check frontmatter
if ! grep -q "^id:" "$NOTE_PATH"; then
    echo "ERROR: Missing 'id' in frontmatter"
    ((ISSUES++))
fi

if ! grep -q "^type: atomic" "$NOTE_PATH"; then
    echo "ERROR: Missing or wrong 'type' in frontmatter"
    ((ISSUES++))
fi

if ! grep -q "^tags:" "$NOTE_PATH"; then
    echo "ERROR: Missing 'tags' in frontmatter"
    ((ISSUES++))
fi

# Check sections
if ! grep -q "## Summary" "$NOTE_PATH"; then
    echo "WARNING: Missing '## Summary' section"
    ((ISSUES++))
fi

if ! grep -q "## Related" "$NOTE_PATH"; then
    echo "WARNING: Missing '## Related' section"
    ((ISSUES++))
fi

# Check word count
WORD_COUNT=$(wc -w < "$NOTE_PATH")
if [ "$WORD_COUNT" -lt 100 ]; then
    echo "WARNING: Note too short ($WORD_COUNT words)"
    ((ISSUES++))
elif [ "$WORD_COUNT" -gt 1000 ]; then
    echo "WARNING: Note may be too long ($WORD_COUNT words)"
    ((ISSUES++))
fi

# Check links
LINK_COUNT=$(grep -o '\[\[' "$NOTE_PATH" | wc -l)
if [ "$LINK_COUNT" -lt 1 ]; then
    echo "WARNING: No links found"
    ((ISSUES++))
fi

if [ "$ISSUES" -eq 0 ]; then
    echo "PASS: Note passes all checks"
else
    echo "FAIL: $ISSUES issues found"
fi

exit $ISSUES
```

## Related Resources

- [[references/context-library-patterns|Context Library Patterns]] - Where notes live
- [[references/cross-referencing-system|Cross-Referencing System]] - Linking details
- [[assets/map-note-template|Map Note Template]] - For organizing atomic notes
- [[SKILL.md|Knowledge Management Skill]] - Parent skill documentation
