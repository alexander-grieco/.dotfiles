# Monthly Rhythm Patterns

Detailed patterns for monthly strategic reviews including multi-agent orchestration, system health analysis, and strategic alignment.

## Monthly Rhythm Structure

### Time Commitment
- **Agent Generation**: 15-25 minutes (2-3 parallel agents)
- **Human Review**: 2-3 hours (dedicated session)
- **Actions**: Strategic adjustments, system optimization

### Agent Suite (Opus)
- **Primary**: Synthesis Agent - Monthly pattern extraction
- **Secondary**: Gap Detector - Knowledge gap analysis
- **Tertiary**: Maintenance Agent - System health metrics
- **Cost**: ~$10-15 per run
- **Frequency**: 1st of each month at configured hour (default 5:00 AM)

## Multi-Agent Orchestration

### Parallel Execution Strategy

```python
def run_monthly_review(knowledge_base, month):
    """Orchestrate monthly review with parallel agents."""

    from concurrent.futures import ThreadPoolExecutor, as_completed

    # Initialize result container
    results = {}

    # Define agent tasks
    agent_tasks = {
        'synthesis': {
            'agent': 'synthesis-agent',
            'model': 'opus',
            'function': monthly_synthesis,
            'args': (knowledge_base, month),
            'estimated_cost': 5.00
        },
        'gaps': {
            'agent': 'gap-detector',
            'model': 'opus',
            'function': analyze_monthly_gaps,
            'args': (knowledge_base, month),
            'estimated_cost': 4.00
        },
        'health': {
            'agent': 'maintenance-agent',
            'model': 'sonnet',
            'function': system_health_check,
            'args': (knowledge_base,),
            'estimated_cost': 2.00
        }
    }

    # Verify total budget
    total_estimated = sum(t['estimated_cost'] for t in agent_tasks.values())
    if not check_budget_before_run('monthly', estimated=total_estimated):
        raise BudgetExceededError(f"Monthly review estimated at ${total_estimated}")

    # Execute agents in parallel
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = {
            executor.submit(
                task['function'],
                *task['args']
            ): name
            for name, task in agent_tasks.items()
        }

        for future in as_completed(futures):
            task_name = futures[future]
            try:
                results[task_name] = future.result()
                log_agent_completion(task_name, agent_tasks[task_name])
            except Exception as e:
                log_agent_error(task_name, e)
                results[task_name] = {'error': str(e)}

    # Combine and synthesize results
    monthly_review = synthesize_monthly_results(results, month)

    return monthly_review
```

### Agent Communication Protocol

```python
class AgentResult:
    """Standardized agent result format."""

    def __init__(self, agent_name, model, execution_time, cost):
        self.agent_name = agent_name
        self.model = model
        self.execution_time = execution_time
        self.cost = cost
        self.sections = []
        self.recommendations = []
        self.metrics = {}
        self.flags = []

    def add_section(self, title, content, priority='normal'):
        self.sections.append({
            'title': title,
            'content': content,
            'priority': priority
        })

    def add_recommendation(self, title, description, effort, value, priority):
        self.recommendations.append({
            'title': title,
            'description': description,
            'effort': effort,
            'value': value,
            'priority': priority
        })

    def add_metric(self, name, value, trend=None, target=None):
        self.metrics[name] = {
            'value': value,
            'trend': trend,
            'target': target
        }

    def flag(self, category, message, severity='warning'):
        self.flags.append({
            'category': category,
            'message': message,
            'severity': severity
        })
```

## Monthly Synthesis Agent

### Pattern Extraction Across 30 Days

