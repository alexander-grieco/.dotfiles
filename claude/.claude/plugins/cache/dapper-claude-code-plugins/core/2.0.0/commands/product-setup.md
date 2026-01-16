---
name: product-setup
description: Automated development environment setup for Dapper Labs products (NBA, NFL, Disney, Peak Money, Atlas). Use when onboarding to a product or setting up new development environment.
---

# Product Setup Command

Automated development environment setup for Dapper Labs products with repository discovery, dependency installation, and environment configuration.

## Usage

Run the following command within Claude Code:

```
/product-setup --product <product-slug>
```

### Supported Products

**Supported Products**: Dynamically discovered from Dapper Labs organization

Products are discovered at runtime by querying F4 MCP for active products in the Dapper Labs portfolio.

## What This Does

This command automates the complete development environment setup for a product by:

1. **Discovering Product Repositories** - Queries GitHub MCP to find all product-related repositories
2. **Cloning Required Repositories** - Clones app, api, infrastructure, and qa repositories
3. **Running Domain Discovery** - Analyzes codebase structure and architecture
4. **Installing Dependencies** - Installs all required dependencies across repositories
5. **Configuring Local Environment** - Sets up environment variables and local configurations
6. **Running Health Checks** - Validates the setup with health check commands
7. **Generating Setup Guide** - Creates a personalized setup guide with next steps

## Command Workflow

### Step 1: Discover Active Products (Execute First)

Query F4 MCP to discover all active products in the Dapper Labs organization.

**F4 MCP Product Discovery Query:**
```javascript
execute_workflow({
  workflow: "MCP - F4" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "List all active Dapper Labs products with their official names and slugs"
      }
    }
  }
})
```

**Product Discovery Output:**
- List of active product names and slugs
- Product metadata (description, status, teams)
- Validation of user-provided product slug against discovered products

**Exit conditions:**
- Product slug not in discovered list → Show discovered products and exit
- F4 MCP unavailable → Fall back to common products (nba, nfl, disney, peak-money, atlas) with warning
- Product exists but is archived/inactive → Report status and ask for confirmation

### Step 2: Discover Product Repositories via GitHub MCP (Per Product)

Query GitHub MCP to discover ALL repositories for the selected product. DO NOT assume naming patterns.

**DISCOVERY STEP 2A: Initial Repository Search**
```javascript
execute_workflow({
  workflow: "MCP - GitHub" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "List ALL repositories in dapperlabs and dapperlabs-platform organizations containing '{product}' in name, description, or topics"
      }
    }
  }
})
```

**DISCOVERY STEP 2B: Categorize Repositories by Purpose**

For each discovered repository:
1. Detect purpose from repository metadata:
   - **App/Frontend**: Check for package.json with "react", "next", "vue", or mobile indicators (Podfile, build.gradle)
   - **API/Backend**: Check for main.go, go.mod, API frameworks (express, fastify, gin, echo)
   - **Infrastructure**: Check for terraform/, .tf files, kubernetes/, helm/
   - **QA/Testing**: Check for test/, e2e/, playwright.config, cypress.config, or "qa" in name
   - **Other**: Document purpose if identifiable, include in discovery report

2. DO NOT assume repository naming patterns like "{product}-app" or "{product}-api"
3. Discover actual organization (dapperlabs vs dapperlabs-platform) per repository
4. Handle edge cases: monorepos, multiple apps, shared infrastructure

**Repository Categorization Algorithm:**
```bash
# For each repository discovered:
# 1. Clone or fetch repository metadata
# 2. Detect purpose based on file patterns and package manager files
# 3. Categorize and report

if [ -f "package.json" ] && grep -q "react\|next\|vue" package.json; then
  CATEGORY="app"
elif [ -f "Podfile" ] || [ -f "build.gradle" ]; then
  CATEGORY="mobile"
elif [ -f "go.mod" ] || [ -f "main.go" ]; then
  CATEGORY="api"
elif [ -d "terraform" ] || ls *.tf 2>/dev/null; then
  CATEGORY="infrastructure"
elif [ -d "test" ] || [ -d "e2e" ] || grep -q "qa" <<< "$REPO_NAME"; then
  CATEGORY="qa"
else
  CATEGORY="other"
fi
```

