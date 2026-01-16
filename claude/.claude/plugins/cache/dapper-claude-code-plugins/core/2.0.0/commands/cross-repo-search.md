---
name: cross-repo-search
description: Search across 1,085+ Dapper Labs repositories with pattern matching and aggregation. Use when finding implementation patterns, conducting security audits, or analyzing cross-product code.
---

# Cross-Repository Search Command

Search for code patterns, implementations, or specific content across multiple repositories in the Dapper Labs organization.

## Usage

Run the following command within Claude Code:

```
/cross-repo-search --query <pattern> [--product <name>] [--language <lang>] [--repo-filter <pattern>]
```

## Parameters

### Required

- `--query <pattern>`: The search pattern (code, text, or regex)

### Optional

- `--product <name>`: Product identifier (discover available products via F4 MCP query: "List active products")
- `--language <lang>`: Language filter (discover available languages via GitHub MCP query: "Show language statistics for dapperlabs + dapperlabs-platform orgs")
- `--repo-filter <pattern>`: Filter repositories by name pattern (e.g., "*-api", "*-infrastructure")

## What This Does

This command will:

1. Query GitHub MCP to discover relevant repositories
2. Search code across discovered repositories
3. Aggregate and deduplicate results
4. Group findings by patterns and repositories
5. Generate comprehensive findings report

## Examples

### Search Across All Repositories

```
/cross-repo-search --query "WalletConnect"
```

Searches for "WalletConnect" across all repositories in the dapperlabs and dapperlabs-platform organizations (query GitHub MCP for current repository count).

### Search Within Specific Product

```
/cross-repo-search --query "authentication" --product nba
```

Searches for "authentication" only in NBA Top Shot repositories (dynamically discovered via GitHub MCP).

### Search by Language

```
/cross-repo-search --query "func handleTransaction" --language go
```

Searches for the pattern only in Go repositories.

### Search Infrastructure Repositories

```
/cross-repo-search --query "terraform-google-gke" --repo-filter "*-infrastructure"
```

Searches for GKE Terraform modules only in infrastructure repositories.

### Combined Filters

```
/cross-repo-search --query "import fcl" --product nba --language typescript
```

Searches for FCL imports in TypeScript files within NBA repositories.

## Command Workflow

### Step 1: Repository Discovery

Query "MCP - GitHub" workflow (discover ID at runtime) to discover repositories:

```javascript
execute_workflow({
  workflow: "MCP - GitHub" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "List all repositories in dapperlabs and dapperlabs-platform organizations matching filters: [product/language/repo-filter]"
      }
    }
  }
})
```

**Output**: List of repository names matching the specified filters.

### Step 2: Code Search Across Repositories

For each discovered repository, execute code search via GitHub MCP:

```javascript
execute_workflow({
  workflow: "MCP - GitHub" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "Search for '<pattern>' in repository [org]/[repo]"
      }
    }
  }
})
```

**Parallel Execution**: Search multiple repositories concurrently (maximum 10 concurrent requests to avoid rate limiting).

### Step 3: Result Aggregation

Collect and deduplicate results:

- Count total matches per repository
- Extract file paths and line numbers
- Capture code snippets with context
- Calculate result statistics

### Step 4: Pattern Grouping

Analyze and group results by:

- **Repository Type**: app, api, infrastructure, qa, mobile
- **File Type**: Source code, tests, configuration, documentation
- **Pattern Similarity**: Common implementation patterns across repos
- **Product**: Group by NBA, NFL, Disney, Peak Money, Atlas

### Step 5: Generate Findings Report

Create comprehensive report with:

```markdown
# Cross-Repository Search Results

## Query Summary
- **Search Pattern**: [pattern]
- **Repositories Searched**: [count]
- **Total Matches**: [count]
- **Filters Applied**: [product/language/repo-filter]

## Results by Repository

### [Repository Name]
- **Matches**: [count]
- **Primary Files**: [list]
- **Pattern**: [description]

[Code snippets with context]

## Grouped Patterns

### Pattern: [Common Implementation]
**Found in**: [repo1, repo2, repo3]
**Usage**: [description]

[Representative code example]

## Recommendations
- [Insights about code patterns]
- [Opportunities for standardization]
- [Best practice observations]
```