```python
def monthly_synthesis(knowledge_base, month):
    """Synthesize patterns across the month."""

    result = AgentResult('synthesis-agent', 'opus', 0, 0)
    start_time = datetime.now()

    # Get all notes from the month
    month_start = month.replace(day=1)
    month_end = (month_start + timedelta(days=32)).replace(day=1) - timedelta(days=1)

    notes = get_notes_in_range(knowledge_base, month_start, month_end)
    conversations = get_conversations_in_range(knowledge_base, month_start, month_end)

    # Section 1: Strategic Progress
    objectives = analyze_objective_progress(knowledge_base, month)
    result.add_section(
        'Strategic Progress',
        format_objectives_progress(objectives),
        priority='high'
    )

    # Section 2: Monthly Patterns
    patterns = extract_monthly_patterns(notes, conversations)
    result.add_section(
        'Emerging Patterns',
        format_patterns(patterns),
        priority='high'
    )

    # Section 3: Decision Analysis
    decisions = extract_decisions(notes)
    decision_analysis = analyze_decision_quality(decisions)
    result.add_section(
        'Decision Analysis',
        format_decision_analysis(decisions, decision_analysis),
        priority='normal'
    )

    # Section 4: Playbook Performance
    playbook_usage = analyze_playbook_usage(notes, conversations)
    result.add_section(
        'Playbook Performance',
        format_playbook_analysis(playbook_usage),
        priority='normal'
    )

    # Section 5: Experiments
    experiments = find_experiments(knowledge_base, month)
    result.add_section(
        'Experiment Results',
        format_experiments(experiments),
        priority='normal'
    )

    # Generate recommendations
    for rec in generate_synthesis_recommendations(patterns, decisions, playbook_usage):
        result.add_recommendation(**rec)

    # Add metrics
    result.add_metric('notes_created', len([n for n in notes if n.created_this_month]))
    result.add_metric('notes_updated', len([n for n in notes if n.updated_this_month]))
    result.add_metric('decisions_made', len(decisions))
    result.add_metric('patterns_detected', len(patterns))
    result.add_metric('playbooks_applied', sum(p['usage_count'] for p in playbook_usage))

    result.execution_time = (datetime.now() - start_time).total_seconds()
    result.cost = calculate_agent_cost('opus', result.execution_time)

    return result
```

### Objective Progress Analysis

```python
def analyze_objective_progress(knowledge_base, month):
    """Analyze progress on monthly/quarterly objectives."""

    objectives = []

    # Find objective notes (OKRs, goals, targets)
    okr_notes = find_notes_by_pattern(knowledge_base, ['OKR-*', 'GOAL-*', 'Q*-objectives'])

    for note in okr_notes:
        # Check if objective is active this month
        if not is_objective_active(note, month):
            continue

        objective = {
            'id': note.id,
            'title': note.title,
            'key_results': [],
            'status': 'unknown',
            'progress_percent': 0
        }

        # Extract key results
        key_results = extract_key_results(note)
        for kr in key_results:
            # Find evidence of progress
            progress_notes = find_progress_evidence(knowledge_base, kr, month)

            kr_status = {
                'description': kr['description'],
                'target': kr['target'],
                'current': estimate_current_value(progress_notes, kr),
                'progress_percent': calculate_progress(kr, progress_notes),
                'evidence': [n.id for n in progress_notes[:3]]
            }
            objective['key_results'].append(kr_status)

        # Calculate overall objective progress
        if objective['key_results']:
            objective['progress_percent'] = sum(
                kr['progress_percent'] for kr in objective['key_results']
            ) / len(objective['key_results'])

        # Determine status
        if objective['progress_percent'] >= 90:
            objective['status'] = 'on_track'
        elif objective['progress_percent'] >= 70:
            objective['status'] = 'at_risk'
        else:
            objective['status'] = 'behind'

        objectives.append(objective)

    return objectives
```

## Gap Detection Agent

### Comprehensive Gap Analysis

```python
def analyze_monthly_gaps(knowledge_base, month):
    """Detect knowledge gaps across the month."""

    result = AgentResult('gap-detector', 'opus', 0, 0)
    start_time = datetime.now()

    # Section 1: Documentation Gaps
    doc_gaps = find_documentation_gaps(knowledge_base, month)
    result.add_section(
        'Documentation Gaps',
        format_documentation_gaps(doc_gaps),
        priority='high' if len(doc_gaps) > 5 else 'normal'
    )

    # Section 2: Process Gaps
    process_gaps = find_process_gaps(knowledge_base, month)
    result.add_section(
        'Process Gaps',
        format_process_gaps(process_gaps),
        priority='high' if len(process_gaps) > 3 else 'normal'
    )

    # Section 3: Knowledge Decay
    decay = analyze_knowledge_decay(knowledge_base)
    result.add_section(
        'Knowledge Decay',
        format_decay_analysis(decay),
        priority='normal'
    )

    # Section 4: Learning Opportunities
    opportunities = identify_learning_opportunities(knowledge_base, month)
    result.add_section(
        'Learning Opportunities',
        format_opportunities(opportunities),
        priority='normal'
    )

    # Generate recommendations
    for gap in doc_gaps:
        result.add_recommendation(
            title=f"Document: {gap['topic']}",
            description=gap['description'],
            effort=gap['estimated_hours'],
            value=gap['value_score'],
            priority=gap['priority']
        )

    for gap in process_gaps:
        result.add_recommendation(
            title=f"Create Playbook: {gap['process']}",
            description=gap['description'],
            effort=gap['estimated_hours'],
            value=gap['value_score'],
            priority=gap['priority']
        )

    # Add metrics
    result.add_metric('documentation_gaps', len(doc_gaps))
    result.add_metric('process_gaps', len(process_gaps))
    result.add_metric('stale_notes', len(decay['stale']))
    result.add_metric('learning_opportunities', len(opportunities))

    result.execution_time = (datetime.now() - start_time).total_seconds()
    result.cost = calculate_agent_cost('opus', result.execution_time)

    return result
```

