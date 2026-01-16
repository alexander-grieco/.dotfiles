# Migrating to CLAUDE.md

Guide for converting existing documentation or starting fresh.

---

## From Nothing

If your project has no CLAUDE.md, start with the essentials:

### Minimum Viable CLAUDE.md

    ## Project Summary

    [One sentence: what does this project do?]

    ## Quick Start

        make setup    # or: npm install
        make dev      # or: npm run dev
        make test     # or: npm test

    ## Warnings and Gotchas

    <!-- Add issues as you discover them -->

### Next Steps

1. Run through a typical development session
2. Note what commands you use
3. Note what trips you up
4. Add to CLAUDE.md as you go

---

## From README.md

README and CLAUDE.md serve different purposes:

| README.md | CLAUDE.md |
|-----------|-----------|
| For humans browsing GitHub | For Claude's operational context |
| Marketing + documentation | Commands + conventions |
| What the project IS | What to DO with it |
| Installation once | Daily development |

### Migration Strategy

1. **Don't copy README** - Reference it instead: `See @README.md for overview`
2. **Extract commands** - Move Quick Start / Development sections
3. **Add operational context** - What README doesn't cover:
   - How to check if services are running
   - Common gotchas and workarounds
   - Team conventions not in README

### Example

**README.md:**

    # MyProject

    MyProject is a revolutionary platform for...

    ## Installation

    1. Clone the repository
    2. Run npm install
    3. Copy .env.example to .env
    4. Run npm start

    ## Features

    - Feature A
    - Feature B

**CLAUDE.md:**

    ## Project Summary

    Platform for X. See @README.md for full overview.

    ## Quick Start

        make setup     # Install deps + copy .env
        make dev       # Start with hot-reload on :3000
        make test      # Run test suite

    ## Development

    - Check server running: lsof -i :3000
    - Logs: make logs or tail -f logs/app.log
    - Hot-reload enabled; no restart needed for code changes

    ## Gotchas

    - Port 3000 must be free; server fails silently if occupied
    - Requires Node 18+ (Node 16 causes test failures)

---

## From Cursor Rules / .cursorrules

Cursor rules and CLAUDE.md have similar purposes but different formats.

### Key Differences

| .cursorrules | CLAUDE.md |
|--------------|-----------|
| JSON/YAML format | Markdown format |
| Cursor-specific | Claude Code specific |
| Often code conventions | Broader project context |

### Migration Steps

1. **Convert format** - Rewrite rules as markdown sections
2. **Expand scope** - Add operational commands, not just conventions
3. **Split if needed** - Code conventions might belong in subdirectory CLAUDE.md

### Example

**.cursorrules:**

    {
      "rules": [
        "Use TypeScript strict mode",
        "Prefer functional components",
        "Use 2-space indentation",
        "Max line length 100 chars"
      ]
    }

**CLAUDE.md:**

    ## Code Conventions

    - TypeScript strict mode enabled (tsconfig.json)
    - Functional components only (no class components)
    - 2-space indentation
    - Max line length: 100 chars

    These are enforced by ESLint. Run make lint to check.

---

## From Copilot Instructions

GitHub Copilot instructions are typically shorter and code-focused.

### Expanding for Claude

Claude benefits from more operational context than Copilot instructions typically provide:

1. **Keep the conventions** - They're still useful
2. **Add commands** - How to run, test, build
3. **Add workflow** - Git conventions, CI/CD info
4. **Add gotchas** - Known issues and workarounds

---

## From Internal Wiki / Docs

If your team has internal documentation, CLAUDE.md should complement, not duplicate it.

### Strategy

1. **Link to wiki** - For architecture details, see [internal wiki link]
2. **Extract essentials** - Daily commands and conventions
3. **Add what's missing** - Gotchas, workarounds, tribal knowledge

### What to Include vs Link

| Include in CLAUDE.md | Link to Docs |
|---------------------|--------------|
| Daily commands | Architecture diagrams |
| Common gotchas | Design decisions |
| Team conventions | Historical context |
| Environment setup | Full API reference |

---

## Splitting a Large CLAUDE.md

If your CLAUDE.md has grown too large (500+ lines), split it:

### Before

    project/
    └── CLAUDE.md (800 lines covering everything)

### After

    project/
    ├── CLAUDE.md                    # Core (150 lines)
    ├── src/
    │   └── api/
    │       └── CLAUDE.md            # API conventions
    ├── tests/
    │   └── CLAUDE.md                # Testing patterns
    └── .claude/
        └── rules/
            ├── security.md          # Security requirements
            └── performance.md       # Performance guidelines

### Split Criteria

Move to subdirectory CLAUDE.md when content:
- Only applies to that directory
- Is rarely needed in other contexts
- Would benefit from on-demand loading

Move to .claude/rules/ when content:
- Applies project-wide but is specialized
- Is a distinct concern (security, performance, accessibility)
- Benefits from modular organization

