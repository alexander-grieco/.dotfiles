# Research Session Template

Investigation and learning session template for exploring new topics, conducting research, and building knowledge.

## Session Overview

| Attribute | Value |
|-----------|-------|
| **Purpose** | Investigation, learning, and knowledge building |
| **Duration** | 1-3 hours typical |
| **Co-Pilot** | Optional (helpful for complex research) |
| **Context Level** | Variable based on research topic |
| **Cost Estimate** | $0.30-1.70 depending on agent spawning |

### When to Use Research Sessions

- Investigating unfamiliar topics
- Exploring technical options
- Conducting competitive analysis
- Learning new technologies or methodologies
- Building foundational knowledge
- Deep-diving into specific questions
- Preparing for major decisions

### When NOT to Use Research Sessions

- Working on known deliverables (use Focus)
- Cross-project alignment (use Strategic)
- Quick information lookups (use Co-pilot)
- Pre-meeting preparation (use Meeting Prep)

## Pre-Session Checklist

### Environment Preparation

```markdown
- [ ] Research question or topic clearly defined
- [ ] Sources or starting points identified
- [ ] Note-taking structure prepared
- [ ] Time allocated without interruptions
- [ ] Reference materials accessible
```

### Context Requirements

```markdown
- [ ] Existing knowledge on topic reviewed
- [ ] Related notes in context library checked
- [ ] Previous research on topic found (if any)
- [ ] Output format determined (atomic notes, synthesis, etc.)
- [ ] Budget for potential agent spawning verified
```

### Budget Verification

```bash
# Check current budget status
/kaaos:status --budget
```

Expected output:
```
Budget Status:
  Daily:   $1.50 / $5.00 (70% remaining)

Estimated research session costs:
  Basic research (2h): $0.30-0.60
  With research agent: $0.60-1.20
  Deep research + co-pilot: $0.90-1.70

Note: Research agents (if spawned) add ~$0.30-0.50
```

## Initialization

### Basic Research Session

```bash
# Start research session
/kaaos:session [organization]/[project] --research "[topic]"

# Example
/kaaos:session personal/product-launch --research "OAuth 2.0 best practices"
```

### Research with Agent Spawning

```bash
# Start research session with dedicated research agent
/kaaos:session [organization]/[project] --research "[topic]" --spawn-agent

# Example
/kaaos:session personal/infrastructure --research "GraphQL vs REST" --spawn-agent
```

### Advanced Options

```bash
# Full options
/kaaos:session [organization]/[project] \
  --research "[topic]" \
  --spawn-agent \
  --depth comprehensive \
  --output atomic-notes \
  --time-limit 120
```

### Initialization Output

```
============================================================
KAAOS Research Session Initialized
============================================================

Session ID: 2026-01-15-research-oauth-best-practices-001
Organization: personal
Project: product-launch
Type: research
Topic: "OAuth 2.0 best practices"

Existing Context:
  [check] Related notes found: 3
    - [[2026-01-045|Authentication Overview]]
    - [[2025-12-100|Security Patterns]]
    - [[PLAY-auth-implementation]]
  [check] No previous research on exact topic

Research Configuration:
  [check] Depth: standard
  [check] Output format: atomic-notes
  [check] Agent: manual (not spawned)

Research Structure:
  [arrow] Start: Define research questions
  [arrow] Explore: Investigate sources
  [arrow] Extract: Capture key insights
  [arrow] Synthesize: Create notes
  [arrow] Link: Connect to context library

============================================================
Research ready. Topic: OAuth 2.0 best practices
============================================================
```

## Session Workflow

### Phase 1: Research Scoping (10-15 minutes)

**Objective**: Define clear research questions and boundaries

