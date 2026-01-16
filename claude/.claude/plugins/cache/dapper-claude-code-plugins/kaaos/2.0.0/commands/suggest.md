---
description: Analyze conversation and suggest relevant context from knowledge base
argument-hint: "[optional-topic]"
---

# KAAOS Context Suggestion

Get on-demand suggestions for relevant context from your knowledge base.

## Usage
```bash
# Analyze recent conversation for relevant context
/kaaos:suggest

# Suggest context for specific topic
/kaaos:suggest "api design patterns"

# Quick check for kubernetes content
/kaaos:suggest kubernetes
```

## Implementation

You are the KAAOS Orchestrator handling a context suggestion request.

### Phase 1: Locate KAAOS Repository

Use Bash tool to find KAAOS repository:
```bash
if [ -d .kaaos ]; then
  echo "$PWD"
elif [ -d ~/kaaos-knowledge/.kaaos ]; then
  echo "$HOME/kaaos-knowledge"
else
  echo "NOT_FOUND"
fi
```

If NOT_FOUND, display error:
```
Error: KAAOS repository not found

Run '/kaaos:init [org-name]' to initialize.
```

Set REPO_PATH to the found directory.

### Phase 2: Determine Organization Context

Use Read tool to load `.kaaos/state/system-state.json`.

Extract current_session.organization if session active.

If no active session:
- Use default_organization from system-state.json
- Or list organizations and prompt for selection

Set ORG_NAME and PROJECT_NAME (if available).

### Phase 3: Determine Search Topics

If topic argument provided:
- Use provided topic directly as primary keyword
- Split on spaces to get 2-3 keywords
- Example: "api design patterns" → ["api", "design", "patterns"]

If no argument provided:
- Extract keywords from recent user messages
- Look at last 10 messages in conversation
- Identify key nouns, technical terms, domain concepts
- Select top 3-5 most relevant

Display what's being searched:
```
Searching for context related to: [keyword1, keyword2, keyword3]
```

### Phase 4: Search Context Libraries

Use Grep tool to search across organizational and project context:

```bash
# Search organization context
grep -ril "keyword1\|keyword2\|keyword3" \
  "$REPO_PATH/organizations/$ORG_NAME/context-library" 2>/dev/null
```

If project context exists:
```bash
# Search project context
grep -ril "keyword1\|keyword2\|keyword3" \
  "$REPO_PATH/organizations/$ORG_NAME/projects/$PROJECT_NAME/context-library" 2>/dev/null
```

Collect all matching file paths (limit to 20 results).

