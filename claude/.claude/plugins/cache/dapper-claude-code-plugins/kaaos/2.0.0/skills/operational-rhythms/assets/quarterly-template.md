# Quarterly Review Template

Template for automated quarterly review generation. This template is used by the full agent orchestrator to create comprehensive 90-day strategic reviews.

## Template Structure

```markdown
# Quarterly Review - Q[N] [Year] ([Start Month] - [End Month])

## Executive Summary

[AGENT_GENERATED: strategic_synthesis]

**Quarter Highlights**:
- [notes_emoji] [notes_created] notes created ([change_direction][change_percent]% from Q[N-1])
- [updates_emoji] [notes_updated] notes updated
- [decisions_emoji] [decisions_made] decisions documented
- [insights_emoji] [insights_extracted] insights extracted
- [patterns_emoji] [patterns_emerged] major patterns emerged
- [achievements_emoji] [objectives_achieved]/[objectives_total] quarterly objectives achieved

**Major Achievements**:
[FOR EACH ACHIEVEMENT max=4]
[N]. [achievement_description]

**Strategic Pivots**:
[FOR EACH PIVOT max=3]
[N]. [pivot_description]

---

## Part 1: Strategic Review

### Quarterly Objectives Results

[FOR EACH OBJECTIVE]
#### [objective_id]: [objective_title] [status_emoji] [status_text]
**Final Status**: [detailed_status] (Target: [target_date])

| Key Result | Target | Achieved | Score |
|------------|--------|----------|-------|
[FOR EACH KEY_RESULT]
| [kr_description] | [kr_target] | [kr_achieved] | [kr_score]% |
| **Overall** | | | **[overall_score]%** |

**Key Decisions That Enabled Success/Caused Issues**:
[FOR EACH DECISION max=3]
- [[decision_id|decision_title]] - [impact_summary]

**Learnings**:
[FOR EACH LEARNING max=3]
- [learning_description]

---

### Major Decisions Impact Analysis

**Decisions Made**: [total_decisions] total
**Reviewed This Quarter**: [reviewed_count] ([reviewed_percent]%)
**Outcomes Documented**: [documented_count] ([documented_percent]%)

#### Decision Quality Distribution

| Category | Count | Percentage |
|----------|-------|------------|
[FOR EACH CATEGORY]
| [category_name] | [count] | [percentage]% |

#### Top Impact Decisions

[FOR EACH TOP_DECISION max=5]
[N]. **[[decision_id|decision_title]]** - Impact: [impact_level]
   - Expected: [expected_outcome]
   - Actual: [actual_outcome]
   - Learning: [key_learning]

#### Unsuccessful Decision Analysis

[FOR EACH FAILED_DECISION]
**[[decision_id|decision_title]]** - Failed
- Expected: [expected]
- Actual: [actual]
- Root Cause: [root_cause]
- Learning: [learning]
- Action: [action_taken]

---

### Strategic Pivots

[FOR EACH PIVOT]
#### Pivot [N]: [pivot_title]
**When**: [timing]
**From**: [previous_state]
**To**: [new_state]

**Trigger**: [trigger_description]
**Impact**: [impact_description]
**Validated**: [validation_status]

---

## Part 2: Knowledge Synthesis

### Quarterly Themes

[FOR EACH THEME max=5]
#### Theme [N]: [theme_name]
**Frequency**: [frequency] related notes, [conversation_count] conversations
**Trajectory**: [trajectory]
**Peak**: [peak_month]

[theme_description]

**Evidence**: [[evidence_note_1]], [[evidence_note_2]], [[evidence_note_3]]
**Implication**: [implication_text]

---

### Pattern Evolution

Patterns that matured this quarter:

| Pattern | [Q-1] Status | [Q] Status | Change |
|---------|--------------|------------|--------|
[FOR EACH PATTERN]
| [pattern_name] | [previous_status] | [current_status] | [change_direction] [change_description] |

---

### Playbook Effectiveness

| Playbook | Times Used | Success Rate | Avg Time Saved |
|----------|------------|--------------|----------------|
[FOR EACH PLAYBOOK]
| [[playbook_id]] | [usage_count] | [success_rate]% | [time_saved] |

**Recommendation**: [playbook_recommendation]

---

## Part 3: System Health

### Knowledge Base Statistics

| Metric | Q[N-1] | Q[N] | Change |
|--------|--------|------|--------|
| Total notes | [prev_notes] | [curr_notes] | [change_prefix][change_percent]% |
| Total links | [prev_links] | [curr_links] | [change_prefix][change_percent]% |
| Avg links/note | [prev_avg] | [curr_avg] | [change_prefix][change_percent]% |
| Total words | [prev_words] | [curr_words] | [change_prefix][change_percent]% |
| Daily active notes | [prev_active] | [curr_active] | [change_prefix][change_percent]% |

### Growth Quality Analysis

**Note Type Distribution**:
[FOR EACH NOTE_TYPE]
- [type_name]: [count] ([percentage]%)

**Quality Indicators**:
- Notes with 3+ cross-references: [cross_ref_percent]% (target: [target]%)
- Notes with frontmatter: [frontmatter_percent]%
- Notes linked to map: [linked_percent]%
- Average note quality score: [quality_score]/10

### Link Health

| Metric | Count | Status |
|--------|-------|--------|
| Broken links | [broken_count] | [status_emoji] [status_text] |
| Orphaned notes | [orphan_count] | [status_emoji] [status_text] |
| Deeply connected (>10 links) | [connected_count] | [status_emoji] [status_text] |
| Map notes | [map_count] | [status_emoji] [status_text] |

### Cost Analysis

| Month | Actual | Budget | Variance |
|-------|--------|--------|----------|
[FOR EACH MONTH]
| [month_name] | $[actual] | $[budget] | [prefix]$[variance] |
| **Q[N] Total** | **$[total_actual]** | **$[total_budget]** | **[total_prefix]$[total_variance]** |

**Analysis**:
- [analysis_point_1]
- [analysis_point_2]

**Q[N+1] Budget Recommendation**: $[recommended_budget]/month

---

## Part 4: Gap Analysis

### Documentation Debt

**Total Estimated Debt**: [debt_hours] hours of documentation needed

| Category | Hours | Priority |
|----------|-------|----------|
[FOR EACH CATEGORY]
| [category_name] | [hours] | [priority] |

### Critical Gaps Identified

[FOR EACH CRITICAL_GAP max=5]
[N]. **[gap_name]** ([status])
   - Impact: [impact_description]
   - Effort: [effort_hours] hours
   - Priority: [priority] ([priority_reason])

### Process Maturity Scores

| Process | Current Level | Target | Gap |
|---------|---------------|--------|-----|
[FOR EACH PROCESS]
| [process_name] | [current_level] ([level_name]) | [target_level] | [gap_levels] level(s) |

---

## Part 5: Future Direction

### Q[N+1] Recommended Priorities

[FOR EACH PRIORITY max=3]
#### Priority [N]: [priority_title] ([priority_level])
**Objective**: [objective_description]

**Key Initiatives**:
[FOR EACH INITIATIVE]
- [initiative_description]

**Resources Needed**: [resource_description]

---

### Strategic Bets for Q[N+1]

[FOR EACH BET max=3]
[N]. **[bet_title]**: [bet_description]
   - Risk: [risk_description]
   - Upside: [upside_description]
   - Investment: [investment_description]

---

### Learning Priorities

[FOR EACH LEARNING_PRIORITY]
[N]. **[priority_title]**: [priority_description]

---

## Part 6: Recommendations

### Immediate Actions (This Week)

[FOR EACH IMMEDIATE_ACTION]
[N]. **[action_title]**
   [FOR EACH SUBTASK]
   - [ ] [subtask_description]
   - Effort: [effort_estimate]

### High Priority (Q[N+1] Month 1)

[FOR EACH HIGH_PRIORITY]
[N]. **[action_title]**
   - [description]
   - Effort: [effort_hours] hours
   - Owner: [owner]

### Medium Priority (Q[N+1])

[FOR EACH MEDIUM_PRIORITY]
[N]. **[action_title]**

### Low Priority (Backlog)

[FOR EACH LOW_PRIORITY]
[N]. **[action_title]**

---

## Meta: This Review

**Generated**: [timestamp] by quarterly-review orchestrator

**Agent Execution Summary**:

| Agent | Model | Time | Cost | Sections | Recommendations |
|-------|-------|------|------|----------|-----------------|
[FOR EACH AGENT]
| [agent_name] | [model] | [execution_time] | $[cost] | [section_count] | [rec_count] |

**Total Execution**: [total_time] (parallel), [wall_clock_time] wall-clock
**Total Cost**: $[total_cost]
**Notes Analyzed**: [total_notes] total, [quarter_notes] from Q[N]
**Patterns Identified**: [pattern_count] ([positive] positive, [emerging] emerging, [problem] problem)
**Recommendations Generated**: [rec_total] ([immediate] immediate, [high] high, [medium] medium, [low] low)

**Value Delivered**:
[FOR EACH VALUE_ITEM]
- [value_description]

**Next Quarterly Review**: [next_date]
```

