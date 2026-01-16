---
name: operational-rhythms
description: Implement automated operational review rhythms (daily/weekly/monthly/quarterly) for knowledge synthesis, gap detection, and strategic alignment. Use when establishing executive review cadences, automating knowledge maintenance, or building compounding insight systems.
---

# Operational Rhythms

Master operational review rhythms that automate knowledge synthesis and strategic reflection at daily, weekly, monthly, and quarterly intervals.

## When to Use This Skill

- Setting up automated executive review systems
- Establishing knowledge maintenance cadences
- Implementing strategic planning cycles
- Building systems for insight compounding
- Automating repetitive review workflows
- Creating predictable strategic reflection habits
- Balancing immediate execution with long-term thinking

## Core Concepts

### 1. Rhythm Hierarchy

**Four Time Horizons**
- **Daily (5-10 min)**: Surface-level scan, flag urgent items
- **Weekly (30-60 min)**: Pattern extraction, tactical adjustments
- **Monthly (2-3 hours)**: Strategic alignment, system optimization
- **Quarterly (half-day)**: Comprehensive reflection, major decisions

**Compound Effect**
Each rhythm builds on the previous:
- Daily → Flags for weekly review
- Weekly → Synthesis for monthly review
- Monthly → Context for quarterly review
- Quarterly → Sets annual direction

### 2. Automation Philosophy

**Zero-User-Time Operations**
- Git hooks extract insights automatically
- Scheduled agents generate digests
- Maintenance runs without intervention
- Human time spent on review, not generation

**Cost-Conscious Automation**
- Daily: ~$0.30 (Sonnet, focused scan)
- Weekly: ~$4-5 (Opus, pattern synthesis)
- Monthly: ~$10-15 (Opus + parallel agents)
- Quarterly: ~$40-50 (Opus + full agent suite)

### 3. Agent Orchestration

**Single vs Parallel Execution**
- **Daily/Weekly**: Single agent, sequential
- **Monthly**: 2-3 agents in parallel
- **Quarterly**: Full agent suite (6+ parallel)

**Agent Selection by Rhythm**
```yaml
daily:
  agent: maintenance-agent
  model: sonnet
  focus: surface-scan

weekly:
  agent: synthesis-agent
  model: opus
  focus: pattern-extraction

monthly:
  agents: [synthesis-agent, gap-detector, maintenance-agent]
  model: opus
  focus: strategic-alignment

quarterly:
  agents: [strategic-reviewer, synthesis-agent, gap-detector,
           research-agent, maintenance-agent, orchestrator]
  model: opus
  focus: comprehensive-reflection
```

### 4. Progressive Detail

**Daily**: Headlines only
- What happened yesterday
- What needs attention today
- Flagged items for deeper review

**Weekly**: Synthesis + Actions
- Patterns emerging this week
- Key decisions and outcomes
- Updated playbooks/practices
- Next week priorities

**Monthly**: Strategic + Operational
- Progress on monthly objectives
- System health and optimization
- Knowledge gaps identified
- Adjustments needed

**Quarterly**: Comprehensive + Directional
- Major accomplishments
- Strategic pivots
- Pattern synthesis across 90 days
- Direction for next quarter

## Quick Start

```bash
# Initialize KAAOS with operational rhythms
/kaaos:init personal

# Configure rhythm schedule
# Edit: ~/.kaaos-knowledge/.kaaos/config.yaml

rhythms:
  daily:
    enabled: true
    hour: 7        # 7:00 AM
    minute: 0
  weekly:
    enabled: true
    weekday: 1     # Monday
    hour: 6
    minute: 0
  monthly:
    enabled: true
    day: 1         # 1st of month
    hour: 5
    minute: 0
  quarterly:
    enabled: true
    months: [1, 4, 7, 10]  # Jan, Apr, Jul, Oct
    day: 1
    hour: 3
    minute: 0

# Verify scheduled jobs
/kaaos:status

# Manually trigger a rhythm
/kaaos:review daily
/kaaos:review weekly
```

## Daily Rhythm (5-10 min)

### Purpose
Morning digest to start your day informed without context-switching cost.

### What's Included

**Yesterday's Activity**
- Commits made (with extracted insights)
- Decisions recorded
- Notes created/updated
- Conversations completed

**Attention Required**
- Flagged items needing follow-up
- Broken links detected
- Orphaned notes created
- Scheduled tasks due today

**Today's Context**
- Upcoming meetings with context
- Project priorities
- Recent related work

### Implementation

