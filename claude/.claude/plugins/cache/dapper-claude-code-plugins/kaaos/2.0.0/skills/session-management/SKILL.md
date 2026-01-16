---
name: session-management
description: Initialize work sessions with context loading, recent history review, and co-pilot agent spawning. Use when starting work sessions, switching between projects, or needing focused context for deep work.
---

# Session Management

Master session initialization patterns for loading relevant context, reviewing recent work, and spawning co-pilot agents for context-aware assistance.

## When to Use This Skill

- Starting work sessions on specific projects
- Switching between different organizational contexts
- Loading context after time away from a project
- Preparing for meetings or strategic work
- Spawning co-pilot agents for real-time assistance
- Minimizing context-switching overhead
- Ensuring continuity across work sessions

## Core Concepts

### 1. Session Types

**Focus Session**: Deep work on single project
- Load project context library
- Review recent project commits
- Spawn project-specific co-pilot
- Duration: 2-4 hours typical

**Strategic Session**: Cross-project thinking
- Load organization context library
- Review synthesis notes
- Load multiple project contexts
- Spawn strategic co-pilot

**Research Session**: Investigation and learning
- Load reference materials
- Spawn research agent
- Create research context
- Duration: 1-3 hours typical

**Meeting Prep Session**: Pre-meeting context loading
- Load meeting-specific context
- Review recent related decisions
- Load participant context
- Duration: 10-30 minutes

### 2. Context Loading Strategy

**Progressive Context Loading**
```
Level 1: Essential (always loaded)
  - Organization index
  - Current project index
  - Recent decisions

Level 2: Recent Work (past 7 days)
  - Notes created/updated
  - Conversations
  - Commits with insights

Level 3: Related Context (on-demand)
  - Referenced notes
  - Map notes for navigation
  - Synthesis notes for patterns

Level 4: Deep Archive (explicit request)
  - Historical notes
  - Archived projects
  - Old synthesis
```

**Token Budget Management**
- Essential context: ~5K tokens
- Recent work: ~10K tokens
- Related context: ~15K tokens
- Deep archive: ~20K+ tokens

Reserve budget for actual work (100K+ tokens for reasoning).

### 3. Co-Pilot Agent Spawning

**When to Spawn Co-Pilot**
- Sessions >2 hours
- Complex problem-solving
- Need real-time suggestions
- Learning new domain

**When to Skip Co-Pilot**
- Quick tasks (<30 min)
- Review-only sessions
- Budget constraints
- Deep focus work (no interruptions)

### 4. Session State Persistence

**Session Metadata**
```yaml
session_id: 2026-01-15-project-launch-1
organization: personal
project: product-launch
type: focus
started: 2026-01-15T14:00:00Z
ended: 2026-01-15T17:30:00Z
context_loaded:
  - organizations/personal/context-library/
  - projects/product-launch/context-library/
  - projects/product-launch/conversations/2026-01-10-*
copilot: false
outputs:
  - notes_created: 3
  - notes_updated: 2
  - decisions: 1
  - commits: 5
```

## Quick Start

```bash
# Start a session
/kaaos:session personal/product-launch

# Session with co-pilot
/kaaos:session personal/product-launch --copilot

# Strategic session (multi-project)
/kaaos:session personal --strategic

# Meeting prep
/kaaos:session personal/product-launch --meeting "Product Planning"

# Check active session
/kaaos:status
```

## Session Initialization Patterns

### Pattern 1: Focus Session Initialization

