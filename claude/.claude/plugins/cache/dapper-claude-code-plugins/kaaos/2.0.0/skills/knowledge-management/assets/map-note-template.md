# Map Note Template

Comprehensive template and guide for creating map notes - navigational hubs that organize related atomic notes into coherent topic clusters.

## Table of Contents

1. [What is a Map Note](#what-is-a-map-note)
2. [Template Structure](#template-structure)
3. [Frontmatter Reference](#frontmatter-reference)
4. [Organization Patterns](#organization-patterns)
5. [Curation Guidelines](#curation-guidelines)
6. [Maintenance](#maintenance)
7. [Examples by Type](#examples-by-type)
8. [Anti-Patterns](#anti-patterns)
9. [Automation Support](#automation-support)

## What is a Map Note

### Definition

A map note is a **navigational hub** that organizes related atomic notes around a topic, theme, or domain. It provides:

- **Structure**: Logical grouping of related concepts
- **Context**: Brief explanations of why notes relate
- **Navigation**: Clear paths through the knowledge base
- **Discovery**: Entry points for exploring topics

### When to Create a Map Note

```yaml
creation_triggers:
  note_count:
    threshold: 5
    description: "Create map when 5+ atomic notes exist on a topic"

  request_frequency:
    pattern: "Users frequently ask about this topic"
    description: "Create map for commonly searched domains"

  complexity:
    pattern: "Topic has multiple subtopics or approaches"
    description: "Create map to organize complex domains"

  onboarding:
    pattern: "New team members need topic orientation"
    description: "Create map as learning path"
```

### Map vs Other Note Types

```markdown
| Type | Purpose | Content | Updates |
|------|---------|---------|---------|
| Atomic | Single concept | Original insight | When concept changes |
| Map | Navigation | Links + context | When notes added |
| Synthesis | Pattern extraction | Analysis + insights | Periodic |
| Index | Entry point | Statistics + links | Automated |
```

## Template Structure

### Basic Template

```markdown
---
id: MAP-[topic-name]
type: map
title: "[Topic Name] Map"
tags: [navigation, primary-domain]
created: YYYY-MM-DD
updated: YYYY-MM-DD
note_count: X
---

# [Topic Name] Map

[1-2 sentence overview of this topic area and why it matters]

## Core Concepts

Brief context for foundational knowledge.

- [[note-id|Title]] - [Why this matters]
- [[note-id|Title]] - [Brief description]
- [[note-id|Title]] - [Brief description]

## [Section 2: Subtopic]

Context for this cluster of notes.

- [[note-id|Title]] - [Description]
- [[note-id|Title]] - [Description]

## [Section 3: Subtopic]

Context for this cluster.

- [[note-id|Title]] - [Description]
- [[note-id|Title]] - [Description]

## Related Maps

- [[MAP-related-topic|Related Topic]]
- [[MAP-another-topic|Another Topic]]

## Getting Started

New to this topic? Start here:
1. First, read [[note-id|Foundational Concept]]
2. Then explore [[note-id|Key Framework]]
3. See real examples in [[note-id|Application Example]]

---
*Notes in this map: X*
*Last updated: YYYY-MM-DD*
*Auto-maintained by maintenance-agent*
```

### Extended Template

```markdown
---
id: MAP-[topic-name]
type: map
title: "[Topic Name] Map"
tags: [navigation, primary-domain, secondary-domain]
created: YYYY-MM-DD
updated: YYYY-MM-DD
note_count: X
coverage: complete|partial|growing
maintainer: [agent-name or manual]
---

# [Topic Name] Map

[Overview paragraph explaining this topic area, its importance, and how notes are organized]

## Quick Links

**Most Referenced**
- [[note-1|Title]] (X refs) - [Brief description]
- [[note-2|Title]] (X refs) - [Brief description]

**Recently Added**
- [[note-3|Title]] (YYYY-MM-DD)
- [[note-4|Title]] (YYYY-MM-DD)

---

## Foundations

Understanding these concepts first enables everything else in this domain.

### Prerequisites
- [[prereq-1|Prerequisite Concept]] - Required background
- [[prereq-2|Another Prerequisite]] - Helpful context

### Core Principles
- [[principle-1|Principle One]] - [Why it matters]
- [[principle-2|Principle Two]] - [Application]
- [[principle-3|Principle Three]] - [Connection]

---

## [Major Section 1]

[Context paragraph explaining this section and how notes relate]

### [Subsection A]
- [[note-id|Title]] - [Description and relevance]
- [[note-id|Title]] - [Description and relevance]

### [Subsection B]
- [[note-id|Title]] - [Description]
- [[note-id|Title]] - [Description]

---

## [Major Section 2]

[Context paragraph]

### [Subsection A]
- [[note-id|Title]] - [Description]
- [[note-id|Title]] - [Description]

### [Subsection B]
- [[note-id|Title]] - [Description]

---

## Playbooks

Actionable processes for this domain.

- [[PLAY-process-1|Process One]] - [When to use]
- [[PLAY-process-2|Process Two]] - [When to use]

---

## Decisions

Key decisions in this domain.

- [[DEC-decision-1|Decision One]] - [Outcome]
- [[DEC-decision-2|Decision Two]] - [Outcome]

---

## Related Maps

| Map | Relationship | When to Navigate |
|-----|--------------|------------------|
| [[MAP-related-1]] | [Relationship] | [Use case] |
| [[MAP-related-2]] | [Relationship] | [Use case] |

---

## Learning Path

For those new to this domain:

### Level 1: Foundations (30 min)
1. [[note-id|Start Here]] - [What you'll learn]
2. [[note-id|Key Concept]] - [What you'll learn]
3. [[note-id|First Application]] - [What you'll practice]

### Level 2: Intermediate (1-2 hours)
4. [[note-id|Advanced Concept]] - [What you'll learn]
5. [[note-id|Common Patterns]] - [What you'll recognize]
6. [[note-id|Pitfalls to Avoid]] - [What you'll prevent]

### Level 3: Mastery (ongoing)
7. [[note-id|Expert Techniques]] - [What you'll master]
8. [[note-id|Edge Cases]] - [What you'll handle]

---

## Coverage Status

| Subtopic | Notes | Status | Next Action |
|----------|-------|--------|-------------|
| Foundations | X | Complete | - |
| Section 1 | X | Partial | Add note on [topic] |
| Section 2 | X | Growing | Review for gaps |

---

*Notes in this map: X*
*Last reviewed: YYYY-MM-DD*
*Coverage: X%*
*Auto-maintained by maintenance-agent*
```

## Frontmatter Reference

### Required Fields

```yaml
id:
  format: "MAP-[topic-name]"
  example: "MAP-decision-making"
  description: "Unique identifier using MAP prefix"

type:
  value: "map"
  description: "Note type classification"

tags:
  required: ["navigation"]
  additional: "[domain tags]"
  description: "Always include 'navigation' tag"

created:
  format: "YYYY-MM-DD"
  description: "Creation date"
```

### Optional Fields

```yaml
updated:
  format: "YYYY-MM-DD"
  auto_updated: true
  description: "Last modification date"

note_count:
  type: integer
  auto_updated: true
  description: "Number of notes linked from this map"

coverage:
  values: ["complete", "partial", "growing"]
  description: "How well this map covers the topic"

maintainer:
  values: ["maintenance-agent", "manual", "user-name"]
  description: "Who/what maintains this map"

title:
  format: "string"
  description: "Full display title"

related_maps:
  format: "[MAP-ids]"
  description: "Explicit map relationships"
```

## Organization Patterns

### Pattern 1: Hierarchical (Subtopics)

Best for: Domains with clear category structure

```markdown
# Leadership Map

## People Management
- [[note-1|One-on-Ones]] - Weekly sync framework
- [[note-2|Feedback Giving]] - Constructive feedback model

## Team Building
- [[note-3|Hiring Process]] - End-to-end hiring
- [[note-4|Onboarding]] - New hire integration

## Strategy
- [[note-5|Vision Setting]] - Long-term direction
- [[note-6|Goal Alignment]] - OKR framework
```

### Pattern 2: Chronological (Lifecycle)

Best for: Processes with sequential stages

```markdown
# Product Launch Map

## Phase 1: Planning
- [[note-1|Market Research]] - Understanding the opportunity
- [[note-2|Requirements]] - Defining what to build

## Phase 2: Development
- [[note-3|MVP Definition]] - Minimum viable scope
- [[note-4|Build Process]] - Development workflow

## Phase 3: Launch
- [[note-5|Go-to-Market]] - Launch strategy
- [[note-6|Metrics]] - Success measurement

## Phase 4: Iteration
- [[note-7|Feedback Loops]] - Learning from users
- [[note-8|Iteration Cycles]] - Continuous improvement
```

### Pattern 3: Conceptual (Relationships)

Best for: Ideas with complex interconnections

```markdown
# Decision-Making Map

## Frameworks
*Different lenses for analyzing decisions*
- [[note-1|Pre-Mortem]] - Anticipate failures
- [[note-2|OODA Loop]] - Rapid iteration
- [[note-3|Six Thinking Hats]] - Multiple perspectives

## Categorization
*Understanding decision types*
- [[note-4|One-Way Doors]] - Irreversible decisions
- [[note-5|Two-Way Doors]] - Reversible decisions

## Execution
*Making decisions happen*
- [[note-6|Decision Logs]] - Documentation
- [[note-7|Communication]] - Announcing decisions

## Meta
*Improving decision-making itself*
- [[note-8|Bias Awareness]] - Cognitive pitfalls
- [[note-9|Retrospectives]] - Learning from outcomes
```

### Pattern 4: Role-Based

Best for: Audience-specific knowledge

```markdown
# Engineering Leadership Map

## For New Tech Leads
- [[note-1|Transition Guide]] - IC to lead
- [[note-2|First 90 Days]] - Getting started

## For Senior Staff
- [[note-3|Cross-Team Influence]] - Leading without authority
- [[note-4|Technical Strategy]] - Setting direction

## For Engineering Managers
- [[note-5|Team Health]] - Culture and morale
- [[note-6|Delivery Balance]] - Speed vs quality
```

### Pattern 5: Question-Based

Best for: Reference and troubleshooting

```markdown
# Remote Work Map

## How do I...

### Communicate effectively?
- [[note-1|Async Communication]] - Written-first approach
- [[note-2|Meeting Efficiency]] - When sync is needed

### Build team culture?
- [[note-3|Virtual Events]] - Remote team building
- [[note-4|Recognition]] - Celebrating remotely

### Stay productive?
- [[note-5|Focus Time]] - Deep work setup
- [[note-6|Work-Life Boundaries]] - Sustainable remote work
```

## Curation Guidelines

### Link Quality Standards

```yaml
link_requirements:
  minimum_per_section: 2
  maximum_per_section: 7
  always_include:
    - contextual_description
    - relevance_explanation

good_example: |
  - [[2026-01-042|One-Way Doors]] - Use to categorize decisions by reversibility

bad_example: |
  - [[2026-01-042]]
```

### Section Sizing

```markdown
| Section Notes | Action |
|---------------|--------|
| 1-2 | Merge with related section or expand topic |
| 3-5 | Ideal size |
| 6-8 | Consider subsections |
| 9+ | Split into sub-map |
```

### Maintaining Balance

```python
def assess_map_balance(map_content: str) -> dict:
    """Assess if map sections are balanced."""

    sections = extract_sections(map_content)
    section_sizes = {
        name: count_links(content)
        for name, content in sections.items()
    }

    avg_size = sum(section_sizes.values()) / len(section_sizes)
    variance = calculate_variance(section_sizes.values())

    assessment = {
        'balanced': variance < (avg_size * 0.5),
        'largest_section': max(section_sizes, key=section_sizes.get),
        'smallest_section': min(section_sizes, key=section_sizes.get),
        'recommendations': []
    }

    # Check for oversized sections
    for section, size in section_sizes.items():
        if size > avg_size * 2:
            assessment['recommendations'].append(
                f"Consider splitting '{section}' (has {size} notes)"
            )
        elif size < 2:
            assessment['recommendations'].append(
                f"Consider expanding or merging '{section}' (has {size} notes)"
            )

    return assessment
```

## Maintenance

### Auto-Update Configuration

```yaml
# Map maintenance settings

auto_update:
  enabled: true
  triggers:
    - new_note_matching_tags
    - weekly_scheduled

  actions:
    add_new_notes:
      placement: "end_of_matching_section"
      require_human_review: false

    update_counts:
      frequency: daily

    check_broken_links:
      frequency: daily
      auto_remove: false

  notifications:
    on_new_notes: true
    on_structural_suggestions: true
```

### Manual Review Checklist

```markdown
## Monthly Map Review

### Structure
- [ ] Sections still logically grouped
- [ ] No section has > 8 notes
- [ ] No orphan notes that should be in map

### Content
- [ ] All link descriptions still accurate
- [ ] Context paragraphs still relevant
- [ ] Learning path still appropriate

### Coverage
- [ ] No significant gaps in topic
- [ ] Related maps list current
- [ ] Note count accurate

### Quality
- [ ] All links resolve correctly
- [ ] Formatting consistent
- [ ] Dates updated
```

### Splitting Overgrown Maps

When a map exceeds ~40 notes, consider splitting:

```python
def suggest_map_split(map_content: str) -> list:
    """Suggest how to split an overgrown map."""

    sections = extract_sections(map_content)
    suggestions = []

    for section_name, section_content in sections.items():
        note_count = count_links(section_content)

        if note_count >= 10:
            suggestions.append({
                'action': 'create_sub_map',
                'section': section_name,
                'new_map_id': f"MAP-{slugify(section_name)}",
                'notes_to_move': note_count,
                'replacement_text': f"""
### {section_name}
See [[MAP-{slugify(section_name)}|{section_name} Map]] for detailed navigation.

**Key notes:**
- [[top-note-1]] - Most referenced
- [[top-note-2]] - Entry point
"""
            })

    return suggestions
```

## Examples by Type

### Domain Map Example

```markdown
---
id: MAP-strategic-planning
type: map
tags: [navigation, strategy, planning]
created: 2026-01-15
updated: 2026-01-20
note_count: 23
---

# Strategic Planning Map

Frameworks, processes, and tools for organizational strategic planning from quarterly objectives to multi-year vision.

## Frameworks

Core mental models for strategic thinking.

- [[2026-01-010|Jobs to Be Done]] - Customer-centric strategy lens
- [[2026-01-015|Porter's Five Forces]] - Competitive analysis framework
- [[2026-01-018|Blue Ocean Strategy]] - Creating uncontested market space
- [[2026-01-020|Strategy Canvas]] - Visual competitive positioning

## Planning Cycles

Rhythms and processes for strategic planning.

### Annual Planning
- [[2026-01-030|Annual Planning Process]] - Full year strategic cycle
- [[2026-01-032|Board Strategy Sessions]] - Governance alignment
- [[2026-01-035|Budget Integration]] - Finance alignment

### Quarterly Planning
- [[2026-01-040|OKR Framework]] - Objectives and Key Results
- [[2026-01-042|Quarterly Business Review]] - Progress assessment
- [[PLAY-quarterly-planning]] - Step-by-step playbook

## Execution Bridge

Connecting strategy to day-to-day work.

- [[2026-01-050|Strategy Deployment]] - Cascading objectives
- [[2026-01-052|Strategic Initiatives]] - Project prioritization
- [[2026-01-055|Leading Indicators]] - Early progress signals

## Common Pitfalls

Mistakes to avoid in strategic planning.

- [[2026-01-060|Strategy-Execution Gap]] - Why strategies fail
- [[2026-01-062|Planning Paralysis]] - Over-analysis patterns
- [[2026-01-065|Goal Proliferation]] - Too many priorities

## Related Maps

- [[MAP-decision-making]] - Decision frameworks for strategic choices
- [[MAP-leadership]] - Leadership aspects of strategy
- [[MAP-execution]] - Implementation of strategic plans

## Learning Path

1. Start with [[2026-01-010|Jobs to Be Done]] - Foundation framework
2. Explore [[2026-01-040|OKR Framework]] - Practical application
3. Review [[PLAY-quarterly-planning]] - Hands-on process

---
*Notes in this map: 23*
*Last updated: 2026-01-20*
```

### Process Map Example

```markdown
---
id: MAP-hiring-process
type: map
tags: [navigation, people, hiring, process]
created: 2026-02-01
updated: 2026-02-15
note_count: 18
---

# Hiring Process Map

End-to-end knowledge for building great teams through effective hiring.

## Phase 1: Planning

Before opening any role.

- [[2026-02-010|Headcount Planning]] - When and why to hire
- [[2026-02-012|Role Definition]] - Creating clear job specs
- [[2026-02-015|Hiring Committee]] - Who should be involved

## Phase 2: Sourcing

Finding qualified candidates.

- [[2026-02-020|Job Posting Optimization]] - Writing effective listings
- [[2026-02-022|Sourcing Channels]] - Where to find candidates
- [[2026-02-025|Employee Referrals]] - Leveraging network

## Phase 3: Screening

Initial candidate evaluation.

- [[2026-02-030|Resume Review]] - What to look for
- [[2026-02-032|Phone Screen]] - Initial conversation framework
- [[2026-02-035|Work Sample Design]] - Async evaluation tasks

## Phase 4: Interview

Deep candidate assessment.

- [[2026-02-040|Interview Structure]] - Full-day format
- [[2026-02-042|Behavioral Questions]] - Past performance signals
- [[2026-02-045|Technical Assessment]] - Skills evaluation
- [[2026-02-048|Culture Add Interview]] - Values alignment

## Phase 5: Decision

Making and communicating decisions.

- [[2026-02-050|Debrief Process]] - Structured decision-making
- [[2026-02-052|Reference Checks]] - Final validation
- [[2026-02-055|Offer Construction]] - Competitive offers

## Phase 6: Close & Onboard

Securing and integrating new hires.

- [[2026-02-060|Offer Negotiation]] - Closing candidates
- [[2026-02-062|Onboarding Handoff]] - Transition to team

## Playbooks

- [[PLAY-hiring-engineering]] - Engineering-specific process
- [[PLAY-hiring-executive]] - Senior leader hiring
- [[PLAY-hiring-remote]] - Remote hiring considerations

## Related Maps

- [[MAP-onboarding]] - Post-hire integration
- [[MAP-team-building]] - Team composition
- [[MAP-performance]] - Ongoing evaluation

---
*Notes in this map: 18*
*Last updated: 2026-02-15*
```

## Anti-Patterns

### What to Avoid

```yaml
anti_patterns:
  link_dump:
    description: "Flat list of links without organization"
    example: |
      - [[note1]]
      - [[note2]]
      - [[note3]]
    fix: "Group into logical sections with context"

  description_less:
    description: "Links without explanatory context"
    example: "- [[2026-01-042]]"
    fix: "Add description: [[2026-01-042|Title]] - Why it matters"

  over_nesting:
    description: "Too many hierarchical levels"
    example: "### Sub-sub-sub-section"
    fix: "Max 2 levels deep; create sub-map for more"

  stale_map:
    description: "Map not updated when notes added"
    example: "Map from 6 months ago, 10 new relevant notes"
    fix: "Enable auto-update or schedule monthly review"

  scope_creep:
    description: "Map covering too broad a topic"
    example: "Business Map" covering everything
    fix: "Create focused domain maps, link from index"

  orphan_map:
    description: "Map not linked from other maps or index"
    example: "MAP-xyz exists but not discoverable"
    fix: "Add to index and related maps sections"
```

## Automation Support

### Auto-Generation from Clusters

```python
# maintenance-agent/map-generator.py

def generate_map_from_cluster(
    cluster_notes: list,
    suggested_title: str,
    domain: str
) -> str:
    """Generate map note draft from note cluster."""

    map_id = f"MAP-{slugify(suggested_title)}"
    today = datetime.now().strftime('%Y-%m-%d')

    # Analyze notes to determine sections
    sections = cluster_into_sections(cluster_notes)

    # Build map content
    sections_md = ""
    for section_name, notes in sections.items():
        sections_md += f"\n## {section_name}\n\n"
        for note in notes:
            sections_md += f"- [[{note['id']}|{note['title']}]] - {note['summary'][:50]}...\n"

    template = f"""---
id: {map_id}
type: map
tags: [navigation, {domain}]
created: {today}
updated: {today}
note_count: {len(cluster_notes)}
coverage: partial
---

# {suggested_title} Map

*Auto-generated map organizing {len(cluster_notes)} related notes.*

{sections_md}

## Related Maps

*[To be determined during review]*

## Getting Started

1. First, read [[{cluster_notes[0]['id']}|{cluster_notes[0]['title']}]]

---
*Notes in this map: {len(cluster_notes)}*
*Generated by maintenance-agent on {today}*
*Status: DRAFT - needs human review*
"""

    return template


def cluster_into_sections(notes: list, max_section_size: int = 6) -> dict:
    """Organize notes into logical sections."""

    # Use tag overlap to group notes
    sections = {}

    for note in notes:
        # Find best section based on tags
        primary_tag = note['tags'][0] if note['tags'] else 'General'

        if primary_tag not in sections:
            sections[primary_tag] = []

        sections[primary_tag].append(note)

    # Split oversized sections
    final_sections = {}
    for name, section_notes in sections.items():
        if len(section_notes) > max_section_size:
            # Split into subsections
            for i, chunk in enumerate(chunked(section_notes, max_section_size)):
                final_sections[f"{name} ({i+1})"] = chunk
        else:
            final_sections[name] = section_notes

    return final_sections
```

### Map Health Checker

```typescript
// map-health-check.ts

interface MapHealthReport {
  mapId: string;
  issues: MapIssue[];
  score: number;
  recommendations: string[];
}

interface MapIssue {
  type: 'broken_link' | 'missing_description' | 'oversized_section' |
        'undersized_section' | 'stale' | 'orphan_map';
  severity: 'error' | 'warning' | 'info';
  details: string;
}

function checkMapHealth(mapPath: string): MapHealthReport {
  const content = fs.readFileSync(mapPath, 'utf-8');
  const issues: MapIssue[] = [];

  // Check for broken links
  const links = extractLinks(content);
  for (const link of links) {
    if (!linkExists(link)) {
      issues.push({
        type: 'broken_link',
        severity: 'error',
        details: `Link [[${link}]] not found`
      });
    }
  }

  // Check for missing descriptions
  const linksWithoutDesc = links.filter(l => !hasDescription(content, l));
  if (linksWithoutDesc.length > 0) {
    issues.push({
      type: 'missing_description',
      severity: 'warning',
      details: `${linksWithoutDesc.length} links missing descriptions`
    });
  }

  // Check section sizes
  const sections = extractSections(content);
  for (const [name, sectionContent] of Object.entries(sections)) {
    const linkCount = countLinks(sectionContent);
    if (linkCount > 8) {
      issues.push({
        type: 'oversized_section',
        severity: 'warning',
        details: `Section "${name}" has ${linkCount} links (max 8)`
      });
    } else if (linkCount < 2 && linkCount > 0) {
      issues.push({
        type: 'undersized_section',
        severity: 'info',
        details: `Section "${name}" has only ${linkCount} link(s)`
      });
    }
  }

  // Calculate health score
  const score = calculateScore(issues);

  // Generate recommendations
  const recommendations = generateRecommendations(issues);

  return {
    mapId: extractMapId(content),
    issues,
    score,
    recommendations
  };
}

function calculateScore(issues: MapIssue[]): number {
  let score = 100;

  for (const issue of issues) {
    switch (issue.severity) {
      case 'error':
        score -= 15;
        break;
      case 'warning':
        score -= 5;
        break;
      case 'info':
        score -= 1;
        break;
    }
  }

  return Math.max(0, score);
}
```

### Map Update Automation

```bash
#!/bin/bash
# update-map-stats.sh
# Update note counts and dates in map files

KB_PATH="${1:-$HOME/kaaos-knowledge}"
TODAY=$(date +%Y-%m-%d)

find "$KB_PATH" -name "MAP-*.md" | while read -r map_file; do
    echo "Updating: $map_file"

    # Count links in file
    LINK_COUNT=$(grep -o '\[\[' "$map_file" | wc -l | tr -d ' ')

    # Update note_count in frontmatter
    if grep -q "^note_count:" "$map_file"; then
        sed -i '' "s/^note_count:.*/note_count: $LINK_COUNT/" "$map_file"
    fi

    # Update updated date
    if grep -q "^updated:" "$map_file"; then
        sed -i '' "s/^updated:.*/updated: $TODAY/" "$map_file"
    fi

    # Update footer stats
    if grep -q "^\*Notes in this map:" "$map_file"; then
        sed -i '' "s/^\*Notes in this map:.*/*Notes in this map: $LINK_COUNT*/" "$map_file"
    fi

    if grep -q "^\*Last updated:" "$map_file"; then
        sed -i '' "s/^\*Last updated:.*/*Last updated: $TODAY*/" "$map_file"
    fi
done

echo "Map updates complete"
```

## Related Resources

- [[references/context-library-patterns|Context Library Patterns]] - Overall structure
- [[references/cross-referencing-system|Cross-Referencing System]] - Link strategies
- [[assets/atomic-note-template|Atomic Note Template]] - Notes that maps organize
- [[SKILL.md|Knowledge Management Skill]] - Parent skill documentation