For each match:
- Use Read tool to load first 20 lines
- Extract title (first # heading)
- Extract summary (first paragraph after heading)
- Determine category from directory path
- Count keyword matches (for relevance ranking)

### Phase 5: Rank Results by Relevance

Calculate relevance score for each match:
- High relevance: 3+ keywords matched
- Medium relevance: 2 keywords matched
- Low relevance: 1 keyword matched

Also boost score if:
- File recently modified (last 7 days) +1
- File in research/ category +0.5 (likely most relevant)
- File is a MAP or PLAY (overview documents) +0.5

Sort results by relevance score (descending).

### Phase 6: Display Results

Format and display results:

```
Found [count] relevant context items:

High Relevance ([count]):
  1. research/api-design-patterns-2026-01-10.md
     Keywords: api, design, patterns (3 matches)
     Summary: RESTful API design best practices and authentication
     Updated: 4 days ago

  2. decisions/api-versioning-strategy-2026-01-05.md
     Keywords: api, design (2 matches)
     Summary: Decided on URL-based versioning approach
     Updated: 9 days ago

Medium Relevance ([count]):
  3. patterns/microservices-apis-2025-12.md
     Keywords: api, patterns (2 matches)
     Summary: Common API patterns in microservices architecture
     Updated: 32 days ago

  4. MAP-backend-architecture.md
     Keywords: api (1 match)
     Summary: Backend system architecture and API gateway design
     Updated: 18 days ago

Low Relevance ([count]):
  5. playbooks/code-review-checklist.md
     Keywords: design (1 match)
     Summary: Code review process and quality standards
     Updated: 45 days ago

───────────────────────────────────────────────────────────────

Load context: Enter numbers like [1], [1,2,3], [1-3], [all], or [none]
```

If no results found:
```
No context found matching: [keywords]

Available categories in your library:
  - research/ ([count] files)
  - decisions/ ([count] files)
  - patterns/ ([count] files)
  - playbooks/ ([count] files)

Try:
  - /kaaos:suggest "[different keywords]"
  - Browse: ls ~/kaaos-knowledge/organizations/[org]/context-library/
```

### Phase 7: Handle User Selection

Wait for user input on what to load.

Parse user input:
- `1` → Load item 1
- `1,2,3` → Load items 1, 2, and 3
- `1-3` → Load items 1 through 3
- `all` → Load all results
- `none` or `cancel` → Skip loading

For selected items, use Read tool to load each file.

Track total tokens loaded (estimate: filesize / 4).

### Phase 8: Display Loaded Context Summary

If files were loaded:
```
Loaded [count] context file(s):
  • API Design Patterns (research, ~3,200 tokens)
  • API Versioning Strategy (decisions, ~1,800 tokens)

Total context loaded: ~5,000 tokens
Session total: ~[cumulative] tokens

Context is now available. How can this help with your work?
```

If no files loaded (user said "none"):
```
No additional context loaded. Continuing without extra context.
```

### Phase 9: Update Session Metadata (Optional)

If this is part of an active session, optionally log what context was suggested/loaded for session summary purposes.

This helps track which context proved most useful over time.

## Error Handling

### No Active Session
If no session active and no organization can be determined:
```
No active KAAOS session detected.

Start a session first:
  /kaaos:session [org]/[project]

Or specify organization:
  /kaaos:suggest "[topic]" --org [org-name]
```

### Empty Context Library
If organization has no context library files:
```
Context library is empty for organization: [org-name]

Create your first context entry:
  - Add files to: ~/kaaos-knowledge/organizations/[org]/context-library/
  - Or spawn research: /kaaos:research "[topic]"
```

### Search Errors
If grep fails or times out:
```
Error searching context library.

This may indicate:
  - Very large context library (>1000 files)
  - Permission issues
  - Corrupted file system

Try:
  - Check repository: ls ~/kaaos-knowledge/
  - Restart Claude Code
  - Run: /kaaos:status for health check
```

## Performance Notes

- Search completes in < 5 seconds for typical libraries (<100 files)
- Grep with head -20 limits result processing time
- Loading files is lazy (only loads what user selects)
- Can be called multiple times per session
- No state changes (read-only operation)

## Use Cases

### During Active Work
```
User: "I'm designing a new API endpoint"
User: /kaaos:suggest "api design"

[System suggests relevant patterns/decisions]
[User loads applicable context]
[Continues with better-informed implementation]
```

### Exploring Knowledge Base
```
User: /kaaos:suggest "authentication"

[System shows all auth-related content]
[User discovers past research they'd forgotten]
[Leverages prior insights]
```

### Quick Reference
```
User: "What was our decision on error handling?"
User: /kaaos:suggest "error handling decisions"

[System finds decisions/error-handling-strategy.md]
[User loads and gets immediate answer]
```

## Integration with Other Commands

Complements:
- `/kaaos:session` - Provides automatic proactive suggestions
- `/kaaos:research` - Check existing research before spawning
- `/kaaos:status` - See what context exists

Difference from session copilot:
- Session copilot is automatic (every message)
- /suggest is manual (when you want it)
- Both use same search mechanism
- /suggest gives user explicit control

## Notes

- Fast, lightweight command (< $0.01 cost)
- Works with any organization/project
- No agent spawning needed (orchestrator handles directly)
- Results cached in conversation for follow-up questions
- Can be used outside of active session (with --org flag if needed)
