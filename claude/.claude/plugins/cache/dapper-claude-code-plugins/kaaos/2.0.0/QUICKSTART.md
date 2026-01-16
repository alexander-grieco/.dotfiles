# KAAOS Quick Start - The Complete Guide

**Everything you need to know about KAAOS in one place.**

Version: 1.0.0 | Status: Production Ready

---

## TL;DR - Start in 2 Minutes

**For impatient users - get started immediately:**

```bash
# 1. Install plugin
/plugin install kaaos

# 2. Initialize (checks for jq, offers to install if missing)
/kaaos:init personal

# 3. Start working
/kaaos:session personal/research
/kaaos:research "your first topic"

# That's it! Knowledge now compounds with semi-automated workflows:
# • Real-time co-pilot suggests related context as you work
# • Git hooks extract insights from every commit
# • SessionEnd hook organizes files automatically
# • Scheduled reviews with user-triggered processing (daily/weekly/monthly/quarterly)
```

**Done!** Continue reading below to understand what's happening.

---

## Enhanced Setup (Optional)

**For semantic cross-linking superpowers:**

```bash
# After installing KAAOS:
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem

# Restart Claude Code
# KAAOS auto-detects claude-mem and enables semantic features!
```

**What you get with claude-mem**:
- Semantic similarity detection (finds related content by meaning, not keywords)
- Auto-cross-linking based on concept similarity
- Smarter pattern detection (groups similar topics even with different words)
- Enhanced co-pilot (semantic suggestions, not just keyword matches)

**Cost**: claude-mem adds ~$10-20/month (runs background service)

**KAAOS works great without it** - this is purely optional enhancement.

---

## What is KAAOS?

**KAAOS** (Knowledge and Analysis Automated Orchestrated System) is a multi-agent knowledge management plugin for Claude Code that treats strategic thinking like software engineers treat code:

- **Git version control** for every conversation and insight
- **Multi-agent orchestration** with 7 specialized agents
- **Automated operational rhythms** (daily/weekly/monthly/quarterly reviews)
- **Zero-touch knowledge capture** via lifecycle hooks
- **Progressive context loading** to stay within token budgets
- **Cost controls** with actual usage tracking

**Core Philosophy**: AI maintains your knowledge infrastructure so you focus on strategic thinking, not knowledge archaeology.

---

## Installation

### Prerequisites

**Required**: `jq` (JSON manipulation)

**Don't worry** - `/kaaos:init` checks for jq and offers to install it if missing!

Manual install (if needed):
```bash
brew install jq
```

That's it! No databases, no build tools, no compilation.

### Install the Plugin

```bash
# Open Claude Code
claude-code

# Install from GitHub (when published)
> /plugin install github.com/yourusername/kaaos

# Or install from local directory
> /plugin install /Users/ben/src/kaaos

# Or link for development
> /plugin link /Users/ben/src/kaaos
```

Verify installation: Type `/kaaos` and hit TAB - you should see 7 commands.

---

## Setup (1 Command, 2 Minutes)

### One Command Does Everything

```bash
/kaaos:init personal
```

**Creates** `~/kaaos-knowledge/` with:
- Git repository (full version control)
- `.kaaos/` directory (state, config, insights)
- `organizations/personal/` structure
- JSON state files
- **Git hooks** (post-commit insights, pre-push validation)
- **Lifecycle hooks** (real-time co-pilot, auto-organization)
- **Automation** (launchd agents for scheduled reviews)
- **Everything configured and ready!**

**Semi-automated scheduling included**:
- Daily review markers: 7:00 AM (processed when you open Claude Code)
- Weekly synthesis markers: Monday 6:00 AM
- Monthly review markers: 1st at 5:00 AM
- Quarterly analysis markers: Jan/Apr/Jul/Oct 1st at 3:00 AM

### Verify Setup

```bash
/kaaos:status
```

**Shows**:
- ✓ Repository initialized
- ✓ Hooks active (lifecycle + git)
- ✓ Automation enabled (daily/weekly/monthly/quarterly)
- ✓ Real-time co-pilot ready
- ✓ File auto-organization enabled
- ✓ Ready to use

**Done! You're ready to start building compounding knowledge.**

