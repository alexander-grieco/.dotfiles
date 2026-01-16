# Monthly Review Template

Template for automated monthly review generation. This template is used by the orchestrator to create comprehensive monthly reviews.

## Template Structure

```markdown
# Monthly Review - [Month] [Year]

## Executive Summary

[AGENT_GENERATED: synthesis_summary]

**Month Highlights**:
- [notes_created_emoji] [notes_created] notes created ([change_direction][change_amount] from [previous_month])
- [notes_updated_emoji] [notes_updated] notes updated
- [decisions_emoji] [decisions_made] decisions documented
- [insights_emoji] [insights_extracted] insights extracted
- [patterns_emoji] [patterns_detected] patterns emerged
- [gaps_emoji] [gaps_identified] gaps identified

**Key Achievements**:
[FOR EACH ACHIEVEMENT max=3]
[N]. [achievement_description]

**Areas Needing Attention**:
[FOR EACH ATTENTION_AREA max=3]
[N]. [attention_description]

---

## Strategic Progress

### [Quarter] Objectives

[FOR EACH OBJECTIVE]
#### [objective_id]: [objective_title]
**Status**: [status_emoji] [status_text] ([progress]% complete)
**Progress**: [progress_description]

| Key Result | Target | Current | Progress |
|------------|--------|---------|----------|
[FOR EACH KEY_RESULT]
| [kr_description] | [kr_target] | [kr_current] | [kr_progress]% |

**Evidence**:
[FOR EACH EVIDENCE_NOTE max=3]
- [[note_id|note_title]] - [note_summary]

**Risks**:
[FOR EACH RISK max=2]
- [risk_description]

**Recommendation**: [recommendation_text]

---

## Emerging Patterns

[FOR EACH PATTERN max=4]
### Pattern [N]: [pattern_name]
**Frequency**: [frequency] instances in [month]
**Strength**: [strength] ([trajectory])

[pattern_description]

**Evidence**:
[FOR EACH EVIDENCE max=4]
[N]. [[note_id|note_title]]
   - [evidence_summary]

**Pattern Analysis**:
[analysis_text]

**Recommendation**: [recommendation_text]

---

## Decision Analysis

### Decisions Made ([decision_count] total)

| ID | Decision | Type | Method | Outcome |
|----|----------|------|--------|---------|
[FOR EACH DECISION max=12]
| [decision_id] | [decision_title] | [decision_type] | [method] | [outcome] |

### Decision Quality Metrics

**Framework Usage**: [framework_percentage]% ([framework_used]/[total] used documented framework)
**Documentation Quality**: [doc_quality] ([quality_description])
**Review Scheduled**: [review_percentage]% ([reviewed]/[total] have review dates)

**Best Practice Adoption**:
[FOR EACH PRACTICE]
- [practice_name]: [usage_count]/[total] ([percentage]%)

**Recommendation**: [recommendation_text]

---

## Knowledge Base Health

### Statistics

| Metric | Value | Change | Trend |
|--------|-------|--------|-------|
| Total notes | [total_notes] | [change] | [trend_emoji] [trend_percent]% |
| Total links | [total_links] | [change] | [trend_emoji] [trend_percent]% |
| Avg links/note | [avg_links] | [change] | [trend_emoji] [trend_percent]% |
| Total words | [total_words] | [change] | [trend_emoji] [trend_percent]% |
| Avg words/note | [avg_words] | [change] | [trend_emoji] [trend_percent]% |

### Link Health

| Metric | Count | Status |
|--------|-------|--------|
| Broken links | [broken_count] | [status_emoji] [status_text] |
| Orphaned notes | [orphan_count] | [status_emoji] [status_text] |
| Deeply connected (>10 links) | [connected_count] | [status_emoji] [status_text] |
| Index notes updated | [index_updated]/[index_total] | [status_emoji] [status_text] |

**Broken Links Requiring Action**:
[FOR EACH BROKEN_LINK max=5]
[N]. [[source_note]] -> [[broken_ref]] (should be [[suggested_target]])

### Growth Quality

**New Note Types**:
[FOR EACH NOTE_TYPE]
- [type_name]: [count] ([percentage]%)

**Quality Indicators**:
- Average cross-references per new note: [avg_refs] ([quality_assessment])
- Notes with frontmatter: [frontmatter_percent]% ([quality_assessment])
- Notes linked to map: [linked_percent]% ([quality_assessment])

---

## Gap Analysis

### Critical Documentation Gaps

[FOR EACH GAP priority=HIGH]
#### Gap [N]: [gap_name]
**Priority**: [priority_emoji] [priority]
**Impact**: [impact_description]
**Frequency**: [frequency_description]

**Missing**:
[FOR EACH MISSING_ITEM]
- [item_description]

**Recommendation**: [recommendation_text]
**Effort**: [effort_hours] hours
**Owner**: [owner]

### Process Gaps

[FOR EACH PROCESS_GAP]
#### Gap [N]: [process_name]
**Priority**: [priority]
**Frequency**: [frequency]

**Missing**:
[FOR EACH MISSING_ITEM]
- [item_description]

**Recommendation**: [recommendation_text]
**Effort**: [effort_hours] hours

### Knowledge Decay

**Stale Notes (>[stale_threshold] days, no access)**:
- [stale_count] notes identified
- [archive_recommended] recommended for archive
- [review_recommended] need review for relevance

**Map Notes Needing Update**:
[FOR EACH MAP_NOTE_NEEDING_UPDATE]
- [[map_note_id]] - [reason]

---

## Cost Analysis

### [Month] Spending

| Category | Actual | Budget | Variance |
|----------|--------|--------|----------|
[FOR EACH COST_CATEGORY]
| [category_name] | $[actual] | $[budget] | [variance_prefix]$[variance] |
| **Total** | **$[total_actual]** | **$[total_budget]** | **[total_prefix]$[total_variance]** |

### Trend Analysis

- **vs [Previous Month]**: [change_prefix][change_percent]% ($[previous] -> $[current])
- **Cause**: [cause_description]
- **Projection**: [next_month] similar (~$[projected_range])

### Cost Optimization Opportunities

[FOR EACH OPTIMIZATION]
[N]. **[optimization_name]**: [description]
   - Savings: ~$[savings]/month
   - Tradeoff: [tradeoff]

**Recommendation**: [recommendation_text]

---

## Recommended Actions

### High Priority (This Week)

[FOR EACH HIGH_PRIORITY_ACTION]
[N]. **[action_title]**
   [FOR EACH SUBTASK]
   - [ ] [subtask_description]
   - Effort: [effort_hours] hours
   - Value: [value_description]
   - Owner: [owner]

### Medium Priority (This Month)

[FOR EACH MEDIUM_PRIORITY_ACTION]
[N]. **[action_title]**
   - [description]
   - Effort: [effort_hours] hours

### Low Priority (Next Month)

[FOR EACH LOW_PRIORITY_ACTION]
[N]. **[action_title]**

---

## Next Month Preview

### [Next Month] Focus Areas

[FOR EACH FOCUS_AREA]
[N]. **[area_name]**: [description]

### Scheduled Reviews

[FOR EACH SCHEDULED_REVIEW]
- [date]: [review_description]

### Anticipated Challenges

[FOR EACH CHALLENGE]
- [challenge_description]

---

## Meta: This Review

**Generated**: [timestamp] by monthly-review orchestrator
**Agents Used**:
[FOR EACH AGENT]
- [agent_name] ([model]): [execution_time], $[cost]

**Total Execution Time**: [total_time] (parallel)
**Total Cost**: $[total_cost]
**Notes Analyzed**: [total_notes] total, [month_notes] from [month]
**Patterns Identified**: [pattern_count] ([positive_count] positive, [problem_count] problem)
**Recommendations Generated**: [rec_count] ([high_count] high, [medium_count] medium, [low_count] low)

**Value Delivered**:
[FOR EACH VALUE_ITEM]
- [value_description]

**Next Monthly Review**: [next_date]
```

