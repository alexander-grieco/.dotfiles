---
description: Begin a context-aware work session with relevant knowledge loaded, recent history reviewed, and optional co-pilot assistance
argument-hint: "[organization]/[project]"
---

# Start KAAOS Work Session

Initialize an intelligent work session with full KAAOS context loaded and ready for productive work.

## Usage
```bash
# Start session for specific project
/kaaos:session personal/research

# Start session for organization (no specific project)
/kaaos:session personal

# Start session with focus area
/kaaos:session company-x/strategy-2026
```

## Implementation

You are the KAAOS Orchestrator handling session initialization.

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

### Phase 1: Parse Session Parameters

Extract organization and optional project from $ARGUMENTS:
```bash
# Format: "organization/project" or "organization"
# Examples: "personal/research" or "personal"
```

Split on "/" to get organization and project.
Organization is required, project is optional.

If no arguments provided, display usage error.

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

If NOT_FOUND, display error and suggest running /kaaos:init.

### Phase 3: Validate Organization and Project

Use Bash tool to check organization exists:
```bash
test -d "$REPO_PATH/organizations/$ORG_NAME" && echo "EXISTS" || echo "NOT_FOUND"
```

If organization doesn't exist, list available organizations using Bash:
```bash
ls -1 "$REPO_PATH/organizations"
```

Display error with available organizations and suggestion to create new one.

If project specified, use Bash tool to check project exists:
```bash
test -d "$REPO_PATH/organizations/$ORG_NAME/projects/$PROJECT_NAME" && echo "EXISTS" || echo "NOT_FOUND"
```

If project doesn't exist, offer to create it:

```
Project '[project]' not found in '[org]'.

Create new project '[project]'? [Y/n]
```

If user confirms (or you want to be helpful and auto-create), use Bash tool to create project:
```bash
mkdir -p "$REPO_PATH/organizations/$ORG_NAME/projects/$PROJECT_NAME"/{context-library,conversations,conversations/artifacts}
```

Use Write tool to create project metadata at `organizations/$ORG_NAME/projects/$PROJECT_NAME/_meta.yaml`:
```yaml
name: project-name
created_at: '2026-01-12T...'
organization: org-name
description: ''
status: active
tags: []
```

Use Write tool to create project README at `organizations/$ORG_NAME/projects/$PROJECT_NAME/README.md`:
```markdown
# Project Name

Project knowledge base within Organization Name.

## Structure
- context-library/ - Project knowledge
- conversations/ - Work sessions
  - artifacts/ - Supporting files (PDFs, images, data files, etc.)
```

Display confirmation:
```
✓ Project 'project-name' created

Proceeding with session initialization...
```

### Phase 4: Load Context Libraries (Progressive Disclosure)

**Three-tier loading to stay within token budget.**

#### Tier 1: Load Context Metadata (Always)

Use Glob tool to discover all context library files.

For organization context:
```
organizations/$ORG_NAME/context-library/**/*.md
```

For project context (if project specified):
```
organizations/$ORG_NAME/projects/$PROJECT_NAME/context-library/**/*.md
```

