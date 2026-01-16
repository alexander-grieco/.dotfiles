# Co-Pilot Interaction Patterns

Advanced patterns for effective human-AI collaboration during work sessions, including interaction modes, proactive assistance, and context-aware responses.

## Table of Contents

1. [Interaction Modes](#interaction-modes)
2. [Proactive Assistance Patterns](#proactive-assistance-patterns)
3. [Query Response Patterns](#query-response-patterns)
4. [Context-Aware Suggestions](#context-aware-suggestions)
5. [Session Memory Management](#session-memory-management)
6. [Multi-Turn Conversation Patterns](#multi-turn-conversation-patterns)
7. [Error Recovery and Clarification](#error-recovery-and-clarification)
8. [Integration with KAAOS Agents](#integration-with-kaaos-agents)

## Interaction Modes

### Mode Selection Framework

```python
# Co-pilot interaction mode configuration
INTERACTION_MODES = {
    'reactive': {
        'description': 'Responds only when explicitly asked',
        'proactive_suggestions': False,
        'pattern_detection': False,
        'auto_expand_context': False,
        'cost_per_hour': 0.10,
        'best_for': ['deep focus work', 'cost-sensitive sessions', 'experienced users']
    },
    'balanced': {
        'description': 'Selective proactive assistance with user control',
        'proactive_suggestions': True,
        'suggestion_threshold': 0.8,  # High confidence only
        'pattern_detection': True,
        'auto_expand_context': False,
        'cost_per_hour': 0.30,
        'best_for': ['standard sessions', 'most users', 'moderate complexity']
    },
    'proactive': {
        'description': 'Active assistance with frequent suggestions',
        'proactive_suggestions': True,
        'suggestion_threshold': 0.6,  # Medium confidence
        'pattern_detection': True,
        'auto_expand_context': True,
        'cost_per_hour': 0.50,
        'best_for': ['learning new domains', 'complex problems', 'strategic work']
    }
}

def select_interaction_mode(session_type, user_preference=None, budget_remaining=None):
    """Select appropriate interaction mode for session."""

    # User preference takes priority
    if user_preference and user_preference in INTERACTION_MODES:
        return user_preference

    # Budget constraints
    if budget_remaining and budget_remaining < 1.00:
        return 'reactive'

    # Session type defaults
    mode_by_session = {
        'focus': 'balanced',
        'strategic': 'proactive',
        'research': 'proactive',
        'meeting-prep': 'balanced',
        'review': 'reactive'
    }

    return mode_by_session.get(session_type, 'balanced')
```

### Reactive Mode Implementation

```python
class ReactiveCopilot:
    """Co-pilot that responds only when explicitly asked."""

    def __init__(self, session):
        self.session = session
        self.mode = 'reactive'
        self.response_count = 0
        self.context_cache = {}

    def should_respond(self, event_type):
        """Determine if co-pilot should respond to event."""

        # Only respond to explicit requests
        explicit_triggers = [
            'user_question',
            'copilot_command',
            'help_request'
        ]

        return event_type in explicit_triggers

    def handle_request(self, request):
        """Handle explicit user request."""

        if request.type == 'question':
            return self.answer_question(request.content)

        elif request.type == 'search':
            return self.search_context(request.query)

        elif request.type == 'relate':
            return self.find_related_notes(request.note_id)

        elif request.type == 'suggest':
            return self.generate_suggestions(request.context)

    def answer_question(self, question):
        """Answer direct question from context."""

        # Search session context
        results = search_session_context(
            self.session['context'],
            question
        )

        if not results:
            return {
                'status': 'no_match',
                'message': 'No relevant context found for this question.',
                'suggestion': 'Try: /copilot search "[broader terms]"'
            }

        # Format response with citations
        response = {
            'status': 'found',
            'answer': results[0]['content'],
            'source': results[0]['source'],
            'confidence': results[0]['score'],
            'related': results[1:3] if len(results) > 1 else []
        }

        self.response_count += 1
        return response
```

### Balanced Mode Implementation

```python
class BalancedCopilot:
    """Co-pilot with selective proactive assistance."""

    def __init__(self, session):
        self.session = session
        self.mode = 'balanced'
        self.suggestion_threshold = 0.8
        self.suggestion_cooldown = 300  # 5 minutes between proactive suggestions
        self.last_suggestion_time = 0
        self.pending_suggestions = []

    def process_user_activity(self, activity):
        """Process user activity for potential suggestions."""

        # Always handle explicit requests
        if activity.type in ['question', 'command']:
            return self.handle_request(activity)

        # Check for proactive suggestion opportunities
        if activity.type == 'note_created':
            suggestion = self.check_note_suggestions(activity.note)
            if suggestion and suggestion['confidence'] >= self.suggestion_threshold:
                self.queue_suggestion(suggestion)

        elif activity.type == 'search_performed':
            suggestion = self.check_search_enhancement(activity.query)
            if suggestion and suggestion['confidence'] >= self.suggestion_threshold:
                self.queue_suggestion(suggestion)

        # Deliver pending suggestions if cooldown passed
        return self.deliver_pending_suggestions()

    def check_note_suggestions(self, note):
        """Check if note could benefit from suggestions."""

        suggestions = []

        # Check for missing cross-references
        potential_refs = find_potential_references(
            note.content,
            self.session['context']
        )

        if potential_refs:
            suggestions.append({
                'type': 'cross_reference',
                'message': f'Consider linking to: {format_note_list(potential_refs[:3])}',
                'confidence': calculate_reference_confidence(potential_refs),
                'action': 'add_references',
                'data': potential_refs
            })

        # Check for pattern matches
        patterns = detect_patterns(note.content, self.session['context'])

        if patterns:
            suggestions.append({
                'type': 'pattern_match',
                'message': f'This looks similar to: {patterns[0]["pattern_name"]}',
                'confidence': patterns[0]['score'],
                'action': 'view_pattern',
                'data': patterns[0]
            })

        # Return highest confidence suggestion
        if suggestions:
            return max(suggestions, key=lambda s: s['confidence'])

        return None

    def queue_suggestion(self, suggestion):
        """Queue suggestion for delivery."""

        # Deduplicate
        if not any(s['type'] == suggestion['type'] and
                   s.get('data') == suggestion.get('data')
                   for s in self.pending_suggestions):
            self.pending_suggestions.append(suggestion)

    def deliver_pending_suggestions(self):
        """Deliver pending suggestions respecting cooldown."""

        current_time = time.time()

        if not self.pending_suggestions:
            return None

        if current_time - self.last_suggestion_time < self.suggestion_cooldown:
            return None  # Still in cooldown

        # Deliver highest priority suggestion
        suggestion = max(self.pending_suggestions, key=lambda s: s['confidence'])
        self.pending_suggestions.remove(suggestion)
        self.last_suggestion_time = current_time

        return format_suggestion(suggestion)
```

### Proactive Mode Implementation

```python
class ProactiveCopilot:
    """Co-pilot with active, frequent assistance."""

    def __init__(self, session):
        self.session = session
        self.mode = 'proactive'
        self.suggestion_threshold = 0.6
        self.suggestion_cooldown = 120  # 2 minutes
        self.context_expansion_enabled = True
        self.pattern_watchers = []
        self.activity_buffer = []

    def initialize_watchers(self):
        """Initialize pattern watchers for proactive detection."""

        self.pattern_watchers = [
            DecisionPatternWatcher(self.session),
            RepetitionPatternWatcher(self.session),
            GapPatternWatcher(self.session),
            ConnectionPatternWatcher(self.session)
        ]

    def process_activity_stream(self, activity):
        """Process activity stream for proactive assistance."""

        # Buffer activity
        self.activity_buffer.append({
            'activity': activity,
            'timestamp': time.time()
        })

        # Trim old activities (keep last 30 minutes)
        cutoff = time.time() - 1800
        self.activity_buffer = [
            a for a in self.activity_buffer
            if a['timestamp'] > cutoff
        ]

        # Run pattern watchers
        detections = []
        for watcher in self.pattern_watchers:
            detection = watcher.check(self.activity_buffer)
            if detection:
                detections.append(detection)

        # Auto-expand context if enabled
        if self.context_expansion_enabled:
            self.check_context_expansion(activity)

        # Return most important detection
        if detections:
            return max(detections, key=lambda d: d['priority'])

        return None

    def check_context_expansion(self, activity):
        """Check if context should be expanded."""

        # Detect when user is searching for something not in context
        if activity.type == 'search_performed':
            coverage = check_query_coverage(
                activity.query,
                self.session['context']
            )

            if coverage < 0.5:
                # Auto-expand context
                expansion = expand_context_for_query(
                    activity.query,
                    self.session
                )

                if expansion:
                    self.session['context']['expanded'] = expansion
                    return {
                        'type': 'context_expanded',
                        'message': f'Loaded {len(expansion)} additional notes for your search',
                        'notes': [n.title for n in expansion[:5]]
                    }

        return None


class DecisionPatternWatcher:
    """Watch for decision-making patterns."""

    def __init__(self, session):
        self.session = session
        self.decision_keywords = [
            'should we', 'decide', 'choice', 'option',
            'alternative', 'trade-off', 'pros cons'
        ]

    def check(self, activity_buffer):
        """Check for decision-making activity."""

        recent_content = extract_recent_content(activity_buffer, minutes=10)

        if any(keyword in recent_content.lower()
               for keyword in self.decision_keywords):

            # Find relevant decision frameworks
            frameworks = find_decision_frameworks(self.session['context'])
            recent_decisions = find_recent_decisions(
                self.session['organization'],
                self.session.get('project'),
                days=90
            )

            return {
                'type': 'decision_detected',
                'priority': 0.8,
                'message': 'Looks like you are making a decision.',
                'suggestions': [
                    {
                        'action': 'view_frameworks',
                        'label': f'View {len(frameworks)} decision frameworks'
                    },
                    {
                        'action': 'view_examples',
                        'label': f'See {len(recent_decisions)} recent decisions'
                    }
                ]
            }

        return None
```

## Proactive Assistance Patterns

### Pattern Detection Engine

```python
class PatternDetectionEngine:
    """Detect patterns in user work to provide proactive assistance."""

    def __init__(self, session):
        self.session = session
        self.detectors = [
            RepetitionDetector(),
            GapDetector(),
            ConnectionDetector(),
            DecisionDetector(),
            BlockageDetector()
        ]

    def analyze_activity(self, activities, window_minutes=30):
        """Analyze recent activity for patterns."""

        cutoff = datetime.now() - timedelta(minutes=window_minutes)
        recent = [a for a in activities if a['timestamp'] > cutoff]

        detections = []
        for detector in self.detectors:
            result = detector.detect(recent, self.session['context'])
            if result and result['confidence'] > 0.6:
                detections.append(result)

        # Sort by priority and confidence
        detections.sort(
            key=lambda d: d['priority'] * d['confidence'],
            reverse=True
        )

        return detections


class RepetitionDetector:
    """Detect repetitive actions that could be automated."""

    def detect(self, activities, context):
        """Detect repetitive patterns."""

        # Group activities by type
        by_type = defaultdict(list)
        for activity in activities:
            by_type[activity['type']].append(activity)

        repetitions = []

        # Check for repeated searches
        if len(by_type['search']) >= 3:
            queries = [a['query'] for a in by_type['search']]
            similar_queries = find_similar_strings(queries, threshold=0.7)

            if similar_queries:
                repetitions.append({
                    'type': 'repeated_search',
                    'pattern': 'Searching for similar terms multiple times',
                    'suggestion': 'Create a saved search or reference note',
                    'data': similar_queries
                })

        # Check for repeated file access
        if len(by_type['file_access']) >= 5:
            files = [a['file'] for a in by_type['file_access']]
            frequent_files = find_frequent_items(files, min_count=3)

            if frequent_files:
                repetitions.append({
                    'type': 'frequent_files',
                    'pattern': 'Accessing same files repeatedly',
                    'suggestion': 'Consider creating a reference note linking these files',
                    'data': frequent_files
                })

        if repetitions:
            return {
                'detector': 'repetition',
                'confidence': 0.85,
                'priority': 0.7,
                'findings': repetitions
            }

        return None


class GapDetector:
    """Detect gaps in knowledge or missing context."""

    def detect(self, activities, context):
        """Detect knowledge gaps."""

        gaps = []

        # Check for unanswered questions
        questions = [
            a for a in activities
            if a['type'] == 'question' and not a.get('answered')
        ]

        if questions:
            # Check if answers exist in context but were not found
            for question in questions:
                potential_answers = search_context(
                    context,
                    question['content'],
                    threshold=0.5
                )

                if potential_answers:
                    gaps.append({
                        'type': 'missed_context',
                        'question': question['content'],
                        'potential_answers': potential_answers,
                        'suggestion': 'This information exists in your context library'
                    })
                else:
                    gaps.append({
                        'type': 'knowledge_gap',
                        'question': question['content'],
                        'suggestion': 'Consider researching this topic'
                    })

        # Check for referenced notes that don't exist
        references = extract_all_references(activities)
        missing_refs = [
            ref for ref in references
            if not note_exists(ref)
        ]

        if missing_refs:
            gaps.append({
                'type': 'missing_references',
                'references': missing_refs,
                'suggestion': 'These referenced notes do not exist'
            })

        if gaps:
            return {
                'detector': 'gap',
                'confidence': 0.9,
                'priority': 0.8,
                'findings': gaps
            }

        return None
```

### Suggestion Formatting

```python
def format_proactive_suggestion(detection):
    """Format detection as user-friendly suggestion."""

    templates = {
        'repetition': """
{icon} Pattern Detected: {pattern}

{suggestion}

{action_prompt}
""",
        'gap': """
{icon} Knowledge Gap: {gap_type}

{context}

Suggested action: {suggestion}
""",
        'connection': """
{icon} Connection Found

{description}

Related notes:
{related_notes}

{action_prompt}
""",
        'decision': """
{icon} Decision Support

You appear to be making a decision about: {topic}

Relevant resources:
{resources}

{action_prompt}
"""
    }

    icons = {
        'repetition': 'Repetition',
        'gap': 'Gap',
        'connection': 'Link',
        'decision': 'Decision'
    }

    template = templates.get(detection['detector'], templates['connection'])

    return template.format(
        icon=icons.get(detection['detector'], 'Info'),
        **detection
    )
```

## Query Response Patterns

### Contextual Question Answering

```python
class ContextualQA:
    """Answer questions using session context."""

    def __init__(self, session):
        self.session = session
        self.response_styles = {
            'brief': {'max_tokens': 100, 'include_sources': True},
            'detailed': {'max_tokens': 500, 'include_sources': True},
            'comprehensive': {'max_tokens': 1000, 'include_sources': True}
        }

    def answer(self, question, style='brief'):
        """Answer question from context."""

        # Search context
        results = self.search_context(question)

        if not results:
            return self.handle_no_results(question)

        # Generate answer
        answer = self.generate_answer(question, results, style)

        return answer

    def search_context(self, question):
        """Search session context for relevant information."""

        # Extract keywords and entities
        keywords = extract_keywords(question)
        entities = extract_entities(question)

        results = []

        # Search essential context
        essential_results = search_dict(
            self.session['context']['essential'],
            keywords
        )
        results.extend([(r, 'essential') for r in essential_results])

        # Search recent work
        if 'recent' in self.session['context']:
            recent_results = search_dict(
                self.session['context']['recent'],
                keywords
            )
            results.extend([(r, 'recent') for r in recent_results])

        # Search loaded notes
        if 'loaded_notes' in self.session['context']:
            for note_id, note in self.session['context']['loaded_notes'].items():
                if matches_keywords(note.content, keywords):
                    results.append((note, 'loaded'))

        # Score and sort results
        scored_results = []
        for result, source in results:
            score = calculate_relevance_score(question, result)
            scored_results.append({
                'content': result,
                'source': source,
                'score': score
            })

        scored_results.sort(key=lambda r: r['score'], reverse=True)

        return scored_results[:10]

    def generate_answer(self, question, results, style='brief'):
        """Generate answer from search results."""

        style_config = self.response_styles[style]

        # Format source citations
        sources = []
        for i, result in enumerate(results[:3]):
            source_id = extract_source_id(result['content'])
            sources.append({
                'id': source_id,
                'relevance': result['score'],
                'excerpt': extract_relevant_excerpt(
                    result['content'],
                    question,
                    max_length=200
                )
            })

        # Build answer
        answer = {
            'question': question,
            'answer': synthesize_answer(question, sources),
            'confidence': calculate_answer_confidence(results),
            'sources': sources,
            'style': style
        }

        return answer

    def handle_no_results(self, question):
        """Handle case when no results found."""

        # Suggest alternatives
        suggestions = []

        # Suggest broader search
        broader_terms = extract_broader_terms(question)
        if broader_terms:
            suggestions.append({
                'type': 'broader_search',
                'action': f'/copilot search "{broader_terms}"',
                'description': 'Try a broader search'
            })

        # Suggest context expansion
        suggestions.append({
            'type': 'expand_context',
            'action': '/copilot expand',
            'description': 'Load additional context'
        })

        # Suggest research
        suggestions.append({
            'type': 'research',
            'action': f'/kaaos:research "{question}"',
            'description': 'Start a research task'
        })

        return {
            'question': question,
            'answer': None,
            'message': 'No relevant information found in current context.',
            'suggestions': suggestions
        }
```

### Response Formatting

```python
def format_qa_response(answer):
    """Format QA response for display."""

    if answer['answer'] is None:
        # No results found
        output = f"""No results found for: "{answer['question']}"

Suggestions:
"""
        for suggestion in answer['suggestions']:
            output += f"  - {suggestion['description']}: {suggestion['action']}\n"

        return output

    # Found results
    confidence_indicator = get_confidence_indicator(answer['confidence'])

    output = f"""{confidence_indicator} Answer ({answer['style']}):

{answer['answer']}

Sources:
"""

    for i, source in enumerate(answer['sources'], 1):
        output += f"""
  [{i}] [[{source['id']}]]
      Relevance: {source['relevance']:.0%}
      "{source['excerpt'][:100]}..."
"""

    return output


def get_confidence_indicator(confidence):
    """Get confidence indicator for answer."""

    if confidence >= 0.9:
        return "High Confidence"
    elif confidence >= 0.7:
        return "Good Confidence"
    elif confidence >= 0.5:
        return "Moderate Confidence"
    else:
        return "Low Confidence"
```

## Context-Aware Suggestions

### Suggestion Engine

```python
class ContextAwareSuggestionEngine:
    """Generate context-aware suggestions during work."""

    def __init__(self, session):
        self.session = session
        self.suggestion_types = [
            CrossReferenceSuggester(session),
            PatternSuggester(session),
            DecisionSuggester(session),
            PlaybookSuggester(session),
            GapSuggester(session)
        ]

    def generate_suggestions(self, current_work):
        """Generate suggestions based on current work."""

        all_suggestions = []

        for suggester in self.suggestion_types:
            suggestions = suggester.generate(current_work)
            all_suggestions.extend(suggestions)

        # Deduplicate and rank
        unique_suggestions = deduplicate_suggestions(all_suggestions)
        ranked = rank_suggestions(unique_suggestions, current_work)

        return ranked[:5]  # Top 5 suggestions


class CrossReferenceSuggester:
    """Suggest cross-references to existing notes."""

    def __init__(self, session):
        self.session = session

    def generate(self, current_work):
        """Generate cross-reference suggestions."""

        suggestions = []

        # Extract entities from current work
        entities = extract_entities(current_work.content)

        # Find notes about these entities
        for entity in entities:
            related_notes = find_notes_about_entity(
                self.session['organization'],
                self.session.get('project'),
                entity
            )

            # Filter out already-referenced notes
            current_refs = extract_references(current_work.content)
            new_refs = [n for n in related_notes if n.id not in current_refs]

            if new_refs:
                suggestions.append({
                    'type': 'cross_reference',
                    'entity': entity,
                    'notes': new_refs[:3],
                    'confidence': calculate_entity_match_confidence(entity, new_refs),
                    'message': f'Consider linking to notes about "{entity}"'
                })

        return suggestions


class PlaybookSuggester:
    """Suggest relevant playbooks for current work."""

    def __init__(self, session):
        self.session = session
        self.playbooks = self.session['context']['essential'].get('active_playbooks', [])

    def generate(self, current_work):
        """Suggest applicable playbooks."""

        suggestions = []

        for playbook in self.playbooks:
            # Check if playbook applies to current work
            applicability = check_playbook_applicability(
                playbook,
                current_work.content
            )

            if applicability['applies'] and applicability['confidence'] > 0.7:
                suggestions.append({
                    'type': 'playbook',
                    'playbook': playbook,
                    'confidence': applicability['confidence'],
                    'trigger': applicability['trigger'],
                    'message': f'Playbook applicable: {playbook["title"]}'
                })

        return suggestions
```

## Session Memory Management

### Working Memory

```python
class SessionWorkingMemory:
    """Manage co-pilot's working memory during session."""

    def __init__(self, max_items=100):
        self.max_items = max_items
        self.memory = {
            'questions_asked': [],
            'searches_performed': [],
            'notes_accessed': [],
            'decisions_discussed': [],
            'suggestions_made': [],
            'user_preferences': {}
        }

    def record_question(self, question, answer):
        """Record a question and its answer."""

        self.memory['questions_asked'].append({
            'question': question,
            'answer': answer,
            'timestamp': datetime.now(),
            'satisfied': None  # User feedback
        })

        self._trim_memory('questions_asked')

    def record_search(self, query, results):
        """Record a search and its results."""

        self.memory['searches_performed'].append({
            'query': query,
            'result_count': len(results),
            'top_results': [r['id'] for r in results[:5]],
            'timestamp': datetime.now()
        })

        self._trim_memory('searches_performed')

    def record_note_access(self, note_id, access_type):
        """Record note access."""

        self.memory['notes_accessed'].append({
            'note_id': note_id,
            'access_type': access_type,  # 'read', 'edit', 'reference'
            'timestamp': datetime.now()
        })

        self._trim_memory('notes_accessed')

    def learn_preference(self, preference_type, value):
        """Learn user preference from interaction."""

        self.memory['user_preferences'][preference_type] = {
            'value': value,
            'learned_at': datetime.now()
        }

    def get_recent_context(self, minutes=30):
        """Get recent context for response generation."""

        cutoff = datetime.now() - timedelta(minutes=minutes)

        recent = {
            'questions': [
                q for q in self.memory['questions_asked']
                if q['timestamp'] > cutoff
            ],
            'searches': [
                s for s in self.memory['searches_performed']
                if s['timestamp'] > cutoff
            ],
            'notes': [
                n for n in self.memory['notes_accessed']
                if n['timestamp'] > cutoff
            ]
        }

        return recent

    def get_frequently_accessed_notes(self, min_count=3):
        """Get frequently accessed notes in session."""

        note_counts = Counter(
            n['note_id'] for n in self.memory['notes_accessed']
        )

        return [
            note_id for note_id, count in note_counts.most_common()
            if count >= min_count
        ]

    def _trim_memory(self, memory_type):
        """Trim memory to max size."""

        if len(self.memory[memory_type]) > self.max_items:
            # Keep most recent
            self.memory[memory_type] = self.memory[memory_type][-self.max_items:]
```

### Session State Persistence

```yaml
# Session state format for co-pilot memory
# File: ~/.kaaos-knowledge/.kaaos/sessions/{session_id}/copilot-state.yaml

copilot_state:
  mode: balanced
  suggestion_threshold: 0.8

  working_memory:
    questions_asked:
      - question: "What was our decision on error handling?"
        answer: "Use try-catch with state updates pattern"
        timestamp: 2026-01-15T14:30:00Z
        source: decisions/error-handling.md
      - question: "How do we handle concurrent agent spawning?"
        answer: "Use state database to track running agents"
        timestamp: 2026-01-15T15:00:00Z
        source: decisions/concurrency-control.md

    frequently_accessed:
      - note_id: "2026-01-050"
        access_count: 5
        last_accessed: 2026-01-15T15:30:00Z
      - note_id: "PLAY-agent-patterns"
        access_count: 3
        last_accessed: 2026-01-15T15:15:00Z

    user_preferences:
      response_style: brief
      proactive_suggestions: true
      auto_expand: false

  statistics:
    questions_answered: 8
    suggestions_made: 12
    suggestions_accepted: 7
    context_expansions: 2
```

## Multi-Turn Conversation Patterns

### Conversation Flow Management

```python
class ConversationFlowManager:
    """Manage multi-turn conversations with context."""

    def __init__(self, session, working_memory):
        self.session = session
        self.memory = working_memory
        self.conversation_state = {
            'current_topic': None,
            'topic_depth': 0,
            'follow_up_expected': False,
            'clarification_needed': False
        }

    def process_turn(self, user_input):
        """Process a conversation turn."""

        # Detect intent
        intent = self.detect_intent(user_input)

        # Check for topic continuity
        if self.is_follow_up(user_input):
            return self.handle_follow_up(user_input, intent)

        # New topic
        self.conversation_state['current_topic'] = intent['topic']
        self.conversation_state['topic_depth'] = 0

        return self.handle_new_topic(user_input, intent)

    def detect_intent(self, user_input):
        """Detect user intent from input."""

        intents = {
            'question': ['what', 'how', 'why', 'when', 'where', 'who', '?'],
            'search': ['find', 'search', 'look for', 'locate'],
            'navigate': ['show', 'open', 'go to', 'take me'],
            'create': ['create', 'make', 'new', 'add'],
            'relate': ['relate', 'link', 'connect', 'similar'],
            'summarize': ['summarize', 'summary', 'overview']
        }

        user_lower = user_input.lower()

        for intent_type, keywords in intents.items():
            if any(kw in user_lower for kw in keywords):
                return {
                    'type': intent_type,
                    'topic': extract_topic(user_input),
                    'confidence': 0.8
                }

        return {
            'type': 'general',
            'topic': extract_topic(user_input),
            'confidence': 0.5
        }

    def is_follow_up(self, user_input):
        """Check if input is follow-up to previous turn."""

        follow_up_indicators = [
            'also', 'and', 'more', 'another', 'what about',
            'similarly', 'in addition', 'related'
        ]

        # Check for pronouns referring to previous context
        pronoun_refs = ['it', 'that', 'this', 'those', 'these', 'they']

        user_lower = user_input.lower()

        if any(ind in user_lower for ind in follow_up_indicators):
            return True

        # Check if using pronouns without explicit referent
        if any(user_lower.startswith(pron) for pron in pronoun_refs):
            return True

        return False

    def handle_follow_up(self, user_input, intent):
        """Handle follow-up in conversation."""

        self.conversation_state['topic_depth'] += 1

        # Get recent context
        recent = self.memory.get_recent_context(minutes=10)

        # Build follow-up context
        context = {
            'previous_questions': recent['questions'],
            'current_topic': self.conversation_state['current_topic'],
            'depth': self.conversation_state['topic_depth']
        }

        # Generate response with context
        response = self.generate_contextual_response(user_input, intent, context)

        return response
```

## Error Recovery and Clarification

### Clarification Patterns

```python
class ClarificationHandler:
    """Handle ambiguous requests and errors."""

    def __init__(self, session):
        self.session = session

    def handle_ambiguous_request(self, request, interpretations):
        """Handle request with multiple interpretations."""

        if len(interpretations) == 1:
            return interpretations[0]

        # Present options to user
        clarification = {
            'type': 'clarification_needed',
            'message': f'I found multiple interpretations for "{request}"',
            'options': []
        }

        for i, interp in enumerate(interpretations[:4], 1):
            clarification['options'].append({
                'number': i,
                'interpretation': interp['description'],
                'action': interp['action']
            })

        clarification['prompt'] = 'Please specify (1-{}) or rephrase your request'.format(
            len(clarification['options'])
        )

        return clarification

    def handle_no_match(self, request):
        """Handle request with no matching context."""

        # Suggest similar items
        similar = find_similar_in_context(
            request,
            self.session['context'],
            threshold=0.4
        )

        response = {
            'type': 'no_exact_match',
            'message': f'Could not find exact match for "{request}"'
        }

        if similar:
            response['similar'] = similar[:5]
            response['prompt'] = 'Did you mean one of these?'
        else:
            response['suggestions'] = [
                'Try broader search terms',
                'Load additional context with /copilot expand',
                'Check if the note exists with a different name'
            ]

        return response

    def handle_error(self, error, request):
        """Handle errors gracefully."""

        error_handlers = {
            'NoteNotFoundError': self.handle_missing_note,
            'ContextOverflowError': self.handle_context_overflow,
            'SearchTimeoutError': self.handle_search_timeout,
            'BudgetExceededError': self.handle_budget_exceeded
        }

        handler = error_handlers.get(
            type(error).__name__,
            self.handle_generic_error
        )

        return handler(error, request)

    def handle_context_overflow(self, error, request):
        """Handle context overflow error."""

        return {
            'type': 'error',
            'error': 'context_overflow',
            'message': 'Session context is too large',
            'suggestions': [
                {
                    'action': '/copilot compact',
                    'description': 'Compress loaded context'
                },
                {
                    'action': '/copilot unload [note_id]',
                    'description': 'Unload specific notes'
                },
                {
                    'action': '/kaaos:session end',
                    'description': 'End session and start fresh'
                }
            ],
            'current_budget': error.budget_used,
            'budget_limit': error.budget_limit
        }
```

## Integration with KAAOS Agents

### Agent Coordination

```python
class AgentCoordinator:
    """Coordinate co-pilot with other KAAOS agents."""

    def __init__(self, session):
        self.session = session
        self.active_agents = {}

    def spawn_research_agent(self, topic):
        """Spawn research agent from co-pilot."""

        # Check if already researching this topic
        if self.is_researching(topic):
            return {
                'status': 'already_running',
                'message': f'Research on "{topic}" already in progress',
                'agent_id': self.active_agents[topic]['id']
            }

        # Spawn research agent
        agent = spawn_agent(
            agent_type='research',
            model='sonnet',
            context={
                'topic': topic,
                'session_context': serialize_session_context(
                    self.session['context']
                ),
                'output_path': f"{self.session['organization']}/context-library/research/"
            }
        )

        self.active_agents[topic] = {
            'id': agent['id'],
            'type': 'research',
            'started': datetime.now()
        }

        return {
            'status': 'spawned',
            'message': f'Research agent spawned for "{topic}"',
            'agent_id': agent['id'],
            'estimated_duration': '5-15 minutes'
        }

    def check_agent_status(self, agent_id):
        """Check status of spawned agent."""

        status = get_agent_status(agent_id)

        if status['state'] == 'completed':
            # Agent completed, retrieve results
            results = get_agent_results(agent_id)

            return {
                'status': 'completed',
                'agent_id': agent_id,
                'results': results,
                'created_notes': results.get('notes_created', [])
            }

        return status

    def handoff_to_orchestrator(self, task):
        """Hand off complex task to orchestrator."""

        return {
            'type': 'handoff',
            'message': 'This task requires orchestrator coordination',
            'task': task,
            'suggested_command': f'/kaaos:research "{task["topic"]}"'
        }
```

### Response Formatting for Agents

```python
def format_agent_response(agent_result):
    """Format agent result for co-pilot display."""

    if agent_result['type'] == 'research':
        return f"""
Research Complete: {agent_result['topic']}

Summary: {agent_result['summary']}

Created Notes:
{format_note_list(agent_result['created_notes'])}

Key Findings:
{format_findings(agent_result['findings'])}

View full research: [[{agent_result['research_note_id']}]]
"""

    elif agent_result['type'] == 'maintenance':
        return f"""
Maintenance Complete

Actions Taken:
{format_action_list(agent_result['actions'])}

Issues Fixed: {agent_result['issues_fixed']}
Warnings: {agent_result['warnings']}
"""
```

## Best Practices

1. **Match Mode to Session**: Use reactive for focus, proactive for learning
2. **Respect Cooldowns**: Don't overwhelm with suggestions
3. **Cite Sources**: Always include sources for answers
4. **Learn Preferences**: Adapt to user's working style
5. **Preserve Context**: Maintain conversation continuity
6. **Coordinate Agents**: Integrate smoothly with KAAOS agents
7. **Handle Errors Gracefully**: Provide actionable recovery options
8. **Monitor Token Usage**: Track budget consumption

## Common Pitfalls

- **Over-Suggesting**: Too many proactive suggestions disrupt flow
- **Ignoring Mode**: Using proactive patterns in reactive mode
- **Lost Context**: Not preserving conversation context across turns
- **Vague Answers**: Providing answers without citations
- **No Recovery Path**: Failing without actionable suggestions
- **Agent Conflicts**: Spawning duplicate agents for same task
- **Memory Bloat**: Not trimming working memory
- **Budget Ignorance**: Ignoring token budget constraints