### Documentation Gap Detection

```python
def find_documentation_gaps(knowledge_base, month):
    """Find topics mentioned but not documented."""

    gaps = []

    # Get all conversations and notes from month
    conversations = get_conversations_in_month(knowledge_base, month)
    notes = get_notes_in_month(knowledge_base, month)

    # Extract topics discussed in conversations
    discussed_topics = set()
    for conv in conversations:
        topics = extract_topics_from_conversation(conv)
        discussed_topics.update(topics)

    # Extract topics documented in notes
    documented_topics = set()
    for note in notes:
        topics = extract_topics_from_note(note)
        documented_topics.update(topics)

    # Find gaps (discussed but not documented)
    for topic in discussed_topics - documented_topics:
        # Count how often topic was discussed
        frequency = count_topic_mentions(conversations, topic)

        if frequency >= 2:  # Discussed multiple times
            gaps.append({
                'topic': topic,
                'frequency': frequency,
                'conversations': find_conversations_with_topic(conversations, topic),
                'description': f"'{topic}' discussed {frequency} times but not documented",
                'estimated_hours': estimate_documentation_effort(topic),
                'value_score': calculate_value_score(frequency, topic),
                'priority': 'high' if frequency >= 5 else 'medium'
            })

    # Sort by value score
    gaps.sort(key=lambda x: x['value_score'], reverse=True)

    return gaps[:10]  # Top 10 gaps
```

### Process Gap Detection

```python
def find_process_gaps(knowledge_base, month):
    """Find repeated processes without playbooks."""

    gaps = []

    # Analyze decision notes for repeated patterns
    decisions = find_decisions_in_month(knowledge_base, month)

    # Group decisions by type
    decision_types = defaultdict(list)
    for decision in decisions:
        decision_type = categorize_decision(decision)
        decision_types[decision_type].append(decision)

    # Check if playbook exists for each type
    for decision_type, type_decisions in decision_types.items():
        if len(type_decisions) >= 2:  # Pattern detected
            playbook = find_playbook_for_type(knowledge_base, decision_type)

            if not playbook:
                gaps.append({
                    'process': decision_type,
                    'frequency': len(type_decisions),
                    'decisions': [d.id for d in type_decisions],
                    'description': f"Made {len(type_decisions)} '{decision_type}' decisions without playbook",
                    'estimated_hours': 2 + len(type_decisions),  # More decisions = more content
                    'value_score': len(type_decisions) * 2,  # Future time saved
                    'priority': 'high' if len(type_decisions) >= 4 else 'medium'
                })

    # Analyze conversations for repeated workflows
    workflows = detect_repeated_workflows(knowledge_base, month)
    for workflow in workflows:
        playbook = find_playbook_for_workflow(knowledge_base, workflow['name'])

        if not playbook:
            gaps.append({
                'process': workflow['name'],
                'frequency': workflow['frequency'],
                'conversations': workflow['conversation_ids'],
                'description': f"'{workflow['name']}' workflow repeated {workflow['frequency']} times",
                'estimated_hours': workflow['complexity'] * 2,
                'value_score': workflow['frequency'] * workflow['complexity'],
                'priority': 'high' if workflow['frequency'] >= 3 else 'medium'
            })

    return gaps
```

## System Health Agent

### Comprehensive Health Metrics

