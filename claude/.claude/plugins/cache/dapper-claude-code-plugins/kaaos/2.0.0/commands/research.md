---
description: Launch a focused research task with proper tracking and integration into context libraries
argument-hint: "[research-topic]"
---

# Spawn KAAOS Research Task

Launch a research task to investigate a specific topic and produce a comprehensive research report integrated into your knowledge base.

## Usage
```bash
# Research a technical topic
/kaaos:research "Claude Code plugin system architecture"

# Research a business domain
/kaaos:research "competitive landscape for AI code editors"

# Research within codebase
/kaaos:research "error handling patterns in current codebase"
```

## Implementation

You are the KAAOS Orchestrator handling a research request.

### Phase 0: Check for Pending Automation (Background Processing)

Before executing this command, check if any automated reviews are pending.

Use Bash tool to check for pending review markers:
```bash
# Check for pending reviews
PENDING_REVIEWS=""
for review_type in daily weekly monthly quarterly; do
  if [ -f "$HOME/kaaos-knowledge/.kaaos/automation/${review_type}-pending" ] || [ -f ".kaaos/automation/${review_type}-pending" ]; then
    PENDING_REVIEWS="${PENDING_REVIEWS}${review_type} "
  fi
done

echo "$PENDING_REVIEWS"
```

If any pending reviews found:

**For each pending review**, use **Task tool** to spawn background agent:

Determine the model based on review type:
- daily: "sonnet"
- weekly: "opus"
- monthly: "opus"
- quarterly: "opus"

Determine the repo path (check current dir first, then ~/kaaos-knowledge):
```bash
if [ -d .kaaos ]; then
  REPO_PATH="$PWD"
elif [ -d ~/kaaos-knowledge/.kaaos ]; then
  REPO_PATH="$HOME/kaaos-knowledge"
fi
```

For each pending review type found, use Task tool:
```
Task Tool Parameters:
- subagent_type: "general-purpose"
- description: "KAAOS [type] review background execution"
- prompt: "You are executing a KAAOS [type] review.

Read and follow the instructions in /Users/ben/src/kaaos/commands/review.md for [type] review.

Context: This is an automated review triggered at scheduled time.
Repository: [REPO_PATH]
Output: .digests/[type]/[date].md

Execute the full review workflow, update state, commit to git."
- run_in_background: true
- model: [model based on type]
```

After spawning each background agent, use Bash to delete the pending marker:
```bash
rm "$REPO_PATH/.kaaos/automation/${review_type}-pending"
```

Display brief notification for all spawned agents:
```
[Processing in background]
  • [Type] review started (background agent)
  • Will complete in ~[time-estimate] minutes
  • View when ready: /kaaos:digest [type]
```

Time estimates:
- daily: ~5 minutes
- weekly: ~30 minutes
- monthly: ~2 hours
- quarterly: ~4 hours

**Then continue with this command's normal execution (Phase 1+).**

**Important**:
- Only spawn background agents, don't wait for completion
- Display non-intrusive notification
- Don't block the command the user actually wanted to run
- Check ALL review types (daily, weekly, monthly, quarterly)

### Phase 1: Parse and Validate Request

Extract research topic from $ARGUMENTS (everything after command name).

If topic is empty or too short (< 5 characters), display usage error:
```
Error: Research topic required

Usage: /kaaos:research "topic to investigate"

Examples:
  /kaaos:research "multi-agent orchestration patterns"
  /kaaos:research "cost optimization strategies for Claude API"
```

Topic should be descriptive and focused. If topic seems too broad (e.g., "everything"), suggest narrowing the scope.

### Phase 2: Locate KAAOS Repository and Load Configuration

Use Bash tool to find KAAOS repository:
```bash
if [ -d .kaaos ]; then
  echo "$PWD"
elif [ -d ~/kaaos-knowledge/.kaaos ]; then
  echo "$HOME/kaaos-knowledge"
else
  echo "NOT_FOUND"
fi
```

Use Read tool to load .kaaos/config.yaml to get model configuration and budget limits.

Use Read tool to load .kaaos/state/system-state.json to get current session context.

Extract current organization and project from current_session field:
```bash
cat .kaaos/state/system-state.json | jq -r '.current_session.organization // empty'
cat .kaaos/state/system-state.json | jq -r '.current_session.project // empty'
```

If no active session, prompt user to start one first:
```
Error: No active session

Start a session first:
  /kaaos:session [organization]/[project]
```

