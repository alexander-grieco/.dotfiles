# Context Library Template

Ready-to-use template for initializing a new context library with proper structure and starter files.

## Quick Start

```bash
# Copy this template to initialize a new context library
cp -r context-library-template ~/kaaos-knowledge/organizations/[org-name]/context-library

# Or let KAAOS do it
/kaaos:init [org-name]
```

## Directory Structure

```
context-library/
├── 00-INDEX.md                      # Start here
├── README.md                        # How to use this library
├── playbooks/                       # Repeatable processes
│   ├── .gitkeep
│   └── PLAY-template.md
├── patterns/                        # Recognized patterns
│   ├── .gitkeep
│   └── PATT-template.md
├── decisions/                       # Strategic decisions
│   ├── .gitkeep
│   └── DEC-template.md
├── references/                      # External knowledge
│   ├── .gitkeep
│   └── REF-template.md
├── maps/                           # Navigation hubs
│   ├── .gitkeep
│   └── MAP-template.md
├── synthesis/                      # Periodic synthesis
│   ├── .gitkeep
│   └── SYNTH-template.md
└── atomic/                         # Atomic notes
    ├── .gitkeep
    └── ATOM-template.md
```

## File Templates

### 00-INDEX.md

```markdown
---
id: INDEX-00
type: index
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# [Organization Name] Context Library

**Start here** for navigating this organization's knowledge base.

## Quick Access

### Most Referenced
*Auto-populated by maintenance agent*

### Recently Updated
*Auto-populated by maintenance agent*

### By Topic

#### Strategy & Planning
- [[MAP-strategic-frameworks|Strategic Frameworks]]
- Coming soon...

#### Operations & Execution
- [[MAP-execution-patterns|Execution Patterns]]
- Coming soon...

#### People & Culture
- [[MAP-leadership-practices|Leadership Practices]]
- Coming soon...

## Getting Started

1. Read [[how-to-use-context-library|How to Use This Library]]
2. Browse maps by topic area above
3. Create your first note using templates in each folder
4. Link liberally between related notes

## Statistics

- **Total Notes**: 0
- **Last Updated**: YYYY-MM-DD
- **Maintenance Status**: ✅ Healthy

---
*Auto-updated by maintenance-agent*
```

### README.md

```markdown
# How to Use This Context Library

This context library uses Zettelkasten-inspired principles for knowledge management.

## Core Principles

1. **Atomic Notes**: One concept per note
2. **Dense Links**: Connect related ideas
3. **Progressive Disclosure**: Summaries link to details
4. **Version Control**: Git tracks all changes
5. **Automated Maintenance**: Agents keep it healthy

## Note Types

### Atomic Notes (atomic/)
Single concepts or insights. Most notes should be atomic.

**Example ID**: `ATOM-2026-01-001`
**Template**: `atomic/ATOM-template.md`
**When**: Capturing insights, frameworks, learnings

### Map Notes (maps/)
Navigation hubs connecting related atomic notes.

**Example ID**: `MAP-strategic-frameworks`
**Template**: `maps/MAP-template.md`
**When**: 3+ related notes need organization

### Playbook Notes (playbooks/)
Repeatable processes with clear steps.

**Example ID**: `PLAY-hiring-process`
**Template**: `playbooks/PLAY-template.md`
**When**: Documenting proven processes

### Decision Notes (decisions/)
Strategic decisions with rationale.

**Example ID**: `DEC-2026-001-market-entry`
**Template**: `decisions/DEC-template.md`
**When**: Recording important decisions

### Synthesis Notes (synthesis/)
Pattern extraction across multiple notes.

**Example ID**: `SYNTH-2026-Q1`
**Template**: `synthesis/SYNTH-template.md`
**When**: Quarterly/monthly reviews (often auto-generated)

### Pattern Notes (patterns/)
Recurring themes and patterns.

**Example ID**: `PATT-decision-making`
**Template**: `patterns/PATT-template.md`
**When**: Recognizing repeated situations

### Reference Notes (references/)
External knowledge and research.

**Example ID**: `REF-industry-report-2026`
**Template**: `references/REF-template.md`
**When**: Capturing external information

## Workflow

### Creating Notes

1. Check if similar note exists (search first)
2. Choose appropriate template
3. Fill in frontmatter (ID, tags, dates)
4. Write content following template
5. Link to 3-5 related notes
6. Commit with descriptive message

### Linking Notes

```markdown
## Related
- [[note-id|Description]] - Why this link matters
```

**Good**: `[[2026-01-020|Decision Reversibility]] - Use with pre-mortems to categorize risks`
**Bad**: `[[2026-01-020]]`

### Finding Notes

- Browse from `00-INDEX.md`
- Follow map notes for topics
- Use Git search: `git grep "keyword"`
- Check backlinks in existing notes

## Maintenance

### Automated (Daily)
- Link validation
- Backlink generation
- Orphan detection
- Statistics update

### Manual (Weekly)
- Review new notes for quality
- Add missing cross-references
- Update relevant map notes

### Synthesis (Monthly/Quarterly)
- Pattern extraction
- Gap identification
- Archive old content

## Best Practices

1. **Start Small**: Create notes as needed, don't over-engineer
2. **Link Liberally**: More connections = more value
3. **Add Context**: Explain why links matter
4. **Use Templates**: Consistency aids navigation
5. **Review Regularly**: Knowledge needs maintenance
6. **Version Control**: Commit frequently with clear messages
7. **Extract Insights**: Mine conversations for promotable content

## Support

Questions? Check:
- KAAOS documentation: `/Users/ben/src/kaaos/README.md`
- Knowledge management skill: Use `/kaaos-help knowledge-management`
```