**Discovery Report Output:**
```
Product: {product-name}
Discovered Repositories:
  App/Frontend:
    - {org}/{repo-name} (detected: React/Next.js)
  API/Backend:
    - {org}/{repo-name} (detected: Go API)
    - {org}/{repo-name-2} (detected: Node.js API)
  Infrastructure:
    - {org}/{repo-name} (detected: Terraform)
  QA/Testing:
    - {org}/{repo-name} (detected: Playwright tests)
  Other:
    - {org}/{repo-name} (purpose: documentation)
    - {org}/{repo-name-2} (purpose: scripts)

Total: N repositories discovered
```

**Note:** Repository discovery is fully dynamic. Do NOT assume patterns. Discover actual repos and categorize by detected purpose.

### Step 3: Clone Required Repositories

Clone all discovered repositories to a local workspace.

**Directory Structure:**
```
~/dapper-labs/<product>/
├── <product>-app/
├── <product>-api/
├── <product>-infrastructure/
└── <product>-qa/
```

**Clone Commands (Dynamic Based on Discovery):**
```bash
mkdir -p ~/dapper-labs/<product>
cd ~/dapper-labs/<product>

# Clone each discovered repository using actual org and repo name
# Example (actual values from discovery):
git clone https://github.com/{discovered-org}/{discovered-repo-name}.git

# DO NOT assume:
# - Repository names follow a pattern
# - All repos are in "dapperlabs" org
# - Standard repo count (may be 2, 5, 10+ repos per product)
```

**Dynamic Cloning Strategy:**
1. For each repository discovered in Step 2, clone using actual org/repo from discovery
2. Preserve discovered categorization in directory structure
3. Report any repositories that fail to clone (continue with successful clones)

**Error Handling:**
- Repository not found → Report specific repo, verify discovery results, continue with available repos
- Clone failure → Report error with repo details, suggest authentication check
- Permission denied → Report specific org/repo, suggest verifying team membership for that org
- Mixed org access → Some repos in dapperlabs, some in dapperlabs-platform (handle gracefully)

### Step 4: Run Domain Discovery Skill

Execute the domain-discovery skill for each repository to understand architecture and patterns.

**Skill Invocation:**
```
/skill domain-discovery --product <product> --component app
/skill domain-discovery --product <product> --component api
/skill domain-discovery --product <product> --component infrastructure
/skill domain-discovery --product <product> --component qa
```

**Domain Discovery Output:**
- Repository structure and key files
- Technology stack identification
- Dependencies and integrations mapping
- Architecture patterns detected
- Recent development activity summary

### Step 5: Install Dependencies (Dynamic Language Detection)

Install dependencies for each repository based on DETECTED technology stack. DO NOT assume languages or package managers.

**CRITICAL: Language Detection First**

For each cloned repository:
1. Detect primary language and frameworks
2. Identify package manager from lock files
3. Discover build commands from package.json, Makefile, or README
4. Install dependencies using discovered tools

**Language & Framework Detection Algorithm:**
```bash
# For each repository:
REPO_PATH="~/dapper-labs/<product>/{discovered-repo-name}"
cd "$REPO_PATH"

# Detect JavaScript/TypeScript
if [ -f "package.json" ]; then
  LANG="javascript/typescript"

  # Detect package manager from lock files
  if [ -f "package-lock.json" ]; then
    PKG_MGR="npm"
  elif [ -f "yarn.lock" ]; then
    PKG_MGR="yarn"
  elif [ -f "pnpm-lock.yaml" ]; then
    PKG_MGR="pnpm"
  elif [ -f "bun.lockb" ]; then
    PKG_MGR="bun"
  else
    PKG_MGR="npm"  # fallback
  fi

  # Install dependencies
  $PKG_MGR install
fi

# Detect Go
if [ -f "go.mod" ]; then
  LANG="go"
  go mod download
fi

# Detect Python
if [ -f "requirements.txt" ] || [ -f "Pipfile" ] || [ -f "pyproject.toml" ]; then
  LANG="python"

  if [ -f "Pipfile" ]; then
    pipenv install
  elif [ -f "pyproject.toml" ] && grep -q "poetry" pyproject.toml; then
    poetry install
  elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
  fi
fi

# Detect Rust
if [ -f "Cargo.toml" ]; then
  LANG="rust"
  cargo fetch
fi

# Detect Ruby
if [ -f "Gemfile" ]; then
  LANG="ruby"
  bundle install
fi

# Detect Terraform
if [ -d "terraform" ] || ls *.tf 2>/dev/null | grep -q .; then
  LANG="terraform"

  if [ -d "terraform" ]; then
    cd terraform
  fi

  terraform init -backend=false  # Local only, no remote state
fi

# Detect Swift (iOS)
if [ -f "Podfile" ]; then
  LANG="swift"
  pod install
fi

# Detect Kotlin/Java (Android)
if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  LANG="kotlin/java"
  ./gradlew dependencies || gradle dependencies
fi

# If no package manager detected
if [ -z "$LANG" ]; then
  echo "No recognized package manager found in $REPO_PATH"
  echo "Manual dependency installation may be required"
fi
```

