---
description: Initialize a new KAAOS knowledge repository with multi-organization structure, git version control, and automated agents
argument-hint: "[organization-name] [optional-repo-path]"
---

# Initialize KAAOS Repository

Creates a new KAAOS (Knowledge and Analysis Automated Orchestrated System) repository with proper structure, git hooks, configuration, and state management.

## Usage
```bash
# Initialize with default location (~/kaaos-knowledge/)
/kaaos:init personal

# Initialize with custom location
/kaaos:init personal ~/my-knowledge-base

# Initialize for a company
/kaaos:init company-x ~/work/company-x-knowledge
```

## Implementation

You are the KAAOS Orchestrator handling repository initialization.

### Phase 0: Check Dependencies

Before starting initialization, verify required tools are installed.

Use Bash tool to check for jq:
```bash
if ! command -v jq &>/dev/null; then
    echo "MISSING_JQ"
else
    echo "JQ_OK"
fi
```

If MISSING_JQ, display error with installation instructions:
```
Error: Required dependency missing

KAAOS requires 'jq' for JSON manipulation.

Install with:
  brew install jq

Then re-run: /kaaos:init [org-name]
```

Optionally offer to install automatically:
```
Would you like me to install jq now? [Y/n]
```

If user confirms, use Bash tool:
```bash
brew install jq
```

If installation succeeds, continue. If fails or user declines, exit with error.

### Phase 1: Parse and Validate Arguments

Extract arguments from $ARGUMENTS:
```bash
# Parse: organization-name [optional-path]
# Example: "personal" or "personal ~/my-knowledge"
```

Parse the organization name (required, first argument).
Parse the repository path (optional, second argument, defaults to ~/kaaos-knowledge).

Validate:
- Organization name must be alphanumeric with hyphens/underscores only
- Repository path must not exist or must be empty
- Expand ~ to full home directory path

If validation fails, display error and usage instructions.

### Phase 2: Create Directory Structure

Use Bash tool to create the complete directory structure:

```bash
mkdir -p "$REPO_PATH"/{organizations,'.kaaos'/{state,locks,logs,cache,scripts,insights/pending},'.digests'/{daily,weekly,monthly,quarterly},'.global-context'}
mkdir -p "$REPO_PATH/organizations/$ORG_NAME"/{context-library/_organizational,projects}
```

Create all necessary directories in a single operation, including `.kaaos/scripts/` for knowledge graph infrastructure and `.global-context/` for cross-organizational methodology documentation.

### Phase 3: Initialize Git Repository

Use Bash tool to initialize Git:

```bash
cd "$REPO_PATH" && git init && git config user.name "KAAOS Agent" && git config user.email "kaaos@localhost"
```

Create .gitignore using Write tool with content:
```
# Temporary files
.kaaos/cache/
.kaaos/locks/*.lock
*.tmp
*.swp

# Logs (keep directory, ignore files)
.kaaos/logs/*.log

# Sensitive data
**/secrets/
**/*.key
**/*.pem

# OS files
.DS_Store
Thumbs.db
```

### Phase 3.5: Install Knowledge Graph Infrastructure

Install the graph-metrics.sh script for knowledge graph analysis.

Use Read tool to load the template script:
```bash
cat "${CLAUDE_PLUGIN_ROOT}/templates/scripts/graph-metrics.sh"
```

Use Write tool to install script at `.kaaos/scripts/graph-metrics.sh` in the repository.

Use Bash tool to make script executable:
```bash
chmod +x "$REPO_PATH/.kaaos/scripts/graph-metrics.sh"
```

Display confirmation:
```
✓ Installed knowledge graph metrics infrastructure
  Location: .kaaos/scripts/graph-metrics.sh
  Usage: Agents will use this to analyze knowledge graph health
```

### Phase 3.6: Create Global Context Methodology

Create the global methodology document that defines knowledge management principles across all organizations.

Use Write tool to create `.global-context/methodology.md`:

```markdown
# KAAOS Knowledge Methodology

## Document Purpose

This methodology guide defines the principles, patterns, and practices for knowledge management within this KAAOS repository. It serves as the authoritative reference for how knowledge should be captured, organized, connected, and maintained.

---

## Core Principles

### 1. Atomic Knowledge Units

**Principle**: Each knowledge item should represent a single, complete idea that can stand alone.

**Guidelines**:
- One concept per note
- Self-contained with sufficient context
- Can be understood without reading other notes
- Enables flexible recombination

**Example**:
```
Good:  "OAuth2 refresh tokens should be rotated on each use to prevent replay attacks"
Bad:   "Authentication best practices" (too broad, multiple concepts)
```

### 2. Progressive Disclosure

**Principle**: Information should be layered from essential to detailed.

**Structure**:
1. **Title**: Captures the essence in 5-10 words
2. **Summary**: One-paragraph overview
3. **Core Content**: Main explanation with examples
4. **Deep Dive**: Technical details, edge cases, references
5. **Metadata**: Tags, links, dates

### 3. Explicit Connections

**Principle**: Relationships between knowledge items must be documented and typed.

**Connection Types**:
- `relates-to`: General topical relationship
- `implements`: Concrete implementation of concept
- `contradicts`: Opposing viewpoint or approach
- `extends`: Builds upon or extends another concept
- `replaces`: Supersedes previous knowledge
- `depends-on`: Prerequisite relationship

**Linking Format**:
```markdown
## Related
- [[note-id]] - implements - Concrete API implementation
- [[other-note]] - extends - Additional security considerations
```

### 4. Temporal Awareness

**Principle**: Knowledge has a lifecycle; track when information becomes stale.

**Required Metadata**:
- `created`: When knowledge was captured
- `updated`: Last modification date
- `valid-until`: Expected relevance period (optional)
- `review-date`: When to verify accuracy

**Staleness Indicators**:
- Technology version changes
- Policy/process updates
- Team/organization changes
- External dependency updates

---

## Note Types

### Atomic Notes
Single-concept knowledge items forming the foundation of the knowledge graph.

**Template**:
```markdown
---
type: atomic
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
confidence: high|medium|low
---

# [Concise Title]

## Summary
One paragraph capturing the essential insight.

## Details
Expanded explanation with context and examples.

## Evidence
Sources, observations, or reasoning supporting this knowledge.

## Related
- [[related-note]] - relationship-type - Brief explanation
```

### Map Notes
High-level overviews connecting multiple atomic notes into coherent topics.

**Purpose**: Navigate complex topics, understand concept relationships, provide entry points.

**Template**:
```markdown
---
type: map
created: YYYY-MM-DD
updated: YYYY-MM-DD
scope: topic|project|domain
---

# [Topic] Overview

## Introduction
What this map covers and why it matters.

## Key Concepts
- [[concept-1]] - Foundation of X
- [[concept-2]] - Core implementation pattern
- [[concept-3]] - Advanced technique

## Concept Relationships
[Describe how the concepts connect]

## Learning Path
1. Start with [[concept-1]]
2. Then understand [[concept-2]]
3. Advanced: [[concept-3]]

## Open Questions
- Unresolved issues or areas needing research
```

### Decision Records
Capture significant decisions with context, rationale, and consequences.

**Template**:
```markdown
---
type: decision
created: YYYY-MM-DD
status: proposed|accepted|deprecated|superseded
deciders: [person1, person2]
---

# [Decision Title]

## Status
[Current status and date]

## Context
What situation or problem prompted this decision?

## Decision
What was decided?

## Rationale
Why was this decision made? What alternatives were considered?

## Consequences
- Positive: What benefits does this bring?
- Negative: What tradeoffs or risks are accepted?
- Neutral: What changes result from this?

## Related Decisions
- [[previous-decision]] - superseded by this
- [[related-decision]] - must be consistent with
```

### Synthesis Notes
Insights derived from analyzing multiple knowledge items.

**Template**:
```markdown
---
type: synthesis
created: YYYY-MM-DD
sources: [note-1, note-2, note-3]
confidence: high|medium|low
---

# [Insight Title]

## Synthesis
The key insight derived from analyzing multiple sources.

## Sources Analyzed
- [[source-1]] - What it contributed
- [[source-2]] - What it contributed
- [[source-3]] - What it contributed

## Methodology
How this synthesis was derived.

## Implications
What this insight means for future work or decisions.

