# KAAOS Hooks System

Complete lifecycle hooks for automatic knowledge capture and automation.

## Overview

The KAAOS hooks system integrates with Claude Code's lifecycle events to:
- **Detect pending reviews** at session start
- **Capture tool usage** automatically (Write, Edit, WebSearch, etc.)
- **Summarize sessions** at session end

## Files

### hooks.json
Hook configuration defining 3 lifecycle events:
- `SessionStart` - Checks for pending automation
- `PostToolUse` - Captures every tool interaction
- `SessionEnd` - Summarizes session and commits insights

### session-start.sh
**Purpose**: Check for pending automation when Claude Code starts

**Behavior**:
- Finds KAAOS repo (~/kaaos-knowledge or current directory)
- Checks for pending review markers (daily, weekly, monthly, quarterly)
- Injects context message if pending reviews found
- Exits silently if no KAAOS repo or no pending reviews

**Output Example**:
```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "KAAOS: Pending reviews detected: daily weekly\n\nThese will be processed automatically..."
  }
}
```

### post-tool.sh
**Purpose**: Capture insights from every tool use

**Captured Tools**:
- `Write` / `Edit` - File modifications → `.kaaos/insights/tool-usage/`
- `WebSearch` / `WebFetch` - Research activities → `.kaaos/insights/research/`
- Other tools - Currently ignored (configurable)

**Output Format** (tool-usage):
```json
{
  "timestamp": 1705200000000,
  "tool": "Write",
  "file": "/path/to/file.txt",
  "session": "2024-01-14-0830",
  "processed": false
}
```

**Output Format** (research):
```json
{
  "timestamp": 1705200000000,
  "tool": "WebSearch",
  "session": "2024-01-14-0830",
  "processed": false
}
```

### session-end.sh
**Purpose**: Summarize session and commit insights

**Behavior**:
- Counts unprocessed tool usage insights
- Creates session summary in `.kaaos/insights/sessions/`
- Logs session end to `.kaaos/logs/sessions.log`
- Only creates summary if tool insights exist

**Output Format** (session summary):
```json
{
  "session_id": "2024-01-14-0830",
  "ended_at": 1705200000000,
  "tool_usage_count": 15,
  "processed": false
}
```

**Log Format**:
```
[2024-01-14T08:30:45-0800] Session 2024-01-14-0830 ended - 15 tool insights captured
```

## Directory Structure Created

```
.kaaos/
├── insights/
│   ├── tool-usage/         # Individual tool usage events
│   │   ├── 1705200001.json
│   │   └── 1705200002.json
│   ├── research/           # Research activity events
│   │   └── 1705200003.json
│   └── sessions/           # Session summaries
│       └── 2024-01-14-0830.json
├── logs/
│   └── sessions.log        # Session end log
└── automation/
    ├── daily-pending       # Pending review markers
    ├── weekly-pending
    ├── monthly-pending
    └── quarterly-pending
```

## Installation

The hooks are automatically registered when KAAOS plugin is loaded by Claude Code.

No manual installation required.

## Testing

### Test session-start.sh
```bash
# Without KAAOS repo (should exit silently)
./hooks/session-start.sh

# With KAAOS repo and pending reviews
mkdir -p ~/kaaos-knowledge/.kaaos/automation
touch ~/kaaos-knowledge/.kaaos/automation/daily-pending
./hooks/session-start.sh
```

### Test post-tool.sh
```bash
# Simulate Write tool usage
echo '{"toolName": "Write", "parameters": {"file_path": "/tmp/test.txt"}}' | ./hooks/post-tool.sh

# Simulate WebSearch tool usage
echo '{"toolName": "WebSearch"}' | ./hooks/post-tool.sh

# Check results
ls -la ~/kaaos-knowledge/.kaaos/insights/tool-usage/
ls -la ~/kaaos-knowledge/.kaaos/insights/research/
```

### Test session-end.sh
```bash
# Run after some tool usage captured
./hooks/session-end.sh

# Check results
cat ~/kaaos-knowledge/.kaaos/insights/sessions/*.json
tail ~/kaaos-knowledge/.kaaos/logs/sessions.log
```

## Error Handling

All hooks follow defensive programming:
- **Exit 0 always** - Never block Claude Code
- **Silent failures** - Errors suppressed with `2>/dev/null || true`
- **Graceful degradation** - Exit silently if KAAOS not initialized
- **Safe operations** - Create directories as needed with `mkdir -p`

## Environment Variables

The hooks use `${CLAUDE_PLUGIN_ROOT}` which is automatically set by Claude Code to the plugin root directory.

## Customization

### Add New Tool Capture
Edit `post-tool.sh` and add to the case statement:

```bash
case "$tool_name" in
    YourTool)
        # Your capture logic here
        ;;
esac
```

### Change Insight Storage
Modify the directory paths in each hook:

```bash
local insight_dir="$kaaos_repo/.kaaos/insights/custom-dir"
```

### Enable Bash Command Capture
In `post-tool.sh`, uncomment the Bash section:

```bash
Bash)
    # Capture bash commands
    local cmd_dir="$kaaos_repo/.kaaos/insights/commands"
    mkdir -p "$cmd_dir"
    # ... capture logic
    ;;
```

## Debugging

### Enable Trace Mode
Add `set -x` to any hook script:

```bash
#!/usr/bin/env bash
set -Eeo pipefail
set -x  # Enable trace mode
```

### Check Hook Execution
Monitor Claude Code logs or add explicit logging:

```bash
echo "Hook executed at $(date)" >> /tmp/kaaos-hook-debug.log
```

### Validate JSON Output
```bash
./hooks/session-start.sh | jq '.'
```

## Performance

Hooks are designed to be lightweight:
- **session-start.sh**: O(1) - Quick file existence checks
- **post-tool.sh**: O(1) - Single JSON write per tool use
- **session-end.sh**: O(n) - Counts insight files, but fast for typical session sizes

No blocking operations or network calls.

## Security

All hooks:
- Use quoted variable expansions
- Avoid `eval` on user input
- Create files with safe permissions
- Use absolute paths for operations
- Validate input before processing

## Troubleshooting

### Hooks not firing
1. Check Claude Code plugin installation
2. Verify hooks.json is valid JSON: `jq '.' hooks/hooks.json`
3. Ensure scripts are executable: `ls -la hooks/*.sh`

### Insights not captured
1. Verify KAAOS repo exists at `~/kaaos-knowledge/.kaaos` or `./.kaaos`
2. Check write permissions in `.kaaos/insights/`
3. Test hook manually with sample input

### Session summaries empty
1. Ensure tool usage insights were captured first
2. Check `.kaaos/insights/tool-usage/` has JSON files
3. Verify session-end.sh has execute permissions

## Version

KAAOS Hooks v1.0.0 - January 2024
