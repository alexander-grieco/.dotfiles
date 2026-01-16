# Daily Rhythm Patterns

Detailed patterns for daily digest generation including activity scanning, attention detection, and context preparation.

## Daily Rhythm Structure

### Time Commitment
- **Agent Generation**: 30-60 seconds (automated)
- **Human Review**: 5-10 minutes (morning routine)
- **Actions**: Immediate flagging, defer to weekly

### Agent: Maintenance Agent (Sonnet)
- **Focus**: Surface-level scan, urgency detection
- **Cost**: ~$0.30 per run
- **Frequency**: Every morning at configured hour (default 7:00 AM)

## Activity Scanning Methodology

### Git Commit Analysis

```python
def analyze_yesterday_commits(knowledge_base, date):
    """Extract insights from yesterday's git commits."""

    yesterday = date - timedelta(days=1)

    # Get all commits from yesterday
    commits = get_commits_for_date(knowledge_base, yesterday)

    insights = []
    for commit in commits:
        # Parse commit message structure
        parsed = parse_commit_message(commit.message)

        # Extract file changes
        files = get_commit_files(commit.sha)

        # Categorize commit type
        commit_type = categorize_commit(parsed, files)

        # Generate insight based on type
        if commit_type == 'note_created':
            insights.append({
                'type': 'new_note',
                'note_path': files[0],
                'summary': parsed.get('summary', commit.message[:100]),
                'tags': extract_tags(commit.message)
            })
        elif commit_type == 'note_updated':
            insights.append({
                'type': 'updated_note',
                'note_path': files[0],
                'changes': summarize_diff(commit.sha),
                'sections_modified': detect_modified_sections(commit.sha)
            })
        elif commit_type == 'decision':
            insights.append({
                'type': 'decision',
                'decision_id': extract_decision_id(parsed),
                'summary': parsed.get('summary'),
                'outcome': parsed.get('outcome')
            })
        elif commit_type == 'insight_extraction':
            insights.append({
                'type': 'insight',
                'source': parsed.get('source'),
                'note_created': files[0] if files else None,
                'summary': parsed.get('insight')
            })

    return {
        'commit_count': len(commits),
        'insights': insights,
        'activity_summary': summarize_activity(insights)
    }
```

### Note Change Detection

```python
def detect_note_changes(knowledge_base, date):
    """Detect all note changes on specified date."""

    changes = {
        'created': [],
        'updated': [],
        'deleted': [],
        'renamed': []
    }

    # Get git log for the date
    log = get_git_log_for_date(knowledge_base.path, date)

    for entry in log:
        for file_change in entry.files:
            if not file_change.path.endswith('.md'):
                continue

            if file_change.status == 'A':  # Added
                note = load_note(file_change.path)
                changes['created'].append({
                    'path': file_change.path,
                    'title': note.title if note else file_change.path,
                    'summary': extract_summary(note),
                    'links': extract_links(note),
                    'timestamp': entry.timestamp
                })
            elif file_change.status == 'M':  # Modified
                note = load_note(file_change.path)
                diff = get_file_diff(file_change.path, entry.sha)
                changes['updated'].append({
                    'path': file_change.path,
                    'title': note.title if note else file_change.path,
                    'changes_summary': summarize_diff(diff),
                    'lines_added': diff.additions,
                    'lines_removed': diff.deletions,
                    'timestamp': entry.timestamp
                })
            elif file_change.status == 'D':  # Deleted
                changes['deleted'].append({
                    'path': file_change.path,
                    'timestamp': entry.timestamp
                })
            elif file_change.status.startswith('R'):  # Renamed
                changes['renamed'].append({
                    'old_path': file_change.old_path,
                    'new_path': file_change.path,
                    'timestamp': entry.timestamp
                })

    return changes
```

### Insight Extraction from Conversations

