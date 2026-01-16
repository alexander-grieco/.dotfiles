---
description: View or generate digests from periodic reviews (daily, weekly, monthly, quarterly)
argument-hint: "[daily|weekly|monthly|quarterly] [optional-date]"
---

# View KAAOS Digest

Display or generate digests from KAAOS periodic reviews.

## Usage
```bash
# View today's daily digest
/kaaos:digest daily

# View specific day's digest
/kaaos:digest daily 2026-01-10

# View this week's synthesis
/kaaos:digest weekly

# View specific week (ISO week format)
/kaaos:digest weekly 2026-W01

# View this month's review
/kaaos:digest monthly

# View specific month
/kaaos:digest monthly 2026-01

# View current quarter
/kaaos:digest quarterly

# View specific quarter
/kaaos:digest quarterly 2026-Q1
```

## Implementation

You are the KAAOS Orchestrator handling a digest view request.

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

### Phase 1: Parse Parameters

Extract digest type from $ARGUMENTS (first argument).

Valid types: daily, weekly, monthly, quarterly.

If invalid or missing, display error:
```
Error: Invalid digest type

Usage: /kaaos:digest [type] [optional-date]

Types:
  daily      - Daily digest
  weekly     - Weekly synthesis
  monthly    - Monthly review
  quarterly  - Quarterly analysis

Examples:
  /kaaos:digest daily
  /kaaos:digest weekly 2026-W02
  /kaaos:digest monthly 2026-01
  /kaaos:digest quarterly 2026-Q1
```

Extract optional date parameter (second argument).

If date provided, parse according to type:
- daily: YYYY-MM-DD
- weekly: YYYY-Wnn (ISO week)
- monthly: YYYY-MM
- quarterly: YYYY-Qn

If no date provided, use current period.

### Phase 2: Locate KAAOS Repository

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

If NOT_FOUND, display error:
```
Error: KAAOS repository not found

Initialize repository first:
  /kaaos:init [organization-name]
```

### Phase 3: Calculate Digest Path

Based on type and date, calculate expected digest file path:

**Daily:**
```bash
# Format: YYYY-MM-DD
DIGEST_PATH=".digests/daily/${DATE}.md"
# Example: .digests/daily/2026-01-12.md
```

**Weekly:**
```bash
# Format: YYYY-Wnn (ISO week number)
WEEK_NUM=$(date +%U)  # or parse from parameter
DIGEST_PATH=".digests/weekly/$(date +%Y)-W${WEEK_NUM}.md"
# Example: .digests/weekly/2026-W02.md
```

**Monthly:**
```bash
# Format: YYYY-MM
DIGEST_PATH=".digests/monthly/$(date +%Y-%m).md"
# Example: .digests/monthly/2026-01.md
```

**Quarterly:**
```bash
# Format: YYYY-Qn
MONTH=$(date +%-m)
QUARTER=$(( ($MONTH - 1) / 3 + 1 ))
DIGEST_PATH=".digests/quarterly/$(date +%Y)-Q${QUARTER}.md"
# Example: .digests/quarterly/2026-Q1.md
```

### Phase 4: Check if Digest Exists

Use Bash tool to check if digest file exists:
```bash
test -f "$REPO_PATH/$DIGEST_PATH" && echo "EXISTS" || echo "NOT_FOUND"
```

If EXISTS, proceed to Phase 5 (display).
If NOT_FOUND, proceed to Phase 6 (handle missing).

### Phase 5: Display Existing Digest

Use Read tool to load digest file.

Format and display with header and footer:

```
═══════════════════════════════════════════════════════════════
  [TYPE] DIGEST - [Period Description]
═══════════════════════════════════════════════════════════════

[Digest content from file]

───────────────────────────────────────────────────────────────
```

Add navigation hints based on digest type:

**For daily digests:**
```
───────────────────────────────────────────────────────────────
Navigation:
  Previous day: /kaaos:digest daily [previous-date]
  Next day: /kaaos:digest daily [next-date]
  This week: /kaaos:digest weekly
───────────────────────────────────────────────────────────────
```

**For weekly digests:**
```
───────────────────────────────────────────────────────────────
Navigation:
  Previous week: /kaaos:digest weekly [previous-week]
  Next week: /kaaos:digest weekly [next-week]
  This month: /kaaos:digest monthly

Daily digests from this week:
  • Mon: /kaaos:digest daily [monday-date]
  • Tue: /kaaos:digest daily [tuesday-date]
  • Wed: /kaaos:digest daily [wednesday-date]
  [etc.]
───────────────────────────────────────────────────────────────
```

