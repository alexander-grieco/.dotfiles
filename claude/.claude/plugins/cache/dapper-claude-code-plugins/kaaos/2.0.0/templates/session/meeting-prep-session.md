---
template: meeting-prep-session
version: "1.0"
description: Template for meeting preparation sessions
usage: Prepare for important meetings with context loading and pre-read creation
duration: 30-60 minutes
recommended_copilot: true
session_type: meeting-prep
---

# Meeting Prep Session Template

Meeting prep sessions ensure you enter important meetings with full context, clear objectives, and prepared materials. The structured approach reduces meeting time and improves outcomes by front-loading the thinking.

## Session Structure

```markdown
# Meeting Prep: {{MEETING_TITLE}}
*Prep Date: {{PREP_DATE}} | Meeting: {{MEETING_DATE}} {{MEETING_TIME}}*

## Meeting Overview

### Basic Info

| Field | Value |
|-------|-------|
| Meeting | {{MEETING_TITLE}} |
| Date/Time | {{MEETING_DATE}} {{MEETING_TIME}} |
| Duration | {{DURATION}} |
| Location | {{LOCATION}} |
| Attendees | {{ATTENDEES}} |
| My Role | {{MY_ROLE}} |

### Meeting Purpose

**Type**: {{MEETING_TYPE}} (decision, planning, review, sync, etc.)

**Objective**: {{OBJECTIVE}}

**Success looks like**: {{SUCCESS_CRITERIA}}

---

## Context Gathering

### Relevant Knowledge

{{#EACH CONTEXT_NOTE}}
#### [[{{NOTE_ID}}|{{TITLE}}]]
**Relevance**: {{RELEVANCE}}
**Key point**: {{KEY_POINT}}
{{/EACH}}

### Related Decisions

| Decision | Status | Relevance |
|----------|--------|-----------|
{{#EACH DECISION}}
| [[{{DECISION_ID}}]] | {{STATUS}} | {{RELEVANCE}} |
{{/EACH}}

### Recent Activity

**Past 30 days related to this topic**:
{{#EACH ACTIVITY}}
- {{DATE}}: {{ACTIVITY}}
{{/EACH}}

### Outstanding Questions

{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

---

## Attendee Analysis

{{#EACH ATTENDEE}}
### {{NAME}}

**Role**: {{ROLE}}
**Likely interests**: {{INTERESTS}}
**Potential concerns**: {{CONCERNS}}
**Recent interactions**: {{RECENT_INTERACTIONS}}
**Preparation for them**: {{PREPARATION}}
{{/EACH}}

---

## My Preparation

### My Objectives

**What I want to achieve**:
{{#EACH MY_OBJECTIVE}}
- {{OBJECTIVE}}
{{/EACH}}

### Points to Make

{{#EACH POINT}}
#### {{POINT_TITLE}}

**Key message**: {{MESSAGE}}
**Supporting evidence**: {{EVIDENCE}}
**Anticipated pushback**: {{PUSHBACK}}
**Response**: {{RESPONSE}}
{{/EACH}}

### Questions to Ask

{{#EACH QUESTION}}
- {{QUESTION}}
  - Why it matters: {{WHY}}
{{/EACH}}

### Potential Decisions

| Decision | My Position | Flexibility |
|----------|-------------|-------------|
{{#EACH DECISION}}
| {{DECISION}} | {{POSITION}} | {{FLEXIBILITY}} |
{{/EACH}}

---

## Pre-Read Preparation

### Pre-Read Required?

{{PRE_READ_REQUIRED}} (Yes/No)

{{#IF PRE_READ_REQUIRED}}
### Pre-Read Content

**Format**: {{FORMAT}} (memo, slides, document)
**Length**: {{LENGTH}}
**Due**: {{DUE}}

#### Pre-Read Outline

{{#EACH SECTION}}
##### {{SECTION_TITLE}}
{{SECTION_CONTENT}}
{{/EACH}}

#### Key Data/Visuals Needed

{{#EACH VISUAL}}
- {{VISUAL}}
{{/EACH}}
{{/IF}}

---

## Scenario Planning

### Best Case

**Scenario**: {{BEST_CASE_SCENARIO}}
**Indicators**: {{INDICATORS}}
**Next steps**: {{NEXT_STEPS}}

### Expected Case

**Scenario**: {{EXPECTED_SCENARIO}}
**Indicators**: {{INDICATORS}}
**Next steps**: {{NEXT_STEPS}}

### Worst Case

**Scenario**: {{WORST_CASE_SCENARIO}}
**Indicators**: {{INDICATORS}}
**Contingency**: {{CONTINGENCY}}

---

## Meeting Logistics

### Before Meeting

- [ ] Pre-read sent (if applicable)
- [ ] Materials prepared
- [ ] Tech tested (if virtual)
- [ ] Context notes reviewed

### During Meeting

- [ ] Notes document open
- [ ] Relevant notes accessible
- [ ] Action items captured real-time

### After Meeting

- [ ] Summary written within 24 hours
- [ ] Action items assigned
- [ ] Decisions documented
- [ ] Follow-ups scheduled

---

## Quick Reference Card

*Print or keep open during meeting*

**My Objectives**:
{{#EACH QUICK_OBJECTIVE}}
- {{OBJECTIVE}}
{{/EACH}}

**Key Points**:
{{#EACH QUICK_POINT}}
- {{POINT}}
{{/EACH}}

**Questions to Ask**:
{{#EACH QUICK_QUESTION}}
- {{QUESTION}}
{{/EACH}}

**Red Lines** (non-negotiables):
{{#EACH RED_LINE}}
- {{RED_LINE}}
{{/EACH}}

---
*Prep session: {{PREP_SESSION_ID}}*
*Context items loaded: {{CONTEXT_COUNT}}*
*Pre-read status: {{PRE_READ_STATUS}}*
```