### Phase 3: Check Budget

Use Read tool to load .kaaos/state/agent-executions.json.

Use Bash tool with jq to calculate today's spending:
```bash
cat .kaaos/state/agent-executions.json | jq -r '
  .executions[] |
  select(.started_at > (now - 86400) * 1000) |
  .cost_usd // 0
' | awk '{sum+=$1} END {print sum}'
```

Get daily_limit_usd from config.yaml (loaded earlier).

Calculate remaining budget:
```bash
# remaining = limit - spent
```

Estimate research cost at $2-5 (typical Sonnet research task).

If remaining budget < $2.00, display error:
```
Error: Insufficient budget remaining

Daily spending: $[spent] / $[limit]
Remaining: $[remaining]

Research typically costs $2-5. Options:
  1. Wait until tomorrow (daily budget resets)
  2. Adjust daily limit in .kaaos/config.yaml
  3. Run manual research without tracking
```

If within budget, display confirmation:
```
Budget check: $[spent] / $[limit] used
Estimated cost: $2-5
Proceeding with research task...
```

### Phase 4: Check for Existing Research

Use Glob tool to search for related research in organization context library:
```
organizations/[org]/context-library/**/*.md
```

If project exists, also search:
```
organizations/[org]/projects/[project]/context-library/**/*.md
```

For each file found, use Grep tool to search for topic keywords (extract 2-3 key words from research topic).

If highly related files found (keyword matches), display:
```
Found existing research on related topics:
  - [file-path-1]
  - [file-path-2]

Would you like to:
  1. Review existing research first
  2. Proceed with new research (may build on existing)
  3. Update/expand existing research

[Continue anyway - type YES to proceed]
```

Wait for user confirmation if related research exists.

### Phase 5: Determine Research Type and Scope

Analyze topic to determine research type:
- Contains "codebase", "repo", "current code" -> CODEBASE research
- Contains "external", "web", "industry" -> EXTERNAL research
- Contains "pattern", "architecture", "design" -> PATTERN research
- Default -> GENERAL research

Set research scope based on type:

**CODEBASE research:**
- Tools: Glob, Grep, Read
- Scope: Analyze current repository files
- Output focus: Code patterns and structure

**EXTERNAL research:**
- Tools: WebSearch, WebFetch
- Scope: Search web sources
- Output focus: Industry knowledge and best practices

**PATTERN research:**
- Tools: Grep, Read, analysis
- Scope: Extract and document patterns
- Output focus: Pattern documentation with examples

Display research plan:
```
Research Plan:
  Topic: [topic]
  Type: [CODEBASE/EXTERNAL/PATTERN/GENERAL]
  Scope: [description]
  Estimated time: 30-60 minutes
  Estimated cost: $2-5
```

### Phase 6: Create Execution Record

Use Read tool to load .kaaos/state/agent-executions.json.

Use Bash tool with jq to create new execution record:
```bash
cat .kaaos/state/agent-executions.json | jq \
  --arg id "$(cat .kaaos/state/agent-executions.json | jq -r '.next_id')" \
  --arg agent "research" \
  --arg topic "$RESEARCH_TOPIC" \
  --arg org "$ORG_NAME" \
  --arg proj "$PROJECT_NAME" \
  --arg time "$(date -u +%s)000" \
  '.executions += [{
    execution_id: ("research-" + $id),
    agent_type: $agent,
    status: "running",
    started_at: ($time | tonumber),
    completed_at: null,
    cost_usd: null,
    context: {
      topic: $topic,
      organization: $org,
      project: $proj
    }
  }] | .next_id = ((.next_id | tonumber) + 1 | tostring)' > .kaaos/state/agent-executions.json.tmp

mv .kaaos/state/agent-executions.json.tmp .kaaos/state/agent-executions.json
```

Store execution ID for later update.

### Phase 7: Spawn Research Agent

**IMPORTANT: Delegate research to dedicated research-agent**

Generate output path first:
```bash
# Sanitize topic for filename
FILENAME=$(echo "$TOPIC" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')
DATE=$(date +%Y-%m-%d)

# Determine output location
if [ -n "$PROJECT_NAME" ]; then
  OUTPUT="organizations/$ORG_NAME/projects/$PROJECT_NAME/context-library/research/${FILENAME}-${DATE}.md"
else
  OUTPUT="organizations/$ORG_NAME/context-library/research/${FILENAME}-${DATE}.md"
fi
```