```python
def research_scoping(session, topic):
    """Scope the research effort."""

    print("=== Research Scoping ===\n")

    print(f"Topic: {topic}\n")

    # Check existing knowledge
    existing = search_context_library(
        session['organization'],
        session.get('project'),
        topic
    )

    if existing:
        print("Existing Knowledge:")
        for note in existing[:5]:
            print(f"  - [[{note.id}|{note.title}]]")
            print(f"    Summary: {note.summary[:100]}...")
        print(f"\nGap Analysis: What do we NOT know?")
    else:
        print("No existing knowledge found on this topic.")
        print("Starting from scratch.\n")

    # Define research questions
    print("\nDefine Research Questions:")
    print("  1. Primary question (must answer)")
    print("  2. Secondary questions (nice to answer)")
    print("  3. Out of scope (explicitly exclude)")

    # Set research boundaries
    boundaries = {
        'time_budget': session.get('time_limit', 120),  # minutes
        'depth': session.get('depth', 'standard'),
        'output_count': estimate_output_notes(session['depth'])
    }

    print(f"\nResearch Boundaries:")
    print(f"  Time budget: {boundaries['time_budget']} minutes")
    print(f"  Depth: {boundaries['depth']}")
    print(f"  Expected outputs: {boundaries['output_count']} notes")

    return boundaries


def estimate_output_notes(depth):
    """Estimate number of output notes by depth."""

    estimates = {
        'quick': '1-2 atomic notes',
        'standard': '3-5 atomic notes + 1 synthesis',
        'comprehensive': '5-10 atomic notes + synthesis + patterns'
    }

    return estimates.get(depth, estimates['standard'])
```

**Research Question Template**:
```yaml
# Research scoping document
topic: "OAuth 2.0 best practices"

primary_question: |
  What are the current best practices for implementing OAuth 2.0
  in a B2B SaaS application with multi-tenant architecture?

secondary_questions:
  - "What are the security considerations for token storage?"
  - "How should we handle token refresh in SPAs?"
  - "What are common OAuth 2.0 anti-patterns to avoid?"

out_of_scope:
  - "Detailed comparison of OAuth providers"
  - "Implementation in specific frameworks"
  - "Legacy OAuth 1.0 patterns"

success_criteria:
  - "Can answer primary question with confidence"
  - "Have documented patterns we can apply"
  - "Know what to avoid"

sources_to_explore:
  - "OAuth 2.0 RFCs"
  - "OWASP OAuth cheat sheet"
  - "Major provider documentation"
```

**Scoping Checklist**:
```markdown
- [ ] Primary research question defined
- [ ] Secondary questions listed
- [ ] Out of scope explicitly stated
- [ ] Success criteria established
- [ ] Sources to explore identified
- [ ] Time budget set
```

### Phase 2: Investigation (50-60% of session)

**Objective**: Gather information and extract insights

#### Investigation Pattern

```python
def investigation_phase(session, research_questions):
    """Conduct research investigation."""

    print("=== Investigation Phase ===\n")

    insights = []
    sources_explored = []

    for question in research_questions:
        print(f"\nInvestigating: {question['text']}")
        print("-" * 50)

        # Search existing context first
        context_results = search_context(
            session['context'],
            question['text']
        )

        if context_results:
            print(f"Found {len(context_results)} relevant context items")
            for result in context_results[:3]:
                print(f"  - [[{result['id']}]]: {result['summary'][:50]}...")

        # If using research agent
        if session.get('research_agent'):
            agent_findings = session['research_agent'].investigate(
                question['text'],
                depth=session['depth']
            )
            insights.extend(agent_findings['insights'])
            sources_explored.extend(agent_findings['sources'])

        # Manual investigation notes
        print(f"\nManual Investigation:")
        print(f"  [arrow] Explore sources")
        print(f"  [arrow] Extract key points")
        print(f"  [arrow] Note questions that arise")

    return {
        'insights': insights,
        'sources': sources_explored
    }


class ResearchAgent:
    """Dedicated research agent for deep investigation."""

    def __init__(self, session, topic):
        self.session = session
        self.topic = topic
        self.findings = []

    def investigate(self, question, depth='standard'):
        """Investigate a research question."""

        # Structure investigation
        investigation = {
            'question': question,
            'approach': self._determine_approach(question, depth),
            'insights': [],
            'sources': [],
            'follow_ups': []
        }

        # Execute investigation based on approach
        if investigation['approach'] == 'web_search':
            investigation = self._web_investigation(investigation)

        elif investigation['approach'] == 'context_deep_dive':
            investigation = self._context_investigation(investigation)

        elif investigation['approach'] == 'hybrid':
            investigation = self._hybrid_investigation(investigation)

        return investigation

    def _determine_approach(self, question, depth):
        """Determine best investigation approach."""

        # Check if we have substantial existing context
        context_coverage = estimate_context_coverage(
            self.session['context'],
            question
        )

        if context_coverage > 0.7:
            return 'context_deep_dive'
        elif context_coverage < 0.3:
            return 'web_search'
        else:
            return 'hybrid'
```

#### Insight Extraction