```python
def extract_conversation_insights(knowledge_base, date):
    """Extract insights from yesterday's Claude conversations."""

    conversations_dir = knowledge_base.path / '.conversations'
    yesterday = date - timedelta(days=1)

    insights = []

    # Find conversations from yesterday
    for conv_file in conversations_dir.glob('*.json'):
        conv = load_conversation(conv_file)

        if conv.date.date() != yesterday.date():
            continue

        # Look for insight patterns in conversation
        for message in conv.messages:
            if message.role == 'assistant':
                # Check for note creation mentions
                note_refs = extract_note_references(message.content)
                if note_refs and 'created' in message.content.lower():
                    insights.append({
                        'type': 'note_created_in_conversation',
                        'note_refs': note_refs,
                        'context': extract_context(message.content, 100)
                    })

                # Check for explicit insights
                if 'insight:' in message.content.lower() or 'key learning:' in message.content.lower():
                    insights.append({
                        'type': 'explicit_insight',
                        'content': extract_insight_content(message.content),
                        'source_conversation': conv.id
                    })

                # Check for decision mentions
                if any(word in message.content.lower() for word in ['decided', 'decision:', 'conclusion:']):
                    insights.append({
                        'type': 'decision_mention',
                        'content': extract_decision_content(message.content),
                        'source_conversation': conv.id
                    })

    return insights
```

## Attention Detection Algorithm

### Priority Scoring System

```python
class AttentionPriority:
    CRITICAL = 1   # Blocks work, must address today
    HIGH = 2       # Should address today
    MEDIUM = 3     # Address this week
    LOW = 4        # Nice to address eventually

def calculate_attention_priority(item):
    """Calculate priority score for attention item."""

    if item['type'] == 'broken_link':
        # Higher priority if in recently accessed note
        if item['source_note_access_days'] < 7:
            return AttentionPriority.HIGH
        return AttentionPriority.MEDIUM

    elif item['type'] == 'orphaned_note':
        # Priority based on note type and age
        if item['note_type'] == 'decision':
            return AttentionPriority.HIGH  # Decisions should be linked
        if item['days_orphaned'] > 60:
            return AttentionPriority.LOW   # Probably can archive
        return AttentionPriority.MEDIUM

    elif item['type'] == 'scheduled_task':
        if item['due_date'] == date.today():
            return AttentionPriority.CRITICAL
        if item['due_date'] < date.today():
            return AttentionPriority.CRITICAL  # Overdue
        return AttentionPriority.HIGH

    elif item['type'] == 'review_due':
        if item['overdue_days'] > 7:
            return AttentionPriority.HIGH
        return AttentionPriority.MEDIUM

    elif item['type'] == 'stale_note':
        if item['days_stale'] > 90:
            return AttentionPriority.LOW
        return AttentionPriority.LOW

    return AttentionPriority.LOW
```

### Broken Link Detection

```python
def detect_broken_links(knowledge_base):
    """Find all broken internal links in knowledge base."""

    broken_links = []

    # Build set of valid note IDs
    valid_ids = set()
    for note_path in knowledge_base.path.rglob('*.md'):
        note_id = extract_note_id(note_path)
        valid_ids.add(note_id)

        # Also add aliases
        note = load_note(note_path)
        if note.aliases:
            valid_ids.update(note.aliases)

    # Check all links in all notes
    for note_path in knowledge_base.path.rglob('*.md'):
        note = load_note(note_path)
        links = extract_wikilinks(note.content)

        for link in links:
            link_target = normalize_link_target(link)

            if link_target not in valid_ids:
                # Check if it's a near match (typo detection)
                close_matches = find_close_matches(link_target, valid_ids, cutoff=0.8)

                broken_links.append({
                    'source_note': note_path,
                    'source_note_title': note.title,
                    'broken_reference': link,
                    'normalized_target': link_target,
                    'suggested_targets': close_matches[:3],
                    'line_number': find_link_line_number(note.content, link),
                    'context': extract_link_context(note.content, link)
                })

    return broken_links
```

### Orphaned Note Detection