**For monthly digests:**
```
───────────────────────────────────────────────────────────────
Navigation:
  Previous month: /kaaos:digest monthly [previous-month]
  Next month: /kaaos:digest monthly [next-month]
  This quarter: /kaaos:digest quarterly

Weekly syntheses from this month:
  • Week 1: /kaaos:digest weekly [week-param]
  • Week 2: /kaaos:digest weekly [week-param]
  [etc.]
───────────────────────────────────────────────────────────────
```

**For quarterly digests:**
```
───────────────────────────────────────────────────────────────
Navigation:
  Previous quarter: /kaaos:digest quarterly [previous-quarter]
  Next quarter: /kaaos:digest quarterly [next-quarter]

Monthly reviews from this quarter:
  • Month 1: /kaaos:digest monthly [month-param]
  • Month 2: /kaaos:digest monthly [month-param]
  • Month 3: /kaaos:digest monthly [month-param]
───────────────────────────────────────────────────────────────
```

Calculate previous/next dates using Bash date arithmetic.

### Phase 6: Handle Missing Digest

Determine if missing digest is for current/recent period or historical period.

Use Bash to compare dates:
```bash
# For daily
TODAY=$(date +%Y-%m-%d)
DAYS_AGO=$(( ($(date +%s) - $(date -d "$DIGEST_DATE" +%s)) / 86400 ))

# Recent if within 7 days
if [ $DAYS_AGO -le 7 ]; then
  echo "RECENT"
else
  echo "HISTORICAL"
fi
```

**If RECENT (current or past 7 days):**

Display offer to generate:
```
Digest for [period] not found.

This digest hasn't been generated yet.

Generate now?

This will:
  • Run [type] review
  • Analyze [period description]
  • Generate digest at [path]
  • Cost: ~$[estimate]
  • Time: ~[time-estimate]

To generate: /kaaos:review [type] [date]

Or to auto-generate now, type YES
```

If user confirms (or if you want to be proactive), call review command:
```
Running /kaaos:review [type] [date]...
```

Then redirect to the review command workflow.

**If HISTORICAL (older than 7 days):**

Display explanation and alternatives:
```
Digest for [period] doesn't exist.

This digest was never generated or has been removed.

Possible reasons:
  • KAAOS wasn't running at that time
  • Review was skipped
  • Files were deleted

Options:
  1. Generate retroactively:
     /kaaos:review [type] [date]

  2. View nearby digests that exist:
```

Use Bash to find nearby digests:
```bash
# Find digests within +/- 7 days for daily
# Find digests in same month for weekly
# Find digests in same quarter for monthly
# Find digests in same year for quarterly

ls -t "$REPO_PATH/.digests/[type]"/*.md 2>/dev/null | head -5
```

Display available nearby digests:
```
Available nearby digests:
  • [period-1]: /kaaos:digest [type] [date-1]
  • [period-2]: /kaaos:digest [type] [date-2]
  • [period-3]: /kaaos:digest [type] [date-3]
```

### Phase 7: Format Period Descriptions

Helper function for formatting period descriptions:

**Daily:**
```
January 12, 2026
Sunday, January 12, 2026
```

**Weekly:**
```
Week 2, 2026 (Jan 6 - Jan 12)
```

**Monthly:**
```
January 2026
```

**Quarterly:**
```
Q1 2026 (Jan - Mar)
```

Use Bash date commands to format appropriately.

## Date Parsing Examples

### Daily Date Parsing
```bash
# From YYYY-MM-DD
DATE_PARAM="2026-01-12"
# Already in correct format

# Validate
if date -d "$DATE_PARAM" &>/dev/null; then
  echo "VALID"
else
  echo "INVALID"
fi
```

### Weekly Date Parsing
```bash
# From YYYY-Wnn
WEEK_PARAM="2026-W02"

# Extract year and week
YEAR=$(echo "$WEEK_PARAM" | cut -d'-' -f1)
WEEK=$(echo "$WEEK_PARAM" | cut -d'W' -f2)

# Calculate date range
# (ISO week starts Monday)
```

### Monthly Date Parsing
```bash
# From YYYY-MM
MONTH_PARAM="2026-01"

# Already in format needed for date command
```