Now spawn the research-agent using Task tool:

```
Task Tool Parameters:
- subagent_type: "kaaos:research-agent"
- description: "Research: [topic-first-50-chars]"
- model: "sonnet"
- prompt: "You are the KAAOS Research Agent conducting research.

Research Topic: [TOPIC]
Research Type: [CODEBASE/EXTERNAL/PATTERN]
Organization: [ORG_NAME]
Project: [PROJECT_NAME]
Output Path: $REPO_PATH/[OUTPUT]
Execution ID: [EXECUTION_ID]

Follow your agent definition instructions to:
1. Conduct comprehensive research using appropriate tools
2. Generate structured research report
3. Include cross-references to related context
4. Add execution metadata with token counts

Expected Research Output Format:
```markdown
# Research: [Topic]

**Research Date:** [date]
**Research Type:** [type]
**Conducted by:** research-agent (execution: [id])

## Executive Summary
[2-3 paragraph summary of key findings]

## Research Objectives
- [Objective 1]
- [Objective 2]
- [Objective 3]

## Methodology
[How research was conducted, tools used, sources consulted]

## Key Findings

### Finding 1: [Title]
[Detailed finding with evidence]

### Finding 2: [Title]
[Detailed finding with evidence]

### Finding 3: [Title]
[Detailed finding with evidence]

## Patterns and Insights
- [Pattern 1]
- [Pattern 2]
- [Pattern 3]

## Recommendations
1. [Actionable recommendation]
2. [Actionable recommendation]
3. [Actionable recommendation]

## Integration Suggestions
[How findings relate to existing context, what should be updated]

## Sources and References
- [Source 1]
- [Source 2]
- [Source 3]

## Tags
`[tag1]` `[tag2]` `[tag3]`

## Execution Metadata
- Input tokens: [estimate based on context]
- Output tokens: [estimate based on output]
- Total tokens: [sum]
- Estimated cost: $[calculated]
```

After completing research, save report to output path and return summary."
```

The agent executes in its own context, performs research, writes file, and returns summary to orchestrator.

**DO NOT use run_in_background: true** - Wait for agent to complete so you can extract results.

### Phase 8: Extract and Record Actual Token Usage

After research agent completes, read the output file it created to extract metadata.

Use Read tool to load the research file:
```bash
cat "$REPO_PATH/$OUTPUT"
```

Use Bash to extract token usage from the Execution Metadata section:
```bash
# Parse Execution Metadata section from research file
INPUT_TOKENS=$(grep "Input tokens:" "$REPO_PATH/$OUTPUT" | grep -o '[0-9,]*' | tr -d ',' | head -1)
OUTPUT_TOKENS=$(grep "Output tokens:" "$REPO_PATH/$OUTPUT" | grep -o '[0-9,]*' | tr -d ',' | head -1)
TOTAL_TOKENS=$(grep "Total tokens:" "$REPO_PATH/$OUTPUT" | grep -o '[0-9,]*' | tr -d ',' | head -1)
ACTUAL_COST=$(grep "Estimated cost:" "$REPO_PATH/$OUTPUT" | grep -o '\$[0-9.]*' | tr -d '$' | head -1)

# If metadata not found, use fallback estimation
if [ -z "$INPUT_TOKENS" ] || [ -z "$ACTUAL_COST" ]; then
  # Fallback: estimate based on file size
  ACTUAL_COST="2.50"
  INPUT_TOKENS="5000"
  OUTPUT_TOKENS="3000"
  TOTAL_TOKENS="8000"
fi
```

### Phase 9: Update Execution Record

Update execution record with actual costs (not estimates).

Use Bash tool with jq to update execution record:
```bash
cd "$REPO_PATH" && cat .kaaos/state/agent-executions.json | jq \
  --arg id "$EXECUTION_ID" \
  --arg time "$(date -u +%s)000" \
  --arg cost "$ACTUAL_COST" \
  --arg output "$OUTPUT" \
  --argjson input "${INPUT_TOKENS:-0}" \
  --argjson output_tok "${OUTPUT_TOKENS:-0}" \
  --argjson total "${TOTAL_TOKENS:-0}" \
  '(.executions[] | select(.execution_id == $id)) += {
    status: "completed",
    completed_at: ($time | tonumber),
    cost_usd: ($cost | tonumber),
    input_tokens: $input,
    output_tokens: $output_tok,
    total_tokens: $total,
    output_path: $output
  }' > .kaaos/state/agent-executions.json.tmp && \
mv .kaaos/state/agent-executions.json.tmp .kaaos/state/agent-executions.json
```