## Example: Completed Meeting Prep

```markdown
# Meeting Prep: Q1 Budget Review
*Prep Date: January 14, 2026 | Meeting: January 15, 2026 2:00 PM*

## Meeting Overview

### Basic Info

| Field | Value |
|-------|-------|
| Meeting | Q1 Budget Review |
| Date/Time | January 15, 2026 2:00 PM |
| Duration | 60 minutes |
| Location | Zoom |
| Attendees | CFO, VP Engineering, VP Product, Finance Manager |
| My Role | Present engineering budget, justify variances |

### Meeting Purpose

**Type**: Review (with decision components)

**Objective**: Review Q1 engineering budget proposal, get approval, and align on headcount plan.

**Success looks like**: Budget approved with minimal changes, headcount plan confirmed, clear on constraints.

---

## Context Gathering

### Relevant Knowledge

#### [[DEC-2025-022|2026 Budget Framework]]
**Relevance**: Sets overall company budget constraints
**Key point**: Engineering allocated 35% of total budget, similar to 2025

#### [[2025-12-015|Q4 Actual vs Budget]]
**Relevance**: Track record of budget accuracy
**Key point**: Q4 came in 3% under budget - good track record

#### [[DEC-2026-003|Frontend Lead Hire]]
**Relevance**: Approved hire affecting Q1 headcount
**Key point**: $160K loaded cost, approved January 10

#### [[MAP-2026-engineering-goals]]
**Relevance**: What the budget enables
**Key point**: Platform v2 launch, mobile architecture, tech debt reduction

### Related Decisions

| Decision | Status | Relevance |
|----------|--------|-----------|
| [[DEC-2026-003]] | Approved | Adds $160K to Q1 |
| [[DEC-2025-022]] | Active | Budget framework |
| [[DEC-2025-018]] | Active | Platform architecture drives infra costs |

### Recent Activity

**Past 30 days related to this topic**:
- Jan 10: Frontend lead hire approved (DEC-2026-003)
- Jan 5: Q1 planning session completed
- Dec 15: 2026 budget framework finalized

### Outstanding Questions

- Will we get approval for contractor budget if hire search takes longer?
- Is there flexibility in the cloud infrastructure line item?
- What's the process for mid-quarter budget adjustments?

---

## Attendee Analysis

### CFO (Sarah)

**Role**: Final budget approver
**Likely interests**: Cost control, ROI clarity, predictability
**Potential concerns**: Headcount growth rate, infrastructure costs
**Recent interactions**: Approved frontend hire, asked about cloud spend
**Preparation for them**: Have ROI data ready for each major line item

### VP Product (Michael)

**Role**: Stakeholder, alignment partner
**Likely interests**: Engineering capacity for product roadmap
**Potential concerns**: Whether engineering resources match product needs
**Recent interactions**: Q1 planning alignment, positive
**Preparation for them**: Show how budget enables product priorities

### Finance Manager (Lisa)

**Role**: Budget tracking, process owner
**Likely interests**: Accuracy, documentation, process compliance
**Potential concerns**: Variance explanations, forecast accuracy
**Recent interactions**: Q4 close-out, no issues
**Preparation for them**: Have detailed breakdown ready

---

## My Preparation

### My Objectives

**What I want to achieve**:
- Get Q1 budget approved as submitted
- Confirm headcount plan (8 + 1 new = 9)
- Establish flexibility for contractor backup
- Clarify cloud infrastructure growth path

### Points to Make

#### Engineering Budget Enables Strategic Goals

**Key message**: Q1 budget directly maps to company priorities - Platform v2 and mobile prep.
**Supporting evidence**: Platform v2 represents 70% of engineering focus, mobile 20%
**Anticipated pushback**: "Why is Platform v2 taking so long?"
**Response**: Scope expanded based on customer feedback (which is good), on track for March 31

#### Cloud Costs Increase is Justified

**Key message**: 15% cloud increase driven by Platform v2 performance requirements and scale testing.
**Supporting evidence**: Performance benchmarks require production-like environment
**Anticipated pushback**: "Can we defer this?"
**Response**: Deferring risks launch quality - bugs found in production are 10x more expensive

#### Headcount is Right-Sized

**Key message**: 9 engineers is minimum for Platform v2 + mobile architecture + maintenance.
**Supporting evidence**: Resource allocation model shows 70/20/10 split
**Anticipated pushback**: "Can you do more with less?"
**Response**: We're already running lean - any reduction delays Platform v2 or mobile

### Questions to Ask

- What's the process for mid-quarter adjustments if priorities shift?
  - Why it matters: Need flexibility for emerging needs
- Is there appetite for contractor budget if hire search extends?
  - Why it matters: Can't have Platform v2 slip due to hiring delays
- How will we handle infrastructure cost growth in H2?
  - Why it matters: Sets expectations for future conversations

### Potential Decisions

| Decision | My Position | Flexibility |
|----------|-------------|-------------|
| Q1 budget approval | Approve as submitted | Minor line item adjustments OK |
| Contractor backup | Add $40K reserve | Can negotiate amount |
| Cloud growth | 15% increase | Can phase over Q1-Q2 if needed |

---

## Pre-Read Preparation

### Pre-Read Required?

Yes - sending budget summary document

### Pre-Read Content

**Format**: 2-page memo with tables
**Length**: 2 pages + appendix
**Due**: January 14, 5 PM

#### Pre-Read Outline

##### Executive Summary
Q1 Engineering budget request of $850K supports Platform v2 launch (March 31) and mobile architecture groundwork. Key changes from Q4: +1 headcount (approved), +15% cloud infrastructure.

##### Budget Summary Table
| Category | Q4 Actual | Q1 Request | Change | Notes |
|----------|-----------|------------|--------|-------|
| Salaries | $650K | $720K | +11% | +1 FTE |
| Cloud | $80K | $92K | +15% | Perf testing |
| Tools | $25K | $25K | 0% | Stable |
| Other | $10K | $13K | +30% | Training |
| **Total** | **$765K** | **$850K** | **+11%** | |

##### Key Investments
1. Platform v2 completion (70% of engineering time)
2. Mobile architecture foundation (20%)
3. Tech debt maintenance (10%)

##### Risk & Mitigation
Hiring delay risk mitigated by contractor reserve request.

#### Key Data/Visuals Needed

- Budget breakdown pie chart
- Q4 vs Q1 comparison bar chart
- Resource allocation diagram

---

## Scenario Planning

### Best Case

**Scenario**: Budget approved as submitted, contractor reserve also approved
**Indicators**: CFO nods along, no tough questions on line items, discussion moves to execution
**Next steps**: Send thanks, begin contractor vendor conversations

### Expected Case

**Scenario**: Budget approved with minor adjustments, contractor reserve tabled
**Indicators**: Some questions on cloud costs, request for more detail, decision on reserve deferred
**Next steps**: Provide additional cloud detail, schedule follow-up on contractor topic

### Worst Case

**Scenario**: Budget sent back for revision, significant cuts requested
**Indicators**: CFO expresses concern about growth rate, asks "what if we had 10% less"
**Contingency**: Prepare 10% reduction scenario (would delay mobile architecture start)

---

## Meeting Logistics

### Before Meeting

- [x] Pre-read sent (if applicable) - sent Jan 14 5pm
- [x] Materials prepared - slides backed up
- [ ] Tech tested (if virtual)
- [x] Context notes reviewed

### During Meeting

- [ ] Notes document open
- [ ] Relevant notes accessible
- [ ] Action items captured real-time

### After Meeting

- [ ] Summary written within 24 hours
- [ ] Action items assigned
- [ ] Decisions documented -> [[DEC-2026-006|Q1 Budget Approval]]
- [ ] Follow-ups scheduled

---

## Quick Reference Card

*Print or keep open during meeting*

**My Objectives**:
- Get Q1 budget approved
- Confirm headcount plan
- Establish contractor flexibility

**Key Points**:
- Budget directly enables Platform v2 (March 31)
- Cloud increase justified by performance needs
- Headcount right-sized for priorities

**Questions to Ask**:
- Mid-quarter adjustment process?
- Contractor backup appetite?
- H2 infrastructure expectations?

**Red Lines** (non-negotiables):
- Cannot reduce headcount below 8
- Cannot delay cloud scaling past Feb 1
- Platform v2 March 31 target must be protected

---
*Prep session: prep-2026-01-14-q1-budget*
*Context items loaded: 4*
*Pre-read status: Sent*
```

