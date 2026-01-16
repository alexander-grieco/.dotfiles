# Strategic Session Template

Cross-project thinking session template for connecting insights across multiple projects and making organization-level decisions.

## Session Overview

| Attribute | Value |
|-----------|-------|
| **Purpose** | Cross-project thinking and strategic alignment |
| **Duration** | 2-3 hours typical |
| **Co-Pilot** | Optional (proactive mode recommended if used) |
| **Context Level** | Organization-wide, all active projects |
| **Cost Estimate** | $0.50-1.50 depending on project count and co-pilot |

### When to Use Strategic Sessions

- Connecting patterns across multiple projects
- Making organization-level decisions
- Quarterly planning and review
- Resource allocation decisions
- Identifying cross-project dependencies
- Strategic initiative planning
- Aligning project priorities

### When NOT to Use Strategic Sessions

- Working on single project deliverables (use Focus)
- Quick decisions affecting one project only
- Deep technical investigation (use Research)
- Pre-meeting preparation (use Meeting Prep)

## Pre-Session Checklist

### Environment Preparation

```markdown
- [ ] Block 2-3 hours of uninterrupted time
- [ ] Have recent synthesis notes accessible
- [ ] Review weekly/monthly digest if available
- [ ] Prepare list of strategic questions to explore
- [ ] Clear mind for high-level thinking
```

### Context Requirements

```markdown
- [ ] Organization exists in KAAOS repository
- [ ] Multiple active projects to review
- [ ] Recent synthesis notes (within 14 days)
- [ ] Strategic questions or themes identified
- [ ] Budget sufficient for multi-project loading
```

### Budget Verification

```bash
# Check current budget status
/kaaos:status --budget
```

Expected output:
```
Budget Status:
  Daily:   $2.00 / $5.00 (60% remaining)
  Weekly:  $15.00 / $25.00 (40% remaining)

Estimated session cost:
  Strategic (2h): $0.50-1.00
  Strategic (2h) + Co-pilot: $0.80-1.50

Note: Strategic sessions load multiple project contexts.
      Cost scales with number of active projects.
```

## Initialization

### Basic Strategic Session

```bash
# Start strategic session for organization
/kaaos:session [organization] --strategic

# Example
/kaaos:session personal --strategic
```

### Strategic Session with Co-Pilot

```bash
# Start strategic session with proactive co-pilot
/kaaos:session [organization] --strategic --copilot --mode proactive

# Example
/kaaos:session personal --strategic --copilot
```

### Advanced Options

```bash
# Full options
/kaaos:session [organization] \
  --strategic \
  --copilot \
  --mode proactive \
  --projects "project-a,project-b,project-c" \
  --focus "Q1 planning alignment"
```

### Initialization Output

```
============================================================
KAAOS Strategic Session Initialized
============================================================

Session ID: 2026-01-15-strategic-personal-001
Organization: personal
Type: strategic

Organization Context Loaded:
  [check] Organization index: 4,500 chars
  [check] Active projects: 5
  [check] Recent org decisions: 8
  [check] Global playbooks: 6

Active Projects Loaded:
  [check] product-launch
       - Status: active
       - Recent notes: 12
       - Open decisions: 2
  [check] infrastructure
       - Status: active
       - Recent notes: 8
       - Open decisions: 1
  [check] research-initiative
       - Status: active
       - Recent notes: 15
       - Open decisions: 3
  [check] team-development
       - Status: maintenance
       - Recent notes: 3
       - Open decisions: 0
  [check] q1-planning
       - Status: planning
       - Recent notes: 6
       - Open decisions: 4

Synthesis Context:
  [check] Weekly synthesis: 2026-01-12
  [check] Monthly synthesis: 2025-12-31
  [check] Cross-project patterns: 7 identified

Co-pilot: Spawned (proactive mode)
  Available commands:
    /copilot cross-project   - Find cross-project connections
    /copilot conflicts       - Detect resource conflicts
    /copilot dependencies    - Map project dependencies
    /copilot opportunities   - Identify synergies

============================================================
Session ready. Strategic focus: [Your defined focus]
============================================================
```