```python
# Session initialization
def initialize_focus_session(org_name, project_name, options={}):
    """Initialize a focused work session on a specific project."""

    session = {
        'id': generate_session_id(org_name, project_name),
        'type': 'focus',
        'organization': org_name,
        'project': project_name,
        'started': datetime.now(),
        'context': {},
        'agents': []
    }

    # Level 1: Essential Context
    print("Loading essential context...")
    session['context']['essential'] = load_essential_context(
        org_name,
        project_name
    )

    # Level 2: Recent Work
    print("Loading recent work (past 7 days)...")
    session['context']['recent'] = load_recent_work(
        org_name,
        project_name,
        days=7
    )

    # Display session summary
    display_session_summary(session)

    # Spawn co-pilot if requested
    if options.get('copilot', False):
        print("\nSpawning co-pilot agent...")
        copilot = spawn_copilot(session)
        session['agents'].append(copilot)

    # Save session state
    save_session_state(session)

    return session

def load_essential_context(org_name, project_name):
    """Load essential context always needed."""

    context = {
        'org_index': load_note(f'organizations/{org_name}/context-library/00-INDEX.md'),
        'project_index': load_note(f'organizations/{org_name}/projects/{project_name}/context-library/00-PROJECT-INDEX.md'),
        'recent_decisions': load_recent_decisions(org_name, project_name, days=30),
        'active_playbooks': load_active_playbooks(org_name)
    }

    return context

def load_recent_work(org_name, project_name, days=7):
    """Load work from past N days."""

    cutoff = datetime.now() - timedelta(days=days)

    recent = {
        'notes_created': find_notes_created_after(
            f'organizations/{org_name}/projects/{project_name}',
            cutoff
        ),
        'notes_updated': find_notes_updated_after(
            f'organizations/{org_name}/projects/{project_name}',
            cutoff
        ),
        'conversations': find_conversations_after(
            f'organizations/{org_name}/projects/{project_name}',
            cutoff
        ),
        'commits': find_commits_after(
            f'organizations/{org_name}/projects/{project_name}',
            cutoff
        )
    }

    return recent

def display_session_summary(session):
    """Display session context summary."""

    print(f"\n{'='*60}")
    print(f"Session: {session['id']}")
    print(f"Type: {session['type']}")
    print(f"Organization: {session['organization']}")
    print(f"Project: {session['project']}")
    print(f"{'='*60}\n")

    # Essential context
    essential = session['context']['essential']
    print("Essential Context Loaded:")
    print(f"  ✓ Organization index: {len(essential['org_index'].content)} chars")
    print(f"  ✓ Project index: {len(essential['project_index'].content)} chars")
    print(f"  ✓ Recent decisions: {len(essential['recent_decisions'])} decisions")
    print(f"  ✓ Active playbooks: {len(essential['active_playbooks'])} playbooks")

    # Recent work
    recent = session['context']['recent']
    print("\nRecent Work (Past 7 Days):")
    print(f"  ✓ Notes created: {len(recent['notes_created'])}")
    print(f"  ✓ Notes updated: {len(recent['notes_updated'])}")
    print(f"  ✓ Conversations: {len(recent['conversations'])}")
    print(f"  ✓ Commits: {len(recent['commits'])}")

    # Highlight key items
    if recent['notes_created']:
        print("\n  Recent Notes:")
        for note in recent['notes_created'][:5]:
            print(f"    - [[{note.id}|{note.title}]] ({note.created})")

    if recent['conversations']:
        print("\n  Recent Sessions:")
        for conv in recent['conversations'][:3]:
            print(f"    - {conv.date}: {conv.summary}")

    print(f"\n{'='*60}\n")
```

### Pattern 2: Strategic Session (Multi-Project)

```python
def initialize_strategic_session(org_name, options={}):
    """Initialize cross-project strategic session."""

    session = {
        'id': generate_session_id(org_name, 'strategic'),
        'type': 'strategic',
        'organization': org_name,
        'started': datetime.now(),
        'context': {},
        'agents': []
    }

    # Load org-level context
    print("Loading organization context...")
    session['context']['organization'] = load_org_context(org_name)

    # Load all active projects
    print("Loading active projects...")
    projects = find_active_projects(org_name)
    session['context']['projects'] = {}

    for project in projects:
        print(f"  Loading {project.name}...")
        session['context']['projects'][project.name] = {
            'index': load_note(project.index_path),
            'recent_notes': find_notes_created_after(
                project.path,
                datetime.now() - timedelta(days=14)
            ),
            'status': project.status
        }

    # Load synthesis notes
    print("Loading recent synthesis...")
    session['context']['synthesis'] = load_recent_synthesis(org_name)

    # Display summary
    display_strategic_summary(session)

    # Spawn strategic co-pilot if requested
    if options.get('copilot', False):
        print("\nSpawning strategic co-pilot...")
        copilot = spawn_strategic_copilot(session)
        session['agents'].append(copilot)

    save_session_state(session)
    return session
```

### Pattern 3: Meeting Prep Session