**Build Command Discovery:**

After detecting package manager, discover build commands:
```bash
# For JavaScript/TypeScript projects:
if [ -f "package.json" ]; then
  # Extract available scripts
  BUILD_CMD=$(jq -r '.scripts.build // empty' package.json)
  TEST_CMD=$(jq -r '.scripts.test // empty' package.json)
  DEV_CMD=$(jq -r '.scripts.dev // empty' package.json)

  # Report discovered commands
  echo "Discovered scripts: build=$BUILD_CMD, test=$TEST_CMD, dev=$DEV_CMD"
fi

# For Go projects:
if [ -f "Makefile" ]; then
  # Extract make targets
  MAKE_TARGETS=$(make -qp | grep "^[^#.].*:" | cut -d: -f1)
  echo "Discovered Makefile targets: $MAKE_TARGETS"
fi

# For repositories with README build instructions:
if [ -f "README.md" ]; then
  # Extract commands from ## Build, ## Development, or ## Setup sections
  # (This is a hint for human review, not automated extraction)
  echo "Check README.md for additional build instructions"
fi
```

**Dependency Installation Report:**
- List of all installed dependencies per repository
- Installation time per repository
- Any warnings or errors encountered
- Total dependency count and disk usage

### Step 6: Configure Local Environment

Set up environment variables and local configuration files.

**Query F4 MCP for Product Configuration:**
```javascript
execute_workflow({
  workflow: "MCP - F4" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "Show configuration requirements and environment setup for <product> product"
      }
    }
  }
})
```

**Environment Setup:**

For each repository with `.env.example` or `.env.template`:
```bash
# Copy environment template
cp .env.example .env

# Prompt for required values or use defaults
# Report which variables need to be configured manually
```

**Configuration Validation:**
- Check for `.env.example` files
- Identify required environment variables
- Report missing configurations
- Suggest default values where applicable
- **NEVER commit .env files** - verify .gitignore includes .env

**Security Checks:**
- Verify `.env` is in `.gitignore`
- Check for any hardcoded secrets in configuration files
- Report any security concerns with configuration

### Step 7: Run Health Checks (Dynamic Based on Detected Tech Stack)

Execute health check commands based on the detected technology stack for each repository.

**Health Check Strategy:**

For each repository, run health checks appropriate to the detected language/framework:

**JavaScript/TypeScript Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Discover available scripts from package.json
BUILD_SCRIPT=$(jq -r '.scripts.build // empty' package.json)
TYPECHECK_SCRIPT=$(jq -r '.scripts.typecheck // empty' package.json)
LINT_SCRIPT=$(jq -r '.scripts.lint // empty' package.json)
TEST_SCRIPT=$(jq -r '.scripts.test // empty' package.json)

# Run discovered scripts (skip if not defined)
if [ -n "$BUILD_SCRIPT" ]; then
  $PKG_MGR run build
fi

if [ -n "$TYPECHECK_SCRIPT" ]; then
  $PKG_MGR run typecheck
elif [ -f "tsconfig.json" ]; then
  # Fallback: try direct tsc if TypeScript detected but no typecheck script
  npx tsc --noEmit
fi

if [ -n "$LINT_SCRIPT" ]; then
  $PKG_MGR run lint
fi

# DO NOT run tests in health check (may require env vars or services)
```

**Go Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Build check (discovers main packages automatically)
go build -o /dev/null ./...

# Test compilation check (don't run tests, just verify they compile)
go test -run=^$ ./...

# Linting (try golangci-lint first, fallback to go vet)
if command -v golangci-lint &> /dev/null; then
  golangci-lint run
else
  go vet ./...
fi
```