```python
def detect_orphaned_notes(knowledge_base, exclude_types=None):
    """Find notes with zero incoming links."""

    exclude_types = exclude_types or ['INDEX', 'MAP', 'PLAY', 'PATT']

    # Build backlink map
    backlinks = defaultdict(set)

    for note_path in knowledge_base.path.rglob('*.md'):
        note = load_note(note_path)
        links = extract_wikilinks(note.content)

        for link in links:
            target_id = normalize_link_target(link)
            backlinks[target_id].add(note.id)

    orphaned = []

    for note_path in knowledge_base.path.rglob('*.md'):
        note = load_note(note_path)

        # Skip excluded types
        if any(note.id.startswith(prefix) for prefix in exclude_types):
            continue

        # Skip if has backlinks
        if note.id in backlinks and len(backlinks[note.id]) > 0:
            continue

        # Calculate days since last access
        last_access = get_note_last_access(note_path)
        days_since_access = (datetime.now() - last_access).days if last_access else 999

        orphaned.append({
            'note_path': note_path,
            'note_id': note.id,
            'title': note.title,
            'created_date': note.created_date,
            'days_since_access': days_since_access,
            'note_type': detect_note_type(note),
            'word_count': count_words(note.content),
            'suggested_maps': suggest_map_notes(note, knowledge_base)
        })

    return orphaned
```

### Scheduled Task Detection

```python
def detect_scheduled_tasks(knowledge_base, date):
    """Find scheduled tasks due on or before date."""

    scheduled_tasks = []

    for note_path in knowledge_base.path.rglob('*.md'):
        note = load_note(note_path)

        # Check frontmatter for scheduled reviews
        if note.frontmatter.get('review_date'):
            review_date = parse_date(note.frontmatter['review_date'])
            if review_date <= date:
                scheduled_tasks.append({
                    'type': 'scheduled_review',
                    'note_path': note_path,
                    'note_id': note.id,
                    'title': note.title,
                    'due_date': review_date,
                    'review_question': note.frontmatter.get('review_question', 'Review this note'),
                    'overdue_days': (date - review_date).days if review_date < date else 0
                })

        # Check for TODO items with dates
        todos = extract_todos_with_dates(note.content)
        for todo in todos:
            if todo['due_date'] and todo['due_date'] <= date and not todo['completed']:
                scheduled_tasks.append({
                    'type': 'todo_item',
                    'note_path': note_path,
                    'note_id': note.id,
                    'title': note.title,
                    'task_description': todo['description'],
                    'due_date': todo['due_date'],
                    'overdue_days': (date - todo['due_date']).days if todo['due_date'] < date else 0
                })

        # Check for decision review dates
        if note.id.startswith('DEC-'):
            review_interval = note.frontmatter.get('review_interval_days', 90)
            created_date = note.frontmatter.get('created_date', note.created_date)
            if created_date:
                review_date = parse_date(created_date) + timedelta(days=review_interval)
                if review_date <= date:
                    scheduled_tasks.append({
                        'type': 'decision_review',
                        'note_path': note_path,
                        'note_id': note.id,
                        'title': note.title,
                        'decision_date': created_date,
                        'review_due': review_date,
                        'review_question': 'Did this decision achieve expected outcomes?',
                        'overdue_days': (date - review_date).days if review_date < date else 0
                    })

    # Sort by overdue first, then by due date
    scheduled_tasks.sort(key=lambda x: (-x.get('overdue_days', 0), x.get('due_date', date)))

    return scheduled_tasks
```

## Today Context Generation

### Meeting Context Loading

```python
def generate_meeting_context(knowledge_base, date):
    """Generate context for today's meetings."""

    meetings = get_calendar_events(date)  # Requires calendar integration

    meeting_contexts = []

    for meeting in meetings:
        context = {
            'time': meeting.start_time,
            'title': meeting.title,
            'attendees': meeting.attendees,
            'related_notes': [],
            'pre_read': None,
            'recent_decisions': [],
            'open_questions': []
        }

        # Extract keywords from meeting title
        keywords = extract_keywords(meeting.title)

        # Find related notes by keyword search
        for keyword in keywords:
            matching_notes = search_notes(knowledge_base, keyword, limit=5)
            context['related_notes'].extend(matching_notes)

        # Deduplicate and sort by relevance
        context['related_notes'] = deduplicate_by_relevance(
            context['related_notes'],
            limit=3
        )

        # Check for explicit pre-read note
        pre_read_patterns = [
            f"pre-read-{slugify(meeting.title)}",
            f"meeting-prep-{date.isoformat()}",
            f"{meeting.title.lower().replace(' ', '-')}-prep"
        ]
        for pattern in pre_read_patterns:
            pre_read = find_note_by_id_pattern(knowledge_base, pattern)
            if pre_read:
                context['pre_read'] = pre_read
                break

        # Find recent decisions related to meeting topic
        recent_decisions = find_decisions_by_keywords(
            knowledge_base,
            keywords,
            days=30,
            limit=3
        )
        context['recent_decisions'] = recent_decisions

        # Find open questions from related notes
        for note in context['related_notes']:
            questions = extract_open_questions(note)
            context['open_questions'].extend(questions[:2])

        meeting_contexts.append(context)

    return meeting_contexts
```

