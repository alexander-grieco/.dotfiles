---
name: claude-md
description: |
  Write effective CLAUDE.md files that serve as persistent memory for Claude Code.
  Use when creating, reviewing, or improving project instructions for AI assistance.
  Triggers: CLAUDE.md, project instructions, memory file, AI setup, claude configuration
---

# Writing Effective CLAUDE.md Files

## Purpose

CLAUDE.md files are persistent memory for Claude Code, automatically loaded at session start. They provide project context, conventions, and operational guidance without cluttering conversation context.

## Agent Behavior: Always Ask Before Writing

**CRITICAL**: When creating or updating any section of a CLAUDE.md file, you MUST use the `AskUserQuestion` tool to confirm content with the user before writing.

For each section:
1. Propose your best recommendation as the primary option
2. Include "Leave empty for now" as an alternative
3. Only offer multiple substantive options if there's a genuinely compelling second choice
4. Let the user provide their own input via "Other" if they disagree

**Example interaction:**
- "For the Quick Start section, I recommend these commands based on your Makefile. Does this look correct, or would you like to adjust?"
- Do NOT assume and auto-populate sections without user confirmation

---

## Core Principles

1. **Actionable over descriptive** - Tell Claude what to DO, not just what exists
2. **Specific over vague** - "Use 2-space indentation" beats "Write clean code"
3. **Minimal but complete** - Include what's needed, exclude what's not
4. **Hierarchical by design** - Project-level vs subdirectory-level instructions

---

## Essential Sections

Every CLAUDE.md should include these sections. Leave headings for empty sections so engineers know they can add content later.

### 1. Project Summary

A 2-3 sentence description of what the project is and does.

## Project Summary

This is a TypeScript SDK for integrating Flow blockchain wallets into web applications. It provides wallet connection, transaction signing, and event subscription capabilities.

### 2. Quick Start Commands

The most common commands an engineer (or Claude) will run. Emphasize Makefile targets.

## Quick Start

    make dev              # Start dev server with hot-reload
    make test             # Run full test suite
    make build            # Production build
    make lint && make test  # Before committing

### 3. Development Workflow

How to run, build, and test the project locally.

## Development Workflow

### Running Locally
- `make dev` starts the server on localhost:3000 with hot-reload
- Check if already running: `lsof -i :3000`
- View logs: `make logs` or `tail -f logs/dev.log`

### Building
- `make build` compiles TypeScript and bundles for production
- Build output goes to `dist/`

### Testing
- `make test` - Full test suite
- `make test-unit` - Unit tests only
- `make test-integration` - Integration tests (requires local db)
- `make test-e2e` - E2E tests (requires running server)

### 4. Project Tendencies

Behavioral patterns and preferences for this codebase.

## Project Tendencies

- **Makefile-first**: Always check Makefile for available commands before using raw CLI
- **Hot-reload**: Dev server auto-reloads; no manual restart needed after code changes
- **Subagents for logs**: When monitoring logs or running long processes, use subagents
- **Parallel tests**: Test suites can run in parallel; use `make test-parallel` for speed

### 5. Useful Tools

MCPs, skills, or slash commands particularly useful for this project. Reference Makefile targets for common utilities.

## Useful Tools

### Skills
- `/flow-deploy` - Deploy Cadence contracts with validation
- `/quality-audit` - Run comprehensive quality checks

### MCPs
- context7 MCP for documentation searches
- BigQuery MCP for analytics queries

### Make Targets
- `make lint` - Run linting
- `make format` - Auto-format code
- `make db-migrate` - Run database migrations

### 6. Repository Etiquette

Git workflow and conventions for the team.

## Repository Etiquette

### Branch Naming
- Always include Linear ticket name if applicable
- `feature/ABC-123-short-description` for features
- `fix/ABC-123-short-description` for bug fixes
- `chore/description` for maintenance

