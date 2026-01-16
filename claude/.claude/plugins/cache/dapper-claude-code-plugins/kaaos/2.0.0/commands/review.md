---
description: Execute periodic review (daily, weekly, monthly, or quarterly) with appropriate depth and analysis
argument-hint: "[daily|weekly|monthly|quarterly] [optional-date]"
---

# Execute KAAOS Periodic Review

Run scheduled operational rhythm review with comprehensive analysis.

## Usage
```bash
# Run daily review (generate today's digest)
/kaaos:review daily

# Run weekly synthesis
/kaaos:review weekly

# Run monthly strategic review
/kaaos:review monthly

# Run quarterly comprehensive analysis
/kaaos:review quarterly

# Run with custom date
/kaaos:review daily 2026-01-11
```

## Review Types

### Daily Review (~$0.30, 5-10 min read)
- Reviews past 24 hours of commits and conversations
- Extracts key developments and insights
- Flags items requiring attention
- Generates morning digest

### Weekly Synthesis (~$4-5, 30-60 min session)
- Distills week's conversations into patterns
- Identifies recurring themes
- Proposes playbook updates
- Detects knowledge gaps

### Monthly Review (~$10-15, 2-3 hour session)
- Comprehensive strategic analysis
- Knowledge graph health check
- Strategic consistency validation
- System optimization recommendations

### Quarterly Analysis (~$40-50, half-day session)
- Strategic evolution assessment
- Major organizational review
- Knowledge base comprehensive audit
- Long-term pattern analysis

## Implementation

You are the KAAOS Orchestrator handling a review request.

**NOTE:** Reviews are meant to be automated via launchd. This command provides manual trigger capability and follows the same orchestration pattern that automation would use.

### Phase 0: Check for Pending Automation (Background Processing)

Before executing this command, check if any automated reviews are pending.

**Special Case:** If the user is explicitly running the same review type that has a pending marker (e.g., `/kaaos:review daily` and `daily-pending` exists), skip Phase 0 processing for that specific review type and just delete its marker. The user is manually running what was scheduled.

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

Parse the user's requested review type from $ARGUMENTS (will be parsed fully in Phase 1).

For each pending review type:
- If it matches the user's requested type, just delete the marker and skip spawning:
  ```bash
  # User is running this review manually, delete the pending marker
  rm "$REPO_PATH/.kaaos/automation/${review_type}-pending"
  ```
- If it's a different review type, spawn background agent for it:

**For other pending reviews (not the one user is running)**, use **Task tool** to spawn background agent:

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

For each non-matching pending review type, use Task tool:
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
- Don't spawn a background agent for the review type the user is explicitly running

### Phase 1: Parse Review Type and Date

Extract review type from $ARGUMENTS (first argument).

Valid types: daily, weekly, monthly, quarterly.

If invalid or missing, display error:
```
Error: Invalid review type

Usage: /kaaos:review [type] [optional-date]

Types:
  daily      - Daily digest (~$0.30)
  weekly     - Weekly synthesis (~$4-5)
  monthly    - Monthly review (~$10-15)
  quarterly  - Quarterly analysis (~$40-50)
```

Extract optional date parameter (second argument).
If provided, parse and validate date format.
If not provided, use current date/period.

### Phase 2: Locate Repository and Load Configuration

Use Bash tool to find KAAOS repository (check current dir, then ~/kaaos-knowledge).

Use Read tool to load .kaaos/config.yaml.

Extract budget limits and enabled status for review type.

If review type disabled in config, display warning:
```
Warning: [type] reviews are disabled in configuration

Enable in .kaaos/config.yaml:
  rhythms:
    [type]:
      enabled: true
```

### Phase 3: Budget Check

Use Read tool to load .kaaos/state/agent-executions.json.

Calculate spending for appropriate period:
- Daily review: check daily budget
- Weekly review: check weekly budget
- Monthly/Quarterly: check monthly budget

