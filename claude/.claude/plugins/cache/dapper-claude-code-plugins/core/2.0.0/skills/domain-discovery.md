---
name: domain-discovery
description: Discover and understand codebase structure, architecture, and patterns using GitHub MCP. Use when starting work on unfamiliar product or component.
model: inherit
---

# Domain Discovery Skill

## Purpose

Discover and understand codebase structure, architecture patterns, and technical stack for unfamiliar products or components. Provides actionable intelligence for developers starting work on new repositories through systematic GitHub MCP-based discovery.

## When to Use

**Mandatory Usage**:
- **REQUIRED** when starting work on unfamiliar product or component
- When joining a new team or project
- As part of `/product-setup` command (Step 4: Run Domain Discovery)
- Before planning major architectural changes

**Recommended Usage**:
- Quarterly architecture reviews for existing products
- When onboarding new developers
- Before scoping large features or refactors
- When evaluating technical debt or modernization efforts

## Prerequisites

- n8n GitHub MCP access (Workflow: "MCP - GitHub" (discover ID at runtime))
- Repository access to `dapperlabs` and `dapperlabs-platform` organizations
- Authentication via `/mcp` command if accessing private repositories

## Usage

```
/skill domain-discovery --product <product-slug> --component <app|api|infrastructure|qa|all>
```

**Parameters**:
- `--product <product-slug>`: Required. Product identifier (e.g., nba, nfl, disney, peak-money, atlas)
- `--component <type>`: Required. Component type to discover (app, api, infrastructure, qa, all)

**Examples**:
```
/skill domain-discovery --product nba --component api
/skill domain-discovery --product disney --component all
/skill domain-discovery --product peak-money --component infrastructure
```

---

## Mandatory 6-Step Workflow

### Step 1: Repository Discovery

**Goal**: Identify all repositories related to the product and component type

**Process**:
1. Query GitHub MCP for all repositories in dapperlabs and dapperlabs-platform organizations
2. Filter repositories by product name (in repository name or description)
3. Apply component filter if not "all" (app, api, infrastructure, qa)
4. Validate repositories are active (not archived)
5. Sort by last update date (most recently active first)

**MCP Query**: List all repositories with metadata (name, full_name, description, language, topics, updated_at, default_branch, html_url)

**Pass Criteria**:
- ✅ At least 1 repository found matching product filter
- ✅ Repository metadata retrieved
- ✅ Active repositories identified

**Failure Conditions** (blocks discovery):
- ❌ No repositories found matching product name
- ❌ GitHub MCP unavailable and no cached data
- ❌ Authentication failure (requires `/mcp` command)

---

### Step 2: Repository Classification

**Goal**: Categorize repositories by component type and detect technology stack

**Process**:
1. For each repository, detect component type using file patterns
2. Identify primary programming language(s)
3. Detect package manager and build tools
4. Classify repository purpose and subtype
5. Extract key file paths

**Component Detection Patterns**:

**App Repository**:
- `package.json` + (React|Next.js|Vue|Angular|React Native|Ionic) OR
- `Podfile`/`Package.swift` (iOS) OR
- `build.gradle` with Android dependencies (Android)

**API Repository**:
- `go.mod` + web frameworks (Gin|Echo|Fiber) OR
- `package.json` + (Express|Fastify|NestJS|Koa) OR
- `requirements.txt` + (FastAPI|Django|Flask) OR
- `pom.xml` + Spring Boot OR
- `Cargo.toml` + (Actix|Rocket)

**Infrastructure Repository**:
- `*.tf` files (Terraform) OR
- `k8s/*.yaml` (Kubernetes manifests) OR
- `helm/` directory (Helm charts) OR
- `docker-compose.yml`

**QA Repository**:
- `test/`|`tests/`|`e2e/` directories AND
- Testing frameworks (Playwright|Cypress|Selenium|pytest|unittest)

**Detection Method**: Query repository file tree via GitHub MCP, check for indicator files, parse contents for framework patterns.

**Pass Criteria**:
- ✅ Component type identified for each repository
- ✅ Primary language(s) detected
- ✅ Package manager identified (if applicable)

**Failure Conditions** (continues with warnings):
- ⚠️ Component type unclear → Classify as "other"
- ⚠️ Language detection failed → Mark as "unknown"

---

### Step 3: File Structure Analysis

**Goal**: Analyze repository file structure and identify key files

**Process**:
1. Query GitHub MCP for repository file tree (max depth: 5)
2. Identify key configuration files
3. Locate documentation files (README.md, CONTRIBUTING.md, docs/)
4. Find dependency manifests
5. Detect testing directories and frameworks

**Key Files to Identify**:

**Required Files**:
- `README.md`, `CONTRIBUTING.md`, `LICENSE`

