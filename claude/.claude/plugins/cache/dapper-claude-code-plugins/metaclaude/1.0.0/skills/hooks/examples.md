# Hook Examples

Complete, copy-paste-ready hook implementations for common use cases.

---

## 1. Auto-Format Code After Edits (PostToolUse)

Automatically format files after Claude edits them.

### Configuration

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/auto-format.py"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/auto-format.py`

```python
#!/usr/bin/env python3
import json
import subprocess
import sys

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

if not file_path:
    sys.exit(0)

# Format based on file extension
if file_path.endswith(('.ts', '.tsx', '.js', '.jsx')):
    subprocess.run(['npx', 'prettier', '--write', file_path],
                   capture_output=True)
elif file_path.endswith('.py'):
    subprocess.run(['black', file_path], capture_output=True)
elif file_path.endswith('.go'):
    subprocess.run(['gofmt', '-w', file_path], capture_output=True)

sys.exit(0)
```

---

## 2. Block Sensitive File Edits (PreToolUse)

Prevent editing production configs, secrets, and lock files.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/block-sensitive.py"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/block-sensitive.py`

```python
#!/usr/bin/env python3
import json
import sys

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

BLOCKED_PATTERNS = [
    '.env',
    'production.env',
    '.git/',
    'secrets/',
    'package-lock.json',
    'yarn.lock',
    'pnpm-lock.yaml',
    '.claude/settings.json',
]

for pattern in BLOCKED_PATTERNS:
    if pattern in file_path:
        print(f"Blocked: Cannot edit {pattern} files", file=sys.stderr)
        sys.exit(2)

sys.exit(0)
```

---

## 3. Log All Bash Commands (PreToolUse)

Audit trail of all commands Claude executes.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/log-commands.sh"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/log-commands.sh`

```bash
#!/bin/bash

LOG_FILE="$HOME/.claude/command-audit.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Read JSON from stdin
INPUT=$(cat)

# Extract command and description
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // "unknown"')
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // "no description"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log the command
echo "[$TIMESTAMP] $DESCRIPTION: $COMMAND" >> "$LOG_FILE"

exit 0
```

---

## 4. Auto-Approve Safe File Reads (PreToolUse)

Skip permission prompts for documentation and config files.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/auto-approve-reads.py"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/auto-approve-reads.py`

```python
#!/usr/bin/env python3
import json
import sys

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

SAFE_EXTENSIONS = (
    '.md', '.txt', '.json', '.yaml', '.yml',
    '.gitignore', '.editorconfig', '.prettierrc',
)

SAFE_PATTERNS = [
    'README',
    'LICENSE',
    'CHANGELOG',
    'package.json',
    'tsconfig.json',
]

is_safe = (
    file_path.endswith(SAFE_EXTENSIONS) or
    any(pattern in file_path for pattern in SAFE_PATTERNS)
)

if is_safe:
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
            "permissionDecisionReason": "Auto-approved: safe file type"
        }
    }
    print(json.dumps(output))

sys.exit(0)
```

---

## 5. Environment Setup at Session Start (SessionStart)

Set development environment variables and load context.

### Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/session-setup.sh"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/session-setup.sh`

```bash
#!/bin/bash

# Set environment variables
if [ -n "$CLAUDE_ENV_FILE" ]; then
    echo 'export NODE_ENV=development' >> "$CLAUDE_ENV_FILE"
    echo 'export DEBUG=true' >> "$CLAUDE_ENV_FILE"
    echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"

    # Load from .env.local if exists
    if [ -f "$CLAUDE_PROJECT_DIR/.env.local" ]; then
        cat "$CLAUDE_PROJECT_DIR/.env.local" >> "$CLAUDE_ENV_FILE"
    fi
fi

# Inject context for Claude
CONTEXT=""

# Add git branch info
if command -v git &> /dev/null; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    CONTEXT="Current git branch: $BRANCH"
fi

# Output context
if [ -n "$CONTEXT" ]; then
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$CONTEXT"
  }
}
EOF
fi

exit 0
```

---

## 6. Custom Desktop Notifications (Notification)