### Optional: Manage Automation Later

```bash
/kaaos:automation status    # See what's running
/kaaos:automation disable   # Turn off if needed
/kaaos:automation enable    # Turn back on
```

---

## How Automation Works

KAAOS uses **semi-automated scheduling** that works in two phases:

### Phase 1: Scheduled Markers (Fully Automated)

- macOS launchd runs at scheduled times:
  - Daily: 7:00 AM
  - Weekly: Monday 6:00 AM
  - Monthly: 1st of month, 5:00 AM
  - Quarterly: Jan/Apr/Jul/Oct 1st, 3:00 AM
- Shell scripts check budgets and create "pending" markers
- Scripts exit immediately without invoking Claude Code

### Phase 2: User-Triggered Processing

- User opens Claude Code or runs any KAAOS command
- Commands detect pending markers in "Phase 0"
- Background agents spawn asynchronously to process reviews
- User continues working while reviews complete in background

### User Experience

**Morning (7:00 AM)**: launchd runs silently, creates daily-pending marker

**You Open Claude (9:00 AM)**:
```
[Processing in background]
  • Daily review started (background agent)
  • Will complete in ~5 minutes
  • View when ready: /kaaos:digest daily
```

**You Continue Working**: Review processes in background

**Later**: `/kaaos:digest daily` (view completed digest)

### Requirement

**You must open Claude Code at least once per day** to trigger pending automation. This is the only user action required.

### Optional Enhancement

Create macOS Shortcut to auto-open Claude Code at a specific time:
- Shortcuts app → New Shortcut
- Add "Open App" → Claude Code
- Schedule for 8:00 AM daily
- This + launchd = fully hands-off

---

## How It Works (The Magic)

### 1. Lifecycle Hooks Capture Everything

**PostToolUse Hook** (REAL-TIME CO-PILOT):
- Fires after every Write, Edit, WebSearch, WebFetch
- Captures tool usage: `.kaaos/insights/tool-usage/[timestamp].json`
- **Analyzes in real-time** and suggests related context
- **Immediately injects**: "💡 Related context: [file.md]"
- Example: You create new agent → Hook suggests: "See error handling in research-agent.md:145"
- **Zero user action** - happens automatically!

**SessionEnd Hook** (FILE AUTO-ORGANIZATION):
- Summarizes session activity
- **Auto-organizes orphaned files** to correct locations
- Moves Research files → context-library/research/
- Moves Decision files → context-library/decisions/
- Cleans up empty directories
- Removes old temp files
- Logs organization actions

**SessionStart Hook**:
- Checks for pending automation
- Notifies: "Daily review pending - will process on first command"

### 2. Git Hooks Extract Insights

**Every commit**:
```bash
git commit -m "Implemented authentication pattern"
```

**Post-commit hook analyzes**:
- Commit message → Detects "pattern" → Architecture insight
- Changed files → `auth/` → Domain insight
- Documentation changes → `.md` files → Knowledge update

**Saves**: `.kaaos/insights/pending/[commit-sha].json`

**Result**: Insights captured with zero user time!

### 3. Semi-Automated Processing

**7:00 AM**: Launchd runs `daily-review.sh`
- Creates `.kaaos/automation/daily-pending`
- Exits

**8:30 AM**: You open Claude Code and run any command
```bash
/kaaos:status
```

