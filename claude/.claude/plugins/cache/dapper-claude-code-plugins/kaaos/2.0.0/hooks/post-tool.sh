#!/usr/bin/env bash
#
# KAAOS Post-Tool Hook
# Captures insights from every tool use (Write, Edit, Bash, etc.)
#
# Exit codes:
#   0 - Success (always, to avoid blocking tool execution)

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

# Function to capture tool usage insight
capture_tool_insight() {
    local kaaos_repo="$1"
    local tool_name="$2"
    local hook_data="$3"
    local timestamp
    timestamp=$(date +%s)

    case "$tool_name" in
        Write|Edit)
            # Capture file writes/edits
            local file_path
            file_path=$(echo "$hook_data" | jq -r '.parameters.file_path // empty' 2>/dev/null || echo "")

            if [[ -n "$file_path" ]]; then
                local insight_dir="$kaaos_repo/.kaaos/insights/tool-usage"
                mkdir -p "$insight_dir"

                # Save tool usage observation
                cat > "$insight_dir/${timestamp}.json" <<TOOLEOF
{
  "timestamp": ${timestamp}000,
  "tool": "$tool_name",
  "file": "$file_path",
  "session": "$(date +%Y-%m-%d-%H%M)",
  "processed": false
}
TOOLEOF
            fi
            ;;

        WebSearch|WebFetch)
            # Capture research activities
            local research_dir="$kaaos_repo/.kaaos/insights/research"
            mkdir -p "$research_dir"

            cat > "$research_dir/${timestamp}.json" <<TOOLEOF
{
  "timestamp": ${timestamp}000,
  "tool": "$tool_name",
  "session": "$(date +%Y-%m-%d-%H%M)",
  "processed": false
}
TOOLEOF
            ;;

        Bash)
            # Capture significant bash commands (optional - can be noisy)
            # Uncomment if you want to track bash command usage
            : # No-op for now
            ;;

        *)
            # Other tools - no capture needed
            : # No-op
            ;;
    esac
}

# Main execution
main() {
    local kaaos_repo
    kaaos_repo=$(find_kaaos_repo)

    # Exit silently if no KAAOS repo found
    if [[ -z "$kaaos_repo" ]]; then
        exit 0
    fi

    # Read hook input from stdin (contains tool name and parameters)
    local hook_data
    hook_data=$(cat) || hook_data=""

    # Exit if no data received
    if [[ -z "$hook_data" ]]; then
        exit 0
    fi

    # Extract tool name
    local tool_name
    tool_name=$(echo "$hook_data" | jq -r '.toolName // empty' 2>/dev/null || echo "")

    # Exit if no tool name found
    if [[ -z "$tool_name" ]]; then
        exit 0
    fi

    # Capture tool usage (wrapped in conditional to prevent errors from blocking)
    capture_tool_insight "$kaaos_repo" "$tool_name" "$hook_data" 2>/dev/null || true

    # Generate real-time co-pilot suggestion
    generate_copilot_suggestion "$kaaos_repo" "$tool_name" "$hook_data"

    # Always exit successfully (don't block tool execution)
    exit 0
}

# Function to generate immediate co-pilot suggestions
generate_copilot_suggestion() {
    local kaaos_repo="$1"
    local tool_name="$2"
    local hook_data="$3"

    # Check if copilot enabled in config
    if ! grep -q "copilot_suggestions: true" "$kaaos_repo/.kaaos/config.yaml" 2>/dev/null; then
        return 0
    fi

    local suggestion=""

    # Check if claude-mem is available (check for MCP server)
    local use_semantic=false
    if ls ~/.claude/plugins/cache/*/claude-mem* &>/dev/null 2>&1; then
        if grep -q "claude_mem.*enabled: true\|use_for_suggestions: true" "$kaaos_repo/.kaaos/config.yaml" 2>/dev/null; then
            use_semantic=true
        fi
    fi

    case "$tool_name" in
        Write|Edit)
            local file_path
            file_path=$(echo "$hook_data" | jq -r '.parameters.file_path // empty' 2>/dev/null || echo "")

            # Only suggest for knowledge files
            if [[ "$file_path" =~ context-library|agents/|commands/|\.md$ ]]; then
                if [[ "$use_semantic" == "true" ]]; then
                    # Use claude-mem for semantic search
                    # Note: This would require MCP tool invocation from bash
                    # For now, document the pattern and let Claude handle it
                    suggestion="💡 Semantic search enabled (claude-mem) - related content will be suggested by Claude based on embeddings"
                else
                    # Fallback to keyword search (current implementation)
                    local filename
                    filename=$(basename "$file_path" .md)

                    # Search for related context (simple grep, fast)
                    local related
                    related=$(grep -rl -i "$filename" "$kaaos_repo/organizations/"*/context-library 2>/dev/null | head -1 || echo "")

                    if [[ -n "$related" ]]; then
                        local rel_path
                        rel_path=$(echo "$related" | sed "s|$kaaos_repo/||")
                        suggestion="💡 Related (keyword): $rel_path"
                    fi
                fi
            fi
            ;;

        WebSearch|WebFetch)
            if [[ "$use_semantic" == "true" ]]; then
                suggestion="💡 Semantic search available - check existing research via claude-mem"
            else
                # Current keyword implementation
                # Check for existing research on similar topics
                local query
                query=$(echo "$hook_data" | jq -r '.parameters.query // .parameters.url // empty' 2>/dev/null || echo "")

                if [[ -n "$query" ]]; then
                    # Extract first meaningful keyword
                    local keyword
                    keyword=$(echo "$query" | tr ' ' '\n' | grep -v '^the$\|^a$\|^an$' | head -1 || echo "")

                    if [[ -n "$keyword" ]]; then
                        # Search for related research
                        local related
                        related=$(grep -il "$keyword" "$kaaos_repo/organizations/"*/context-library/research/*.md 2>/dev/null | head -1 || echo "")

                        if [[ -n "$related" ]]; then
                            local rel_path
                            rel_path=$(echo "$related" | sed "s|$kaaos_repo/||")
                            suggestion="💡 Existing research (keyword): $rel_path"
                        fi
                    fi
                fi
            fi
            ;;
    esac

    # Inject suggestion immediately if found
    if [[ -n "$suggestion" ]]; then
        cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "$suggestion"
  }
}
EOF
    fi
}

# Run main function
main "$@"
