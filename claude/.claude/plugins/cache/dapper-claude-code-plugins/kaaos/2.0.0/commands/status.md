---
description: Check KAAOS system status including configuration, schedules, recent activity, and cost tracking
argument-hint: ""
---

# KAAOS System Status

Display comprehensive status of the KAAOS automation and knowledge management system.

## Usage
```bash
/kaaos:status
```

No arguments required.

## Implementation

You are the KAAOS Orchestrator handling a status request.

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

### Phase 1: Locate KAAOS Repository

Check if KAAOS is initialized by looking for .kaaos directory.

Use Bash tool to find KAAOS repository:
```bash
# Check current directory first
if [ -d .kaaos ]; then
  echo "$PWD"
elif [ -d ~/kaaos-knowledge/.kaaos ]; then
  echo "$HOME/kaaos-knowledge"
else
  echo "NOT_FOUND"
fi
```

If NOT_FOUND, display error:
```
Error: KAAOS repository not found

Run '/kaaos:init [org-name]' to initialize a new KAAOS repository.
```

Set REPO_PATH to the found directory for subsequent operations.

### Phase 2: Load Configuration

Use Read tool to load .kaaos/config.yaml.

Parse YAML to extract:
- enabled status
- repository_path
- default_organization
- cost_controls (daily/weekly/monthly limits)
- feature flags
- model assignments

If file doesn't exist or is invalid, display error about corrupted repository.

### Phase 3: Load State Files

Use Read tool to load .kaaos/state/agent-executions.json.
Use Read tool to load .kaaos/state/schedules.json.
Use Read tool to load .kaaos/state/system-state.json.
Use Read tool to load .kaaos/state/context-items.json.

If any critical file is missing, note it for the health check section.

### Phase 4: Get Recent Activity

Use Bash tool to get recent git commits:
```bash
cd "$REPO_PATH" && git log --pretty=format:'%h|%an|%ar|%s' -10
```

Parse output to extract:
- Commit count in last 24 hours
- Agent commits vs user commits
- Last commit time

Use Bash tool to count organizations:
```bash
find "$REPO_PATH/organizations" -mindepth 1 -maxdepth 1 -type d | wc -l
```

Use Bash tool to count projects:
```bash
find "$REPO_PATH/organizations/*/projects" -mindepth 1 -maxdepth 1 -type d -not -name '.*' | wc -l
```

### Phase 5: Calculate Cost Tracking

Use Bash tool with jq to calculate costs from agent-executions.json:

```bash
# Get costs for last 24 hours
cat .kaaos/state/agent-executions.json | jq -r '
  .executions[] |
  select(.started_at > (now - 86400) * 1000) |
  .cost_usd // 0
' | awk '{sum+=$1} END {print sum}'
```

```bash
# Get costs for last 7 days
cat .kaaos/state/agent-executions.json | jq -r '
  .executions[] |
  select(.started_at > (now - 604800) * 1000) |
  .cost_usd // 0
' | awk '{sum+=$1} END {print sum}'
```

```bash
# Get costs for current month
MONTH_START=$(date -u +%s -d "$(date +%Y-%m-01)")
cat .kaaos/state/agent-executions.json | jq -r --arg start "$MONTH_START" '
  .executions[] |
  select(.started_at > ($start | tonumber) * 1000) |
  .cost_usd // 0
' | awk '{sum+=$1} END {print sum}'
```

Calculate budget percentages:
- Daily: (daily_cost / daily_limit) * 100
- Weekly: (weekly_cost / weekly_limit) * 100
- Monthly: (monthly_cost / monthly_limit) * 100

### Phase 6: Get Schedule Status

For each schedule type (daily, weekly, monthly, quarterly), extract from schedules.json:
- enabled status
- last_run timestamp
- next_run timestamp

Format last_run as "Today 7:00 AM" or "2 days ago" etc.
Format next_run as "Tomorrow 7:00 AM" or "Mon Jan 13 6:00 AM" etc.

### Phase 7: Check for Running Agents

Use Bash tool with jq to find running agents:
```bash
cat .kaaos/state/agent-executions.json | jq -r '
  .executions[] |
  select(.status == "running") |
  "\(.agent_type)|\(.started_at)"
'
```

Count running agents and format their details.

### Phase 8: Get Recent Context Items