### Active Project Detection

```python
def detect_active_projects(knowledge_base):
    """Find currently active projects."""

    projects_dir = knowledge_base.path / 'projects'
    active_projects = []

    for project_dir in projects_dir.iterdir():
        if not project_dir.is_dir():
            continue

        # Look for project index
        index_file = project_dir / '00-PROJECT-INDEX.md'
        if not index_file.exists():
            continue

        index_note = load_note(index_file)

        # Check project status
        status = index_note.frontmatter.get('status', 'unknown')
        if status.lower() not in ['active', 'in-progress', 'current']:
            continue

        # Find most recent activity
        recent_activity = find_most_recent_note_in_path(project_dir)

        # Calculate project progress if available
        progress = index_note.frontmatter.get('progress', None)
        if not progress and 'week' in index_note.content.lower():
            progress = extract_week_progress(index_note.content)

        active_projects.append({
            'name': index_note.title or project_dir.name,
            'path': project_dir,
            'status': status,
            'progress': progress,
            'recent_note': recent_activity,
            'start_date': index_note.frontmatter.get('start_date'),
            'target_date': index_note.frontmatter.get('target_date'),
            'owner': index_note.frontmatter.get('owner')
        })

    # Sort by recent activity
    active_projects.sort(
        key=lambda x: x['recent_note']['date'] if x['recent_note'] else datetime.min,
        reverse=True
    )

    return active_projects
```

## Full Example Daily Digest

