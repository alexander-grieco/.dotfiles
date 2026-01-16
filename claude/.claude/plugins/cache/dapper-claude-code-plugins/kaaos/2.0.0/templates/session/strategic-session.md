---
template: strategic-session
version: "1.0"
description: Template for strategic planning and thinking sessions
usage: High-level planning, vision work, and strategic decision-making
duration: 2-4 hours
recommended_copilot: true
session_type: strategic
---

# Strategic Session Template

Strategic sessions are dedicated time for big-picture thinking: vision development, strategic planning, priority setting, and major decision-making. They differ from focus sessions by emphasizing breadth over depth and long-term over immediate.

## Session Structure

```markdown
# Strategic Session: {{SESSION_TITLE}}
*{{DATE}} | {{START_TIME}} - {{END_TIME}} | Duration: {{DURATION}}*

## Session Setup

### Strategic Context

**Horizon**: {{HORIZON}} (e.g., Q1 2026, 12 months, 3 years)

**Scope**: {{SCOPE}} (e.g., Company, Team, Product, Personal)

**Key Question**: {{KEY_QUESTION}}

### Objectives
{{#EACH OBJECTIVE}}
- {{OBJECTIVE}}
{{/EACH}}

### Context Loaded
{{#EACH CONTEXT_NOTE}}
- [[{{NOTE_ID}}]]: {{RELEVANCE}}
{{/EACH}}

### Current State Summary
{{CURRENT_STATE}}

---

## Strategic Analysis

### Environmental Scan

#### What's Changed
{{#EACH CHANGE}}
- **{{AREA}}**: {{CHANGE}}
{{/EACH}}

#### Implications
{{#EACH IMPLICATION}}
- {{IMPLICATION}}
{{/EACH}}

### SWOT Analysis (if applicable)

| Strengths | Weaknesses |
|-----------|------------|
{{#EACH STRENGTH}}| {{STRENGTH}} | {{WEAKNESS}} |{{/EACH}}

| Opportunities | Threats |
|---------------|---------|
{{#EACH OPPORTUNITY}}| {{OPPORTUNITY}} | {{THREAT}} |{{/EACH}}

### Key Tensions

{{#EACH TENSION}}
#### {{TENSION_NAME}}
**Trade-off**: {{TRADEOFF}}
**Current stance**: {{CURRENT_STANCE}}
**Consideration**: {{CONSIDERATION}}
{{/EACH}}

---

## Strategic Options

### Option A: {{OPTION_A_NAME}}

**Description**: {{DESCRIPTION_A}}

**Pros**:
{{#EACH PRO_A}}
- {{PRO}}
{{/EACH}}

**Cons**:
{{#EACH CON_A}}
- {{CON}}
{{/EACH}}

**Resource Requirements**: {{RESOURCES_A}}

**Risk Assessment**: {{RISK_A}}

### Option B: {{OPTION_B_NAME}}

{{OPTION_B_CONTENT}}

### Option C: {{OPTION_C_NAME}}

{{OPTION_C_CONTENT}}

---

## Decision Framework

### Evaluation Criteria

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
{{#EACH CRITERION}}
| {{NAME}} | {{WEIGHT}} | {{SCORE_A}} | {{SCORE_B}} | {{SCORE_C}} |
{{/EACH}}
| **Total** | | {{TOTAL_A}} | {{TOTAL_B}} | {{TOTAL_C}} |

### Decision

**Chosen Direction**: {{CHOSEN_OPTION}}

**Rationale**: {{RATIONALE}}

**Key Assumptions**:
{{#EACH ASSUMPTION}}
- {{ASSUMPTION}}
{{/EACH}}

---

## Strategic Plan

### Vision Statement
{{VISION}}

### Strategic Priorities

{{#EACH PRIORITY}}
#### Priority {{INDEX}}: {{PRIORITY_NAME}}

**Why it matters**: {{WHY}}

**Success looks like**: {{SUCCESS_CRITERIA}}

**Key initiatives**:
{{#EACH INITIATIVE}}
- {{INITIATIVE}}
{{/EACH}}

**Dependencies**: {{DEPENDENCIES}}

**Timeline**: {{TIMELINE}}
{{/EACH}}

### Resource Allocation

| Priority | Time % | Budget % | Key People |
|----------|--------|----------|------------|
{{#EACH ALLOCATION}}
| {{PRIORITY}} | {{TIME}} | {{BUDGET}} | {{PEOPLE}} |
{{/EACH}}

### What We're NOT Doing

{{#EACH NOT_DOING}}
- **{{ITEM}}**: {{REASON}}
{{/EACH}}

---

## Implementation Framework

### Milestones

| Milestone | Target Date | Success Criteria | Owner |
|-----------|-------------|------------------|-------|
{{#EACH MILESTONE}}
| {{NAME}} | {{DATE}} | {{CRITERIA}} | {{OWNER}} |
{{/EACH}}

### Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
{{#EACH RISK}}
| {{NAME}} | {{LIKELIHOOD}} | {{IMPACT}} | {{MITIGATION}} |
{{/EACH}}

### Review Points

| Review | Date | Focus | Decision Point |
|--------|------|-------|----------------|
{{#EACH REVIEW}}
| {{NAME}} | {{DATE}} | {{FOCUS}} | {{DECISION}} |
{{/EACH}}

---

## Session Insights

### Key Realizations

{{#EACH REALIZATION}}
- {{REALIZATION}}
{{/EACH}}

### Assumptions to Test

{{#EACH ASSUMPTION_TEST}}
- **{{ASSUMPTION}}**: Test by {{TEST_METHOD}}
{{/EACH}}

### Open Questions

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

---

## Action Items

{{#EACH ACTION}}
- [ ] {{ACTION}} (Owner: {{OWNER}}, Due: {{DUE}})
{{/EACH}}

## Documents to Create

{{#EACH DOCUMENT}}
- {{DOCUMENT_TYPE}}: {{TITLE}} -> [[{{LINK}}]]
{{/EACH}}

---
*Session ID: {{SESSION_ID}}*
*Horizon: {{HORIZON}}*
*Key decision: {{KEY_DECISION}}*
```

