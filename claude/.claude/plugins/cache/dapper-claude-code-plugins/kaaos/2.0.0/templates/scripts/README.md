# KAAOS Scripts

This directory contains utility scripts for KAAOS knowledge repository management.

## Overview

KAAOS uses shell scripts for:
- **Knowledge Graph Analysis** - Compute metrics about your knowledge base
- **Backup Operations** - Automated backup and recovery
- **Automation Integration** - Integration with macOS launchd for scheduled reviews

## Available Scripts

### graph-metrics.sh

Analyzes the knowledge graph structure by parsing `[[wikilinks]]` from markdown files.

**Usage:**
```bash
./graph-metrics.sh [repo-path] [--json|--ascii|--mermaid]
```

**Output Modes:**
- `--json` (default): Machine-readable JSON with all metrics
- `--ascii`: Human-readable terminal output
- `--mermaid`: Mermaid diagram of top hubs

**Example Output (JSON):**
```json
{
  "calculated_at": "2026-01-15T10:30:00-08:00",
  "total_notes": 156,
  "total_references": 423,
  "orphan_count": 12,
  "orphans": ["notes/draft-idea.md", "archive/old-project.md"],
  "hub_count": 5,
  "hubs": ["MAP-decisions:24", "PLAY-hiring:18"],
  "average_connectivity": 2.71,
  "density": 0.0175
}
```

**Metrics Explained:**
- `total_notes`: Number of markdown files in organizations/
- `total_references`: Total count of [[wikilinks]] found
- `orphan_count`: Notes with zero inbound links
- `hub_count`: Notes with >10 inbound links
- `average_connectivity`: References per note (higher = more connected)
- `density`: Actual edges / possible edges (sparse graphs are <0.1)

### backup.sh (Template)

Production-ready backup script supporting multiple strategies and destinations.

**Note:** The backup.sh script is provided as a template. Install it using:
```bash
/kaaos:init [org-name]  # Installs during initialization
```

Or manually copy from the KAAOS plugin:
```bash
cp ${CLAUDE_PLUGIN_ROOT}/templates/scripts/backup.sh ~/.kaaos-knowledge/.kaaos/scripts/
chmod +x ~/.kaaos-knowledge/.kaaos/scripts/backup.sh
```

**Features:**
- Full and incremental git bundle creation
- rsync to local, network, or cloud destinations
- Comprehensive error handling and logging
- Dry-run mode for testing
- Automatic cleanup with configurable retention
- State tracking for incremental backups
- Email notifications (optional)
- Cron/launchd integration ready

**Usage:**
```bash
./backup.sh [--full|--incremental] [--dry-run] [--notify]
```

## Automation Scripts

The following scripts are created during `/kaaos:init` and placed in `~/.kaaos/automation/`:

### daily-review.sh

Creates marker file for daily digest generation.

```bash
#!/bin/bash
set -euo pipefail

MARKER_DIR="$HOME/.kaaos/pending-reviews"
mkdir -p "$MARKER_DIR"

DATE=$(date +%Y-%m-%d)
MARKER_FILE="$MARKER_DIR/daily-$DATE.marker"

# Skip if already created today
if [[ -f "$MARKER_FILE" ]]; then
    echo "Daily marker already exists for $DATE"
    exit 0
fi

cat > "$MARKER_FILE" <<EOF
type: daily
created_at: $(date -Iseconds)
status: pending
repository: ${KAAOS_REPO:-$HOME/kaaos-knowledge}
EOF

# Optional: macOS notification
if [[ "${KAAOS_NOTIFY:-true}" == "true" ]]; then
    osascript -e 'display notification "Daily digest ready to generate" with title "KAAOS"' 2>/dev/null || true
fi

echo "Created daily review marker: $MARKER_FILE"
```

### weekly-synthesis.sh

Creates marker file for weekly synthesis.

```bash
#!/bin/bash
set -euo pipefail

MARKER_DIR="$HOME/.kaaos/pending-reviews"
mkdir -p "$MARKER_DIR"

WEEK=$(date +%Y-W%V)
MARKER_FILE="$MARKER_DIR/weekly-$WEEK.marker"

# Skip if already created this week
if [[ -f "$MARKER_FILE" ]]; then
    echo "Weekly marker already exists for $WEEK"
    exit 0
fi

cat > "$MARKER_FILE" <<EOF
type: weekly
week: $WEEK
created_at: $(date -Iseconds)
status: pending
repository: ${KAAOS_REPO:-$HOME/kaaos-knowledge}
EOF

# Optional: macOS notification
if [[ "${KAAOS_NOTIFY:-true}" == "true" ]]; then
    osascript -e 'display notification "Weekly synthesis ready to generate" with title "KAAOS"' 2>/dev/null || true
fi

echo "Created weekly synthesis marker: $MARKER_FILE"
```

### monthly-review.sh

Creates marker file for monthly review.

