# Session Startup Checklist

Pre-session preparation checklist to ensure effective context loading and productive work sessions.

## Before Starting

### 1. Define Session Purpose

- [ ] **Session Type Identified**
  - [ ] Focus session (deep work on specific project)
  - [ ] Strategic session (cross-project thinking)
  - [ ] Research session (investigation and learning)
  - [ ] Meeting prep (pre-meeting context loading)
  - [ ] Review session (digest review and action)

- [ ] **Session Duration Estimated**
  - [ ] Quick (<30 min) - Skip co-pilot, minimal context
  - [ ] Short (30-60 min) - Essential context only
  - [ ] Medium (1-2 hours) - Full context, consider co-pilot
  - [ ] Long (2-4 hours) - Full context + co-pilot
  - [ ] Extended (4+ hours) - Full setup + breaks planned

- [ ] **Session Goal Defined**
  - [ ] Clear deliverable identified
  - [ ] Success criteria defined
  - [ ] Time-boxed appropriately

### 2. Check System Status

- [ ] **KAAOS Status**
  ```bash
  /kaaos:status
  ```
  - [ ] Repository accessible
  - [ ] No pending maintenance issues
  - [ ] Budget sufficient for session

- [ ] **Recent Activity Reviewed**
  - [ ] Check daily digest from this morning
  - [ ] Review recent commits since last session
  - [ ] Note any flagged items needing attention

- [ ] **Calendar Context**
  - [ ] Upcoming meetings noted
  - [ ] Deadlines identified
  - [ ] Context switch points planned

### 3. Budget Check

- [ ] **Cost Estimate**
  - [ ] Session type cost estimated
  - [ ] Co-pilot cost included if needed
  - [ ] Within daily/weekly budget limits

- [ ] **Current Spend**
  ```bash
  /kaaos:status --budget
  ```
  - [ ] Daily spend: $____ / $5.00
  - [ ] Weekly spend: $____ / $25.00
  - [ ] Monthly spend: $____ / $100.00

## Session Initialization

### 4. Start Session

- [ ] **Initialize Session**
  ```bash
  # Focus session
  /kaaos:session [org]/[project]

  # With co-pilot
  /kaaos:session [org]/[project] --copilot

  # Strategic session
  /kaaos:session [org] --strategic

  # Meeting prep
  /kaaos:session [org]/[project] --meeting "[Meeting Title]"
  ```

- [ ] **Verify Context Loaded**
  - [ ] Organization index loaded
  - [ ] Project index loaded
  - [ ] Recent decisions loaded
  - [ ] Active playbooks loaded
  - [ ] Recent work (past 7 days) loaded

### 5. Review Loaded Context

- [ ] **Essential Context Check**
  - [ ] Organization: [Name]
  - [ ] Project: [Name] (if applicable)
  - [ ] Recent decisions: [Count]
  - [ ] Active playbooks: [Count]

- [ ] **Recent Work Summary**
  - [ ] Notes created: [Count]
  - [ ] Notes updated: [Count]
  - [ ] Conversations: [Count]
  - [ ] Commits: [Count]

- [ ] **Attention Items**
  - [ ] Broken links: [Count]
  - [ ] Orphaned notes: [Count]
  - [ ] Flagged items: [Count]
  - [ ] Action items: [Count]

### 6. Co-Pilot Setup (if applicable)

- [ ] **Co-Pilot Spawned**
  - [ ] Process ID noted: [PID]
  - [ ] Capabilities confirmed
  - [ ] Context initialized

- [ ] **Test Co-Pilot**
  ```bash
  /copilot question "What did we work on yesterday?"
  ```
  - [ ] Response appropriate
  - [ ] Context accurate

## During Session

### 7. Session Hygiene

- [ ] **Link Notes Created**
  - [ ] Reference session in note metadata
  - [ ] Cross-reference related notes
  - [ ] Update relevant map notes

- [ ] **Track Decisions**
  - [ ] Document decisions as made
  - [ ] Link to relevant context
  - [ ] Note rationale

- [ ] **Use Co-Pilot (if available)**
  - [ ] `/copilot suggest` when creating notes
  - [ ] `/copilot patterns` when seeing patterns
  - [ ] `/copilot relate [note]` when linking