## Session Workflow

### Phase 1: Strategic Landscape Review (15-20 minutes)

**Objective**: Build mental model of current state across all projects

```python
def strategic_landscape_review(session):
    """Review strategic landscape across all projects."""

    print("=== Strategic Landscape Review ===\n")

    # Project status overview
    print("Project Status Overview:")
    print("-" * 60)

    for project in session['context']['projects']:
        status = project['status']
        health = calculate_project_health(project)

        print(f"\n{project['name']} [{status}]")
        print(f"  Health: {health['indicator']} {health['score']:.0%}")
        print(f"  Recent activity: {project['recent_notes']} notes")
        print(f"  Open decisions: {len(project['open_decisions'])}")

        if project['open_decisions']:
            print("  Pending:")
            for decision in project['open_decisions'][:2]:
                print(f"    - {decision['summary']}")

    # Cross-project patterns
    print("\n" + "=" * 60)
    print("Cross-Project Patterns Detected:")
    for pattern in session['context']['synthesis']['patterns']:
        print(f"  - {pattern['description']}")
        print(f"    Affects: {', '.join(pattern['projects'])}")

    return session['context']


def calculate_project_health(project):
    """Calculate project health indicators."""

    indicators = {
        'activity': project['recent_notes'] > 5,
        'decisions': len(project['open_decisions']) < 5,
        'blockers': len(project.get('blockers', [])) == 0,
        'momentum': project.get('velocity', 0) > 0
    }

    score = sum(indicators.values()) / len(indicators)

    if score >= 0.75:
        indicator = "Good"
    elif score >= 0.5:
        indicator = "Moderate"
    else:
        indicator = "Needs Attention"

    return {'indicator': indicator, 'score': score, 'details': indicators}
```

**Review Checklist**:
```markdown
- [ ] All active projects reviewed
- [ ] Project health indicators noted
- [ ] Open decisions across projects identified
- [ ] Cross-project patterns recognized
- [ ] Resource conflicts identified
```

### Phase 2: Cross-Project Analysis (30-40% of session)

**Objective**: Identify connections, conflicts, and opportunities

#### Connection Discovery

```python
def cross_project_analysis(session):
    """Analyze connections across projects."""

    print("=== Cross-Project Analysis ===\n")

    projects = session['context']['projects']

    # Find shared themes
    themes = extract_shared_themes(projects)
    print("Shared Themes Across Projects:")
    for theme in themes:
        print(f"\n  Theme: {theme['name']}")
        print(f"  Projects: {', '.join(theme['projects'])}")
        print(f"  Strength: {theme['strength']:.0%}")

    # Find potential conflicts
    conflicts = detect_resource_conflicts(projects)
    if conflicts:
        print("\nPotential Resource Conflicts:")
        for conflict in conflicts:
            print(f"\n  Conflict: {conflict['description']}")
            print(f"  Projects: {' vs '.join(conflict['projects'])}")
            print(f"  Resource: {conflict['resource']}")
            print(f"  Severity: {conflict['severity']}")

    # Find synergies
    synergies = identify_synergies(projects)
    if synergies:
        print("\nPotential Synergies:")
        for synergy in synergies:
            print(f"\n  Synergy: {synergy['description']}")
            print(f"  Projects: {', '.join(synergy['projects'])}")
            print(f"  Benefit: {synergy['benefit']}")

    return {
        'themes': themes,
        'conflicts': conflicts,
        'synergies': synergies
    }
```

#### Dependency Mapping

```python
def map_dependencies(session):
    """Map dependencies between projects."""

    print("\nProject Dependencies:")
    print("-" * 60)

    dependencies = []

    for project in session['context']['projects']:
        # Extract dependencies from project context
        project_deps = extract_dependencies(project)

        for dep in project_deps:
            dependencies.append({
                'from': project['name'],
                'to': dep['target'],
                'type': dep['type'],
                'critical': dep.get('critical', False)
            })

    # Visualize dependencies
    print("\nDependency Graph:")
    for dep in dependencies:
        arrow = "==>" if dep['critical'] else "-->"
        print(f"  {dep['from']} {arrow} {dep['to']} ({dep['type']})")

    # Identify critical path
    critical_deps = [d for d in dependencies if d['critical']]
    if critical_deps:
        print("\nCritical Dependencies:")
        for dep in critical_deps:
            print(f"  ! {dep['from']} depends on {dep['to']}")

    return dependencies
```