### ATOM-template.md

```markdown
---
id: ATOM-YYYY-MM-XXX
type: atomic
tags: [domain, subdomain, keywords]
created: YYYY-MM-DD
updated: YYYY-MM-DD
confidence: high|medium|low
source: experience|research|synthesis
---

# [Single Concept Title]

## Summary
One-paragraph executive summary (2-3 sentences max)

## When to Use
Clear applicability criteria:
- Situation 1
- Situation 2
- Situation 3

## Details
Full explanation with context and examples

[Add relevant details, examples, case studies]

## Implementation
Concrete steps or code (if applicable)

```bash
# Example commands or code
```

## Benefits
- Benefit 1
- Benefit 2
- Benefit 3

## Limitations
- Limitation 1
- Limitation 2

## Related
- [[note-id|Description]] - Why this link matters
- [[note-id|Description]] - Why this link matters
- [[note-id|Description]] - Why this link matters

## Sources
- Source 1: [citation or experience note]
- Source 2: [citation or experience note]

---
*Last reviewed: YYYY-MM-DD*
```

### MAP-template.md

```markdown
---
id: MAP-[topic-name]
type: map
tags: [navigation, domain]
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# [Topic Name] Map

Brief overview of this topic area and why it matters.

## Section 1: [Subtopic]

Brief context for this cluster of notes.

- [[note-id|Title]] - Brief description of what this covers
- [[note-id|Title]] - Brief description of what this covers
- [[note-id|Title]] - Brief description of what this covers

## Section 2: [Subtopic]

Brief context for this cluster.

- [[note-id|Title]] - Brief description
- [[note-id|Title]] - Brief description

## Section 3: [Subtopic]

Brief context.

- [[note-id|Title]] - Brief description

## Related Maps
- [[MAP-other-topic|Other Topic]]
- [[MAP-another-topic|Another Topic]]

## Getting Started
New to this topic? Start here:
1. First, read [[note-id|Foundational Concept]]
2. Then explore [[note-id|Core Framework]]
3. See real examples in [[note-id|Case Study]]

---
*Auto-updated: YYYY-MM-DD*
*Notes in this map: X*
```

### PLAY-template.md