## Validation Needed
What would strengthen or invalidate this synthesis?
```

---

## Organization Patterns

### Project Structure
```
organizations/
└── [org-name]/
    ├── _meta.yaml              # Organization metadata
    ├── README.md               # Organization overview
    ├── context-library/        # Cross-project knowledge
    │   ├── index.md           # Entry point
    │   ├── _organizational/   # Org-wide patterns
    │   ├── domain/            # Domain knowledge
    │   └── technical/         # Technical patterns
    └── projects/
        └── [project-name]/
            ├── _meta.yaml     # Project metadata
            ├── context-library/
            │   ├── architecture/
            │   ├── decisions/
            │   └── patterns/
            └── conversations/
                └── YYYY/
                    └── MM/
                        └── [session-id]/
```

### Naming Conventions

**Files**:
- Lowercase with hyphens: `api-authentication-patterns.md`
- Descriptive but concise: max 50 characters
- Include type prefix for special files: `decision-`, `map-`, `synthesis-`

**Tags**:
- Lowercase, hyphenated: `api-design`, `security-review`
- Hierarchical when needed: `backend/api`, `frontend/components`
- Limited vocabulary: maintain tag index to prevent proliferation

### Context Library Principles

1. **Organizational level**: Cross-cutting concerns, company patterns, shared decisions
2. **Project level**: Project-specific architecture, decisions, domain knowledge
3. **No duplication**: Reference, don't copy; use links between levels
4. **Progressive detail**: Org-level is principles, project-level is implementation

---

## Maintenance Practices

### Daily Practices
- Review pending insights from git hooks
- Quick-capture important observations
- Update notes touched during work

### Weekly Practices
- Process accumulated quick captures
- Review and refine recent atomic notes
- Update map notes if concepts shifted
- Check for orphaned notes

### Monthly Practices
- Review staleness indicators
- Consolidate related atomic notes
- Update organizational patterns
- Archive deprecated content

### Quarterly Practices
- Comprehensive structure review
- Knowledge graph health analysis
- Strategic alignment check
- Methodology refinement

---

## Quality Standards

### Note Quality Checklist
- [ ] Single clear concept (atomic notes)
- [ ] Self-contained with sufficient context
- [ ] Proper metadata complete
- [ ] At least one connection to existing knowledge
- [ ] Evidence or source cited
- [ ] Reviewed for accuracy
- [ ] Follows naming conventions
- [ ] Appropriate tags applied

### Anti-Patterns to Avoid

1. **Knowledge Hoarding**: Capturing everything without curation
2. **Orphan Notes**: Notes without connections to the graph
3. **Stale Knowledge**: Information kept past its validity
4. **Duplication**: Same concept captured in multiple places
5. **Over-Abstraction**: Maps without atomic foundations
6. **Under-Linking**: Missing obvious connections
7. **Tag Explosion**: Uncontrolled tag vocabulary

---

## Agent Integration

### Orchestrator Responsibilities
- Overall knowledge structure integrity
- Cross-organization pattern detection
- Strategic alignment verification

### Maintenance Agent Responsibilities
- Staleness detection and flagging
- Orphan note identification
- Duplicate detection
- Link validation

### Research Agent Responsibilities
- Deep investigation on topics
- Evidence gathering
- Synthesis generation

### Copilot Responsibilities
- Real-time connection suggestions
- Quick capture assistance
- Context loading recommendations

---

## Revision History

| Date | Version | Changes |
|------|---------|---------|
| [INIT_DATE] | 1.0 | Initial methodology document |

---

*This methodology is a living document. Update it as your knowledge management practices evolve.*
```

Replace `[INIT_DATE]` with the current date.

Display confirmation:
```
✓ Created global context methodology
  Location: .global-context/methodology.md
  Purpose: Defines knowledge management principles across all organizations
```

### Phase 4: Create Configuration File

Use Write tool to create .kaaos/config.yaml:

```yaml
version: '1.0'
enabled: true
repository_path: /path/to/repo
created_at: '2026-01-12T10:00:00Z'
default_organization: organization-name

cost_controls:
  daily_limit_usd: 5.00
  weekly_limit_usd: 25.00
  monthly_limit_usd: 100.00
  quarterly_limit_usd: 500.00
  alert_threshold_percent: 80
  hard_stop_on_limit: true

models:
  orchestrator: opus
  research: sonnet
  synthesis: opus
  maintenance: sonnet
  copilot: sonnet
  gap_detector: sonnet
  strategic_reviewer: opus

rhythms:
  daily:
    enabled: true
    hour: 7
    minute: 0
  weekly:
    enabled: true
    weekday: 1
    hour: 6
    minute: 0
  monthly:
    enabled: true
    day: 1
    hour: 5
    minute: 0
  quarterly:
    enabled: true
    months: [1, 4, 7, 10]
    day: 1
    hour: 3
    minute: 0

features:
  git_hooks: true
  copilot_suggestions: true      # Real-time co-pilot via PostToolUse hook
  auto_organization: true        # Auto-organize files via SessionEnd hook
  auto_maintenance: true
  parallel_quarterly: true

integrations:
  claude_mem:
    enabled: false              # Auto-detected on first use
    use_for_suggestions: true   # Use for co-pilot suggestions
    use_for_cross_linking: true # Use for auto-cross-linking
    use_for_synthesis: true     # Use in weekly/monthly synthesis
    similarity_threshold: 0.75  # Minimum similarity for cross-refs

git:
  auto_commit: true
  commit_prefix: '[KAAOS-AGENT]'
  require_messages: true
```

Replace placeholder values with actual repository path, organization name, and current timestamp.

### Phase 5: Create State Files

Use Write tool to create .kaaos/state/agent-executions.json:
```json
{
  "executions": [],
  "next_id": 1
}
```

Use Write tool to create .kaaos/state/context-items.json:
```json
{
  "items": []
}
```

Use Write tool to create .kaaos/state/schedules.json:
```json
{
  "schedules": {
    "daily": {
      "type": "daily",
      "enabled": true,
      "last_run": null,
      "next_run": null
    },
    "weekly": {
      "type": "weekly",
      "enabled": true,
      "last_run": null,
      "next_run": null
    },
    "monthly": {
      "type": "monthly",
      "enabled": true,
      "last_run": null,
      "next_run": null
    },
    "quarterly": {
      "type": "quarterly",
      "enabled": true,
      "last_run": null,
      "next_run": null
    }
  }
}
```

Use Write tool to create .kaaos/state/system-state.json:
```json
{
  "initialized_at": "2026-01-12T10:00:00Z",
  "version": "1.0",
  "default_organization": "organization-name",
  "current_session": null
}
```

Replace timestamps and organization name with actual values.

### Phase 6: Install Git Hooks

Use Bash tool to create post-commit hook:

```bash
cat > "$REPO_PATH/.git/hooks/post-commit" << 'HOOKEOF'
#!/bin/bash
# KAAOS post-commit hook - Extract insights automatically
set -euo pipefail

# Prevent infinite loop
COMMIT_MSG=$(git log -1 --pretty=%B)
if [[ "$COMMIT_MSG" == *"[KAAOS-AGENT]"* ]] || [[ "${KAAOS_AGENT_COMMIT:-}" == "1" ]]; then
    exit 0
fi

# Get commit details
COMMIT_SHA=$(git rev-parse HEAD)
COMMIT_DIFF=$(git diff HEAD~1 HEAD 2>/dev/null || echo "Initial commit")
COMMIT_MSG_FULL=$(git log -1 --pretty=%B)
FILES_CHANGED=$(git diff-tree --no-commit-id --name-only -r HEAD)

# Extract insights using simple pattern matching
INSIGHTS=""

# Look for decision patterns
if echo "$COMMIT_MSG_FULL" | grep -qi "decide\|decision\|chose\|selected"; then
    INSIGHTS="$INSIGHTS\n- Decision detected in commit message"
fi

# Look for architecture patterns
if echo "$FILES_CHANGED" | grep -q "agent\|command\|lib"; then
    INSIGHTS="$INSIGHTS\n- Architecture change"
fi

# Look for documentation
if echo "$FILES_CHANGED" | grep -q "\.md$"; then
    INSIGHTS="$INSIGHTS\n- Documentation updated"
fi

# Save insights if any found
if [ -n "$INSIGHTS" ]; then
    mkdir -p .kaaos/insights/pending

    cat > ".kaaos/insights/pending/${COMMIT_SHA}.json" <<EOF
{
  "commit_sha": "$COMMIT_SHA",
  "timestamp": $(date +%s)000,
  "commit_message": $(echo "$COMMIT_MSG_FULL" | jq -Rs .),
  "files_changed": $(echo "$FILES_CHANGED" | jq -R . | jq -s .),
  "insights": $(echo -e "$INSIGHTS" | grep "^-" | jq -R . | jq -s .),
  "processed": false
}
EOF

    echo "[KAAOS] Insights extracted from $COMMIT_SHA" >> .kaaos/logs/insights.log
fi

exit 0
HOOKEOF

chmod +x "$REPO_PATH/.git/hooks/post-commit"
```