- [ ] **Budget Monitoring**
  - [ ] Check budget if session >2 hours
  - [ ] Reduce co-pilot use if approaching limit
  - [ ] Consider pausing if hitting budget

### 8. Break Management (Long Sessions)

For sessions >2 hours:

- [ ] **Every 90 Minutes**
  - [ ] Take 10-15 minute break
  - [ ] Save current work
  - [ ] Review progress toward goal

- [ ] **Every 2 Hours**
  - [ ] Save session state
  ```bash
  /kaaos:session save
  ```
  - [ ] Review created/updated notes
  - [ ] Adjust remaining session plan

## Session Completion

### 9. Wrap-Up

- [ ] **Save All Work**
  - [ ] All notes committed
  - [ ] Commit messages descriptive
  - [ ] No unsaved changes

- [ ] **Session Summary**
  - [ ] Notes created: [Count]
  - [ ] Notes updated: [Count]
  - [ ] Decisions made: [Count]
  - [ ] Actions identified: [Count]

- [ ] **Update Indexes**
  - [ ] Project index updated (if needed)
  - [ ] Relevant map notes updated
  - [ ] Cross-references added

### 10. Close Session

- [ ] **Close Co-Pilot (if running)**
  ```bash
  /copilot stop
  ```
  - [ ] Co-pilot stopped cleanly
  - [ ] Suggestions reviewed

- [ ] **Save Session State**
  ```bash
  /kaaos:session end
  ```
  - [ ] Session metadata saved
  - [ ] Outputs tracked
  - [ ] Duration recorded

- [ ] **Review Session Metrics**
  - [ ] Duration: [Time]
  - [ ] Cost: $[Amount]
  - [ ] Productivity: [Notes/hour]
  - [ ] Goal achieved: [Yes/No]

### 11. Next Session Prep

- [ ] **Create Next Session Note**
  - [ ] Document where you left off
  - [ ] List next steps
  - [ ] Flag any blockers

- [ ] **Schedule Follow-Up**
  - [ ] Next session planned: [Date/Time]
  - [ ] Context to load noted
  - [ ] Goals defined

## Session Type Templates

### Focus Session Checklist

**Purpose**: Deep work on specific project

Pre-session:
- [ ] Define deliverable
- [ ] Estimate 2-4 hours
- [ ] Clear calendar of interruptions

Initialization:
- [ ] `/kaaos:session [org]/[project] --copilot`
- [ ] Load project context
- [ ] Review recent project work

During:
- [ ] Stay in project context
- [ ] Link all notes to project
- [ ] Track decisions

Post-session:
- [ ] Update project index
- [ ] Commit all work
- [ ] Note next steps

### Strategic Session Checklist

**Purpose**: Cross-project thinking

Pre-session:
- [ ] Review weekly/monthly synthesis
- [ ] Identify strategic questions
- [ ] Allocate 2-3 hours

Initialization:
- [ ] `/kaaos:session [org] --strategic`
- [ ] Load org context
- [ ] Load all active projects

During:
- [ ] Connect patterns across projects
- [ ] Make cross-project decisions
- [ ] Update org-level playbooks

Post-session:
- [ ] Document insights
- [ ] Update strategic notes
- [ ] Distribute to projects

### Meeting Prep Checklist

**Purpose**: Load context before meeting

Pre-session:
- [ ] Note meeting time (allow 30 min prep)
- [ ] Identify attendees
- [ ] Find agenda/pre-read

Initialization:
- [ ] `/kaaos:session [org]/[project] --meeting "[Title]"`
- [ ] Load meeting note
- [ ] Load pre-reads
- [ ] Load related decisions

During prep:
- [ ] Review all pre-reads
- [ ] Note questions
- [ ] Identify decisions needed

Post-meeting:
- [ ] Document decisions
- [ ] Capture action items
- [ ] Update relevant notes

### Research Session Checklist

**Purpose**: Investigation and learning

Pre-session:
- [ ] Define research question
- [ ] Allocate 1-3 hours
- [ ] Identify sources