Use Bash with jq to sum costs:
```bash
# For daily (last 24 hours)
cat .kaaos/state/agent-executions.json | jq -r '
  .executions[] |
  select(.started_at > (now - 86400) * 1000) |
  .cost_usd // 0
' | awk '{sum+=$1} END {print sum}'
```

Get estimated cost for review type:
- daily: $0.50
- weekly: $5.00
- monthly: $15.00
- quarterly: $50.00

Check if remaining budget sufficient.

If budget exceeded, display error and stop:
```
Error: Insufficient budget for [type] review

Current spending: $[spent] / $[limit]
Review estimate: $[estimate]

Options:
  1. Adjust budget limits in .kaaos/config.yaml
  2. Wait until budget period resets
  3. Skip automated review
```

### Phase 4: Determine Review Period and Load Context

Calculate review period based on type and date:

**Daily:**
- Period: previous 24 hours
- Load: git commits, new context items, conversations

**Weekly:**
- Period: last 7 days (Mon-Sun)
- Load: daily digests, conversations, git activity

**Monthly:**
- Period: current/previous month
- Load: weekly syntheses, significant conversations, major commits

**Quarterly:**
- Period: last 3 months
- Load: monthly reviews, weekly syntheses, all context items

Use Bash to get git commits for period:
```bash
# For daily
cd "$REPO_PATH" && git log --since="24 hours ago" --pretty=format:'%H|%an|%ar|%s'

# For weekly
cd "$REPO_PATH" && git log --since="7 days ago" --pretty=format:'%H|%an|%ar|%s'

# For monthly
cd "$REPO_PATH" && git log --since="1 month ago" --pretty=format:'%H|%an|%ar|%s'
```

Use Bash with jq to get recent agent executions:
```bash
cat .kaaos/state/agent-executions.json | jq -r --arg since "$PERIOD_START" '
  .executions[] |
  select(.started_at > ($since | tonumber)) |
  "\(.agent_type)|\(.status)|\(.cost_usd)"
'
```

For weekly/monthly/quarterly, use Glob to find previous digests:
```bash
# Find daily digests for weekly review
ls -t "$REPO_PATH/.digests/daily"/*.md | head -7

# Find weekly digests for monthly review
ls -t "$REPO_PATH/.digests/weekly"/*.md | head -4
```

Use Read tool to load previous digests (if they exist).

### Phase 5: Create Execution Record

Use Bash with jq to create execution record:
```bash
EXEC_ID="${REVIEW_TYPE}-review-$(date +%s)"

cat .kaaos/state/agent-executions.json | jq \
  --arg id "$EXEC_ID" \
  --arg type "synthesis" \
  --arg review "$REVIEW_TYPE" \
  --arg time "$(date -u +%s)000" \
  '.executions += [{
    execution_id: $id,
    agent_type: $type,
    status: "running",
    started_at: ($time | tonumber),
    completed_at: null,
    cost_usd: null,
    context: {
      review_type: $review,
      review_period: "..."
    }
  }] | .next_id = ((.next_id | tonumber) + 1 | tostring)' > .kaaos/state/agent-executions.json.tmp

mv .kaaos/state/agent-executions.json.tmp .kaaos/state/agent-executions.json
```

### Phase 6: Perform Review Analysis

**This is where you perform the actual review work using Claude's analytical capabilities.**

**For Quarterly Reviews ONLY - Spawn 4 Parallel Analysis Agents:**

**CRITICAL**: Quarterly reviews use parallel agent execution for comprehensive analysis.

If review type is "quarterly", use Task tool to spawn ALL 4 agents simultaneously (4 Task calls in ONE message):