## Agent Implementation

```python
def generate_monthly_review(knowledge_base, month, config):
    """Generate monthly review using parallel agents."""

    from concurrent.futures import ThreadPoolExecutor, as_completed
    from datetime import datetime, timedelta
    import time

    start_time = time.time()

    # Initialize template data
    template_data = {
        'month': month.strftime('%B'),
        'year': month.year,
        'previous_month': (month - timedelta(days=1)).strftime('%B'),
        'next_month': (month + timedelta(days=32)).replace(day=1).strftime('%B'),
        'quarter': get_quarter_name(month),
        'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M %p'),
        'agents': []
    }

    # Define agent tasks
    agents = {
        'synthesis': synthesis_agent_task,
        'gaps': gap_detector_task,
        'health': health_check_task
    }

    # Execute agents in parallel
    results = {}
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = {
            executor.submit(func, knowledge_base, month, config): name
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
                    'cost': results[name]['cost']
                })
            except Exception as e:
                results[name] = {'error': str(e)}

    # Merge results into template data
    template_data = merge_agent_results(template_data, results)

    # Calculate totals
    template_data['total_time'] = format_time(time.time() - start_time)
    template_data['total_cost'] = sum(r.get('cost', 0) for r in results.values())

    # Render template
    return render_monthly_template(template_data)
```