Use Bash tool to create pre-push hook:

```bash
cat > "$REPO_PATH/.git/hooks/pre-push" << 'HOOKEOF'
#!/bin/bash
# KAAOS pre-push hook - Validate structure
set -euo pipefail

# Future: Validate repository structure
exit 0
HOOKEOF

chmod +x "$REPO_PATH/.git/hooks/pre-push"
```

### Phase 7: Create Organization Metadata

Use Write tool to create organizations/[org-name]/_meta.yaml (get current date via Bash date command first):

```yaml
name: organization-name
created_at: '2026-01-12T10:00:00Z'
description: ''
type: personal
owner: username
tags: []
settings:
  default_project: null
  auto_context_loading: true
```

Use Write tool to create organizations/[org-name]/README.md:

```markdown
# Organization Name

Organization knowledge base for Organization Name.

## Overview

This organization contains projects, context libraries, and conversation history.

## Structure

- `context-library/` - Organizational knowledge and cross-project insights
- `projects/` - Individual projects with their own contexts and conversations

## Getting Started

Start a session:
```
/kaaos:session organization-name/[project-name]
```

Create a project:
```
mkdir -p projects/[project-name]/{context-library,conversations}
```
```

Use Write tool to create organizations/[org-name]/context-library/_organizational/README.md:

```markdown
# Organizational Context Library

Cross-project knowledge, patterns, and insights for this organization.

## Purpose

This library contains knowledge that applies across multiple projects:
- Strategic decisions
- Architectural patterns
- Team playbooks
- Shared domain knowledge

## Usage

Files in this library are automatically loaded during sessions.
```

Create index file using Write tool for organizations/[org-name]/context-library/index.md:

```markdown
# Context Library Index

## Organizational Context
- [Organizational README](_organizational/README.md)

## Projects
(Projects will be listed here as they are created)
```

### Phase 8: Create Repository README

Use Write tool to create README.md in repository root:

```markdown
# KAAOS Knowledge Repository

Multi-organization knowledge management system powered by KAAOS.

## Organizations

- [organization-name](organizations/organization-name/) - Organization knowledge base

## Usage

### Start a Session
```
/kaaos:session organization-name/[project-name]
```

### Spawn Research
```
/kaaos:research "topic to investigate"
```

### Check Status
```
/kaaos:status
```

### View Digests
```
/kaaos:digest daily
/kaaos:digest weekly
/kaaos:digest monthly
```

## Operational Rhythms

- **Daily** (7:00 AM): Morning digest of yesterday's work
- **Weekly** (Mon 6:00 AM): Pattern synthesis and gap identification
- **Monthly** (1st 5:00 AM): Strategic alignment review
- **Quarterly** (Quarterly 1st 3:00 AM): Comprehensive analysis

## Repository Statistics

- Initialized: [current-date]
- Organizations: 1
- Projects: 0
- Context Items: 0

---

Managed by KAAOS v1.0
```

Replace placeholders with actual values.

### Phase 9: Create .gitkeep Files

Use Bash tool to create placeholder files:

```bash
touch "$REPO_PATH/organizations/$ORG_NAME/projects/.gitkeep"
touch "$REPO_PATH/.kaaos/locks/.gitkeep"
touch "$REPO_PATH/.kaaos/logs/.gitkeep"
touch "$REPO_PATH/.digests/daily/.gitkeep"
touch "$REPO_PATH/.digests/weekly/.gitkeep"
touch "$REPO_PATH/.digests/monthly/.gitkeep"
touch "$REPO_PATH/.digests/quarterly/.gitkeep"
```

### Phase 10: Initial Git Commit

Use Bash tool to commit all files:

```bash
cd "$REPO_PATH" && \
git add -A && \
git commit -m "Initialize KAAOS repository with organization: $ORG_NAME

Created by KAAOS Orchestrator
Timestamp: $(date -Iseconds)"
```

### Phase 11: Set Up Automation (Automatic)

**Automatically create automation for hands-free reviews.**

Use Bash tool to create automation directory and scripts:

```bash
mkdir -p ~/.kaaos/automation
mkdir -p ~/.kaaos/logs
```

