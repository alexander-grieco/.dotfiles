---
name: domain-driven-design
description: |
  Design and review backend APIs using Routes→Handlers→Services→Repositories with clear Domain Model vs DTO boundaries.
  Use PROACTIVELY when creating/refactoring endpoints, moving logic out of handlers, defining service use-cases, or implementing repositories.
  Triggers: DDD, domain-driven design, layered architecture, clean architecture, hexagonal, ports and adapters, repository pattern, service layer, handler, endpoint, API design, refactor backend, business logic, use-case, aggregate, entity, value object, DTO
---

# Backend Layering + DDD (Routes → Handlers → Services → Repositories)

## Goal
Separate **transport**, **business rules**, and **persistence** so code is testable, replaceable, and consistent.

## Layer responsibilities

### Routes (transport wiring)
- Map paths/methods to handlers.
- Attach middleware (auth, tracing, rate limits).
- Construct dependencies (DI); no business logic.

### Handlers (HTTP/RPC boundary; keep thin)
- Parse + validate request data.
- Translate **Request DTO → domain input** (command/query objects).
- Call a service method.
- Translate **domain result/errors → Response DTO + status code**.

### Services (use-cases / application layer)
- Own workflows and business rules.
- Enforce invariants via domain model behavior.
- Coordinate multiple repositories/clients.
- Define transaction/unit-of-work boundaries.
- Return **domain errors** (not HTTP codes).

### Repositories (data access)
- Encapsulate persistence (SQL/Spanner/etc).
- Map **storage record ↔ domain model**.
- Return typed data errors (e.g., not found / conflict), not transport errors.
- No business decisions.

## Domain models (DDD)
Domain models represent business concepts and rules; they should be independent of transport and storage.

### Building blocks
- **Entities**: have identity + lifecycle (e.g., `Order{OrderID,...}`).
- **Value Objects**: immutable, equality by value, validate at construction (e.g., `Email`, `Money`).
- **Aggregates**: consistency boundary; mutate through the **aggregate root** only.

### Domain rules placement
- Put invariants/state transitions on the domain model (methods like `Approve()`, `AddItem()`, `Pay()`).
- Avoid domain models importing HTTP/DB/logging frameworks.
- Prefer constructors/factories for anything with invariants (`NewEmail`, `NewMoney`, etc.).

## DTOs (Data Transfer Objects)
DTOs are boundary types used to match external formats.

- **Handler DTOs**: request/response shapes (JSON/gRPC), versionable API contracts.
- **Repo DTOs** (optional): row/record structs matching storage schema.
- DTOs should be mostly data (minimal/no behavior) and should not own business rules.

## Mapping rules (where conversions happen)
- Handler: **Request DTO → domain command/query**; **domain result → Response DTO**.
- Repository: **storage record ↔ domain entity/value objects**.
- Services: operate on domain types, not transport/storage types.

## Error strategy
- Repository errors: `ErrNotFound`, `ErrConflict`, etc.
- Service errors: domain/use-case errors (`ErrInvalidState`, `ErrInsufficientFunds`, `ErrForbiddenOperation`).
- Handler maps domain/service errors to transport responses.

## Default workflow (apply this pattern)
1. Define endpoint + middleware in Routes.
2. In Handler: parse/validate + map DTO → domain input.
3. In Service: load aggregates, call domain behaviors, coordinate repos, commit transaction.
4. In Repo: perform queries/mutations and map records ↔ domain.

## Review checklist
- Handlers are thin translation layers; no direct DB calls.
- Services express use-cases (not "CRUD mirroring").
- Domain invariants live in domain methods/constructors.
- Repos hide query details and don't enforce business rules.
- Errors flow: repo → service(domain) → handler(transport mapping).

## Integration notes

**Complements**: Feature development skills, code review workflows, architecture planning
**Used when**: Creating new endpoints, refactoring existing code, reviewing PRs for architectural consistency

## Extending this skill

Keep SKILL.md concise. If deeper guidance is needed, create reference files:
- `examples.md` - Code examples for each layer
- `patterns/` - Common patterns (CQRS, event sourcing, etc.)
- `anti-patterns.md` - Common mistakes to avoid
