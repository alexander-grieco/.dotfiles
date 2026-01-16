---
template: reference-note
version: "1.0"
description: Template for reference documentation
usage: Capture stable reference information (specs, APIs, terminology)
placeholders:
  - "{{REF_ID}}" - Unique identifier (e.g., "REF-api-endpoints")
  - "{{TITLE}}" - Reference title
  - "{{DOMAIN}}" - Domain this reference covers
  - "{{CREATED}}" - Creation timestamp
---

# Reference Note Template

Reference notes capture stable information that is looked up rather than learned. They differ from atomic notes in that they prioritize findability and accuracy over insight. Examples include API documentation, terminology glossaries, process specifications, and configuration references.

## Template Structure

```markdown
---
id: {{REF_ID}}
title: {{TITLE}}
type: reference
domain: {{DOMAIN}}
created: {{CREATED}}
modified: {{MODIFIED}}
version: {{VERSION}}
status: current | draft | deprecated
canonical_source: {{SOURCE_URL}}
review_frequency: {{REVIEW_FREQUENCY}}
last_verified: {{LAST_VERIFIED}}
---

# {{TITLE}}

> {{BRIEF_DESCRIPTION}}

## Quick Reference

{{QUICK_REFERENCE_TABLE}}

## Overview

{{OVERVIEW}}

*What is this reference for? When should someone consult it?*

## Contents

### {{SECTION_1_NAME}}

{{SECTION_1_CONTENT}}

### {{SECTION_2_NAME}}

{{SECTION_2_CONTENT}}

### {{SECTION_3_NAME}}

{{SECTION_3_CONTENT}}

## Definitions

| Term | Definition | Notes |
|------|------------|-------|
{{#EACH DEFINITION}}
| {{TERM}} | {{DEFINITION}} | {{NOTES}} |
{{/EACH}}

## Common Use Cases

### {{USE_CASE_1_NAME}}

**Scenario**: {{SCENARIO}}

**Reference needed**: {{WHAT_TO_LOOK_UP}}

**Example**:
```
{{EXAMPLE}}
```

### {{USE_CASE_2_NAME}}

{{USE_CASE_2_CONTENT}}

## Related References

{{#EACH RELATED}}
- [[{{REF_ID}}]]: {{RELATIONSHIP}}
{{/EACH}}

## Changelog

| Version | Date | Changes |
|---------|------|---------|
{{#EACH CHANGE}}
| {{VERSION}} | {{DATE}} | {{DESCRIPTION}} |
{{/EACH}}

## Sources

- Canonical source: {{CANONICAL_SOURCE}}
- Last verified: {{LAST_VERIFIED}}
- Next review: {{NEXT_REVIEW}}

---
*Reference type: {{TYPE}}*
*Maintainer: {{MAINTAINER}}*
```

## Reference Note Types

### API Reference

For documenting APIs, endpoints, and integrations.

