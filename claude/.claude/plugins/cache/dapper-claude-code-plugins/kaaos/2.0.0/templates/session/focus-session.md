---
template: focus-session
version: "1.0"
description: Template for deep work focus sessions
usage: Dedicated time blocks for complex, uninterrupted work
duration: 90-180 minutes
recommended_copilot: true
session_type: focus
---

# Focus Session Template

Focus sessions are dedicated time blocks for deep, uninterrupted work on complex tasks. The structure minimizes context-switching, captures insights in real-time, and ensures work products are properly integrated into the knowledge base.

## Session Structure

```markdown
# Focus Session: {{SESSION_TITLE}}
*{{DATE}} | {{START_TIME}} - {{END_TIME}} | Duration: {{DURATION}}*

## Session Setup

### Objective
**Primary Goal**: {{PRIMARY_OBJECTIVE}}

**Success Criteria**:
{{#EACH CRITERION}}
- [ ] {{CRITERION}}
{{/EACH}}

### Context Loaded
{{#EACH CONTEXT_NOTE}}
- [[{{NOTE_ID}}]]: {{RELEVANCE}}
{{/EACH}}

### Environment
- [ ] Notifications silenced
- [ ] Environment prepared
- [ ] Materials gathered
- [ ] Copilot agent active

---

## Work Log

### Hour 1: {{START}} - {{HOUR_1_END}}

#### Focus Area
{{FOCUS_AREA_1}}

#### Work Completed
{{WORK_COMPLETED_1}}

#### Decisions Made
{{#EACH DECISION}}
- **{{DECISION}}**: {{RATIONALE}}
{{/EACH}}

#### Questions/Blockers
{{#EACH QUESTION}}
- {{QUESTION}}
{{/EACH}}

#### Insights
{{#EACH INSIGHT}}
- {{INSIGHT}}
{{/EACH}}

---

### Hour 2: {{HOUR_1_END}} - {{HOUR_2_END}}

#### Focus Area
{{FOCUS_AREA_2}}

#### Work Completed
{{WORK_COMPLETED_2}}

#### Decisions Made
{{DECISIONS_2}}

#### Insights
{{INSIGHTS_2}}

---

### Hour 3 (if applicable): {{HOUR_2_END}} - {{END}}

{{HOUR_3_CONTENT}}

---

## Session Review

### Accomplishments
{{#EACH ACCOMPLISHMENT}}
- {{ACCOMPLISHMENT}}
{{/EACH}}

### Outstanding Items
{{#EACH OUTSTANDING}}
- {{ITEM}} (Reason: {{REASON}})
{{/EACH}}

### Key Insights
{{#EACH KEY_INSIGHT}}
- {{INSIGHT}}
  - Note created: [[{{NOTE_ID}}]]
{{/EACH}}

### Decisions for Documentation
{{#EACH DECISION_TO_DOC}}
- {{DECISION}} -> Create [[{{DECISION_NOTE_ID}}]]
{{/EACH}}

### Next Session Prep
{{NEXT_SESSION_PREP}}

---

## Session Metrics

| Metric | Value |
|--------|-------|
| Planned duration | {{PLANNED_DURATION}} |
| Actual duration | {{ACTUAL_DURATION}} |
| Goals completed | {{GOALS_COMPLETED}}/{{GOALS_TOTAL}} |
| Notes created | {{NOTES_CREATED}} |
| Decisions documented | {{DECISIONS_DOCUMENTED}} |
| Insights captured | {{INSIGHTS_CAPTURED}} |

## Artifacts Created

{{#EACH ARTIFACT}}
- {{ARTIFACT_NAME}}: {{DESCRIPTION}}
{{/EACH}}

---
*Session ID: {{SESSION_ID}}*
*Copilot active: {{COPILOT_ACTIVE}}*
*Context items loaded: {{CONTEXT_COUNT}}*
```

## Example: Completed Focus Session