**Agent 1: Strategic Alignment Analyst**
```
Task Parameters:
- subagent_type: "general-purpose"
- description: "Quarterly strategic alignment analysis"
- prompt: "You are the KAAOS Strategic Reviewer focusing on strategic alignment.

Analyze all conversations and decisions from Q[N] [YEAR].

Context loaded: [monthly reviews, git history, context items]

Your focus: Strategic alignment analysis
- Extract major strategic decisions
- Assess consistency across organizations
- Identify strategic pivots or shifts
- Track decision rationale evolution

Output format: Include ## Token Usage section with:
- Input tokens: [count]
- Output tokens: [count]
- Total: [sum]"
- model: "opus"
- run_in_background: true
```

**Agent 2: Knowledge Graph Optimizer**
```
Task Parameters:
- subagent_type: "general-purpose"
- description: "Quarterly knowledge graph optimization"
- prompt: "You are the KAAOS Knowledge Graph Optimizer.

Analyze knowledge base structure and quality for Q[N] [YEAR].

Context loaded: [all context items, connections, metadata]

Your focus: Knowledge graph analysis
- Assess graph structure and coverage
- Identify orphaned or disconnected knowledge
- Recommend connection improvements
- Evaluate tagging and categorization

Output format: Include ## Token Usage section with:
- Input tokens: [count]
- Output tokens: [count]
- Total: [sum]"
- model: "opus"
- run_in_background: true
```

**Agent 3: Content Quality Auditor**
```
Task Parameters:
- subagent_type: "general-purpose"
- description: "Quarterly content quality audit"
- prompt: "You are the KAAOS Content Quality Auditor.

Audit content quality across all repositories for Q[N] [YEAR].

Context loaded: [context items, documentation, research reports]

Your focus: Content quality assessment
- Evaluate documentation completeness
- Identify outdated or stale content
- Assess clarity and actionability
- Recommend quality improvements

Output format: Include ## Token Usage section with:
- Input tokens: [count]
- Output tokens: [count]
- Total: [sum]"
- model: "opus"
- run_in_background: true
```

**Agent 4: Cross-Organization Analyst**
```
Task Parameters:
- subagent_type: "general-purpose"
- description: "Quarterly cross-organization analysis"
- prompt: "You are the KAAOS Cross-Organization Analyst.

Analyze patterns and insights across organizations for Q[N] [YEAR].

Context loaded: [all organizational context, projects, patterns]

Your focus: Cross-organization pattern analysis
- Identify shared patterns across organizations
- Find reusable knowledge and playbooks
- Spot inconsistencies in approaches
- Recommend knowledge sharing opportunities

Output format: Include ## Token Usage section with:
- Input tokens: [count]
- Output tokens: [count]
- Total: [sum]"
- model: "opus"
- run_in_background: true
```

Wait for all 4 agents to complete (poll output files or use blocking calls).

Synthesize all 4 outputs into comprehensive quarterly analysis combining:
- Strategic alignment findings
- Knowledge graph improvements
- Content quality recommendations
- Cross-organization insights

**For All Other Review Types (Daily, Weekly, Monthly):**

Spawn the appropriate specialized agent using Task tool.

**Daily Review - Spawn Synthesis Agent:**

```
Task Tool Parameters:
- subagent_type: "kaaos:synthesis-agent"
- description: "Daily digest generation"
- model: "sonnet"
- prompt: "You are the KAAOS Synthesis Agent generating a daily digest.

Review Type: daily
Review Date: [DATE]
Organization: [ORG_NAME]
Repository: $REPO_PATH
Output Path: .digests/daily/[DATE].md
Execution ID: [EXECUTION_ID]

Context Loaded:
- Git commits from last 24 hours
- Agent executions from last 24 hours
- New context items from last 24 hours

Follow your agent definition to generate the daily digest.

Expected Output Format:"
```

