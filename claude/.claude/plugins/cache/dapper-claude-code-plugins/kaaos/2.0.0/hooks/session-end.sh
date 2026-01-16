#!/usr/bin/env bash
#
# KAAOS Session End Hook
# Summarizes session and commits insights
#
# Exit codes:
#   0 - Success (always, to avoid blocking Claude Code shutdown)

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

# Function to count unprocessed insights
count_tool_insights() {
    local kaaos_repo="$1"
    local insight_dir="$kaaos_repo/.kaaos/insights/tool-usage"

    if [[ -d "$insight_dir" ]]; then
        find "$insight_dir" -name "*.json" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# Function to create session summary
create_session_summary() {
    local kaaos_repo="$1"
    local tool_count="$2"
    local session_id
    session_id=$(date +%Y-%m-%d-%H%M)
    local timestamp
    timestamp=$(date +%s)

    local sessions_dir="$kaaos_repo/.kaaos/insights/sessions"
    mkdir -p "$sessions_dir"

    cat > "$sessions_dir/${session_id}.json" <<EOF
{
  "session_id": "$session_id",
  "ended_at": ${timestamp}000,
  "tool_usage_count": $tool_count,
  "processed": false
}
EOF
}

# Function to log session end
log_session_end() {
    local kaaos_repo="$1"
    local session_id="$2"
    local tool_count="$3"

    local logs_dir="$kaaos_repo/.kaaos/logs"
    mkdir -p "$logs_dir"

    local timestamp
    timestamp=$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)

    echo "[$timestamp] Session $session_id ended - $tool_count tool insights captured" >> "$logs_dir/sessions.log"
}

# Main execution
main() {
    local kaaos_repo
    kaaos_repo=$(find_kaaos_repo)

    # Exit silently if no KAAOS repo found
    if [[ -z "$kaaos_repo" ]]; then
        exit 0
    fi

    # Check if there are unprocessed tool usage insights
    local tool_insights
    tool_insights=$(count_tool_insights "$kaaos_repo")

    if [[ "$tool_insights" -gt 0 ]]; then
        # Create session summary marker
        local session_id
        session_id=$(date +%Y-%m-%d-%H%M)

        create_session_summary "$kaaos_repo" "$tool_insights" 2>/dev/null || true
        log_session_end "$kaaos_repo" "$session_id" "$tool_insights" 2>/dev/null || true
    fi

    # Auto-organize files
    organize_files "$kaaos_repo" 2>/dev/null || true

    # Always exit successfully
    exit 0
}

# Function to auto-organize orphaned files
organize_files() {
    local kaaos_repo="$1"

    # Check if auto-organization enabled
    if ! grep -q "auto_organization: true" "$kaaos_repo/.kaaos/config.yaml" 2>/dev/null; then
        return 0
    fi

    # Find orphaned markdown files in repo root
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue

        # Determine where file should go based on content
        if grep -q "^# Research:" "$file" 2>/dev/null; then
            # Research report - find organization and move to research/
            local org
            org=$(ls -1 "$kaaos_repo/organizations" 2>/dev/null | head -1)

            if [[ -n "$org" ]]; then
                local dest="$kaaos_repo/organizations/$org/context-library/research"
                mkdir -p "$dest"
                mv "$file" "$dest/" 2>/dev/null && \
                    echo "$(date -Iseconds) Organized: $(basename "$file") → $dest/" >> "$kaaos_repo/.kaaos/logs/organization.log"
            fi

        elif grep -q "^# Decision:" "$file" 2>/dev/null; then
            # Decision record
            local org
            org=$(ls -1 "$kaaos_repo/organizations" 2>/dev/null | head -1)

            if [[ -n "$org" ]]; then
                local dest="$kaaos_repo/organizations/$org/context-library/decisions"
                mkdir -p "$dest"
                mv "$file" "$dest/" 2>/dev/null && \
                    echo "$(date -Iseconds) Organized: $(basename "$file") → $dest/" >> "$kaaos_repo/.kaaos/logs/organization.log"
            fi
        fi
    done < <(find "$kaaos_repo" -maxdepth 1 -name "*.md" -type f 2>/dev/null)

    # Clean up empty directories in conversations/
    find "$kaaos_repo/organizations/"*/projects/*/conversations -type d -empty -delete 2>/dev/null || true

    # Remove old temp files
    find "$kaaos_repo/.kaaos/cache" -name "*.tmp" -mtime +7 -delete 2>/dev/null || true
}

# Run main function
main "$@"