## Agent Implementation

```python
def generate_quarterly_review(knowledge_base, quarter, config):
    """Generate quarterly review using full agent suite."""

    from concurrent.futures import ThreadPoolExecutor, as_completed
    from datetime import datetime
    import time

    start_time = time.time()

    # Initialize template data
    q_num, year = parse_quarter(quarter)
    q_start, q_end = get_quarter_boundaries(quarter)

    template_data = {
        'quarter_num': q_num,
        'year': year,
        'start_month': q_start.strftime('%B'),
        'end_month': q_end.strftime('%B'),
        'prev_quarter': f"Q{q_num - 1 if q_num > 1 else 4}",
        'next_quarter': f"Q{q_num + 1 if q_num < 4 else 1}",
        'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M %p'),
        'agents': []
    }

    # Define full agent suite
    agents = {
        'strategic': strategic_reviewer_task,
        'synthesis': synthesis_agent_task,
        'gaps': gap_detector_task,
        'research': research_agent_task,
        'maintenance': maintenance_agent_task,
        'orchestrator': orchestrator_meta_task
    }

    # Execute all agents in parallel (6 workers)
    results = {}
    with ThreadPoolExecutor(max_workers=6) as executor:
        futures = {
            executor.submit(func, knowledge_base, quarter, config): name
            for name, func in agents.items()
        }

        for future in as_completed(futures):
            name = futures[future]
            try:
                results[name] = future.result()
                template_data['agents'].append({
                    'agent_name': results[name]['agent_name'],
                    'model': results[name]['model'],
                    'execution_time': format_time(results[name]['execution_time']),
                    'cost': f"{results[name]['cost']:.2f}",
                    'section_count': results[name].get('section_count', 0),
                    'rec_count': results[name].get('recommendation_count', 0)
                })
            except Exception as e:
                results[name] = {'error': str(e)}

    # Phase 2: Cross-agent synthesis
    template_data = synthesize_all_results(template_data, results)

    # Calculate totals
    wall_clock = time.time() - start_time
    parallel_time = sum(r.get('execution_time', 0) for r in results.values())

    template_data['total_time'] = format_time(parallel_time)
    template_data['wall_clock_time'] = format_time(wall_clock)
    template_data['total_cost'] = sum(r.get('cost', 0) for r in results.values())

    # Render template
    return render_quarterly_template(template_data)
```

