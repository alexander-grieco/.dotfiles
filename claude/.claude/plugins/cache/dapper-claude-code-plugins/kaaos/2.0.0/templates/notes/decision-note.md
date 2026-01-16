---
template: decision-note
version: "1.0"
description: Template for documenting decisions
usage: Record decisions with context, rationale, alternatives, and review criteria
placeholders:
  - "{{DECISION_ID}}" - Unique identifier (e.g., "DEC-2026-003")
  - "{{TITLE}}" - Decision title
  - "{{DATE}}" - Decision date
  - "{{DOMAIN}}" - Domain (hiring, strategy, technical, etc.)
---

# Decision Note Template

Decision notes capture important decisions with their context, rationale, alternatives considered, and criteria for future review. Good decision documentation enables learning from outcomes and provides precedent for similar future decisions.

## Template Structure

```markdown
---
id: {{DECISION_ID}}
title: {{TITLE}}
type: decision
date: {{DATE}}
domain: {{DOMAIN}}
status: proposed | decided | implemented | reviewed | superseded
decision_maker: {{DECISION_MAKER}}
stakeholders: {{STAKEHOLDERS}}
reversibility: one-way | two-way
magnitude: strategic | tactical | operational
confidence: high | medium | low
review_date: {{REVIEW_DATE}}
superseded_by: {{SUPERSEDED_BY}}
---

# {{TITLE}}

## Decision Summary

**Decision**: {{ONE_LINE_DECISION}}

**Date**: {{DATE}}
**Decision Maker**: {{DECISION_MAKER}}
**Status**: {{STATUS}}

## Context

### Background

{{BACKGROUND}}

*What situation or need prompted this decision?*

### Trigger

{{TRIGGER}}

*What specific event or deadline forced this decision now?*

### Constraints

{{#EACH CONSTRAINT}}
- **{{CONSTRAINT_TYPE}}**: {{DESCRIPTION}}
{{/EACH}}

### Key Stakeholders

| Stakeholder | Role | Interest |
|-------------|------|----------|
{{#EACH STAKEHOLDER}}
| {{NAME}} | {{ROLE}} | {{INTEREST}} |
{{/EACH}}

## The Decision

### What We Decided

{{DETAILED_DECISION}}

### Rationale

{{RATIONALE}}

*Why did we choose this option?*

### Key Arguments For

{{#EACH ARGUMENT_FOR}}
- {{ARGUMENT}}
{{/EACH}}

### Key Arguments Against

{{#EACH ARGUMENT_AGAINST}}
- {{ARGUMENT}}
{{/EACH}}

## Alternatives Considered

### Option A: {{OPTION_A_NAME}} (Chosen)

**Description**: {{OPTION_A_DESCRIPTION}}

**Pros**:
{{#EACH OPTION_A_PROS}}
- {{PRO}}
{{/EACH}}

**Cons**:
{{#EACH OPTION_A_CONS}}
- {{CON}}
{{/EACH}}

### Option B: {{OPTION_B_NAME}}

**Description**: {{OPTION_B_DESCRIPTION}}

**Pros**:
{{#EACH OPTION_B_PROS}}
- {{PRO}}
{{/EACH}}

**Cons**:
{{#EACH OPTION_B_CONS}}
- {{CON}}
{{/EACH}}

**Why not chosen**: {{WHY_NOT_B}}

### Option C: {{OPTION_C_NAME}}

{{OPTION_C_CONTENT}}

**Why not chosen**: {{WHY_NOT_C}}

## Analysis Framework

### Framework Used

{{FRAMEWORK_NAME}} (see [[{{FRAMEWORK_LINK}}]])

{{FRAMEWORK_APPLICATION}}

### Reversibility Assessment

**Type**: {{REVERSIBILITY_TYPE}}
**Reasoning**: {{REVERSIBILITY_REASONING}}

{{#IF ONE_WAY}}
**Irreversibility factors**:
{{#EACH IRREVERSIBILITY_FACTOR}}
- {{FACTOR}}
{{/EACH}}
{{/IF}}

{{#IF TWO_WAY}}
**Reversal cost**: {{REVERSAL_COST}}
**Reversal timeline**: {{REVERSAL_TIMELINE}}
{{/IF}}

### Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
{{#EACH RISK}}
| {{RISK_NAME}} | {{LIKELIHOOD}} | {{IMPACT}} | {{MITIGATION}} |
{{/EACH}}

## Implementation

### Immediate Actions

{{#EACH IMMEDIATE_ACTION}}
- [ ] {{ACTION}} (Owner: {{OWNER}}, Due: {{DUE_DATE}})
{{/EACH}}

### Timeline

| Milestone | Target Date | Status |
|-----------|-------------|--------|
{{#EACH MILESTONE}}
| {{NAME}} | {{DATE}} | {{STATUS}} |
{{/EACH}}

### Success Criteria

{{#EACH SUCCESS_CRITERION}}
- {{CRITERION}}
{{/EACH}}

### Resources Required

{{#EACH RESOURCE}}
- **{{RESOURCE_TYPE}}**: {{DESCRIPTION}}
{{/EACH}}

## Review Plan

### Review Schedule

| Review | Date | Focus |
|--------|------|-------|
{{#EACH REVIEW}}
| {{TYPE}} | {{DATE}} | {{FOCUS}} |
{{/EACH}}

### Key Questions for Review

{{#EACH REVIEW_QUESTION}}
- {{QUESTION}}
{{/EACH}}

### Metrics to Track

| Metric | Baseline | Target | Current |
|--------|----------|--------|---------|
{{#EACH METRIC}}
| {{NAME}} | {{BASELINE}} | {{TARGET}} | {{CURRENT}} |
{{/EACH}}

### Reversal Triggers

If any of the following occur, reconsider this decision:

{{#EACH TRIGGER}}
- {{TRIGGER}}
{{/EACH}}

## Related Decisions

### Depends On
{{#EACH DEPENDENCY}}
- [[{{DECISION_ID}}]]: {{RELATIONSHIP}}
{{/EACH}}

### Enables
{{#EACH ENABLES}}
- [[{{DECISION_ID}}]]: {{RELATIONSHIP}}
{{/EACH}}

### Related Context
{{#EACH CONTEXT}}
- [[{{NOTE_ID}}]]: {{RELEVANCE}}
{{/EACH}}

## Appendix

### Discussion Log

{{#EACH DISCUSSION}}
- **{{DATE}}** ({{PARTICIPANTS}}): {{SUMMARY}}
{{/EACH}}

### Reference Materials

{{#EACH REFERENCE}}
- {{REFERENCE}}
{{/EACH}}

---
*Documented by: {{DOCUMENTER}}*
*Last updated: {{LAST_UPDATED}}*
```