```python
def extract_insights(source_material, research_question):
    """Extract insights from source material."""

    insights = []

    # Pattern: Key finding
    key_findings = extract_key_findings(source_material)
    for finding in key_findings:
        insights.append({
            'type': 'finding',
            'content': finding['text'],
            'confidence': finding['confidence'],
            'source': finding['source'],
            'applicable_to': match_to_context(finding)
        })

    # Pattern: Best practice
    best_practices = extract_best_practices(source_material)
    for practice in best_practices:
        insights.append({
            'type': 'best_practice',
            'content': practice['text'],
            'rationale': practice['rationale'],
            'source': practice['source']
        })

    # Pattern: Anti-pattern
    anti_patterns = extract_anti_patterns(source_material)
    for anti in anti_patterns:
        insights.append({
            'type': 'anti_pattern',
            'content': anti['text'],
            'consequence': anti['consequence'],
            'source': anti['source']
        })

    # Pattern: Open question
    open_questions = extract_open_questions(source_material)
    for question in open_questions:
        insights.append({
            'type': 'open_question',
            'content': question['text'],
            'importance': question['importance']
        })

    return insights
```

**Investigation Checklist**:
```markdown
For each research question:
- [ ] Existing context searched
- [ ] External sources explored
- [ ] Key findings extracted
- [ ] Best practices identified
- [ ] Anti-patterns noted
- [ ] Follow-up questions recorded
- [ ] Sources documented
```

### Phase 3: Synthesis (25-30% of session)

**Objective**: Create structured notes from research

#### Creating Atomic Notes

```python
def create_research_notes(session, insights):
    """Create atomic notes from research insights."""

    print("=== Synthesis Phase ===\n")

    notes_created = []

    # Group insights by theme
    themes = group_by_theme(insights)

    for theme, theme_insights in themes.items():
        print(f"\nTheme: {theme}")

        # Create atomic note for theme
        note = create_atomic_note(
            session['organization'],
            session.get('project'),
            {
                'title': f"{session['topic']} - {theme}",
                'type': 'research',
                'content': synthesize_insights(theme_insights),
                'sources': extract_sources(theme_insights),
                'tags': ['research', session['topic'].lower().replace(' ', '-')]
            }
        )

        notes_created.append(note)
        print(f"  [check] Created: [[{note.id}|{note.title}]]")

        # Add cross-references
        related = find_related_notes(
            session['context'],
            note.content
        )

        if related:
            add_cross_references(note, related)
            print(f"  [check] Linked to {len(related)} related notes")

    return notes_created


def synthesize_insights(insights):
    """Synthesize multiple insights into coherent content."""

    content = []

    # Findings section
    findings = [i for i in insights if i['type'] == 'finding']
    if findings:
        content.append("## Key Findings\n")
        for f in findings:
            content.append(f"- **{f['content']}**")
            if f.get('source'):
                content.append(f"  - Source: {f['source']}")
            content.append("")

    # Best practices section
    practices = [i for i in insights if i['type'] == 'best_practice']
    if practices:
        content.append("## Best Practices\n")
        for p in practices:
            content.append(f"### {p['content'][:50]}...")
            content.append(f"\n{p['content']}")
            if p.get('rationale'):
                content.append(f"\n**Rationale**: {p['rationale']}")
            content.append("")

    # Anti-patterns section
    anti = [i for i in insights if i['type'] == 'anti_pattern']
    if anti:
        content.append("## Anti-Patterns to Avoid\n")
        for a in anti:
            content.append(f"- **{a['content']}**")
            if a.get('consequence'):
                content.append(f"  - Consequence: {a['consequence']}")
            content.append("")

    # Open questions section
    questions = [i for i in insights if i['type'] == 'open_question']
    if questions:
        content.append("## Open Questions\n")
        for q in questions:
            content.append(f"- {q['content']}")
        content.append("")

    return "\n".join(content)
```

#### Research Note Template

