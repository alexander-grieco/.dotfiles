# CLAUDE.md Anti-Patterns

Common mistakes that reduce effectiveness of CLAUDE.md files.

---

## 1. Vague Instructions

**Bad:**

    Write clean, maintainable code following best practices.

**Good:**

    - Use 2-space indentation for TypeScript
    - Max function length: 50 lines
    - Prefer composition over inheritance
    - All public functions require JSDoc comments

**Why it matters:** Vague instructions give Claude no actionable guidance. Be specific about what "good" means in your codebase.

---

## 2. Information Overload

**Bad:**

    ## API Reference

    ### UserController
    - GET /users - Returns all users with pagination...
    - POST /users - Creates a new user with fields...
    [500 more lines of API docs]

**Good:**

    ## API Documentation

    API reference is in `docs/api/` or run `make docs` to generate.
    Key endpoints: see `src/routes/index.ts` for route definitions.

**Why it matters:** CLAUDE.md is loaded every session. Large files consume tokens and slow responses. Link to docs instead of embedding them.

---

## 3. Outdated Information

**Bad:**

    ## Setup

    Run `npm install` to install dependencies.
    Start server with `node server.js`.

*(When project actually uses pnpm and has a Makefile)*

**Good:**

    ## Setup

    Run `make setup` to install dependencies.
    Start server with `make dev`.

**Why it matters:** Outdated instructions cause Claude to suggest wrong commands, wasting time and breaking trust.

---

## 4. Duplicate of README

**Bad:**

    # My Project

    My Project is an innovative solution for...

    ## Features
    - Feature 1
    - Feature 2

    ## Installation
    ...

**Good:**

    ## Project Summary

    SDK for Flow blockchain wallet integration. See @README.md for full overview.

    ## Quick Start
    [Actionable commands for Claude]

**Why it matters:** README is for humans browsing GitHub. CLAUDE.md is for Claude's operational context. Different purposes need different content.

---

## 5. Secrets and Credentials

**Bad:**

    ## Environment

    Set these variables:
    - API_KEY=sk-abc123def456
    - DATABASE_URL=postgres://admin:password@prod.db.com/main

**Good:**

    ## Environment

    Copy `.env.example` to `.env` and configure:
    - `API_KEY` - Request from #platform-access Slack
    - `DATABASE_URL` - Use local db for dev: `postgres://localhost:5432/dev`

**Why it matters:** CLAUDE.md is often committed to git. Secrets in version control are a security incident waiting to happen.

---

## 6. Everything in Root CLAUDE.md

**Bad:**

    # Root CLAUDE.md (2000 lines)

    ## General Info
    ...
    ## TypeScript Conventions
    ...
    ## API Conventions
    ...
    ## Testing Patterns
    ...
    ## Terraform Standards
    ...
    ## Mobile Development
    ...

**Good:**

    project/
    ├── CLAUDE.md                    # Core project info (200 lines)
    ├── src/api/CLAUDE.md            # API conventions
    ├── tests/CLAUDE.md              # Testing patterns
    └── infrastructure/CLAUDE.md     # Terraform standards

**Why it matters:** Subdirectory CLAUDE.md files are loaded on-demand. Keep root file lean; move specialized content to where it's relevant.

---

## 7. Describing Instead of Instructing

**Bad:**

    The project uses ESLint for linting and Prettier for formatting.
    Tests are written using Jest and run via the test script.

**Good:**

    ## Code Quality

    Before committing:
    1. Run `make lint` to check for issues
    2. Run `make format` to auto-fix formatting
    3. Run `make test` to verify tests pass

    CI will block PRs that fail these checks.

**Why it matters:** Claude needs to know what to DO, not just what exists. Describe actions, not facts.

---

## 8. No Quick Start

**Bad:**

    ## Architecture

    The system follows a hexagonal architecture pattern with ports and adapters...
    [Long architectural explanation]

**Good:**

    ## Quick Start

        make setup    # First time setup
        make dev      # Start development
        make test     # Run tests

    ## Architecture

    For architectural details, see @docs/architecture.md

**Why it matters:** Claude (and engineers) need to be productive immediately. Lead with actionable commands.

---

## 9. Missing Gotchas

**Bad:**

    ## Testing

    Run `make test` to execute tests.

**Good:**

    ## Testing

    Run `make test` to execute tests.

    **Gotchas:**
    - Tests require Docker running (`docker ps` to verify)
    - `auth.spec.ts` is flaky; retry once if it fails
    - Use `make test-unit` for quick feedback

**Why it matters:** Claude will hit the same issues repeatedly without documented gotchas. Save future debugging time.

---

## 10. Hardcoded Paths

**Bad:**

    ## Setup

    Edit `/Users/john/projects/myapp/.env` to configure.
    Logs are at `/var/log/myapp/`.

**Good:**

    ## Setup

    Edit `.env` in project root to configure.
    Logs are at `./logs/` or run `make logs` to tail.

**Why it matters:** Absolute paths break for other users. Use relative paths or environment variables.

---

## Summary Table

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Vague instructions | No actionable guidance | Be specific with examples |
| Information overload | Token waste, slow responses | Link to docs, keep lean |
| Outdated info | Wrong suggestions | Keep updated, review quarterly |
| Duplicate of README | Wrong purpose | Different content for Claude |
| Secrets in file | Security risk | Reference .env.example |
| Everything in root | Always loaded | Use subdirectory CLAUDE.md |
| Describing vs instructing | No actions | Lead with commands |
| No quick start | Slow onboarding | Put commands first |
| Missing gotchas | Repeated debugging | Document known issues |
| Hardcoded paths | Breaks portability | Use relative paths |
