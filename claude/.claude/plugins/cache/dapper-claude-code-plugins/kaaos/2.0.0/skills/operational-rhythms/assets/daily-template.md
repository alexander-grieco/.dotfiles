# Daily Digest Template

Template for automated daily digest generation. This template is used by the maintenance agent to create morning digests.

## Template Structure

```markdown
# Daily Digest - [Day], [Date]

## Yesterday's Activity ([Previous Date])

### Work Summary
- 📝 [X] notes created
- ✏️  [X] notes updated
- 💡 [X] insights extracted
- ✅ [X] decisions recorded

### Highlights

[FOR EACH NEW NOTE]
**New Note**: [[note-id|Note Title]]
*[One-line summary]*
→ Links to: [[ref-1]], [[ref-2]]

[FOR EACH UPDATED NOTE]
**Updated**: [[note-id|Note Title]]
*[What changed]*

[FOR EACH DECISION]
**Decision**: [[decision-id|Decision Title]]
*[Brief decision statement]*

[FOR EACH INSIGHT EXTRACTED]
**Insight**: [Insight summary]
*Extracted from [source], created [[note-id]]*

## Needs Attention ⚠️

[IF NONE]
*No items flagged for attention*

[FOR EACH ATTENTION ITEM]
[N]. **[Category]**
   [Description of issue]
   → [Recommended action]

## Today's Context

### Meetings
[FOR EACH MEETING TODAY]
- [Time]: [Meeting Title]
  *Recent context*: [[relevant-note]]
  *Pre-read*: [[pre-read-note]] 📄

[IF NO MEETINGS]
*No meetings scheduled*

### Active Projects
[FOR EACH ACTIVE PROJECT]
[N]. **[Project Name]** ([Status])
   Recent: [[recent-note]]

### This Week
[FOR EACH TODO DUE THIS WEEK]
- [ ] [Task description] (Due: [Date])

---
*Generated: [Timestamp] by maintenance-agent*
*Execution time: [X] seconds | Cost: $[Amount]*
```

## Agent Implementation

```python
def generate_daily_digest(date):
    """Generate daily digest for specified date."""

    yesterday = date - timedelta(days=1)
    knowledge_base = load_knowledge_base()

    # Template data structure
    digest = {
        'date': date,
        'yesterday': yesterday,
        'activity': {},
        'attention_items': [],
        'today_context': {}
    }

    # Section 1: Yesterday's activity
    digest['activity'] = analyze_yesterday(knowledge_base, yesterday)

    # Section 2: Attention required
    digest['attention_items'] = detect_attention_items(knowledge_base)

    # Section 3: Today's context
    digest['today_context'] = generate_today_context(knowledge_base, date)

    # Render using template
    return render_template('daily-digest.md', digest)
```

## Section Generators

### Yesterday's Activity

```python
def analyze_yesterday(knowledge_base, date):
    """Analyze yesterday's work."""

    # Get all activity from yesterday
    notes_created = find_notes_created_on(knowledge_base, date)
    notes_updated = find_notes_updated_on(knowledge_base, date)
    insights = extract_insights_from_commits(knowledge_base, date)
    decisions = find_decisions_on(knowledge_base, date)

    # Generate highlights
    highlights = []

    # New notes
    for note in notes_created:
        highlights.append({
            'type': 'new_note',
            'note_id': note.id,
            'title': note.title,
            'summary': note.summary,
            'references': extract_references(note.content)[:3]
        })

    # Updated notes
    for note in notes_updated:
        diff = get_note_diff(note, date)
        highlights.append({
            'type': 'updated_note',
            'note_id': note.id,
            'title': note.title,
            'changes': summarize_diff(diff)
        })

    # Decisions
    for decision in decisions:
        highlights.append({
            'type': 'decision',
            'note_id': decision.id,
            'title': decision.title,
            'summary': decision.summary
        })

    # Insights
    for insight in insights:
        highlights.append({
            'type': 'insight',
            'summary': insight.summary,
            'source': insight.source,
            'note_id': insight.note_id
        })

    return {
        'counts': {
            'notes_created': len(notes_created),
            'notes_updated': len(notes_updated),
            'insights': len(insights),
            'decisions': len(decisions)
        },
        'highlights': highlights
    }
```

### Attention Required