## Section Generators

### Executive Summary Generator

```python
def generate_executive_summary(synthesis_result, gaps_result, health_result, month):
    """Generate executive summary from agent results."""

    summary = {
        'synthesis_summary': synthesis_result.get('summary', ''),
        'notes_created': health_result.get('notes_created', 0),
        'notes_updated': health_result.get('notes_updated', 0),
        'decisions_made': synthesis_result.get('decision_count', 0),
        'insights_extracted': synthesis_result.get('insight_count', 0),
        'patterns_detected': len(synthesis_result.get('patterns', [])),
        'gaps_identified': len(gaps_result.get('critical_gaps', []))
    }

    # Emoji mappings
    summary['notes_created_emoji'] = '📝'
    summary['notes_updated_emoji'] = '✏️'
    summary['decisions_emoji'] = '✅'
    summary['insights_emoji'] = '💡'
    summary['patterns_emoji'] = '📊'
    summary['gaps_emoji'] = '⚠️'

    # Calculate change from previous month
    prev_stats = get_previous_month_stats(month)
    if prev_stats:
        change = summary['notes_created'] - prev_stats['notes_created']
        summary['change_amount'] = abs(change)
        summary['change_direction'] = '↑' if change > 0 else '↓'
    else:
        summary['change_amount'] = 0
        summary['change_direction'] = ''

    # Extract achievements
    summary['achievements'] = extract_achievements(synthesis_result)[:3]

    # Extract attention areas
    summary['attention_areas'] = extract_attention_areas(gaps_result, health_result)[:3]

    return summary
```

### Strategic Progress Generator

```python
def generate_strategic_progress(knowledge_base, month):
    """Generate strategic progress section."""

    objectives = find_active_objectives(knowledge_base, month)
    progress_data = []

    for obj in objectives:
        obj_data = {
            'objective_id': obj.id,
            'objective_title': obj.title,
            'progress': calculate_objective_progress(obj),
            'status': determine_status(obj),
            'key_results': [],
            'evidence': [],
            'risks': [],
            'recommendation': ''
        }

        # Status emoji mapping
        status_map = {
            'on_track': ('✅', 'On Track'),
            'at_risk': ('⚠️', 'At Risk'),
            'behind': ('🔴', 'Behind')
        }
        emoji, text = status_map.get(obj_data['status'], ('❓', 'Unknown'))
        obj_data['status_emoji'] = emoji
        obj_data['status_text'] = text

        # Key results
        for kr in obj.key_results:
            kr_data = {
                'kr_description': kr['description'],
                'kr_target': kr['target'],
                'kr_current': estimate_current_value(knowledge_base, kr, month),
                'kr_progress': calculate_kr_progress(kr)
            }
            obj_data['key_results'].append(kr_data)

        # Evidence notes
        evidence_notes = find_evidence_notes(knowledge_base, obj, month)
        obj_data['evidence'] = [
            {
                'note_id': n.id,
                'note_title': n.title,
                'note_summary': n.summary[:100] if n.summary else ''
            }
            for n in evidence_notes[:3]
        ]

        # Risks and recommendation
        obj_data['risks'] = identify_objective_risks(obj, obj_data['progress'])[:2]
        obj_data['recommendation'] = generate_objective_recommendation(obj, obj_data)

        progress_data.append(obj_data)

    return progress_data
```

### Cost Analysis Generator

