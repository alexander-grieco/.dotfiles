---
template: research-session
version: "1.0"
description: Template for investigation and research sessions
usage: Exploring topics, gathering information, building understanding
duration: 1-3 hours
recommended_copilot: true
session_type: research
---

# Research Session Template

Research sessions are dedicated time for exploration and investigation. Unlike focus sessions (which produce deliverables) or strategic sessions (which make decisions), research sessions build understanding through structured inquiry.

## Session Structure

```markdown
# Research Session: {{SESSION_TITLE}}
*{{DATE}} | {{START_TIME}} - {{END_TIME}} | Duration: {{DURATION}}*

## Research Setup

### Research Question
**Primary Question**: {{PRIMARY_QUESTION}}

**Sub-questions**:
{{#EACH SUB_QUESTION}}
- {{QUESTION}}
{{/EACH}}

### Why This Matters
{{WHY_IT_MATTERS}}

### What I Already Know
{{PRIOR_KNOWLEDGE}}

### What I Need to Learn
{{#EACH LEARNING_NEED}}
- {{NEED}}
{{/EACH}}

### Initial Hypotheses
{{#EACH HYPOTHESIS}}
- {{HYPOTHESIS}}
{{/EACH}}

### Context Loaded
{{#EACH CONTEXT_NOTE}}
- [[{{NOTE_ID}}]]: {{RELEVANCE}}
{{/EACH}}

---

## Research Log

### Source 1: {{SOURCE_1_NAME}}

**Type**: {{SOURCE_TYPE}} (article, paper, documentation, interview, etc.)
**URL/Location**: {{SOURCE_LOCATION}}
**Credibility**: {{CREDIBILITY_ASSESSMENT}}

#### Key Findings
{{#EACH FINDING}}
- {{FINDING}}
{{/EACH}}

#### Relevant Quotes
{{#EACH QUOTE}}
> "{{QUOTE}}"
> — {{ATTRIBUTION}}
{{/EACH}}

#### Questions Raised
{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

#### Relevance to Research Question
{{RELEVANCE}}

---

### Source 2: {{SOURCE_2_NAME}}

{{SOURCE_2_CONTENT}}

---

### Source 3: {{SOURCE_3_NAME}}

{{SOURCE_3_CONTENT}}

---

## Synthesis

### Emerging Themes

{{#EACH THEME}}
#### Theme: {{THEME_NAME}}

**Evidence**:
{{#EACH EVIDENCE}}
- {{SOURCE}}: {{EVIDENCE}}
{{/EACH}}

**Interpretation**: {{INTERPRETATION}}
{{/EACH}}

### Contradictions Found

{{#EACH CONTRADICTION}}
#### {{CONTRADICTION_NAME}}
- **Source A says**: {{SOURCE_A_CLAIM}}
- **Source B says**: {{SOURCE_B_CLAIM}}
- **My assessment**: {{ASSESSMENT}}
{{/EACH}}

### Hypothesis Status

| Hypothesis | Status | Evidence |
|------------|--------|----------|
{{#EACH HYPOTHESIS_STATUS}}
| {{HYPOTHESIS}} | {{STATUS}} | {{EVIDENCE}} |
{{/EACH}}

### Answer to Research Question

**Primary Question**: {{PRIMARY_QUESTION}}

**Answer**: {{ANSWER}}

**Confidence**: {{CONFIDENCE}}

**Limitations**: {{LIMITATIONS}}

---

## Knowledge Artifacts

### Notes to Create

{{#EACH NOTE_TO_CREATE}}
- **{{NOTE_TYPE}}**: {{TITLE}}
  - Key content: {{KEY_CONTENT}}
  - Links to: {{LINKS}}
{{/EACH}}

### Updates to Existing Notes

{{#EACH UPDATE}}
- [[{{NOTE_ID}}]]: {{UPDATE_DESCRIPTION}}
{{/EACH}}

### Gaps Identified

{{#EACH GAP}}
- {{GAP}}: Needs further research on {{FURTHER_RESEARCH}}
{{/EACH}}

---

## Research Quality Assessment

### Source Diversity

| Source Type | Count | Quality |
|-------------|-------|---------|
{{#EACH SOURCE_TYPE}}
| {{TYPE}} | {{COUNT}} | {{QUALITY}} |
{{/EACH}}

### Bias Awareness

**Potential biases in research**:
{{#EACH BIAS}}
- {{BIAS}}
{{/EACH}}

**Mitigation taken**:
{{#EACH MITIGATION}}
- {{MITIGATION}}
{{/EACH}}

### Confidence Assessment

| Factor | Assessment |
|--------|------------|
| Source quality | {{SOURCE_QUALITY}} |
| Source diversity | {{SOURCE_DIVERSITY}} |
| Consistency of findings | {{CONSISTENCY}} |
| Depth of coverage | {{DEPTH}} |
| **Overall confidence** | **{{OVERALL_CONFIDENCE}}** |

---

## Follow-up Actions

### Immediate
{{#EACH IMMEDIATE}}
- [ ] {{ACTION}}
{{/EACH}}

### Future Research
{{#EACH FUTURE}}
- {{TOPIC}}: {{REASON}}
{{/EACH}}

### People to Consult
{{#EACH PERSON}}
- {{NAME}}: {{TOPIC}}
{{/EACH}}

---
*Session ID: {{SESSION_ID}}*
*Sources consulted: {{SOURCE_COUNT}}*
*Notes created: {{NOTES_CREATED}}*
*Confidence: {{CONFIDENCE}}*
```