```python
def system_health_check(knowledge_base):
    """Comprehensive system health analysis."""

    result = AgentResult('maintenance-agent', 'sonnet', 0, 0)
    start_time = datetime.now()

    # Section 1: Knowledge Base Statistics
    stats = calculate_kb_statistics(knowledge_base)
    result.add_section(
        'Knowledge Base Statistics',
        format_statistics(stats),
        priority='normal'
    )

    # Section 2: Link Health
    link_health = analyze_link_health(knowledge_base)
    result.add_section(
        'Link Health',
        format_link_health(link_health),
        priority='high' if link_health['broken_count'] > 10 else 'normal'
    )

    # Section 3: Agent Performance
    agent_perf = analyze_agent_performance(knowledge_base)
    result.add_section(
        'Agent Performance',
        format_agent_performance(agent_perf),
        priority='normal'
    )

    # Section 4: Cost Analysis
    costs = analyze_costs(knowledge_base)
    result.add_section(
        'Cost Analysis',
        format_cost_analysis(costs),
        priority='high' if costs['over_budget'] else 'normal'
    )

    # Section 5: System Optimization Opportunities
    optimizations = find_optimization_opportunities(knowledge_base)
    result.add_section(
        'Optimization Opportunities',
        format_optimizations(optimizations),
        priority='normal'
    )

    # Add metrics
    for metric_name, metric_value in stats.items():
        result.add_metric(metric_name, metric_value)

    result.add_metric('broken_links', link_health['broken_count'])
    result.add_metric('orphaned_notes', link_health['orphan_count'])
    result.add_metric('month_cost_usd', costs['month_total'])
    result.add_metric('cost_trend', costs['trend'])

    # Flag issues
    if link_health['broken_count'] > 10:
        result.flag('link_health', f"{link_health['broken_count']} broken links detected", 'warning')

    if costs['over_budget']:
        result.flag('budget', f"Over budget by ${costs['over_amount']:.2f}", 'error')

    result.execution_time = (datetime.now() - start_time).total_seconds()
    result.cost = calculate_agent_cost('sonnet', result.execution_time)

    return result
```

### Knowledge Base Statistics

```python
def calculate_kb_statistics(knowledge_base):
    """Calculate comprehensive knowledge base statistics."""

    stats = {}

    # Count notes by type
    all_notes = list(knowledge_base.path.rglob('*.md'))
    stats['total_notes'] = len(all_notes)

    note_types = defaultdict(int)
    for note_path in all_notes:
        note_type = detect_note_type_from_path(note_path)
        note_types[note_type] += 1

    stats['notes_by_type'] = dict(note_types)

    # Calculate link density
    total_links = 0
    for note_path in all_notes:
        content = note_path.read_text()
        links = extract_wikilinks(content)
        total_links += len(links)

    stats['total_links'] = total_links
    stats['avg_links_per_note'] = total_links / len(all_notes) if all_notes else 0

    # Calculate content volume
    total_words = 0
    for note_path in all_notes:
        content = note_path.read_text()
        total_words += len(content.split())

    stats['total_words'] = total_words
    stats['avg_words_per_note'] = total_words / len(all_notes) if all_notes else 0

    # Growth metrics
    this_month = get_notes_created_this_month(knowledge_base)
    last_month = get_notes_created_last_month(knowledge_base)

    stats['notes_created_this_month'] = len(this_month)
    stats['notes_created_last_month'] = len(last_month)
    stats['growth_rate'] = (
        (len(this_month) - len(last_month)) / len(last_month) * 100
        if last_month else 0
    )

    # Age distribution
    ages = []
    for note_path in all_notes:
        note = load_note(note_path)
        if note.created_date:
            age_days = (datetime.now() - note.created_date).days
            ages.append(age_days)

    if ages:
        stats['avg_note_age_days'] = sum(ages) / len(ages)
        stats['oldest_note_days'] = max(ages)
        stats['newest_note_days'] = min(ages)

    return stats
```

### Cost Analysis

```python
def analyze_costs(knowledge_base):
    """Analyze costs for the month."""

    costs = {
        'month_total': 0,
        'by_rhythm': {},
        'by_agent': {},
        'trend': 'stable',
        'over_budget': False,
        'over_amount': 0
    }

    # Load cost logs
    cost_log = load_cost_log(knowledge_base)
    config = load_config(knowledge_base)

    # Get this month's costs
    month_start = datetime.now().replace(day=1)
    month_costs = [
        entry for entry in cost_log
        if entry['timestamp'] >= month_start
    ]

    # Sum by rhythm type
    for entry in month_costs:
        costs['month_total'] += entry['cost_usd']

        rhythm = entry.get('rhythm', 'unknown')
        costs['by_rhythm'][rhythm] = costs['by_rhythm'].get(rhythm, 0) + entry['cost_usd']

        agent = entry.get('agent', 'unknown')
        costs['by_agent'][agent] = costs['by_agent'].get(agent, 0) + entry['cost_usd']

    # Compare to budget
    monthly_budget = config.get('cost_controls', {}).get('monthly_limit_usd', 100)
    if costs['month_total'] > monthly_budget:
        costs['over_budget'] = True
        costs['over_amount'] = costs['month_total'] - monthly_budget

    # Calculate trend
    last_month_costs = get_last_month_costs(cost_log)
    if last_month_costs > 0:
        change = (costs['month_total'] - last_month_costs) / last_month_costs * 100
        if change > 10:
            costs['trend'] = 'increasing'
        elif change < -10:
            costs['trend'] = 'decreasing'
        else:
            costs['trend'] = 'stable'

    # Project end of month
    days_in_month = (month_start.replace(month=month_start.month % 12 + 1, day=1) - timedelta(days=1)).day
    days_elapsed = datetime.now().day
    if days_elapsed > 0:
        costs['projected_total'] = costs['month_total'] / days_elapsed * days_in_month
    else:
        costs['projected_total'] = 0

    return costs
```