### Commit Style
- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`
- Reference ticket: `feat(auth): add SSO support [ABC-123]`

### Merge Strategy
- Squash merge for feature branches
- Rebase onto main before merging

### Releases
- Releases created via GitHub Actions on tag push
- Tag format: `v1.2.3` (semver)

### 7. CI/CD and GitHub Actions

What automation exists and how to interact with it.

## CI/CD

### GitHub Actions
- `ci.yml` - Runs on every PR (lint, test, build)
- `deploy.yml` - Manual trigger for deployments
- `release.yml` - Triggered on version tags

### Running Actions Locally
- Use `act` CLI: `act -j test`
- Or: `make ci-local`

### 8. Warnings and Gotchas

Unexpected behaviors or known issues Claude should be aware of.

## Warnings and Gotchas

- **Port 3000 conflict**: Dev server fails silently if port in use. Check with `lsof -i :3000`
- **Node version**: Tests fail on Node 16; ensure Node 18+
- **Docker required**: Integration tests require Docker running
- **Flaky test**: `test/e2e/auth.spec.ts` occasionally times out; safe to retry
- **Build cache**: If build behaves unexpectedly, run `make clean` first

### 9. Project Structure (Optional)

Include for larger projects (100+ files). Keep selective, not exhaustive.

## Project Structure

    src/
    ├── api/          # REST API handlers
    ├── services/     # Business logic
    ├── models/       # Data models and types
    └── config/       # Configuration loaders

    tests/
    ├── unit/         # Fast, isolated tests
    ├── integration/  # Tests with external deps
    └── e2e/          # Full flow tests

Key files:
- `src/index.ts` - Main entry point
- `src/config/index.ts` - All configuration loading

---

## Content That Belongs in .claude/rules/

Move one-time or specialized content to `.claude/rules/*.md` files:

| Content | Why in .claude/rules/ |
|---------|----------------------|
| First-time setup (prerequisites, install) | Only needed once per developer |
| Environment variable details | Reference material, not daily use |
| Detailed code conventions | Specialized, not always needed |
| Security requirements | Loaded when relevant |
| Testing patterns | Load when writing tests |

**Example structure:**

    project/
    ├── CLAUDE.md                 # Daily operational context
    └── .claude/
        └── rules/
            ├── setup.md          # First-time setup instructions
            ├── env-vars.md       # Environment variable reference
            └── security.md       # Security requirements

All `.md` files in `.claude/rules/` are automatically loaded with the same priority as `CLAUDE.md`.

---

## Hierarchical Organization

Claude Code loads CLAUDE.md files recursively from current directory up to root, and discovers nested ones when reading files in subdirectories.

### When to Use Subdirectory CLAUDE.md

Move instructions to subdirectory CLAUDE.md when they:
- Only apply to that directory's code
- Are specialized conventions (e.g., test patterns, API standards)
- Would clutter the root file with rarely-needed context

**Example structure:**

    project/
    ├── CLAUDE.md                 # Project-wide instructions
    ├── src/
    │   └── api/
    │       └── CLAUDE.md         # API-specific conventions
    ├── tests/
    │   └── CLAUDE.md             # Testing conventions
    └── infrastructure/
        └── CLAUDE.md             # Terraform/K8s conventions

### Importing Files

Use `@path/to/file` syntax to import additional context:

    # CLAUDE.md
    See @README.md for project overview.

    # Coding Standards
    @docs/coding-standards.md

    # Personal preferences (not in repo)
    @~/.claude/my-preferences.md

---

## What NOT to Include

Keep CLAUDE.md lean by excluding:

| Exclude | Why | Where Instead |
|---------|-----|---------------|
| First-time setup details | Only needed once | `.claude/rules/setup.md` |
| Detailed code conventions | Loaded on-demand wastes tokens | Skills or subdirectory CLAUDE.md |
| API reference docs | Too verbose, changes frequently | Link to docs or use skills |
| Full dependency lists | package.json/go.mod already exists | Reference the file |
| Secrets or credentials | Security risk | .env files, vault |
| Historical changes | Irrelevant to current work | CHANGELOG.md |

---

## Template

A minimal but complete CLAUDE.md template:

## Project Summary

<!-- 2-3 sentences: what this project is and does -->

## Quick Start

    make dev        # Start development server
    make test       # Run tests
    make build      # Production build

## Development Workflow

### Running Locally
<!-- How to start, check status, view logs -->

### Building
<!-- Build commands and output location -->

### Testing
<!-- Test commands for different scopes -->

## Project Tendencies

<!-- Behavioral patterns: Makefile usage, hot-reload, subagents, etc. -->

## Useful Tools

### Skills
<!-- Relevant slash commands -->

### MCPs
<!-- Available MCP integrations -->

### Make Targets
<!-- Key make targets for common operations -->

## Repository Etiquette

### Branch Naming
<!-- Pattern for branch names -->

### Commit Style
<!-- Commit message format -->

### Merge Strategy
<!-- Merge vs rebase preference -->

### Releases
<!-- How releases are created -->

## CI/CD

<!-- GitHub Actions and automation available -->

## Warnings and Gotchas

<!-- Known issues, flaky tests, common mistakes -->

## Project Structure

<!-- Optional: High-level directory overview for large projects -->

---

## Additional Resources

- For detailed examples by project type, see [examples/](examples/)
- For anti-patterns to avoid, see [anti-patterns.md](anti-patterns.md)
- For migration guide from other formats, see [migration.md](migration.md)

---

## Checklist

Before finalizing a CLAUDE.md:

- [ ] Project summary is clear and concise (2-3 sentences)
- [ ] CLAUDE.md is less than 500 lines long
- [ ] Quick start commands work and are up-to-date
- [ ] Makefile targets documented (if Makefile exists)
- [ ] Testing commands cover unit, integration, and e2e
- [ ] Specialized or infrequently used content is offloaded to the appropriate place (sub-directory CLAUDE.md , .claude/rules/, or a plugin)