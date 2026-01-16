---
template: daily-digest
version: "1.0"
description: Template for automated daily digest generation
usage: Used by maintenance agent to create morning digests
placeholders:
  - "{{DATE}}" - Current date (e.g., "Monday, January 15, 2026")
  - "{{PREVIOUS_DATE}}" - Yesterday's date
  - "{{TIMESTAMP}}" - Generation timestamp (ISO-8601)
  - "{{EXECUTION_TIME}}" - Time to generate in seconds
  - "{{COST}}" - API cost for generation
---

# Daily Digest Template

This template defines the structure for automated daily digest generation. The maintenance agent uses this template to create morning digests summarizing the previous day's activity.

## Template Output

```markdown
# Daily Digest - {{DATE}}

## Yesterday's Activity ({{PREVIOUS_DATE}})

### Work Summary
{{ACTIVITY_STATS}}

### Highlights

{{#EACH NEW_NOTE}}
**New Note**: [[{{NOTE_ID}}|{{NOTE_TITLE}}]]
*{{SUMMARY}}*
> Links to: {{REFERENCES}}
{{/EACH}}

{{#EACH UPDATED_NOTE}}
**Updated**: [[{{NOTE_ID}}|{{NOTE_TITLE}}]]
*{{CHANGES}}*
{{/EACH}}

{{#EACH DECISION}}
**Decision**: [[{{DECISION_ID}}|{{DECISION_TITLE}}]]
*{{DECISION_SUMMARY}}*
{{/EACH}}

{{#EACH INSIGHT}}
**Insight**: {{INSIGHT_SUMMARY}}
*Extracted from {{SOURCE}}, created [[{{NOTE_ID}}]]*
{{/EACH}}

## Needs Attention

{{#IF NO_ATTENTION_ITEMS}}
*No items flagged for attention*
{{/IF}}

{{#EACH ATTENTION_ITEM}}
{{INDEX}}. **{{CATEGORY}}**
   {{DESCRIPTION}}
   > {{RECOMMENDED_ACTION}}
{{/EACH}}

## Today's Context

### Meetings
{{#EACH MEETING}}
- {{TIME}}: {{TITLE}}
  *Recent context*: [[{{RELEVANT_NOTE}}]]
  {{#IF PRE_READ}}*Pre-read*: [[{{PRE_READ_NOTE}}]]{{/IF}}
{{/EACH}}

{{#IF NO_MEETINGS}}
*No meetings scheduled*
{{/IF}}

### Active Projects
{{#EACH PROJECT}}
{{INDEX}}. **{{PROJECT_NAME}}** ({{STATUS}})
   Recent: [[{{RECENT_NOTE}}]]
{{/EACH}}

### This Week
{{#EACH TASK}}
- [ ] {{DESCRIPTION}} (Due: {{DUE_DATE}})
{{/EACH}}

---
*Generated: {{TIMESTAMP}} by maintenance-agent*
*Execution time: {{EXECUTION_TIME}} seconds | Cost: ${{COST}}*
```

## Data Structures

### Activity Stats Format

```yaml
activity_stats:
  notes_created: 0       # Number of new notes
  notes_updated: 0       # Number of updated notes
  insights_extracted: 0  # Number of insights
  decisions_recorded: 0  # Number of decisions
```

Rendered as:
```markdown
- 📝 3 notes created
- ✏️  2 notes updated
- 💡 5 insights extracted
- ✅ 1 decision recorded
```

### Highlight Types

| Type | Icon | Description |
|------|------|-------------|
| new_note | 📝 | Newly created note |
| updated_note | ✏️ | Modified note |
| decision | ✅ | Decision recorded |
| insight | 💡 | Insight extracted |

### Attention Item Categories

| Category | Priority | Description |
|----------|----------|-------------|
| Broken Link Detected | Medium | [[reference]] to non-existent note |
| Orphaned Note | Low | Note with 0 inbound links |
| Scheduled Task Due | High | Task with due date today |
| Review Due | Medium | Item flagged for periodic review |
| Stale Note | Low | Note not accessed for threshold days |

## Generation Logic

### Yesterday's Activity Analysis

```python
def analyze_yesterday(knowledge_base, date):
    """Analyze yesterday's work."""

    activity = {
        'notes_created': [],
        'notes_updated': [],
        'decisions': [],
        'insights': []
    }

    # Find notes created yesterday
    activity['notes_created'] = find_notes_by_date(
        knowledge_base,
        created_on=date
    )

    # Find notes updated yesterday (excluding created)
    created_ids = [n.id for n in activity['notes_created']]
    activity['notes_updated'] = [
        n for n in find_notes_by_date(knowledge_base, modified_on=date)
        if n.id not in created_ids
    ]

    # Find decisions (notes with 'decision' type or DEC- prefix)
    activity['decisions'] = [
        n for n in activity['notes_created']
        if n.type == 'decision' or n.id.startswith('DEC-')
    ]

    # Extract insights from git commits
    activity['insights'] = extract_insights_from_commits(
        knowledge_base,
        date
    )

    return activity
```

### Attention Detection