**Python Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Type checking (if mypy configured)
if [ -f "mypy.ini" ] || grep -q mypy pyproject.toml 2>/dev/null; then
  mypy .
fi

# Linting (discover which linter is configured)
if [ -f ".flake8" ] || grep -q flake8 pyproject.toml 2>/dev/null; then
  flake8 .
elif [ -f "pyproject.toml" ] && grep -q ruff pyproject.toml; then
  ruff check .
fi
```

**Terraform Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Change to terraform directory if it exists
if [ -d "terraform" ]; then
  cd terraform
fi

# Terraform validation (local only, no remote state)
terraform validate

# Terraform formatting check
terraform fmt -check -recursive
```

**Swift (iOS) Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Discover workspace or project file
WORKSPACE=$(ls *.xcworkspace 2>/dev/null | head -1)
PROJECT=$(ls *.xcodeproj 2>/dev/null | head -1)

if [ -n "$WORKSPACE" ]; then
  xcodebuild -workspace "$WORKSPACE" -scheme <discover-scheme> -sdk iphonesimulator build
elif [ -n "$PROJECT" ]; then
  xcodebuild -project "$PROJECT" -scheme <discover-scheme> -sdk iphonesimulator build
fi
```

**Kotlin/Java (Android) Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Build check
./gradlew assembleDebug || gradle assembleDebug

# Lint check
./gradlew lint || gradle lint
```

**Rust Repositories:**
```bash
cd ~/dapper-labs/<product>/{discovered-repo-name}

# Build check
cargo build

# Lint check
cargo clippy
```

