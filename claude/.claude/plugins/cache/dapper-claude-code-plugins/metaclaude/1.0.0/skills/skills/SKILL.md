# Building Claude Code Skills

## Overview

Skills are markdown files that teach Claude how to perform specific tasks. Unlike slash commands (user-invoked), skills are **model-invoked** - Claude automatically discovers and applies them based on task context.

**Key Architecture Principle**: Skills should be designed with **progressive disclosure** and **lazy loading** in mind. Keep the main `SKILL.md` lean (~100-500 lines) and reference supporting files that are loaded only when needed.

---

## Why Multi-File Architecture Matters

Claude loads skill content into its context window along with conversation history, other skills, and your request. Large monolithic skills consume valuable context and slow response times.

**Lazy Loading Benefits**:
- Faster initial skill discovery (only name + description loaded at startup)
- Reduced context consumption during execution
- Claude loads supporting files only when the specific sub-capability is needed
- Better separation of concerns and maintainability

---

## Skill Structure

### Minimal Skill (Single File)

```
my-skill/
└── SKILL.md    # Required: Contains frontmatter + instructions
```

### Multi-File Skill (Recommended for Complex Skills)

```
my-skill/
├── SKILL.md              # Overview, navigation, core workflow (required)
├── reference.md          # Detailed API/syntax reference (lazy-loaded)
├── examples.md           # Usage examples (lazy-loaded)
├── patterns/
│   ├── pattern-a.md      # Specific pattern documentation
│   └── pattern-b.md      # Another pattern
├── validation/
│   └── checklist.md      # Validation criteria
└── scripts/
    └── helper.py         # Utility scripts (executed, not loaded as context)
```

---

## SKILL.md Syntax

### Required Frontmatter

```yaml
---
name: skill-name                    # Required: lowercase, hyphens only, max 64 chars
description: Brief description...   # Required: max 1024 chars, include trigger keywords
---
```

### Optional Frontmatter Fields

```yaml
---
name: skill-name
description: What it does and when Claude should use it
model: inherit                      # inherit | opus | sonnet | haiku
context: fork                       # Run in isolated subagent context
agent: general-purpose              # Subagent type when context: fork
allowed-tools: Read, Grep, Glob     # Restrict available tools
user-invocable: true                # Show in slash command menu (default: true)
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

### Field Reference

| Field | Required | Max Length | Purpose |
|-------|----------|------------|---------|
| `name` | Yes | 64 chars | Must match directory name, lowercase with hyphens |
| `description` | Yes | 1024 chars | Trigger keywords for auto-discovery |
| `model` | No | - | Override model (inherit, opus, sonnet, haiku) |
| `context` | No | - | `fork` for isolated subagent execution |
| `agent` | No | - | Subagent type when `context: fork` |
| `allowed-tools` | No | - | Restrict Claude to specific tools |
| `user-invocable` | No | - | `false` hides from slash menu |
| `hooks` | No | - | Lifecycle event handlers |

---

## Multi-File Architecture Patterns

### Pattern 1: Reference Files for Detailed Documentation

Keep the main SKILL.md focused on workflow, reference details in supporting files:

**SKILL.md** (lean overview):
```markdown
---
name: api-design
description: Design RESTful APIs with OpenAPI specs. Use for API design, documentation, or validation.
---

# API Design Skill

## Quick Start
1. Analyze requirements
2. Design endpoints
3. Generate OpenAPI spec
4. Validate design

## Core Workflow
[Essential 50-100 lines of workflow instructions]

## Additional Resources
- For OpenAPI syntax details, see [openapi-reference.md](openapi-reference.md)
- For design patterns, see [patterns/](patterns/)
- For examples, see [examples.md](examples.md)
```

**openapi-reference.md** (loaded when needed):
```markdown
# OpenAPI Reference

## Schema Definitions
[Detailed schema documentation - 200+ lines]

