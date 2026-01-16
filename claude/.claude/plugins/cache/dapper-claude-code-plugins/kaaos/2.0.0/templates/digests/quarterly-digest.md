---
template: quarterly-digest
version: "1.0"
description: Template for automated quarterly comprehensive analysis
usage: Used by parallel strategic agents for quarterly deep analysis
placeholders:
  - "{{QUARTER}}" - Quarter identifier (e.g., "Q1")
  - "{{YEAR}}" - Year (e.g., "2026")
  - "{{QUARTER_ID}}" - Full identifier (e.g., "2026-Q1")
  - "{{TIMESTAMP}}" - Generation timestamp (ISO-8601)
  - "{{EXECUTION_TIME}}" - Time to generate in seconds
  - "{{COST}}" - API cost for generation
  - "{{AGENT_COUNT}}" - Number of parallel agents used
---

# Quarterly Digest Template

This template defines the structure for automated quarterly comprehensive analysis. Multiple parallel agents collaborate to produce a thorough strategic review covering knowledge evolution, pattern maturation, strategic alignment, and forward planning.

## Parallel Agent Architecture

The quarterly review uses 6 parallel specialist agents:

| Agent | Role | Focus Area |
|-------|------|------------|
| **Pattern Analyst** | Pattern detection & evolution | Track pattern maturation, identify new patterns |
| **Strategic Reviewer** | Goal alignment | Assess progress toward strategic objectives |
| **Knowledge Auditor** | Quality & completeness | Audit knowledge base health |
| **Gap Detector** | Missing knowledge | Identify critical knowledge gaps |
| **Trend Forecaster** | Future planning | Project trends and recommend focus |
| **Synthesizer** | Integration | Combine all analyses into cohesive report |

## Template Output