#### Co-Pilot Strategic Commands

```markdown
## Co-Pilot Commands for Strategic Sessions

### Cross-Project Connections
User: /copilot cross-project "authentication"

Co-pilot: Cross-project connections for "authentication":

  product-launch:
    - [[2026-01-080|User Auth Flow]] - Implementation
    - [[2026-01-075|OAuth Integration]] - Decision

  infrastructure:
    - [[2026-01-065|Auth Service Architecture]] - Design
    - [[2026-01-070|Token Management]] - Pattern

  Shared decision needed:
    - Token expiration strategy (affects both projects)

### Resource Conflict Detection
User: /copilot conflicts

Co-pilot: Resource conflicts detected:

  1. Timeline Conflict (High Priority)
     - product-launch: Launch target 2026-02-15
     - infrastructure: Migration planned 2026-02-10
     - Risk: Infrastructure migration during launch prep

  2. Team Allocation
     - research-initiative: Needs senior engineer
     - product-launch: Same engineer assigned
     - Risk: Overallocation during Q1

### Opportunity Identification
User: /copilot opportunities

Co-pilot: Strategic opportunities identified:

  1. Shared Component
     - product-launch and infrastructure both need
       rate limiting implementation
     - Opportunity: Single implementation, shared

  2. Knowledge Transfer
     - research-initiative findings applicable to
       product-launch user experience
     - Opportunity: Schedule knowledge share
```

**Analysis Checklist**:
```markdown
- [ ] Shared themes identified
- [ ] Resource conflicts documented
- [ ] Dependencies mapped
- [ ] Synergies identified
- [ ] Critical blockers flagged
```

### Phase 3: Strategic Decision Making (30-40% of session)

**Objective**: Make organization-level decisions

#### Decision Framework

```python
def strategic_decision_session(session, decisions_to_make):
    """Facilitate strategic decision making."""

    print("=== Strategic Decision Making ===\n")

    for decision in decisions_to_make:
        print(f"\nDecision: {decision['topic']}")
        print("-" * 40)

        # Load relevant context
        context = gather_decision_context(
            session,
            decision['topic']
        )

        print(f"Relevant Context:")
        for item in context[:5]:
            print(f"  - [[{item['id']}|{item['title']}]]")

        # Present options
        print(f"\nOptions:")
        for i, option in enumerate(decision['options'], 1):
            print(f"  {i}. {option['description']}")
            print(f"     Pros: {', '.join(option['pros'][:2])}")
            print(f"     Cons: {', '.join(option['cons'][:2])}")

        # Cross-project impact
        impact = assess_cross_project_impact(
            session,
            decision['topic']
        )

        print(f"\nCross-Project Impact:")
        for project, effects in impact.items():
            print(f"  {project}: {effects['summary']}")

        # Document decision
        if decision.get('decided'):
            create_strategic_decision_note(
                session['organization'],
                decision
            )
            print(f"\n[check] Decision documented: [[{decision['note_id']}]]")


def assess_cross_project_impact(session, decision_topic):
    """Assess impact of decision across projects."""

    impact = {}

    for project in session['context']['projects']:
        # Check how decision affects this project
        relevance = calculate_relevance(
            decision_topic,
            project['context']
        )

        if relevance > 0.3:
            effects = predict_effects(
                decision_topic,
                project
            )
            impact[project['name']] = {
                'relevance': relevance,
                'summary': effects['summary'],
                'actions_needed': effects.get('actions', [])
            }

    return impact
```

#### Strategic Decision Note Template

