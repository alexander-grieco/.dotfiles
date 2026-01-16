---
name: hooks
description: |
  Write effective Claude Code hooks for automation, validation, and workflow control.
  Use when creating hooks, configuring PreToolUse/PostToolUse events, or automating Claude behavior.
  Triggers: hooks, PreToolUse, PostToolUse, PermissionRequest, SessionStart, Stop, hook configuration
---

# Claude Code Hooks Developer Guide

## What Are Hooks?

Hooks are **user-defined shell commands that execute at specific points in Claude Code's lifecycle**. They provide deterministic control over Claude's behavior—ensuring certain actions always happen rather than relying on Claude to choose to do them.

**Key Principle**: Hooks turn suggestions into automated actions. Instead of asking Claude to format code, a hook makes it happen every time.

---

## Quick Reference: Which Hook to Use

| Goal | Hook Event | Details |
|------|------------|---------|
| Validate/block before tool runs | **PreToolUse** | Receives tool parameters, can modify input |
| Auto-approve tool calls | **PreToolUse** | Set `permissionDecision: "allow"` |
| Format code after edits | **PostToolUse** | Match `Edit\|Write` tools |
| Log/audit commands | **PreToolUse** | Log to file before execution |
| Prevent sensitive file edits | **PreToolUse** | Check file path, exit 2 to block |
| Add context to prompts | **UserPromptSubmit** | Inject context via stdout or JSON |
| Force Claude to keep working | **Stop** | Set `decision: "block"` with reason |
| Desktop notifications | **Notification** | Use `notify-send` or similar |
| Setup environment | **SessionStart** | Set env vars via `$CLAUDE_ENV_FILE` |
| Cleanup on exit | **SessionEnd** | Remove temp files, save state |

For detailed event documentation, see [events-reference.md](events-reference.md).

---

## Hook Configuration Locations

Hooks can be configured in four scopes (highest to lowest priority):

| Scope | Location | Shared? |
|-------|----------|---------|
| **Managed** | System directories (IT-deployed) | All users |
| **Local Project** | `.claude/settings.local.json` | You only (gitignored) |
| **Project** | `.claude/settings.json` | Team (committed) |
| **User** | `~/.claude/settings.json` | You across all projects |

### Configuration in settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/validate-bash.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Configuration in Skill Frontmatter

Skills can embed hooks that activate when the skill is used:

```yaml
---
name: secure-operations
description: Perform operations with security validation
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

---

## Hook Types

### Command Hooks (Recommended)

Execute shell commands with JSON input via stdin:

```json
{
  "type": "command",
  "command": "python3 ~/.claude/hooks/validate.py",
  "timeout": 60
}
```

### Prompt Hooks

Use LLM evaluation for context-aware decisions:

```json
{
  "type": "prompt",
  "prompt": "Evaluate if Claude should stop. Check if tasks are complete.",
  "timeout": 30
}
```

Supported for: `Stop`, `SubagentStop`, `UserPromptSubmit`, `PreToolUse`, `PermissionRequest`

---

## Core Patterns

### Exit Codes

| Code | Meaning | Behavior |
|------|---------|----------|
| **0** | Success | stdout parsed as JSON |
| **2** | Blocking error | stderr shown to Claude, execution blocked |
| **Other** | Non-blocking error | stderr shown in verbose mode, continues |

### JSON Output Schema

All hooks can return:

```json
{
  "continue": true,
  "stopReason": "string",
  "suppressOutput": true,
  "systemMessage": "Warning to show user"
}
```

### PreToolUse Permission Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Auto-approved: safe operation",
    "updatedInput": {
      "command": "modified command"
    }
  }
}
```

---

## Matcher Patterns

Matchers are **case-sensitive** and support regex:

| Pattern | Matches |
|---------|---------|
| `Bash` | Only Bash tool |
| `Edit\|Write` | Either Edit OR Write |
| `Notebook.*` | All Notebook tools |
| `mcp__server__.*` | All tools from an MCP server |
| `""` or `*` | All tools |

---

## Environment Variables

Available in hook commands:

| Variable | Value |
|----------|-------|
| `$CLAUDE_PROJECT_DIR` | Absolute path to project root |
| `$CLAUDE_CODE_REMOTE` | `"true"` if web, empty if CLI |
| `$CLAUDE_ENV_FILE` | (SessionStart only) Path for persisting env vars |

---

## Debugging Hooks

1. **View registered hooks**: Run `/hooks` command
2. **Test manually**: Run hook commands in terminal first
3. **Debug mode**: Use `claude --debug` to see execution
4. **Check permissions**: Ensure scripts are executable (`chmod +x`)

---

## Additional Resources

| Topic | File | When to Use |
|-------|------|-------------|
| All 10 Events | [events-reference.md](events-reference.md) | Detailed event documentation |
| Examples | [examples.md](examples.md) | Copy-paste implementations |
| Security | [security.md](security.md) | Validation and safety patterns |

---

## Security Warning

Hooks execute with your user credentials. Always:
- Review hook code before adding
- Test in safe environment first
- Validate and sanitize all inputs
- Use absolute paths in scripts

See [security.md](security.md) for comprehensive security guidance.