For each file found, extract metadata only (don't load full content yet).

Use Bash tool to get file info:
```bash
# For each context file
for FILE_PATH in [glob-results]; do
  FILE_SIZE=$(wc -c < "$FILE_PATH")
  FILE_SIZE_KB=$((FILE_SIZE / 1024))

  # Extract title from first heading
  TITLE=$(head -n 20 "$FILE_PATH" | grep -m 1 '^# ' | sed 's/^# //' || echo "$(basename "$FILE_PATH" .md)")

  # Get last modified date (cross-platform)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    LAST_MODIFIED=$(stat -f %Sm -t "%Y-%m-%d" "$FILE_PATH")
  else
    LAST_MODIFIED=$(stat -c %y "$FILE_PATH" | cut -d' ' -f1)
  fi

  # Determine category from directory structure
  CATEGORY=$(dirname "$FILE_PATH" | xargs basename)

  # Estimate tokens (rough: 1 char ≈ 0.25 tokens)
  ESTIMATED_TOKENS=$((FILE_SIZE / 4))

  echo "$FILE_PATH|$TITLE|$CATEGORY|$FILE_SIZE_KB|$LAST_MODIFIED|$ESTIMATED_TOKENS"
done
```

Store metadata for all files (file path, title, category, size, modified date, estimated tokens).

Calculate total estimated tokens if all files loaded.

Display context catalog:
```
Available Context Libraries ([total-count] files):

Organizational Context ([org-count]):
  • [title] ([category], [size]KB, updated [date])
  • [title] ([category], [size]KB, updated [date])
  ...

Project Context ([project-count]):
  • [title] ([category], [size]KB, updated [date])
  • [title] ([category], [size]KB, updated [date])
  ...

Token budget: 50,000 tokens available
Estimated if all loaded: [total-estimate] tokens
```

#### Tier 2: Selective Loading

**If total estimated tokens ≤ 50,000:**
- Auto-load all context files using Read tool
- Display confirmation
- Proceed to Phase 5

**If total estimated tokens > 50,000:**

Ask user what to load:

```
Context exceeds token budget.

Load options:
  1. Essential only (org core + project overview) - ~10K tokens
  2. Recent only (updated last 7 days) - ~[estimate]K tokens
  3. Category-specific (choose: architecture/decisions/patterns/research/other)
  4. Let me choose specific files
  5. Load all anyway (may hit limits)

Choice: [wait for user input or auto-select #1 if non-interactive]
```

Based on selection:

**Option 1: Essential only**
- Load organization _organizational/*.md files
- Load project README.md (if exists)
- Load project _organizational/*.md files (if exists)

**Option 2: Recent only**
- Use Bash tool to filter files modified in last 7 days:
```bash
# Filter to files modified in last 7 days
find "$REPO_PATH/organizations/$ORG_NAME/context-library" -name "*.md" -type f -mtime -7
find "$REPO_PATH/organizations/$ORG_NAME/projects/$PROJECT_NAME/context-library" -name "*.md" -type f -mtime -7 2>/dev/null
```
- Load filtered files with Read tool

**Option 3: Category-specific**
- Ask user to choose category from detected categories
- Filter files by category (based on directory structure)
- Load matching files with Read tool

**Option 4: Let me choose**
- Display numbered list of all files with metadata
- Ask user to enter numbers (comma-separated) or ranges
- Load selected files with Read tool

**Option 5: Load all anyway**
- Use Read tool to load all files
- Display warning about potential token limits
- Proceed (may trigger model context limit handling)

For all options, use Read tool to load selected files and accumulate context content.

Display loaded context summary:
```
Context Loaded:
  • [file-1-title] ([category], [tokens] tokens)
  • [file-2-title] ([category], [tokens] tokens)
  • [file-3-title] ([category], [tokens] tokens)
  ...

  Total: [sum] / 50,000 tokens used

Available for on-demand: [remaining-count] files
Request more: "Load context about [topic]"
```

#### Tier 3: On-Demand During Session

Context is now loaded and session proceeds.

During the session, user can request additional context with:
```
"Load context about [topic]"
"Load the [filename] context"
"Show me the architecture context"
```

See "On-Demand Context Loading" section below for handling these requests.

### Phase 5: Review Recent Activity

Use Bash tool to get recent conversations (if conversations directory exists):
```bash
find "$REPO_PATH/organizations/$ORG_NAME/projects/$PROJECT_NAME/conversations" \
  -name "*.md" -type f -mtime -7 \
  -exec ls -t {} + 2>/dev/null | head -5
```

Display conversation file names (last 5, past 7 days).

Use Bash tool to get recent commits:
```bash
cd "$REPO_PATH" && git log --pretty=format:'%ar|%s' -5 --since="7 days ago"
```

Display recent commits (last 5, past week).

Use Read tool to load .kaaos/state/agent-executions.json.

Use Bash tool with jq to find recent executions:
```bash
cat .kaaos/state/agent-executions.json | jq -r --arg since "$(date -u +%s -d '7 days ago')" '
  .executions[] |
  select(.started_at > ($since | tonumber) * 1000) |
  "\(.agent_type)|\(.status)|\(.started_at)"
' | head -5
```

Format and display recent agent activity.

### Phase 6: Check for Running Agents

Use Bash tool with jq to find currently running agents:
```bash
cat .kaaos/state/agent-executions.json | jq -r '
  .executions[] |
  select(.status == "running") |
  "\(.agent_type)|\(.execution_id)|\(.started_at)"
'
```

If any running agents found, display warning:
```
Running Agents:
  • [agent-type] (started [time-ago])
```

### Phase 7: Load Recent Digests

Use Bash tool to find most recent daily digest:
```bash
ls -t "$REPO_PATH/.digests/daily"/*.md 2>/dev/null | head -1
```

If recent digest exists (within 7 days), use Read tool to load it.

Extract key highlights from digest (first 5-10 lines or summary section).

Display digest highlights if available.

### Phase 8: Save Session State

Use Read tool to load .kaaos/state/system-state.json.

Use Bash tool with jq to update session state:
```bash
cat .kaaos/state/system-state.json | jq \
  --arg org "$ORG_NAME" \
  --arg proj "$PROJECT_NAME" \
  --arg time "$(date -u +%s)000" \
  '.current_session = {
    organization: $org,
    project: $proj,
    started_at: ($time | tonumber),
    copilot_active: true
  }' > .kaaos/state/system-state.json.tmp

mv .kaaos/state/system-state.json.tmp .kaaos/state/system-state.json
```

### Phase 9: Present Session Summary

Display comprehensive session initialization summary:

```
┌─────────────────────────────────────────────────────────────┐
│              KAAOS Session Initialized                      │
└─────────────────────────────────────────────────────────────┘

CONTEXT
  Organization: [org-name]
  Project: [project-name or "Organization-wide"]

  Context Libraries Loaded: [count]
    • [library-1-name]
    • [library-2-name]
    • [library-3-name]

  Token Budget Used: ~[estimate] / 50,000

RECENT ACTIVITY (7 days)
  Conversations: [count]
    • [conversation-file-1]
    • [conversation-file-2]

  Recent Commits: [count]
    • [commit-message-1]
    • [commit-message-2]

  Agent Executions: [count]
    • [agent-type] ([status])

CURRENT STATUS
  Running Agents: [count]
  Latest Digest: [date/time]
  Co-pilot: Active (ready to assist)

───────────────────────────────────────────────────────────────

Your KAAOS co-pilot is active and ready to help with:
  • Context navigation and search
  • Answering questions about loaded knowledge
  • Suggesting related notes and patterns
  • Tracking decisions during this session

Quick commands:
  • Spawn research: /kaaos:research "topic"
  • Check status: /kaaos:status
  • View digest: /kaaos:digest daily
```

Replace all bracketed placeholders with actual loaded values.

### Phase 10: Activate Proactive Copilot Mode

Display copilot activation message and instructions:

```
┌─────────────────────────────────────────────────────────────┐
│       KAAOS PROACTIVE COPILOT MODE: ACTIVE                  │
└─────────────────────────────────────────────────────────────┘

ORCHESTRATOR INSTRUCTIONS (Critical - Follow Exactly):

You are now in KAAOS Proactive Copilot Mode for this session.

═══════════════════════════════════════════════════════════════
BEFORE RESPONDING TO ANY USER MESSAGE:
═══════════════════════════════════════════════════════════════

1. Extract 2-3 key topics from user's message

2. Search context library for related content:
   grep -ril "topic1\|topic2" $REPO_PATH/organizations/$ORG_NAME/context-library 2>/dev/null | head -5

3. If matches found, mention proactively:
   "💡 Found relevant context:
    - [filepath] - [one-line description]

    Load for reference? (say 'load' or continue)"

4. Then proceed with user's request

═══════════════════════════════════════════════════════════════
BEFORE CREATING OR EDITING FILES:
═══════════════════════════════════════════════════════════════

When about to Write/Edit files in context-library:
- Search for existing related files (avoid duplicates)
- Check for conflicts with existing decisions
- Suggest adding cross-references using [[notation]]

═══════════════════════════════════════════════════════════════
WHEN PERFORMING RESEARCH:
═══════════════════════════════════════════════════════════════

BEFORE using WebSearch/WebFetch:
1. Check for existing research:
   ls -t $REPO_PATH/organizations/*/context-library/research/*.md | head -10
   grep -ril "[topic]" $REPO_PATH/organizations/*/context-library/research

2. If existing research found from last 30 days:
   "Found existing research on [topic] from [date].
    Should I build on this (recommended) or start fresh?"

AFTER completing research:
1. Automatically save to: organizations/$ORG_NAME/context-library/research/[topic-slug]-[date].md
2. Format:
   # Research: [Topic]
   **Date**: [YYYY-MM-DD]
   **Sources**: [links]

   ## Key Findings
   [Bullet points]

   ## Implications
   [How this applies]

   ## Related Context
   [[cross-references]]

3. Notify: "✓ Research saved to research/[filename]"

═══════════════════════════════════════════════════════════════
PROACTIVE PATTERN DETECTION:
═══════════════════════════════════════════════════════════════

Every 8-10 user messages, check if conversation has:
- Made important decisions → suggest documenting in decisions/
- Identified patterns → suggest capturing in patterns/
- Developed frameworks → suggest formalizing in context-library/

Suggest: "This conversation has covered [topic] comprehensively.
          Create context library entry? (decisions/patterns/playbook)"

═══════════════════════════════════════════════════════════════
PERSISTENCE:
═══════════════════════════════════════════════════════════════

Copilot mode stays ACTIVE until:
- User explicitly ends session
- /exit command

If uncertain whether copilot active after long conversation:
  jq -r '.current_session.copilot_active' $REPO_PATH/.kaaos/state/system-state.json

═══════════════════════════════════════════════════════════════

This mode is now ACTIVE. Copilot behavior will persist for this session.

───────────────────────────────────────────────────────────────
```

This message is displayed once but its instructions persist throughout the session.

## Context Loading Strategy

### Token Budget: 50,000 tokens

Phase 4 implements a **three-tier progressive disclosure pattern** to stay within token budget:

#### Tier 1: Metadata Only (Always Load)
- Scan all available context files
- Extract: title, category, size, last modified, estimated tokens
- Display catalog to user
- Calculate total estimated token count
- **Cost: ~100-500 tokens** (metadata only)

#### Tier 2: Selective Loading (User Choice)
If total tokens ≤ 50,000:
- Auto-load all context files
- Proceed to session

If total tokens > 50,000:
- Present loading options to user:
  1. **Essential only** (~10K tokens): Org core + project overview
  2. **Recent only** (~variable): Files updated in last 7 days
  3. **Category-specific**: Choose architecture/decisions/patterns/research
  4. **Custom selection**: User picks specific files
  5. **Load all**: Override budget (may hit limits)

Load selected context based on user choice.

#### Tier 3: On-Demand (During Session)
- User can request additional context anytime
- Search by topic, category, or filename
- Load incrementally as needed
- Track cumulative token usage

### Priority Allocation (for "Essential only" mode)

1. **Organization core context**: ~5,000-10,000 tokens
   - _organizational/*.md files
   - Key strategic documents

2. **Project core context**: ~5,000-10,000 tokens (if project specified)
   - Project README.md
   - Project _organizational/*.md files
   - Key project documents

3. **Reserved for on-demand**: ~30,000+ tokens
   - Additional context loaded during session
   - Architecture docs, decisions, patterns
   - Research and domain knowledge

### Loading Rules

**Tier 1 - Always scan (metadata only):**
- All organization context-library/*.md files
- All project context-library/*.md files (if project exists)
- Extract metadata, don't load content yet

**Tier 2 - Load based on user selection:**
- Essential mode: _organizational/*.md only
- Recent mode: Files modified in last 7 days
- Category mode: Files in selected category
- Custom mode: User-selected specific files
- All mode: Everything (may exceed budget)

**Tier 3 - On-demand during session:**
- User requests: "Load context about [topic]"
- Search matching files
- Load incrementally
- Track cumulative token usage

### Benefits of Progressive Loading

1. **Stay within budget**: Never accidentally exceed 50,000 tokens
2. **User control**: User decides what context to load
3. **Faster initialization**: Metadata scan is quick (~5 seconds)
4. **Flexible**: Load more context as needed during session
5. **Transparent**: User sees token usage and available context
6. **Scalable**: Works with 10 files or 1,000 files

### Example Token Usage

**Small context library (5 files, 25K tokens total):**
- Tier 1: 200 tokens (metadata)
- Tier 2: Auto-load all 25,000 tokens
- Total: 25,200 / 50,000 tokens
- Result: All context loaded, 24K tokens available for work

**Large context library (50 files, 200K tokens total):**
- Tier 1: 500 tokens (metadata)
- Tier 2: User selects "Essential only" - 10,000 tokens
- Tier 3: User loads 3 more files during session - 15,000 tokens
- Total: 25,500 / 50,000 tokens
- Result: Core context + on-demand, 24K tokens available for work

### Progressive Loading UI Example

```
Available Context Libraries (47 files):

Organizational Context (23):
  • Enterprise Strategy (strategy, 45KB, updated 2026-01-12)
  • Security Standards (security, 28KB, updated 2026-01-10)
  • API Guidelines (standards, 19KB, updated 2026-01-08)
  ...

Project Context (24):
  • Architecture Overview (architecture, 52KB, updated 2026-01-13)
  • Domain Model (patterns, 31KB, updated 2026-01-11)
  • Integration Decisions (decisions, 22KB, updated 2026-01-09)
  ...

Token budget: 50,000 tokens available
Estimated if all loaded: 187,000 tokens

Context exceeds token budget.

Load options:
  1. Essential only (org core + project overview) - ~10K tokens
  2. Recent only (updated last 7 days) - ~23K tokens
  3. Category-specific (choose: architecture/decisions/patterns/research/other)
  4. Let me choose specific files
  5. Load all anyway (may hit limits)

Choice: 2

[Loading recent context files...]

Context Loaded:
  • Architecture Overview (architecture, ~13,000 tokens)
  • Domain Model (patterns, ~7,800 tokens)
  • Integration Decisions (decisions, ~5,500 tokens)

  Total: 26,300 / 50,000 tokens used

Available for on-demand: 44 files
Request more: "Load context about [topic]"

Ready to begin! What would you like to work on?
```

## On-Demand Context Loading (During Session)

This section describes how to handle user requests for additional context after the session has been initialized.

### Trigger Patterns

User requests like:
- "Load context about [topic]"
- "Load the [filename] context"
- "Show me the architecture context"
- "I need the [category] documentation"
- "Pull in context for [subject]"

### Execution Steps

**Step 1: Identify what user wants to load**

Parse the user request to extract:
- Topic/subject keywords
- Category name (architecture, decisions, patterns, research, etc.)
- Specific filename or file pattern

**Step 2: Search for matching files**

Use Grep tool to find relevant context files by content or filename:

```bash
# Search by topic in file content (case-insensitive)
grep -r -i "$TOPIC" "$REPO_PATH/organizations/$ORG_NAME/context-library" -l | head -10

# If project context exists
grep -r -i "$TOPIC" "$REPO_PATH/organizations/$ORG_NAME/projects/$PROJECT_NAME/context-library" -l 2>/dev/null | head -10
```

Or use Glob tool if user specified category/directory:
```
organizations/$ORG_NAME/context-library/$CATEGORY/**/*.md
organizations/$ORG_NAME/projects/$PROJECT_NAME/context-library/$CATEGORY/**/*.md
```

**Step 3: Present matches (if multiple found)**

If multiple files match, display options:
```
Found [count] context files matching "[topic]":

1. [title] ([category], [size]KB, updated [date])
2. [title] ([category], [size]KB, updated [date])
3. [title] ([category], [size]KB, updated [date])
...

Load: (1) specific file, (2) all matches, (3) cancel
```

Wait for user selection.

**Step 4: Load selected files**

Use Read tool to load the selected file(s).

Calculate token count for loaded content (estimate or actual).

**Step 5: Confirm loading**

Display confirmation:
```
Loaded [count] additional context file(s):
  • [title-1] ([category], ~[tokens] tokens)
  • [title-2] ([category], ~[tokens] tokens)

Total session context: ~[new-total] tokens

Ready. How does this context help?
```

### Example Interactions

**Example 1: Topic-based loading**
```
User: "Load context about authentication strategy"

You:
  [Use Grep to search for "authentication" in context files]
  [Find 2 matches: security/auth-patterns.md, decisions/oauth-migration.md]

  Found 2 context files about authentication:
  1. Authentication Patterns (security, 12KB, updated 2026-01-10)
  2. OAuth Migration Decision (decisions, 8KB, updated 2026-01-05)

  Load: (1) specific file, (2) all matches, (3) cancel

User: "2"

You:
  [Use Read tool to load both files]

  Loaded 2 additional context files:
    • Authentication Patterns (security, ~3,000 tokens)
    • OAuth Migration Decision (decisions, ~2,000 tokens)

  Total session context: ~25,000 tokens

  Ready. I can now help with authentication implementation.
```

**Example 2: Category-based loading**
```
User: "Show me all architecture documentation"

You:
  [Use Glob to find organizations/.../context-library/architecture/*.md]
  [Find 4 files]

  Found 4 architecture context files:
  1. System Architecture Overview (architecture, 45KB, updated 2026-01-12)
  2. Microservices Design (architecture, 28KB, updated 2026-01-08)
  3. Data Flow Patterns (architecture, 19KB, updated 2025-12-20)
  4. Integration Architecture (architecture, 32KB, updated 2026-01-02)

  This would add ~31,000 tokens (total: ~41,000 / 50,000).
  Load all? [Y/n]

User: "Y"

You:
  [Use Read tool to load all 4 files]

  Loaded 4 architecture context files (~31,000 tokens)
  Total session context: ~41,000 / 50,000 tokens

  Architecture context loaded. What would you like to design?
```

**Example 3: Specific file loading**
```
User: "Load the API design guidelines"

You:
  [Use Grep to search for filename pattern matching "api" and "design"]
  [Find 1 exact match: standards/api-design-guidelines.md]

  Loaded: API Design Guidelines (standards, ~4,500 tokens)
  Total session context: ~18,500 tokens

  API guidelines loaded. Ready to review or design APIs.
```

### Token Budget Tracking

Track cumulative token usage across initial load and on-demand loads.

If approaching 50,000 token budget, warn user:
```
Warning: Approaching token budget limit

Current: ~48,000 / 50,000 tokens
Remaining: ~2,000 tokens

Loading more context may trigger model limits.
Proceed? [Y/n]
```

If exceeding budget significantly (>70,000 tokens estimated), suggest alternatives:
```
Context budget exceeded (estimated ~75,000 tokens).

Alternatives:
  1. Start fresh session with different context selection
  2. Load anyway (may hit model limits)
  3. Cancel this load

Choice:
```

### Search Strategies

**By topic/keyword:**
```bash
grep -r -i "$KEYWORD" "$CONTEXT_PATH" -l | head -10
```

**By category (directory):**
```bash
find "$CONTEXT_PATH/$CATEGORY" -name "*.md" -type f
```

**By filename pattern:**
```bash
find "$CONTEXT_PATH" -name "*$PATTERN*.md" -type f
```

**By recent updates:**
```bash
find "$CONTEXT_PATH" -name "*.md" -type f -mtime -7
```

**Combined search (keyword + category):**
```bash
grep -r -i "$KEYWORD" "$CONTEXT_PATH/$CATEGORY" -l
```

### Error Handling

**No matches found:**
```
No context files found matching "[topic]".

Available categories:
  - architecture
  - decisions
  - patterns
  - research
  - security

Try: "Load context from [category]" or "List available context"
```

**File read error:**
```
Error loading context file: [filename]
Reason: [error message]

File may be corrupt or too large.
Skip and continue? [Y/n]
```

**Already loaded:**
```
Note: [filename] already loaded in this session.

Options:
  1. Skip (already in context)
  2. Reload (refresh content)

Choice:
```

## Error Handling

### Organization Not Found
```
Error: Organization '[org-name]' not found

Available organizations:
  - personal
  - company-x

Create new organization:
  /kaaos:init [org-name]
```

### Project Not Found (Auto-Created)

When project doesn't exist, command automatically creates it:
```
Project '[project]' not found in '[org]'.

✓ Creating new project '[project]'...
✓ Project structure created
✓ Metadata initialized

Proceeding with session...
```

Project is created with standard structure and metadata, then session continues normally.

### Context Loading Failed
```
Warning: Could not load some context libraries

Loaded: [count] files
Failed: [count] files
  - [file-path] (file corrupt or too large)

Session can proceed with available context.
```

### No Context Available
```
Warning: No context libraries found

Organization: [org-name]
Project: [project-name]

Consider:
  1. Create context library files in:
     [repo-path]/organizations/[org]/context-library/
  2. Document key knowledge
  3. Re-run session to load context
```

## Notes

- Context loading is read-only (no state changes except session record)
- Fast initialization target: < 30 seconds
- Cost efficient: < $0.10 (just context loading, no agent spawns)
- Token budget enforced to prevent context overflow
- Session state saved for other commands to reference
- Multiple file reads done in parallel when possible
- Glob patterns used for file discovery
- jq used for JSON manipulation in Bash
- All paths are absolute for reliability