**Daily Review Output Template:**
```markdown
# Daily Digest - [Date]

## Summary
[1-2 paragraph overview of the day's work]

## Key Developments
- [Development 1]
- [Development 2]
- [Development 3]

## Insights Extracted
- [Insight 1]
- [Insight 2]

## Items Requiring Attention
- [Item 1]
- [Item 2]

## Metrics
- Commits: [count]
- Files created/modified: [count]
- Agent executions: [count]
- Context items added: [count]

## Tomorrow's Focus
[Suggested priorities for next day]
```"
```

**DO NOT use run_in_background: true** - Wait for completion.

**Weekly Review - Spawn Synthesis Agent:**

```
Task Tool Parameters:
- subagent_type: "kaaos:synthesis-agent"
- description: "Weekly synthesis generation"
- model: "opus"
- prompt: "You are the KAAOS Synthesis Agent generating a weekly synthesis.

Review Type: weekly
Week Number: [WEEK_NUM]
Organization: [ORG_NAME]
Repository: $REPO_PATH
Output Path: .digests/weekly/[YEAR]-W[NUM].md
Execution ID: [EXECUTION_ID]

Context Loaded:
- Daily digests from last 7 days
- Git activity from last 7 days
- Agent executions from last 7 days

Follow your agent definition to generate the weekly synthesis.

Expected Output Format:"
```

**Weekly Synthesis Output Template:**
```markdown
# Weekly Synthesis - Week [N], [Year]

## Executive Summary
[2-3 paragraphs summarizing the week]

## Patterns Discovered

### Pattern 1: [Name]
[Description, implications, examples]

### Pattern 2: [Name]
[Description, implications, examples]

## Recurring Themes
- [Theme 1]
- [Theme 2]

## Playbook Updates Proposed
1. [Update 1 with rationale]
2. [Update 2 with rationale]

## Knowledge Gaps Identified
- [Gap 1]
- [Gap 2]

## Metrics
- Daily digests: [count]
- Commits: [count]
- Patterns identified: [count]

## Next Week's Priorities
[Suggested priorities for next week]
```"
```

**DO NOT use run_in_background: true** - Wait for completion.

**Monthly Review - Spawn Strategic Reviewer:**

```
Task Tool Parameters:
- subagent_type: "kaaos:strategic-reviewer"
- description: "Monthly strategic review"
- model: "opus"
- prompt: "You are the KAAOS Strategic Reviewer generating a monthly review.

Review Type: monthly
Month: [MONTH] [YEAR]
Organization: [ORG_NAME]
Repository: $REPO_PATH
Output Path: .digests/monthly/[YEAR]-[MM].md
Execution ID: [EXECUTION_ID]

Context Loaded:
- Weekly syntheses from last 4-5 weeks
- Major git activity from month
- All agent executions from month

Follow your agent definition to generate the monthly strategic review.

Expected Output Format:"
```

**Monthly Review Output Template:**
```markdown
# Monthly Review - [Month Year]

## Executive Summary
[Comprehensive overview of month's work and progress]

## Strategic Analysis
[Analysis of alignment with goals and strategic direction]

## Knowledge Graph Health
[Assessment of knowledge base structure and quality]

## Major Developments
- [Development 1]
- [Development 2]

## Patterns and Insights
[Cross-week patterns and meta-patterns]

## Gaps and Opportunities
[Strategic gaps requiring attention]

## Metrics
- Weekly syntheses: [count]
- Total commits: [count]
- Major projects: [count]

## Recommendations
1. [Strategic recommendation]
2. [Process recommendation]

## Next Month's Focus
[Strategic priorities]
```

**Quarterly Analysis Output:**
```markdown
# Quarterly Analysis - Q[N] [Year]

## Executive Summary
[High-level strategic overview of quarter]

## Strategic Evolution
[How strategy and direction evolved]

## Knowledge Base Audit
[Comprehensive review of knowledge quality and coverage]

## Major Achievements
- [Achievement 1]
- [Achievement 2]

## Long-Term Patterns
[Patterns spanning multiple months]

## Strategic Gaps
[Major gaps requiring strategic attention]

## Comprehensive Metrics
- Monthly reviews: [count]
- Total commits: [count]
- Knowledge items: [count]
- Organizations/Projects: [count]

## Strategic Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

## Next Quarter's Strategic Focus
[Major priorities for next quarter]
```