```yaml
# Research atomic note template
---
id: "2026-01-105"
type: atomic
category: research
title: "OAuth 2.0 - Token Storage Best Practices"
created: 2026-01-15
updated: 2026-01-15

research_session: "2026-01-15-research-oauth-best-practices-001"
topic: "OAuth 2.0 best practices"

tags:
  - research
  - oauth
  - security
  - authentication

sources:
  - "OAuth 2.0 RFC 6749"
  - "OWASP OAuth Cheat Sheet"
  - "Auth0 Documentation"

related:
  - "[[2026-01-045|Authentication Overview]]"
  - "[[PLAY-auth-implementation]]"
---

# OAuth 2.0 - Token Storage Best Practices

## Summary

Token storage is critical for OAuth 2.0 security. Access tokens should
be stored in memory where possible, refresh tokens require secure
storage with encryption at rest.

## Key Findings

- **Access tokens should be short-lived (15-60 minutes)**
  - Reduces window of exposure if compromised
  - Source: RFC 6749

- **Refresh tokens require secure storage**
  - Server-side: Encrypted database with token hashing
  - Client-side: HttpOnly cookies or secure storage APIs
  - Source: OWASP

## Best Practices

### Use Appropriate Storage by Context

For SPAs: Store access tokens in memory only, use refresh token
rotation with HttpOnly cookies.

**Rationale**: Memory storage prevents XSS access while refresh
tokens in cookies handle persistence securely.

### Implement Token Rotation

Rotate refresh tokens on each use. Invalidate token family on
reuse detection.

**Rationale**: Limits impact of token theft and enables detection
of compromised tokens.

## Anti-Patterns to Avoid

- **Storing tokens in localStorage**
  - Consequence: Vulnerable to XSS attacks

- **Long-lived access tokens**
  - Consequence: Extended exposure window if compromised

## Open Questions

- How to handle token refresh during offline periods?
- What's the optimal access token lifetime for our use case?

## Application to Our Project

This research applies to [[2026-01-045|Authentication Overview]].
Key actions:
1. Review current token storage implementation
2. Implement refresh token rotation
3. Reduce access token lifetime to 30 minutes
```

#### Creating Synthesis Note

```python
def create_synthesis_note(session, atomic_notes):
    """Create synthesis note linking all research outputs."""

    print("\nCreating Research Synthesis...")

    synthesis = {
        'title': f"Research Synthesis: {session['topic']}",
        'type': 'synthesis',
        'research_session': session['id'],
        'atomic_notes': [n.id for n in atomic_notes],
        'primary_question': session['research_questions']['primary'],
        'answer': synthesize_answer(atomic_notes, session['research_questions']),
        'key_takeaways': extract_takeaways(atomic_notes),
        'next_steps': generate_next_steps(atomic_notes, session)
    }

    note = create_note(
        session['organization'],
        session.get('project'),
        synthesis
    )

    print(f"[check] Created synthesis: [[{note.id}|{note.title}]]")

    return note
```

**Synthesis Checklist**:
```markdown
- [ ] Insights grouped by theme
- [ ] Atomic notes created for each theme
- [ ] Sources documented in notes
- [ ] Cross-references added
- [ ] Synthesis note linking all outputs
- [ ] Primary question answered
- [ ] Next steps identified
```

### Phase 4: Integration (10-15 minutes)

**Objective**: Connect research to context library

```python
def integrate_research(session, notes_created, synthesis_note):
    """Integrate research into context library."""

    print("=== Integration Phase ===\n")

    # Update relevant map notes
    map_notes = find_relevant_map_notes(
        session['organization'],
        session.get('project'),
        session['topic']
    )

    for map_note in map_notes:
        add_research_to_map(map_note, notes_created)
        print(f"[check] Updated map note: [[{map_note.id}]]")

    # Update project index if project-specific
    if session.get('project'):
        update_project_index(
            session['organization'],
            session['project'],
            notes_created
        )
        print(f"[check] Updated project index")

    # Create or update pattern if pattern discovered
    patterns = detect_patterns(notes_created)
    for pattern in patterns:
        pattern_note = create_or_update_pattern(
            session['organization'],
            pattern
        )
        print(f"[check] Pattern documented: [[{pattern_note.id}]]")

    # Link to relevant decisions
    decisions = find_related_decisions(
        session['organization'],
        session.get('project'),
        session['topic']
    )

    for decision in decisions:
        link_research_to_decision(decision, synthesis_note)
        print(f"[check] Linked to decision: [[{decision.id}]]")

    return {
        'maps_updated': len(map_notes),
        'patterns_created': len(patterns),
        'decisions_linked': len(decisions)
    }
```

**Integration Checklist**:
```markdown
- [ ] Relevant map notes updated
- [ ] Project index updated
- [ ] Patterns documented (if discovered)
- [ ] Linked to related decisions
- [ ] Organization index updated
- [ ] Tags consistent across notes
```

### Phase 5: Wrap-Up (5 minutes)

