# Hook Security Best Practices

Hooks execute with your user credentials and can access any file on your system. This guide covers essential security practices.

---

## Security Warning

By using hooks, you acknowledge:
- Hooks execute arbitrary shell commands automatically
- Malicious hooks can modify, delete, or access any files
- You are solely responsible for hook code you add
- Always review hooks before adding them

---

## Input Validation

### Validate All Input Fields

Never trust input blindly. Always validate before use.

**Python**:

```python
#!/usr/bin/env python3
import json
import sys
import os

data = json.load(sys.stdin)

# Validate required fields exist
file_path = data.get('tool_input', {}).get('file_path')
if not file_path:
    sys.exit(0)  # Missing field, skip hook

# Validate path is absolute
if not os.path.isabs(file_path):
    print("Error: Expected absolute path", file=sys.stderr)
    sys.exit(2)

# Validate path is within project
project_dir = os.environ.get('CLAUDE_PROJECT_DIR', '')
if project_dir and not file_path.startswith(project_dir):
    print("Error: Path outside project directory", file=sys.stderr)
    sys.exit(2)
```

**Bash with jq**:

```bash
#!/bin/bash

INPUT=$(cat)

# Validate JSON structure
if ! echo "$INPUT" | jq -e '.tool_input' > /dev/null 2>&1; then
    exit 0  # Invalid structure, skip
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Check for empty path
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Validate absolute path
if [[ "$FILE_PATH" != /* ]]; then
    echo "Error: Expected absolute path" >&2
    exit 2
fi
```

---

## Path Traversal Prevention

Prevent access to files outside intended directories.

```python
#!/usr/bin/env python3
import json
import sys
import os

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

# Check for path traversal attempts
if '..' in file_path:
    print("Error: Path traversal detected", file=sys.stderr)
    sys.exit(2)

# Normalize and verify path stays within bounds
project_dir = os.environ.get('CLAUDE_PROJECT_DIR', '')
if project_dir:
    normalized = os.path.normpath(file_path)
    if not normalized.startswith(os.path.normpath(project_dir)):
        print("Error: Path escapes project directory", file=sys.stderr)
        sys.exit(2)
```

---

## Sensitive File Protection

Block access to files that should never be modified.

```python
#!/usr/bin/env python3
import json
import sys

SENSITIVE_PATTERNS = [
    # Secrets and credentials
    '.env',
    '.env.local',
    '.env.production',
    'secrets/',
    'credentials',
    '.pem',
    '.key',
    'id_rsa',
    'id_ed25519',

    # Git internals
    '.git/',

    # Lock files
    'package-lock.json',
    'yarn.lock',
    'pnpm-lock.yaml',
    'Cargo.lock',
    'poetry.lock',

    # Claude config
    '.claude/settings.json',
]

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '').lower()

for pattern in SENSITIVE_PATTERNS:
    if pattern.lower() in file_path:
        print(f"Blocked: Cannot access sensitive file matching '{pattern}'",
              file=sys.stderr)
        sys.exit(2)

sys.exit(0)
```

---

## Shell Quoting

Always quote variables to prevent injection attacks.

**Good**:

```bash
#!/bin/bash
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path')

# Correct: quoted variable
if [ -f "$FILE_PATH" ]; then
    cat "$FILE_PATH"
fi
```

**Bad**:

```bash
#!/bin/bash
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path')

# DANGEROUS: unquoted variable allows injection
if [ -f $FILE_PATH ]; then
    cat $FILE_PATH
fi
```

---

## Command Injection Prevention

Never interpolate user input directly into shell commands.

**Dangerous**:

```bash
# NEVER do this - allows command injection
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
eval "$COMMAND"  # Attacker can inject arbitrary commands
```

**Safe Pattern**:

```python
#!/usr/bin/env python3
import json
import subprocess
import sys
import shlex

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

# Safe: use list form, not shell=True
subprocess.run(['cat', file_path], check=True)

# If you must use shell, escape properly
# subprocess.run(f'cat {shlex.quote(file_path)}', shell=True, check=True)
```

