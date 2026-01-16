---
template: review-session
version: "1.0"
description: Template for periodic review sessions
usage: Structured reflection on progress, outcomes, and learnings
duration: 60-120 minutes
recommended_copilot: true
session_type: review
---

# Review Session Template

Review sessions provide structured time for reflection on progress, outcomes, and learnings. They can be used for personal reviews, project retrospectives, decision reviews, or any periodic assessment. The template supports learning from experience and closing loops on past commitments.

## Session Structure

```markdown
# Review Session: {{REVIEW_TITLE}}
*{{DATE}} | Review Period: {{PERIOD_START}} - {{PERIOD_END}}*

## Review Setup

### Review Type

**Type**: {{REVIEW_TYPE}} (personal, project, decision, team, goal)

**Period**: {{PERIOD_START}} to {{PERIOD_END}}

**Focus**: {{FOCUS}}

### Review Questions

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

### Materials to Review

{{#EACH MATERIAL}}
- [[{{NOTE_ID}}]]: {{PURPOSE}}
{{/EACH}}

---

## What Was Planned

### Original Objectives

{{#EACH OBJECTIVE}}
#### {{OBJECTIVE_NAME}}

**Target**: {{TARGET}}
**Why it mattered**: {{WHY}}
**Success criteria**: {{CRITERIA}}
{{/EACH}}

### Key Milestones

| Milestone | Planned Date | Purpose |
|-----------|--------------|---------|
{{#EACH MILESTONE}}
| {{NAME}} | {{DATE}} | {{PURPOSE}} |
{{/EACH}}

### Commitments Made

{{#EACH COMMITMENT}}
- {{COMMITMENT}} (Context: [[{{CONTEXT_NOTE}}]])
{{/EACH}}

---

## What Actually Happened

### Objective Status

| Objective | Status | Actual | Notes |
|-----------|--------|--------|-------|
{{#EACH OBJECTIVE_STATUS}}
| {{NAME}} | {{STATUS}} | {{ACTUAL}} | {{NOTES}} |
{{/EACH}}

### Milestone Status

| Milestone | Planned | Actual | Variance | Reason |
|-----------|---------|--------|----------|--------|
{{#EACH MILESTONE_STATUS}}
| {{NAME}} | {{PLANNED}} | {{ACTUAL}} | {{VARIANCE}} | {{REASON}} |
{{/EACH}}

### Commitment Status

| Commitment | Status | Notes |
|------------|--------|-------|
{{#EACH COMMITMENT_STATUS}}
| {{COMMITMENT}} | {{STATUS}} | {{NOTES}} |
{{/EACH}}

### Key Events

{{#EACH EVENT}}
#### {{DATE}}: {{EVENT_NAME}}

**What happened**: {{WHAT}}
**Impact**: {{IMPACT}}
**Link**: [[{{NOTE_ID}}]]
{{/EACH}}

---

## Analysis

### What Went Well

{{#EACH WELL}}
#### {{TITLE}}

**Description**: {{DESCRIPTION}}
**Contributing factors**: {{FACTORS}}
**How to repeat**: {{REPEAT}}
{{/EACH}}

### What Didn't Go Well

{{#EACH NOT_WELL}}
#### {{TITLE}}

**Description**: {{DESCRIPTION}}
**Root cause**: {{ROOT_CAUSE}}
**How to avoid**: {{AVOID}}
{{/EACH}}

### What Was Learned

{{#EACH LEARNING}}
#### {{TITLE}}

**Insight**: {{INSIGHT}}
**Evidence**: {{EVIDENCE}}
**Application**: {{APPLICATION}}
**Note created**: [[{{NOTE_ID}}]]
{{/EACH}}

### Surprises

{{#EACH SURPRISE}}
- **{{TITLE}}**: {{DESCRIPTION}}
  - Why surprising: {{WHY}}
  - Implication: {{IMPLICATION}}
{{/EACH}}

---

## Decisions Review

### Decisions Made During Period

| Decision | Date | Outcome | Assessment |
|----------|------|---------|------------|
{{#EACH DECISION}}
| [[{{DECISION_ID}}]] | {{DATE}} | {{OUTCOME}} | {{ASSESSMENT}} |
{{/EACH}}

### Decision Deep Dives

{{#EACH DECISION_REVIEW}}
#### [[{{DECISION_ID}}|{{TITLE}}]]

**Original rationale**: {{RATIONALE}}

**Outcome**: {{OUTCOME}}

**Assessment**: {{ASSESSMENT}}

**What we'd do differently**: {{DIFFERENTLY}}

**Update to decision note**: {{UPDATE}}
{{/EACH}}

---

## Pattern Recognition

### Patterns Observed

{{#EACH PATTERN}}
#### {{PATTERN_NAME}}

**Observation**: {{OBSERVATION}}
**Frequency**: {{FREQUENCY}}
**Significance**: {{SIGNIFICANCE}}
**Action**: {{ACTION}}
{{/EACH}}

### Recurring Themes

{{#EACH THEME}}
- **{{THEME}}**: {{DESCRIPTION}}
{{/EACH}}

### Emerging Questions

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

---

## Metrics Review

### Key Metrics

| Metric | Start | End | Change | Target | Status |
|--------|-------|-----|--------|--------|--------|
{{#EACH METRIC}}
| {{NAME}} | {{START}} | {{END}} | {{CHANGE}} | {{TARGET}} | {{STATUS}} |
{{/EACH}}

### Metric Analysis

{{#EACH METRIC_ANALYSIS}}
#### {{METRIC_NAME}}

**Trend**: {{TREND}}
**Explanation**: {{EXPLANATION}}
**Action**: {{ACTION}}
{{/EACH}}

---

## Forward Look

### Carry Forward

{{#EACH CARRY_FORWARD}}
- {{ITEM}} (Reason: {{REASON}})
{{/EACH}}

### New Priorities

{{#EACH NEW_PRIORITY}}
- {{PRIORITY}} (Based on: {{BASED_ON}})
{{/EACH}}

### Adjusted Targets

| Target | Previous | New | Reason |
|--------|----------|-----|--------|
{{#EACH ADJUSTED_TARGET}}
| {{NAME}} | {{PREVIOUS}} | {{NEW}} | {{REASON}} |
{{/EACH}}

### Open Loops to Close

{{#EACH OPEN_LOOP}}
- {{LOOP}} (Deadline: {{DEADLINE}})
{{/EACH}}

---

## Action Items

### Immediate (This Week)

{{#EACH IMMEDIATE}}
- [ ] {{ACTION}} (Owner: {{OWNER}})
{{/EACH}}

### Near-Term (This Month)

{{#EACH NEAR_TERM}}
- [ ] {{ACTION}} (Owner: {{OWNER}}, Due: {{DUE}})
{{/EACH}}

### Process Changes

{{#EACH PROCESS_CHANGE}}
- {{CHANGE}} (Affects: {{AFFECTS}})
{{/EACH}}

---

## Knowledge Artifacts

### Notes Created

{{#EACH NOTE_CREATED}}
- [[{{NOTE_ID}}]]: {{DESCRIPTION}}
{{/EACH}}

### Notes Updated

{{#EACH NOTE_UPDATED}}
- [[{{NOTE_ID}}]]: {{UPDATE}}
{{/EACH}}

### Decisions to Document

{{#EACH DECISION_TO_DOC}}
- {{DECISION}} -> [[{{DECISION_ID}}]]
{{/EACH}}

---

## Review Summary

### Period Grade

**Overall assessment**: {{GRADE}} (A/B/C/D/F or equivalent)

**Rationale**: {{GRADE_RATIONALE}}

### Key Takeaways

{{#EACH TAKEAWAY}}
1. {{TAKEAWAY}}
{{/EACH}}

### Next Review

**Date**: {{NEXT_REVIEW_DATE}}
**Focus**: {{NEXT_REVIEW_FOCUS}}

---
*Review session: {{SESSION_ID}}*
*Period: {{PERIOD}}*
*Duration: {{DURATION}}*
```