```markdown
---
id: PLAY-[process-name]
type: playbook
tags: [playbook, domain]
created: YYYY-MM-DD
updated: YYYY-MM-DD
times_used: 0
success_rate: N/A
---

# [Process Name] Playbook

## Purpose
Why this playbook exists and what problem it solves.

## When to Use
Clear criteria for when to apply this playbook:
- Criterion 1
- Criterion 2
- Criterion 3

## Prerequisites
What you need before starting:
- [ ] Prerequisite 1
- [ ] Prerequisite 2
- [ ] Prerequisite 3

## Steps

### Step 1: [Name]
**Duration**: [estimated time]
**Responsible**: [role]

Description of what to do in this step.

```bash
# Commands or code if applicable
```

**Outputs**:
- Output 1
- Output 2

**Next**: Proceed to Step 2

### Step 2: [Name]
**Duration**: [estimated time]
**Responsible**: [role]

Description...

**Outputs**:
- Output 1

**Next**: Proceed to Step 3

### Step 3: [Name]
**Duration**: [estimated time]
**Responsible**: [role]

Description...

**Outputs**:
- Final output 1
- Final output 2

## Success Criteria
How to know if this playbook achieved its goal:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Common Pitfalls

### Pitfall 1: [Description]
**Symptoms**: How to recognize this
**Solution**: How to avoid or fix
**Prevention**: What to do differently

### Pitfall 2: [Description]
**Symptoms**:
**Solution**:
**Prevention**:

## Adaptations
How this has been customized for different contexts:
- **Context A**: Adaptation description
- **Context B**: Adaptation description

## Metrics
Track effectiveness over time:
- **Times Used**: 0
- **Success Rate**: N/A
- **Average Duration**: N/A
- **User Satisfaction**: N/A

## Related
- [[note-id|Related Framework]]
- [[note-id|Related Playbook]]
- [[note-id|Background Context]]

## Changelog
- YYYY-MM-DD: Initial version
- YYYY-MM-DD: Updated based on feedback from Project X

---
*Last used: N/A*
*Next review: YYYY-MM-DD*
```

### DEC-template.md

```markdown
---
id: DEC-YYYY-XXX-[short-name]
type: decision
tags: [decision, domain]
created: YYYY-MM-DD
decided: YYYY-MM-DD
status: proposed|decided|implemented|reversed
stakeholders: [names or roles]
---

# Decision: [Decision Title]

## Status
**Current**: [proposed|decided|implemented|reversed]
**Decided**: YYYY-MM-DD
**Implemented**: YYYY-MM-DD (if applicable)

## Context
What situation led to this decision? What problem are we solving?

[Background information]

## Decision
What we decided to do (one clear statement).

## Rationale
Why we made this decision:
1. Reason 1
2. Reason 2
3. Reason 3

## Options Considered

### Option 1: [Name]
**Pros**:
- Pro 1
- Pro 2

**Cons**:
- Con 1
- Con 2

**Cost/Effort**: [estimate]

### Option 2: [Name] ⭐ SELECTED
**Pros**:
- Pro 1
- Pro 2

**Cons**:
- Con 1
- Con 2

**Cost/Effort**: [estimate]

### Option 3: [Name]
**Pros**:
- Pro 1

**Cons**:
- Con 1
- Con 2

**Cost/Effort**: [estimate]

## Consequences

### Positive
- Consequence 1
- Consequence 2

### Negative
- Consequence 1
- Consequence 2

### Risks
- Risk 1: [mitigation]
- Risk 2: [mitigation]

## Implementation

### Required Actions
- [ ] Action 1 (Owner: [name], Due: YYYY-MM-DD)
- [ ] Action 2 (Owner: [name], Due: YYYY-MM-DD)
- [ ] Action 3 (Owner: [name], Due: YYYY-MM-DD)

### Success Metrics
How we'll know if this decision was right:
- Metric 1: Target value
- Metric 2: Target value

## Review
**Review Date**: YYYY-MM-DD (3-6 months)
**Review Owner**: [name]

Questions to answer at review:
- Did this achieve intended outcomes?
- Were consequences as expected?
- Should we continue or reverse?

## Related
- [[note-id|Related Framework]] - Used in decision-making
- [[note-id|Related Decision]] - Related or dependent decision
- [[note-id|Background Research]]

## Stakeholders
- **Decision Maker**: [name]
- **Consulted**: [names]
- **Informed**: [names]

---
*Last updated: YYYY-MM-DD*
```

### SYNTH-template.md