```python
# Daily rhythm agent
def generate_daily_digest(knowledge_base, date):
    """Generate morning digest for specified date."""

    yesterday = date - timedelta(days=1)

    digest = {
        'date': date.isoformat(),
        'period': {
            'start': yesterday.isoformat(),
            'end': date.isoformat()
        },
        'sections': []
    }

    # Section 1: Yesterday's work
    activity = analyze_activity(knowledge_base, yesterday)
    digest['sections'].append({
        'title': "Yesterday's Activity",
        'items': [
            f"📝 {activity['notes_created']} notes created",
            f"✏️  {activity['notes_updated']} notes updated",
            f"💡 {activity['insights_extracted']} insights extracted",
            f"✅ {activity['decisions_made']} decisions recorded"
        ],
        'details': activity['highlights']
    })

    # Section 2: Needs attention
    attention_items = detect_attention_required(knowledge_base)
    digest['sections'].append({
        'title': "Needs Attention",
        'items': attention_items,
        'priority': 'high' if len(attention_items) > 0 else 'none'
    })

    # Section 3: Today's context
    today_context = generate_today_context(knowledge_base, date)
    digest['sections'].append({
        'title': "Today's Context",
        'items': today_context
    })

    return render_digest(digest, 'daily')
```

### Example Output

```markdown
# Daily Digest - Monday, January 15, 2026

## Yesterday's Activity (Sunday, January 14)

### Work Summary
- 📝 3 notes created
- ✏️  2 notes updated
- 💡 5 insights extracted
- ✅ 1 decision recorded

### Highlights

**New Note**: [[2026-01-050|Sprint Cadence Decision]]
*Decided on 2-week sprints with async planning*
→ Links to: [[PLAY-remote-async]], [[2026-02-020|Agile Practices]]

**Updated**: [[PLAY-quarterly-planning|Quarterly Planning Playbook]]
*Added pre-mortem step based on Company X success*

**Decision**: [[DEC-2026-003|Hire Frontend Lead]]
*Approved budget, work sample created, posting Monday*

**Insight**: Pre-reads reduce meeting time by 40%
*Extracted from retro conversation, created [[2026-01-075]]*

## Needs Attention ⚠️

1. **Broken Link Detected**
   [[2026-03-048]] references [[PLAY-standup]] which doesn't exist
   → Likely renamed to [[PLAY-daily-standup]]
   → Action: Update reference

2. **Orphaned Note**
   [[2026-01-035|Early Framework Draft]] has 0 backlinks
   → Not accessed in 45 days
   → Action: Link from [[MAP-frameworks]] or archive

3. **Scheduled Task Due**
   Review [[DEC-2026-001|Market Entry Decision]]
   → 90-day review scheduled for today
   → Check: Did we achieve expected outcomes?

## Today's Context

### Meetings
- 10:00 AM: Leadership Sync
  *Recent context*: [[2026-01-048|Last week's priorities]]
  *Pre-read*: [[2026-01-075|Meeting pre-read practice]] 📄

- 2:00 PM: Product Planning
  *Project context*: [[projects/product-launch/00-PROJECT-INDEX]]
  *Recent decisions*: [[DEC-2026-003|Frontend Lead Hire]]

### Active Projects
1. **Product Launch** (Week 4 of 12)
   Recent: [[2026-01-050|Sprint Cadence Decision]]

2. **Q1 Planning** (Due: Jan 31)
   Recent: [[PLAY-quarterly-planning|Playbook Updated]]

### This Week
- [ ] Complete Q1 OKR draft (Due: Wed)
- [ ] Schedule frontend candidate interviews (Due: Fri)
- [ ] Review monthly budget (Scheduled: Thu 3pm)

---
*Generated: 2026-01-15 07:00 AM by maintenance-agent*
*Execution time: 8 seconds | Cost: $0.28*
```

### Customization

```yaml
# .kaaos/config.yaml - Daily rhythm settings
rhythms:
  daily:
    enabled: true
    hour: 7
    minute: 0

    # What to include
    include:
      yesterdays_activity: true
      attention_required: true
      todays_context: true
      upcoming_meetings: true
      flagged_items: true

    # Thresholds
    attention_thresholds:
      broken_links: 1        # Flag if any broken links
      orphaned_notes: 2      # Flag if 2+ orphaned notes
      stale_notes: 30        # Flag if not accessed in 30 days

    # Delivery
    output_path: ".digests/daily/"
    notify: true             # System notification when ready
```

## Weekly Rhythm (30-60 min)

### Purpose
Extract patterns from the week, update practices, identify what needs deeper attention.

### What's Included

**Pattern Synthesis**
- Recurring themes across work this week
- Insights that connect previous notes
- Frameworks that emerged from practice

**Key Outcomes**
- Decisions made and their context
- Playbooks applied (and how they worked)
- Experiments run (success/failure)

**Knowledge Updates**
- Notes created/updated with highlights
- Cross-references added
- Map notes updated

**Next Week Planning**
- Carry-forward items
- Strategic priorities
- Scheduled deep work