## Meeting Prep Guidelines

### When to Use

- Important decision meetings
- Budget and resource discussions
- Leadership syncs
- Client/partner meetings
- Performance reviews
- Any meeting where you have a stake

### Time Investment

| Meeting Importance | Prep Time | Ratio |
|-------------------|-----------|-------|
| Critical (career/company impact) | 60-90 min | 1:1 or more |
| Important (significant decisions) | 30-60 min | 1:2 |
| Standard (regular syncs) | 15-30 min | 1:4 |
| Routine (status updates) | 5-15 min | 1:6 |

### Pre-Read Best Practices

1. **Send 24-48 hours before** - Gives time to read
2. **Keep it focused** - 1-3 pages max
3. **Lead with summary** - Busy readers get the point
4. **Include decision asks** - What do you need from them?
5. **End with questions** - What should they come prepared to discuss?

### Quick Reference Card Tips

- Print or keep on second monitor
- Include ONLY what you need to glance at
- Red lines keep you from over-compromising
- Questions you want to ask (easy to forget in discussion)

## Related Templates

- [[focus-session.md]] - For deep work on meeting follow-ups
- [[decision-note.md]] - For documenting meeting decisions
- [[daily-digest.md]] - Includes meeting context

---

*Part of KAAOS Session Management Templates*