## Section Generators

### Strategic Review Generator

```python
def generate_strategic_review(strategic_result, quarter):
    """Generate strategic review section."""

    review_data = {
        'objectives': [],
        'decisions_analysis': {},
        'pivots': []
    }

    # Process objectives
    for obj in strategic_result.get('objectives', []):
        obj_data = {
            'objective_id': obj['id'],
            'objective_title': obj['title'],
            'status_emoji': get_status_emoji(obj['status']),
            'status_text': obj['status'].upper(),
            'detailed_status': obj['detailed_status'],
            'target_date': obj['target_date'],
            'key_results': [],
            'overall_score': obj['overall_score'],
            'decisions': obj.get('enabling_decisions', [])[:3],
            'learnings': obj.get('learnings', [])[:3]
        }

        for kr in obj.get('key_results', []):
            obj_data['key_results'].append({
                'kr_description': kr['description'],
                'kr_target': kr['target'],
                'kr_achieved': kr['achieved'],
                'kr_score': kr['score']
            })

        review_data['objectives'].append(obj_data)

    # Process decision analysis
    decisions = strategic_result.get('decision_analysis', {})
    review_data['decisions_analysis'] = {
        'total_decisions': decisions.get('total', 0),
        'reviewed_count': decisions.get('reviewed', 0),
        'reviewed_percent': calculate_percent(decisions.get('reviewed', 0), decisions.get('total', 1)),
        'documented_count': decisions.get('documented', 0),
        'documented_percent': calculate_percent(decisions.get('documented', 0), decisions.get('total', 1)),
        'categories': decisions.get('categories', []),
        'top_decisions': decisions.get('top_impact', [])[:5],
        'failed_decisions': decisions.get('unsuccessful', [])
    }

    # Process pivots
    for pivot in strategic_result.get('pivots', []):
        review_data['pivots'].append({
            'pivot_title': pivot['title'],
            'timing': pivot['timing'],
            'previous_state': pivot['from'],
            'new_state': pivot['to'],
            'trigger_description': pivot['trigger'],
            'impact_description': pivot['impact'],
            'validation_status': pivot['validated']
        })

    return review_data
```