Determine output path:
```bash
case "$REVIEW_TYPE" in
  daily)
    OUTPUT=".digests/daily/$(date +%Y-%m-%d).md"
    ;;
  weekly)
    OUTPUT=".digests/weekly/$(date +%Y-W%U).md"
    ;;
  monthly)
    OUTPUT=".digests/monthly/$(date +%Y-%m).md"
    ;;
  quarterly)
    QUARTER=$(( ($(date +%-m) - 1) / 3 + 1 ))
    OUTPUT=".digests/quarterly/$(date +%Y)-Q${QUARTER}.md"
    ;;
esac
```

Use Write tool to save digest to output path.

### Phase 6.5: Process Pending Insights

Before finalizing the review, process any pending insights from post-commit hooks.

Use Bash to check for pending insights:
```bash
if [ -d "$REPO_PATH/.kaaos/insights/pending" ]; then
  PENDING_COUNT=$(ls -1 "$REPO_PATH/.kaaos/insights/pending"/*.json 2>/dev/null | wc -l)
  echo "$PENDING_COUNT"
fi
```

If pending insights exist:

1. Use Read tool to load each pending insight file
2. Extract commit information and detected patterns
3. Integrate insights into current review analysis
4. Use Bash to move processed insights to archive:
```bash
mkdir -p .kaaos/insights/processed
for insight_file in .kaaos/insights/pending/*.json; do
  if [ -f "$insight_file" ]; then
    BASENAME=$(basename "$insight_file")
    cat "$insight_file" | jq '.processed = true' > ".kaaos/insights/processed/$BASENAME"
    rm "$insight_file"
  fi
done
```

Include pending insights summary in review output:
```markdown
## Insights Processed
- Insights from commits: [count]
- Decisions detected: [count]
- Architecture changes: [count]
- Documentation updates: [count]
```

### Phase 7: Extract and Record Actual Token Usage

Use Bash to extract token usage from review output:
```bash
# Parse Execution Metadata section from output file
INPUT_TOKENS=$(grep "Input tokens:" "$OUTPUT_PATH" | grep -o '[0-9,]*' | tr -d ',')
OUTPUT_TOKENS=$(grep "Output tokens:" "$OUTPUT_PATH" | grep -o '[0-9,]*' | tr -d ',')
TOTAL_TOKENS=$(grep "Total tokens:" "$OUTPUT_PATH" | grep -o '[0-9,]*' | tr -d ',')
ACTUAL_COST=$(grep "Estimated cost:" "$OUTPUT_PATH" | grep -o '\$[0-9.]*' | tr -d '$')

# If metadata not found, use fallback estimation based on review type
if [ -z "$INPUT_TOKENS" ]; then
  case "$REVIEW_TYPE" in
    daily) ACTUAL_COST="0.30" ;;
    weekly) ACTUAL_COST="4.00" ;;
    monthly) ACTUAL_COST="12.00" ;;
    quarterly) ACTUAL_COST="45.00" ;;
  esac
fi
```

### Phase 8: Update Execution Record

Update execution record with actual costs and token counts (not estimates).

Use Bash with jq to update execution:
```bash
cat .kaaos/state/agent-executions.json | jq \
  --arg id "$EXEC_ID" \
  --arg time "$(date -u +%s)000" \
  --arg cost "$ACTUAL_COST" \
  --arg output "$OUTPUT_PATH" \
  --argjson input "${INPUT_TOKENS:-0}" \
  --argjson output_tok "${OUTPUT_TOKENS:-0}" \
  --argjson total "${TOTAL_TOKENS:-0}" \
  '(.executions[] | select(.execution_id == $id)) |= {
    status: "completed",
    completed_at: ($time | tonumber),
    cost_usd: ($cost | tonumber),
    input_tokens: $input,
    output_tokens: $output_tok,
    total_tokens: $total,
    output_path: $output
  }' > .kaaos/state/agent-executions.json.tmp

mv .kaaos/state/agent-executions.json.tmp .kaaos/state/agent-executions.json
```