---

## Environment Variable Safety

Be careful with environment variables in hooks.

```bash
#!/bin/bash

# Always check if variable is set
if [ -z "$CLAUDE_PROJECT_DIR" ]; then
    echo "Error: CLAUDE_PROJECT_DIR not set" >&2
    exit 1
fi

# Use default values
LOG_DIR="${CLAUDE_LOG_DIR:-$HOME/.claude/logs}"

# Don't expose sensitive env vars in output
# Bad: echo "Using API_KEY=$API_KEY"
# Good: echo "API key is configured"
```

---

## Testing Recommendations

### 1. Test Hooks Manually First

Before adding to configuration, run hook scripts directly:

```bash
# Create test input
echo '{"tool_input": {"file_path": "/test/path.txt"}}' | ./my-hook.py
echo $?  # Check exit code
```

### 2. Test Edge Cases

```bash
# Empty input
echo '{}' | ./my-hook.py

# Path traversal attempt
echo '{"tool_input": {"file_path": "../../../etc/passwd"}}' | ./my-hook.py

# Special characters
echo '{"tool_input": {"file_path": "/path/with spaces/and\"quotes"}}' | ./my-hook.py
```

### 3. Use a Safe Environment

- Test in a disposable directory first
- Use a test project, not production code
- Consider using Docker/VM for untrusted hooks

### 4. Review Before Committing

- Understand every line of hook code
- Check for obvious security issues
- Have a colleague review complex hooks

---

## Security Checklist

Use this checklist when reviewing hooks:

- [ ] **Input validation**: All inputs validated before use
- [ ] **Path traversal**: No `..` allowed in paths
- [ ] **Path bounds**: Paths stay within project directory
- [ ] **Sensitive files**: Block access to secrets, credentials, configs
- [ ] **Shell quoting**: All variables properly quoted
- [ ] **No eval**: Never use `eval` with user input
- [ ] **subprocess safety**: Use list form, avoid `shell=True`
- [ ] **Error handling**: Graceful handling of unexpected input
- [ ] **Exit codes**: Correct exit codes (0=success, 2=block)
- [ ] **Manual testing**: Tested with various inputs
- [ ] **Edge cases**: Tested empty, malformed, malicious inputs
- [ ] **Code review**: Reviewed by another person

---

## Secure Hook Template

Use this template as a secure starting point:

```python
#!/usr/bin/env python3
"""
Secure hook template with input validation.
"""
import json
import os
import sys


def validate_path(path: str, project_dir: str) -> bool:
    """Validate that path is safe."""
    if not path:
        return False
    if not os.path.isabs(path):
        return False
    if '..' in path:
        return False
    if project_dir:
        normalized = os.path.normpath(path)
        if not normalized.startswith(os.path.normpath(project_dir)):
            return False
    return True


def is_sensitive(path: str) -> bool:
    """Check if path matches sensitive patterns."""
    sensitive = ['.env', '.git/', 'secrets/', '.pem', '.key']
    path_lower = path.lower()
    return any(s in path_lower for s in sensitive)


def main():
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)  # Invalid JSON, skip

    file_path = data.get('tool_input', {}).get('file_path', '')
    project_dir = os.environ.get('CLAUDE_PROJECT_DIR', '')

    # Validate path
    if not validate_path(file_path, project_dir):
        print("Error: Invalid path", file=sys.stderr)
        sys.exit(2)

    # Block sensitive files
    if is_sensitive(file_path):
        print("Error: Cannot access sensitive file", file=sys.stderr)
        sys.exit(2)

    # Your hook logic here
    # ...

    sys.exit(0)


if __name__ == '__main__':
    main()
```

---

## Related

- [SKILL.md](SKILL.md) - Main hooks guide
- [events-reference.md](events-reference.md) - Event documentation
- [examples.md](examples.md) - Implementation examples