### Knowledge Synthesis Generator

```python
def generate_knowledge_synthesis(synthesis_result, quarter):
    """Generate knowledge synthesis section."""

    synthesis_data = {
        'themes': [],
        'pattern_evolution': [],
        'playbook_effectiveness': []
    }

    # Process themes
    for theme in synthesis_result.get('themes', [])[:5]:
        synthesis_data['themes'].append({
            'theme_name': theme['name'],
            'frequency': theme['frequency'],
            'conversation_count': theme.get('conversations', 0),
            'trajectory': theme['trajectory'],
            'peak_month': theme['peak_month'],
            'theme_description': theme['description'],
            'evidence_notes': theme.get('evidence', [])[:3],
            'implication_text': theme.get('implication', '')
        })

    # Process pattern evolution
    for pattern in synthesis_result.get('pattern_evolution', []):
        synthesis_data['pattern_evolution'].append({
            'pattern_name': pattern['name'],
            'previous_status': pattern['previous_status'],
            'current_status': pattern['current_status'],
            'change_direction': get_change_arrow(pattern['change']),
            'change_description': pattern['change_description']
        })

    # Process playbook effectiveness
    for playbook in synthesis_result.get('playbook_effectiveness', []):
        synthesis_data['playbook_effectiveness'].append({
            'playbook_id': playbook['id'],
            'usage_count': playbook['times_used'],
            'success_rate': playbook['success_rate'],
            'time_saved': format_time_saved(playbook['avg_time_saved'])
        })

    synthesis_data['playbook_recommendation'] = synthesis_result.get(
        'playbook_recommendation',
        'Continue investing in playbook creation based on emerging patterns'
    )

    return synthesis_data
```

### Future Direction Generator

```python
def generate_future_direction(all_results, quarter):
    """Generate future direction section."""

    direction_data = {
        'priorities': [],
        'strategic_bets': [],
        'learning_priorities': []
    }

    # Synthesize priorities from all agent outputs
    strategic = all_results.get('strategic', {})
    gaps = all_results.get('gaps', {})
    research = all_results.get('research', {})

    # Priority 1: Based on strategic gaps
    if gaps.get('critical_gaps'):
        direction_data['priorities'].append({
            'priority_title': 'Address Critical Gaps',
            'priority_level': 'HIGH',
            'objective_description': 'Resolve identified documentation and process gaps',
            'initiatives': [
                gap['remediation'] for gap in gaps['critical_gaps'][:3]
            ],
            'resource_description': f"{sum(g['effort'] for g in gaps['critical_gaps'][:3])} hours total"
        })

    # Priority 2: Based on strategic objectives
    next_objectives = strategic.get('next_quarter_objectives', [])
    if next_objectives:
        direction_data['priorities'].append({
            'priority_title': next_objectives[0]['title'],
            'priority_level': 'HIGH',
            'objective_description': next_objectives[0]['description'],
            'initiatives': next_objectives[0].get('initiatives', []),
            'resource_description': next_objectives[0].get('resources', 'TBD')
        })

    # Strategic bets from research agent
    for bet in research.get('strategic_bets', [])[:3]:
        direction_data['strategic_bets'].append({
            'bet_title': bet['title'],
            'bet_description': bet['description'],
            'risk_description': bet['risk'],
            'upside_description': bet['upside'],
            'investment_description': bet['investment']
        })

    # Learning priorities
    for priority in research.get('learning_priorities', [])[:3]:
        direction_data['learning_priorities'].append({
            'priority_title': priority['title'],
            'priority_description': priority['description']
        })

    return direction_data
```