```python
def generate_cost_analysis(knowledge_base, month, config):
    """Generate cost analysis section."""

    cost_log = load_cost_log(knowledge_base)
    budget = config.get('cost_controls', {})

    # Budget allocation
    categories = {
        'daily_digests': {'actual': 0, 'budget': 9.00, 'name': 'Daily digests'},
        'weekly_synthesis': {'actual': 0, 'budget': 20.00, 'name': 'Weekly synthesis'},
        'monthly_review': {'actual': 0, 'budget': 15.00, 'name': 'Monthly review'},
        'ad_hoc_queries': {'actual': 0, 'budget': 15.00, 'name': 'Ad-hoc queries'}
    }

    # Get month boundaries
    month_start = month.replace(day=1)
    next_month = (month_start + timedelta(days=32)).replace(day=1)

    # Sum costs by category
    for entry in cost_log:
        entry_date = parse_date(entry['timestamp'])
        if month_start <= entry_date < next_month:
            category = entry.get('category', 'ad_hoc_queries')
            if category in categories:
                categories[category]['actual'] += entry['cost_usd']

    # Build cost data
    cost_data = {
        'categories': [],
        'total_actual': 0,
        'total_budget': 0,
        'trend_analysis': {},
        'optimizations': []
    }

    for cat_key, cat_values in categories.items():
        variance = cat_values['actual'] - cat_values['budget']
        cost_data['categories'].append({
            'category_name': cat_values['name'],
            'actual': f"{cat_values['actual']:.2f}",
            'budget': f"{cat_values['budget']:.2f}",
            'variance': f"{abs(variance):.2f}",
            'variance_prefix': '+' if variance > 0 else '-'
        })
        cost_data['total_actual'] += cat_values['actual']
        cost_data['total_budget'] += cat_values['budget']

    # Calculate total variance
    total_var = cost_data['total_actual'] - cost_data['total_budget']
    cost_data['total_variance'] = f"{abs(total_var):.2f}"
    cost_data['total_prefix'] = '+' if total_var > 0 else '-'

    # Trend analysis
    prev_month_cost = get_previous_month_total_cost(cost_log, month)
    if prev_month_cost > 0:
        change = cost_data['total_actual'] - prev_month_cost
        change_percent = (change / prev_month_cost) * 100
        cost_data['trend_analysis'] = {
            'change_prefix': '+' if change > 0 else '',
            'change_percent': f"{change_percent:.0f}",
            'previous': f"{prev_month_cost:.0f}",
            'current': f"{cost_data['total_actual']:.0f}",
            'cause': infer_cost_change_cause(cost_log, month),
            'projected_range': f"{cost_data['total_actual'] * 0.9:.0f}-{cost_data['total_actual'] * 1.1:.0f}"
        }

    return cost_data
```

## Configuration Options

```yaml
# Monthly template configuration
templates:
  monthly:
    # Section toggles
    sections:
      executive_summary: true
      strategic_progress: true
      emerging_patterns: true
      decision_analysis: true
      knowledge_health: true
      gap_analysis: true
      cost_analysis: true
      recommendations: true
      next_month_preview: true
      meta: true

    # Content limits
    limits:
      achievements: 3
      attention_areas: 3
      patterns: 4
      evidence_per_pattern: 4
      decisions: 12
      broken_links: 5
      critical_gaps: 5
      high_priority_actions: 5
      medium_priority_actions: 5
      low_priority_actions: 5
      focus_areas: 4
      scheduled_reviews: 5
      challenges: 3

    # Quality thresholds
    thresholds:
      broken_links_warning: 5
      broken_links_critical: 10
      orphan_notes_warning: 10
      orphan_notes_critical: 20
      stale_days: 90
      cost_variance_warning: 10  # percent
      cost_variance_critical: 25

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
# Generate for current month
/kaaos:review monthly

# Generate for specific month
/kaaos:review monthly 2026-01

# View most recent
/kaaos:digest monthly --view

# Dry run (preview without saving)
/kaaos:review monthly --dry-run
```

### Automated Generation

Runs automatically via launchd on the 1st of each month at the configured hour.

```bash
# Verify schedule
launchctl list | grep kaaos.monthly

# Manual trigger for testing
launchctl start com.kaaos.monthly
```

## Best Practices

1. **Block Review Time**: Schedule 2-3 hours for thorough review
2. **Act on High Priority**: Address critical gaps within the week
3. **Update OKRs**: Keep objective progress current for accurate tracking
4. **Track Decisions**: Ensure all decisions have scheduled review dates
5. **Monitor Costs**: Watch for unexpected spending increases
6. **Archive Completed**: Move finished projects to archive promptly
7. **Share Insights**: Communicate key patterns to stakeholders

## Related Resources

- **references/monthly-rhythm-patterns.md**: Detailed patterns and algorithms
- **references/weekly-rhythm-patterns.md**: Weekly synthesis patterns
- **daily-template.md**: Daily digest template
- **quarterly-template.md**: Quarterly review template
- **launchd-configs/**: macOS scheduling configurations
