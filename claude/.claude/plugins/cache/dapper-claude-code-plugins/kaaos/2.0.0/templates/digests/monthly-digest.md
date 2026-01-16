---
template: monthly-digest
version: "1.0"
description: Template for automated monthly review generation
usage: Used by strategic-reviewer agent for monthly strategic alignment
placeholders:
  - "{{MONTH}}" - Month name (e.g., "January")
  - "{{YEAR}}" - Year (e.g., "2026")
  - "{{MONTH_ID}}" - Month identifier (e.g., "2026-01")
  - "{{TIMESTAMP}}" - Generation timestamp (ISO-8601)
  - "{{EXECUTION_TIME}}" - Time to generate in seconds
  - "{{COST}}" - API cost for generation
---

# Monthly Digest Template

This template defines the structure for automated monthly reviews. The strategic-reviewer agent uses this template to assess strategic alignment, knowledge quality, and provide improvement recommendations.

## Template Output

```markdown
# Monthly Review - {{MONTH}} {{YEAR}}

## Executive Summary

{{EXECUTIVE_SUMMARY}}

**Key Metrics**:
- Knowledge items: {{TOTAL_NOTES}} (+{{NEW_NOTES}} this month)
- Decisions documented: {{DECISIONS_COUNT}}
- Patterns identified: {{PATTERNS_COUNT}}
- Strategic alignment: {{ALIGNMENT_SCORE}}%

## Month Overview

### Activity Timeline

```mermaid
gantt
    title {{MONTH}} {{YEAR}} Activity
    dateFormat  YYYY-MM-DD
    section Projects
    {{#EACH PROJECT_TIMELINE}}
    {{NAME}} :{{START}}, {{END}}
    {{/EACH}}
    section Decisions
    {{#EACH DECISION_TIMELINE}}
    {{NAME}} :milestone, {{DATE}}, 0d
    {{/EACH}}
```

### Weekly Breakdown

{{#EACH WEEK}}
#### Week {{WEEK_NUMBER}} ({{DATE_RANGE}})
- **Focus**: {{FOCUS}}
- **Output**: {{OUTPUT_SUMMARY}}
- **Key decision**: {{KEY_DECISION}}
{{/EACH}}

### Decisions Made

| Decision | Date | Category | Status | Link |
|----------|------|----------|--------|------|
{{#EACH DECISION}}
| {{TITLE}} | {{DATE}} | {{CATEGORY}} | {{STATUS}} | [[{{LINK}}]] |
{{/EACH}}

## Strategic Alignment Analysis

### Goals Assessment

{{#EACH GOAL}}
#### {{GOAL_NAME}}
**Alignment Score**: {{SCORE}}/10

**Progress This Month**:
{{PROGRESS_DESCRIPTION}}

**Evidence**:
{{#EACH EVIDENCE}}
- [[{{NOTE_ID}}]]: {{QUOTE}}
{{/EACH}}

**Gap to Target**:
{{GAP_DESCRIPTION}}

**Recommendations**:
{{#EACH RECOMMENDATION}}
- {{RECOMMENDATION}}
{{/EACH}}
{{/EACH}}

### Alignment Matrix

| Goal | Target | Current | Gap | Trend |
|------|--------|---------|-----|-------|
{{#EACH ALIGNMENT_ROW}}
| {{GOAL}} | {{TARGET}} | {{CURRENT}} | {{GAP}} | {{TREND}} |
{{/EACH}}

## Pattern Evolution

### Patterns Strengthened

{{#EACH STRENGTHENED_PATTERN}}
#### {{PATTERN_NAME}}
- **Start of month**: {{START_STRENGTH}} ({{START_COUNT}} notes)
- **End of month**: {{END_STRENGTH}} ({{END_COUNT}} notes)
- **Key developments**: {{DEVELOPMENTS}}
{{/EACH}}

### New Patterns Emerged

{{#EACH NEW_PATTERN}}
#### {{PATTERN_NAME}}
- **First observed**: Week {{FIRST_WEEK}}
- **Current strength**: {{STRENGTH}}
- **Significance**: {{SIGNIFICANCE}}
{{/EACH}}

### Patterns Weakening

{{#EACH WEAKENING_PATTERN}}
#### {{PATTERN_NAME}}
- **Concern**: {{CONCERN}}
- **Recommendation**: {{RECOMMENDATION}}
{{/EACH}}

## Knowledge Quality Assessment

### Quality Metrics

| Metric | Score | Target | Status |
|--------|-------|--------|--------|
| Connectivity | {{CONNECTIVITY_SCORE}} | 3.0+ | {{CONNECTIVITY_STATUS}} |
| Freshness | {{FRESHNESS_SCORE}} | 80%+ | {{FRESHNESS_STATUS}} |
| Completeness | {{COMPLETENESS_SCORE}} | 90%+ | {{COMPLETENESS_STATUS}} |
| Actionability | {{ACTIONABILITY_SCORE}} | 70%+ | {{ACTIONABILITY_STATUS}} |

### Quality Issues

{{#EACH QUALITY_ISSUE}}
#### {{ISSUE_TYPE}}: {{TITLE}}

**Description**: {{DESCRIPTION}}

**Affected Items**: {{AFFECTED_COUNT}} notes
{{#EACH EXAMPLES}}
- [[{{NOTE_ID}}]]: {{ISSUE}}
{{/EACH}}

**Resolution**: {{RESOLUTION}}

**Priority**: {{PRIORITY}}
{{/EACH}}

### Maintenance Completed

- Broken links fixed: {{LINKS_FIXED}}
- Orphans resolved: {{ORPHANS_RESOLVED}}
- Notes archived: {{NOTES_ARCHIVED}}
- Cross-references added: {{CROSS_REFS_ADDED}}

## Insights and Learnings

### Key Insights

{{#EACH INSIGHT}}
#### {{INDEX}}. {{TITLE}}

{{DESCRIPTION}}

**Source**: {{SOURCE}}
**Implications**: {{IMPLICATIONS}}
**Action taken**: {{ACTION}}
{{/EACH}}

### Lessons Learned

{{#EACH LESSON}}
- **{{CATEGORY}}**: {{LESSON}}
  - Context: {{CONTEXT}}
  - Future application: {{APPLICATION}}
{{/EACH}}

## Recommendations

### High Priority

{{#EACH HIGH_PRIORITY_REC}}
#### {{INDEX}}. {{TITLE}}

**Rationale**: {{RATIONALE}}

**Suggested approach**:
{{APPROACH}}

**Expected outcome**: {{OUTCOME}}

**Effort estimate**: {{EFFORT}}
{{/EACH}}

### Medium Priority

{{#EACH MEDIUM_PRIORITY_REC}}
- **{{TITLE}}**: {{DESCRIPTION}}
{{/EACH}}

### Low Priority

{{#EACH LOW_PRIORITY_REC}}
- {{TITLE}}: {{DESCRIPTION}}
{{/EACH}}

## Looking Ahead

### Next Month Focus

{{#EACH FOCUS_AREA}}
{{INDEX}}. **{{AREA}}**
   - Rationale: {{RATIONALE}}
   - Success criteria: {{CRITERIA}}
   - Dependencies: {{DEPENDENCIES}}
{{/EACH}}

### Scheduled Reviews

{{#EACH SCHEDULED_REVIEW}}
- {{DATE}}: {{DESCRIPTION}}
{{/EACH}}

### Questions to Explore

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

---
*Generated: {{TIMESTAMP}} by strategic-reviewer (Opus)*
*Execution time: {{EXECUTION_TIME}} seconds | Cost: ${{COST}}*
*Next review: {{NEXT_REVIEW}}*
```

## Data Structures

### Executive Summary Generation

```python
def generate_executive_summary(month_data):
    """Generate executive summary for monthly review."""

    summary_points = []

    # Activity summary
    activity = f"This month saw {month_data['notes_created']} new notes created "
    activity += f"across {len(month_data['active_projects'])} active projects. "
    summary_points.append(activity)

    # Decision summary
    decisions = month_data['decisions']
    if decisions:
        decision_summary = f"{len(decisions)} significant decisions were documented, "
        decision_summary += f"including {decisions[0]['title']}. "
        summary_points.append(decision_summary)

    # Pattern summary
    patterns = month_data['patterns']
    if patterns:
        strongest = patterns[0]
        pattern_summary = f"The strongest emerging pattern was '{strongest['name']}' "
        pattern_summary += f"with {strongest['occurrences']} supporting observations. "
        summary_points.append(pattern_summary)

    # Strategic alignment
    alignment = calculate_alignment_score(month_data)
    if alignment >= 80:
        alignment_summary = f"Strategic alignment is strong at {alignment}%. "
    elif alignment >= 60:
        alignment_summary = f"Strategic alignment is moderate at {alignment}%, "
        alignment_summary += "with opportunities for improvement. "
    else:
        alignment_summary = f"Strategic alignment needs attention at {alignment}%. "
    summary_points.append(alignment_summary)

    return ' '.join(summary_points)
```

### Strategic Alignment Assessment

```python
def assess_strategic_alignment(knowledge_base, goals):
    """Assess alignment between work and stated goals."""

    alignment_results = []

    for goal in goals:
        # Find notes related to this goal
        related_notes = find_notes_by_goal(knowledge_base, goal)

        # Calculate alignment score
        score = calculate_goal_alignment_score(goal, related_notes)

        # Gather evidence
        evidence = []
        for note in related_notes[:3]:
            evidence.append({
                'note_id': note.id,
                'quote': extract_relevant_quote(note, goal)
            })

        # Assess gap
        gap = assess_goal_gap(goal, score)

        # Generate recommendations
        recommendations = generate_goal_recommendations(goal, score, gap)

        alignment_results.append({
            'goal_name': goal.name,
            'score': score,
            'progress_description': summarize_progress(related_notes),
            'evidence': evidence,
            'gap_description': gap,
            'recommendations': recommendations
        })

    return alignment_results
```

### Quality Assessment

```python
def assess_knowledge_quality(knowledge_base):
    """Assess quality metrics for knowledge base."""

    quality = {}

    # Connectivity: Average references per note
    graph = analyze_graph(knowledge_base)
    quality['connectivity'] = {
        'score': graph['average_connectivity'],
        'target': 3.0,
        'status': 'Good' if graph['average_connectivity'] >= 3.0 else 'Needs improvement'
    }

    # Freshness: Percentage of notes updated in last 90 days
    recent = count_recent_notes(knowledge_base, days=90)
    total = count_all_notes(knowledge_base)
    freshness_pct = (recent / total) * 100 if total > 0 else 0
    quality['freshness'] = {
        'score': freshness_pct,
        'target': 80,
        'status': 'Good' if freshness_pct >= 80 else 'Needs improvement'
    }

    # Completeness: Notes with required fields filled
    complete = count_complete_notes(knowledge_base)
    completeness_pct = (complete / total) * 100 if total > 0 else 0
    quality['completeness'] = {
        'score': completeness_pct,
        'target': 90,
        'status': 'Good' if completeness_pct >= 90 else 'Needs improvement'
    }

    # Actionability: Notes with clear next steps or actions
    actionable = count_actionable_notes(knowledge_base)
    actionability_pct = (actionable / total) * 100 if total > 0 else 0
    quality['actionability'] = {
        'score': actionability_pct,
        'target': 70,
        'status': 'Good' if actionability_pct >= 70 else 'Needs improvement'
    }

    return quality
```

## Example Output

```markdown
# Monthly Review - January 2026

## Executive Summary

This month saw 45 new notes created across 4 active projects. 8 significant decisions were documented, including the Frontend Lead Hiring decision. The strongest emerging pattern was 'Async-First Communication' with 12 supporting observations. Strategic alignment is strong at 82%.

**Key Metrics**:
- Knowledge items: 156 (+45 this month)
- Decisions documented: 8
- Patterns identified: 6
- Strategic alignment: 82%

## Month Overview

### Weekly Breakdown

#### Week 1 (Jan 1-5)
- **Focus**: Q1 planning kickoff
- **Output**: 12 notes, 2 decisions
- **Key decision**: Sprint cadence (2-week sprints)

#### Week 2 (Jan 6-12)
- **Focus**: Hiring process development
- **Output**: 15 notes, 3 decisions
- **Key decision**: Frontend lead hire approved

#### Week 3 (Jan 13-19)
- **Focus**: Marketing experiment launch
- **Output**: 10 notes, 2 decisions
- **Key decision**: Reddit community engagement test

#### Week 4 (Jan 20-26)
- **Focus**: Q1 OKR finalization
- **Output**: 8 notes, 1 decision
- **Key decision**: Q1 OKRs locked

### Decisions Made

| Decision | Date | Category | Status | Link |
|----------|------|----------|--------|------|
| Sprint Cadence | Jan 3 | Process | Active | [[DEC-2026-001]] |
| Hiring Budget | Jan 8 | Finance | Active | [[DEC-2026-002]] |
| Frontend Lead Hire | Jan 10 | Hiring | In Progress | [[DEC-2026-003]] |
| Marketing Experiment | Jan 15 | Marketing | Active | [[DEC-2026-004]] |

## Strategic Alignment Analysis

### Goals Assessment

#### Improve Team Velocity
**Alignment Score**: 8/10

**Progress This Month**:
Implemented 2-week sprint cadence and async standups. Team velocity baseline established.

**Evidence**:
- [[2026-01-050]]: "Async standups save 7.5 hours/week"
- [[DEC-2026-001]]: "2-week sprints provide faster feedback"
- [[PLAY-velocity-tracking]]: "Established velocity measurement"

**Gap to Target**:
Need to implement velocity tracking dashboard and burndown charts.

**Recommendations**:
- Create velocity dashboard in project tools
- Document sprint retrospective process
- Establish velocity targets per team

### Alignment Matrix

| Goal | Target | Current | Gap | Trend |
|------|--------|---------|-----|-------|
| Team Velocity | 50 pts/sprint | 42 pts | -8 | Improving |
| Documentation Coverage | 90% | 78% | -12% | Stable |
| Decision Latency | <3 days | 4.2 days | +1.2 days | Improving |
| Knowledge Freshness | 80% | 72% | -8% | Stable |

## Knowledge Quality Assessment

### Quality Metrics

| Metric | Score | Target | Status |
|--------|-------|--------|--------|
| Connectivity | 2.71 | 3.0+ | Needs improvement |
| Freshness | 72% | 80%+ | Needs improvement |
| Completeness | 94% | 90%+ | Good |
| Actionability | 68% | 70%+ | Near target |

### Quality Issues

#### Low Connectivity: Orphaned Decision Notes

**Description**: Several decision notes lack backlinks from context notes.

**Affected Items**: 4 notes
- [[DEC-2026-002]]: No links from project context
- [[DEC-2026-004]]: Missing link from marketing strategy

**Resolution**: Add decision references to relevant map notes and project indexes.

**Priority**: Medium

## Recommendations

### High Priority

#### 1. Create Velocity Tracking Dashboard

**Rationale**: Velocity goal at 84% of target but no tracking system.

**Suggested approach**:
Document velocity metrics in [[PLAY-velocity-tracking]] and create simple tracking spreadsheet or integrate with project tools.

**Expected outcome**: Clear visibility into velocity trends and bottlenecks.

**Effort estimate**: 4 hours

### Medium Priority

- **Add decision backlinks**: Ensure all decisions linked from context notes
- **Update stale documentation**: Refresh 12 notes older than 90 days
- **Create async-first playbook**: Codify emerging async patterns

---
*Generated: 2026-02-01T05:00:00-08:00 by strategic-reviewer (Opus)*
*Execution time: 120 seconds | Cost: $2.45*
*Next review: 2026-03-01*
```

## Configuration Options

```yaml
rhythms:
  monthly:
    enabled: true
    day: 1
    hour: 5
    minute: 0

    include:
      executive_summary: true
      activity_timeline: true
      strategic_alignment: true
      pattern_evolution: true
      quality_assessment: true
      recommendations: true
      looking_ahead: true

    alignment:
      goals_source: ".kaaos/goals.yaml"  # Path to goals definition
      min_score_warn: 60  # Warn if alignment below this

    quality:
      connectivity_target: 3.0
      freshness_target: 80
      completeness_target: 90
      actionability_target: 70
```

## Related Templates

- [[daily-digest.md]] - Daily activity summary
- [[weekly-digest.md]] - Weekly pattern synthesis
- [[quarterly-digest.md]] - Quarterly comprehensive analysis

---

*Part of KAAOS Operational Rhythms*