```bash
#!/bin/bash
set -euo pipefail

MARKER_DIR="$HOME/.kaaos/pending-reviews"
mkdir -p "$MARKER_DIR"

MONTH=$(date +%Y-%m)
MARKER_FILE="$MARKER_DIR/monthly-$MONTH.marker"

# Skip if already created this month
if [[ -f "$MARKER_FILE" ]]; then
    echo "Monthly marker already exists for $MONTH"
    exit 0
fi

cat > "$MARKER_FILE" <<EOF
type: monthly
month: $MONTH
created_at: $(date -Iseconds)
status: pending
repository: ${KAAOS_REPO:-$HOME/kaaos-knowledge}
EOF

# Optional: macOS notification
if [[ "${KAAOS_NOTIFY:-true}" == "true" ]]; then
    osascript -e 'display notification "Monthly review ready to generate" with title "KAAOS"' 2>/dev/null || true
fi

echo "Created monthly review marker: $MARKER_FILE"
```

### quarterly-review.sh

Creates marker file for quarterly review.

```bash
#!/bin/bash
set -euo pipefail

MARKER_DIR="$HOME/.kaaos/pending-reviews"
mkdir -p "$MARKER_DIR"

# Calculate quarter
MONTH=$(date +%-m)
YEAR=$(date +%Y)
QUARTER=$(( (MONTH - 1) / 3 + 1 ))
QUARTER_ID="${YEAR}-Q${QUARTER}"

MARKER_FILE="$MARKER_DIR/quarterly-$QUARTER_ID.marker"

# Skip if already created this quarter
if [[ -f "$MARKER_FILE" ]]; then
    echo "Quarterly marker already exists for $QUARTER_ID"
    exit 0
fi

cat > "$MARKER_FILE" <<EOF
type: quarterly
quarter: $QUARTER_ID
year: $YEAR
quarter_number: $QUARTER
created_at: $(date -Iseconds)
status: pending
repository: ${KAAOS_REPO:-$HOME/kaaos-knowledge}
parallel_agents: true
EOF

# Optional: macOS notification
if [[ "${KAAOS_NOTIFY:-true}" == "true" ]]; then
    osascript -e 'display notification "Quarterly review ready - comprehensive analysis queued" with title "KAAOS"' 2>/dev/null || true
fi

echo "Created quarterly review marker: $MARKER_FILE"
```

## Integration with launchd

See `templates/config/launchd-example.plist` for detailed launchd configuration examples.

**Quick Setup:**
```bash
# Create automation directory
mkdir -p ~/.kaaos/automation ~/.kaaos/logs ~/.kaaos/pending-reviews

# Copy scripts (created by /kaaos:init)
# Each script goes to ~/.kaaos/automation/

# Create launchd plists
# Copy launchd-example.plist for each review type
# Edit paths and schedule

# Load all agents
launchctl load ~/Library/LaunchAgents/com.kaaos.daily-review.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.weekly-synthesis.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.monthly-review.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.quarterly-review.plist
```

## Script Development Guidelines

When creating new KAAOS scripts:

1. **Use strict mode:**
   ```bash
   set -euo pipefail
   ```

2. **Support KAAOS environment variables:**
   - `KAAOS_REPO` - Repository path
   - `KAAOS_NOTIFY` - Enable notifications
   - `KAAOS_DEBUG` - Enable debug output

3. **Log to standard KAAOS locations:**
   ```bash
   LOG_DIR="${KAAOS_REPO:-.}/.kaaos/logs"
   ```

4. **Use marker files for deferred execution:**
   - Scripts should be quick (<1 second)
   - Create marker files that KAAOS detects
   - Actual work happens when Claude is active

5. **Handle errors gracefully:**
   ```bash
   trap 'echo "Error on line $LINENO" >> "$LOG_DIR/errors.log"' ERR
   ```

6. **Test with dry-run mode:**
   ```bash
   if [[ "${DRY_RUN:-false}" == "true" ]]; then
       echo "Would do X"
   else
       do_x
   fi
   ```

## Troubleshooting

### Scripts not executing

1. **Check permissions:**
   ```bash
   chmod +x ~/.kaaos/automation/*.sh
   ```

2. **Verify launchd status:**
   ```bash
   launchctl list | grep kaaos
   ```

3. **Check logs:**
   ```bash
   tail -f ~/.kaaos/logs/*.log
   ```

### Marker files not detected

1. **Verify marker directory:**
   ```bash
   ls -la ~/.kaaos/pending-reviews/
   ```

2. **Check marker format:**
   ```bash
   cat ~/.kaaos/pending-reviews/*.marker
   ```

### Notifications not appearing

1. **Check macOS notification settings:**
   System Preferences > Notifications > Script Editor

2. **Test osascript:**
   ```bash
   osascript -e 'display notification "Test" with title "KAAOS"'
   ```

## Related Documentation

- Configuration: `templates/config/config.yaml.template`
- Launchd: `templates/config/launchd-example.plist`
- Digest templates: `templates/digests/`
- Session templates: `templates/session/`

---

*Part of KAAOS - Knowledge and Analysis Automated Orchestrated System*