**Configuration Files**:
- `package.json`, `tsconfig.json`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`
- `Makefile`, `Dockerfile`, `.github/workflows/*.yml`

**Infrastructure Files**:
- `*.tf`, `terraform.tfvars`, `k8s/*.yaml`, `docker-compose.yml`

**Blockchain Files**:
- `flow.json`, `cadence/**/*.cdc`

**Pass Criteria**:
- ✅ File tree retrieved for each repository
- ✅ Key configuration files identified
- ✅ Documentation files located

**Failure Conditions** (continues with warnings):
- ⚠️ File tree unavailable → Use cached data or proceed without
- ⚠️ Missing README.md → Flag as documentation gap

---

### Step 4: Documentation Extraction

**Goal**: Extract and analyze repository documentation for setup instructions and architecture patterns

**Process**:
1. Retrieve README.md content from each repository via GitHub MCP
2. Parse README sections (Architecture, Installation, Development, Testing, Deployment)
3. Extract setup instructions and build commands
4. Identify dependencies and prerequisites
5. Locate additional documentation resources

**Documentation Analysis**:
- Extract installation commands from Installation/Getting Started/Setup sections
- Extract development commands (npm run|yarn|make|go run)
- Capture architecture information and system design notes
- Identify common issues or troubleshooting steps

**Pass Criteria**:
- ✅ README.md content retrieved for each repository
- ✅ Setup/installation instructions extracted (if present)
- ✅ Development commands identified (if documented)

**Failure Conditions** (continues with warnings):
- ⚠️ README.md missing → Flag as critical documentation gap
- ⚠️ No installation instructions → Manual setup may be complex
- ⚠️ No architecture documentation → Discovery-based analysis only

---

### Step 5: Recent Activity Analysis

**Goal**: Analyze recent development activity and patterns to understand codebase health

**Process**:
1. Query GitHub MCP for recent commits (last 90 days, max 50 commits)
2. Analyze commit messages for patterns (features, bugfixes, refactors, migrations)
3. Review recent pull requests (last 30 PRs, open and closed)
4. Identify active contributors
5. Detect migration or upgrade activities

**Activity Metrics to Calculate**:
- Commits in last 90 days
- Unique contributors
- Open pull requests
- Merged pull requests in last 90 days
- Last commit date
- Development pattern keywords (migration|upgrade|deprecated|breaking|refactor)

**Pass Criteria**:
- ✅ Recent commit history retrieved
- ✅ Activity metrics calculated
- ✅ Development patterns identified
- ✅ Active contributors counted

**Failure Conditions** (continues with warnings):
- ⚠️ No recent activity (> 90 days) → May be inactive/deprecated
- ⚠️ Activity analysis failed → Use cached data or skip

---

### Step 6: Discovery Report Generation

**Goal**: Generate comprehensive discovery report with architecture summary and actionable recommendations

**Report Sections**:

#### 1. Executive Summary
- Product name and component type
- Discovery date and duration
- Total repositories analyzed
- Key findings and highlights
- Quick start recommendations

#### 2. Repository Inventory
Per repository:
- Name, organization, and URL
- Component type and subtype
- Primary language and tech stack
- Key files and structure
- Recent activity metrics
- Setup complexity assessment

#### 3. Architecture Overview
- Component breakdown (app/api/infrastructure/qa repositories)
- Integration patterns between components (REST|GraphQL|gRPC|Message Queue|SDK)
- Deployment model (platform, orchestration, IaC tool, CI/CD)
- Blockchain integration (Flow/Cadence if applicable)

#### 4. Technology Stack
- Languages used across repositories (with percentages)
- Frameworks and libraries (categorized: web|mobile|backend|testing|infrastructure)
- Databases and data stores (PostgreSQL|MySQL|MongoDB|Redis|Firestore|BigQuery)
- Build tools and package managers
- Testing frameworks

#### 5. Development Patterns
- Monorepo vs multi-repo structure
- Code organization patterns
- Testing strategy and coverage
- Documentation quality (excellent|good|fair|poor|none)
- CI/CD maturity (advanced|moderate|basic|none)

#### 6. Getting Started
- Prerequisites and setup requirements
- Repository cloning order
- Installation commands per repository
- Development environment setup
- Health check procedures
- Common issues and troubleshooting

#### 7. Recommendations
- **Priority Repositories**: Which repositories to start with (critical|high|medium|low priority)
- **Learning Path**: Step-by-step approach to understanding the codebase
- **Potential Issues**: Identified risks or gaps with severity (critical|high|medium|low|info)
- **Next Steps**: Suggested actions for onboarding

**Output Formats**:
- **Markdown**: `discovery-{product}-{component}-{YYYY-MM-DD}.md` (human-readable)
- **JSON**: `discovery-{product}-{component}-{YYYY-MM-DD}.json` (machine-readable)

---

## Language Detection

**Primary Indicators**:
- **TypeScript/JavaScript**: `package.json` + (`tsconfig.json` OR `.ts`/`.js` files)
- **Go**: `go.mod` + `*.go` files
- **Python**: (`requirements.txt` OR `pyproject.toml` OR `setup.py`) + `*.py` files
- **Rust**: `Cargo.toml` + `*.rs` files
- **Cadence**: `flow.json` + `*.cdc` files
- **Swift**: (`Podfile` OR `Package.swift`) + `*.swift` files
- **Kotlin/Java**: (`build.gradle` OR `pom.xml`) + (`*.kt` OR `*.java` files)

**Package Manager Priority**:
- **Node.js**: bun > pnpm > yarn > npm (detect via lock files: `bun.lockb` > `pnpm-lock.yaml` > `yarn.lock` > `package-lock.json`)
- **Python**: poetry > pipenv > pip (detect via `poetry.lock` > `Pipfile` > `requirements.txt`)
- **Go**: go modules (standard)
- **Rust**: cargo (standard)

---

## Discovery Queries

Query GitHub MCP (Workflow: "MCP - GitHub" (discover ID at runtime)) for:

1. **Repository List** - All repos in dapperlabs/dapperlabs-platform orgs, filter by {product}, exclude archived
2. **File Tree** - Repository structure for each repo (max depth 5), identify key files
3. **README Content** - Extract raw markdown, parse Architecture/Installation/Development sections
4. **Recent Commits** - Last 50 commits, 90-day window, analyze patterns
5. **Recent PRs** - Last 30 PRs (open and closed), 90-day window, activity analysis
6. **Dependencies** - Parse dependency files (package.json, go.mod, requirements.txt, Cargo.toml, pom.xml, build.gradle, Gemfile, Podfile, Package.swift)

**Execution**: Parallel where possible (max 5 concurrent queries)
**Caching**: 6-12hr TTL for most queries, use 24-48hr fallback if fresh data unavailable
**Failure Handling**:
- BLOCK on Query 1 (repository discovery) - cannot proceed without repos
- WARN on Queries 2-6 - continue with partial data, use cache as fallback
- Retry with exponential backoff (3 attempts: 2s, 4s, 8s)

---

## Error Handling

### GitHub MCP Unavailable
- **Check**: Run `claude mcp list | grep n8n` to verify installation
- **Resolution**: Run `/n8n-mcp-setup` if not installed, `/mcp` if not authenticated
- **Fallback**: Use cached data if available (< 24hr old)
- **Block Condition**: Cannot proceed without repository discovery data

### Repository Not Found
- **Verify**: Check product name spelling and case sensitivity
- **Resolution**: Try alternative product names or check GitHub directly
- **Continue**: Skip repository and proceed with others found

### Rate Limit Exceeded
- **Action**: Wait for GitHub API rate limit reset (displayed in error message)
- **Fallback**: Use cached data if available
- **Retry**: Automatic retry after rate limit reset + 5 seconds

### Authentication Failure
- **Resolution**: Run `/mcp` command in Claude Code (not terminal)
- **Block Condition**: Cannot access private repositories without authentication

### Timeout Errors
- **Retry**: Exponential backoff (3 attempts)
- **Fallback**: Use cached data if available (< 24hr)
- **Continue**: Generate report with partial data and warnings

---

## Performance Characteristics

**Typical Execution Time** (with parallelization):
- Single repository: 60-95 seconds
- 5 repositories: 90-120 seconds
- 10+ repositories: 120-180 seconds

**Optimization Strategies**:
- Parallel MCP queries (max 5 concurrent)
- Aggressive caching (6-12 hour TTL)
- Batch repository processing
- Skip optional analysis if timeout approaches

---

## Integration Points

**Used By**:
- `/product-setup` command (Step 4: Domain Discovery)
- `architecture-review` skill (foundation for comprehensive reviews)
- Product-specific agents for context building

**Depends On**:
- n8n GitHub MCP (Workflow: "MCP - GitHub" (discover ID at runtime))
- Active product in GitHub organizations (dapperlabs, dapperlabs-platform)

---

## Best Practices

**Discovery Execution**:
- ✅ Run discovery before starting development on unfamiliar repositories
- ✅ Use `--component all` for comprehensive product understanding
- ✅ Review generated report before making architectural decisions
- ✅ Share discovery reports with team members for onboarding
- ✅ Re-run quarterly to track architectural evolution
- ❌ Don't skip discovery when joining existing projects
- ❌ Don't assume repository structure or tech stack
- ❌ Don't ignore warnings about missing documentation or inactive repos

**Report Usage**:
- ✅ Save discovery reports in product documentation directory
- ✅ Version control reports to track changes over time
- ✅ Update reports after major architectural changes
- ✅ Reference reports during sprint planning and estimation
- ❌ Don't treat as one-time artifact (keep updated)
- ❌ Don't ignore potential issues flagged in report