```markdown
# Quarterly Review - {{QUARTER}} {{YEAR}}
*{{QUARTER_START}} - {{QUARTER_END}}*

---

## Executive Summary

{{EXECUTIVE_SUMMARY}}

### Quarter Highlights
{{#EACH HIGHLIGHT}}
- {{ICON}} **{{TITLE}}**: {{DESCRIPTION}}
{{/EACH}}

### Key Metrics Dashboard

| Category | Start of Q | End of Q | Change | Target | Status |
|----------|------------|----------|--------|--------|--------|
| Knowledge Items | {{START_NOTES}} | {{END_NOTES}} | {{NOTES_CHANGE}} | {{NOTES_TARGET}} | {{NOTES_STATUS}} |
| Cross-References | {{START_REFS}} | {{END_REFS}} | {{REFS_CHANGE}} | {{REFS_TARGET}} | {{REFS_STATUS}} |
| Decisions | {{START_DECISIONS}} | {{END_DECISIONS}} | {{DECISIONS_CHANGE}} | - | {{DECISIONS_STATUS}} |
| Patterns | {{START_PATTERNS}} | {{END_PATTERNS}} | {{PATTERNS_CHANGE}} | - | {{PATTERNS_STATUS}} |
| Playbooks | {{START_PLAYBOOKS}} | {{END_PLAYBOOKS}} | {{PLAYBOOKS_CHANGE}} | {{PLAYBOOKS_TARGET}} | {{PLAYBOOKS_STATUS}} |

### Strategic Alignment Summary
{{ALIGNMENT_SUMMARY}}

---

## Part 1: Pattern Analysis
*Analysis by Pattern Analyst Agent*

### Pattern Evolution Matrix

| Pattern | Q-1 Status | Current Status | Trajectory | Recommendation |
|---------|------------|----------------|------------|----------------|
{{#EACH PATTERN_ROW}}
| {{NAME}} | {{PREV_STATUS}} | {{CURRENT_STATUS}} | {{TRAJECTORY}} | {{REC}} |
{{/EACH}}

### Mature Patterns (Established)

{{#EACH MATURE_PATTERN}}
#### {{PATTERN_NAME}}
**Status**: Mature | **Evidence**: {{EVIDENCE_COUNT}} notes | **Confidence**: {{CONFIDENCE}}%

**Definition**:
{{DEFINITION}}

**Key Supporting Notes**:
{{#EACH SUPPORTING_NOTES}}
- [[{{NOTE_ID}}|{{TITLE}}]]: {{RELEVANCE}}
{{/EACH}}

**Impact Assessment**:
{{IMPACT}}

**Maintenance Notes**:
{{MAINTENANCE}}
{{/EACH}}

### Emerging Patterns (Watch)

{{#EACH EMERGING_PATTERN}}
#### {{PATTERN_NAME}}
**Status**: Emerging | **First Seen**: {{FIRST_SEEN}} | **Growth**: {{GROWTH}}

**Early Evidence**:
{{#EACH EVIDENCE}}
- [[{{NOTE_ID}}]]: "{{QUOTE}}"
{{/EACH}}

**Potential Significance**: {{SIGNIFICANCE}}

**Recommended Action**: {{ACTION}}
{{/EACH}}

### Declining Patterns

{{#EACH DECLINING_PATTERN}}
#### {{PATTERN_NAME}}
**Status**: Declining | **Reason**: {{REASON}}

**Action**: {{ACTION}}
{{/EACH}}

---

## Part 2: Strategic Alignment
*Analysis by Strategic Reviewer Agent*

### OKR/Goal Progress

{{#EACH OBJECTIVE}}
#### Objective: {{OBJECTIVE_NAME}}

**Overall Progress**: {{PROGRESS}}%

| Key Result | Target | Actual | Status |
|------------|--------|--------|--------|
{{#EACH KEY_RESULT}}
| {{KR_NAME}} | {{TARGET}} | {{ACTUAL}} | {{STATUS}} |
{{/EACH}}

**Supporting Work**:
{{#EACH SUPPORTING_WORK}}
- [[{{NOTE_ID}}]]: {{CONTRIBUTION}}
{{/EACH}}

**Gaps Identified**:
{{#EACH GAP}}
- {{GAP_DESCRIPTION}}
{{/EACH}}

**Recommendations**:
{{RECOMMENDATIONS}}
{{/EACH}}

### Strategic Initiative Status

| Initiative | Owner | Start | Target End | Progress | Risk |
|------------|-------|-------|------------|----------|------|
{{#EACH INITIATIVE}}
| {{NAME}} | {{OWNER}} | {{START}} | {{END}} | {{PROGRESS}}% | {{RISK}} |
{{/EACH}}

### Alignment Heatmap

```
                        Knowledge  Decisions  Patterns  Playbooks
Strategic Goal 1    ████████████  ████████   █████     ████████
Strategic Goal 2    ████████      ████████   ██████    ███████
Strategic Goal 3    ██████████    ██████     ████████  ████
Strategic Goal 4    █████         ████████   ███████   ██████████

Legend: ████ Strong (80-100%)  ████ Good (60-79%)  ████ Weak (40-59%)  ████ Gap (<40%)
```

---

## Part 3: Knowledge Quality Audit
*Analysis by Knowledge Auditor Agent*

### Quality Scorecard

| Dimension | Score | Grade | Trend | Notes |
|-----------|-------|-------|-------|-------|
| Connectivity | {{CONN_SCORE}}/100 | {{CONN_GRADE}} | {{CONN_TREND}} | {{CONN_NOTES}} |
| Completeness | {{COMP_SCORE}}/100 | {{COMP_GRADE}} | {{COMP_TREND}} | {{COMP_NOTES}} |
| Freshness | {{FRESH_SCORE}}/100 | {{FRESH_GRADE}} | {{FRESH_TREND}} | {{FRESH_NOTES}} |
| Consistency | {{CONSIST_SCORE}}/100 | {{CONSIST_GRADE}} | {{CONSIST_TREND}} | {{CONSIST_NOTES}} |
| Actionability | {{ACTION_SCORE}}/100 | {{ACTION_GRADE}} | {{ACTION_TREND}} | {{ACTION_NOTES}} |
| **Overall** | **{{OVERALL_SCORE}}/100** | **{{OVERALL_GRADE}}** | {{OVERALL_TREND}} | |

### Knowledge Graph Analysis

```
Quarter Graph Evolution:

Start of Q:
  Nodes: {{START_NODES}} | Edges: {{START_EDGES}} | Density: {{START_DENSITY}}

End of Q:
  Nodes: {{END_NODES}} | Edges: {{END_EDGES}} | Density: {{END_DENSITY}}

Key Changes:
{{#EACH GRAPH_CHANGE}}
  - {{CHANGE_DESCRIPTION}}
{{/EACH}}
```

### Content Type Distribution

| Type | Count | % of Total | Change | Health |
|------|-------|------------|--------|--------|
| Atomic Notes | {{ATOMIC_COUNT}} | {{ATOMIC_PCT}}% | {{ATOMIC_CHANGE}} | {{ATOMIC_HEALTH}} |
| Map Notes | {{MAP_COUNT}} | {{MAP_PCT}}% | {{MAP_CHANGE}} | {{MAP_HEALTH}} |
| Decision Notes | {{DECISION_COUNT}} | {{DECISION_PCT}}% | {{DECISION_CHANGE}} | {{DECISION_HEALTH}} |
| Playbooks | {{PLAYBOOK_COUNT}} | {{PLAYBOOK_PCT}}% | {{PLAYBOOK_CHANGE}} | {{PLAYBOOK_HEALTH}} |
| Reference Notes | {{REF_COUNT}} | {{REF_PCT}}% | {{REF_CHANGE}} | {{REF_HEALTH}} |

### Quality Issues Requiring Attention

{{#EACH QUALITY_ISSUE}}
#### Issue {{INDEX}}: {{TITLE}}

**Severity**: {{SEVERITY}} | **Category**: {{CATEGORY}}

**Description**:
{{DESCRIPTION}}

**Affected Items**: {{AFFECTED_COUNT}}
{{#EACH EXAMPLES}}
- [[{{NOTE_ID}}]]: {{ISSUE}}
{{/EACH}}

**Resolution Plan**:
{{RESOLUTION}}

**Effort Estimate**: {{EFFORT}}
{{/EACH}}

---

## Part 4: Gap Analysis
*Analysis by Gap Detector Agent*

### Critical Knowledge Gaps

{{#EACH CRITICAL_GAP}}
#### Gap: {{TITLE}}

**Impact**: Critical | **Domain**: {{DOMAIN}}

**Description**:
{{DESCRIPTION}}

**Evidence of Gap**:
{{#EACH EVIDENCE}}
- {{CONTEXT}}: "{{QUOTE}}"
- Impact: {{IMPACT}}
{{/EACH}}

**Business Impact**:
{{BUSINESS_IMPACT}}

**Resolution Priority**: {{PRIORITY}}

**Suggested Resolution**:
{{RESOLUTION}}

**Dependencies**:
{{#EACH DEPENDENCY}}
- {{DEPENDENCY}}
{{/EACH}}
{{/EACH}}

### Moderate Gaps

{{#EACH MODERATE_GAP}}
- **{{TITLE}}** ({{DOMAIN}}): {{DESCRIPTION}}
  - Resolution: {{RESOLUTION}}
{{/EACH}}

### Gap Trend Analysis

| Quarter | Critical Gaps | Moderate Gaps | Resolved | Net Change |
|---------|--------------|---------------|----------|------------|
| {{PREV_Q2}} | {{PREV_Q2_CRIT}} | {{PREV_Q2_MOD}} | {{PREV_Q2_RES}} | {{PREV_Q2_NET}} |
| {{PREV_Q1}} | {{PREV_Q1_CRIT}} | {{PREV_Q1_MOD}} | {{PREV_Q1_RES}} | {{PREV_Q1_NET}} |
| {{CURR_Q}} | {{CURR_CRIT}} | {{CURR_MOD}} | {{CURR_RES}} | {{CURR_NET}} |

---

## Part 5: Trend Forecast
*Analysis by Trend Forecaster Agent*

### Predicted Trends for Next Quarter

{{#EACH PREDICTED_TREND}}
#### {{TREND_NAME}}
**Confidence**: {{CONFIDENCE}}% | **Impact**: {{IMPACT}}

**Prediction**:
{{PREDICTION}}

**Basis**:
{{#EACH BASIS}}
- {{BASIS_POINT}}
{{/EACH}}

**Implications**:
{{IMPLICATIONS}}

**Recommended Preparation**:
{{PREPARATION}}
{{/EACH}}

### Risk Forecast

| Risk | Likelihood | Impact | Mitigation | Owner |
|------|------------|--------|------------|-------|
{{#EACH RISK}}
| {{NAME}} | {{LIKELIHOOD}} | {{IMPACT}} | {{MITIGATION}} | {{OWNER}} |
{{/EACH}}

### Opportunity Forecast

{{#EACH OPPORTUNITY}}
- **{{TITLE}}**: {{DESCRIPTION}}
  - Window: {{WINDOW}}
  - Potential value: {{VALUE}}
  - Required investment: {{INVESTMENT}}
{{/EACH}}

---

## Part 6: Synthesis and Recommendations
*Analysis by Synthesizer Agent*

### Integrated Analysis

{{INTEGRATED_ANALYSIS}}

### Quarter Theme

**{{QUARTER_THEME}}**

{{THEME_EXPLANATION}}

### Top Recommendations

#### Priority 1: {{P1_TITLE}}

**Rationale**:
{{P1_RATIONALE}}

**Approach**:
{{P1_APPROACH}}

**Success Criteria**:
{{#EACH P1_CRITERIA}}
- {{CRITERION}}
{{/EACH}}

**Timeline**: {{P1_TIMELINE}}
**Effort**: {{P1_EFFORT}}
**Owner**: {{P1_OWNER}}

#### Priority 2: {{P2_TITLE}}

**Rationale**:
{{P2_RATIONALE}}

**Approach**:
{{P2_APPROACH}}

**Timeline**: {{P2_TIMELINE}}

#### Priority 3: {{P3_TITLE}}

**Rationale**:
{{P3_RATIONALE}}

**Approach**:
{{P3_APPROACH}}

**Timeline**: {{P3_TIMELINE}}

### Additional Recommendations

{{#EACH ADDITIONAL_REC}}
{{INDEX}}. **{{TITLE}}** ({{PRIORITY}}): {{DESCRIPTION}}
{{/EACH}}

---

## Next Quarter Planning

### Suggested OKRs

{{#EACH SUGGESTED_OKR}}
#### Objective: {{OBJECTIVE}}

**Rationale**: {{RATIONALE}}

Key Results:
{{#EACH KEY_RESULT}}
- {{KR}}
{{/EACH}}
{{/EACH}}

### Focus Areas

{{#EACH FOCUS_AREA}}
{{INDEX}}. **{{AREA}}**
   - Why: {{WHY}}
   - Target outcome: {{OUTCOME}}
   - Key activities: {{ACTIVITIES}}
{{/EACH}}

### Scheduled Reviews

| Date | Review Type | Focus | Notes |
|------|-------------|-------|-------|
{{#EACH SCHEDULED}}
| {{DATE}} | {{TYPE}} | {{FOCUS}} | {{NOTES}} |
{{/EACH}}

---

## Appendix

### Methodology

This quarterly review was generated using {{AGENT_COUNT}} parallel specialist agents:

| Agent | Model | Tokens | Cost |
|-------|-------|--------|------|
{{#EACH AGENT_STATS}}
| {{NAME}} | {{MODEL}} | {{TOKENS}} | ${{COST}} |
{{/EACH}}
| **Total** | - | {{TOTAL_TOKENS}} | ${{TOTAL_COST}} |

**Execution Time**: {{EXECUTION_TIME}} seconds
**Generated**: {{TIMESTAMP}}

### Data Sources

- Knowledge base: {{REPO_PATH}}
- Notes analyzed: {{NOTES_ANALYZED}}
- Time range: {{QUARTER_START}} to {{QUARTER_END}}
- Previous quarters referenced: {{QUARTERS_REFERENCED}}

### Confidence Intervals

| Analysis | Confidence | Factors |
|----------|------------|---------|
| Pattern Analysis | {{PATTERN_CONFIDENCE}}% | {{PATTERN_FACTORS}} |
| Strategic Alignment | {{ALIGN_CONFIDENCE}}% | {{ALIGN_FACTORS}} |
| Gap Detection | {{GAP_CONFIDENCE}}% | {{GAP_FACTORS}} |
| Trend Forecast | {{TREND_CONFIDENCE}}% | {{TREND_FACTORS}} |

---
*Generated: {{TIMESTAMP}}*
*Total execution: {{EXECUTION_TIME}} seconds*
*Total cost: ${{COST}}*
*Next quarterly review: {{NEXT_REVIEW}}*
```

## Parallel Agent Orchestration

```python
def run_quarterly_review(knowledge_base, config):
    """Orchestrate parallel quarterly review agents."""

    # Initialize agents
    agents = [
        PatternAnalystAgent(model='opus'),
        StrategicReviewerAgent(model='opus'),
        KnowledgeAuditorAgent(model='sonnet'),
        GapDetectorAgent(model='sonnet'),
        TrendForecasterAgent(model='sonnet'),
        SynthesizerAgent(model='opus')
    ]

    # Phase 1: Data gathering (parallel)
    with ThreadPoolExecutor(max_workers=config.max_parallel) as executor:
        data_futures = {
            agent.name: executor.submit(agent.gather_data, knowledge_base)
            for agent in agents[:5]  # All except synthesizer
        }

        gathered_data = {
            name: future.result()
            for name, future in data_futures.items()
        }

    # Phase 2: Analysis (parallel)
    with ThreadPoolExecutor(max_workers=config.max_parallel) as executor:
        analysis_futures = {
            agent.name: executor.submit(agent.analyze, gathered_data[agent.name])
            for agent in agents[:5]
        }

        analyses = {
            name: future.result()
            for name, future in analysis_futures.items()
        }

    # Phase 3: Synthesis (sequential)
    synthesizer = agents[5]
    final_report = synthesizer.synthesize(analyses)

    # Track costs
    total_cost = sum(agent.cost for agent in agents)
    total_tokens = sum(agent.tokens for agent in agents)

    return {
        'report': final_report,
        'cost': total_cost,
        'tokens': total_tokens,
        'agent_stats': [
            {'name': a.name, 'model': a.model, 'tokens': a.tokens, 'cost': a.cost}
            for a in agents
        ]
    }
```

## Configuration Options

```yaml
rhythms:
  quarterly:
    enabled: true
    months: [1, 4, 7, 10]
    day: 1
    hour: 3
    minute: 0

    parallel_agents: true
    max_parallel: 6

    include:
      pattern_analysis: true
      strategic_alignment: true
      knowledge_audit: true
      gap_analysis: true
      trend_forecast: true
      synthesis: true
      next_quarter_planning: true

    models:
      pattern_analyst: opus
      strategic_reviewer: opus
      knowledge_auditor: sonnet
      gap_detector: sonnet
      trend_forecaster: sonnet
      synthesizer: opus

    cost_limits:
      max_total: 10.00
      per_agent: 2.00
```

## Typical Costs

| Component | Typical Cost | Range |
|-----------|--------------|-------|
| Pattern Analysis | $1.20 | $0.80-1.80 |
| Strategic Review | $1.50 | $1.00-2.00 |
| Knowledge Audit | $0.60 | $0.40-0.90 |
| Gap Detection | $0.70 | $0.50-1.00 |
| Trend Forecast | $0.80 | $0.60-1.20 |
| Synthesis | $1.80 | $1.20-2.50 |
| **Total** | **$6.60** | **$4.50-9.40** |

## Related Templates

- [[daily-digest.md]] - Daily activity summary
- [[weekly-digest.md]] - Weekly pattern synthesis
- [[monthly-digest.md]] - Monthly strategic review

---

*Part of KAAOS Operational Rhythms*