```python
def initialize_meeting_prep_session(org_name, project_name, meeting_title, options={}):
    """Initialize session for meeting preparation."""

    session = {
        'id': generate_session_id(org_name, project_name, 'meeting-prep'),
        'type': 'meeting-prep',
        'organization': org_name,
        'project': project_name,
        'meeting': meeting_title,
        'started': datetime.now(),
        'context': {}
    }

    print(f"Preparing for meeting: {meeting_title}")

    # Load meeting-specific context
    print("Loading meeting context...")

    # Check if there's a meeting note or agenda
    meeting_note = find_meeting_note(org_name, project_name, meeting_title)
    if meeting_note:
        session['context']['meeting_note'] = meeting_note
        print(f"  ✓ Found meeting note: [[{meeting_note.id}]]")

        # Extract pre-read documents
        pre_reads = extract_pre_reads(meeting_note)
        if pre_reads:
            session['context']['pre_reads'] = [
                load_note(pr) for pr in pre_reads
            ]
            print(f"  ✓ Loaded {len(pre_reads)} pre-read documents")

    # Load related decisions
    print("Loading related decisions...")
    keywords = extract_keywords_from_title(meeting_title)
    related_decisions = find_decisions_by_keywords(
        org_name,
        project_name,
        keywords
    )
    session['context']['related_decisions'] = related_decisions
    print(f"  ✓ Found {len(related_decisions)} related decisions")

    # Load participant context (if available)
    participants = options.get('participants', [])
    if participants:
        print("Loading participant context...")
        session['context']['participants'] = {}
        for participant in participants:
            # Load notes by or about this participant
            participant_notes = find_notes_by_author(
                org_name,
                participant,
                days=30
            )
            session['context']['participants'][participant] = participant_notes
            print(f"  ✓ {participant}: {len(participant_notes)} recent notes")

    # Display summary
    display_meeting_prep_summary(session)

    save_session_state(session)
    return session
```

## Co-Pilot Agent Patterns

### Spawning Co-Pilot

```python
def spawn_copilot(session):
    """Spawn co-pilot agent for real-time assistance."""

    copilot = {
        'agent_type': 'copilot',
        'model': 'sonnet',
        'spawned': datetime.now(),
        'session': session['id'],
        'capabilities': [
            'suggest_related_notes',
            'detect_patterns',
            'flag_inconsistencies',
            'suggest_cross_references',
            'answer_context_questions'
        ]
    }

    # Initialize with session context
    copilot['context'] = serialize_session_context(session['context'])

    # Start co-pilot process
    copilot['process'] = start_copilot_daemon(copilot)

    print(f"\n✓ Co-pilot agent spawned (PID: {copilot['process'].pid})")
    print("  Available commands:")
    print("    /copilot suggest       - Suggest related notes")
    print("    /copilot patterns      - Detect patterns in current work")
    print("    /copilot relate [note] - Find related notes")
    print("    /copilot question      - Ask about context")

    return copilot

def copilot_suggest_related(copilot, current_note):
    """Co-pilot suggests related notes."""

    # Embed current note
    embedding = embed_note(current_note)

    # Find similar notes in session context
    context_notes = get_copilot_context_notes(copilot)
    similarities = calculate_similarities(embedding, context_notes)

    # Top 5 suggestions
    suggestions = sorted(
        similarities,
        key=lambda x: x['score'],
        reverse=True
    )[:5]

    return suggestions
```

### Co-Pilot Interaction Examples

```markdown
# During session

You: Working on sprint planning document

Co-pilot: 📎 Related context found:
  - [[2026-01-050|Sprint Cadence Decision]] - Your 2-week sprint decision
  - [[PLAY-remote-async-excellence]] - Async planning playbook
  - [[2026-01-078|Async Standup Format]] - Daily update template

You: /copilot patterns

Co-pilot: 🔍 Patterns detected in current work:
  - You're referencing decision frameworks 3x
  - Consider linking to [[MAP-decision-frameworks]]
  - Similar work done in [[projects/q1-planning/sprint-setup]]

You: /copilot question "What did we decide about meeting cadence?"

Co-pilot: 📚 From [[2026-01-050|Sprint Cadence Decision]]:
  "2-week sprints with async planning. Sync meetings:
   - Sprint planning: 1 hour (with pre-read)
   - Sprint retro: 45 min
   - Daily standups: Async via Slack"
```

## Context Loading Strategies

### Lazy Loading

```python
def lazy_load_context(session, note_id):
    """Load additional context on-demand."""

    # Check if already loaded
    if note_id in session['context'].get('loaded_notes', {}):
        return session['context']['loaded_notes'][note_id]

    # Load note
    note = load_note(note_id)

    # Load immediate references
    refs = extract_references(note.content)
    note.references = {}
    for ref_id in refs[:5]:  # Limit to 5 to avoid explosion
        if ref_id not in session['context'].get('loaded_notes', {}):
            note.references[ref_id] = load_note(ref_id)

    # Cache in session
    if 'loaded_notes' not in session['context']:
        session['context']['loaded_notes'] = {}
    session['context']['loaded_notes'][note_id] = note

    return note
```

