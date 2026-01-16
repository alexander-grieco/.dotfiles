#!/usr/bin/env bash
#
# KAAOS Knowledge Graph Metrics Calculator
# Parses [[references]] from markdown files and computes graph metrics
#
# Usage:
#   ./graph-metrics.sh [repo-path] [--json|--ascii]
#
# Outputs JSON by default with metrics about the knowledge graph

set -euo pipefail

REPO="${1:-$HOME/kaaos-knowledge}"
FORMAT="${2:---json}"

# Arrays for tracking graph structure
declare -A INBOUND_COUNT   # basename -> count of inbound refs
declare -A OUTBOUND_COUNT  # filepath -> count of outbound refs
ALL_FILES=()
TOTAL_REF=0

# Find all markdown files in organizations/
while IFS= read -r file; do
    # Skip if file doesn't exist or isn't readable
    [[ -f "$file" ]] || continue

    # Get relative path
    rel=$(echo "$file" | sed "s|$REPO/||")
    ALL_FILES+=("$rel")

    # Get basename for inbound tracking
    base=$(basename "$file" .md)

    # Extract [[references]] - matches [[text]] or [[text|display]]
    # Uses grep -oE to find all matches, sed to clean up
    refs=$(grep -oE '\[\[([^]|]+)' "$file" 2>/dev/null | sed 's/\[\[//g; s/|.*//' || true)

    ref_count=0
    for ref in $refs; do
        # Clean reference (remove section anchors like #section)
        ref_clean=$(echo "$ref" | sed 's/#.*//')

        # Skip empty references
        [[ -z "$ref_clean" ]] && continue

        # Get basename of reference for tracking
        ref_base=$(basename "$ref_clean" .md)

        # Track outbound from this file
        ref_count=$((ref_count + 1))

        # Track inbound to referenced file (by basename)
        INBOUND_COUNT["$ref_base"]=$((${INBOUND_COUNT["$ref_base"]:-0} + 1))
    done

    # Store outbound count for this file
    if [[ $ref_count -gt 0 ]]; then
        OUTBOUND_COUNT["$rel"]=$ref_count
        TOTAL_REF=$((TOTAL_REF + ref_count))
    fi

done < <(find "$REPO/organizations" -name "*.md" -type f 2>/dev/null)

# Calculate aggregate metrics
TOTAL_NOTES=${#ALL_FILES[@]}

# Find orphans (files with 0 inbound references)
ORPHANS=()
for file in "${ALL_FILES[@]}"; do
    base=$(basename "$file" .md)
    if [[ ${INBOUND_COUNT["$base"]:-0} -eq 0 ]]; then
        ORPHANS+=("$file")
    fi
done

# Find hubs (files with >10 inbound references)
HUBS=()
for note in "${!INBOUND_COUNT[@]}"; do
    count=${INBOUND_COUNT["$note"]}
    if [[ $count -gt 10 ]]; then
        HUBS+=("$note:$count")
    fi
done

# Calculate average connectivity
if [[ $TOTAL_NOTES -gt 0 ]]; then
    AVG=$(echo "scale=2; $TOTAL_REF / $TOTAL_NOTES" | bc -l 2>/dev/null || echo "0")
else
    AVG="0"
fi

# Calculate density (actual edges / possible edges)
# For directed graph: possible = n * (n-1)
if [[ $TOTAL_NOTES -gt 1 ]]; then
    POSSIBLE=$((TOTAL_NOTES * (TOTAL_NOTES - 1)))
    DENSITY=$(echo "scale=4; $TOTAL_REF / $POSSIBLE" | bc -l 2>/dev/null || echo "0")
else
    DENSITY="0"
fi

# Output based on format
if [[ "$FORMAT" == "--ascii" ]]; then
    # ASCII visualization
    cat <<EOF

Knowledge Graph Structure ($TOTAL_NOTES notes, $TOTAL_REF connections)

Average Connectivity: $AVG references per note
Graph Density: $DENSITY

Orphaned Notes (${#ORPHANS[@]}):
EOF
    printf '  - %s\n' "${ORPHANS[@]}" | head -10
    if [[ ${#ORPHANS[@]} -gt 10 ]]; then
        echo "  ... and $((${#ORPHANS[@]} - 10)) more"
    fi

    cat <<EOF

Top Hubs (${#HUBS[@]} notes with >10 connections):
EOF
    printf '  - %s\n' "${HUBS[@]}" | sort -t: -k2 -nr | head -5

elif [[ "$FORMAT" == "--mermaid" ]]; then
    # Mermaid diagram (simplified - just top hubs)
    echo "graph LR"
    printf '  - %s\n' "${HUBS[@]}" | sort -t: -k2 -nr | head -5 | while IFS=: read -r name count; do
        echo "    $name[\"$name<br/>$count refs\"]"
    done

else
    # JSON output (default)
    cat <<EOF
{
  "calculated_at": "$(date -Iseconds)",
  "total_notes": $TOTAL_NOTES,
  "total_references": $TOTAL_REF,
  "orphan_count": ${#ORPHANS[@]},
  "orphans": $(printf '%s\n' "${ORPHANS[@]}" | jq -R . | jq -s . 2>/dev/null || echo '[]'),
  "hub_count": ${#HUBS[@]},
  "hubs": $(printf '%s\n' "${HUBS[@]}" | jq -R . | jq -s . 2>/dev/null || echo '[]'),
  "average_connectivity": $AVG,
  "density": $DENSITY
}
EOF
fi