## Path Parameters
[Detailed path parameter docs]

## Response Formats
[Response format specifications]
```

### Pattern 2: Modular Sub-Skills

Break complex skills into focused sub-components:

```
security-audit/
├── SKILL.md                        # Orchestrates the audit workflow
├── phases/
│   ├── discovery.md                # Phase 1: Discovery queries
│   ├── static-analysis.md          # Phase 2: Static analysis
│   ├── access-control.md           # Phase 3: Access control review
│   ├── testing.md                  # Phase 4: Test validation
│   └── reporting.md                # Phase 5: Report generation
└── checklists/
    ├── critical-findings.md        # Critical severity checklist
    └── deployment-readiness.md     # Deployment approval checklist
```

**SKILL.md**:
```markdown
---
name: security-audit
description: Comprehensive security audit for smart contracts. Use before deployment.
---

# Security Audit Skill

## Audit Phases
This audit follows 5 mandatory phases. Each phase is documented separately for focused execution.

### Phase 1: Discovery
Execute pre-audit discovery queries.
**Details**: [phases/discovery.md](phases/discovery.md)

### Phase 2: Static Analysis
Run automated static analysis tools.
**Details**: [phases/static-analysis.md](phases/static-analysis.md)

### Phase 3: Access Control Review
Validate access control implementation.
**Details**: [phases/access-control.md](phases/access-control.md)

### Phase 4: Testing Validation
Verify test coverage meets requirements.
**Details**: [phases/testing.md](phases/testing.md)

### Phase 5: Report Generation
Generate comprehensive audit report.
**Details**: [phases/reporting.md](phases/reporting.md)

## Severity Definitions
- **Critical**: Blocks deployment, immediate fix required
- **High**: Blocks deployment, fix before release
- **Medium**: Deploy with risk acceptance
- **Low**: Track in backlog
```

### Pattern 3: Domain-Specific Sub-Skills

When a skill applies to multiple domains with variations:

```
testing/
├── SKILL.md                        # Core testing philosophy and workflow
├── domains/
│   ├── unit-testing.md             # Unit test specifics
│   ├── integration-testing.md      # Integration test patterns
│   ├── e2e-testing.md              # End-to-end testing
│   └── contract-testing.md         # Smart contract testing
└── frameworks/
    ├── jest.md                     # Jest-specific guidance
    ├── pytest.md                   # Pytest-specific guidance
    └── go-test.md                  # Go testing guidance
```

### Pattern 4: Conditional Reference Loading

Reference files based on detected context:

**SKILL.md**:
```markdown
## Framework-Specific Guidance

Choose the appropriate reference based on your project:

- **React projects**: See [frameworks/react.md](frameworks/react.md)
- **Vue projects**: See [frameworks/vue.md](frameworks/vue.md)
- **Angular projects**: See [frameworks/angular.md](frameworks/angular.md)
- **Svelte projects**: See [frameworks/svelte.md](frameworks/svelte.md)

Claude will load the relevant framework guide based on detected project type.
```

---

## Best Practices

### 1. Write Effective Descriptions

The `description` field determines when Claude activates your skill. Include specific trigger keywords.

**Good** (specific triggers):
```yaml
description: |
  Design and implement GraphQL APIs with schema-first approach.
  Use when building GraphQL services, defining schemas, or implementing resolvers.
  Triggers: graphql, schema, resolver, mutation, subscription, apollo
```

**Bad** (too vague):
```yaml
description: Helps with API stuff
```

### 2. Keep SKILL.md Under 500 Lines

| Section | Recommended Lines |
|---------|-------------------|
| Frontmatter | 5-15 |
| Overview/Purpose | 10-30 |
| Prerequisites | 10-20 |
| Core Workflow | 50-200 |
| Navigation to References | 20-50 |
| Integration Notes | 10-30 |
| **Total** | **~100-350 lines** |

### 3. Use Clear Navigation

Help Claude (and humans) find the right reference file:

```markdown
## Additional Resources