### Smart Context Expansion

```python
def expand_context_if_needed(session, query):
    """Expand context based on user query."""

    # Extract keywords from query
    keywords = extract_keywords(query)

    # Check if we have relevant context loaded
    loaded_content = serialize_session_context(session['context'])
    coverage = calculate_keyword_coverage(keywords, loaded_content)

    # If coverage < 50%, expand context
    if coverage < 0.5:
        print("Query needs additional context. Loading relevant notes...")

        # Find notes matching keywords
        relevant_notes = search_notes(
            session['organization'],
            session['project'],
            keywords,
            limit=10
        )

        # Load top matches
        for note in relevant_notes[:5]:
            lazy_load_context(session, note.id)

        print(f"✓ Loaded {len(relevant_notes[:5])} additional notes")
```

## Session Resumption

### Save Session State

```python
def save_session_state(session):
    """Save session for later resumption."""

    session_file = Path(
        f"~/.kaaos-knowledge/.kaaos/sessions/{session['id']}.yaml"
    ).expanduser()

    # Serialize session (lightweight, not full context)
    state = {
        'id': session['id'],
        'type': session['type'],
        'organization': session['organization'],
        'project': session.get('project'),
        'started': session['started'].isoformat(),
        'context_paths': get_loaded_context_paths(session),
        'agents': [
            {
                'type': agent['agent_type'],
                'pid': agent.get('process', {}).get('pid')
            }
            for agent in session.get('agents', [])
        ]
    }

    with open(session_file, 'w') as f:
        yaml.dump(state, f)
```

### Resume Session

```python
def resume_session(session_id):
    """Resume a previous session."""

    session_file = Path(
        f"~/.kaaos-knowledge/.kaaos/sessions/{session_id}.yaml"
    ).expanduser()

    if not session_file.exists():
        raise SessionNotFoundError(f"Session {session_id} not found")

    # Load saved state
    with open(session_file, 'r') as f:
        state = yaml.safe_load(f)

    print(f"Resuming session: {session_id}")
    print(f"  Started: {state['started']}")
    print(f"  Type: {state['type']}")

    # Reload context
    session = {
        'id': state['id'],
        'type': state['type'],
        'organization': state['organization'],
        'project': state.get('project'),
        'started': datetime.fromisoformat(state['started']),
        'resumed': datetime.now(),
        'context': {}
    }

    # Reload contexts from paths
    for path in state['context_paths']:
        context_name = Path(path).stem
        session['context'][context_name] = load_context_from_path(path)

    # Check if agents are still running
    for agent_state in state.get('agents', []):
        if 'pid' in agent_state:
            if is_process_running(agent_state['pid']):
                print(f"  ✓ {agent_state['type']} agent still running")
            else:
                print(f"  ✗ {agent_state['type']} agent stopped, respawn? [y/n]")
                # Handle respawn

    display_session_summary(session)
    return session
```

## Best Practices

1. **Start Every Session**: Don't work without context
2. **Use Appropriate Type**: Focus vs strategic vs meeting-prep
3. **Co-pilot for Long Sessions**: >2 hours benefits from assistance
4. **Load Progressively**: Start essential, expand as needed
5. **Review Recent Work**: Always check past 7 days
6. **Link to Session**: Reference session in created notes
7. **Save State**: Save session for resumption
8. **Close Cleanly**: Proper session end saves outputs

## Common Pitfalls

- **Skipping Session Init**: Starting work cold loses context
- **Over-Loading Context**: Loading too much context wastes tokens
- **Ignoring Recent Work**: Missing continuity with past work
- **Not Using Co-Pilot**: Missing real-time assistance value
- **Forgetting to Close**: Session outputs not tracked
- **Wrong Session Type**: Strategic when need focus (or vice versa)
- **No Context Budget**: Loading everything, running out of tokens

## Resources

- **references/context-loading-strategies.md**: Advanced loading patterns
- **references/copilot-interaction-patterns.md**: Co-pilot usage examples
- **references/session-resumption.md**: Pausing and resuming work
- **assets/session-checklist.md**: Pre-session preparation checklist
- **assets/session-templates/**: Templates for different session types