## Full Example Monthly Review

```markdown
# Monthly Review - January 2026

## Executive Summary

Strong month with clear pattern emergence in decision-making frameworks. Knowledge base grew 23% with high-quality additions. Two significant knowledge gaps identified requiring immediate attention. System health excellent; costs on track.

**Month Highlights**:
- 📝 45 notes created (↑12 from December)
- ✏️  67 notes updated
- ✅ 12 decisions documented
- 💡 89 insights extracted
- 📊 4 patterns emerged
- ⚠️  2 critical gaps identified

**Key Achievements**:
1. Decision-making playbook consolidation - saving 2-4 hours per major decision
2. Async communication standardization - saving 7+ hours/week team-wide
3. Frontend hiring process documentation - first systematic hire in 2026

**Areas Needing Attention**:
1. Hiring process still has gaps (work sample library incomplete)
2. Q4 2025 retrospective not yet archived
3. Cost trending 8% above last month

## Strategic Progress

### Q1 2026 Objectives

#### OKR-1: Product Launch (Target: March 31)
**Status**: On Track (33% complete)
**Progress**: Week 4 of 12

| Key Result | Target | Current | Progress |
|------------|--------|---------|----------|
| Feature completion | 100% | 35% | 35% |
| Beta users | 50 | 12 | 24% |
| NPS score | 40+ | N/A | Pending |

**Evidence**:
- [[2026-01-050|Sprint Cadence Decision]] - 2-week sprints implemented
- [[projects/product-launch/sprint-1-retro]] - First sprint completed
- [[projects/product-launch/sprint-2-plan]] - Sprint 2 planned

**Risks**:
- Feature scope may be too aggressive
- Beta user recruitment slower than expected

**Recommendation**: Review feature scope in Week 6, consider MVP reduction

#### OKR-2: Team Scaling (Target: Q1)
**Status**: At Risk (40% complete)

| Key Result | Target | Current | Progress |
|------------|--------|---------|----------|
| Frontend Lead hired | 1 | 0 | In progress |
| Onboarding time | <30 days | N/A | Not started |
| Team velocity | +20% | +5% | 25% |

**Evidence**:
- [[DEC-2026-003|Frontend Lead Hire]] - Approved, screening started
- [[2026-01-070|Interview Framework]] - Process documented
- [[2026-01-078|Interview Panel]] - Panel selected

**Risks**:
- Candidate quality lower than expected
- Onboarding documentation incomplete

**Recommendation**: Accelerate candidate sourcing, complete onboarding docs by hire date

#### OKR-3: Process Excellence (Target: Q1)
**Status**: On Track (55% complete)

| Key Result | Target | Current | Progress |
|------------|--------|---------|----------|
| Meeting time reduction | 30% | 40% | 133% |
| Playbooks created | 5 | 3 | 60% |
| Async adoption | 80% | 65% | 81% |

**Evidence**:
- [[PLAY-decision-making]] - Created and applied
- [[2026-01-075|Meeting Pre-Read Standard]] - Adopted
- [[2026-01-078|Async Standup Experiment]] - Successful

**Ahead of Target**: Meeting time reduction exceeding goal

## Emerging Patterns

### Pattern 1: Decision Framework Combination
**Frequency**: 8 applications in January
**Strength**: Strong (consistent outcomes)

Teams are naturally combining pre-mortem analysis with reversibility classification before major decisions. This wasn't prescribed but emerged from practice.

**Evidence**:
- [[2026-01-050|Sprint Cadence]] - Applied both frameworks
- [[DEC-2026-003|Frontend Lead]] - Pre-mortem identified onboarding risk
- [[2026-01-062|Marketing Test]] - Reversibility justified small bet
- [[2026-01-076|Budget Reallocation]] - Pre-mortem caught cash flow issue
- Plus 4 additional applications

**Outcome**: Average decision time reduced from 2+ hours to 30 minutes
**Action Taken**: Created [[PLAY-decision-making]] consolidating frameworks
**Next**: Monitor adoption across all teams

### Pattern 2: Async-First Communication
**Frequency**: 12 instances in January
**Strength**: Growing (positive results)

Multiple teams independently moving to async-first communication:
- Meeting pre-reads
- Async standups
- Decision documents

**Evidence**:
- Product team: 40% meeting time reduction
- Engineering team: 7.5 hours/week saved
- Leadership: 2 async decision cycles completed

**Success Factors**:
- Clear artifacts (pre-reads, docs, status updates)
- Response time expectations (24 hours)
- Sync reserved for true collaboration

**Failure Mode**: Brainstorming doesn't work async

**Action Taken**: Created [[PATT-async-communication]]
**Next**: Expand to all teams, create playbook

### Pattern 3: Knowledge Gap Rework
**Frequency**: 3 significant instances
**Strength**: Problem pattern (causing waste)

Same information being recreated multiple times due to poor documentation:
- Hiring work samples recreated 2x
- Interview rubrics recreated
- Compensation bands researched 3x

**Impact**: ~15 hours wasted in January

**Root Cause**: Infrequent processes not documented between uses

**Action Taken**: Prioritized hiring playbook completion
**Next**: Identify other infrequent but important processes

### Pattern 4: Project Index as Living Document
**Frequency**: 4 projects
**Strength**: Emerging (positive signal)

Project INDEX notes being updated weekly with:
- Status changes
- Key decision links
- Sprint references
- Risk tracking

**Evidence**:
- [[projects/product-launch/00-PROJECT-INDEX]] - 8 updates in Jan
- [[projects/q1-planning/00-PROJECT-INDEX]] - 5 updates
- [[projects/frontend-hiring/00-PROJECT-INDEX]] - 4 updates
- [[projects/marketing-experiments/00-PROJECT-INDEX]] - 3 updates

**Benefit**: Single source of truth for project status
**Action**: Standardize project index template

## Decision Analysis

### Decisions Made (12 total)

| ID | Decision | Type | Method | Outcome |
|----|----------|------|--------|---------|
| DEC-2026-001 | Market entry strategy | Strategic | Full analysis | Pending (90-day review due) |
| DEC-2026-002 | Q1 OKR finalization | Strategic | Team consensus | Implemented |
| DEC-2026-003 | Frontend lead hire | Resource | Pre-mortem + reversibility | In progress |
| DEC-2026-004 | Sprint cadence | Process | Experiment design | Implemented, positive early signal |
| DEC-2026-005 | Marketing channel test | Investment | Two-way door | Week 2 of 4 |
| ... | ... | ... | ... | ... |

### Decision Quality Metrics

**Framework Usage**: 75% (9/12 used documented framework)
**Documentation Quality**: High (all have context, rationale, outcomes)
**Review Scheduled**: 83% (10/12 have review dates)

**Best Practice Adoption**:
- Pre-mortem applied: 8/12 (67%)
- Reversibility classified: 7/12 (58%)
- Kill criteria defined: 4/5 experiments (80%)

**Recommendation**: Continue framework adoption, target 90% next month

## Knowledge Base Health

### Statistics

| Metric | Value | Change | Trend |
|--------|-------|--------|-------|
| Total notes | 312 | +45 | ↑ 17% |
| Total links | 1,847 | +312 | ↑ 20% |
| Avg links/note | 5.9 | +0.3 | ↑ 5% |
| Total words | 156,000 | +28,000 | ↑ 22% |
| Avg words/note | 500 | -8 | ↓ 2% |

### Link Health

| Metric | Count | Status |
|--------|-------|--------|
| Broken links | 7 | ⚠️ Needs attention |
| Orphaned notes | 12 | Normal |
| Deeply connected (>10 links) | 34 | Excellent |
| Index notes updated | 8/8 | ✅ All current |

**Broken Links Requiring Action**:
1. [[2026-01-055]] → [[COMP-bands]] (should be [[2026-01-085]])
2. [[projects/q4-review/context]] → [[Q4-retro]] (archived)
3. Plus 5 minor issues

### Growth Quality

**New Note Types**:
- Decisions: 12 (27%)
- Playbooks: 3 (7%)
- Patterns: 2 (4%)
- Project notes: 15 (33%)
- Atomic notes: 13 (29%)

**Quality Indicators**:
- Average cross-references per new note: 4.2 (good)
- Notes with frontmatter: 100% (excellent)
- Notes linked to map: 89% (good)

## Gap Analysis

### Critical Documentation Gaps

#### Gap 1: Hiring Work Sample Library
**Priority**: HIGH
**Impact**: 3+ hours per hire
**Frequency**: Recreated 2x this month

**Missing**:
- Work sample templates by role
- Evaluation rubrics
- Candidate response examples
- Scoring calibration guide

**Recommendation**: Complete before next hire (target: Jan 31)
**Effort**: 4-6 hours
**Owner**: Hiring manager + You

#### Gap 2: Onboarding Checklist
**Priority**: HIGH
**Impact**: New hire productivity
**Risk**: Frontend lead starts in ~30 days

**Missing**:
- Day 1-7 checklist
- Week 1-4 milestones
- Required reading list
- System access guide

**Recommendation**: Complete before hire start date
**Effort**: 3-4 hours
**Owner**: Team lead

### Process Gaps

#### Gap 3: Quarterly Planning Playbook (Complete)
**Status**: Addressed - [[PLAY-quarterly-planning]] updated

#### Gap 4: Budget Review Process
**Priority**: MEDIUM
**Frequency**: Monthly, undocumented

**Missing**:
- Review checklist
- Variance thresholds
- Approval workflow
- Templates

**Recommendation**: Document before Feb review
**Effort**: 2 hours

### Knowledge Decay

**Stale Notes (>90 days, no access)**:
- 8 notes identified
- 3 recommended for archive
- 5 need review for relevance

**Map Notes Needing Update**:
- [[MAP-hiring-system]] - Add new hiring notes
- [[MAP-q4-2025]] - Archive or close

## Cost Analysis

### January Spending

| Category | Actual | Budget | Variance |
|----------|--------|--------|----------|
| Daily digests | $9.30 | $9.00 | +$0.30 |
| Weekly synthesis | $18.50 | $20.00 | -$1.50 |
| Monthly review | $12.40 | $15.00 | -$2.60 |
| Ad-hoc queries | $15.80 | $15.00 | +$0.80 |
| **Total** | **$56.00** | **$59.00** | **-$3.00** |

### Trend Analysis

- **vs December**: +8% ($52 → $56)
- **Cause**: More ad-hoc queries due to hiring process
- **Projection**: February similar (~$55-60)

### Cost Optimization Opportunities

1. **Reduce daily digest scope**: Currently scanning 30-day window, could reduce to 7
   - Savings: ~$2/month
   - Tradeoff: Less context

2. **Batch ad-hoc queries**: Combine related questions
   - Savings: ~$3-5/month
   - Tradeoff: Slightly slower turnaround

**Recommendation**: Current spending acceptable, no immediate action needed

## Recommended Actions

### High Priority (This Week)

1. **Complete Hiring Work Sample Library**
   - [ ] Create work sample templates
   - [ ] Add evaluation rubrics
   - [ ] Include example responses
   - Effort: 4-6 hours
   - Value: Save 3+ hours per hire
   - Owner: You + Hiring Manager

2. **Fix Broken Links (7 total)**
   - [ ] Update [[2026-01-055]] reference
   - [ ] Archive or redirect Q4 references
   - Effort: 30 minutes
   - Value: Maintain knowledge base health

3. **Complete 90-Day Decision Review**
   - [ ] Review [[DEC-2026-001|Market Entry Decision]]
   - [ ] Document outcomes vs expectations
   - Effort: 1 hour
   - Value: Decision quality feedback loop

### Medium Priority (This Month)

4. **Create Onboarding Checklist**
   - Before frontend lead hire
   - Effort: 3-4 hours

5. **Document Budget Review Process**
   - Before February review
   - Effort: 2 hours

6. **Archive Q4 2025 Project Notes**
   - Clean up knowledge base
   - Effort: 1 hour

### Low Priority (Next Month)

7. **Expand Async Communication Playbook**
8. **Create Project Index Template**
9. **Review Stale Notes for Archive**

## Next Month Preview

### February Focus Areas

1. **Product Launch**: Sprint 3-4, feature completion push
2. **Frontend Hire**: Interview and selection
3. **Q1 Checkpoint**: Mid-quarter OKR review
4. **Process Refinement**: Async playbook expansion

### Scheduled Reviews

- Feb 1: Monthly review (this cycle)
- Feb 15: Sprint 4 retrospective
- Feb 28: Q1 mid-point checkpoint

### Anticipated Challenges

- Candidate decision pressure (hire by Feb 15 target)
- Feature scope vs timeline tradeoff
- Maintaining momentum during hire integration

---

## Meta: This Review

**Generated**: 2026-02-01 05:00 AM by monthly-review orchestrator
**Agents Used**:
- synthesis-agent (Opus): 8 min 32 sec, $5.20
- gap-detector (Opus): 6 min 15 sec, $4.10
- maintenance-agent (Sonnet): 2 min 48 sec, $1.85

**Total Execution Time**: 17 min 35 sec (parallel)
**Total Cost**: $11.15
**Notes Analyzed**: 312 total, 112 from January
**Patterns Identified**: 4 (3 positive, 1 problem)
**Recommendations Generated**: 9 (3 high, 3 medium, 3 low)

**Value Delivered**:
- Identified 2 critical gaps before they caused issues
- Validated Q1 OKR progress tracking
- Confirmed decision framework adoption
- Flagged hiring timeline risk

**Next Monthly Review**: March 1, 2026
```

