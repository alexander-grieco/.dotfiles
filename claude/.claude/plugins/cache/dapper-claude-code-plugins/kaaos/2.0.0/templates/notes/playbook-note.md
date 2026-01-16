---
template: playbook-note
version: "1.0"
description: Template for creating playbook (how-to) notes
usage: Capture repeatable processes, procedures, and best practices
placeholders:
  - "{{PLAYBOOK_ID}}" - Unique identifier (e.g., "PLAY-hiring-process")
  - "{{TITLE}}" - Playbook title
  - "{{DOMAIN}}" - Domain this playbook covers
  - "{{CREATED}}" - Creation timestamp
---

# Playbook Note Template

Playbook notes capture repeatable processes, procedures, and best practices. They transform tacit knowledge into explicit guidance that can be followed, improved, and shared. A good playbook enables consistent execution while allowing for judgment.

## Template Structure

```markdown
---
id: {{PLAYBOOK_ID}}
title: {{TITLE}}
type: playbook
domain: {{DOMAIN}}
created: {{CREATED}}
modified: {{MODIFIED}}
author: {{AUTHOR}}
version: {{VERSION}}
status: draft | active | deprecated
maturity: experimental | proven | standard
last_used: {{LAST_USED}}
success_rate: {{SUCCESS_RATE}}
---

# {{TITLE}}

> {{BRIEF_DESCRIPTION}}

## Quick Reference

| Aspect | Details |
|--------|---------|
| **When to use** | {{WHEN_TO_USE}} |
| **Time required** | {{TIME_ESTIMATE}} |
| **Prerequisites** | {{PREREQUISITES}} |
| **Outcome** | {{EXPECTED_OUTCOME}} |

## Overview

### Purpose

{{PURPOSE}}

*Why does this playbook exist? What problem does it solve?*

### Scope

**In scope**:
{{#EACH IN_SCOPE}}
- {{ITEM}}
{{/EACH}}

**Out of scope**:
{{#EACH OUT_OF_SCOPE}}
- {{ITEM}}
{{/EACH}}

### Prerequisites

Before starting:
{{#EACH PREREQUISITE}}
- [ ] {{PREREQUISITE}}
{{/EACH}}

## The Process

### Phase 1: {{PHASE_1_NAME}}

**Goal**: {{PHASE_1_GOAL}}
**Duration**: {{PHASE_1_DURATION}}

{{PHASE_1_DESCRIPTION}}

#### Steps

{{#EACH PHASE_1_STEP}}
{{INDEX}}. **{{STEP_NAME}}**
   {{STEP_DESCRIPTION}}

   {{#IF DETAILS}}
   <details>
   <summary>Detailed guidance</summary>

   {{DETAILS}}

   </details>
   {{/IF}}

   {{#IF EXAMPLES}}
   **Example**: {{EXAMPLE}}
   {{/IF}}

   {{#IF CHECKLIST}}
   - [ ] {{CHECKLIST_ITEM}}
   {{/IF}}
{{/EACH}}

#### Phase 1 Checklist
{{#EACH PHASE_1_CHECKPOINT}}
- [ ] {{CHECKPOINT}}
{{/EACH}}

### Phase 2: {{PHASE_2_NAME}}

**Goal**: {{PHASE_2_GOAL}}
**Duration**: {{PHASE_2_DURATION}}

{{PHASE_2_DESCRIPTION}}

#### Steps

{{#EACH PHASE_2_STEP}}
{{INDEX}}. **{{STEP_NAME}}**
   {{STEP_DESCRIPTION}}
{{/EACH}}

#### Phase 2 Checklist
{{#EACH PHASE_2_CHECKPOINT}}
- [ ] {{CHECKPOINT}}
{{/EACH}}

### Phase 3: {{PHASE_3_NAME}}

{{PHASE_3_CONTENT}}

## Decision Points

### {{DECISION_1_NAME}}

**Situation**: {{SITUATION}}

| If... | Then... |
|-------|---------|
{{#EACH DECISION_OPTION}}
| {{CONDITION}} | {{ACTION}} |
{{/EACH}}

**Guidance**: {{DECISION_GUIDANCE}}

### {{DECISION_2_NAME}}

{{DECISION_2_CONTENT}}

## Common Variations

### {{VARIATION_1_NAME}}

**When**: {{WHEN_TO_USE_VARIATION}}

**Modifications**:
{{#EACH MODIFICATION}}
- {{MODIFICATION}}
{{/EACH}}

### {{VARIATION_2_NAME}}

{{VARIATION_2_CONTENT}}

## Troubleshooting

### {{PROBLEM_1}}

**Symptoms**: {{SYMPTOMS}}

**Likely causes**:
{{#EACH CAUSE}}
- {{CAUSE}}
{{/EACH}}

**Solutions**:
{{#EACH SOLUTION}}
1. {{SOLUTION}}
{{/EACH}}

### {{PROBLEM_2}}

{{PROBLEM_2_CONTENT}}

## Anti-patterns

**Don't**:
{{#EACH ANTI_PATTERN}}
- {{ANTI_PATTERN}}: {{WHY_BAD}}
{{/EACH}}

## Templates and Resources

### Templates
{{#EACH TEMPLATE}}
- [[{{TEMPLATE_ID}}|{{TEMPLATE_NAME}}]]: {{DESCRIPTION}}
{{/EACH}}

### Tools
{{#EACH TOOL}}
- **{{TOOL_NAME}}**: {{TOOL_USAGE}}
{{/EACH}}

### Related Reading
{{#EACH READING}}
- [[{{NOTE_ID}}]]: {{RELEVANCE}}
{{/EACH}}

## Examples

### Example 1: {{EXAMPLE_1_TITLE}}

**Context**: {{CONTEXT}}

**How it went**:
{{NARRATIVE}}

**Key learnings**:
{{#EACH LEARNING}}
- {{LEARNING}}
{{/EACH}}

### Example 2: {{EXAMPLE_2_TITLE}}

{{EXAMPLE_2_CONTENT}}

## Metrics and Success Criteria

### Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
{{#EACH METRIC}}
| {{NAME}} | {{TARGET}} | {{MEASUREMENT}} |
{{/EACH}}

### Quality Indicators

Good execution looks like:
{{#EACH QUALITY_INDICATOR}}
- {{INDICATOR}}
{{/EACH}}

## Improvement Log

### Recent Updates
{{#EACH UPDATE}}
- {{DATE}}: {{UPDATE}}
{{/EACH}}

### Planned Improvements
{{#EACH PLANNED}}
- {{IMPROVEMENT}}
{{/EACH}}

### Feedback Welcome

If you use this playbook, please note:
- What worked well
- What was confusing
- What was missing

---
*Author: {{AUTHOR}}*
*Version: {{VERSION}}*
*Last used: {{LAST_USED}}*
*Success rate: {{SUCCESS_RATE}} ({{USE_COUNT}} uses)*
```