```python
def detect_attention_items(knowledge_base):
    """Detect items requiring attention."""

    attention_items = []

    # Check for broken links
    broken_links = find_broken_links(knowledge_base)
    if broken_links:
        for broken in broken_links:
            attention_items.append({
                'category': 'Broken Link Detected',
                'description': f"[[{broken['source']}]] references [[{broken['broken_ref']}]] which doesn't exist",
                'action': f"Update reference or create missing note",
                'priority': 'medium'
            })

    # Check for orphaned notes
    orphaned = find_orphaned_notes(knowledge_base)
    if orphaned:
        for orphan in orphaned:
            # Only flag if not accessed recently
            days_since_access = (datetime.now() - orphan.last_accessed).days
            if days_since_access > 30:
                attention_items.append({
                    'category': 'Orphaned Note',
                    'description': f"[[{orphan.id}|{orphan.title}]] has 0 backlinks",
                    'action': f"Link from relevant map note or archive",
                    'priority': 'low'
                })

    # Check for scheduled tasks
    scheduled = find_scheduled_tasks_due_today(knowledge_base)
    for task in scheduled:
        attention_items.append({
            'category': 'Scheduled Task Due',
            'description': f"{task.description}",
            'action': f"Complete task: {task.action}",
            'priority': 'high'
        })

    # Check for review-due items
    reviews = find_items_needing_review(knowledge_base, datetime.now())
    for review in reviews:
        attention_items.append({
            'category': 'Review Due',
            'description': f"Review [[{review.id}|{review.title}]]",
            'action': f"{review.review_question}",
            'priority': 'medium'
        })

    # Sort by priority
    priority_order = {'high': 0, 'medium': 1, 'low': 2}
    attention_items.sort(key=lambda x: priority_order[x['priority']])

    return attention_items
```

### Today's Context

```python
def generate_today_context(knowledge_base, date):
    """Generate context for today."""

    context = {}

    # Load calendar (if integrated)
    meetings = get_meetings_for_date(date)
    context['meetings'] = []

    for meeting in meetings:
        # Find related context
        keywords = extract_keywords_from_title(meeting.title)
        related_notes = find_notes_by_keywords(
            knowledge_base,
            keywords,
            limit=3
        )

        # Check for pre-read
        pre_read = find_meeting_pre_read(
            knowledge_base,
            meeting.title,
            meeting.date
        )

        context['meetings'].append({
            'time': meeting.time,
            'title': meeting.title,
            'related_notes': related_notes,
            'pre_read': pre_read
        })

    # Active projects
    active_projects = find_active_projects(knowledge_base)
    context['active_projects'] = []

    for project in active_projects:
        recent_note = find_most_recent_note(
            knowledge_base,
            project.path
        )

        context['active_projects'].append({
            'name': project.name,
            'status': project.status,
            'recent_note': recent_note
        })

    # This week's tasks
    week_start = date - timedelta(days=date.weekday())
    week_end = week_start + timedelta(days=6)

    tasks = find_tasks_due_between(
        knowledge_base,
        week_start,
        week_end
    )

    context['week_tasks'] = tasks

    return context
```

## Example Output

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

**New Note**: [[2026-01-055|Hiring Budget Approval]]
*Approved budget for frontend lead, $140-160K + equity*
→ Links to: [[DEC-2026-003|Frontend Lead Hire]], [[2026-01-085|Compensation Framework]]

**New Note**: [[2026-01-062|Marketing Channel Experiment]]
*$5K test budget for Reddit community engagement*
→ Links to: [[2026-01-020|Two-Way Door Thinking]]

**Updated**: [[PLAY-quarterly-planning|Quarterly Planning Playbook]]
*Added pre-mortem step based on Company X success*

**Updated**: [[MAP-decision-frameworks|Decision Frameworks Map]]
*Added 3 new framework notes*

**Decision**: [[DEC-2026-003|Hire Frontend Lead]]
*Approved hiring frontend lead, job posting created*

**Insight**: Pre-reads reduce meeting time by 40%
*Extracted from retro conversation, created [[2026-01-075]]*

**Insight**: Async standups save 7.5 hours/week for team
*Extracted from engineering team feedback*

**Insight**: Work samples predict hire success (0.72 correlation)
*From hiring retrospective, added to [[PLAY-hiring-process]]*

**Insight**: Decision frameworks being naturally combined
*Pattern detected: Pre-mortems + reversibility analysis*

**Insight**: Knowledge gaps in hiring process
*Identified missing documentation: work samples, rubrics, offer negotiation*

## Needs Attention ⚠️

1. **Broken Link Detected**
   [[2026-03-048|Team Velocity]] references [[PLAY-standup]] which doesn't exist
   → Likely renamed to [[PLAY-daily-standup]], update reference

2. **Orphaned Note**
   [[2026-01-035|Early Framework Draft]] has 0 backlinks
   → Not accessed in 45 days, link from [[MAP-frameworks]] or archive

