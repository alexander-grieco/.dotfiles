# KAAOS Skills

Comprehensive skills for KAAOS plugin users and agents, following Claude Code progressive disclosure pattern.

## Available Skills

### 1. Knowledge Management

**File**: `knowledge-management/SKILL.md`

**Purpose**: Implement Zettelkasten-inspired knowledge management for building and maintaining context libraries with automated cross-referencing.

**When to Use**:
- Building context libraries for organizations or projects
- Implementing cross-referencing systems
- Creating knowledge bases that compound over time
- Migrating from fragmented tools to unified knowledge systems

**Key Concepts**:
- Context library architecture (org/project/conversation hierarchy)
- Zettelkasten principles adapted for AI
- Note types: atomic, map, synthesis, playbook, decision, pattern, reference
- Cross-reference system with semantic linking
- Knowledge lifecycle and maintenance

**Progressive Disclosure**:
- **SKILL.md** (554 lines): Core concepts, quick start, implementation patterns
- **references/context-library-patterns.md**: Detailed architectural patterns, scaling strategies
- **references/cross-referencing-system.md**: Advanced linking strategies, graph visualization
- **assets/context-library-template.md**: Ready-to-use templates for all note types

**Quick Start**:
```bash
/kaaos:init personal
cd ~/kaaos-knowledge/organizations/personal/context-library
# Use templates to create your first notes
```

### 2. Operational Rhythms

**File**: `operational-rhythms/SKILL.md`

**Purpose**: Implement automated operational review rhythms (daily/weekly/monthly/quarterly) for knowledge synthesis and strategic alignment.

**When to Use**:
- Setting up automated executive review systems
- Establishing knowledge maintenance cadences
- Implementing strategic planning cycles
- Building systems for insight compounding

**Key Concepts**:
- Four rhythm hierarchy: daily (5-10 min), weekly (30-60 min), monthly (2-3 hours), quarterly (half-day)
- Zero-user-time automation with git hooks and scheduled agents
- Progressive detail: headlines → synthesis → strategic → comprehensive
- Cost-conscious automation ($50-100/month typical)

**Progressive Disclosure**:
- **SKILL.md** (726 lines): Core rhythm concepts, agent orchestration, implementation
- **references/weekly-rhythm-patterns.md**: Detailed weekly synthesis patterns and algorithms
- **assets/daily-template.md**: Daily digest template and configuration
- **assets/weekly-template.md**: Weekly synthesis template and pattern extraction

**Quick Start**:
```bash
# Initialize with rhythms enabled
/kaaos:init personal

# Manually trigger rhythms
/kaaos:review daily
/kaaos:review weekly
```

### 3. Session Management

**File**: `session-management/SKILL.md`

**Purpose**: Initialize work sessions with context loading, recent history review, and co-pilot agent spawning.

**When to Use**:
- Starting work sessions on specific projects
- Switching between different organizational contexts
- Loading context after time away from a project
- Spawning co-pilot agents for real-time assistance

**Key Concepts**:
- Session types: focus, strategic, research, meeting-prep
- Progressive context loading (essential → recent → related → archive)
- Token budget management (40K context budget from 200K window)
- Co-pilot agent spawning and interaction patterns
- Session state persistence and resumption

**Progressive Disclosure**:
- **SKILL.md** (639 lines): Session types, context loading, co-pilot patterns
- **references/context-loading-strategies.md**: Advanced loading patterns, compression, caching
- **assets/session-checklist.md**: Pre-session preparation checklist

**Quick Start**:
```bash
# Start a focus session
/kaaos:session personal/product-launch

# With co-pilot for long session
/kaaos:session personal/product-launch --copilot

# Strategic session
/kaaos:session personal --strategic
```

## Skill Structure

Each skill follows the Claude Code progressive disclosure pattern:

```
skill-name/
├── SKILL.md                 # Main skill (<750 lines)
│                            # - YAML frontmatter
│                            # - When to use
│                            # - Core concepts
│                            # - Quick start
│                            # - Implementation patterns
│                            # - Best practices
│                            # - Resources
│
├── references/              # Detailed deep-dives
│   ├── pattern-1.md         # Specific pattern details
│   ├── pattern-2.md         # Advanced techniques
│   └── ...
│
└── assets/                  # Ready-to-use templates
    ├── template-1.md        # Starter templates
    ├── template-2.md        # Configuration examples
    └── ...
```

## Usage in KAAOS

### By Users

Skills provide comprehensive guidance for using KAAOS features:

```bash
# Reference skills when learning
cat skills/knowledge-management/SKILL.md | less

# Use templates from assets
cp skills/knowledge-management/assets/context-library-template.md ~/kaaos-knowledge/organizations/personal/

# Follow patterns from references
open skills/session-management/references/context-loading-strategies.md
```

### By Agents

Agents can reference skills for implementation guidance:

```python
# In agent prompt
"""
You are implementing knowledge management for a user.
Reference: /Users/ben/src/kaaos/skills/knowledge-management/SKILL.md

Follow the patterns in the skill, particularly:
1. Context library architecture (3-level hierarchy)
2. Note type taxonomy (atomic, map, synthesis, etc.)
3. Cross-referencing system (bidirectional links)

Create notes using templates from:
/Users/ben/src/kaaos/skills/knowledge-management/assets/context-library-template.md
"""
```

### By Commands

Commands can load skill context:

```python
# In /kaaos:session command
def initialize_session(org, project):
    # Load session management skill
    skill = load_skill('session-management')

    # Apply patterns from skill
    context = load_context_progressive(
        org,
        project,
        strategy=skill.context_loading_strategies
    )
```

## Integration with Plugin

### Plugin Structure Reference

```
kaaos/
├── .claude-plugin/
│   └── plugin.json           # References skills
├── agents/                    # Can reference skills
├── commands/                  # Can load skills
├── skills/                    # This directory
│   ├── knowledge-management/
│   ├── operational-rhythms/
│   └── session-management/
├── lib/                       # Implements skill patterns
└── templates/                 # Uses skill templates
```

### Skill Registration

Skills should be registered in plugin.json (future):

```json
{
  "name": "kaaos",
  "version": "1.0.0",
  "skills": [
    {
      "name": "knowledge-management",
      "path": "skills/knowledge-management/SKILL.md",
      "description": "Zettelkasten-inspired knowledge management patterns"
    },
    {
      "name": "operational-rhythms",
      "path": "skills/operational-rhythms/SKILL.md",
      "description": "Automated review rhythms for knowledge synthesis"
    },
    {
      "name": "session-management",
      "path": "skills/session-management/SKILL.md",
      "description": "Session initialization and context loading patterns"
    }
  ]
}
```

## Statistics

| Skill | Main | References | Assets | Total |
|-------|------|------------|--------|-------|
| knowledge-management | 554 lines | 2 files | 1 file | 3 files |
| operational-rhythms | 726 lines | 1 file | 2 files | 3 files |
| session-management | 639 lines | 1 file | 1 file | 2 files |
| **Total** | **1,919 lines** | **4 files** | **4 files** | **11 files** |

## Content Coverage

### Knowledge Management (3 files, ~2,500 lines)
- Context library architecture patterns
- Note type taxonomy and templates
- Cross-referencing and linking systems
- Knowledge lifecycle and maintenance
- Migration strategies from existing tools
- Graph visualization and metrics
- Automated maintenance workflows

### Operational Rhythms (3 files, ~3,000 lines)
- Daily digest generation (5-10 min reviews)
- Weekly pattern synthesis (30-60 min)
- Monthly strategic alignment (2-3 hours)
- Quarterly comprehensive reviews (half-day)
- Pattern extraction algorithms
- Playbook usage tracking
- Cost management and budget controls

### Session Management (2 files, ~2,000 lines)
- Session initialization patterns
- Progressive context loading strategies
- Token budget management
- Co-pilot agent spawning
- Session state persistence
- Context compression techniques
- Multi-level caching strategies

## Best Practices

### For Skill Authors

1. **Progressive Disclosure**: Main skill <750 lines, details in references
2. **Practical Examples**: Code snippets and real implementations
3. **Clear When to Use**: Explicit applicability criteria
4. **Ready Templates**: Assets should be copy-paste ready
5. **Cross-References**: Link between related skills
6. **Maintain Consistency**: Follow existing skill patterns

### For Skill Users

1. **Start with SKILL.md**: Get overview and quick start
2. **Use Quick Start**: Try it before diving deep
3. **Reference Details**: Go to references/ when needed
4. **Copy Templates**: Use assets/ for starter files
5. **Adapt Patterns**: Customize for your context
6. **Contribute Back**: Share improvements

## Future Skills

Potential additions to skills directory:

- **multi-agent-orchestration**: Patterns for spawning and coordinating agents
- **cost-optimization**: Budget management and cost reduction strategies
- **git-integration**: Git hooks, automation, and workflow patterns
- **research-workflows**: Deep research and investigation patterns
- **strategic-planning**: Quarterly and annual planning frameworks
- **meeting-management**: Meeting prep, facilitation, and follow-up
- **decision-frameworks**: Comprehensive decision-making patterns
- **playbook-creation**: How to create and maintain playbooks

## Contributing

When adding new skills:

1. Follow the structure: `SKILL.md` + `references/` + `assets/`
2. Keep main skill <750 lines
3. Use YAML frontmatter
4. Include "When to Use" section
5. Provide practical examples
6. Add templates in assets/
7. Update this README

## License

MIT License - See LICENSE file for details

---

**For KAAOS Plugin Documentation**: See `/Users/ben/src/kaaos/README.md`