```yaml
# Strategic decision note structure
type: decision
scope: organization
level: strategic

title: "Q1 Resource Allocation Strategy"
status: decided
decided_date: 2026-01-15

context:
  - "Multiple projects competing for limited resources"
  - "Q1 has ambitious delivery targets"
  - "New research initiative requires dedicated time"

options_considered:
  - option: "Parallel execution"
    pros: ["All projects advance", "No delays"]
    cons: ["Resource strain", "Quality risk"]
    assessment: "High risk of burnout"

  - option: "Sequential focus"
    pros: ["Quality maintained", "Deep work"]
    cons: ["Some projects delayed", "Stakeholder concerns"]
    assessment: "Lower risk, clearer priorities"

  - option: "Hybrid approach"
    pros: ["Balanced progress", "Flexibility"]
    cons: ["Complexity", "Context switching"]
    assessment: "Moderate risk, requires coordination"

decision: "Hybrid approach with clear priority tiers"

rationale: |
  Given Q1 targets and team capacity, a hybrid approach
  balances progress with sustainability. Priority tiers
  ensure critical path work is protected while maintaining
  momentum on secondary projects.

implementation:
  - action: "Define priority tiers for each project"
    owner: "[name]"
    deadline: 2026-01-20

  - action: "Communicate allocation to stakeholders"
    owner: "[name]"
    deadline: 2026-01-22

  - action: "Set up weekly cross-project sync"
    owner: "[name]"
    deadline: 2026-01-25

affected_projects:
  - project: product-launch
    impact: "Primary priority - full allocation"
  - project: infrastructure
    impact: "Secondary - 50% allocation"
  - project: research-initiative
    impact: "Tertiary - dedicated Friday focus"

review_date: 2026-02-15
```

**Decision Checklist**:
```markdown
- [ ] Decision context gathered
- [ ] Options evaluated
- [ ] Cross-project impact assessed
- [ ] Stakeholders considered
- [ ] Decision documented
- [ ] Implementation actions defined
- [ ] Review date set
```

### Phase 4: Alignment and Distribution (15-20 minutes)

**Objective**: Ensure decisions cascade to affected projects

```python
def alignment_distribution(session):
    """Distribute strategic decisions to projects."""

    print("=== Alignment Distribution ===\n")

    decisions = session.get('decisions_made', [])

    for decision in decisions:
        print(f"\nDistributing: {decision['title']}")

        # Update affected project indexes
        for project_impact in decision['affected_projects']:
            project = project_impact['project']

            # Add to project's decision log
            add_to_project_decisions(
                session['organization'],
                project,
                decision
            )

            # Create project-specific action items
            if project_impact.get('actions'):
                create_project_actions(
                    session['organization'],
                    project,
                    project_impact['actions']
                )

            print(f"  [check] Updated {project}")

    # Update organization index
    update_org_index_with_decisions(
        session['organization'],
        decisions
    )
    print(f"\n[check] Organization index updated")

    # Generate summary for stakeholders
    summary = generate_strategic_summary(session)
    save_strategic_summary(session, summary)
    print(f"[check] Strategic summary generated")

    return summary
```

**Alignment Checklist**:
```markdown
- [ ] Decisions linked to affected projects
- [ ] Project-specific actions created
- [ ] Organization index updated
- [ ] Cross-references established
- [ ] Strategic summary prepared
- [ ] Stakeholder communication planned
```

### Phase 5: Wrap-Up (10 minutes)

**Objective**: Close session and prepare for follow-up