**Phase 0 (automatic)**:
- Detects: `daily-pending` exists
- Spawns: Background Task agent (Sonnet)
- Deletes: Marker file
- **Continues**: Shows status (you're not blocked!)

**Background** (10 minutes):
- Agent loads pending insights
- Analyzes git history
- Generates digest
- Commits: `.digests/daily/2026-01-13.md`

**8:45 AM**: You read it
```bash
/kaaos:digest daily
```

**Impact**: ~95% automated - you just need to trigger once per day!

### 4. Progressive Context Loading

**When you start a session**:
```bash
/kaaos:session personal/research
```

**Tier 1 - Metadata scan** (~1K tokens):
```
Available Context Libraries (12 files):

Organizational (4 files):
  • Company Strategy (strategic, 15KB, Jan 10)
  • Team Playbook (organizational, 8KB, Jan 12)

Project (8 files):
  • Architecture Decisions (architecture, 12KB, Jan 13)
  • Error Patterns (patterns, 6KB, Jan 12)
  • Research: Plugin Systems (research, 25KB, Jan 11)

Token budget: 50,000 available
Estimated if all loaded: 78,000 tokens ⚠️
```

**Tier 2 - Selective loading**:
```
Context exceeds budget. Load options:
  1. Essential only (org core + project overview) - ~10K tokens
  2. Recent only (last 7 days) - ~18K tokens
  3. Category-specific (architecture/decisions/patterns/research)
  4. Let me choose specific files
  5. Load all anyway

Choice: 1

✓ Loaded 4 essential files (9,456 tokens)
```

**Tier 3 - On-demand**:
```
[During session]
User: "Load the enterprise strategy context"
Claude: [Finds matching files, loads, displays]
     "Loaded 2 additional files (5,234 tokens)"
```

**Impact**: Never exceed budget, user stays in control, 10x better!

---

## The 7 Commands

### /kaaos:init [org-name]

Initialize KAAOS repository.

```bash
/kaaos:init personal
/kaaos:init company-x ~/work/company-x-knowledge
```

Creates: Git repo, directory structure, config, state files, git hooks.

### /kaaos:session [org]/[project]

Start context-aware work session.

```bash
/kaaos:session personal/research
/kaaos:session company-x/strategy-2026
```

Features:
- Auto-creates project if missing
- Progressive context loading (3-tier)
- Reviews recent history
- Loads relevant knowledge within budget

### /kaaos:research [topic]

Perform research and generate comprehensive report.

```bash
/kaaos:research "multi-agent orchestration patterns"
/kaaos:research "enterprise pricing strategies"
```

What happens:
- YOU (Claude) perform the research using WebSearch/Glob/Grep
- Generate comprehensive markdown report
- Save to context library
- Include token usage metadata
- Commit to git

### /kaaos:review [daily|weekly|monthly|quarterly]

Generate periodic review digest.

```bash
/kaaos:review daily      # ~$0.30, 5-10 min read
/kaaos:review weekly     # ~$4-5, 30-60 min session
/kaaos:review monthly    # ~$10-15, 2-3 hour session
/kaaos:review quarterly  # ~$40-50, half-day session (4 parallel agents!)
```

**Quarterly is special**: Spawns 4 parallel Opus agents for comprehensive analysis:
1. Strategic Alignment Analyst
2. Knowledge Graph Optimizer
3. Content Quality Auditor
4. Cross-Organization Analyst

All run simultaneously via Task tool!

### /kaaos:status

Display comprehensive system status.

```bash
/kaaos:status
```

Shows:
- Configuration and health
- Recent activity
- Pending automation
- Cost tracking (actual usage!)
- Budget status

### /kaaos:digest [period] [date]

View generated digests.

```bash
/kaaos:digest daily
/kaaos:digest weekly 2026-W02
/kaaos:digest monthly 2026-01
/kaaos:digest quarterly 2026-Q1
```

Features:
- Navigation hints (previous/next)
- Generate missing digests on request
- Formatted display

### /kaaos:automation [install|enable|disable|status]

Manage automated reviews.

```bash
/kaaos:automation install   # Create scripts and launchd agents
/kaaos:automation enable    # Enable scheduling
/kaaos:automation status    # Check what's running
/kaaos:automation disable   # Turn off automation
```

---

## Daily Workflow

**Morning** (8:30 AM - you slept through the 7 AM schedule):

```bash
# Open Claude Code, run any command
/kaaos:status
```

**You see**:
```
[Processing in background]
  • Daily review started (background agent)
  • Will complete in ~10 minutes

┌─────────────────────────────────────────────────────────────┐
│                    KAAOS System Status                       │
└─────────────────────────────────────────────────────────────┘

[Normal status output...]
```

**During the day**:
```bash
# Start work
/kaaos:session personal/research

# Work normally - insights captured automatically!
# • PostToolUse hook captures Write/Edit/WebSearch
# • Git hook captures commit insights
# • Session end hook summarizes activity

# Research when needed
/kaaos:research "error handling best practices"
```

**End of day** (10 minutes):
```bash
# Read digest
/kaaos:digest daily
```

**User time**: ~11 minutes (30 sec trigger + 10 min reading)
**AI time**: Automatic (background)
**Knowledge**: Captured, synthesized, ready!

---

## Weekly Workflow

**Monday morning** (6 AM schedule ran):

```bash
# Your first command
/kaaos:session personal/strategy
```

**You see**:
```
[Processing in background]
  • Weekly synthesis started (background agent)
  • Will complete in ~30 minutes

[Session loads with progressive context...]
```

**30 minutes later** (60-minute session):
```bash
# Read synthesis
/kaaos:digest weekly
```

**Review shows**:
- Patterns discovered (7 patterns)
- Gaps identified (3 gaps)
- Playbook updates proposed (5 updates)
- Recommendations for next week

**Act on insights**:
- Spawn research for gaps
- Update playbooks
- Set priorities

**User time**: 60 minutes (30 sec trigger + strategic session)
**AI time**: 30 min background synthesis
**Value**: Strategic clarity for the week!

---

## Monthly & Quarterly Workflows

**Monthly** (first weekend):
```bash
/kaaos:digest monthly  # Read comprehensive review
# 2-3 hour strategic alignment session
```

**Quarterly** (end of quarter):
```bash
/kaaos:review quarterly  # Spawns 4 parallel agents!
# Wait for completion notifications
/kaaos:digest quarterly  # Half-day strategic reflection
```

**4 agents analyze in parallel**:
- Strategic evolution
- Knowledge graph health
- Content quality
- Cross-organization patterns

**User time**: Half-day for strategic session
**AI time**: 8-12 hours (parallel execution)
**Value**: Comprehensive strategic review!

---

## What Gets Captured Automatically

### Tool Usage (PostToolUse Hook)

**Every Write/Edit**:
```bash
Write tool creates: agents/new-agent.md
→ Hook captures: tool-usage/[timestamp].json
  {
    "tool": "Write",
    "file": "agents/new-agent.md",
    "session": "2026-01-13-0830"
  }
```

**Every WebSearch/WebFetch**:
```bash
WebSearch: "Claude Code plugin patterns"
→ Hook captures: research/[timestamp].json
  {
    "tool": "WebSearch",
    "session": "2026-01-13-0830"
  }
```

### Git Commits (Post-Commit Hook)

**Pattern detection**:
```bash
git commit -m "Added error handling to research agent"

# Hook detects:
• "error handling" → Pattern insight
• "research agent" → Architecture insight
• Changed: agents/research-agent.md → Agent modification

# Saves: insights/pending/[commit-sha].json
```

### Session Activity (SessionEnd Hook)

**When session ends**:
- Counts tool usage insights captured
- Creates session summary
- Logs activity

---

## Cost Tracking (Actual Usage)

### Agents Self-Report Tokens

**Every agent includes in output**:
```markdown
## Execution Metadata
- Input tokens: 15,234 (context loaded)
- Output tokens: 3,456 (report generated)
- Total: 18,690
- Estimated cost: $0.23 (Sonnet rates)
```

### Commands Record Actual Costs

**After agent completes**:
```bash
# Parse metadata from output
INPUT_TOKENS=$(grep "Input tokens:" output.md | grep -o '[0-9,]*')
OUTPUT_TOKENS=$(grep "Output tokens:" output.md | grep -o '[0-9,]*')

# Record in state
jq '.executions[-1].input_tokens = '$INPUT_TOKENS' state.json
```

### Budget Enforcement Uses Actuals

**Pre-flight checks**:
```bash
# Before spawning agent
SPENT_TODAY=$(jq '[.executions[] | select(.started_at > today) | .cost_usd] | add' state.json)
DAILY_LIMIT=$(yq '.cost_controls.daily_limit_usd' config.yaml)

if [ $SPENT_TODAY + $ESTIMATE > $DAILY_LIMIT ]; then
  echo "Budget exceeded!"
fi
```

**Result**: Accurate cost management, no surprises!

---

## File Structure

### Your KAAOS Repository
```
~/kaaos-knowledge/
├── .git/                        # Version control
├── .kaaos/
│   ├── config.yaml              # Configuration
│   ├── state/
│   │   ├── agent-executions.json  # Execution history with token counts
│   │   ├── context-items.json     # Knowledge metadata
│   │   ├── schedules.json         # Review schedules
│   │   └── system-state.json      # Current session info
│   ├── insights/
│   │   ├── pending/               # Unprocessed insights
│   │   ├── tool-usage/            # Tool usage captures
│   │   ├── research/              # Research activity
│   │   └── sessions/              # Session summaries
│   ├── automation/
│   │   ├── daily-pending          # Marker files
│   │   ├── weekly-pending
│   │   └── [etc.]
│   ├── locks/                     # File locks
│   └── logs/                      # Operation logs
├── organizations/
│   └── personal/
│       ├── context-library/       # Organizational knowledge
│       │   └── _organizational/
│       └── projects/
│           └── research/
│               ├── context-library/  # Project knowledge
│               │   ├── architecture/
│               │   ├── decisions/
│               │   ├── patterns/
│               │   └── research/
│               └── conversations/    # Session logs
└── .digests/                      # Generated digests
    ├── daily/
    ├── weekly/
    ├── monthly/
    └── quarterly/
```

### The Plugin (Entirely Contained)
```
kaaos/ (in ~/.claude/plugins/cache/)
├── .claude-plugin/
│   └── plugin.json
├── hooks/                   # Lifecycle hooks
│   ├── hooks.json
│   ├── session-start.sh
│   ├── post-tool.sh
│   └── session-end.sh
├── agents/                  # 7 agent personas
├── commands/                # 7 orchestration commands
└── skills/                  # 3 knowledge skills
```

---

## The 7 Agents

| Agent | Model | Purpose | When Active |
|-------|-------|---------|-------------|
| **Orchestrator** | Opus | Central coordinator | All commands |
| **Research** | Sonnet | Deep investigation | /kaaos:research |
| **Synthesis** | Opus | Pattern extraction | Reviews |
| **Maintenance** | Sonnet | Repository health | Post-review |
| **Co-pilot** | Sonnet | Session assistance | Sessions with --copilot |
| **Gap Detector** | Sonnet | Find missing knowledge | Weekly reviews |
| **Strategic Reviewer** | Opus | Quarterly analysis | Quarterly (4 parallel!) |

**Model Strategy**:
- **Opus** ($15/M input, $75/M output): Strategic reasoning, synthesis
- **Sonnet** ($3/M input, $15/M output): Research, maintenance, assistance

---

## Operational Rhythms

### Real-Time (Zero User Time)

**PostToolUse hook**: Captures every tool use
**Post-commit hook**: Extracts insights from commits
**SessionEnd hook**: Summarizes activity

**User time**: 0 minutes
**AI time**: Instant (pattern matching)
**Cost**: $0 (just file operations)

### Daily (5-10 Minutes User Time)

**Schedule**: 7:00 AM daily
**Automation**: Launchd creates `daily-pending`
**Trigger**: Any KAAOS command you run
**Execution**: Background Sonnet agent (~10 min)
**Output**: `.digests/daily/YYYY-MM-DD.md`

**User workflow**:
```bash
# Morning coffee
/kaaos:digest daily

# 5 minutes reading:
# - Yesterday's key developments
# - Insights extracted
# - Items requiring attention
```

**User time**: 5-10 min reading
**Trigger time**: 30 seconds
**Total**: ~11 minutes

### Weekly (30-60 Minutes User Time)

**Schedule**: Monday 6:00 AM
**Execution**: Background Opus agent (~30 min)
**Output**: `.digests/weekly/YYYY-Wnn.md`

**User workflow**:
```bash
# Monday morning
/kaaos:digest weekly

# 30-60 min strategic session:
# - Patterns discovered (5-10 patterns)
# - Gaps identified (3-5 gaps)
# - Playbook updates proposed
# - Act on recommendations
```

### Monthly (2-3 Hours User Time)

**Schedule**: 1st of month, 5:00 AM
**Execution**: Background Opus agent (~60 min)
**Output**: `.digests/monthly/YYYY-MM.md`

**User workflow**:
```bash
# First weekend
/kaaos:digest monthly

# 2-3 hour strategic session:
# - Strategic evolution analysis
# - Knowledge graph health
# - Major accomplishments
# - Set next month priorities
```

### Quarterly (Half-Day User Time)

**Schedule**: Jan/Apr/Jul/Oct 1st, 3:00 AM
**Execution**: 4 parallel Opus agents (~2-4 hours)
**Output**: `.digests/quarterly/YYYY-Qn.md`

**User workflow**:
```bash
# End of quarter
/kaaos:review quarterly  # Spawns 4 parallel agents

# Wait for all 4 to complete
# Read: /kaaos:digest quarterly

# Half-day strategic reflection:
# - 4 comprehensive analyses
# - Strategic pivots identified
# - Knowledge base audit
# - Next quarter priorities
```

**Impact**: Comprehensive review with 8-12 hours of parallel AI analysis!

---

## Example Session

```bash
$ claude-code

# SessionStart hook checks automation
KAAOS: Daily review pending - will process on first command

$ /kaaos:session personal/research

# Phase 0 - Automation
[Processing in background]
  • Daily review started (background agent abc-123)
  • Will complete in ~10 minutes

# Phase 4 - Progressive Loading
Available Context (8 files, ~45K tokens):

Organizational (3):
  • Research Methodology (research, 12KB, Jan 10)
  • Company Strategy (strategic, 15KB, Jan 08)

Project (5):
  • Plugin Patterns (patterns, 8KB, Jan 12)
  • Architecture Decisions (architecture, 10KB, Jan 11)

Token budget: 50,000 available
All files within budget ✓

✓ Loaded 8 context files (42,345 tokens)

┌─────────────────────────────────────────────────────────────┐
│              KAAOS Session Initialized                      │
└─────────────────────────────────────────────────────────────┘

CONTEXT
  Organization: personal
  Project: research
  Context loaded: 8 files (42K tokens)

RECENT ACTIVITY
  Last session: Yesterday 2:30 PM
  Recent commits: 5
  Pending insights: 12 (will integrate in daily review)

Ready! What would you like to work on?

$ /kaaos:research "progressive disclosure patterns"

# PostToolUse hook fires after WebSearch
💡 Existing research: organizations/personal/context-library/research/context-loading-2026-01-10.md

# Research executes using WebSearch, Glob, Grep
# Generates comprehensive report
# Includes token metadata:
#   Input: 8,234 tokens
#   Output: 2,156 tokens
#   Cost: $0.12

# PostToolUse hook fires after Write tool
💡 Related context: skills/session-management/references/context-loading-strategies.md

Research Complete!
Output: context-library/research/progressive-disclosure-patterns-2026-01-13.md
Cost: $0.12 (actual)

$ git commit -m "Added progressive disclosure research"

# Post-commit hook fires
# Extracts: "progressive disclosure" pattern
# Saves: .kaaos/insights/pending/[sha].json

$ /kaaos:status

✓ Daily review completed (background agent finished!)

Daily spending: $1.45 / $5.00 (29%)
Recent executions: 3 (research, daily-review, maintenance)

$ /kaaos:digest daily

# Read yesterday's digest with integrated insights

[Session end]

# SessionEnd hook fires automatically:
# 1. Summarizes: 2 research tasks, 5 tool uses, 3 commits
# 2. Auto-organizes: Moves orphaned research.md → context-library/research/
# 3. Cleans up: Removes empty dirs, old temp files
# 4. Logs: "Organized 1 file, cleaned 2 temp files"
# 5. Saves: .kaaos/insights/sessions/2026-01-13-0830.json

You arrive tomorrow to groomed slopes - everything organized!
```

---

## Configuration

Edit `~/kaaos-knowledge/.kaaos/config.yaml`:

```yaml
# Cost controls
cost_controls:
  daily_limit_usd: 5.00      # Change if needed
  weekly_limit_usd: 25.00
  monthly_limit_usd: 100.00
  alert_threshold_percent: 80  # Alert at 80%
  hard_stop_on_limit: true     # Stop at limit

# Automation schedules
rhythms:
  daily:
    enabled: true
    hour: 7                    # 7 AM (change if needed)
    minute: 0
  weekly:
    enabled: true
    weekday: 1                 # Monday (0=Sunday, 6=Saturday)
    hour: 6
    minute: 0
  # monthly, quarterly...

# Features
features:
  git_hooks: true              # Post-commit insights
  copilot_suggestions: true    # Real-time co-pilot suggestions (PostToolUse hook)
  auto_organization: true      # Auto-organize files (SessionEnd hook)
  auto_maintenance: true       # Automatic maintenance
  parallel_quarterly: true     # 4 parallel quarterly agents

# To disable co-pilot suggestions:
# copilot_suggestions: false

# To disable auto-organization:
# auto_organization: false

# Models
models:
  orchestrator: opus           # Central coordination
  research: sonnet             # Cost-effective research
  synthesis: opus              # Deep pattern extraction
  # [etc.]
```

---

## Troubleshooting

### Plugin Not Loading
```bash
# Check installed plugins
claude-code plugin list

# Reinstall
/plugin install /Users/ben/src/kaaos
```

### Hooks Not Firing
Check hooks are executable:
```bash
ls -la ~/.claude/plugins/cache/*/kaaos/*/hooks/*.sh
# Should show: -rwxr-xr-x (executable)
```

### Automation Not Running
```bash
/kaaos:automation status

# Check launchd
launchctl list | grep kaaos

# Reinstall if needed
/kaaos:automation install
/kaaos:automation enable
```

### Budget Exceeded
```bash
# Check spending
/kaaos:status

# Adjust limits
vim ~/kaaos-knowledge/.kaaos/config.yaml
# Increase daily_limit_usd or monthly_limit_usd
```

### Context Loading Slow
```bash
# Use progressive loading
/kaaos:session personal/project

# When prompted, choose:
# Option 1: Essential only
# Or Option 2: Recent only

# Load more on-demand during session
```

---

## Key Concepts

### Zero-Touch Knowledge Capture

**You just work**:
- Write files → PostToolUse hook captures
- Research web → PostToolUse hook captures
- Commit code → Git hook extracts insights
- End session → SessionEnd hook summarizes

**Knowledge captured automatically!**

### Compounding Knowledge

**Over time**:
- Week 1: 10 insights captured
- Week 4: 50 insights, 8 patterns identified
- Month 3: 200 insights, 25 patterns, playbooks created
- Year 1: 2,500 insights, context library is gold mine

**Every new conversation leverages all prior knowledge!**

### Git-Backed Everything

**Benefits**:
- `git log` - See all knowledge evolution
- `git grep "pattern"` - Search across all time
- `git blame` - Who created this insight, when?
- `git checkout old-commit` - Resume any historical state
- `git diff` - See how understanding evolved

**Your knowledge base IS a git repository!**

---

## What Makes KAAOS Different

vs **Notion/Roam**: Version control, multi-agent synthesis, automation
vs **Claude.ai**: Multi-org, context persistence, operational rhythms
vs **claude-mem**: Long-term strategic (years), hierarchical structure, pure plugin
vs **Linear/Jira**: Knowledge management (not tasks), strategic synthesis

**KAAOS is**: Git-backed knowledge that compounds over years with AI maintenance.

---

## Success in 90 Days

**Month 1**:
- 100+ insights captured automatically
- 30 daily digests
- 4 weekly syntheses
- 10 research reports

**Month 2**:
- Patterns emerge across weeks
- Playbooks created from repeated solutions
- Cross-references strengthen knowledge graph

**Month 3**:
- Monthly review shows strategic evolution
- Quarterly analysis (4 parallel agents!)
- Knowledge base is invaluable resource

**After 90 days**: You have institutional knowledge that would take weeks to rebuild manually.

---

## Support

- **Documentation**: This file has everything
- **Commands**: Type `/kaaos` + TAB to see all commands
- **Status**: `/kaaos:status` shows what's happening
- **Help**: `/kaaos:digest daily` to see example outputs

---

**You're ready to build compounding knowledge with KAAOS!** 🚀

Everything you need is in this guide. Just install, initialize, and start working - KAAOS handles the rest.