```markdown
---
id: REF-api-user-service
title: User Service API Reference
type: reference
domain: engineering
created: 2025-06-01
modified: 2026-01-14
version: 2.1.0
status: current
canonical_source: https://api.example.com/docs
review_frequency: monthly
last_verified: 2026-01-10
---

# User Service API Reference

> Complete reference for the User Service REST API.

## Quick Reference

| Endpoint | Method | Description |
|----------|--------|-------------|
| /users | GET | List all users |
| /users | POST | Create user |
| /users/{id} | GET | Get user by ID |
| /users/{id} | PUT | Update user |
| /users/{id} | DELETE | Delete user |

## Authentication

All requests require Bearer token in Authorization header:

```http
Authorization: Bearer <token>
```

Tokens are obtained via `/auth/token` endpoint.

## Endpoints

### List Users

**GET** `/users`

**Query Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | integer | No | Page number (default: 1) |
| limit | integer | No | Items per page (default: 20, max: 100) |
| status | string | No | Filter by status (active, inactive) |
| search | string | No | Search by name or email |

**Response**:
```json
{
  "users": [
    {
      "id": "usr_123",
      "email": "user@example.com",
      "name": "John Doe",
      "status": "active",
      "created_at": "2026-01-14T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8
  }
}
```

**Status Codes**:
| Code | Description |
|------|-------------|
| 200 | Success |
| 401 | Unauthorized |
| 500 | Server error |

### Create User

**POST** `/users`

**Request Body**:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "role": "member"
}
```

**Required Fields**:
| Field | Type | Constraints |
|-------|------|-------------|
| email | string | Valid email, unique |
| name | string | 1-100 characters |

**Optional Fields**:
| Field | Type | Default |
|-------|------|---------|
| role | string | "member" |
| metadata | object | {} |

**Response** (201 Created):
```json
{
  "id": "usr_456",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "member",
  "status": "active",
  "created_at": "2026-01-14T15:45:00Z"
}
```

**Error Responses**:
| Code | Reason | Body |
|------|--------|------|
| 400 | Validation error | `{"error": "email_invalid", "message": "..."}` |
| 409 | Email exists | `{"error": "email_exists", "message": "..."}` |

## Error Handling

All errors follow this format:

```json
{
  "error": "error_code",
  "message": "Human readable message",
  "details": {}
}
```

**Error Codes**:
| Code | HTTP Status | Description |
|------|-------------|-------------|
| validation_error | 400 | Request validation failed |
| unauthorized | 401 | Invalid or missing token |
| forbidden | 403 | Insufficient permissions |
| not_found | 404 | Resource not found |
| email_exists | 409 | Email already registered |
| rate_limited | 429 | Too many requests |
| internal_error | 500 | Server error |

## Rate Limits

| Tier | Requests/minute | Requests/day |
|------|-----------------|--------------|
| Free | 60 | 1,000 |
| Pro | 300 | 10,000 |
| Enterprise | 1,000 | Unlimited |

Rate limit headers:
- `X-RateLimit-Limit`: Maximum requests
- `X-RateLimit-Remaining`: Remaining requests
- `X-RateLimit-Reset`: Reset timestamp

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.1.0 | 2026-01-10 | Added search parameter to list users |
| 2.0.0 | 2025-12-01 | Updated authentication to Bearer tokens |
| 1.5.0 | 2025-09-15 | Added pagination support |

---
*Reference type: API*
*Maintainer: Engineering team*
```

### Terminology Glossary

For defining domain-specific terms.

```markdown
---
id: REF-kaaos-glossary
title: KAAOS Terminology Glossary
type: reference
domain: kaaos
created: 2026-01-12
modified: 2026-01-14
version: 1.0
status: current
canonical_source: internal
review_frequency: quarterly
last_verified: 2026-01-14
---

# KAAOS Terminology Glossary

> Standard definitions for KAAOS concepts and terminology.

## Core Concepts

### Knowledge Types

| Term | Definition | Example |
|------|------------|---------|
| **Atomic Note** | A self-contained note capturing exactly one idea | "Pre-reads reduce meeting time" |
| **Map Note** | An index note organizing related atomic notes | "Decision Frameworks Map" |
| **Synthesis Note** | A note combining multiple atomics into new insight | "Async practices compound" |
| **Playbook** | A repeatable process document | "Hiring Process Playbook" |
| **Decision Note** | Documentation of a specific decision | "DEC-2026-003 Frontend Lead" |
| **Pattern Note** | Documentation of a recurring observation | "Pre-reads accelerate meetings" |
| **Reference Note** | Stable lookup information | This glossary |

### Operational Rhythms

| Term | Definition | Frequency |
|------|------------|-----------|
| **Daily Digest** | Morning summary of previous day's activity | Daily |
| **Weekly Synthesis** | Pattern detection and gap analysis | Weekly |
| **Monthly Review** | Strategic alignment assessment | Monthly |
| **Quarterly Review** | Comprehensive multi-agent analysis | Quarterly |

### Agents

| Term | Definition | Model |
|------|------------|-------|
| **Orchestrator** | Main coordination agent | Opus |
| **Maintenance Agent** | Handles daily operations | Sonnet |
| **Synthesis Agent** | Performs pattern synthesis | Opus |
| **Copilot Agent** | Real-time session assistant | Sonnet |
| **Gap Detector** | Identifies knowledge gaps | Sonnet |
| **Strategic Reviewer** | Quarterly analysis lead | Opus |

### Note Statuses

| Status | Definition | Action |
|--------|------------|--------|
| **Seedling** | New, undeveloped note | Develop with connections |
| **Budding** | Growing, being refined | Continue development |
| **Evergreen** | Mature, stable note | Periodic review only |

### Confidence Levels

| Level | Definition | Review Frequency |
|-------|------------|------------------|
| **High** | Well-established, strong evidence | 90 days |
| **Medium** | Reasonable support, some uncertainty | 30 days |
| **Low** | Speculative, needs validation | 14 days |

## Identifiers

### ID Conventions

| Type | Format | Example |
|------|--------|---------|
| Atomic Note | YYYY-MM-NNN | 2026-01-050 |
| Decision | DEC-YYYY-NNN | DEC-2026-003 |
| Playbook | PLAY-name | PLAY-hiring-process |
| Map | MAP-name | MAP-decision-frameworks |
| Pattern | PAT-YYYY-NNN | PAT-2026-001 |
| Synthesis | SYN-YYYY-MM-NNN | SYN-2026-01-001 |
| Reference | REF-name | REF-api-endpoints |

### Organization Paths

| Path | Purpose |
|------|---------|
| `/organizations/{org}/` | Organization root |
| `/organizations/{org}/context-library/` | Shared knowledge |
| `/organizations/{org}/projects/{proj}/` | Project-specific |
| `/.kaaos/` | System configuration |
| `/.digests/` | Generated digests |

## Acronyms

| Acronym | Full Form | Context |
|---------|-----------|---------|
| **KAAOS** | Knowledge and Analysis Automated Orchestrated System | System name |
| **LLM** | Large Language Model | Claude/GPT/etc. |
| **MCP** | Model Context Protocol | Tool integration |
| **OKR** | Objectives and Key Results | Goal framework |
| **RACI** | Responsible, Accountable, Consulted, Informed | Decision matrix |

## Related References

- [[REF-kaaos-commands]]: Command reference
- [[REF-kaaos-config]]: Configuration options
- [[REF-note-types]]: Detailed note type guide

---
*Reference type: Glossary*
*Maintainer: KAAOS documentation*
```

### Configuration Reference

For documenting configuration options.

```markdown
---
id: REF-kaaos-config
title: KAAOS Configuration Reference
type: reference
domain: kaaos
created: 2026-01-12
modified: 2026-01-14
version: 1.0
status: current
canonical_source: templates/config/config.yaml.template
review_frequency: monthly
last_verified: 2026-01-14
---

# KAAOS Configuration Reference

> Complete reference for .kaaos/config.yaml options.

## Quick Reference

| Section | Purpose |
|---------|---------|
| cost_controls | API spending limits |
| models | Agent model assignments |
| rhythms | Automated review schedules |
| features | Feature toggles |
| integrations | External service config |

## Configuration Sections

### cost_controls

Controls API spending limits.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| daily_limit_usd | float | 5.00 | Max daily spend |
| weekly_limit_usd | float | 25.00 | Max weekly spend |
| monthly_limit_usd | float | 100.00 | Max monthly spend |
| quarterly_limit_usd | float | 500.00 | Max quarterly spend |
| alert_threshold_percent | int | 80 | Alert when % reached |
| hard_stop_on_limit | bool | true | Stop on limit hit |

**Example**:
```yaml
cost_controls:
  daily_limit_usd: 10.00
  weekly_limit_usd: 50.00
  alert_threshold_percent: 75
```

### models

Assigns Claude models to agent roles.

| Key | Type | Options | Default | Description |
|-----|------|---------|---------|-------------|
| orchestrator | string | opus, sonnet | opus | Main orchestrator |
| research | string | opus, sonnet | sonnet | Research tasks |
| synthesis | string | opus, sonnet | opus | Pattern synthesis |
| maintenance | string | opus, sonnet | sonnet | Daily operations |
| copilot | string | opus, sonnet | sonnet | Session assistant |

**Example**:
```yaml
models:
  orchestrator: opus
  synthesis: opus
  maintenance: sonnet
```

### rhythms

Configures automated review schedules.

#### rhythms.daily

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | true | Enable daily digests |
| hour | int | 7 | Hour to run (0-23) |
| minute | int | 0 | Minute to run (0-59) |

#### rhythms.weekly

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | true | Enable weekly synthesis |
| weekday | int | 1 | Day of week (0=Sun) |
| hour | int | 6 | Hour to run |
| minute | int | 0 | Minute to run |

**Example**:
```yaml
rhythms:
  daily:
    enabled: true
    hour: 6
    minute: 30
  weekly:
    enabled: true
    weekday: 1  # Monday
    hour: 5
```

### features

Feature toggles for KAAOS capabilities.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| git_hooks | bool | true | Install git hooks |
| copilot_suggestions | bool | true | Real-time suggestions |
| auto_organization | bool | true | Auto-organize files |
| auto_maintenance | bool | true | Run maintenance |
| parallel_quarterly | bool | true | Parallel agents |

**Example**:
```yaml
features:
  git_hooks: true
  copilot_suggestions: true
  parallel_quarterly: true
```

## Validation

Configuration is validated on load. Common errors:

| Error | Cause | Fix |
|-------|-------|-----|
| Invalid YAML | Syntax error | Check YAML validity |
| Unknown key | Typo in key name | Check spelling |
| Wrong type | String where int expected | Use correct type |
| Missing required | Required key absent | Add required key |

Validate with:
```bash
yq '.' .kaaos/config.yaml
```

## Related References

- [[REF-kaaos-glossary]]: Terminology definitions
- [[REF-kaaos-commands]]: Command reference

---
*Reference type: Configuration*
*Maintainer: KAAOS documentation*
```

## Reference Note Best Practices

1. **Keep it current**: Reference notes lose value when outdated
2. **Link canonical source**: Always reference authoritative source
3. **Use tables**: Quick scanning is essential for references
4. **Include examples**: Show, don't just tell
5. **Version explicitly**: Track changes over time
6. **Review regularly**: Set and follow review schedules

## Quality Checklist

- [ ] Clear, descriptive title
- [ ] Quick reference table at top
- [ ] Canonical source linked
- [ ] Last verified date recent
- [ ] Changelog maintained
- [ ] Review schedule set
- [ ] Examples for common use cases
- [ ] Related references linked

## Related Templates

- [[atomic-note.md]] - For insights, not reference
- [[playbook-note.md]] - For processes
- [[map-note.md]] - For organizing references

---

*Part of KAAOS Knowledge Management Templates*