### Quarterly Date Parsing
```bash
# From YYYY-Qn
QUARTER_PARAM="2026-Q1"

# Extract year and quarter
YEAR=$(echo "$QUARTER_PARAM" | cut -d'-' -f1)
QUARTER=$(echo "$QUARTER_PARAM" | cut -d'Q' -f2)

# Calculate months
FIRST_MONTH=$(( ($QUARTER - 1) * 3 + 1 ))
```

## Display Examples

### Daily Digest Display
```
═══════════════════════════════════════════════════════════════
  DAILY DIGEST - January 12, 2026
═══════════════════════════════════════════════════════════════

## Summary
Productive day focused on KAAOS plugin development. Completed
core infrastructure and command implementations.

## Key Developments
- Completed all 7 agent definitions
- Implemented core library modules
- Created 6 essential commands

## Insights Extracted
- SQLite ideal for single-user state management
- File-based locking prevents Git conflicts
- Sonnet for research, Opus for strategy balances cost/quality

## Items Requiring Attention
⚠ Need to create git hook templates
⚠ Launchd automation scripts pending

## Metrics
- Commits: 18
- Files created: 15
- Agent executions: 3

## Tomorrow's Focus
- Finalize git hooks
- Create launchd automation
- Test full workflow end-to-end

───────────────────────────────────────────────────────────────
Navigation:
  Previous day: /kaaos:digest daily 2026-01-11
  Next day: /kaaos:digest daily 2026-01-13
  This week: /kaaos:digest weekly
───────────────────────────────────────────────────────────────
```

### Weekly Synthesis Display
```
═══════════════════════════════════════════════════════════════
  WEEKLY SYNTHESIS - Week 2, 2026
═══════════════════════════════════════════════════════════════

## Executive Summary
Week 2 focused on building KAAOS plugin foundation. Established
multi-agent architecture, implemented core libraries, defined
all agent types and essential commands.

## Patterns Discovered

### Pattern: Progressive Complexity
Building from simple (config, state) to complex (orchestration,
synthesis). Each layer builds on previous.

Implications: Sound architectural approach, good foundations.

### Pattern: Safety-First Design
Locking, budget controls, loop prevention throughout.

Implications: Production-ready from start, prevents issues.

## Playbook Updates Proposed
1. Add KAAOS plugin development playbook
2. Document multi-agent orchestration patterns
3. Create cost optimization strategies

## Knowledge Gaps Identified
- Git hooks not yet implemented
- Automation scripts pending
- Testing framework needed

## Metrics
- Daily digests: 7
- Commits: 87
- Patterns identified: 8

───────────────────────────────────────────────────────────────
Navigation:
  This month: /kaaos:digest monthly

Daily digests from this week:
  • Mon: /kaaos:digest daily 2026-01-06
  • Tue: /kaaos:digest daily 2026-01-07
  [etc.]
───────────────────────────────────────────────────────────────
```

## Error Cases

### Invalid Digest Type
```
Error: Invalid digest type "[type]"

Valid types: daily, weekly, monthly, quarterly

Usage: /kaaos:digest [type] [optional-date]
```

### Invalid Date Format
```
Error: Invalid date format "[date]"

Expected format for [type]:
  daily: YYYY-MM-DD (e.g., 2026-01-12)
  weekly: YYYY-Wnn (e.g., 2026-W02)
  monthly: YYYY-MM (e.g., 2026-01)
  quarterly: YYYY-Qn (e.g., 2026-Q1)
```

### Repository Not Found
```
Error: KAAOS repository not found

Initialize repository first:
  /kaaos:init [organization-name]
```

### Digest File Corrupted
```
Error: Could not read digest file

File: [path]
Issue: [error details]

Try:
  1. Check file exists and is readable
  2. Restore from git: git checkout [path]
  3. Regenerate: /kaaos:review [type] [date]
```

## Notes

- This command is read-only (displays existing digests)
- Fast execution (< 2 seconds if digest exists)
- Zero cost (just file reading)
- Integration point between reviews (write) and users (read)
- Navigation hints help users explore digest history
- Offers to generate missing digests when appropriate
- Uses Read tool for file access
- Uses Bash for path calculation and date arithmetic
- All dates calculated relative to current time
- ISO week format for weekly digests (Monday start)
- Friendly error messages with actionable suggestions