Initialization:
- [ ] `/kaaos:session [org]/[project]`
- [ ] Create research note
- [ ] Load relevant references

During:
- [ ] Track sources
- [ ] Extract key insights
- [ ] Link to existing knowledge

Post-session:
- [ ] Summarize findings
- [ ] Create atomic notes for insights
- [ ] Link to context library

## Quick Reference

### Session Commands

```bash
# Start session
/kaaos:session [org]/[project]
/kaaos:session [org]/[project] --copilot
/kaaos:session [org] --strategic

# Check status
/kaaos:status
/kaaos:status --budget

# Co-pilot
/copilot suggest
/copilot patterns
/copilot relate [note]
/copilot question "[question]"
/copilot stop

# End session
/kaaos:session save
/kaaos:session end
```

### Context Loading Levels

**Minimal** (Quick <30 min):
- Organization index (summary)
- Project index (summary)
- ~5K tokens

**Essential** (Short 30-60 min):
- + Recent decisions
- + Active playbooks
- ~10K tokens

**Full** (Medium 1-2 hours):
- + Recent work (7 days)
- + Recent conversations
- ~25K tokens

**Extended** (Long 2-4 hours):
- + Related notes
- + Co-pilot agent
- ~40K tokens

### Budget Guidelines

| Session Type | Typical Cost | Co-pilot Cost | Total |
|--------------|--------------|---------------|-------|
| Quick (<30m) | $0.10-0.20 | N/A | $0.10-0.20 |
| Short (30-60m) | $0.20-0.40 | N/A | $0.20-0.40 |
| Medium (1-2h) | $0.40-0.80 | $0.30-0.50 | $0.70-1.30 |
| Long (2-4h) | $0.80-1.50 | $0.50-1.00 | $1.30-2.50 |

## Troubleshooting

### Context Not Loading

**Issue**: Session initialization fails

**Checks**:
- [ ] Repository path correct in config
- [ ] Organization/project exists
- [ ] Permissions on directory
- [ ] Git repository valid

**Solution**:
```bash
/kaaos:status --verbose
# Review error messages
# Verify paths in config.yaml
```

### Budget Exceeded

**Issue**: Hit daily/weekly budget limit

**Options**:
- [ ] Wait until budget resets
- [ ] Increase budget in config.yaml
- [ ] Work without co-pilot
- [ ] Use shorter sessions

### Co-Pilot Not Responding

**Issue**: Co-pilot agent unresponsive

**Checks**:
- [ ] Process running: `ps aux | grep copilot`
- [ ] Check logs: `tail -f ~/.kaaos-knowledge/.kaaos/logs/copilot.log`
- [ ] Budget sufficient

**Solution**:
```bash
/copilot restart
# Or close and respawn
/copilot stop
/kaaos:session [org]/[project] --copilot
```

### Session State Lost

**Issue**: Session not resuming properly

**Recovery**:
- [ ] Check session files: `ls ~/.kaaos-knowledge/.kaaos/sessions/`
- [ ] Review session log: `cat ~/.kaaos-knowledge/.kaaos/sessions/[id].yaml`
- [ ] Manually reload context: `/kaaos:session [org]/[project]`

## Best Practices Summary

1. ✅ **Always Start Sessions**: Don't work without context
2. ✅ **Check Recent Work**: Review past 7 days
3. ✅ **Use Co-pilot for Long Sessions**: >2 hours
4. ✅ **Link Everything**: Cross-reference as you work
5. ✅ **Track Decisions**: Document immediately
6. ✅ **Save Frequently**: Commit every 30-60 min
7. ✅ **End Cleanly**: Proper session closure
8. ✅ **Review Metrics**: Learn from session data

## Anti-Patterns to Avoid

1. ❌ **Cold Starts**: Working without session init
2. ❌ **Over-Loading**: Loading too much context
3. ❌ **No Linking**: Creating isolated notes
4. ❌ **Lost Decisions**: Not documenting choices
5. ❌ **Budget Blindness**: Ignoring cost tracking
6. ❌ **Dirty Exits**: Not closing sessions properly
7. ❌ **No Follow-Up**: Not planning next session