3. **Scheduled Task Due**
   Review [[DEC-2026-001|Market Entry Decision]]
   → 90-day review scheduled for today, check outcomes vs expectations

4. **Review Due**
   Review [[2026-01-062|Marketing Channel Experiment]]
   → Week 1 check-in: Are we getting qualified leads?

## Today's Context

### Meetings
- 10:00 AM: Leadership Sync
  *Recent context*: [[2026-01-048|Last Week's Priorities]]
  *Pre-read*: [[2026-01-075|Meeting Pre-Read Practice]] 📄

- 2:00 PM: Product Planning
  *Recent context*: [[projects/product-launch/00-PROJECT-INDEX]]
  *Recent decision*: [[2026-01-050|Sprint Cadence Decision]]

### Active Projects
1. **Product Launch** (Week 4 of 12)
   Recent: [[2026-01-050|Sprint Cadence Decision]]

2. **Q1 Planning** (Due: Jan 31)
   Recent: [[PLAY-quarterly-planning|Playbook Updated]]

3. **Frontend Hiring** (Active)
   Recent: [[DEC-2026-003|Hire Approved]]

### This Week
- [ ] Complete Q1 OKR draft (Due: Wed)
- [ ] Schedule frontend candidate interviews (Due: Fri)
- [ ] Review monthly budget (Scheduled: Thu 3pm)
- [ ] Create hiring playbook (Due: Fri)

---
*Generated: 2026-01-15 07:00 AM by maintenance-agent*
*Execution time: 8 seconds | Cost: $0.28*
```

## Customization Options

### Configuration

```yaml
# .kaaos/config.yaml
rhythms:
  daily:
    enabled: true
    hour: 7
    minute: 0

    # Content sections
    include:
      yesterdays_activity: true
      activity_highlights: true
      attention_required: true
      todays_meetings: true
      active_projects: true
      week_tasks: true

    # Activity detail level
    activity_detail: medium  # minimal, medium, detailed

    # Attention thresholds
    attention:
      broken_links: true
      orphaned_notes: true
      orphan_days_threshold: 30
      scheduled_tasks: true
      review_due: true
      stale_notes: false
      stale_days_threshold: 90

    # Highlight limits
    limits:
      new_notes: 10
      updated_notes: 5
      insights: 10
      decisions: 5

    # Output
    output_path: ".digests/daily/"
    format: markdown
    notify: true  # macOS notification when ready
```

### Notification Setup (macOS)

```bash
# .kaaos/scripts/notify-daily-digest.sh
#!/bin/bash

DIGEST_FILE="$1"
DATE=$(date +"%B %d, %Y")

osascript -e "display notification \"Daily digest ready\" with title \"KAAOS\" subtitle \"$DATE\""

# Optional: Open in editor
# open -a "Obsidian" "$DIGEST_FILE"
```

## Usage

### Manual Generation

```bash
# Generate for today
/kaaos:digest daily

# Generate for specific date
/kaaos:digest daily 2026-01-15

# View most recent
/kaaos:digest daily --view
```

### Automated Generation

Runs automatically via launchd:

```xml
<!-- ~/Library/LaunchAgents/com.kaaos.daily.plist -->
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>7</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

### Integration with Morning Routine

```bash
# In .zshrc or .bashrc
alias morning='cat ~/.kaaos-knowledge/.digests/daily/$(date +%Y-%m-%d).md | less'

# Or with rich display
alias morning='glow ~/.kaaos-knowledge/.digests/daily/$(date +%Y-%m-%d).md'
```

## Best Practices

1. **Review First Thing**: Make it part of morning routine
2. **Act on Attention Items**: Don't let them accumulate
3. **Check Meeting Context**: Load relevant notes before meetings
4. **Quick Scan**: 5-10 minutes maximum
5. **Flag for Weekly**: Note patterns for weekly synthesis
6. **Update Config**: Adjust to your needs
7. **Disable if Noisy**: Only include valuable sections

## Common Issues

### Too Much Detail

**Problem**: Digest overwhelming

**Solution**:
- Set `activity_detail: minimal`
- Reduce `limits` for each category
- Disable less useful sections

### Missing Information

**Problem**: Important items not showing

**Solution**:
- Check `include` settings
- Lower `attention` thresholds
- Review `limits` settings

### Wrong Time

**Problem**: Digest generates at wrong time

**Solution**:
- Update `hour`/`minute` in config
- Reload launchd config:
```bash
launchctl unload ~/Library/LaunchAgents/com.kaaos.daily.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.daily.plist
```