### Phase 9: Update Schedule Record

Use Read tool to load .kaaos/state/schedules.json.

Use Bash with jq to update schedule:
```bash
cat .kaaos/state/schedules.json | jq \
  --arg type "$REVIEW_TYPE" \
  --arg time "$(date -u +%s)000" \
  '(.schedules[$type].last_run) = ($time | tonumber)' > .kaaos/state/schedules.json.tmp

mv .kaaos/state/schedules.json.tmp .kaaos/state/schedules.json
```

### Phase 10: Commit to Git

Use Bash to commit digest and state:
```bash
cd "$REPO_PATH" && \
git add "$OUTPUT_PATH" .kaaos/state/ && \
KAAOS_AGENT_COMMIT=1 git commit -m "[KAAOS-AGENT] ${REVIEW_TYPE^} Review

Period: $REVIEW_PERIOD
Output: $OUTPUT_PATH
Cost: \$$ACTUAL_COST
Execution: $EXEC_ID

Generated by synthesis-agent"
```

### Phase 11: Present Results

Display completion summary:

**For Daily:**
```
Daily Digest Complete!

Output: [output-path]

Quick Summary:
[First 2-3 lines from digest]

Metrics:
  Commits: [count]
  Context items: [count]

Cost: $[cost]
Time: [duration]

Read full digest: /kaaos:digest daily
```

**For Weekly:**
```
Weekly Synthesis Complete!

Output: [output-path]

Patterns Identified: [count]
Gaps Found: [count]
Playbook Updates: [count]

Cost: $[cost]
Time: [duration]

Read full synthesis: /kaaos:digest weekly
```

**For Monthly:**
```
Monthly Review Complete!

Output: [output-path]

This comprehensive review requires strategic attention.
Estimated read time: 30-45 minutes

Strategic recommendations: [count]
Major insights: [count]

Cost: $[cost]
Time: [duration]

Read full review: /kaaos:digest monthly
```

**For Quarterly:**
```
Quarterly Analysis Complete!

Output: [output-path]

Comprehensive quarterly analysis ready for review.
Estimated read time: 1-2 hours

Block time for strategic session to:
  - Review findings
  - Make decisions on recommendations
  - Set priorities for next quarter

Cost: $[cost]
Time: [duration]

Read analysis: /kaaos:digest quarterly
```

## Error Handling

### Invalid Review Type
```
Error: Invalid review type "[type]"

Valid types: daily, weekly, monthly, quarterly

Usage: /kaaos:review [type]
```

### Budget Exceeded
```
Error: Budget exceeded for [type] review

Spent: $[spent] / $[limit]
Estimated: $[estimate]

Adjust limits in .kaaos/config.yaml or wait for budget reset.
```

### Previous Digests Missing
```
Warning: Previous digests not found

Weekly review requires daily digests.
Monthly review requires weekly syntheses.

This review will be limited in scope.
Proceed? [Y/n]
```

### Analysis Failed
```
Error: Review analysis failed

Issue: [specific error]

Options:
  1. Retry review
  2. Run manual analysis
  3. Check logs for details
```

Update execution status to "failed" with error details.

## Notes

- Reviews use Claude's analytical capabilities directly
- No external agent spawning - you ARE the synthesis agent
- Daily reviews are lightweight, quarterly are comprehensive
- All reviews follow consistent output templates
- State tracking ensures scheduling works correctly
- Git commits use KAAOS_AGENT_COMMIT=1 to prevent loops
- Cost estimates are conservative (actual may be lower)
- Reviews build on previous period's outputs
- Meant to be automated via launchd but works manually