## Example: Completed Decision Note

```markdown
---
id: DEC-2026-003
title: Hire Frontend Lead
type: decision
date: 2026-01-10
domain: hiring
status: implemented
decision_maker: VP Engineering
stakeholders: [CEO, Frontend Team, Product]
reversibility: two-way
magnitude: strategic
confidence: high
review_date: 2026-04-10
superseded_by: null
---

# Hire Frontend Lead

## Decision Summary

**Decision**: Hire a senior Frontend Lead to build and lead a frontend team, with a budget of $140-160K base salary plus equity.

**Date**: 2026-01-10
**Decision Maker**: VP Engineering
**Status**: Implemented (candidate accepted)

## Context

### Background

Our frontend codebase has grown significantly over the past year. We currently have 3 frontend developers but no dedicated technical leadership. Architecture decisions are ad-hoc, code quality varies, and we're accumulating technical debt. The team needs a leader who can establish standards, mentor developers, and drive architectural decisions.

### Trigger

Two factors made this decision urgent:
1. Q1 product roadmap requires significant frontend work
2. One of our frontend developers indicated potential departure without growth path

### Constraints

- **Budget**: Approved headcount in 2026 plan, but need to fit compensation guidelines
- **Timeline**: Ideal to have someone started by end of Q1
- **Market**: Senior frontend talent is competitive; may need to be flexible on remote
- **Team**: Current team needs to buy in; they'll report to this person

### Key Stakeholders

| Stakeholder | Role | Interest |
|-------------|------|----------|
| VP Engineering | Decision maker | Team structure, technical quality |
| CEO | Approver | Budget, strategic fit |
| Frontend Team | Affected party | Career growth, management quality |
| Product | Customer | Frontend delivery speed, quality |

## The Decision

### What We Decided

Hire a Frontend Lead with the following profile:
- 7+ years frontend experience, 2+ years leading teams
- Strong React/TypeScript expertise
- Experience scaling frontend architecture
- Proven ability to mentor developers

Compensation: $140-160K base + 0.1% equity
Location: Remote-first (US time zones preferred)
Start date: Target February 2026

### Rationale

The frontend team is at a critical inflection point. Without leadership, we risk:
- Continued technical debt accumulation
- Departure of existing talent
- Slower feature delivery
- Inconsistent user experience

A dedicated Frontend Lead addresses all these concerns while enabling future team growth.

### Key Arguments For

- Team is ready for dedicated technical leadership
- Budget is approved and competitive
- Clear ROI: improved velocity and quality
- Retention signal to existing team

### Key Arguments Against

- Could promote from within (but no one ready)
- Economic uncertainty (but need is real regardless)
- Remote management adds complexity (mitigated by async practices)

## Alternatives Considered

### Option A: Hire Frontend Lead (Chosen)

**Description**: External hire for dedicated Frontend Lead role.

**Pros**:
- Brings outside perspective and best practices
- Immediate impact on architecture decisions
- Clear career path for existing team
- Dedicated bandwidth for leadership

**Cons**:
- Onboarding time (3-6 months to full effectiveness)
- Cultural integration risk
- Higher cost than internal promotion
- External hire may not fit team culture

### Option B: Promote from Within

**Description**: Promote senior frontend developer to lead role.

**Pros**:
- Already knows codebase and culture
- Lower cost (smaller salary bump)
- Faster to productive
- Good retention signal

**Cons**:
- No current candidate ready for leadership
- Would require significant coaching investment
- May not bring needed outside perspective
- Creates gap in IC capacity

**Why not chosen**: No internal candidate has both the technical depth and leadership readiness required. Promoting prematurely would set them up for failure.

### Option C: Use Engineering Manager

**Description**: Existing Engineering Manager adds frontend to responsibilities.

**Pros**:
- No new hire required
- Already integrated into team
- Immediate availability

**Cons**:
- EM already at capacity
- Lacks frontend-specific expertise
- Would be a stretch assignment
- Delays establishing proper frontend leadership

**Why not chosen**: Would compromise both EM effectiveness and frontend team needs.

## Analysis Framework

### Framework Used

Two-Way Door Analysis (see [[2026-01-020|Two-Way Door Thinking]])

This is a "two-way door" decision because:
- We can undo within 90 days if hire doesn't work out
- Severance cost is manageable
- Team can operate without role (less efficiently)

However, we should decide quickly because:
- Delay costs us Q1 execution
- Competitive market moves fast
- Team morale affected by uncertainty

### Reversibility Assessment

**Type**: Two-way door
**Reasoning**: While not trivial to reverse, we can exit the hire within probationary period if not working out. The cost of reversal (severance, restart search) is significant but manageable.

**Reversal cost**: ~$50K (severance, recruiting restart)
**Reversal timeline**: 90 days to identify, 30 days to exit

### Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Candidate not culture fit | Medium | High | Thorough values interview |
| Technical skills oversold | Low | High | Work sample evaluation |
| Offer rejected | Medium | Medium | Competitive offer, quick process |
| Team resistance | Low | Medium | Involve team in interviews |
| Slow ramp-up | Medium | Medium | 90-day onboarding plan |

## Implementation

### Immediate Actions

- [x] Post job description (Owner: Recruiting, Due: Jan 11)
- [x] Set up interview panel (Owner: VP Eng, Due: Jan 12)
- [x] Screen initial candidates (Owner: Recruiting, Due: Jan 15)
- [x] Conduct interviews (Owner: Panel, Due: Jan 18)
- [x] Make offer (Owner: VP Eng, Due: Jan 19)
- [ ] Begin onboarding prep (Owner: VP Eng, Due: Feb 1)

### Timeline

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| Job posted | Jan 11 | Complete |
| Interviews complete | Jan 18 | Complete |
| Offer extended | Jan 19 | Complete |
| Offer accepted | Jan 20 | Complete |
| Start date | Feb 3 | Scheduled |
| 30-day check-in | Mar 3 | Pending |
| 90-day review | May 3 | Pending |

### Success Criteria

- Frontend technical debt addressed within 6 months
- Team velocity improved by 20% within 6 months
- Zero unwanted departures from frontend team
- Architecture documentation created within 90 days
- At least one junior developer successfully mentored

### Resources Required

- **Budget**: $140-160K salary + equity + benefits
- **Recruiting**: Internal recruiting team bandwidth
- **Onboarding**: VP Eng time for first 90 days
- **Equipment**: Standard new hire equipment package

## Review Plan

### Review Schedule

| Review | Date | Focus |
|--------|------|-------|
| 30-day | Mar 3 | Integration, initial observations |
| 90-day | May 3 | Full review, confirm continuation |
| 6-month | Aug 3 | Impact assessment |

### Key Questions for Review

- Is the hire meeting technical expectations?
- How is the team responding to new leadership?
- Is technical debt being addressed?
- Are architectural decisions improving?
- Is the hire exhibiting our values?

### Metrics to Track

| Metric | Baseline | Target | Current |
|--------|----------|--------|---------|
| Frontend velocity | 42 pts/sprint | 50 pts/sprint | - |
| Tech debt items | 47 | 30 | - |
| Code review turnaround | 48 hours | 24 hours | - |
| Team NPS | 7.2 | 8.0+ | - |

### Reversal Triggers

If any of the following occur, reconsider this decision:

- 30-day review reveals fundamental culture mismatch
- Team expresses strong concerns about leadership style
- Technical decisions consistently questioned by team
- Hire unable to articulate architectural vision by 90 days

## Related Decisions

### Depends On
- [[DEC-2025-015|Engineering Team Structure]]: This hire fits 2026 team plan
- [[DEC-2025-022|Remote Work Policy]]: Remote-first enables broader search

### Enables
- [[DEC-2026-004|Frontend Architecture Refresh]]: New lead will drive this
- Future decision: Frontend team expansion

### Related Context
- [[2026-01-055|Work Samples Predict Success]]: Informed evaluation process
- [[PLAY-hiring-process]]: Used this playbook
- [[MAP-team-structure]]: Frontend lead fits here

## Appendix

### Discussion Log

- **Jan 8** (VP Eng, CEO): Initial discussion, budget approval
- **Jan 9** (VP Eng, Frontend Team): Team input on role requirements
- **Jan 10** (VP Eng, HR): Finalized compensation range
- **Jan 18** (Interview Panel): Debrief, unanimous hire recommendation

### Reference Materials

- Job description: [internal link]
- Interview rubric: [[hiring-rubric-engineering]]
- Compensation benchmark: [internal link]

---
*Documented by: VP Engineering*
*Last updated: 2026-01-20*
```