```markdown
# Focus Session: API Design for User Permissions
*January 15, 2026 | 9:00 AM - 12:00 PM | Duration: 3 hours*

## Session Setup

### Objective
**Primary Goal**: Design the REST API for user permissions system including endpoints, data models, and access control patterns.

**Success Criteria**:
- [x] Define core permission entities
- [x] Design CRUD endpoints for roles
- [x] Design permission assignment endpoints
- [ ] Document access control middleware (started, not complete)
- [x] Create example request/response payloads

### Context Loaded
- [[REF-api-conventions]]: API design standards
- [[2025-12-020|RBAC vs ABAC]]: Permission model comparison
- [[DEC-2025-018|RBAC Decision]]: Why we chose RBAC
- [[PLAY-api-design]]: API design playbook

### Environment
- [x] Notifications silenced
- [x] Environment prepared
- [x] Materials gathered
- [x] Copilot agent active

---

## Work Log

### Hour 1: 9:00 AM - 10:00 AM

#### Focus Area
Core entity design: Roles, Permissions, and Assignments

#### Work Completed
Defined three core entities:
1. **Role**: Named collection of permissions (e.g., "Editor", "Admin")
2. **Permission**: Specific capability (e.g., "users:read", "posts:write")
3. **RoleAssignment**: Links users to roles with optional scope

Created entity relationship diagram showing:
- User -> RoleAssignment (1:many)
- RoleAssignment -> Role (many:1)
- Role -> Permission (many:many)

#### Decisions Made
- **Use resource:action permission format**: More flexible than boolean flags, allows granular control
- **Support scoped assignments**: User can be Admin for one project, Editor for another
- **Hierarchical roles deferred**: Keep v1 simple, add hierarchy in v2 if needed

#### Questions/Blockers
- Should we support permission inheritance? (Deferred to v2)
- How do we handle permission conflicts? (Decided: explicit deny wins)

#### Insights
- The separation of Role and Permission allows for permission bundles that can be reused
- Scoped assignments add complexity but are essential for multi-tenant scenarios

---

### Hour 2: 10:00 AM - 11:00 AM

#### Focus Area
CRUD endpoints for Roles and Permissions

#### Work Completed
Designed 8 endpoints:

**Roles**:
- `GET /roles` - List all roles
- `POST /roles` - Create role
- `GET /roles/{id}` - Get role details
- `PUT /roles/{id}` - Update role
- `DELETE /roles/{id}` - Delete role
- `PUT /roles/{id}/permissions` - Set role permissions

**Role Assignments**:
- `GET /users/{userId}/roles` - Get user's roles
- `POST /users/{userId}/roles` - Assign role to user
- `DELETE /users/{userId}/roles/{roleId}` - Remove role from user

Created OpenAPI snippets for each endpoint with request/response examples.

#### Decisions Made
- **Use PUT for setting permissions**: Replaces entire permission set rather than patching
- **Include scope in assignment**: `POST /users/{userId}/roles` accepts optional scope parameter
- **Return expanded role in assignment response**: Reduces need for follow-up requests

#### Insights
- The GET /users/{userId}/roles endpoint should support filtering by scope
- Consider a "check permission" endpoint: GET /users/{userId}/permissions/{permission}

---

### Hour 3: 11:00 AM - 12:00 PM

#### Focus Area
Permission checking middleware and access control patterns

#### Work Completed
Documented permission checking flow:
1. Extract user ID from JWT
2. Look up user's role assignments (cached)
3. Expand roles to permissions (cached)
4. Check requested permission against user's permission set
5. Consider scope if applicable

Started middleware implementation outline but did not complete.

Created decision tree for permission checks:
- Public endpoint? -> Allow
- Authenticated? -> Check token
- Permission required? -> Check permission
- Scoped? -> Check scope match

#### Decisions Made
- **Cache role lookups**: 5-minute TTL, invalidate on role change
- **Permission format**: `resource:action` or `resource:action:scope`

#### Outstanding
- Middleware implementation details (need code review)
- Error response format for permission denied

#### Insights
- We need an audit log for permission changes - this is a compliance requirement
- Consider a "permission denied" webhook for security monitoring

---

## Session Review

### Accomplishments
- Complete entity model for RBAC system
- 8 API endpoints designed with examples
- Permission checking flow documented
- Key decisions made and rationale captured

### Outstanding Items
- Middleware implementation details (Reason: Needs code review with team)
- Error response standardization (Reason: Should align with existing error format)
- Audit logging design (Reason: Scope creep - separate session)

### Key Insights
- Permission bundles (roles) are key abstraction for usability
  - Note created: [[2026-01-065|Permission Bundles Simplify UX]]
- Scoped assignments essential for multi-tenant
  - Note created: [[2026-01-066|Scoped Role Assignments]]
- Audit logging is compliance requirement
  - Added to backlog, not knowledge base yet

### Decisions for Documentation
- RBAC entity model -> Create [[DEC-2026-005|Permission System Design]]
- Permission format decision -> Add to [[REF-api-conventions]]

### Next Session Prep
- Review middleware approach with backend team
- Research audit logging patterns
- Schedule follow-up session for implementation details

---

## Session Metrics

| Metric | Value |
|--------|-------|
| Planned duration | 3 hours |
| Actual duration | 3 hours |
| Goals completed | 4/5 |
| Notes created | 2 |
| Decisions documented | 6 |
| Insights captured | 3 |

## Artifacts Created

- `api-permissions-design.md`: Complete API design document
- `permission-entities.mermaid`: Entity relationship diagram
- `endpoint-examples.yaml`: OpenAPI snippets for all endpoints

---
*Session ID: focus-2026-01-15-api-permissions*
*Copilot active: true*
*Context items loaded: 4*
```