## Configuration Schema

```yaml
# .kaaos/config.yaml - Monthly rhythm configuration
rhythms:
  monthly:
    enabled: true
    day: 1  # 1st of month
    hour: 5
    minute: 0
    timezone: America/Los_Angeles

    # Agent configuration
    agents:
      synthesis:
        enabled: true
        model: opus
        focus: patterns
        max_runtime_minutes: 15

      gap_detector:
        enabled: true
        model: opus
        focus: gaps
        max_runtime_minutes: 10

      maintenance:
        enabled: true
        model: sonnet
        focus: health
        max_runtime_minutes: 5

    # Content sections
    sections:
      strategic_progress:
        enabled: true
        include_okrs: true
        include_evidence: true
        include_risks: true

      patterns:
        enabled: true
        min_frequency: 3
        include_evidence: true
        max_patterns: 5

      decisions:
        enabled: true
        include_quality_metrics: true
        max_decisions: 20

      health:
        enabled: true
        include_statistics: true
        include_link_health: true
        include_costs: true

      gaps:
        enabled: true
        include_recommendations: true
        max_gaps: 10

      recommendations:
        enabled: true
        include_effort_estimates: true
        include_value_scores: true

    # Output settings
    output:
      path: ".digests/monthly/"
      filename_format: "%Y-%m.md"
      archive_after_months: 12

    # Cost controls
    cost:
      estimated_usd: 12.00
      alert_if_exceeds: 18.00
      max_agent_cost: 8.00
```