## Decision Classification

### Reversibility

| Type | Definition | Decision Speed | Documentation Depth |
|------|------------|----------------|---------------------|
| **One-way** | Cannot be undone | Slower, thorough | Comprehensive |
| **Two-way** | Can be reversed | Faster, decisive | Moderate |

### Magnitude

| Level | Scope | Typical Examples |
|-------|-------|------------------|
| **Strategic** | Organization-wide, long-term | Funding, market entry, pivots |
| **Tactical** | Team/department, medium-term | Hires, tool selection, process changes |
| **Operational** | Day-to-day, short-term | Sprint priorities, minor policies |

## Decision Workflow

```python
def document_decision(decision_context):
    """Document a decision with appropriate depth."""

    # Assess magnitude and reversibility
    magnitude = assess_magnitude(decision_context)
    reversibility = assess_reversibility(decision_context)

    # Determine documentation depth
    if magnitude == 'strategic' or reversibility == 'one-way':
        depth = 'comprehensive'  # Full template
    elif magnitude == 'tactical':
        depth = 'standard'       # Core sections
    else:
        depth = 'minimal'        # Summary only

    # Generate decision ID
    decision_id = generate_decision_id()  # DEC-YYYY-NNN

    # Create decision document
    decision = {
        'id': decision_id,
        'type': 'decision',
        'magnitude': magnitude,
        'reversibility': reversibility,
        'documentation_depth': depth,
        # ... rest of fields based on depth
    }

    return decision
```

## Review Process

### Types of Review

| Review | Timing | Purpose |
|--------|--------|---------|
| **Check-in** | 30 days | Early course correction |
| **Full Review** | 90 days | Comprehensive assessment |
| **Annual** | 12 months | Long-term impact |
| **Triggered** | As needed | Response to reversal triggers |

### Review Questions

1. Did the decision achieve its intended outcomes?
2. Were the assumptions accurate?
3. What unexpected consequences occurred?
4. Would we make the same decision today?
5. What did we learn for future similar decisions?

## Related Templates

- [[atomic-note.md]] - Context notes for decisions
- [[playbook-note.md]] - Processes that enable decisions
- [[synthesis-note.md]] - Learnings from decision outcomes

---

*Part of KAAOS Knowledge Management Templates*