```python
def detect_attention_items(knowledge_base, config):
    """Detect items requiring attention."""

    attention_items = []

    # Broken links
    if config.attention.broken_links:
        for broken in find_broken_links(knowledge_base):
            attention_items.append({
                'category': 'Broken Link Detected',
                'priority': 'medium',
                'description': f"[[{broken.source}]] references [[{broken.target}]] which doesn't exist",
                'action': f"Update reference or create missing note"
            })

    # Orphaned notes
    if config.attention.orphaned_notes:
        threshold = config.attention.orphan_days_threshold
        for orphan in find_orphaned_notes(knowledge_base, min_age_days=threshold):
            attention_items.append({
                'category': 'Orphaned Note',
                'priority': 'low',
                'description': f"[[{orphan.id}|{orphan.title}]] has 0 backlinks",
                'action': f"Link from relevant map note or archive"
            })

    # Scheduled tasks
    if config.attention.scheduled_tasks:
        for task in find_tasks_due_today(knowledge_base):
            attention_items.append({
                'category': 'Scheduled Task Due',
                'priority': 'high',
                'description': task.description,
                'action': task.action
            })

    # Review due
    if config.attention.review_due:
        for review in find_items_needing_review(knowledge_base, datetime.now()):
            attention_items.append({
                'category': 'Review Due',
                'priority': 'medium',
                'description': f"Review [[{review.id}|{review.title}]]",
                'action': review.review_question
            })

    # Sort by priority
    priority_order = {'high': 0, 'medium': 1, 'low': 2}
    attention_items.sort(key=lambda x: priority_order[x['priority']])

    return attention_items
```

### Today's Context Generation

```python
def generate_today_context(knowledge_base, date, calendar=None):
    """Generate context for today."""

    context = {
        'meetings': [],
        'projects': [],
        'tasks': []
    }

    # Meetings (if calendar integrated)
    if calendar:
        for meeting in calendar.get_meetings(date):
            # Find related context
            keywords = extract_keywords(meeting.title)
            related = find_notes_by_keywords(knowledge_base, keywords, limit=3)

            context['meetings'].append({
                'time': meeting.time.strftime('%I:%M %p'),
                'title': meeting.title,
                'relevant_note': related[0] if related else None,
                'pre_read': find_meeting_pre_read(knowledge_base, meeting)
            })

    # Active projects
    for project in find_active_projects(knowledge_base):
        recent = find_most_recent_note(knowledge_base, project.path)
        context['projects'].append({
            'name': project.name,
            'status': project.status,
            'recent_note': recent
        })

    # This week's tasks
    week_end = date + timedelta(days=(6 - date.weekday()))
    context['tasks'] = find_tasks_due_between(knowledge_base, date, week_end)

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
> Links to: [[PLAY-remote-async]], [[2026-02-020|Agile Practices]]

**New Note**: [[2026-01-055|Hiring Budget Approval]]
*Approved budget for frontend lead, $140-160K + equity*
> Links to: [[DEC-2026-003|Frontend Lead Hire]]

**Updated**: [[PLAY-quarterly-planning|Quarterly Planning Playbook]]
*Added pre-mortem step based on Company X success*

**Decision**: [[DEC-2026-003|Hire Frontend Lead]]
*Approved hiring frontend lead, job posting created*

**Insight**: Pre-reads reduce meeting time by 40%
*Extracted from retro conversation, created [[2026-01-075]]*

## Needs Attention

1. **Broken Link Detected**
   [[2026-03-048|Team Velocity]] references [[PLAY-standup]] which doesn't exist
   > Likely renamed to [[PLAY-daily-standup]], update reference

2. **Scheduled Task Due**
   Review [[DEC-2026-001|Market Entry Decision]]
   > 90-day review scheduled for today

## Today's Context

### Meetings
- 10:00 AM: Leadership Sync
  *Recent context*: [[2026-01-048|Last Week's Priorities]]
  *Pre-read*: [[2026-01-075|Meeting Pre-Read Practice]]

- 2:00 PM: Product Planning
  *Recent context*: [[projects/product-launch/00-PROJECT-INDEX]]

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
*Generated: 2026-01-15T07:00:00-08:00 by maintenance-agent*
*Execution time: 8 seconds | Cost: $0.28*
```

## Configuration Options

```yaml
# In .kaaos/config.yaml
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

    # Highlight limits
    limits:
      new_notes: 10
      updated_notes: 5
      insights: 10
      decisions: 5

    # Output
    output_path: ".digests/daily/"
    format: markdown
    notify: true
```

## Best Practices

1. **Review first thing** - Make the daily digest part of your morning routine
2. **Act on attention items** - Don't let them accumulate across days
3. **Check meeting context** - Load relevant notes before meetings
4. **Quick scan** - The digest should take 5-10 minutes to review
5. **Flag for weekly** - Note patterns worth exploring in weekly synthesis
6. **Adjust config** - Tune limits and thresholds to your workflow

## Related Templates

- [[weekly-digest.md]] - Weekly pattern synthesis
- [[monthly-digest.md]] - Monthly strategic review
- [[quarterly-digest.md]] - Quarterly comprehensive analysis

---

*Part of KAAOS Operational Rhythms*
