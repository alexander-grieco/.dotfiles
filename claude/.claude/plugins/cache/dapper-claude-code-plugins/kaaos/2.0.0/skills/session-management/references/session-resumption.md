# Session Resumption

Advanced patterns for pausing, persisting, and resuming work sessions with full context restoration.

## Table of Contents

1. [Session State Model](#session-state-model)
2. [Persistence Strategies](#persistence-strategies)
3. [Context Restoration](#context-restoration)
4. [Interruption Handling](#interruption-handling)
5. [Multi-Session Management](#multi-session-management)
6. [Recovery Patterns](#recovery-patterns)
7. [Token Budget Restoration](#token-budget-restoration)
8. [Agent State Preservation](#agent-state-preservation)

## Session State Model

### Complete State Structure

```yaml
# Session state file format
# Path: ~/.kaaos-knowledge/.kaaos/sessions/{session_id}.yaml

session:
  id: "2026-01-15-focus-product-launch-001"
  version: "1.0"

  # Core identifiers
  organization: "personal"
  project: "product-launch"
  type: "focus"  # focus | strategic | research | meeting-prep | review

  # Lifecycle timestamps
  lifecycle:
    created: "2026-01-15T09:00:00Z"
    started: "2026-01-15T09:05:00Z"
    paused: "2026-01-15T11:30:00Z"
    resumed: null
    ended: null
    duration_active_minutes: 145

  # Context snapshot
  context:
    essential:
      org_index_hash: "abc123..."
      project_index_hash: "def456..."
      decisions_loaded: 5
      playbooks_loaded: 3

    recent:
      notes_created_count: 8
      notes_updated_count: 12
      conversations_count: 3
      commits_count: 15
      cutoff_date: "2026-01-08T00:00:00Z"

    expanded:
      loaded_note_ids:
        - "2026-01-050"
        - "2026-01-078"
        - "PLAY-sprint-planning"
        - "MAP-product-decisions"
      total_tokens_loaded: 35000

    cache:
      search_cache_size: 15
      embedding_cache_size: 25

  # Working state
  working_state:
    current_focus:
      note_id: "2026-01-100"
      note_title: "Sprint Planning Q1"
      position: "section-3"

    open_threads:
      - topic: "pricing_decision"
        status: "in_progress"
        last_activity: "2026-01-15T11:25:00Z"
      - topic: "feature_prioritization"
        status: "paused"
        notes: ["Need stakeholder input"]

    uncommitted_changes:
      - file: "context-library/decisions/pricing-model.md"
        type: "created"
      - file: "context-library/notes/2026-01-100.md"
        type: "modified"

  # Agent state
  agents:
    copilot:
      active: true
      mode: "balanced"
      pid: 12345
      working_memory_path: "./copilot-state.yaml"
      suggestions_pending: 2

    research:
      active: false
      last_run: "2026-01-15T10:00:00Z"
      last_topic: "competitor_analysis"

  # Metrics
  metrics:
    notes_created: 3
    notes_updated: 5
    decisions_made: 2
    questions_asked: 8
    searches_performed: 12
    suggestions_accepted: 7
    estimated_cost: 1.25

  # Resumption hints
  resumption:
    recommended_context:
      - "2026-01-100"  # Was working on this
      - "2026-01-050"  # Frequently accessed

    open_questions:
      - "Pricing tier structure?"
      - "Launch date confirmation?"

    next_actions:
      - "Complete pricing decision note"
      - "Review competitor analysis"
      - "Update project index"
```

### State Serialization

```python
class SessionStateManager:
    """Manage session state serialization and deserialization."""

    def __init__(self, kaaos_root):
        self.kaaos_root = Path(kaaos_root)
        self.sessions_dir = self.kaaos_root / '.kaaos' / 'sessions'
        self.sessions_dir.mkdir(parents=True, exist_ok=True)

    def save_session(self, session):
        """Save complete session state."""

        state = self._serialize_session(session)

        session_file = self.sessions_dir / f"{session['id']}.yaml"

        # Create backup of existing state
        if session_file.exists():
            backup_file = self.sessions_dir / f"{session['id']}.backup.yaml"
            shutil.copy(session_file, backup_file)

        # Write new state
        with open(session_file, 'w') as f:
            yaml.dump(state, f, default_flow_style=False)

        # Also save copilot state if active
        if session.get('agents', {}).get('copilot', {}).get('active'):
            self._save_copilot_state(session)

        return session_file

    def _serialize_session(self, session):
        """Convert session to serializable format."""

        state = {
            'session': {
                'id': session['id'],
                'version': '1.0',
                'organization': session['organization'],
                'project': session.get('project'),
                'type': session['type'],
                'lifecycle': self._serialize_lifecycle(session),
                'context': self._serialize_context(session['context']),
                'working_state': self._serialize_working_state(session),
                'agents': self._serialize_agents(session),
                'metrics': session.get('metrics', {}),
                'resumption': self._generate_resumption_hints(session)
            }
        }

        return state

    def _serialize_context(self, context):
        """Serialize context to lightweight format."""

        # Don't store full content, just references
        serialized = {
            'essential': {
                'org_index_hash': hash_content(context['essential'].get('org_index', '')),
                'project_index_hash': hash_content(context['essential'].get('project_index', '')),
                'decisions_loaded': len(context['essential'].get('recent_decisions', [])),
                'playbooks_loaded': len(context['essential'].get('active_playbooks', []))
            },
            'recent': {
                'notes_created_count': len(context.get('recent', {}).get('notes_created', [])),
                'notes_updated_count': len(context.get('recent', {}).get('notes_updated', [])),
                'conversations_count': len(context.get('recent', {}).get('conversations', [])),
                'commits_count': len(context.get('recent', {}).get('commits', []))
            },
            'expanded': {
                'loaded_note_ids': list(context.get('loaded_notes', {}).keys()),
                'total_tokens_loaded': sum(
                    estimate_tokens(note)
                    for note in context.get('loaded_notes', {}).values()
                )
            }
        }

        return serialized

    def _generate_resumption_hints(self, session):
        """Generate hints for optimal session resumption."""

        hints = {
            'recommended_context': [],
            'open_questions': [],
            'next_actions': []
        }

        # Most recently accessed notes
        if 'working_memory' in session:
            recent_notes = session['working_memory'].get_frequently_accessed_notes()
            hints['recommended_context'] = recent_notes[:5]

        # Open questions from copilot
        if 'copilot_state' in session:
            unanswered = [
                q['question'] for q in session['copilot_state'].get('questions_asked', [])
                if not q.get('answered')
            ]
            hints['open_questions'] = unanswered[:5]

        # Uncommitted work becomes next actions
        if session.get('uncommitted_changes'):
            hints['next_actions'].append('Commit uncommitted changes')

        # Open threads become next actions
        for thread in session.get('open_threads', []):
            if thread['status'] == 'in_progress':
                hints['next_actions'].append(f"Continue: {thread['topic']}")

        return hints
```

## Persistence Strategies

### Automatic Checkpointing

```python
class SessionCheckpointer:
    """Automatic session checkpointing."""

    def __init__(self, session, interval_minutes=15):
        self.session = session
        self.interval = timedelta(minutes=interval_minutes)
        self.last_checkpoint = datetime.now()
        self.state_manager = SessionStateManager()
        self.checkpoint_count = 0

    def start_checkpointing(self):
        """Start background checkpointing."""

        self.running = True
        self.checkpoint_thread = threading.Thread(
            target=self._checkpoint_loop,
            daemon=True
        )
        self.checkpoint_thread.start()

    def _checkpoint_loop(self):
        """Background checkpoint loop."""

        while self.running:
            time.sleep(60)  # Check every minute

            if datetime.now() - self.last_checkpoint >= self.interval:
                self._create_checkpoint()

    def _create_checkpoint(self):
        """Create a checkpoint."""

        try:
            # Save current state
            self.state_manager.save_session(self.session)

            self.last_checkpoint = datetime.now()
            self.checkpoint_count += 1

            # Notify user (non-intrusively)
            if self.checkpoint_count % 4 == 0:  # Every hour
                print(f"Session auto-saved (checkpoint #{self.checkpoint_count})")

        except Exception as e:
            # Log but don't interrupt user
            log_error(f"Checkpoint failed: {e}")

    def force_checkpoint(self):
        """Force immediate checkpoint."""

        self._create_checkpoint()
        return {
            'status': 'saved',
            'checkpoint': self.checkpoint_count,
            'timestamp': self.last_checkpoint
        }

    def stop_checkpointing(self):
        """Stop checkpointing and create final checkpoint."""

        self.running = False
        self._create_checkpoint()  # Final save


class IncrementalSaver:
    """Save incremental changes efficiently."""

    def __init__(self, session):
        self.session = session
        self.pending_changes = []
        self.last_full_save = datetime.now()

    def record_change(self, change_type, data):
        """Record a change for incremental save."""

        self.pending_changes.append({
            'type': change_type,
            'data': data,
            'timestamp': datetime.now()
        })

        # Auto-save if too many pending changes
        if len(self.pending_changes) >= 50:
            self.save_incremental()

    def save_incremental(self):
        """Save incremental changes."""

        if not self.pending_changes:
            return

        increment_file = Path(
            f"~/.kaaos-knowledge/.kaaos/sessions/{self.session['id']}.increments.yaml"
        ).expanduser()

        # Append to increments file
        with open(increment_file, 'a') as f:
            for change in self.pending_changes:
                yaml.dump([change], f)

        self.pending_changes = []

    def merge_increments(self):
        """Merge incremental saves into full state."""

        increment_file = Path(
            f"~/.kaaos-knowledge/.kaaos/sessions/{self.session['id']}.increments.yaml"
        ).expanduser()

        if not increment_file.exists():
            return

        # Load increments
        with open(increment_file, 'r') as f:
            increments = list(yaml.safe_load_all(f))

        # Apply to session state
        for increment in increments:
            if increment:
                self._apply_increment(increment[0])

        # Clear increment file
        increment_file.unlink()

        # Save full state
        SessionStateManager().save_session(self.session)
        self.last_full_save = datetime.now()

    def _apply_increment(self, increment):
        """Apply single increment to session."""

        change_type = increment['type']
        data = increment['data']

        if change_type == 'note_accessed':
            self.session.setdefault('access_log', []).append(data)

        elif change_type == 'question_asked':
            self.session.setdefault('questions', []).append(data)

        elif change_type == 'context_expanded':
            self.session['context'].setdefault('loaded_notes', {}).update(data)
```

## Context Restoration

### Progressive Restoration

```python
class ContextRestorer:
    """Restore session context progressively."""

    def __init__(self, state, budget_tokens=40000):
        self.state = state
        self.budget = budget_tokens
        self.tokens_used = 0

    def restore_context(self, priority='balanced'):
        """Restore context based on priority strategy."""

        strategies = {
            'minimal': self._restore_minimal,
            'balanced': self._restore_balanced,
            'full': self._restore_full
        }

        return strategies[priority]()

    def _restore_minimal(self):
        """Restore minimal context (~5K tokens)."""

        context = {}

        # Essential indexes only
        org_name = self.state['organization']
        project_name = self.state.get('project')

        context['essential'] = {
            'org_index': load_note(
                f'organizations/{org_name}/context-library/00-INDEX.md'
            ),
            'project_index': load_note(
                f'organizations/{org_name}/projects/{project_name}/context-library/00-PROJECT-INDEX.md'
            ) if project_name else None
        }

        self.tokens_used = estimate_tokens(context)

        return {
            'context': context,
            'tokens_used': self.tokens_used,
            'restoration_level': 'minimal'
        }

    def _restore_balanced(self):
        """Restore balanced context (~25K tokens)."""

        context = {}

        # Start with minimal
        minimal = self._restore_minimal()
        context = minimal['context']

        # Add recommended context from resumption hints
        recommended = self.state.get('resumption', {}).get('recommended_context', [])

        context['loaded_notes'] = {}
        for note_id in recommended:
            if self.tokens_used + 2000 > self.budget:
                break  # Stay within budget

            try:
                note = load_note(note_id)
                context['loaded_notes'][note_id] = note
                self.tokens_used += estimate_tokens(note)
            except NoteNotFoundError:
                continue

        # Load recent decisions
        context['essential']['recent_decisions'] = load_recent_decisions(
            self.state['organization'],
            self.state.get('project'),
            days=30
        )[:5]  # Limit to 5

        self.tokens_used += estimate_tokens(context['essential']['recent_decisions'])

        return {
            'context': context,
            'tokens_used': self.tokens_used,
            'restoration_level': 'balanced'
        }

    def _restore_full(self):
        """Restore full context from previous session (~40K tokens)."""

        context = {}

        # Start with balanced
        balanced = self._restore_balanced()
        context = balanced['context']

        # Restore all previously loaded notes
        previous_notes = self.state.get('context', {}).get('expanded', {}).get('loaded_note_ids', [])

        for note_id in previous_notes:
            if note_id in context.get('loaded_notes', {}):
                continue  # Already loaded

            if self.tokens_used + 2000 > self.budget:
                break  # Stay within budget

            try:
                note = load_note(note_id)
                context.setdefault('loaded_notes', {})[note_id] = note
                self.tokens_used += estimate_tokens(note)
            except NoteNotFoundError:
                continue

        return {
            'context': context,
            'tokens_used': self.tokens_used,
            'restoration_level': 'full',
            'notes_restored': len(context.get('loaded_notes', {})),
            'notes_requested': len(previous_notes)
        }

    def restore_working_state(self):
        """Restore working state (current focus, open threads)."""

        working = self.state.get('working_state', {})

        restored = {
            'current_focus': None,
            'open_threads': [],
            'uncommitted_changes': []
        }

        # Restore current focus
        if working.get('current_focus'):
            focus = working['current_focus']
            try:
                note = load_note(focus['note_id'])
                restored['current_focus'] = {
                    'note': note,
                    'position': focus.get('position')
                }
            except NoteNotFoundError:
                pass

        # Restore open threads
        restored['open_threads'] = working.get('open_threads', [])

        # Check uncommitted changes
        for change in working.get('uncommitted_changes', []):
            file_path = Path(change['file'])
            if file_path.exists():
                restored['uncommitted_changes'].append({
                    'file': change['file'],
                    'type': change['type'],
                    'still_uncommitted': check_git_status(file_path)
                })

        return restored
```

### Delta-Based Restoration

```python
class DeltaRestorer:
    """Restore context by applying deltas from last session."""

    def __init__(self, previous_state, current_state):
        self.previous = previous_state
        self.current = current_state

    def calculate_deltas(self):
        """Calculate what changed since last session."""

        deltas = {
            'notes_created': [],
            'notes_updated': [],
            'notes_deleted': [],
            'context_changes': []
        }

        # Time since last session
        last_active = datetime.fromisoformat(
            self.previous['lifecycle']['paused'] or
            self.previous['lifecycle']['ended']
        )

        # Find notes created since then
        deltas['notes_created'] = find_notes_created_after(
            self.previous['organization'],
            last_active
        )

        # Find notes updated since then
        deltas['notes_updated'] = find_notes_updated_after(
            self.previous['organization'],
            last_active
        )

        # Check if previously loaded notes were deleted
        previous_loaded = (
            self.previous.get('context', {})
            .get('expanded', {})
            .get('loaded_note_ids', [])
        )

        for note_id in previous_loaded:
            if not note_exists(note_id):
                deltas['notes_deleted'].append(note_id)

        return deltas

    def generate_delta_report(self, deltas):
        """Generate human-readable delta report."""

        report = f"""
Session Resumption Delta Report
===============================

Time away: {self.calculate_time_away()}

Changes since last session:

Notes Created: {len(deltas['notes_created'])}
"""

        for note in deltas['notes_created'][:5]:
            report += f"  + [[{note.id}|{note.title}]]\n"

        if len(deltas['notes_created']) > 5:
            report += f"  ... and {len(deltas['notes_created']) - 5} more\n"

        report += f"""
Notes Updated: {len(deltas['notes_updated'])}
"""

        for note in deltas['notes_updated'][:5]:
            report += f"  ~ [[{note.id}|{note.title}]]\n"

        if deltas['notes_deleted']:
            report += f"""
Notes Deleted: {len(deltas['notes_deleted'])}
  (Previously loaded notes that no longer exist)
"""
            for note_id in deltas['notes_deleted']:
                report += f"  - {note_id}\n"

        return report

    def suggest_context_refresh(self, deltas):
        """Suggest context to refresh based on deltas."""

        suggestions = []

        # Suggest loading new notes if relevant
        if deltas['notes_created']:
            suggestions.append({
                'action': 'load_new_notes',
                'description': f'Load {len(deltas["notes_created"])} new notes',
                'notes': [n.id for n in deltas['notes_created'][:10]]
            })

        # Suggest refreshing updated notes
        if deltas['notes_updated']:
            # Check which updated notes were previously loaded
            previously_loaded = set(
                self.previous.get('context', {})
                .get('expanded', {})
                .get('loaded_note_ids', [])
            )

            updated_and_loaded = [
                n for n in deltas['notes_updated']
                if n.id in previously_loaded
            ]

            if updated_and_loaded:
                suggestions.append({
                    'action': 'refresh_updated',
                    'description': f'Refresh {len(updated_and_loaded)} updated notes',
                    'notes': [n.id for n in updated_and_loaded]
                })

        return suggestions
```

## Interruption Handling

### Graceful Pause

```python
class InterruptionHandler:
    """Handle session interruptions gracefully."""

    def __init__(self, session, checkpointer):
        self.session = session
        self.checkpointer = checkpointer
        self.interrupt_handlers = {
            'user_pause': self._handle_user_pause,
            'budget_exceeded': self._handle_budget_exceeded,
            'timeout': self._handle_timeout,
            'error': self._handle_error,
            'system_interrupt': self._handle_system_interrupt
        }

    def handle_interruption(self, interrupt_type, context=None):
        """Handle session interruption."""

        handler = self.interrupt_handlers.get(
            interrupt_type,
            self._handle_generic_interrupt
        )

        return handler(context)

    def _handle_user_pause(self, context):
        """Handle user-initiated pause."""

        # Force checkpoint
        self.checkpointer.force_checkpoint()

        # Update session state
        self.session['lifecycle']['paused'] = datetime.now().isoformat()
        self.session['lifecycle']['pause_reason'] = 'user_requested'

        # Generate resumption summary
        summary = self._generate_pause_summary()

        # Stop copilot if running
        if self.session.get('agents', {}).get('copilot', {}).get('active'):
            self._pause_copilot()

        return {
            'status': 'paused',
            'session_id': self.session['id'],
            'summary': summary,
            'resume_command': f"/kaaos:session resume {self.session['id']}"
        }

    def _handle_budget_exceeded(self, context):
        """Handle budget exceeded interruption."""

        # Save state immediately
        self.checkpointer.force_checkpoint()

        # Reduce copilot activity
        if self.session.get('agents', {}).get('copilot', {}).get('active'):
            self._reduce_copilot_mode()

        return {
            'status': 'budget_warning',
            'current_spend': context.get('current_spend'),
            'budget_limit': context.get('budget_limit'),
            'options': [
                {
                    'action': 'continue_limited',
                    'description': 'Continue with reduced copilot (reactive mode)'
                },
                {
                    'action': 'pause',
                    'description': 'Pause session and resume later',
                    'command': '/kaaos:session pause'
                },
                {
                    'action': 'increase_budget',
                    'description': 'Increase session budget',
                    'command': '/kaaos:status --budget increase'
                }
            ]
        }

    def _handle_timeout(self, context):
        """Handle session timeout."""

        # Auto-save
        self.checkpointer.force_checkpoint()

        # Update state
        self.session['lifecycle']['paused'] = datetime.now().isoformat()
        self.session['lifecycle']['pause_reason'] = 'timeout'

        # Generate inactivity report
        report = {
            'status': 'timed_out',
            'inactive_duration': context.get('inactive_duration'),
            'last_activity': context.get('last_activity'),
            'session_saved': True,
            'resume_command': f"/kaaos:session resume {self.session['id']}"
        }

        return report

    def _generate_pause_summary(self):
        """Generate summary of session state at pause."""

        summary = {
            'duration': self._calculate_duration(),
            'work_completed': {
                'notes_created': self.session['metrics'].get('notes_created', 0),
                'notes_updated': self.session['metrics'].get('notes_updated', 0),
                'decisions_made': self.session['metrics'].get('decisions_made', 0)
            },
            'work_in_progress': [],
            'next_actions': []
        }

        # Identify work in progress
        if self.session.get('uncommitted_changes'):
            summary['work_in_progress'].append(
                f"{len(self.session['uncommitted_changes'])} uncommitted changes"
            )

        for thread in self.session.get('open_threads', []):
            if thread['status'] == 'in_progress':
                summary['work_in_progress'].append(thread['topic'])

        # Suggest next actions
        if summary['work_in_progress']:
            summary['next_actions'].append('Complete in-progress work')

        summary['next_actions'].extend(
            self.session.get('resumption', {}).get('next_actions', [])[:3]
        )

        return summary

    def _pause_copilot(self):
        """Pause copilot agent."""

        copilot = self.session['agents']['copilot']

        # Save copilot state
        copilot_state_file = Path(
            f"~/.kaaos-knowledge/.kaaos/sessions/{self.session['id']}/copilot-state.yaml"
        ).expanduser()

        copilot_state = {
            'mode': copilot.get('mode'),
            'working_memory': copilot.get('working_memory', {}).memory,
            'pending_suggestions': copilot.get('pending_suggestions', [])
        }

        with open(copilot_state_file, 'w') as f:
            yaml.dump(copilot_state, f)

        # Stop process
        if copilot.get('pid'):
            try:
                os.kill(copilot['pid'], signal.SIGTERM)
            except ProcessLookupError:
                pass  # Already stopped

        copilot['active'] = False
```

### Emergency Save

```python
class EmergencySaver:
    """Emergency state saving for crash recovery."""

    def __init__(self, session):
        self.session = session
        self.emergency_file = Path(
            f"~/.kaaos-knowledge/.kaaos/sessions/emergency-{session['id']}.yaml"
        ).expanduser()

    def setup_crash_handlers(self):
        """Setup signal handlers for crash recovery."""

        signal.signal(signal.SIGTERM, self._handle_signal)
        signal.signal(signal.SIGINT, self._handle_signal)

        # Register atexit handler
        atexit.register(self._emergency_save)

    def _handle_signal(self, signum, frame):
        """Handle termination signals."""

        self._emergency_save()
        sys.exit(0)

    def _emergency_save(self):
        """Perform emergency save."""

        try:
            # Minimal state save
            emergency_state = {
                'session_id': self.session['id'],
                'organization': self.session['organization'],
                'project': self.session.get('project'),
                'timestamp': datetime.now().isoformat(),
                'reason': 'emergency_save',
                'context_paths': get_loaded_context_paths(self.session),
                'uncommitted_changes': self.session.get('uncommitted_changes', []),
                'open_threads': self.session.get('open_threads', [])
            }

            with open(self.emergency_file, 'w') as f:
                yaml.dump(emergency_state, f)

        except Exception:
            pass  # Best effort, don't crash during crash

    def recover_from_emergency(self):
        """Recover session from emergency save."""

        if not self.emergency_file.exists():
            return None

        with open(self.emergency_file, 'r') as f:
            emergency_state = yaml.safe_load(f)

        # Clean up emergency file
        self.emergency_file.unlink()

        return {
            'recovered_from': 'emergency',
            'timestamp': emergency_state['timestamp'],
            'state': emergency_state
        }
```

## Multi-Session Management

### Session Registry

```python
class SessionRegistry:
    """Manage multiple sessions."""

    def __init__(self, kaaos_root):
        self.kaaos_root = Path(kaaos_root)
        self.sessions_dir = self.kaaos_root / '.kaaos' / 'sessions'
        self.registry_file = self.sessions_dir / 'registry.yaml'

    def list_sessions(self, status=None, organization=None, project=None):
        """List sessions with optional filters."""

        sessions = []

        for session_file in self.sessions_dir.glob('*.yaml'):
            if session_file.name in ['registry.yaml', 'emergency-*.yaml']:
                continue

            try:
                with open(session_file, 'r') as f:
                    state = yaml.safe_load(f)

                session = state.get('session', {})

                # Apply filters
                if status and self._get_status(session) != status:
                    continue

                if organization and session.get('organization') != organization:
                    continue

                if project and session.get('project') != project:
                    continue

                sessions.append({
                    'id': session['id'],
                    'organization': session.get('organization'),
                    'project': session.get('project'),
                    'type': session.get('type'),
                    'status': self._get_status(session),
                    'created': session.get('lifecycle', {}).get('created'),
                    'last_active': self._get_last_active(session)
                })

            except Exception:
                continue

        # Sort by last active
        sessions.sort(
            key=lambda s: s['last_active'] or '',
            reverse=True
        )

        return sessions

    def _get_status(self, session):
        """Determine session status."""

        lifecycle = session.get('lifecycle', {})

        if lifecycle.get('ended'):
            return 'ended'
        elif lifecycle.get('paused'):
            return 'paused'
        elif lifecycle.get('started'):
            return 'active'
        else:
            return 'created'

    def _get_last_active(self, session):
        """Get last active timestamp."""

        lifecycle = session.get('lifecycle', {})

        return (
            lifecycle.get('paused') or
            lifecycle.get('ended') or
            lifecycle.get('started') or
            lifecycle.get('created')
        )

    def find_resumable_sessions(self, organization, project=None):
        """Find sessions that can be resumed."""

        resumable = []

        sessions = self.list_sessions(
            status='paused',
            organization=organization,
            project=project
        )

        for session in sessions:
            # Check if session is recent enough (within 7 days)
            last_active = datetime.fromisoformat(session['last_active'])
            if datetime.now() - last_active < timedelta(days=7):
                resumable.append(session)

        return resumable

    def cleanup_old_sessions(self, max_age_days=30):
        """Clean up old session files."""

        cutoff = datetime.now() - timedelta(days=max_age_days)
        cleaned = []

        sessions = self.list_sessions(status='ended')

        for session in sessions:
            ended = datetime.fromisoformat(session['last_active'])
            if ended < cutoff:
                # Archive and delete
                self._archive_session(session['id'])
                cleaned.append(session['id'])

        return cleaned

    def _archive_session(self, session_id):
        """Archive session to compressed storage."""

        session_file = self.sessions_dir / f"{session_id}.yaml"
        archive_dir = self.sessions_dir / 'archive'
        archive_dir.mkdir(exist_ok=True)

        # Compress and move
        archive_file = archive_dir / f"{session_id}.yaml.gz"

        with open(session_file, 'rb') as f_in:
            with gzip.open(archive_file, 'wb') as f_out:
                f_out.writelines(f_in)

        # Remove original
        session_file.unlink()
```

### Session Switching

```python
class SessionSwitcher:
    """Handle switching between sessions."""

    def __init__(self, current_session, registry):
        self.current = current_session
        self.registry = registry

    def switch_to(self, target_session_id, save_current=True):
        """Switch to a different session."""

        # Save current session
        if save_current and self.current:
            print("Saving current session...")
            pause_result = InterruptionHandler(
                self.current,
                SessionCheckpointer(self.current)
            ).handle_interruption('user_pause')

            print(f"Current session paused: {self.current['id']}")

        # Load target session
        print(f"\nLoading session: {target_session_id}")

        target_state = self._load_session_state(target_session_id)

        if not target_state:
            return {
                'status': 'error',
                'message': f'Session {target_session_id} not found'
            }

        # Restore context
        restorer = ContextRestorer(target_state['session'])
        restoration = restorer.restore_context(priority='balanced')

        # Build new session
        new_session = {
            'id': target_state['session']['id'],
            'organization': target_state['session']['organization'],
            'project': target_state['session'].get('project'),
            'type': target_state['session']['type'],
            'started': datetime.fromisoformat(target_state['session']['lifecycle']['started']),
            'resumed': datetime.now(),
            'context': restoration['context']
        }

        # Restore working state
        working_state = restorer.restore_working_state()
        new_session['working_state'] = working_state

        return {
            'status': 'switched',
            'from_session': self.current['id'] if self.current else None,
            'to_session': new_session['id'],
            'session': new_session,
            'restoration': restoration
        }

    def _load_session_state(self, session_id):
        """Load session state from file."""

        session_file = Path(
            f"~/.kaaos-knowledge/.kaaos/sessions/{session_id}.yaml"
        ).expanduser()

        if not session_file.exists():
            return None

        with open(session_file, 'r') as f:
            return yaml.safe_load(f)
```

## Recovery Patterns

### Corruption Recovery

```python
class SessionRecovery:
    """Recover from corrupted or incomplete session state."""

    def __init__(self, session_id):
        self.session_id = session_id
        self.sessions_dir = Path("~/.kaaos-knowledge/.kaaos/sessions").expanduser()

    def attempt_recovery(self):
        """Attempt to recover session from available data."""

        recovery_sources = [
            self._try_primary_state,
            self._try_backup_state,
            self._try_incremental_state,
            self._try_emergency_state,
            self._try_git_recovery
        ]

        for source in recovery_sources:
            result = source()
            if result['success']:
                return result

        return {
            'success': False,
            'message': 'Unable to recover session from any source',
            'session_id': self.session_id
        }

    def _try_primary_state(self):
        """Try to load primary state file."""

        state_file = self.sessions_dir / f"{self.session_id}.yaml"

        if not state_file.exists():
            return {'success': False, 'source': 'primary'}

        try:
            with open(state_file, 'r') as f:
                state = yaml.safe_load(f)

            if self._validate_state(state):
                return {
                    'success': True,
                    'source': 'primary',
                    'state': state
                }

        except Exception as e:
            return {'success': False, 'source': 'primary', 'error': str(e)}

        return {'success': False, 'source': 'primary', 'error': 'validation_failed'}

    def _try_backup_state(self):
        """Try to load backup state file."""

        backup_file = self.sessions_dir / f"{self.session_id}.backup.yaml"

        if not backup_file.exists():
            return {'success': False, 'source': 'backup'}

        try:
            with open(backup_file, 'r') as f:
                state = yaml.safe_load(f)

            if self._validate_state(state):
                # Restore from backup
                primary_file = self.sessions_dir / f"{self.session_id}.yaml"
                shutil.copy(backup_file, primary_file)

                return {
                    'success': True,
                    'source': 'backup',
                    'state': state,
                    'restored': True
                }

        except Exception as e:
            return {'success': False, 'source': 'backup', 'error': str(e)}

        return {'success': False, 'source': 'backup'}

    def _try_git_recovery(self):
        """Try to recover state from git history."""

        state_file = self.sessions_dir / f"{self.session_id}.yaml"

        try:
            # Get previous version from git
            result = subprocess.run(
                ['git', 'show', f'HEAD~1:{state_file}'],
                capture_output=True,
                text=True,
                cwd=self.sessions_dir.parent
            )

            if result.returncode == 0:
                state = yaml.safe_load(result.stdout)

                if self._validate_state(state):
                    # Restore from git
                    with open(state_file, 'w') as f:
                        yaml.dump(state, f)

                    return {
                        'success': True,
                        'source': 'git_history',
                        'state': state,
                        'restored': True
                    }

        except Exception as e:
            return {'success': False, 'source': 'git_history', 'error': str(e)}

        return {'success': False, 'source': 'git_history'}

    def _validate_state(self, state):
        """Validate session state structure."""

        required_fields = ['session']
        session_fields = ['id', 'organization', 'type', 'lifecycle']

        if not all(field in state for field in required_fields):
            return False

        session = state['session']
        if not all(field in session for field in session_fields):
            return False

        return True
```

## Token Budget Restoration

### Budget-Aware Restoration

```python
class BudgetAwareRestorer:
    """Restore context with token budget awareness."""

    def __init__(self, state, budget_config):
        self.state = state
        self.budget = budget_config
        self.tokens_used = 0

    def restore_with_budget(self):
        """Restore context respecting token budget."""

        total_budget = self.budget.get('session_context', 40000)

        # Calculate restoration priorities
        priorities = self._calculate_priorities()

        context = {}
        restoration_log = []

        for priority_item in priorities:
            estimated_tokens = priority_item['estimated_tokens']

            if self.tokens_used + estimated_tokens > total_budget:
                restoration_log.append({
                    'item': priority_item['id'],
                    'status': 'skipped',
                    'reason': 'budget_exceeded'
                })
                continue

            # Load item
            loaded = self._load_priority_item(priority_item)

            if loaded:
                context[priority_item['category']] = loaded
                self.tokens_used += estimate_tokens(loaded)
                restoration_log.append({
                    'item': priority_item['id'],
                    'status': 'loaded',
                    'tokens': estimate_tokens(loaded)
                })

        return {
            'context': context,
            'tokens_used': self.tokens_used,
            'budget_total': total_budget,
            'budget_remaining': total_budget - self.tokens_used,
            'restoration_log': restoration_log
        }

    def _calculate_priorities(self):
        """Calculate restoration priorities."""

        priorities = []

        # Essential context (highest priority)
        priorities.append({
            'id': 'essential',
            'category': 'essential',
            'priority': 1.0,
            'estimated_tokens': 5000,
            'loader': self._load_essential
        })

        # Recommended context from resumption
        recommended = self.state.get('resumption', {}).get('recommended_context', [])
        for note_id in recommended:
            priorities.append({
                'id': f'recommended:{note_id}',
                'category': 'loaded_notes',
                'priority': 0.9,
                'estimated_tokens': 2000,
                'loader': lambda nid=note_id: load_note(nid)
            })

        # Recent work
        priorities.append({
            'id': 'recent',
            'category': 'recent',
            'priority': 0.8,
            'estimated_tokens': 10000,
            'loader': self._load_recent
        })

        # Previously expanded context (lower priority)
        expanded = (
            self.state.get('context', {})
            .get('expanded', {})
            .get('loaded_note_ids', [])
        )

        for note_id in expanded:
            if note_id not in recommended:
                priorities.append({
                    'id': f'expanded:{note_id}',
                    'category': 'loaded_notes',
                    'priority': 0.5,
                    'estimated_tokens': 2000,
                    'loader': lambda nid=note_id: load_note(nid)
                })

        # Sort by priority
        priorities.sort(key=lambda p: p['priority'], reverse=True)

        return priorities
```

## Best Practices

1. **Checkpoint Frequently**: Auto-save every 15 minutes
2. **Use Incremental Saves**: Reduce I/O with delta saves
3. **Prioritize Restoration**: Load essential context first
4. **Track Deltas**: Show what changed since last session
5. **Handle Interruptions**: Always save on pause/interrupt
6. **Clean Up Old Sessions**: Archive sessions older than 30 days
7. **Validate State**: Check state integrity on load
8. **Respect Budgets**: Stay within token limits during restoration

## Common Pitfalls

- **No Checkpointing**: Losing work on crash
- **Full State Saves**: Slow saves of unchanged data
- **Eager Restoration**: Loading everything regardless of need
- **Ignoring Deltas**: Missing changes made between sessions
- **No Error Recovery**: Failing without fallback options
- **Session Sprawl**: Too many old sessions cluttering storage
- **Budget Overrun**: Restoring more than token budget allows
- **Lost Agent State**: Not preserving copilot memory