Create daily-review.sh, weekly-synthesis.sh, monthly-review.sh, quarterly-analysis.sh scripts (see /kaaos:automation for full implementation).

Each script creates a pending marker file at scheduled time.

Create launchd plists in ~/Library/LaunchAgents/ for each review type.

Load launchd agents:
```bash
launchctl load ~/Library/LaunchAgents/com.kaaos.daily-review.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.weekly-synthesis.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.monthly-review.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.quarterly-analysis.plist
```

Display: "✓ Automation configured (daily 7AM, weekly Mon 6AM, monthly 1st 5AM, quarterly)"

### Phase 12: Optional claude-mem Integration (Recommended)

**For semantic cross-linking and enhanced co-pilot suggestions.**

Display recommendation:
```
┌─────────────────────────────────────────────────────────────┐
│          Optional Enhancement: claude-mem Integration        │
└─────────────────────────────────────────────────────────────┘

KAAOS works great with keyword-based cross-linking.

For SEMANTIC understanding (finds related content even with different words):

Install claude-mem:
  1. /plugin marketplace add thedotmack/claude-mem
  2. /plugin install claude-mem
  3. Restart Claude Code
  4. KAAOS automatically detects and uses it

Benefits:
  • Real-time semantic suggestions (not just keywords)
  • Discover non-obvious connections across different terminology
  • Auto-cross-linking based on concept similarity
  • Smarter pattern detection in reviews
  • Enhanced context loading (semantic relevance)

Cost: claude-mem runs background service (~$10-20/month additional)

Install claude-mem now? [Y/n/Later]
```

If user says "Y" or "Later", display:
```
To install claude-mem, run these commands:

  /plugin marketplace add thedotmack/claude-mem
  /plugin install claude-mem

Then restart Claude Code.

KAAOS will automatically detect claude-mem and enable semantic features.
```

If user says "n", continue:
```
Skipping claude-mem - KAAOS will use keyword-based cross-linking.

You can install later with the commands above.
```

### Phase 13: Validate and Report Success

Use Bash tool to verify structure:

```bash
# Check critical directories exist
test -d "$REPO_PATH/.git" && \
test -d "$REPO_PATH/.kaaos" && \
test -d "$REPO_PATH/.global-context" && \
test -f "$REPO_PATH/.global-context/methodology.md" && \
test -d "$REPO_PATH/organizations/$ORG_NAME" && \
test -f "$REPO_PATH/.kaaos/config.yaml" && \
echo "VALIDATION_OK" || echo "VALIDATION_FAILED"
```

If validation succeeds, display success message:

```
┌─────────────────────────────────────────────────────────────┐
│          KAAOS Repository Initialized Successfully          │
└─────────────────────────────────────────────────────────────┘

Repository: /path/to/repo
Organization: organization-name

✓ Directory structure created
✓ Global context methodology initialized
✓ Git repository initialized
✓ Git hooks installed (post-commit insights, pre-push validation)
✓ Lifecycle hooks active (real-time co-pilot, auto-organization)
✓ Knowledge graph infrastructure installed
✓ Configuration created
✓ State files initialized
✓ Automation configured (daily/weekly/monthly/quarterly)
✓ Initial commit created

Next Steps:
  1. Start working: /kaaos:session organization-name/[project-name]
  2. Check status: /kaaos:status
  3. Review methodology: .global-context/methodology.md
  4. Disable automation (optional): /kaaos:automation disable

Everything is set up! Knowledge will now compound automatically.

For help: Run /kaaos:status to see system overview
```

If validation fails, display error message with details about what failed.

## Error Handling

### Invalid Organization Name
Display error: "Invalid organization name. Use alphanumeric characters, hyphens, and underscores only."

### Directory Already Exists
Use Bash tool to check if directory is empty:
```bash
ls -A "$REPO_PATH" | wc -l
```

If not empty, display error: "Directory already exists and is not empty. Use a different path or remove existing files."

### Permission Denied
If any mkdir or write operation fails, display clear error message about permission issues.

## Notes

- All file operations use Claude's Write tool
- All directory operations use Bash tool with mkdir
- All git operations use Bash tool with git commands
- JSON files use simple structure for easy jq manipulation
- YAML configuration is human-readable and editable
- Git hooks are executable shell scripts
- State files are initialized empty but valid JSON