```python
def strategic_wrap_up(session):
    """Wrap up strategic session."""

    print("=== Strategic Session Wrap-Up ===\n")

    # Session summary
    summary = {
        'duration': calculate_duration(session),
        'projects_reviewed': len(session['context']['projects']),
        'decisions_made': len(session.get('decisions_made', [])),
        'actions_created': sum(
            len(d.get('implementation', []))
            for d in session.get('decisions_made', [])
        ),
        'conflicts_identified': len(session.get('conflicts', [])),
        'synergies_found': len(session.get('synergies', []))
    }

    print("Session Summary:")
    print(f"  Duration: {summary['duration']}")
    print(f"  Projects reviewed: {summary['projects_reviewed']}")
    print(f"  Decisions made: {summary['decisions_made']}")
    print(f"  Actions created: {summary['actions_created']}")
    print(f"  Conflicts identified: {summary['conflicts_identified']}")
    print(f"  Synergies found: {summary['synergies_found']}")

    # Follow-up recommendations
    print("\nRecommended Follow-ups:")

    if session.get('conflicts'):
        print("  - Address resource conflicts before next sprint")

    if session.get('synergies'):
        print("  - Schedule cross-project collaboration sessions")

    pending_decisions = [
        d for d in session.get('decisions_to_make', [])
        if not d.get('decided')
    ]
    if pending_decisions:
        print(f"  - {len(pending_decisions)} decisions still pending")

    # Save and close
    save_session_state(session)
    print(f"\n[check] Session saved: {session['id']}")

    return summary
```

## Session State Format

```yaml
# Strategic session state
session:
  id: "2026-01-15-strategic-personal-001"
  type: strategic
  organization: personal

  lifecycle:
    created: "2026-01-15T10:00:00Z"
    started: "2026-01-15T10:05:00Z"
    ended: "2026-01-15T12:30:00Z"
    duration_minutes: 145

  context:
    org_index: true
    projects_loaded: 5
    synthesis_loaded: true
    total_tokens: 45000

  analysis:
    themes_identified:
      - name: "Authentication standardization"
        projects: ["product-launch", "infrastructure"]
        strength: 0.85
    conflicts_detected:
      - type: "timeline"
        projects: ["product-launch", "infrastructure"]
        severity: high
    synergies_found:
      - description: "Shared rate limiting"
        projects: ["product-launch", "infrastructure"]
        benefit: "Reduced duplication"

  decisions:
    - id: "STRATEGIC-2026-01-001"
      topic: "Q1 Resource Allocation"
      status: decided
      affected_projects: 3

  outputs:
    decision_notes_created: 2
    project_updates: 5
    actions_created: 8

  metrics:
    estimated_cost: 1.15
```

## Completion Checklist

```markdown
### Analysis Complete
- [ ] All active projects reviewed
- [ ] Cross-project patterns identified
- [ ] Resource conflicts documented
- [ ] Dependencies mapped
- [ ] Synergies identified

### Decisions Documented
- [ ] Strategic decisions recorded
- [ ] Cross-project impact assessed
- [ ] Implementation actions defined
- [ ] Review dates set

### Distribution Complete
- [ ] Decisions linked to projects
- [ ] Project indexes updated
- [ ] Organization index updated
- [ ] Strategic summary generated

### Session Closure
- [ ] All changes committed
- [ ] Session state saved
- [ ] Follow-up sessions planned
- [ ] Stakeholder communication scheduled
```

## Commands Reference

```bash
# Start strategic session
/kaaos:session [org] --strategic
/kaaos:session [org] --strategic --copilot

# During session
/copilot cross-project "[topic]"   # Find cross-project connections
/copilot conflicts                  # Detect resource conflicts
/copilot dependencies               # Map project dependencies
/copilot opportunities              # Identify synergies

# End session
/kaaos:session end
```

## Best Practices

1. **Regular Cadence**: Schedule strategic sessions weekly or bi-weekly
2. **Fresh Context**: Review recent synthesis before session
3. **Document Decisions**: Create formal decision notes
4. **Cascade Changes**: Distribute decisions to affected projects
5. **Track Conflicts**: Monitor resource conflicts over time
6. **Review Outcomes**: Follow up on previous strategic decisions
7. **Stakeholder Alignment**: Communicate decisions promptly
8. **Balanced Focus**: Don't neglect lower-priority projects entirely

## Common Pitfalls

- **Too Narrow Focus**: Only looking at one or two projects
- **Decision Paralysis**: Not making decisions due to complexity
- **No Distribution**: Making decisions but not cascading to projects
- **Ignoring Conflicts**: Not addressing resource tensions
- **Skipping Synthesis**: Not using recent synthesis for context
- **Over-Strategizing**: Strategic sessions without action items
- **No Follow-Up**: Not reviewing previous strategic decisions
