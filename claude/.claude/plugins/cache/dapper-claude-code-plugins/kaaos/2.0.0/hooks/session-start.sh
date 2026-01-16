#!/usr/bin/env bash
#
# KAAOS Session Start Hook
# Checks for pending automation when Claude Code starts
#
# Exit codes:
#   0 - Success (with or without pending reviews)
#   Non-zero codes are avoided to prevent blocking Claude Code startup

set -Eeo pipefail

# Function to find KAAOS repo
find_kaaos_repo() {
    if [[ -d "$HOME/kaaos-knowledge/.kaaos" ]]; then
        echo "$HOME/kaaos-knowledge"
    elif [[ -d "$PWD/.kaaos" ]]; then
        echo "$PWD"
    else
        # No KAAOS repo found
        echo ""
    fi
}

# Function to check claude-mem recommendation
check_claude_mem_recommendation() {
    local repo="$1"

    # Check if we've already shown this recommendation
    if [[ -f "$repo/.kaaos/state/claude-mem-prompted" ]]; then
        return 0
    fi

    # Check if claude-mem is installed
    if ! ls ~/.claude/plugins/cache/*/claude-mem* &>/dev/null 2>&1; then
        # Not installed - recommend once
        cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "💡 KAAOS Enhancement Available

Install claude-mem for semantic cross-linking:
  /plugin marketplace add thedotmack/claude-mem
  /plugin install claude-mem

Benefits: Find related content by meaning (not just keywords)

This is optional - KAAOS works fine without it.
To dismiss: touch ~/.kaaos/state/claude-mem-prompted"
  }
}
EOF

        # Mark as prompted
        mkdir -p "$repo/.kaaos/state" 2>/dev/null || true
        touch "$repo/.kaaos/state/claude-mem-prompted" 2>/dev/null || true
    else
        # claude-mem is installed - update config if needed
        if ! grep -q "claude_mem:" "$repo/.kaaos/config.yaml" 2>/dev/null; then
            # Add integration config (log for manual update)
            echo "$(date -Iseconds): claude-mem detected but not configured in config.yaml" >> "$repo/.kaaos/logs/integration.log" 2>/dev/null || true
        fi
    fi
}

# Main execution
main() {
    local kaaos_repo
    kaaos_repo=$(find_kaaos_repo)

    # Exit silently if no KAAOS repo found
    if [[ -z "$kaaos_repo" ]]; then
        exit 0
    fi

    # Check for pending reviews
    local pending_reviews=()
    local automation_dir="$kaaos_repo/.kaaos/automation"

    if [[ -d "$automation_dir" ]]; then
        for review_type in daily weekly monthly quarterly; do
            if [[ -f "$automation_dir/${review_type}-pending" ]]; then
                pending_reviews+=("$review_type")
            fi
        done
    fi

    # If pending reviews found, inject context to trigger processing
    if [[ ${#pending_reviews[@]} -gt 0 ]]; then
        local pending_list="${pending_reviews[*]}"

        cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "KAAOS: Pending reviews detected: $pending_list

These will be processed automatically in background when you run your first KAAOS command.

Pending reviews: $pending_list
- Run any KAAOS command to trigger background processing
- Or manually: /kaaos:review [type]"
  }
}
EOF
    fi

    # Check for claude-mem recommendation (only if no pending reviews)
    if [[ ${#pending_reviews[@]} -eq 0 ]]; then
        check_claude_mem_recommendation "$kaaos_repo"
    fi

    exit 0
}

# Run main function
main "$@"