**Health Check Execution Rules:**
1. Detect language/framework first (from Step 5)
2. Run only checks applicable to detected stack
3. Skip tests that require running services or environment variables
4. Continue on failures (report but don't block)
5. Report all results in health check summary

**Health Check Report:**
- ✅ Passed health checks
- ❌ Failed health checks with error details
- ⚠️ Warnings or partial failures
- Suggestions for fixing failures

### Step 8: Generate Setup Guide

Create a personalized setup guide with next steps and product-specific information.

**Setup Guide Contents:**

```markdown
# <Product Name> Development Environment Setup

## Setup Summary
- **Product:** <product-name>
- **Setup Date:** <timestamp>
- **Repositories Cloned:** <count>
- **Dependencies Installed:** <count>
- **Health Checks:** <passed>/<total>

## Repository Locations
- App: ~/dapper-labs/<product>/<product>-app
- API: ~/dapper-labs/<product>/<product>-api
- Infrastructure: ~/dapper-labs/<product>/<product>-infrastructure
- QA: ~/dapper-labs/<product>/<product>-qa

## Technology Stack
- Frontend: <detected-stack>
- Backend: <detected-stack>
- Infrastructure: <detected-stack>
- Testing: <detected-stack>

## Required Manual Configuration
<List of environment variables and configurations that need manual setup>

## Next Steps
1. Configure environment variables in .env files
2. Start development servers:
   - App: cd ~/dapper-labs/<product>/<product>-app && npm run dev
   - API: cd ~/dapper-labs/<product>/<product>-api && go run main.go
3. Run tests:
   - Unit tests: <commands>
   - Integration tests: <commands>
4. Access local services:
   - Frontend: http://localhost:<port>
   - API: http://localhost:<port>

## Product Resources
- Product documentation: <F4 MCP links>
- Architecture diagrams: <links-if-found>
- Team contacts: <from-F4-or-README>
- Slack channels: <from-F4>

## Common Commands
<Product-specific development commands discovered during domain analysis>

## Troubleshooting
<Common issues and solutions discovered during setup>
```

**Save Setup Guide:**
```bash
# Save to product root directory
echo "<setup-guide-content>" > ~/dapper-labs/<product>/SETUP_GUIDE.md
```

**Display Summary:**
Report the setup completion status and location of the setup guide to the user.

## Integration Requirements

### n8n MCP Workflows

**GitHub MCP (Workflow: "MCP - GitHub" - discover ID at runtime)**
- Repository discovery and listing
- Repository structure analysis
- Recent commit and PR activity

**F4 MCP (Workflow: "MCP - F4" - discover ID at runtime)**
- Product documentation and information
- Configuration requirements
- Team and resource information

### Skills

**domain-discovery**
- Repository structure analysis
- Technology stack detection
- Architecture pattern identification
- Dependency mapping

## Error Handling

### MCP Unavailability
If GitHub MCP is unavailable:
- Fall back to direct repository name patterns
- Attempt cloning based on standard naming convention
- Warn user about reduced discovery capabilities

If F4 MCP is unavailable:
- Skip product-specific configuration discovery
- Rely on `.env.example` files and README documentation
- Report reduced configuration assistance

### Repository Access Issues
- **Authentication required:** Prompt user to configure GitHub credentials
- **Repository not found:** Report missing repositories, continue with available ones
- **Permission denied:** Report access issue, suggest verifying team membership

### Dependency Installation Failures
- Report which dependencies failed
- Suggest manual installation commands
- Continue with remaining repositories
- Include failures in final report

### Health Check Failures
- Report failed checks with error details
- Continue with remaining checks
- Provide troubleshooting guidance in setup guide
- Don't block setup completion on health check failures

## Prerequisites

Before running this command:

1. **MCP Server Installed:** Run `/n8n-mcp-setup` if not already installed
2. **MCP Authenticated:** Run `/mcp` in Claude Code to authenticate
3. **Git Configured:** Ensure git credentials are configured for GitHub access
4. **Disk Space:** Ensure sufficient disk space for repositories (~5-10GB per product)
5. **Tools Installed:**
   - Git
   - Node.js (for frontend/API repos)
   - Go (for API repos)
   - Terraform (for infrastructure repos)

## Usage Examples

### Setup Product Development Environment (Generic)
```
/product-setup --product <product-slug>
```

**Note:** Product slugs are dynamically discovered from F4 MCP. Common examples include:
- `nba` - NBA Top Shot
- `nfl` - NFL All Day
- `disney` - Disney Pinnacle
- `peak-money` - Peak Money
- `atlas` - Atlas

For the complete list of active products, run the command without a product slug or with an invalid slug to see all available products.

## Expected Outcomes

**Success Scenario:**
- All repositories cloned successfully
- Dependencies installed for all repositories
- Environment configurations identified
- Health checks passing or with minor warnings
- Setup guide generated with clear next steps

**Partial Success Scenario:**
- Some repositories cloned (report missing ones)
- Most dependencies installed (report failures)
- Some health checks passing (provide troubleshooting)
- Setup guide generated with known issues documented

**Failure Scenario:**
- Report clear error message
- Provide manual setup instructions
- Suggest checking prerequisites
- Offer alternative setup approaches

## Performance Expectations

**Typical Setup Times:**
- Repository discovery: 10-20 seconds
- Repository cloning: 1-3 minutes
- Domain discovery: 30-60 seconds
- Dependency installation: 3-10 minutes
- Health checks: 1-3 minutes
- **Total: 6-17 minutes**

**Large Product Considerations:**
- Some products may have larger repositories
- Dependency installation may take longer on slow networks
- Health checks may be skipped for faster setup if requested

## Post-Setup Validation

After running `/product-setup`, verify:

1. ✅ All expected repositories are cloned
2. ✅ Dependencies are installed (check node_modules/, vendor/, etc.)
3. ✅ Environment files are present (.env created from .env.example)
4. ✅ Setup guide is generated (SETUP_GUIDE.md exists)
5. ✅ Basic health checks pass or issues are documented

## Related Commands

- `/n8n-mcp-setup` - Install and configure n8n MCP server (prerequisite)
- `/cross-repo-search` - Search across product repositories

## Related Skills

- `domain-discovery` - Analyze repository structure and architecture
- `architecture-review` - Review product architecture patterns

## Best Practices

✅ **Run once per product** - Sets up complete development environment
✅ **Use before starting feature work** - Ensures consistent environment
✅ **Review setup guide** - Contains product-specific important information
✅ **Update .env files** - Configure required environment variables before running services

❌ **Don't skip MCP setup** - Required for repository discovery
❌ **Don't ignore health check failures** - May indicate missing prerequisites
❌ **Don't commit .env files** - Contains sensitive configuration data

---

**Quick Start:** Run `/product-setup --product <nba|nfl|disney|peak-money|atlas>` to setup a complete development environment in under 20 minutes.