## Configuration Options

```yaml
# Quarterly template configuration
templates:
  quarterly:
    # Section toggles
    sections:
      executive_summary: true
      strategic_review: true
      knowledge_synthesis: true
      system_health: true
      gap_analysis: true
      future_direction: true
      recommendations: true
      meta: true

    # Content limits
    limits:
      achievements: 4
      pivots: 3
      objectives: 5
      key_results_per_objective: 5
      decisions_per_objective: 3
      learnings_per_objective: 3
      top_decisions: 5
      themes: 5
      pattern_evolution: 10
      playbooks: 8
      critical_gaps: 5
      priorities: 3
      strategic_bets: 3
      learning_priorities: 3
      immediate_actions: 5
      high_priority_actions: 6
      medium_priority_actions: 6
      low_priority_actions: 10

    # Agent configuration
    agents:
      strategic_reviewer:
        model: opus
        max_runtime_minutes: 25
      synthesis_agent:
        model: opus
        max_runtime_minutes: 20
      gap_detector:
        model: opus
        max_runtime_minutes: 15
      research_agent:
        model: opus
        max_runtime_minutes: 12
      maintenance_agent:
        model: opus
        max_runtime_minutes: 10
      orchestrator:
        model: opus
        max_runtime_minutes: 8

    # Cost controls
    cost:
      estimated_usd: 45.00
      alert_threshold: 55.00
      max_total_cost: 75.00
      per_agent_max: 15.00

    # Formatting
    formatting:
      date_format: "%B %d, %Y"
      time_format: "%H:%M %p"
      currency_format: "${:.2f}"
      percent_format: "{:.0f}%"
```

## Usage

### Manual Generation

```bash
# Generate for current quarter
/kaaos:review quarterly

# Generate for specific quarter
/kaaos:review quarterly Q1-2026

# View most recent
/kaaos:digest quarterly --view

# Dry run (preview without saving)
/kaaos:review quarterly --dry-run

# Generate with specific agent subset
/kaaos:review quarterly --agents strategic,synthesis
```

### Automated Generation

Runs automatically via launchd on the 1st of Jan, Apr, Jul, Oct at configured hour.

```bash
# Verify schedule
launchctl list | grep kaaos.quarterly

# Manual trigger for testing
launchctl start com.kaaos.quarterly

# Check last run
cat ~/.kaaos-knowledge/.kaaos/logs/quarterly.log
```

## Best Practices

1. **Block Half-Day**: Schedule 4-6 hours for comprehensive review
2. **Pre-Read Generated Output**: Review agent output before deep dive
3. **Document Commitments**: Capture action items immediately
4. **Set Next Quarter OKRs**: Use session to define objectives
5. **Archive Completed Work**: Clean up finished projects
6. **Share Strategic Summary**: Communicate key points to stakeholders
7. **Celebrate Achievements**: Acknowledge team and personal wins
8. **Learn from Failures**: Document what didn't work for future reference

## Related Resources

- **references/quarterly-rhythm-patterns.md**: Detailed patterns and algorithms
- **references/monthly-rhythm-patterns.md**: Monthly review patterns
- **monthly-template.md**: Monthly review template
- **daily-template.md**: Daily digest template
- **launchd-configs/**: macOS scheduling configurations