| Topic | File | When to Use |
|-------|------|-------------|
| API Reference | [reference.md](reference.md) | Detailed syntax lookup |
| Examples | [examples.md](examples.md) | Implementation patterns |
| Troubleshooting | [troubleshooting.md](troubleshooting.md) | Error resolution |
```

### 4. Structure Reference Files Consistently

Each reference file should be self-contained with clear sections:

```markdown
# [Topic] Reference

## Overview
Brief context for this reference.

## [Main Content Sections]
Detailed documentation...

## Related
- Links to related references within the skill
```

### 5. Use Relative Paths

Always use relative paths from SKILL.md:

```markdown
# Correct
See [patterns/validation.md](patterns/validation.md)

# Incorrect
See /absolute/path/to/patterns/validation.md
```

### 6. Include Scripts for Zero-Context Execution

For operations that don't need LLM context, include utility scripts:

```markdown
## Utility Scripts

To validate input: `python scripts/validate.py input.json`
To generate report: `python scripts/report.py --format html`
```

Scripts execute without consuming context window space.

---

## Tool Access Control

Restrict skill capabilities using `allowed-tools`:

### Read-Only Skill
```yaml
allowed-tools: Read, Grep, Glob
```

### Code Analysis Skill
```yaml
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(grep:*, find:*, wc:*)
```

### Full Access (Default)
Omit `allowed-tools` to allow all tools.

---

## Forked Context Execution

Use `context: fork` for isolated execution:

```yaml
---
name: complex-analysis
description: Deep analysis that generates extensive output
context: fork
agent: general-purpose
---
```

**When to Use**:
- Complex multi-step operations
- High-volume output generation
- Operations that should not pollute main conversation
- Chained subagent workflows

---

## Skill Discovery and Loading Flow

```
1. STARTUP (Fast)
   └── Load skill names + descriptions only (~100 bytes each)

2. TASK MATCHING
   └── Claude analyzes task against skill descriptions
   └── Selects relevant skill(s)

3. SKILL ACTIVATION
   └── Load full SKILL.md content
   └── Parse frontmatter configuration
   └── Apply tool restrictions if specified

4. PROGRESSIVE LOADING (As Needed)
   └── Claude encounters reference to supporting file
   └── Loads specific reference file on demand
   └── Uses reference content for current sub-task
   └── Returns to main workflow
```

---

## File Organization Guidelines

### Naming Conventions
- **Skill directories**: lowercase, hyphens (`api-design/`, `security-audit/`)
- **Main file**: Always `SKILL.md` (case-sensitive)
- **Reference files**: descriptive, lowercase (`openapi-reference.md`, `validation-checklist.md`)
- **Sub-directories**: categorical (`patterns/`, `phases/`, `frameworks/`)

### Directory Depth
- Keep references one level deep from SKILL.md
- Avoid: `skill/sub/sub/sub/reference.md` (hard to navigate)
- Prefer: `skill/category/reference.md`

### File Sizes
| File Type | Target Size | Max Size |
|-----------|-------------|----------|
| SKILL.md | 100-350 lines | 500 lines |
| Reference files | 50-300 lines | 500 lines |
| Examples files | 100-400 lines | 600 lines |

---

## Integration with Other Components

### Used By Commands
Commands can invoke skills as part of their workflow:

```markdown
## Integration Notes