### Phase 10: Update Context Items Database

Use Read tool to load .kaaos/state/context-items.json.

Use Bash tool with jq to add new context item:
```bash
cat .kaaos/state/context-items.json | jq \
  --arg id "$(uuidgen | tr '[:upper:]' '[:lower:]')" \
  --arg path "$OUTPUT_PATH" \
  --arg type "research" \
  --arg exec "$EXECUTION_ID" \
  --arg time "$(date -u +%s)000" \
  --arg tags "$TAGS" \
  --arg summary "$SUMMARY" \
  '.items += [{
    id: $id,
    path: $path,
    item_type: $type,
    created_by: $exec,
    created_at: ($time | tonumber),
    last_updated: ($time | tonumber),
    git_commit: null,
    tags: ($tags | split(",") | map(gsub("^\\s+|\\s+$"; ""))),
    summary: $summary
  }]' > .kaaos/state/context-items.json.tmp

mv .kaaos/state/context-items.json.tmp .kaaos/state/context-items.json
```

Extract tags from research report (look for Tags section or generate from topic).
Extract summary from Executive Summary section (first 200 chars).

### Phase 11: Commit to Git

Use Bash tool to commit research findings:
```bash
cd "$REPO_PATH" && \
git add "$OUTPUT_PATH" .kaaos/state/ && \
KAAOS_AGENT_COMMIT=1 git commit -m "[KAAOS-AGENT] Research: $TOPIC

Execution: $EXECUTION_ID
Output: $OUTPUT_PATH
Cost: \$$ACTUAL_COST

Generated by research-agent"
```

Get commit SHA:
```bash
git rev-parse HEAD
```

Update context item with commit SHA:
```bash
cat .kaaos/state/context-items.json | jq \
  --arg id "$ITEM_ID" \
  --arg sha "$COMMIT_SHA" \
  '(.items[] | select(.id == $id)).git_commit = $sha' > .kaaos/state/context-items.json.tmp

mv .kaaos/state/context-items.json.tmp .kaaos/state/context-items.json
```

### Phase 12: Present Results

Display research completion summary:

```
Research Complete!

Topic: "[topic]"
Output: [output-path]

Executive Summary:
[First paragraph from research report]

Key Findings:
- [Finding 1 title]
- [Finding 2 title]
- [Finding 3 title]

Recommendations: [count]
Sources Analyzed: [count]
Patterns Identified: [count]

Cost: $[actual-cost]
Execution Time: [duration]
Execution ID: [execution-id]

───────────────────────────────────────────────────────────────

Next Steps:
  • Review full report: Read [output-path]
  • View in context: /kaaos:session [org]/[project]
  • Related research: [Suggest follow-up topics]

Committed to git: [commit-sha]
```

Extract actual values from research report and execution record.

## Error Handling

### Topic Too Broad
If topic is very generic (< 10 chars, single word), suggest:
```
Topic may be too broad: "[topic]"

Consider narrowing scope, for example:
  - "multi-agent orchestration patterns"
  - "cost optimization strategies for Claude API"
  - "error handling best practices in TypeScript"
```

### Research Failed
If research encounters errors (file not found, web search failed, etc.):
```
Error: Research task failed

Issue: [specific error]

Options:
  1. Retry with narrower scope
  2. Try different research type
  3. Manual research (without automation)
```

Update execution record status to "failed" with error message.

### Budget Exceeded Mid-Research
If research exceeds estimated budget:
```
Warning: Research cost exceeded estimate

Estimated: $2-5
Actual: $[actual]

This has been noted. Consider:
  - Adjusting budget limits
  - Using more focused research topics
```

## Notes

- Research uses Claude's native tools (Read, Write, Bash, Glob, Grep, WebSearch, WebFetch)
- No external agent spawning needed - you ARE the research agent
- Direct tool usage is more reliable than delegation
- Output is production-ready markdown
- All state updates use jq for JSON manipulation
- Git commits use KAAOS_AGENT_COMMIT=1 to prevent hook loops
- Cost tracking is estimated based on token usage
- Research output follows consistent template for easy parsing
