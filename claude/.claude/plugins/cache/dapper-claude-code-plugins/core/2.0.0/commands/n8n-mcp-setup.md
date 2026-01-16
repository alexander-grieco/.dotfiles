---
name: n8n-mcp-setup
description: Install and configure the Dapper Labs n8n MCP server for agent workflows and company-specific integrations. Use when setting up new development environment or after Claude Code updates.
---

# n8n MCP Setup Command

Installs and configures the Dapper Labs n8n MCP server for agent workflows.

## Usage

Run the following command within Claude Code:

```
/n8n-mcp-setup
```

## What This Does

This command will:
1. Check if `n8n` MCP is already installed
2. Install the Dapper Labs n8n MCP server if not present
3. Verify the installation was successful
4. Prompt you to run `/mcp` within Claude Code to authenticate with the MCP server
5. Report status to user

## Installation Details

**MCP Server URL:** `https://dapperlabs.app.n8n.cloud/mcp-server/http`

**What It Enables:**
- Custom n8n workflows execution
- Company-specific integrations
- Internal tools and services access
- Pre-built automation patterns

## Command Workflow

### Step 1: Check Existing Installation
```bash
claude mcp list | grep n8n
```

If already installed, command reports success and exits.

### Step 2: Install MCP Server
```bash
claude mcp add n8n https://dapperlabs.app.n8n.cloud/mcp-server/http
```

### Step 3: Verify Installation
```bash
claude mcp list | grep n8n
```

Confirms the MCP appears in the list.

### Step 4: Authenticate

**REQUIRED:** After installation, users must complete authentication by running `/mcp` within Claude Code:

```
/mcp
```

This step is **critical and not optional**. Running `/mcp` in Claude Code will:
- Open the authentication flow for the MCP server
- Establish the connection between Claude Code and the n8n server
- Enable the MCP tools to be used by agents

**Without completing authentication, the MCP server will be installed but non-functional.**

### Step 5: Report Status
- ✅ Success: MCP installed and verified
- ⚠️ Already installed: MCP was previously configured
- ❌ Failed: Installation or verification error (with troubleshooting steps)

## Error Handling

### Installation Fails
If `claude mcp add` fails:
- Check network connectivity to `dapperlabs.app.n8n.cloud`
- Verify Claude Code version supports HTTP MCP transport
- Ensure n8n server is available
- Check Claude Code logs for detailed error

### Verification Fails
If MCP doesn't appear after installation:
- Try: `claude mcp remove n8n` then re-run `/n8n-mcp-setup`
- Restart Claude Code
- Check `~/.claude/mcp-logs/` for error logs

## After Setup

Once installed **and authenticated**, agents automatically have access to the Dapper Labs MCP capabilities. No per-agent configuration needed.

**IMPORTANT:** You must complete authentication by running `/mcp` within Claude Code before agents can use the MCP. Installation alone is not sufficient - authentication is a required step.

### In Agent Briefings

Specify MCP availability when creating agents:

```
**Tools Available:**
- Dapper Labs MCP (n8n workflows)
- Git (CLI)
- Standard CLI tools
```

## Manual Installation (Alternative)

If you prefer manual installation:

```bash
# Install
claude mcp add n8n https://dapperlabs.app.n8n.cloud/mcp-server/http

# Verify
claude mcp list | grep n8n
```

## Removal

To remove the MCP server:

```bash
claude mcp remove n8n
```

## Best Practices

✅ **Run before starting multi-agent projects** - Ensures MCP is available  
✅ **Verify with `/n8n-mcp-setup` after Claude Code updates** - Confirm compatibility  
✅ **Document in agent briefings** - Agents need to know tools available  

❌ **Don't install mid-project** - May cause agent failures  
❌ **Don't skip verification** - Command handles this automatically  

## Related

- **Command:** `/n8n-mcp-setup` (this command)
- **Marketplace:** `dapperlabs/dapper-claude-code-plugins`
- **Plugin:** `core`

---

**Quick Start:** Just run `/n8n-mcp-setup` and let the command handle installation and verification.