Use Bash tool with jq to count recent context items:
```bash
cat .kaaos/state/context-items.json | jq -r --arg since "$(date -u +%s -d '24 hours ago')" '
  [.items[] | select(.created_at > ($since | tonumber) * 1000)] | length
'
```

### Phase 9: Validate Repository Health

Use Bash tool to check structure:
```bash
# Check required directories
for dir in .kaaos organizations .digests; do
  test -d "$REPO_PATH/$dir" || echo "MISSING:$dir"
done
```

Use Bash tool to check required files:
```bash
# Check required files
for file in .kaaos/config.yaml .kaaos/state/agent-executions.json .kaaos/state/schedules.json; do
  test -f "$REPO_PATH/$file" || echo "MISSING:$file"
done
```

If any MISSING entries found, note them for display.

### Phase 10: Format and Display Status

Display comprehensive status report:

```
┌─────────────────────────────────────────────────────────────┐
│                    KAAOS System Status                       │
└─────────────────────────────────────────────────────────────┘

CONFIGURATION
  Repository: /path/to/repo
  Status: [Enabled/Disabled]
  Organizations: [count]
  Projects: [count]
  Default Org: [org-name]

SCHEDULED JOBS
  [✓/✗] Daily Review      7:00 AM daily       Last: [time]
  [✓/✗] Weekly Synthesis  Mon 6:00 AM         Next: [time]
  [✓/✗] Monthly Review    1st 5:00 AM         Next: [time]
  [✓/✗] Quarterly        Jan/Apr/Jul/Oct 3 AM Next: [time]

RECENT ACTIVITY (24 hours)
  Agent Executions: [count]
    - [agent-type] ([status], [time])
    - [agent-type] ([status], [time])

  Git Commits: [count] ([agent-count] by agents)
  Context Items: [count] created
  Running Agents: [count]

COST TRACKING
  Daily:     $[amount] / $[limit]    ([percent]%)
  Weekly:    $[amount] / $[limit]    ([percent]%)
  Monthly:   $[amount] / $[limit]    ([percent]%)

  Budget Status: [Under/Near/Over] budget

REPOSITORY HEALTH
  [✓/✗] Structure valid
  [✓/✗] All required files present
  [✓/✗] Git repository healthy

  Last commit: [time]
  Current branch: [branch]

───────────────────────────────────────────────────────────────

Next Steps:
  • View daily digest: /kaaos:digest daily
  • Start session: /kaaos:session [org]/[project]
  • Spawn research: /kaaos:research "topic"
```

Use actual values from loaded data.

For cost percentages:
- Green (under 80%): Display normally
- Yellow (80-99%): Add warning symbol
- Red (100%+): Add error symbol and warning

### Phase 11: Display Warnings if Needed

If any issues found:

**Missing Files:**
```
Warning: Missing required files
  - .kaaos/state/schedules.json

Repository may need repair or re-initialization.
```

**Budget Exceeded:**
```
Warning: Budget limits exceeded
  Daily: $6.50 / $5.00 (130%)

Consider:
  - Review spending in agent executions
  - Adjust limits in .kaaos/config.yaml
  - Disable automated reviews temporarily
```

**Corrupted State:**
```
Error: Could not parse state files
  - .kaaos/state/agent-executions.json: Invalid JSON

Try restoring from git history or backup.
```

## Error Cases

### Repository Not Found
```
Error: KAAOS repository not found

Check:
  - Current directory: $PWD
  - Default location: ~/kaaos-knowledge

Run '/kaaos:init [org-name]' to initialize a new repository.
```

### Invalid Configuration
```
Error: Configuration file invalid

File: .kaaos/config.yaml
Issue: [specific error]

Try:
  1. Check YAML syntax
  2. Restore from git: git checkout .kaaos/config.yaml
  3. Re-initialize if needed
```

### Git Repository Issues
```
Warning: Git repository issues detected

Run: cd /path/to/repo && git status

This may affect:
  - Commit tracking
  - Agent git operations
```

## Notes

- This command is read-only (no state changes)
- Fast execution (< 2 seconds typical)
- Uses jq for JSON parsing in Bash
- All timestamps formatted as human-readable
- Budget calculations use simple arithmetic
- Works even if repository partially initialized
- Costs calculated from execution records only