## Example: Completed Playbook

```markdown
---
id: PLAY-hiring-process
title: Hiring Process Playbook
type: playbook
domain: hiring
created: 2025-09-15T10:00:00-08:00
modified: 2026-01-14T16:00:00-08:00
author: people-operations
version: 2.3
status: active
maturity: proven
last_used: 2026-01-10
success_rate: 85%
---

# Hiring Process Playbook

> A structured approach to hiring that balances thoroughness with speed, ensuring quality hires while respecting candidates' time.

## Quick Reference

| Aspect | Details |
|--------|---------|
| **When to use** | Any new hire for technical or leadership roles |
| **Time required** | 3-4 weeks end-to-end |
| **Prerequisites** | Approved headcount, job description |
| **Outcome** | Hired candidate or documented pass |

## Overview

### Purpose

This playbook ensures we hire effectively by:
1. Moving quickly to not lose good candidates
2. Evaluating thoroughly to avoid mis-hires
3. Providing great candidate experience
4. Making defensible, unbiased decisions

### Scope

**In scope**:
- Full-time technical and leadership roles
- Initial sourcing through offer acceptance
- Interview structure and evaluation

**Out of scope**:
- Contractor hiring (see [[PLAY-contractor-hiring]])
- Executive search (see [[PLAY-executive-search]])
- Onboarding (see [[PLAY-onboarding]])

### Prerequisites

Before starting:
- [ ] Headcount approved by finance
- [ ] Job description finalized and approved
- [ ] Interview panel identified
- [ ] Compensation range confirmed with HR

## The Process

### Phase 1: Sourcing & Screening

**Goal**: Build qualified candidate pipeline
**Duration**: 1-2 weeks

Sourcing should cast a wide net while screening focuses attention on promising candidates.

#### Steps

1. **Post the role**
   Post to approved channels within 24 hours of approval.

   <details>
   <summary>Detailed guidance</summary>

   Standard channels:
   - Company careers page (mandatory)
   - LinkedIn (for all roles)
   - Role-specific boards (Stack Overflow for engineers, etc.)

   Include in posting:
   - Clear title matching internal levels
   - Salary range (legally required in some states)
   - Remote/hybrid/onsite status
   - Link to company values page

   </details>

   - [ ] Posted to careers page
   - [ ] Posted to LinkedIn
   - [ ] Posted to role-specific channels

2. **Activate referral network**
   Send role summary to team asking for referrals.

   **Example**: "We're hiring a Frontend Lead. Know someone who built products at scale and enjoys mentoring? Intro appreciated!"

   - [ ] Sent referral request to relevant teams

3. **Initial screening**
   Review applications within 48 hours of receipt.

   Screen for:
   - Required qualifications (hard requirements)
   - Relevant experience (soft match OK)
   - Communication quality in application

   - [ ] All applications reviewed within 48 hours

4. **Phone screen**
   30-minute call to assess fit and interest.

   Questions:
   - Why are you interested in this role?
   - Walk me through your most relevant experience.
   - What are you looking for in your next role?
   - What are your salary expectations?

   - [ ] Phone screens scheduled within 1 week of application

#### Phase 1 Checklist
- [ ] Job posted to all channels
- [ ] At least 5 candidates phone screened
- [ ] Best candidates moved to Phase 2
- [ ] Rejected candidates notified

### Phase 2: Deep Evaluation

**Goal**: Thorough assessment of top candidates
**Duration**: 1-2 weeks

#### Steps

1. **Work sample**
   Send take-home exercise or schedule live coding session.

   For Engineering roles: 2-4 hour take-home or 1-hour live coding
   For Leadership roles: Case study presentation

   - [ ] Work sample instructions sent
   - [ ] Deadline set (typically 1 week)

2. **Technical interview**
   60-90 minute deep dive into technical skills.

   Use structured rubric (see [[hiring-rubrics]]).

   - [ ] Technical interview completed
   - [ ] Rubric filled out within 24 hours

3. **Values/culture interview**
   45-60 minutes assessing values alignment.

   Not "culture fit" (homogeneity) but "values alignment" (shared principles).

   - [ ] Values interview completed
   - [ ] Notes documented

4. **Hiring manager interview**
   60 minutes with direct manager.

   Focus on:
   - Working style compatibility
   - Growth expectations
   - Role-specific scenarios

   - [ ] Hiring manager interview completed

#### Phase 2 Checklist
- [ ] Work sample reviewed and scored
- [ ] All interviews completed
- [ ] All feedback documented within 24 hours
- [ ] Debrief scheduled

### Phase 3: Decision & Offer

**Goal**: Make and execute hiring decision
**Duration**: 3-5 days

#### Steps

1. **Debrief meeting**
   All interviewers meet to discuss candidate.

   Rules:
   - Written feedback submitted before meeting
   - No anchoring (everyone shares before discussion)
   - Focus on evidence, not impressions

   Decision options:
   - Strong hire: Move to offer
   - Hire with reservations: Document concerns, proceed if acceptable
   - No hire: Document reasons, reject

   - [ ] Debrief completed
   - [ ] Decision documented

2. **Reference checks**
   For strong hire candidates only.

   Contact 2-3 references (at least 1 manager).

   - [ ] References checked
   - [ ] No red flags identified

3. **Offer creation**
   Work with HR to prepare competitive offer.

   Include:
   - Base salary (in approved range)
   - Equity (if applicable)
   - Start date options
   - Benefits summary

   - [ ] Offer approved by HR and hiring manager

4. **Offer delivery**
   Call candidate to deliver offer verbally first.

   - [ ] Verbal offer delivered
   - [ ] Written offer sent within 24 hours
   - [ ] Candidate response deadline set (typically 1 week)

#### Phase 3 Checklist
- [ ] Decision made within 48 hours of final interview
- [ ] Offer extended within 24 hours of decision
- [ ] Rejected candidates notified with feedback

## Decision Points

### Borderline Candidate

**Situation**: Candidate meets requirements but team is not enthusiastic.

| If... | Then... |
|-------|---------|
| Concerns are addressable with coaching | Proceed with documented expectations |
| Concerns are fundamental (values, motivation) | Pass - don't compromise |
| Team is split 50/50 | Hiring manager makes call |

**Guidance**: When in doubt, don't hire. A mis-hire costs 6-12 months of productivity. It's better to restart the search.

### Multiple Strong Candidates

**Situation**: Two or more candidates would be great hires.

| If... | Then... |
|-------|---------|
| Have budget for multiple hires | Hire both |
| Only one slot | Decide based on team needs |
| Truly equal | Consider who would accept |

**Guidance**: This is a great problem! Document both so you can reach out if the first declines.

## Common Variations

### Urgent Hire

**When**: Critical role needs to be filled quickly

**Modifications**:
- Compress timeline (2 weeks vs 4 weeks)
- Run interviews in parallel vs sequential
- Reduce work sample scope
- Keep evaluation rigor - don't skip steps

### Remote-First Hire

**When**: Candidate will work fully remote

**Modifications**:
- All interviews via video call
- Add async communication assessment
- Include "virtual onboarding readiness" evaluation
- Schedule interviews across time zones fairly

## Troubleshooting

### No Qualified Applicants

**Symptoms**: Few applications, none meeting requirements

**Likely causes**:
- Job description too narrow
- Compensation below market
- Unattractive job posting
- Wrong channels

**Solutions**:
1. Review job requirements - which are truly required?
2. Benchmark compensation against market data
3. Rewrite posting with candidate perspective
4. Try different sourcing channels
5. Activate referral network more aggressively

### Candidates Dropping Out

**Symptoms**: Qualified candidates withdrawing mid-process

**Likely causes**:
- Process too slow
- Poor communication
- Better offers elsewhere
- Bad interview experience

**Solutions**:
1. Audit process timing - where are delays?
2. Improve communication frequency
3. Review compensation competitiveness
4. Gather candidate feedback on experience

## Anti-patterns

**Don't**:
- **Hire for "culture fit"**: This perpetuates homogeneity. Hire for values alignment instead.
- **Skip the work sample**: Past work is the best predictor. Resumes and interviews alone are insufficient.
- **Rush the decision**: Quick process, thoughtful decision. Don't conflate speed with urgency.
- **Give wishy-washy feedback**: Rejected candidates deserve honest, actionable feedback.
- **Let one person veto**: Strong objections should be heard, but one person shouldn't have absolute veto.

## Templates and Resources

### Templates
- [[hiring-job-description-template]]: Standard job posting format
- [[hiring-rubric-engineering]]: Technical evaluation rubric
- [[hiring-rubric-leadership]]: Leadership evaluation rubric
- [[hiring-reference-questions]]: Reference check guide

### Tools
- **ATS**: Use Lever/Greenhouse for tracking
- **Scheduling**: Calendly for interview scheduling
- **Video**: Zoom for remote interviews

### Related Reading
- [[DEC-2026-003|Frontend Lead Hire]]: Recent hiring decision example
- [[2026-01-055|Work Samples Predict Success]]: Evidence for work samples
- [[PLAY-onboarding]]: What happens after the hire

## Examples

### Example 1: Frontend Lead Hire (January 2026)

**Context**: Needed senior frontend developer with leadership potential.

**How it went**:
- Posted role on January 8
- 47 applications, 8 phone screens, 3 to deep eval
- Candidate A: Strong technical, weak leadership signals
- Candidate B: Strong all around, accepted offer January 15
- Total time: 7 days (compressed timeline)

**Key learnings**:
- Work sample immediately differentiated candidates
- Running interviews in parallel saved 3 days
- Having backup candidates ready was valuable

### Example 2: Engineer Hire with Red Flag (Q4 2025)

**Context**: Promising engineer candidate with concerning reference.

**How it went**:
- Candidate performed well in all interviews
- Reference mentioned "sometimes difficult to work with"
- Dug deeper: Pattern of conflict with previous managers
- Decision: Pass despite strong skills

**Key learnings**:
- References matter - don't skip them
- One red flag can save months of problems
- Document the decision for future reference

## Metrics and Success Criteria

### Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Time to hire | <30 days | Posting to offer acceptance |
| Offer acceptance rate | >80% | Acceptances / offers extended |
| 90-day retention | >95% | Still employed at 90 days |
| Hiring manager satisfaction | >4/5 | Survey at 90 days |

### Quality Indicators

Good execution looks like:
- Candidates report positive experience (even rejected ones)
- Diverse finalist pool
- Team enthusiastic about hire
- New hire ramping successfully

## Improvement Log

### Recent Updates
- 2026-01-14: Added remote-first variation
- 2026-01-10: Updated work sample guidance based on DEC-2026-003
- 2025-12-15: Added anti-patterns section

### Planned Improvements
- Add structured interview question bank
- Create interviewer training module
- Add diversity metrics tracking

---
*Author: people-operations*
*Version: 2.3*
*Last used: 2026-01-10*
*Success rate: 85% (20 hires, 17 successful at 90 days)*
```

## Playbook Characteristics

### Maturity Levels

| Level | Definition | Criteria |
|-------|------------|----------|
| **Experimental** | New, untested | <3 uses, still evolving |
| **Proven** | Works reliably | 3-10 uses, consistent results |
| **Standard** | Organizational norm | 10+ uses, high success rate |

### Good Playbook Traits

1. **Actionable**: Clear steps, not just principles
2. **Contextual**: Knows when it applies (and doesn't)
3. **Flexible**: Variations for common situations
4. **Evidence-based**: Draws from real experience
5. **Improvable**: Logs updates and welcomes feedback

## Related Templates

- [[atomic-note.md]] - Knowledge that informs playbooks
- [[decision-note.md]] - Decisions that reference playbooks
- [[pattern-note.md]] - Patterns that may become playbooks

---

*Part of KAAOS Knowledge Management Templates*