## Example: Completed Research Session

```markdown
# Research Session: RBAC vs ABAC for Permission Systems
*January 10, 2026 | 2:00 PM - 5:00 PM | Duration: 3 hours*

## Research Setup

### Research Question
**Primary Question**: Should we use Role-Based Access Control (RBAC) or Attribute-Based Access Control (ABAC) for our new permission system?

**Sub-questions**:
- What are the core differences between RBAC and ABAC?
- What are the implementation complexity trade-offs?
- Which better fits our multi-tenant architecture?
- What do industry leaders use?

### Why This Matters
We're designing the permission system for Platform v2. This is a foundational decision that affects security, user experience, and future flexibility. Wrong choice = expensive rewrite.

### What I Already Know
- RBAC uses roles to group permissions
- ABAC uses attributes for fine-grained control
- We currently have a simple role system (admin, user, viewer)
- Multi-tenancy requires some form of scoping

### What I Need to Learn
- Detailed pros/cons of each approach
- Implementation complexity comparison
- How others handle multi-tenancy
- Performance implications

### Initial Hypotheses
- ABAC is more flexible but more complex
- RBAC might be sufficient for our needs
- Hybrid approach might be best

### Context Loaded
- [[REF-current-permissions]]: Current system documentation
- [[2025-08-012|Permission System Pain Points]]: Known issues
- [[DEC-2024-015|Original Permission Design]]: Why we chose current approach

---

## Research Log

### Source 1: NIST RBAC Standard (NIST SP 800-207)

**Type**: Technical standard / Government publication
**URL/Location**: https://csrc.nist.gov/publications/detail/sp/800-207/final
**Credibility**: High - authoritative government source

#### Key Findings
- RBAC defined as core, hierarchical, and constrained variants
- Core RBAC sufficient for most applications
- Hierarchical RBAC adds role inheritance
- Constrained RBAC adds separation of duties

#### Relevant Quotes
> "RBAC policies constrain access based on job functions rather than individual user identities, simplifying policy administration."

> "The core RBAC model includes five basic data elements: users, roles, objects, operations, and permissions."

#### Questions Raised
- Is hierarchical RBAC worth the complexity?
- How does constrained RBAC map to our use case?

#### Relevance to Research Question
Strong foundation for understanding RBAC capabilities. Our current system is essentially "core RBAC" - confirms we're not far off.

---

### Source 2: AWS IAM Documentation

**Type**: Technical documentation
**URL/Location**: https://docs.aws.amazon.com/IAM/latest/UserGuide/
**Credibility**: High - real-world implementation at scale

#### Key Findings
- AWS uses policy-based system (closer to ABAC)
- Policies combine principal, action, resource, and conditions
- Supports both identity-based and resource-based policies
- Condition keys enable attribute-like behavior

#### Relevant Quotes
> "IAM policies define permissions for an action regardless of the method that you use to perform the operation."

#### Questions Raised
- Is AWS IAM overkill for our use case?
- How much of this complexity do we actually need?

#### Relevance to Research Question
AWS demonstrates that large-scale systems often end up with policy-based (ABAC-like) systems. But they also have enormous engineering resources.

---

### Source 3: Auth0 Blog - "RBAC vs ABAC"

**Type**: Technical blog post
**URL/Location**: https://auth0.com/blog/rbac-vs-abac/
**Credibility**: Medium-High - industry vendor with expertise

#### Key Findings
- RBAC: Simpler to implement, easier to audit, less flexible
- ABAC: More flexible, harder to audit, more complex
- Recommendation: Start with RBAC, evolve to ABAC if needed
- Hybrid approach ("RBAC with attributes") gaining popularity

#### Relevant Quotes
> "RBAC is easier to implement and manage but can become unwieldy when you need fine-grained access control."

> "Many organizations start with RBAC and add attribute-based rules as needed."

#### Questions Raised
- What's the trigger point for needing ABAC?
- How do you implement hybrid cleanly?

#### Relevance to Research Question
Directly addresses our question. Suggests evolutionary approach: RBAC first, add attributes later.

---

### Source 4: Okta Technical White Paper

**Type**: White paper
**URL/Location**: Okta documentation library
**Credibility**: High - major identity provider

#### Key Findings
- Multi-tenancy often handled through "scoped RBAC"
- Scope = tenant, project, or resource group
- Permission = Role + Scope
- This avoids full ABAC complexity while gaining flexibility

#### Relevant Quotes
> "Scoped roles provide the flexibility of attributes with the simplicity of roles."

#### Relevance to Research Question
"Scoped RBAC" seems to be exactly what we need for multi-tenancy.

---

### Source 5: Internal Interview - Senior Security Engineer

**Type**: Expert interview
**URL/Location**: Slack conversation, Jan 10
**Credibility**: High - internal domain expert

#### Key Findings
- Our current pain points stem from lack of scoping, not RBAC itself
- ABAC would require policy engine (complex)
- Scoped RBAC with 3-5 roles per scope would cover 95% of use cases
- Performance: ABAC policy evaluation is slower

#### Relevant Quotes
> "We don't need ABAC's flexibility. We need our current RBAC to understand scopes."

#### Questions Raised
- What are the 5% edge cases RBAC wouldn't cover?

#### Relevance to Research Question
Strong internal endorsement for scoped RBAC approach.

---

## Synthesis

### Emerging Themes

#### Theme: "RBAC is sufficient with scoping"

**Evidence**:
- Auth0: Start with RBAC, evolve as needed
- Okta: Scoped RBAC handles multi-tenancy
- Internal expert: Our pain is scoping, not RBAC itself

**Interpretation**: Our assumption that we need ABAC may be wrong. The real need is scoped RBAC.

#### Theme: "Complexity has real costs"

**Evidence**:
- AWS: Massive engineering investment in IAM
- Auth0: ABAC harder to audit
- Internal: ABAC policy evaluation is slower

**Interpretation**: ABAC's flexibility comes with meaningful operational costs we should avoid if not needed.

#### Theme: "Hybrid approaches exist"

**Evidence**:
- Auth0: "RBAC with attributes"
- Okta: Scoped RBAC
- AWS: Condition keys for attribute-like behavior

**Interpretation**: We don't have to choose pure RBAC or ABAC - hybrid is valid.

### Contradictions Found

#### Flexibility Assessment
- **Auth0 says**: ABAC is more flexible
- **NIST says**: Constrained RBAC can handle complex requirements
- **My assessment**: Flexibility depends on requirements. For our multi-tenant case, scoped RBAC provides needed flexibility.

### Hypothesis Status

| Hypothesis | Status | Evidence |
|------------|--------|----------|
| ABAC is more flexible but complex | Confirmed | All sources agree |
| RBAC might be sufficient | Confirmed | With scoping, covers our needs |
| Hybrid might be best | Partially confirmed | Scoped RBAC is a form of hybrid |

### Answer to Research Question

**Primary Question**: Should we use RBAC or ABAC?

**Answer**: Use scoped RBAC. This provides the multi-tenancy flexibility we need (the actual pain point) without the complexity of full ABAC. Design the system to allow adding attribute-based rules later if edge cases emerge.

**Confidence**: High

**Limitations**:
- Haven't evaluated specific edge cases (5% mentioned by security engineer)
- Performance testing not done
- Implementation complexity not measured

---

## Knowledge Artifacts

### Notes to Create

- **Atomic note**: "Scoped RBAC vs Pure ABAC"
  - Key content: Trade-offs, when to use each
  - Links to: MAP-security, DEC-2026-005

- **Decision note**: "DEC-2026-005 Permission System Architecture"
  - Key content: Decision to use scoped RBAC
  - Links to: This research session

### Updates to Existing Notes

- [[2025-08-012|Permission Pain Points]]: Add scoping as root cause analysis
- [[MAP-security]]: Add link to new permission decision

### Gaps Identified

- Edge cases for ABAC: Needs follow-up with security engineer
- Performance benchmarks: Needs testing in implementation phase
- Migration path from current system: Needs separate planning

---

## Research Quality Assessment

### Source Diversity

| Source Type | Count | Quality |
|-------------|-------|---------|
| Standards/Specs | 1 | High |
| Vendor docs | 2 | High |
| Blog posts | 1 | Medium-High |
| Expert interviews | 1 | High |

### Bias Awareness

**Potential biases in research**:
- Vendor sources may oversimplify to sell products
- I may have confirmation bias toward simpler solution
- Internal expert has context I might over-weight

**Mitigation taken**:
- Included authoritative standard (NIST)
- Explicitly noted AWS uses more complex approach
- Sought contradictions actively

### Confidence Assessment

| Factor | Assessment |
|--------|------------|
| Source quality | High |
| Source diversity | Good (5 different types) |
| Consistency of findings | High |
| Depth of coverage | Medium (focused on decision, not implementation) |
| **Overall confidence** | **High** |

---

## Follow-up Actions

### Immediate
- [ ] Write decision note DEC-2026-005
- [ ] Update MAP-security with new links
- [ ] Schedule follow-up with security engineer on edge cases

### Future Research
- Permission system implementation patterns: For actual build phase
- Migration strategies: For transitioning current system

### People to Consult
- Security Engineer: Edge cases, policy details
- Frontend Lead: UI implications of scoped permissions

---
*Session ID: research-2026-01-10-rbac-abac*
*Sources consulted: 5*
*Notes created: 2*
*Confidence: High*
```

## Research Session Guidelines

### Types of Research Sessions

| Type | Purpose | Typical Duration |
|------|---------|------------------|
| Exploratory | Understand new domain | 2-3 hours |
| Decision support | Gather evidence for decision | 1-2 hours |
| Problem investigation | Diagnose issue root cause | 1-2 hours |
| Competitive analysis | Understand alternatives | 2-3 hours |

### Source Quality Assessment

| Credibility | Description | Examples |
|-------------|-------------|----------|
| High | Authoritative, peer-reviewed | Academic papers, standards, official docs |
| Medium-High | Expert but potentially biased | Vendor white papers, industry experts |
| Medium | Useful but verify | Blog posts, tutorials |
| Low | Use with caution | Forum posts, unverified claims |

### Research Anti-patterns

**Avoid**:
- Single source conclusions
- Ignoring contradictory evidence
- Confirmation bias (seeking only supporting evidence)
- Over-relying on recent sources
- Forgetting to document sources

## Related Templates

- [[focus-session.md]] - For acting on research findings
- [[decision-note.md]] - For documenting research-informed decisions
- [[synthesis-note.md]] - For combining research insights

---

*Part of KAAOS Session Management Templates*