```markdown
# Daily Digest - Tuesday, January 16, 2026

## Yesterday's Activity (Monday, January 15)

### Work Summary
- 📝 4 notes created
- ✏️  3 notes updated
- 💡 7 insights extracted
- ✅ 2 decisions recorded

### Highlights

**New Note**: [[2026-01-070|Frontend Lead Interview Framework]]
*Created work sample evaluation and scoring rubric for frontend candidates*
→ Links to: [[DEC-2026-003|Frontend Lead Hire]], [[PLAY-hiring-process]]

**New Note**: [[2026-01-072|Reddit Marketing Baseline]]
*Established baseline metrics before $5K Reddit experiment*
→ Links to: [[2026-01-062|Marketing Channel Experiment]]

**New Note**: [[PLAY-decision-making|Unified Decision-Making Playbook]]
*Combined pre-mortem and reversibility frameworks into single playbook*
→ Links to: [[2026-01-001|Pre-Mortem Analysis]], [[2026-01-020|Decision Reversibility]]

**New Note**: [[2026-01-075|Meeting Pre-Read Standard]]
*Formalized meeting pre-read practice after 40% time savings*
→ Links to: [[PATT-async-communication]]

**Updated**: [[MAP-hiring-system|Hiring System Map]]
*Added 3 new hiring notes, expanded structure*

**Updated**: [[DEC-2026-003|Frontend Lead Hire]]
*Added interview schedule, first candidates screened*

**Updated**: [[projects/product-launch/00-PROJECT-INDEX]]
*Week 4 status update, sprint cadence decision reflected*

**Decision**: [[2026-01-076|Marketing Budget Reallocation]]
*Reallocated $3K from trade shows to Reddit experiment*

**Decision**: [[2026-01-078|Interview Panel Selection]]
*Selected interview panel for frontend lead role*

**Insight**: Work sample accuracy correlates with hire success
*From hiring retrospective analysis, quantified at 0.72 correlation*

**Insight**: Pre-mortem + reversibility combination is emerging pattern
*Detected across 4 decisions this week, recommend playbook creation*

**Insight**: Async standups maintaining blocker resolution time
*Engineering team experiment showing positive results after 1 week*

**Insight**: Meeting pre-reads average 24-hour lead time
*Sufficient for preparation, shorter may reduce participation*

**Insight**: Knowledge gaps causing 2+ hours rework per hire
*Work samples, rubrics, offer negotiation all being recreated*

**Insight**: Sprint velocity improved 15% with async planning
*Comparing first async sprint to previous 3 sync sprints*

**Insight**: Frontend candidates prefer take-home over live coding
*Feedback from first 5 applicants, 100% preference for take-home*

## Needs Attention ⚠️

1. **Scheduled Task Due** (CRITICAL)
   Review [[DEC-2026-001|Market Entry Decision]]
   → 90-day review was due January 15 (1 day overdue)
   → Action: Assess outcomes vs original expectations

2. **Broken Link Detected** (HIGH)
   [[2026-01-055|Hiring Budget Approval]] references [[COMP-bands]] which doesn't exist
   → Likely should be [[2026-01-085|Compensation Framework]]
   → Action: Update reference to correct note

3. **Orphaned Note** (MEDIUM)
   [[2026-01-040|Initial Framework Thoughts]] has 0 backlinks
   → Created 35 days ago, not accessed in 28 days
   → Contains early decision framework ideas, superseded by [[PLAY-decision-making]]
   → Action: Archive or link from [[MAP-decision-frameworks]]

4. **Review Due** (MEDIUM)
   [[2026-01-050|Sprint Cadence Decision]]
   → First sprint under new cadence completes Friday
   → Action: Prepare retrospective notes

5. **Stale Project Context** (LOW)
   [[projects/q4-review/00-PROJECT-INDEX]] not updated in 45 days
   → Q4 complete, project may need archiving
   → Action: Archive or close project formally

## Today's Context

### Meetings

- **9:00 AM**: Frontend Lead Screen (30 min)
  *Context*: [[2026-01-070|Interview Framework]]
  *Candidates*: 3 applications to screen
  *Preparation*: Review work samples when submitted

- **11:00 AM**: Product Sprint Planning (60 min)
  *Pre-read*: [[projects/product-launch/sprint-2-plan]] 📄
  *Context*: [[2026-01-050|Sprint Cadence Decision]]
  *Recent*: First async sprint planning

- **2:00 PM**: Leadership Sync (45 min)
  *Pre-read*: [[2026-01-076|Marketing Budget Reallocation]] 📄
  *Context*: [[2026-01-048|Q1 Priorities]]
  *Decisions Pending*: None flagged

- **4:00 PM**: 1:1 with Engineering Lead (30 min)
  *Context*: [[2026-01-078|Async Standup Experiment]]
  *Discussion*: Week 1 results, any adjustments needed

### Active Projects

1. **Product Launch** (Week 4 of 12 - 33% complete)
   Status: On track
   Recent: [[2026-01-050|Sprint Cadence Decision]]
   This week: Sprint 2 planning, feature prioritization

2. **Frontend Hiring** (Week 1 - Screening phase)
   Status: Active
   Recent: [[2026-01-070|Interview Framework]]
   This week: Screen applications, schedule interviews

3. **Q1 Planning** (Due: Jan 31 - 50% complete)
   Status: On track
   Recent: [[2026-01-068|Q1 OKR Finalization]]
   This week: Complete OKR cascade document

4. **Marketing Experiments** (Week 1 - Reddit test)
   Status: Active
   Recent: [[2026-01-072|Reddit Baseline]]
   This week: Monitor initial engagement metrics

### This Week's Tasks

- [x] Create hiring playbook (Completed Mon)
- [x] Set up interview framework (Completed Mon)
- [ ] Complete Q1 OKR cascade (Due: Wed)
- [ ] Screen frontend applications (Due: Wed)
- [ ] First candidate interview scheduled (Due: Fri)
- [ ] Sprint 1 retrospective (Due: Fri)
- [ ] Review marketing experiment metrics (Due: Sat)

---
*Generated: 2026-01-16 07:00 AM by maintenance-agent (Sonnet 3.5)*
*Execution time: 12 seconds | Cost: $0.31*
*Notes analyzed: 4 new, 3 updated, 12 conversations*
```

