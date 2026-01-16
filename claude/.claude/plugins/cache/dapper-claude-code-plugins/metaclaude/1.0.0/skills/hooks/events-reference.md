# Hook Events Reference

This document provides detailed documentation for all 10 Claude Code hook events.

---

## Event Overview

| Event | When It Runs | Can Block? |
|-------|--------------|------------|
| [PreToolUse](#pretooluse) | Before tool execution | Yes |
| [PostToolUse](#posttooluse) | After tool completes | No (feedback only) |
| [PermissionRequest](#permissionrequest) | When permission dialog shown | Yes |
| [UserPromptSubmit](#userpromptsubmit) | When user submits prompt | Yes |
| [Notification](#notification) | When Claude sends notifications | No |
| [Stop](#stop) | When Claude finishes responding | Yes |
| [SubagentStop](#subagentstop) | When subagent completes | Yes |
| [SessionStart](#sessionstart) | When session starts/resumes | No (context only) |
| [SessionEnd](#sessionend) | When session ends | No |
| [PreCompact](#precompact) | Before context compaction | No |

---

## PreToolUse

**When**: Before tool calls execute (after Claude creates parameters)

**Can Block**: Yes

**Use Cases**: Validate inputs, modify parameters, block unsafe operations, auto-approve safe operations

### Matchers

Regex patterns matching tool names: `Bash`, `Edit|Write`, `Read`, `Glob`, `Grep`, `WebFetch`, `Task`, `mcp__server__tool`

### Input Schema

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/session.jsonl",
  "cwd": "/current/working/directory",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test",
    "description": "Run tests",
    "timeout": 120000
  }
}
```

Tool-specific `tool_input` fields:

| Tool | Fields |
|------|--------|
| **Bash** | `command`, `description`, `timeout`, `run_in_background` |
| **Write** | `file_path`, `content` |
| **Edit** | `file_path`, `old_string`, `new_string`, `replace_all` |
| **Read** | `file_path`, `offset`, `limit` |

### Output Schema

```json
{
  "continue": true,
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Explanation",
    "updatedInput": {
      "command": "modified command"
    }
  }
}
```

**Permission Decisions**:
- `allow` - Bypass permission system, execute immediately
- `deny` - Block execution, show reason to Claude
- `ask` - Show confirmation dialog to user

---

## PostToolUse

**When**: After tool calls complete successfully

**Can Block**: No (tool already ran, but can provide feedback)

**Use Cases**: Format code after edits, run linters, add context for Claude

### Matchers

Same as PreToolUse: `Bash`, `Edit|Write`, etc.

### Input Schema

```json
{
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "content": "..."
  },
  "tool_response": {
    "success": true
  }
}
```

### Output Schema

```json
{
  "decision": "block|undefined",
  "reason": "Explanation if blocking",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Info for Claude about what happened"
  }
}
```

---

## PermissionRequest

**When**: When permission dialog would be shown to user

**Can Block**: Yes (auto-approve or auto-deny)

**Use Cases**: Auto-approve safe operations, auto-deny dangerous ones

### Matchers

Same tool patterns as PreToolUse

### Input Schema

Same as PreToolUse

### Output Schema

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow|deny",
      "updatedInput": { ... },
      "message": "Denial reason",
      "interrupt": false
    }
  }
}
```

---

## UserPromptSubmit

**When**: When user submits a prompt, before Claude processes it

**Can Block**: Yes

**Use Cases**: Validate prompts, add context, block unsafe input

### Matchers

None (runs for all prompts)

### Input Schema

```json
{
  "hook_event_name": "UserPromptSubmit",
  "prompt": "User's submitted text"
}
```

### Output Schema

```json
{
  "decision": "block|undefined",
  "reason": "Why prompt is blocked",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Context injected for Claude"
  }
}
```

**Note**: Plain text stdout (exit code 0) is automatically added as context.

---

## Notification

**When**: When Claude Code sends notifications

**Can Block**: No

**Use Cases**: Custom desktop alerts, logging, integrations

### Matchers

| Matcher | Trigger |
|---------|---------|
| `permission_prompt` | Permission requests |
| `idle_prompt` | Claude waiting 60+ seconds |
| `auth_success` | Authentication success |
| `elicitation_dialog` | MCP tool input dialog |

### Input Schema

```json
{
  "hook_event_name": "Notification",
  "notification_type": "permission_prompt",
  "message": "Notification content"
}
```

### Output Schema

Standard output (no hook-specific fields)

---

## Stop

**When**: When main Claude Code agent finishes responding

**Can Block**: Yes (force Claude to continue)

**Use Cases**: Ensure task completion, multi-step workflows

### Matchers

None

### Input Schema

```json
{
  "hook_event_name": "Stop",
  "stop_reason": "Why Claude stopped"
}
```

### Output Schema

```json
{
  "decision": "block|undefined",
  "reason": "Why Claude must continue (required when blocking)"
}
```

**Prompt Hook Example**:

```json
{
  "type": "prompt",
  "prompt": "Check if all requested tasks are complete. Respond with {\"ok\": true} to stop or {\"ok\": false, \"reason\": \"what's left\"} to continue."
}
```

---

## SubagentStop

**When**: When a subagent task completes

**Can Block**: Yes (force subagent to continue)

**Use Cases**: Ensure subagent thoroughness

### Matchers

None

### Input/Output Schema

Same as Stop

---

## SessionStart

**When**: When session starts or resumes

**Can Block**: No (but can add context)

**Use Cases**: Load development context, set environment variables, install dependencies

### Matchers

| Matcher | Trigger |
|---------|---------|
| `startup` | Fresh session startup |
| `resume` | Resumed via `--resume` or `/resume` |
| `clear` | After `/clear` command |
| `compact` | After auto/manual compact |

### Input Schema

```json
{
  "hook_event_name": "SessionStart",
  "trigger": "startup|resume|clear|compact"
}
```

### Output Schema

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Context injected at session start"
  }
}
```

### Setting Environment Variables

Use `$CLAUDE_ENV_FILE` to persist environment variables:

```bash
#!/bin/bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=development' >> "$CLAUDE_ENV_FILE"
  echo 'export API_URL=http://localhost:3000' >> "$CLAUDE_ENV_FILE"
fi
```

---

## SessionEnd

**When**: When session ends

**Can Block**: No

**Use Cases**: Cleanup temp files, save state, logging

### Matchers

None

### Input Schema

```json
{
  "hook_event_name": "SessionEnd"
}
```

### Output Schema

Standard output (cleanup only, no special fields)

---

## PreCompact

**When**: Before context compaction occurs

**Can Block**: No

**Use Cases**: Logging, prevent compaction in specific scenarios

### Matchers

| Matcher | Trigger |
|---------|---------|
| `manual` | From `/compact` command |
| `auto` | From auto-compact (full context) |

### Input Schema

```json
{
  "hook_event_name": "PreCompact",
  "trigger": "manual|auto"
}
```

### Output Schema

Standard output

---

## Common Input Fields

All hooks receive these base fields:

```json
{
  "session_id": "unique-session-id",
  "transcript_path": "/path/to/session.jsonl",
  "cwd": "/current/working/directory",
  "permission_mode": "default|plan|acceptEdits|dontAsk|bypassPermissions",
  "hook_event_name": "EventName"
}
```

---

## Related

- [SKILL.md](SKILL.md) - Main hooks guide
- [examples.md](examples.md) - Implementation examples
- [security.md](security.md) - Security best practices