### Implementation

```python
# Weekly rhythm agent
def generate_weekly_synthesis(knowledge_base, week):
    """Generate weekly synthesis for specified week."""

    notes = get_notes_in_week(knowledge_base, week)
    conversations = get_conversations_in_week(knowledge_base, week)

    synthesis = {
        'week': week.isoformat(),
        'period': f"{week.start_date} to {week.end_date}",
        'sections': []
    }

    # Section 1: Pattern extraction
    patterns = extract_patterns(notes, min_frequency=2)
    synthesis['sections'].append({
        'title': 'Emerging Patterns',
        'patterns': patterns
    })

    # Section 2: Key decisions and outcomes
    decisions = extract_decisions(notes)
    playbooks_used = extract_playbook_usage(notes, conversations)
    synthesis['sections'].append({
        'title': 'Key Outcomes',
        'decisions': decisions,
        'playbooks': playbooks_used
    })

    # Section 3: Knowledge graph updates
    updates = summarize_knowledge_updates(notes)
    synthesis['sections'].append({
        'title': 'Knowledge Updates',
        'updates': updates
    })

    # Section 4: Recommendations
    recommendations = generate_recommendations(
        patterns,
        decisions,
        playbooks_used,
        knowledge_base
    )
    synthesis['sections'].append({
        'title': 'Recommended Actions',
        'items': recommendations
    })

    return render_synthesis(synthesis, 'weekly')
```

### Example Output

See **references/weekly-rhythm-patterns.md** for full example.

### Customization

```yaml
# Weekly rhythm settings
rhythms:
  weekly:
    enabled: true
    weekday: 1  # Monday
    hour: 6
    minute: 0

    # Pattern detection
    pattern_detection:
      min_frequency: 2          # Must appear 2+ times
      semantic_similarity: 0.75 # Similarity threshold
      min_cluster_size: 3       # Min notes to suggest map

    # Recommendations
    recommendations:
      suggest_playbooks: true
      suggest_map_notes: true
      identify_gaps: true
      flag_stale_content: true

    # Output
    output_path: ".digests/weekly/"
    create_todo: true  # Create TODO list from recommendations
```

## Monthly Rhythm (2-3 hours)

### Purpose
Strategic alignment, system health, comprehensive gap analysis.

### What's Included

**Strategic Progress**
- Monthly objectives progress
- Key results tracking
- Major decisions impact

**System Health**
- Knowledge base statistics
- Link health metrics
- Agent performance
- Cost tracking

**Gap Analysis**
- Missing documentation
- Undocumented patterns
- Knowledge decay
- Learning opportunities

**Strategic Adjustments**
- What's working / not working
- Experiments to run next month
- Playbooks to create/update
- Focus areas for next month

### Implementation

```python
# Monthly rhythm orchestrator
def run_monthly_review(knowledge_base, month):
    """Orchestrate monthly review with parallel agents."""

    # Launch agents in parallel
    with agent_pool() as pool:
        # Agent 1: Synthesis
        synthesis_future = pool.submit(
            synthesis_agent.synthesize_month,
            knowledge_base,
            month
        )

        # Agent 2: Gap detection
        gaps_future = pool.submit(
            gap_detector.analyze_gaps,
            knowledge_base,
            month
        )

        # Agent 3: System health
        health_future = pool.submit(
            maintenance_agent.health_check,
            knowledge_base
        )

        # Wait for all agents
        synthesis = synthesis_future.result()
        gaps = gaps_future.result()
        health = health_future.result()

    # Combine results
    monthly_review = {
        'month': month.isoformat(),
        'synthesis': synthesis,
        'gaps': gaps,
        'health': health,
        'recommendations': generate_monthly_recommendations(
            synthesis,
            gaps,
            health
        )
    }

    return render_review(monthly_review, 'monthly')
```

### Example Output

See **references/monthly-rhythm-patterns.md** for full example.

## Quarterly Rhythm (half-day)

### Purpose
Comprehensive strategic reflection, major pattern synthesis, directional planning.

### What's Included

**Comprehensive Synthesis**
- 90-day pattern extraction
- Cross-organization learnings
- Major themes and pivots

**Strategic Review**
- Quarterly objectives results
- Decision quality assessment
- Experiment outcomes

**System Evolution**
- Knowledge architecture review
- Tool and process improvements
- Automation opportunities

**Directional Planning**
- Next quarter focus areas
- Strategic bets
- Learning priorities

### Implementation