## Example: Completed Strategic Session

```markdown
# Strategic Session: Q1 2026 Planning
*January 5, 2026 | 9:00 AM - 1:00 PM | Duration: 4 hours*

## Session Setup

### Strategic Context

**Horizon**: Q1 2026 (January - March)

**Scope**: Engineering Team

**Key Question**: How do we maximize impact given headcount constraints while setting up for H2 growth?

### Objectives
- Define Q1 engineering priorities
- Allocate resources across projects
- Identify what we're NOT doing
- Create milestone calendar

### Context Loaded
- [[DEC-2025-022|2026 Company Priorities]]: Company-level direction
- [[2025-12-quarterly|Q4 2025 Retrospective]]: What we learned
- [[MAP-technical-debt]]: Current debt inventory
- [[DEC-2025-018|Platform Architecture]]: Technical direction

### Current State Summary
Engineering team: 8 engineers (1 new hire starting Jan 15)
Major projects: Platform v2 (60% complete), Mobile app (planning)
Tech debt: 47 items, 12 critical
H1 goals: Platform launch, mobile MVP

---

## Strategic Analysis

### Environmental Scan

#### What's Changed
- **Market**: Competitor launched similar product, accelerating our timeline
- **Resources**: Approved one additional hire, starting mid-January
- **Dependencies**: Design team fully allocated to Platform v2
- **Technology**: New framework version available (migration opportunity)

#### Implications
- Must accelerate Platform v2 timeline
- New hire onboarding will consume senior time
- Mobile work depends on design availability
- Framework migration could reduce future debt but adds Q1 work

### Key Tensions

#### Speed vs Quality
**Trade-off**: Ship Platform v2 faster vs reduce tech debt first
**Current stance**: Prioritizing speed for competitive reasons
**Consideration**: Tech debt slowing us down - compounding problem

#### New Features vs Mobile
**Trade-off**: Platform v2 feature scope vs starting mobile
**Current stance**: Unclear, needs decision
**Consideration**: Mobile is H2 priority but needs early architecture work

#### Hire Ramp vs Delivery
**Trade-off**: Thorough onboarding vs immediate productivity
**Current stance**: Want both
**Consideration**: Under-investing in onboarding hurts long-term

---

## Strategic Options

### Option A: Platform-First

**Description**: All resources on Platform v2 launch, defer mobile until Q2.

**Pros**:
- Maximum velocity on highest priority
- Clear focus for team
- Earlier Platform v2 launch (late Feb vs late March)

**Cons**:
- Mobile architecture deferred, may delay H2
- Puts all eggs in one basket
- Team may burn out on single project

**Resource Requirements**: 8 engineers full-time on Platform
**Risk Assessment**: Medium (single point of focus)

### Option B: Balanced Portfolio

**Description**: 70% Platform v2, 20% Mobile architecture, 10% Tech debt.

**Pros**:
- Progress on multiple priorities
- Positions for H2 mobile work
- Maintains some debt reduction

**Cons**:
- Slower Platform v2 timeline
- Context switching overhead
- Mobile work may feel incomplete

**Resource Requirements**: 6 on Platform, 1 on Mobile arch, 1 on debt
**Risk Assessment**: Low-Medium (diversified)

### Option C: Debt-First Sprint

**Description**: Two-week debt sprint, then Platform-first remainder of Q1.

**Pros**:
- Addresses compounding debt problem
- Faster velocity after sprint
- Team morale boost (paying down debt)

**Cons**:
- Delays Platform v2 by 2 weeks
- Competitive pressure increases
- May not see debt benefits in Q1

**Resource Requirements**: Full team on debt (2 weeks), then Platform
**Risk Assessment**: Medium (delay risk)

---

## Decision Framework

### Evaluation Criteria

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| Platform v2 timeline | 40% | 9 | 6 | 7 |
| H2 preparation | 20% | 4 | 8 | 5 |
| Team sustainability | 20% | 6 | 7 | 8 |
| Risk mitigation | 20% | 6 | 8 | 6 |
| **Total** | | 6.8 | 7.0 | 6.6 |

### Decision

**Chosen Direction**: Option B - Balanced Portfolio

**Rationale**: While Platform v2 is critical, completely ignoring mobile architecture creates H2 risk. A balanced approach maintains strategic flexibility while keeping focus on the primary priority.

**Key Assumptions**:
- New hire can contribute to mobile architecture after onboarding
- Design team will complete Platform v2 designs by end of January
- 70% allocation is sufficient for late March Platform launch

---

## Strategic Plan

### Vision Statement
By end of Q1, Platform v2 is launched and delighting users, mobile architecture is defined and validated, and the team is positioned for H2 growth.

### Strategic Priorities

#### Priority 1: Platform v2 Launch

**Why it matters**: Core business priority, competitive pressure

**Success looks like**: Platform v2 live by March 31, positive user feedback, <1 critical bug in first week

**Key initiatives**:
- Complete remaining 40% of features (Jan-Feb)
- Performance optimization sprint (early March)
- Staged rollout with monitoring (late March)

**Dependencies**: Design completion, QA resources

**Timeline**: Launch March 31

#### Priority 2: Mobile Architecture

**Why it matters**: H2 priority requires Q1 foundation work

**Success looks like**: Architecture doc approved, tech stack decided, prototype validates approach

**Key initiatives**:
- Architecture design (January)
- Tech stack evaluation (February)
- Prototype validation (March)

**Dependencies**: Platform v2 design patterns

**Timeline**: Architecture approved by March 15

#### Priority 3: Technical Debt (Maintenance)

**Why it matters**: Compounding slowdown, team morale

**Success looks like**: 5 critical debt items resolved, no new critical items

**Key initiatives**:
- Address 5 highest-impact items
- Prevent new critical debt

**Dependencies**: None

**Timeline**: Ongoing, 10% allocation

### Resource Allocation

| Priority | Time % | Budget % | Key People |
|----------|--------|----------|------------|
| Platform v2 | 70% | 80% | Senior team + new hire |
| Mobile Architecture | 20% | 15% | 1 senior engineer |
| Tech Debt | 10% | 5% | Rotating assignment |

### What We're NOT Doing

- **Major framework migration**: Too risky alongside Platform launch
- **New product features**: Focus on Platform v2 scope only
- **Full mobile development**: Architecture only, implementation in H2
- **Extensive refactoring**: Surgical debt reduction only

---

## Implementation Framework

### Milestones

| Milestone | Target Date | Success Criteria | Owner |
|-----------|-------------|------------------|-------|
| Platform v2 feature complete | Feb 15 | All features merged | Tech Lead |
| Mobile architecture approved | Feb 28 | Sign-off from team | Senior Eng |
| Performance sprint complete | Mar 15 | <2s load time | Platform team |
| Platform v2 launch | Mar 31 | Live with <1 critical bug | Tech Lead |

### Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Design delays | Medium | High | Weekly design syncs |
| New hire slow ramp | Low | Medium | Structured onboarding |
| Scope creep | Medium | Medium | Strict change control |
| Performance issues | Medium | High | Early perf testing |

### Review Points

| Review | Date | Focus | Decision Point |
|--------|------|-------|----------------|
| Month 1 | Feb 5 | Progress check | Adjust allocations? |
| Mid-Q | Feb 20 | Risk review | Scope changes? |
| Pre-launch | Mar 15 | Launch readiness | Go/no-go |

---

## Session Insights

### Key Realizations

- Mobile architecture work now prevents H2 scramble
- Tech debt is compounding faster than expected
- New hire is strategic opportunity for mobile work
- Framework migration should be H2 initiative

### Assumptions to Test

- **70% is sufficient for Platform v2**: Test by Feb 5 check-in
- **Mobile architecture can be done by 1 person**: Test by Feb 28

### Open Questions

- What's the minimum viable mobile architecture scope?
- How do we measure Platform v2 success beyond launch?
- Should new hire focus on Platform or Mobile after onboarding?

---

## Action Items

- [ ] Create Platform v2 milestone calendar (Owner: Tech Lead, Due: Jan 8)
- [ ] Draft mobile architecture scope (Owner: Senior Eng, Due: Jan 15)
- [ ] Update team on Q1 priorities (Owner: Manager, Due: Jan 6)
- [ ] Schedule monthly review meetings (Owner: Manager, Due: Jan 6)
- [ ] Identify tech debt top 5 (Owner: Team, Due: Jan 10)

## Documents to Create

- Decision note: Q1 Priority Allocation -> [[DEC-2026-001]]
- Project plan: Platform v2 milestones -> [[projects/platform-v2/milestones]]
- Architecture doc: Mobile architecture -> [[projects/mobile/architecture]]

---
*Session ID: strategic-2026-01-05-q1-planning*
*Horizon: Q1 2026*
*Key decision: Balanced portfolio approach*
```

## Strategic Session Guidelines

### When to Use

- Quarterly planning
- Annual strategy development
- Major initiative planning
- Resource allocation decisions
- Vision and priority setting

### Pre-Session Preparation

1. **Gather context**: Load relevant strategy docs, past decisions
2. **Identify stakeholders**: Who needs input, who decides
3. **Frame the question**: What strategic question are we answering
4. **Set time horizon**: What period are we planning for

### Session Flow

| Phase | Duration | Focus |
|-------|----------|-------|
| Context setting | 15% | Review current state, what's changed |
| Analysis | 25% | Environmental scan, tensions, options |
| Decision-making | 30% | Evaluate options, make choices |
| Planning | 20% | Priorities, resources, milestones |
| Action items | 10% | Next steps, documentation needs |

### Quality Indicators

- Clear decision made with rationale
- Priorities explicitly ranked
- "Not doing" list defined
- Milestones have dates and owners
- Assumptions are testable
- Review points scheduled

## Related Templates

- [[focus-session.md]] - For executing on strategy
- [[review-session.md]] - For assessing strategic progress
- [[quarterly-digest.md]] - Quarterly review input

---

*Part of KAAOS Session Management Templates*