## Integration Details

### GitHub MCP Workflow

**Workflow**: "MCP - GitHub" (discover ID at runtime)

**Organizations Covered**:
- `dapperlabs` (product repositories)
- `dapperlabs-platform` (infrastructure and shared modules)

**Total Repositories**: Query GitHub MCP at runtime for current count

**Repository Types**:
- Application repositories (React/Next.js, iOS, Android)
- API repositories (Go microservices, GraphQL)
- Infrastructure repositories (Terraform, Kubernetes, Helm)
- QA repositories (testing frameworks, automation)
- Blockchain repositories (Cadence smart contracts)

### Product Repository Discovery

**Product Repository Discovery** (Execute at runtime):

For each product, query GitHub MCP to discover actual repositories. Do NOT assume naming patterns.

**Discovery Query Example**:
```javascript
execute_workflow({
  workflow: "MCP - GitHub" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "List all repositories for product [product-name] in dapperlabs and dapperlabs-platform organizations"
      }
    }
  }
})
```

**Note**: Repository naming patterns vary. Always discover dynamically via MCP; never hardcode repository names or patterns.

### Language Distribution

**Language Statistics** (Query at runtime):

Query GitHub MCP to discover current language distribution across organizations:

```javascript
execute_workflow({
  workflow: "MCP - GitHub" // Discover ID at runtime,
  inputs: {
    type: "webhook",
    webhookData: {
      method: "POST",
      body: {
        query: "Show language statistics for repositories in dapperlabs and dapperlabs-platform organizations"
      }
    }
  }
})
```

**Note**: Language distributions change as codebases evolve. Always query for current statistics; never rely on static percentages.

## Use Cases

### 1. Find Implementation Patterns

**Scenario**: How do we handle wallet connections across products?

```
/cross-repo-search --query "WalletConnect" --language typescript
```

**Result**: Discover consistent patterns in NBA, NFL, and Disney apps.

### 2. Security Audits

**Scenario**: Find all uses of deprecated authentication patterns.

```
/cross-repo-search --query "access(all)" --language cadence
```

**Result**: Identify smart contracts needing security updates.

### 3. Infrastructure Standardization

**Scenario**: Find GKE cluster configurations across products.

```
/cross-repo-search --query "google_container_cluster" --language hcl
```

**Result**: Compare infrastructure patterns and identify optimization opportunities.

### 4. API Pattern Discovery

**Scenario**: How are GraphQL resolvers implemented?

```
/cross-repo-search --query "resolver.*Query" --language go --repo-filter "*-api"
```

**Result**: Discover backend API patterns across all products.

### 5. Mobile Integration Patterns

**Scenario**: Find Flow blockchain integration in mobile apps.

```
/cross-repo-search --query "Flow.*SDK" --language swift
```

**Result**: Discover iOS implementation patterns for Flow integration.

### 6. Testing Patterns

**Scenario**: Find test coverage patterns across products.

```
/cross-repo-search --query "describe.*test" --language typescript --product nba
```

**Result**: Analyze testing strategies and coverage.

## Performance Considerations

### Rate Limiting

GitHub API rate limits apply:
- **Authenticated**: 5,000 requests/hour
- **Search API**: 30 requests/minute

**Mitigation**:
- Batch repository searches
- Cache results for repeated queries
- Implement exponential backoff on rate limit errors

### Parallel Execution

- **Max Concurrent Searches**: 10 repositories simultaneously
- **Timeout Per Repository**: 30 seconds
- **Total Timeout**: 5 minutes

### Result Size Limits

- **Max Results Per Repository**: 100 matches
- **Max Total Results**: 1,000 matches across all repositories
- **Snippet Context**: 5 lines before/after match