## Focus Session Guidelines

### Optimal Duration

| Duration | Best For | Break Pattern |
|----------|----------|---------------|
| 90 minutes | Single complex task | No break needed |
| 2 hours | Task with subtasks | 5 min break at midpoint |
| 3 hours | Major deliverable | 5 min breaks hourly |
| >3 hours | Not recommended | Split into multiple sessions |

### Pre-Session Checklist

```markdown
## Pre-Session Checklist

- [ ] Clear, specific objective defined
- [ ] Success criteria are measurable
- [ ] Relevant context notes identified
- [ ] Environment prepared (tools, materials)
- [ ] Distractions minimized (notifications off)
- [ ] Time block protected (calendar blocked)
- [ ] Copilot preferences set
```

### During Session

1. **Log work in real-time** - Don't wait until end
2. **Capture decisions immediately** - With rationale
3. **Note insights as they occur** - Even if tangential
4. **Track blockers** - Don't let them stall progress
5. **Take scheduled breaks** - Maintain focus quality

### Post-Session

1. **Complete session review** - While memory fresh
2. **Create atomic notes** - For significant insights
3. **Queue decision notes** - For important decisions
4. **Identify follow-ups** - Next session prep
5. **Update relevant maps** - Cross-reference artifacts

## Copilot Integration

The copilot agent enhances focus sessions by:

- **Context suggestions**: Recommending relevant notes
- **Cross-reference detection**: Identifying connections
- **Decision prompts**: Asking clarifying questions
- **Insight extraction**: Flagging notable observations
- **Session summary**: Generating end-of-session review

### Copilot Commands

```markdown
@copilot suggest context
@copilot find related to [topic]
@copilot summarize progress
@copilot capture insight: [insight text]
@copilot flag decision: [decision text]
```

## Common Focus Session Types

| Type | Duration | Typical Objective |
|------|----------|-------------------|
| Design | 2-3 hours | Create architecture or spec |
| Writing | 90-120 min | Draft document or content |
| Analysis | 2 hours | Deep dive into data/problem |
| Code | 90-180 min | Implement feature or fix |
| Planning | 2 hours | Create plan or roadmap |

## Quality Indicators

A successful focus session:
- Achieved primary objective or made significant progress
- Captured all decisions with rationale
- Created atomic notes for insights
- Identified clear next steps
- Integrated artifacts into knowledge base

## Related Templates

- [[strategic-session.md]] - For strategic planning
- [[research-session.md]] - For investigation tasks
- [[review-session.md]] - For review activities

---

*Part of KAAOS Session Management Templates*
