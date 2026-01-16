# Session Templates

Ready-to-use templates for different KAAOS session types. Each template provides structured guidance for session initialization, workflow, and completion.

## Available Templates

| Template | Purpose | Typical Duration | Co-Pilot |
|----------|---------|------------------|----------|
| [focus-session.md](focus-session.md) | Deep work on single project | 2-4 hours | Recommended |
| [strategic-session.md](strategic-session.md) | Cross-project thinking | 2-3 hours | Optional |
| [research-session.md](research-session.md) | Investigation and learning | 1-3 hours | Optional |
| [meeting-prep-session.md](meeting-prep-session.md) | Pre-meeting preparation | 10-30 minutes | Not needed |
| [review-session.md](review-session.md) | Digest review and action | 30-60 minutes | Not needed |

## Quick Selection Guide

```
What is your goal?
    |
    +-- Deep work on specific project?
    |   --> focus-session.md
    |
    +-- Think across multiple projects?
    |   --> strategic-session.md
    |
    +-- Learn something new or investigate?
    |   --> research-session.md
    |
    +-- Prepare for an upcoming meeting?
    |   --> meeting-prep-session.md
    |
    +-- Review digests and process updates?
        --> review-session.md
```

## Template Structure

Each template includes:

1. **Session Overview**
   - Purpose and goals
   - Typical duration
   - Co-pilot recommendation
   - Cost estimate

2. **Pre-Session Checklist**
   - Environment preparation
   - Context requirements
   - Budget verification

3. **Initialization Commands**
   - Exact commands to start session
   - Context loading options
   - Co-pilot configuration

4. **Session Workflow**
   - Phase-by-phase guide
   - Decision points
   - Progress checkpoints

5. **Completion Checklist**
   - Work finalization
   - Documentation updates
   - Session closure

6. **Code Examples**
   - Python implementation patterns
   - YAML configuration snippets
   - Command line examples

## Usage

### Starting a Session

1. Select appropriate template based on your goal
2. Review pre-session checklist
3. Run initialization commands
4. Follow session workflow

### During Session

- Use template checkpoints to track progress
- Refer to workflow sections for guidance
- Adjust based on actual needs

### Ending Session

- Complete the completion checklist
- Ensure all work is saved
- Plan follow-up session if needed

## Customization

Templates can be customized for your organization:

```yaml
# Custom template configuration
# File: ~/.kaaos-knowledge/.kaaos/config.yaml

session_templates:
  focus:
    default_duration: 180  # minutes
    copilot_mode: balanced
    auto_checkpoint: true
    checkpoint_interval: 15  # minutes

  strategic:
    default_duration: 150
    copilot_mode: proactive
    load_all_projects: true

  research:
    default_duration: 120
    spawn_research_agent: true
    auto_document: true
```

## Integration with Commands

These templates are used by the `/kaaos:session` command:

```bash
# Start focus session using template
/kaaos:session personal/project --template focus

# Start strategic session
/kaaos:session personal --strategic

# Start meeting prep
/kaaos:session personal/project --meeting "Weekly Planning"
```

## Cost Estimates by Template

| Template | Base Cost | With Co-Pilot | Notes |
|----------|-----------|---------------|-------|
| Focus (2h) | $0.40-0.80 | $0.70-1.30 | Higher with active editing |
| Strategic (2h) | $0.50-1.00 | $0.80-1.50 | Multi-project loading |
| Research (2h) | $0.60-1.20 | $0.90-1.70 | Agent spawning adds cost |
| Meeting Prep | $0.05-0.15 | N/A | Short duration |
| Review (1h) | $0.15-0.30 | N/A | Light interaction |

## Related Resources

- **../session-checklist.md**: Comprehensive session preparation checklist
- **../../references/context-loading-strategies.md**: Advanced context loading patterns
- **../../references/copilot-interaction-patterns.md**: Co-pilot usage patterns
- **../../references/session-resumption.md**: Pausing and resuming sessions
- **../../SKILL.md**: Session management skill overview