## Error Handling

### Repository Access Errors

If specific repositories are inaccessible:
- Log repository name and error
- Continue searching remaining repositories
- Include error summary in report

### Search Timeout

If search exceeds time limits:
- Return partial results
- List repositories that timed out
- Suggest narrowing search criteria

### Rate Limit Exceeded

If GitHub rate limit is hit:
- Pause execution
- Wait for rate limit reset
- Resume from last successful repository
- Display remaining rate limit in output

## Best Practices

### Effective Query Patterns

✅ **Use specific patterns**: `"func.*Transaction"` instead of `"transaction"`
✅ **Filter by language**: Reduces false positives and improves performance
✅ **Filter by product**: When investigating product-specific issues
✅ **Use repo filters**: Target specific repository types (api, infrastructure)

❌ **Avoid overly broad queries**: `"function"` will return too many results
❌ **Don't search without filters**: 1,085 repos is a lot to search
❌ **Don't ignore language context**: Code patterns differ by language

### When to Use This Command

**Good Use Cases**:
- Finding implementation patterns across products
- Security audits for deprecated patterns
- Infrastructure standardization reviews
- Discovering best practices from existing code
- Impact analysis for API changes
- Technology adoption metrics

**Not Recommended For**:
- Single repository searches (use standard grep/search tools)
- Real-time development searches (use IDE search)
- Exhaustive code analysis (use dedicated static analysis tools)

## Output Format

### Console Output

```
🔍 Cross-Repository Search
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Query: "WalletConnect"
Filters: product=nba, language=typescript

Discovering repositories... ✓ (12 repositories found)
Searching repositories...
  [1/12] nba-app........................... ✓ (23 matches)
  [2/12] nba-api........................... ✓ (0 matches)
  [3/12] nba-infrastructure................ ✓ (0 matches)
  ...

Aggregating results... ✓
Generating report... ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Search Complete

Total Repositories: 12
Repositories with Matches: 4
Total Matches: 45

Report saved to: cross-repo-search-results-[timestamp].md
```

### Report File

Markdown file saved to current directory with structured findings.

## Related Commands

- `/product-setup` - Set up product development environment
- `/architecture-diagram` - Generate architecture diagrams from repository analysis
- `/dependency-graph` - Map dependencies across repositories

## Permissions

**Git Operations**: Read-only repository access via GitHub MCP
**Modifications**: This command does NOT modify any repositories
**Authentication**: Requires authenticated GitHub MCP connection

## Troubleshooting

### "No repositories found"

**Cause**: Filters too restrictive or product name incorrect

**Solution**:
- Verify product name (nba, nfl, disney, peak-money, atlas)
- Relax filters (remove language or repo-filter)
- Check GitHub MCP authentication status

### "Search returned no results"

**Cause**: Pattern doesn't exist or incorrect language filter

**Solution**:
- Verify pattern syntax (try simpler pattern first)
- Remove language filter
- Try broader search (e.g., product-level instead of repo-filter)

### "Rate limit exceeded"

**Cause**: Too many searches in short time period

**Solution**:
- Wait for rate limit reset (shown in error message)
- Use more specific filters to reduce repository count
- Cache and reuse previous search results

### "GitHub MCP not authenticated"

**Cause**: MCP server not installed or authenticated

**Solution**:
```
/n8n-mcp-setup
/mcp
```

## Quick Start

**Most Common Usage**:

```
# Find all Flow blockchain integrations
/cross-repo-search --query "fcl" --language typescript

# Find Terraform GKE patterns
/cross-repo-search --query "google_container_cluster" --language hcl

# Find authentication patterns in NBA
/cross-repo-search --query "auth" --product nba --repo-filter "*-api"

# Find Cadence security patterns
/cross-repo-search --query "access.*capability" --language cadence
```

---

**Note**: This command requires the Dapper Labs n8n MCP server to be installed and authenticated. Run `/n8n-mcp-setup` and `/mcp` before using this command.