Send native notifications when Claude needs attention.

### Configuration

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/notify.sh"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/notify.sh`

```bash
#!/bin/bash

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude needs your attention"')

# macOS
if command -v osascript &> /dev/null; then
    osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\""
# Linux
elif command -v notify-send &> /dev/null; then
    notify-send "Claude Code" "$MESSAGE"
fi

exit 0
```

---

## 7. Intelligent Stop Hook (Prompt-Based)

Use LLM to evaluate if Claude should continue working.

### Configuration

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if Claude should stop. Check:\n1. Are all user-requested tasks complete?\n2. Are there unresolved errors?\n3. Is follow-up work needed?\n\nRespond with {\"ok\": true} to stop or {\"ok\": false, \"reason\": \"explanation\"} to continue.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Alternative: Command-Based Stop Check

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/check-stop.sh"
          }
        ]
      }
    ]
  }
}
```

### Script: `~/.claude/hooks/check-stop.sh`

```bash
#!/bin/bash

# Check if there are uncommitted changes
if [ -d "$CLAUDE_PROJECT_DIR/.git" ]; then
    cd "$CLAUDE_PROJECT_DIR"
    if ! git diff --quiet 2>/dev/null; then
        cat << 'EOF'
{
  "decision": "block",
  "reason": "There are uncommitted changes. Please commit or stash before stopping."
}
EOF
        exit 0
    fi
fi

exit 0
```

---

## 8. Skill-Embedded Hooks (Frontmatter)

Define hooks directly in a skill that activate when the skill is used.

### Skill: `plugins/example/skills/secure-deploy/SKILL.md`

```yaml
---
name: secure-deploy
description: |
  Deploy applications with security validation.
  Triggers: deploy, release, production
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "python3 $CLAUDE_PROJECT_DIR/.claude/hooks/validate-deploy.py"
  PostToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "bash $CLAUDE_PROJECT_DIR/.claude/hooks/notify-deploy.sh"
---

# Secure Deploy Skill

This skill ensures all deployments pass security validation...
```

### Validation Script: `.claude/hooks/validate-deploy.py`

```python
#!/usr/bin/env python3
import json
import sys

data = json.load(sys.stdin)
command = data.get('tool_input', {}).get('command', '')

# Block dangerous deployment patterns
DANGEROUS_PATTERNS = [
    '--force',
    '--skip-tests',
    '--no-verify',
    'rm -rf',
]

for pattern in DANGEROUS_PATTERNS:
    if pattern in command:
        print(f"Blocked: Dangerous pattern '{pattern}' in deploy command",
              file=sys.stderr)
        sys.exit(2)

# Require confirmation for production
if 'production' in command or 'mainnet' in command:
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": "Production deployment requires confirmation"
        }
    }
    print(json.dumps(output))

sys.exit(0)
```

---

## Quick Reference: Hook Script Template

Use this as a starting point for new hooks:

### Python Template

```python
#!/usr/bin/env python3
"""
Hook: [Name]
Event: [PreToolUse|PostToolUse|etc.]
Purpose: [Description]
"""
import json
import sys

def main():
    # Read input
    data = json.load(sys.stdin)

    # Extract relevant fields
    tool_name = data.get('tool_name', '')
    tool_input = data.get('tool_input', {})

    # Your logic here
    # ...

    # Output (optional)
    # output = {"hookSpecificOutput": {...}}
    # print(json.dumps(output))

    # Exit codes: 0 = success, 2 = block
    sys.exit(0)

if __name__ == '__main__':
    main()
```

### Bash Template

```bash
#!/bin/bash
# Hook: [Name]
# Event: [PreToolUse|PostToolUse|etc.]
# Purpose: [Description]

set -e

# Read input
INPUT=$(cat)

# Extract fields with jq
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Your logic here
# ...

# Exit codes: 0 = success, 2 = block
exit 0
```

---

## Related

- [SKILL.md](SKILL.md) - Main hooks guide
- [events-reference.md](events-reference.md) - Event documentation
- [security.md](security.md) - Security best practices