## Troubleshooting

### Common Issues

**Problem**: Monthly review timing out

**Solutions**:
1. Increase agent timeouts:
   ```yaml
   agents:
     synthesis:
       max_runtime_minutes: 20  # Increase from 15
   ```
2. Reduce scope:
   ```yaml
   sections:
     patterns:
       max_patterns: 3  # Reduce from 5
   ```
3. Check for infinite loops in pattern detection

**Problem**: One agent failing while others succeed

**Solutions**:
1. Check individual agent logs:
   ```bash
   cat ~/.kaaos-knowledge/.kaaos/logs/monthly-synthesis.error.log
   ```
2. Run failed agent manually:
   ```bash
   /kaaos:review monthly --agent synthesis --debug
   ```
3. Verify agent has necessary permissions

**Problem**: Cost exceeding estimates

**Solutions**:
1. Review which agent is expensive:
   ```bash
   /kaaos:status --costs --breakdown
   ```
2. Switch expensive agent to cheaper model:
   ```yaml
   agents:
     gap_detector:
       model: sonnet  # Change from opus
   ```
3. Reduce content scope

**Problem**: Missing OKR progress

**Solutions**:
1. Verify OKR notes exist and are tagged:
   ```bash
   ls ~/.kaaos-knowledge/objectives/OKR-*.md
   ```
2. Check frontmatter format:
   ```yaml
   ---
   type: okr
   quarter: Q1-2026
   status: active
   ---
   ```
3. Ensure key results have measurable targets

## Best Practices

1. **Schedule Deep Work**: Block 2-3 hours for review
2. **Act on High Priority**: Address critical gaps within the week
3. **Update OKRs**: Keep objective notes current
4. **Review Decisions**: Check if outcomes match expectations
5. **Track Costs**: Monitor for unexpected increases
6. **Archive Completed**: Move finished projects to archive
7. **Celebrate Patterns**: Acknowledge positive patterns emerging
8. **Fix Problems**: Address negative patterns promptly

## Related Resources

- **assets/monthly-template.md**: Full template with placeholders
- **references/weekly-rhythm-patterns.md**: Weekly synthesis patterns
- **references/quarterly-rhythm-patterns.md**: Quarterly comprehensive review
- **SKILL.md**: Overview of all operational rhythms