```markdown
---
id: SYNTH-YYYY-[period]
type: synthesis
period: [timeframe]
source_notes: [count]
tags: [synthesis, patterns]
created: YYYY-MM-DD
generated_by: [agent-name or manual]
---

# [Period] Pattern Synthesis

Agent-extracted patterns from [X] notes created this period.

## Emerging Patterns

### Pattern 1: [Pattern Name]
**Frequency**: [X] references across [Y] projects
**Pattern**: [One-sentence description]

**Key Insights**:
- [[note-id|Title]] [specific insight]
- [[note-id|Title]] [specific insight]
- [[note-id|Title]] [specific insight]

**Recommendation**: [What to do with this pattern]

**Related Notes**: [[note-1]], [[note-2]], [[note-3]]

### Pattern 2: [Pattern Name]
**Frequency**:
**Pattern**:

**Key Insights**:
-
-

**Recommendation**:

**Related Notes**:

## Cross-Organization Learnings

### Successful Practices Reapplied
1. **[Practice Name]** (From Org A → Org B)
   - Results: [specific outcomes]
   - Documentation: [[note-id]]

2. **[Practice Name]** (From Project X → Project Y)
   - Results:
   - Documentation: [[note-id]]

### Failed Experiments
1. **[Experiment Name]** - Worked for [X]/[Y] contexts
   - Success factors: [list]
   - Failure factors: [list]
   - Document learnings: [[note-id]]

## Recommended Actions

### Create New Artifacts
- [ ] Create [[PLAY-new-playbook|New Playbook]] based on Pattern 1
- [ ] Create [[MAP-new-map|New Map]] to organize related notes
- [ ] Document [[PATT-new-pattern|New Pattern]] emerging

### Prune Knowledge
- [ ] Archive [X] obsolete notes from [period]
- [ ] Consolidate [Y] overlapping notes
- [ ] Update [Z] stale references

### Fill Gaps
- [ ] Document [missing topic 1]
- [ ] Create [missing artifact 2]
- [ ] Research [knowledge gap 3]

## Knowledge Health

### Statistics
- **New Notes**: [count]
- **Updated Notes**: [count]
- **Orphaned Notes**: [count]
- **Broken Links**: [count]
- **Most Referenced**: [[note-id]] ([count] refs)

### Quality Metrics
- **Avg Note Length**: [words]
- **Avg Links Per Note**: [count]
- **Coverage Gaps**: [count] identified

## Next Review
**Date**: [YYYY-MM-DD]
**Focus**: [what to emphasize next time]

---
*Generated by [agent-name] on YYYY-MM-DD*
```

## Initialization Script

```bash
#!/bin/bash
# initialize-context-library.sh

ORG_NAME=$1
BASE_PATH="${HOME}/kaaos-knowledge/organizations/${ORG_NAME}/context-library"

if [ -z "$ORG_NAME" ]; then
    echo "Usage: ./initialize-context-library.sh [org-name]"
    exit 1
fi

echo "Initializing context library for: ${ORG_NAME}"

# Create directory structure
mkdir -p "${BASE_PATH}"/{playbooks,patterns,decisions,references,maps,synthesis,atomic}

# Copy templates
TEMPLATE_DIR="/Users/ben/src/kaaos/skills/knowledge-management/assets"

# Create index
cat > "${BASE_PATH}/00-INDEX.md" <<EOF
---
id: INDEX-00
type: index
created: $(date +%Y-%m-%d)
updated: $(date +%Y-%m-%d)
---

# ${ORG_NAME} Context Library

**Start here** for navigating this organization's knowledge base.

[Content continues with template...]
EOF

# Copy other templates
for dir in playbooks patterns decisions references maps synthesis atomic; do
    touch "${BASE_PATH}/${dir}/.gitkeep"
    # Copy template file
done

# Initialize git if needed
cd "${BASE_PATH}/../.." || exit
git add .
git commit -m "Initialize ${ORG_NAME} context library"

echo "✅ Context library initialized at: ${BASE_PATH}"
echo "📝 Next steps:"
echo "   1. Review 00-INDEX.md"
echo "   2. Create your first atomic note"
echo "   3. Run /kaaos:status to verify setup"
```

## Usage Examples

### Creating Your First Note

```bash
# Navigate to context library
cd ~/kaaos-knowledge/organizations/personal/context-library

# Copy template
cp atomic/ATOM-template.md atomic/ATOM-2026-01-001-pre-mortem.md

# Edit the file
# ... add content ...

# Commit
git add atomic/ATOM-2026-01-001-pre-mortem.md
git commit -m "Add pre-mortem analysis framework"
```

### Creating a Map Note

```bash
# After creating 3+ related atomic notes
cp maps/MAP-template.md maps/MAP-decision-frameworks.md

# Edit to link related notes
# ... add links ...

# Commit
git add maps/MAP-decision-frameworks.md
git commit -m "Create decision frameworks map"
```