## Configuration Schema

```yaml
# .kaaos/config.yaml - Daily rhythm configuration
rhythms:
  daily:
    enabled: true
    hour: 7
    minute: 0
    timezone: America/Los_Angeles

    # Content sections to include
    sections:
      yesterdays_activity:
        enabled: true
        max_new_notes: 10
        max_updated_notes: 5
        max_insights: 10
        max_decisions: 5
        show_links: true

      attention_required:
        enabled: true
        priority_threshold: low  # critical, high, medium, low
        max_items: 10

        # Individual attention types
        types:
          broken_links: true
          orphaned_notes: true
          scheduled_tasks: true
          review_due: true
          stale_notes: false  # Disable if too noisy

        # Thresholds
        thresholds:
          orphan_days: 30
          stale_days: 90
          review_overdue_days: 7

      todays_context:
        enabled: true
        show_meetings: true
        show_active_projects: true
        show_week_tasks: true
        max_meetings: 10
        max_projects: 5

    # Output settings
    output:
      path: ".digests/daily/"
      filename_format: "%Y-%m-%d.md"
      archive_after_days: 30

    # Notifications
    notifications:
      enabled: true
      sound: true
      title: "KAAOS Daily Digest"

    # Cost controls
    cost:
      estimated_usd: 0.30
      alert_if_exceeds: 0.50
      model: claude-sonnet-4-20250514
```

## Agent Implementation Details

### Main Entry Point

```python
#!/usr/bin/env python3
"""Daily digest generation agent."""

import argparse
from datetime import datetime, timedelta
from pathlib import Path

def main():
    parser = argparse.ArgumentParser(description='Generate daily digest')
    parser.add_argument('--date', type=str, help='Date for digest (YYYY-MM-DD)')
    parser.add_argument('--config', type=str, help='Path to config file')
    parser.add_argument('--dry-run', action='store_true', help='Print without saving')
    args = parser.parse_args()

    # Parse date
    if args.date:
        date = datetime.strptime(args.date, '%Y-%m-%d').date()
    else:
        date = datetime.now().date()

    # Load configuration
    config = load_config(args.config)

    # Verify budget
    if not check_budget_before_run('daily', config):
        print("Budget exceeded, skipping daily digest")
        return 1

    # Load knowledge base
    knowledge_base = load_knowledge_base(config['knowledge_base_path'])

    # Generate digest
    start_time = datetime.now()
    digest = generate_daily_digest(knowledge_base, date, config)
    end_time = datetime.now()

    # Add metadata
    digest['metadata'] = {
        'generated_at': datetime.now().isoformat(),
        'execution_time_seconds': (end_time - start_time).total_seconds(),
        'cost_usd': calculate_actual_cost(),
        'agent': 'maintenance-agent',
        'model': config['rhythms']['daily']['cost']['model']
    }

    # Render to markdown
    markdown = render_digest_markdown(digest)

    if args.dry_run:
        print(markdown)
        return 0

    # Save digest
    output_path = save_digest(
        markdown,
        date,
        config['rhythms']['daily']['output']
    )

    # Send notification
    if config['rhythms']['daily']['notifications']['enabled']:
        send_notification(
            title=config['rhythms']['daily']['notifications']['title'],
            message=f"Daily digest ready for {date}",
            sound=config['rhythms']['daily']['notifications']['sound']
        )

    # Log execution
    log_rhythm_execution('daily', digest['metadata'])

    print(f"Daily digest saved to: {output_path}")
    return 0

if __name__ == '__main__':
    exit(main())
```

### Notification System (macOS)