```python
# Quarterly rhythm orchestrator
def run_quarterly_review(knowledge_base, quarter):
    """Full agent suite for comprehensive quarterly review."""

    # Maximum parallelization
    with agent_pool(max_workers=6) as pool:
        futures = {
            'strategic': pool.submit(
                strategic_reviewer.comprehensive_review,
                knowledge_base, quarter
            ),
            'synthesis': pool.submit(
                synthesis_agent.quarterly_synthesis,
                knowledge_base, quarter
            ),
            'gaps': pool.submit(
                gap_detector.deep_analysis,
                knowledge_base, quarter
            ),
            'research': pool.submit(
                research_agent.trend_analysis,
                knowledge_base, quarter
            ),
            'maintenance': pool.submit(
                maintenance_agent.quarterly_optimization,
                knowledge_base
            ),
            'orchestrator': pool.submit(
                orchestrator.meta_analysis,
                knowledge_base, quarter
            )
        }

        # Collect results
        results = {
            key: future.result()
            for key, future in futures.items()
        }

    # Strategic synthesis across all agent outputs
    quarterly_review = orchestrator.synthesize_quarterly(
        results,
        quarter
    )

    return quarterly_review
```

### Example Output

See **references/quarterly-rhythm-patterns.md** for full example (truncated due to length).

## Scheduling and Automation

### macOS launchd Configuration

```xml
<!-- ~/Library/LaunchAgents/com.kaaos.daily.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.kaaos.daily</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/kaaos</string>
        <string>review</string>
        <string>daily</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>7</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>/Users/ben/.kaaos-knowledge/.kaaos/logs/daily.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/ben/.kaaos-knowledge/.kaaos/logs/daily.error.log</string>
</dict>
</plist>
```

### Load Schedule

```bash
# Load all rhythm schedules
launchctl load ~/Library/LaunchAgents/com.kaaos.daily.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.weekly.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.monthly.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.quarterly.plist

# Verify loaded
launchctl list | grep kaaos

# Trigger manually for testing
launchctl start com.kaaos.daily
```

## Cost Management

### Budget Allocation

```yaml
# Monthly budget: $100
daily: $9      # $0.30 × 30 days
weekly: $20    # $5 × 4 weeks
monthly: $15   # $15 × 1
quarterly: $50 # $50 × 1 (every 3 months, so ~$16/month amortized)
# Total: ~$60/month actual, $44/month amortized
```

### Cost Controls

```python
def check_budget_before_run(rhythm_type):
    """Verify budget before executing rhythm."""

    current_spend = get_current_month_spend()
    estimated_cost = RHYTHM_COSTS[rhythm_type]
    monthly_limit = get_config('cost_controls.monthly_limit_usd')

    if current_spend + estimated_cost > monthly_limit:
        # Check if hard stop enabled
        if get_config('cost_controls.hard_stop_on_limit'):
            raise BudgetExceededError(
                f"Monthly limit ${monthly_limit} would be exceeded. "
                f"Current: ${current_spend}, Estimated: ${estimated_cost}"
            )
        else:
            # Log warning but continue
            log_warning(f"Approaching monthly limit: ${current_spend + estimated_cost} / ${monthly_limit}")

    # Check alert threshold
    alert_threshold = get_config('cost_controls.alert_threshold_percent')
    if (current_spend + estimated_cost) / monthly_limit * 100 >= alert_threshold:
        notify_user(f"Budget at {percentage}% of monthly limit")

    return True
```

## Best Practices

1. **Start Automated**: Let agents run without manual intervention
2. **Review, Don't Generate**: Spend time reviewing digests, not creating them
3. **Customize Gradually**: Start with defaults, adjust based on value
4. **Track Costs**: Monitor spend per rhythm, adjust if needed
5. **Trust the System**: Resist urge to manually check between rhythms
6. **Act on Recommendations**: Flagged items need follow-up
7. **Evolve Templates**: Update digest formats as needs change
8. **Measure Value**: Track time saved vs insights gained

## Common Pitfalls

- **Over-Reviewing**: Checking daily digest multiple times dilutes value
- **Ignoring Flags**: Attention items accumulate if not addressed
- **Manual Generation**: Defeats automation purpose
- **One-Size-Fits-All**: Customize for your needs
- **Missing Budget Alerts**: Costs can accumulate
- **No Action on Insights**: Digests are inputs for decisions
- **Skipping Rhythms**: Consistency creates compound value

## Resources

- **references/daily-rhythm-patterns.md**: Daily digest deep dive
- **references/weekly-rhythm-patterns.md**: Weekly synthesis patterns
- **references/monthly-rhythm-patterns.md**: Monthly review structure
- **references/quarterly-rhythm-patterns.md**: Quarterly comprehensive review
- **assets/daily-template.md**: Daily digest template
- **assets/weekly-template.md**: Weekly synthesis template
- **assets/monthly-template.md**: Monthly review template
- **assets/quarterly-template.md**: Quarterly review template
- **assets/launchd-configs/**: macOS scheduling configurations