## Example: Completed Review Session

```markdown
# Review Session: January 2026 Personal Review
*January 31, 2026 | Review Period: January 1 - January 31, 2026*

## Review Setup

### Review Type

**Type**: Personal monthly review

**Period**: January 1 to January 31, 2026

**Focus**: Professional goals, knowledge growth, key decisions

### Review Questions

- Did I make progress on my stated goals?
- What did I learn that I didn't expect?
- Which decisions am I most/least confident in?
- Am I spending time on what matters?

### Materials to Review

- [[2026-goals|2026 Personal Goals]]: What I committed to
- [[calendar-january]]: Where my time went
- [[DEC-2026-*]]: Decisions made this month
- [[daily-digests/2026-01-*]]: Daily activity

---

## What Was Planned

### Original Objectives

#### Launch Platform v2

**Target**: Feature complete by mid-February, launch by March 31
**Why it mattered**: Core company priority, sets up H2
**Success criteria**: On track for dates, team healthy

#### Build Knowledge System

**Target**: KAAOS repository operational, daily habit established
**Why it mattered**: Knowledge compounding is core to effectiveness
**Success criteria**: Using daily, seeing value

#### Improve Decision Quality

**Target**: Document all significant decisions, review outcomes
**Why it mattered**: Learning from decisions is high-leverage
**Success criteria**: 100% decision documentation, monthly reviews

### Key Milestones

| Milestone | Planned Date | Purpose |
|-----------|--------------|---------|
| Q1 planning complete | Jan 10 | Clear priorities |
| Frontend hire decision | Jan 15 | Team capacity |
| Platform v2 design freeze | Jan 31 | Lock scope |

### Commitments Made

- Complete 4 deep work sessions per week (Context: [[2026-goals]])
- Document all hiring decisions within 24h (Context: [[PLAY-hiring]])
- Weekly knowledge synthesis (Context: [[kaaos-rhythm]])

---

## What Actually Happened

### Objective Status

| Objective | Status | Actual | Notes |
|-----------|--------|--------|-------|
| Platform v2 progress | On track | 65% complete | Ahead of schedule |
| Knowledge system | On track | Daily use | Seeing value |
| Decision quality | Partial | 80% documented | Room to improve |

### Milestone Status

| Milestone | Planned | Actual | Variance | Reason |
|-----------|---------|--------|----------|--------|
| Q1 planning | Jan 10 | Jan 5 | -5 days | Started early |
| Frontend hire decision | Jan 15 | Jan 10 | -5 days | Great candidate |
| Design freeze | Jan 31 | Jan 31 | On time | As planned |

### Commitment Status

| Commitment | Status | Notes |
|------------|--------|-------|
| 4 deep work sessions/week | Partial | Avg 3.2 sessions |
| Hiring decisions within 24h | Met | All 3 documented |
| Weekly synthesis | Met | 4 of 4 weeks |

### Key Events

#### January 10: Frontend Lead Hired

**What happened**: Made offer to strong candidate, accepted same day
**Impact**: Unblocked mobile architecture planning, boosted team morale
**Link**: [[DEC-2026-003]]

#### January 15: KAAOS System Live

**What happened**: Completed initial setup, began daily use
**Impact**: Noticeable improvement in context retention
**Link**: [[2026-01-015-kaaos-setup]]

#### January 20: Q1 Kickoff

**What happened**: Successfully launched Q1 with team alignment
**Impact**: Clear priorities, minimal confusion
**Link**: [[2026-01-020-q1-kickoff]]

---

## Analysis

### What Went Well

#### Hiring Speed

**Description**: Frontend hire completed in 7 days from posting to accepted offer
**Contributing factors**: Pre-approved headcount, strong process, great candidate timing
**How to repeat**: Maintain hiring process rigor, move fast when candidate is strong

#### Knowledge System Adoption

**Description**: KAAOS became a daily habit, seeing compound effects
**Contributing factors**: Clear templates, low friction, immediate value
**How to repeat**: Keep friction low, capture everything, trust the system

#### Strategic Planning

**Description**: Q1 planning was clearest and most aligned ever
**Contributing factors**: Pre-reads, structured sessions, clear framework
**How to repeat**: Use strategic session template, invest in pre-work

### What Didn't Go Well

#### Deep Work Sessions

**Description**: Only achieved 3.2 of 4 planned deep work sessions per week
**Root cause**: Meeting creep, reactive work taking priority
**How to avoid**: Block calendar more aggressively, protect mornings

#### Decision Documentation Speed

**Description**: Some decisions documented days later, missing context
**Root cause**: "I'll do it later" mentality, context decay
**How to avoid**: Document immediately after decision, even if brief

### What Was Learned

#### Pre-reads Transform Meetings

**Insight**: Meetings with pre-reads are dramatically more effective (40% shorter, better decisions)
**Evidence**: Q1 planning, budget review, hiring discussions all benefited
**Application**: Make pre-reads default for all important meetings
**Note created**: [[2026-01-050|Pre-reads Reduce Meeting Time]]

#### Hiring Speed Has Limits

**Insight**: Fast hiring is good, but not faster than thorough evaluation
**Evidence**: Frontend hire was fast AND thorough - both possible
**Application**: Don't compromise on evaluation to speed up
**Note created**: [[2026-01-055|Speed Without Compromise in Hiring]]

### Surprises

- **Team enthusiasm for KAAOS**: Expected resistance, got curiosity
  - Why surprising: Change is usually hard
  - Implication: Team is ready for more process improvements

- **Budget review went smoothly**: Expected tough questions, got support
  - Why surprising: Usually more pushback on growth
  - Implication: Track record matters, maintain it

---

## Decisions Review

### Decisions Made During Period

| Decision | Date | Outcome | Assessment |
|----------|------|---------|------------|
| [[DEC-2026-001\|Q1 Priorities]] | Jan 5 | Executing well | Good |
| [[DEC-2026-003\|Frontend Hire]] | Jan 10 | Accepted, starting Feb 3 | Excellent |
| [[DEC-2026-004\|Marketing Experiment]] | Jan 15 | In progress | TBD |
| [[DEC-2026-005\|Permission System]] | Jan 20 | Implementation started | Good |

### Decision Deep Dives

#### [[DEC-2026-003|Frontend Lead Hire]]

**Original rationale**: Team needed technical leadership, approved headcount

**Outcome**: Hired excellent candidate in 7 days, starts Feb 3

**Assessment**: Excellent - right decision, great execution

**What we'd do differently**: Nothing - this is the template

**Update to decision note**: Add as hiring process example

---

## Pattern Recognition

### Patterns Observed

#### Pre-reads Correlate with Meeting Quality

**Observation**: Meetings with pre-reads consistently better
**Frequency**: 100% correlation in January
**Significance**: High - multiplies meeting effectiveness
**Action**: Formalize pre-read requirement

#### Morning Deep Work is More Productive

**Observation**: Morning sessions produce more than afternoon
**Frequency**: Clear pattern in session logs
**Significance**: Medium - informs scheduling
**Action**: Protect mornings more aggressively

### Recurring Themes

- **Speed and quality can coexist**: Multiple examples this month
- **Documentation pays off quickly**: Context from notes was valuable
- **Process investment has ROI**: Templates saved time repeatedly

### Emerging Questions

- How do I scale personal knowledge practices to team?
- What's the right balance between process and flexibility?
- When does documentation become overhead?

---

## Metrics Review

### Key Metrics

| Metric | Start | End | Change | Target | Status |
|--------|-------|-----|--------|--------|--------|
| Deep work hours | 0 | 51 | +51 | 64 (16/wk) | 80% |
| Notes created | 0 | 45 | +45 | 40 | Met |
| Decisions documented | 0 | 5 | +5 | 5 | Met |
| Platform v2 progress | 60% | 65% | +5% | 70% | On track |

### Metric Analysis

#### Deep Work Hours

**Trend**: 80% of target (51 of 64 hours)
**Explanation**: Meeting creep consumed some deep work time
**Action**: More aggressive calendar blocking in February

---

## Forward Look

### Carry Forward

- Deep work session discipline (Reason: Didn't fully hit target)
- Real-time decision documentation (Reason: Some delays)

### New Priorities

- New hire onboarding (Based on: Feb 3 start date)
- Mobile architecture kickoff (Based on: Q1 plan)

### Adjusted Targets

| Target | Previous | New | Reason |
|--------|----------|-----|--------|
| Deep work sessions | 4/week | 4/week | Keep pushing |
| Decision doc speed | <24h | <4h | Tighten |

### Open Loops to Close

- Marketing experiment week 2 review (Deadline: Feb 5)
- Platform v2 feature freeze (Deadline: Jan 31)

---

## Action Items

### Immediate (This Week)

- [ ] Block February mornings on calendar (Owner: Me)
- [ ] Prepare onboarding materials for new hire (Owner: Me)

### Near-Term (This Month)

- [ ] Formalize pre-read requirement (Owner: Me, Due: Feb 15)
- [ ] Share KAAOS templates with team (Owner: Me, Due: Feb 28)

### Process Changes

- Pre-reads required for all >30 minute meetings (Affects: Calendar invites)
- Decision documentation within 4 hours (Affects: Decision workflow)

---

## Knowledge Artifacts

### Notes Created

- [[2026-01-050|Pre-reads Reduce Meeting Time]]: Key insight
- [[2026-01-055|Speed Without Compromise]]: Hiring insight

### Notes Updated

- [[PLAY-hiring]]: Added DEC-2026-003 as example
- [[MAP-meeting-practices]]: Added pre-read section

### Decisions to Document

- None outstanding

---

## Review Summary

### Period Grade

**Overall assessment**: B+

**Rationale**: Strong progress on objectives, excellent hiring execution, good knowledge system adoption. Missed on deep work target. Decision documentation could be faster.

### Key Takeaways

1. Pre-reads are a force multiplier - make them default
2. Speed and quality are not trade-offs when process is good
3. Morning deep work is most productive - protect it
4. Knowledge system paying dividends - keep investing

### Next Review

**Date**: February 28, 2026
**Focus**: New hire onboarding success, Platform v2 progress, deep work discipline

---
*Review session: review-2026-01-31-monthly*
*Period: January 2026*
*Duration: 90 minutes*
```

## Review Session Types

| Type | Frequency | Focus | Duration |
|------|-----------|-------|----------|
| Personal | Monthly | Goals, habits, decisions | 60-90 min |
| Project | At milestones | Progress, blockers, learnings | 60-120 min |
| Decision | Per decision review schedule | Outcome vs expectation | 30-60 min |
| Team | Weekly-Monthly | Collaboration, process | 60-90 min |
| Goal | Quarterly | Strategic progress | 90-120 min |

## Review Best Practices

1. **Schedule in advance** - Reviews happen when calendared
2. **Gather materials first** - Don't search during review
3. **Be honest** - Reviews only work with honesty
4. **Focus on learning** - Not judgment
5. **Create artifacts** - Capture insights in notes
6. **Act on findings** - Reviews without action are waste

## Related Templates

- [[strategic-session.md]] - For planning based on reviews
- [[decision-note.md]] - For reviewing specific decisions
- [[monthly-digest.md]] - Automated monthly review input
- [[quarterly-digest.md]] - Automated quarterly review input

---

*Part of KAAOS Session Management Templates*