```python
def send_notification(title, message, sound=True):
    """Send macOS notification."""

    import subprocess

    script = f'''
    display notification "{message}" with title "{title}"
    '''

    if sound:
        script += ' sound name "Glass"'

    subprocess.run(['osascript', '-e', script], check=True)
```

### Calendar Integration (Optional)

```python
def get_calendar_events(date):
    """Get calendar events for date. Requires calendar integration."""

    # Option 1: iCloud Calendar via AppleScript
    try:
        return get_icalendar_events(date)
    except Exception:
        pass

    # Option 2: Google Calendar via API
    try:
        return get_google_calendar_events(date)
    except Exception:
        pass

    # Option 3: Read from local ICS file
    try:
        return get_ics_file_events(date)
    except Exception:
        pass

    # Fallback: No calendar integration
    return []

def get_icalendar_events(date):
    """Get events from macOS Calendar app."""

    import subprocess

    script = f'''
    tell application "Calendar"
        set targetDate to date "{date.strftime('%B %d, %Y')}"
        set nextDate to targetDate + 1 * days

        set eventList to {{}}
        repeat with cal in calendars
            set calEvents to (every event of cal whose start date >= targetDate and start date < nextDate)
            repeat with e in calEvents
                set end of eventList to {{summary:summary of e, startDate:start date of e, endDate:end date of e}}
            end repeat
        end repeat

        return eventList
    end tell
    '''

    result = subprocess.run(
        ['osascript', '-e', script],
        capture_output=True,
        text=True
    )

    return parse_applescript_events(result.stdout)
```

## Troubleshooting

### Common Issues

**Problem**: Digest not generating at scheduled time

**Solutions**:
1. Check launchd status:
   ```bash
   launchctl list | grep kaaos.daily
   ```
2. Check log files:
   ```bash
   cat ~/.kaaos-knowledge/.kaaos/logs/daily.error.log
   ```
3. Test manual execution:
   ```bash
   /usr/local/bin/kaaos review daily --dry-run
   ```
4. Reload launchd agent:
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.kaaos.daily.plist
   launchctl load ~/Library/LaunchAgents/com.kaaos.daily.plist
   ```

**Problem**: Too many attention items

**Solutions**:
1. Increase thresholds in config:
   ```yaml
   thresholds:
     orphan_days: 60  # Increase from 30
     stale_days: 180  # Increase from 90
   ```
2. Disable noisy attention types:
   ```yaml
   types:
     stale_notes: false
   ```
3. Batch-fix orphaned notes:
   ```bash
   /kaaos:maintenance --fix-orphans
   ```

**Problem**: Missing meeting context

**Solutions**:
1. Verify calendar integration:
   ```bash
   /kaaos:status --check-calendar
   ```
2. Create pre-read notes with standard naming:
   ```
   pre-read-meeting-name-YYYY-MM-DD.md
   ```
3. Link meeting notes to relevant project indexes

**Problem**: Digest cost exceeding estimate

**Solutions**:
1. Check actual vs estimated costs:
   ```bash
   /kaaos:status --costs
   ```
2. Reduce content sections:
   ```yaml
   sections:
     yesterdays_activity:
       max_insights: 5  # Reduce from 10
   ```
3. Switch to smaller model (if available):
   ```yaml
   cost:
     model: claude-haiku  # Cheaper but less capable
   ```

## Best Practices

1. **Morning Ritual**: Review digest as part of morning routine
2. **Act on Critical Items**: Address CRITICAL priority items same day
3. **Weekly Batch**: Save MEDIUM/LOW items for weekly review
4. **Pre-Read Preparation**: Create pre-read notes day before meetings
5. **Project Hygiene**: Keep project status current for accurate context
6. **Link Notes**: Well-linked notes surface better meeting context
7. **Review Configuration**: Adjust thresholds based on noise level
8. **Trust Automation**: Resist checking between daily digests

## Related Resources

- **assets/daily-template.md**: Full template with placeholders
- **references/weekly-rhythm-patterns.md**: Weekly synthesis patterns
- **SKILL.md**: Overview of all operational rhythms
- **../knowledge-management/context-library-patterns.md**: Note organization patterns