```python
def research_wrap_up(session):
    """Wrap up research session."""

    print("=== Research Session Wrap-Up ===\n")

    # Generate session summary
    summary = {
        'topic': session['topic'],
        'duration': calculate_duration(session),
        'primary_question_answered': session.get('primary_answered', False),
        'notes_created': len(session.get('notes_created', [])),
        'insights_captured': len(session.get('insights', [])),
        'sources_explored': len(session.get('sources', [])),
        'follow_up_questions': session.get('follow_up_questions', [])
    }

    print("Research Summary:")
    print(f"  Topic: {summary['topic']}")
    print(f"  Duration: {summary['duration']}")
    print(f"  Primary question answered: {'Yes' if summary['primary_question_answered'] else 'Partially'}")
    print(f"  Notes created: {summary['notes_created']}")
    print(f"  Insights captured: {summary['insights_captured']}")

    if summary['follow_up_questions']:
        print(f"\nFollow-up Research Needed:")
        for q in summary['follow_up_questions'][:3]:
            print(f"  - {q}")

    # Commit all changes
    git_commit_all(
        message=f"Research: {session['topic']}"
    )
    print(f"\n[check] All changes committed")

    # Save session state
    save_session_state(session)
    print(f"[check] Session saved: {session['id']}")

    return summary
```

## Session State Format

```yaml
# Research session state
session:
  id: "2026-01-15-research-oauth-best-practices-001"
  type: research
  organization: personal
  project: product-launch
  topic: "OAuth 2.0 best practices"

  lifecycle:
    created: "2026-01-15T14:00:00Z"
    started: "2026-01-15T14:05:00Z"
    ended: "2026-01-15T16:00:00Z"
    duration_minutes: 115

  research:
    primary_question: "What are OAuth 2.0 best practices for B2B SaaS?"
    primary_answered: true
    secondary_questions: 3
    secondary_answered: 2
    depth: standard

  findings:
    insights_captured: 15
    sources_explored: 8
    patterns_discovered: 2
    follow_up_questions: 3

  outputs:
    atomic_notes_created:
      - "2026-01-105"
      - "2026-01-106"
      - "2026-01-107"
    synthesis_note: "2026-01-108"
    patterns_documented:
      - "PATTERN-token-rotation"

  integration:
    maps_updated: 2
    decisions_linked: 1
    project_index_updated: true

  metrics:
    agent_spawned: false
    estimated_cost: 0.45
```

## Completion Checklist

```markdown
### Research Complete
- [ ] Primary question answered
- [ ] Key insights captured
- [ ] Sources documented
- [ ] Follow-up questions noted

### Notes Created
- [ ] Atomic notes for each theme
- [ ] Synthesis note linking outputs
- [ ] Patterns documented (if found)
- [ ] Cross-references added

### Integration Complete
- [ ] Map notes updated
- [ ] Project index updated
- [ ] Related decisions linked
- [ ] Tags consistent

### Session Closure
- [ ] All changes committed
- [ ] Session state saved
- [ ] Follow-up research planned (if needed)
```

## Commands Reference

```bash
# Start research session
/kaaos:session [org]/[project] --research "[topic]"
/kaaos:session [org]/[project] --research "[topic]" --spawn-agent
/kaaos:session [org]/[project] --research "[topic]" --depth comprehensive

# During session
/kaaos:research search "[query]"    # Search sources
/kaaos:research insight "[text]"    # Capture insight
/kaaos:research question "[text]"   # Record question

# End session
/kaaos:session end
```

## Best Practices

1. **Define Questions First**: Clear questions lead to focused research
2. **Check Existing Context**: Avoid duplicate research
3. **Document Sources**: Always record where insights came from
4. **Create Atomic Notes**: One concept per note
5. **Link Aggressively**: Connect to existing knowledge
6. **Capture Follow-ups**: Note what needs more research
7. **Time-Box**: Set clear time limits
8. **Integration Priority**: Linking is as important as creating

## Common Pitfalls

- **Vague Questions**: Starting without clear research questions
- **Duplicate Research**: Not checking existing context first
- **No Sources**: Capturing insights without attribution
- **Monolithic Notes**: Creating one large note instead of atomic
- **Isolated Research**: Not linking to context library
- **Scope Creep**: Expanding research beyond time budget
- **No Synthesis**: Capturing facts without synthesizing meaning
- **Skipping Integration**: Creating notes but not linking them