**Used By**:
- `/deploy` command (pre-deployment validation)
- `/review` command (code quality checks)
```

### Used By Agents
Agents can reference skills for specialized capabilities:

```markdown
**Used By**:
- `backend-expert` agent (API design guidance)
- `security-analyst` agent (audit workflows)
```

### Depends On
Document skill dependencies:

```markdown
**Depends On**:
- n8n GitHub MCP (for repository queries)
- Flow CLI (for validation commands)
- Node.js runtime (for scripts)
```

---

## Troubleshooting

### Skill Not Triggering

**Cause**: Description doesn't match user's natural language

**Solution**: Add specific trigger keywords to description

### Skill Loads But Fails

**Cause**: YAML syntax error in frontmatter

**Check**:
1. Frontmatter starts with `---` on line 1 (no blank lines before)
2. Frontmatter ends with `---`
3. Uses spaces, not tabs
4. Run `claude --debug` to see loading errors

### Reference Files Not Loading

**Cause**: Incorrect path or file not found

**Check**:
1. Path is relative to SKILL.md location
2. File exists at specified path
3. Filename matches exactly (case-sensitive)

### Context Window Exhaustion

**Cause**: Skill and references too large

**Solution**:
1. Break into smaller reference files
2. Move detailed content to lazy-loaded references
3. Keep SKILL.md focused on workflow, not reference content

---

## Example: Complete Multi-File Skill

### Directory Structure
```
contract-deployment/
├── SKILL.md
├── phases/
│   ├── pre-deployment.md
│   ├── deployment.md
│   └── post-deployment.md
├── networks/
│   ├── emulator.md
│   ├── testnet.md
│   └── mainnet.md
├── validation/
│   └── checklist.md
└── scripts/
    └── deploy.sh
```

### SKILL.md (Main File - ~150 lines)
```yaml
---
name: contract-deployment
description: |
  Deploy smart contracts to Flow blockchain networks.
  Use for emulator, testnet, or mainnet deployments.
  Triggers: deploy, contract, mainnet, testnet, emulator
model: inherit
---
```

```markdown
# Contract Deployment Skill

## Purpose
Manage smart contract deployments across Flow networks with validation gates.

## Prerequisites
- Flow CLI installed
- Valid `flow.json` configuration
- Security audit passing (mainnet only)

## Deployment Workflow

### Phase 1: Pre-Deployment Validation
Validate contract readiness before deployment.
**Details**: [phases/pre-deployment.md](phases/pre-deployment.md)

### Phase 2: Network-Specific Deployment
Execute deployment with network-appropriate settings.

**Select Network**:
- [Emulator](networks/emulator.md) - Local development
- [Testnet](networks/testnet.md) - Integration testing
- [Mainnet](networks/mainnet.md) - Production (requires audit)

### Phase 3: Post-Deployment Verification
Verify successful deployment and functionality.
**Details**: [phases/post-deployment.md](phases/post-deployment.md)

## Quick Commands
- Validate: `flow project deploy --network=emulator --update`
- Deploy testnet: `./scripts/deploy.sh testnet`

## Integration Notes
**Used By**: `/flow-deploy` command
**Depends On**: `cadence-security-audit` skill (mainnet only)
```

---

## Skill Checklist

Use this checklist when creating skills:

- [ ] **Name**: lowercase, hyphens, matches directory
- [ ] **Description**: includes trigger keywords, under 1024 chars
- [ ] **SKILL.md**: under 500 lines, focused on workflow
- [ ] **References**: detailed content in separate files
- [ ] **Navigation**: clear links to reference files
- [ ] **Paths**: relative, forward slashes
- [ ] **Prerequisites**: documented clearly
- [ ] **Integration**: notes on commands/agents that use this skill
- [ ] **Validation**: YAML is valid (spaces, proper delimiters)

---

## Summary

| Aspect | Guidance |
|--------|----------|
| **Main File** | Keep SKILL.md lean (100-500 lines) |
| **Sub-Files** | Break detailed content into reference files |
| **Loading** | Claude lazy-loads references as needed |
| **Description** | Include trigger keywords for discovery |
| **Navigation** | Provide clear paths to sub-resources |
| **Organization** | Use categorical subdirectories |
| **Paths** | Always relative from SKILL.md |
| **Context** | Use `context: fork` for isolation |
| **Tools** | Restrict with `allowed-tools` if needed |
