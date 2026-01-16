#!/usr/bin/env bash
#===============================================================================
# KAAOS Backup Script
#===============================================================================
# Production-ready backup solution for KAAOS knowledge repositories
#
# Features:
#   - Full and incremental git bundles
#   - rsync to multiple destinations (local, remote, cloud)
#   - Comprehensive error handling and logging
#   - Dry-run mode for testing
#   - Compression support (gzip, bzip2, xz)
#   - State tracking with JSON
#   - Email notifications
#   - Automatic cleanup with retention policies
#   - Cron-ready with proper logging
#   - Verification and integrity checks
#
# Usage:
#   backup.sh [OPTIONS] <repository-path>
#
# Examples:
#   backup.sh ~/kaaos-knowledge
#   backup.sh --dry-run ~/kaaos-knowledge
#   backup.sh --incremental --dest=/backup/kaaos ~/kaaos-knowledge
#   backup.sh --full --compress=xz --notify ~/kaaos-knowledge
#
# Author: KAAOS System
# Version: 1.0.0
# License: MIT
#===============================================================================

set -euo pipefail
IFS=$'\n\t'

#===============================================================================
# Configuration
#===============================================================================

# Script metadata
readonly SCRIPT_NAME="kaaos-backup"
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration
DEFAULT_BACKUP_DIR="${HOME}/.kaaos/backups"
DEFAULT_RETENTION_DAYS=30
DEFAULT_RETENTION_FULL=4
DEFAULT_RETENTION_INCREMENTAL=14
DEFAULT_COMPRESSION="gzip"
DEFAULT_LOG_DIR="${HOME}/.kaaos/logs"
DEFAULT_STATE_FILE="${HOME}/.kaaos/state/backup-state.json"

# Runtime configuration (set via options)
REPO_PATH=""
BACKUP_DIR=""
BACKUP_TYPE="auto"  # auto, full, incremental
COMPRESSION=""
DRY_RUN=false
VERBOSE=false
NOTIFY=false
NOTIFY_EMAIL=""
VERIFY=true
DESTINATIONS=()
RETENTION_DAYS=""
RETENTION_FULL=""
RETENTION_INCREMENTAL=""
LOG_FILE=""
STATE_FILE=""

# Computed values
TIMESTAMP=""
BACKUP_NAME=""
BUNDLE_FILE=""
ARCHIVE_FILE=""

#===============================================================================
# Logging Functions
#===============================================================================

# Colors for terminal output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Format based on level
    local color=""
    local prefix=""
    case "$level" in
        INFO)  color="$GREEN"; prefix="[INFO]" ;;
        WARN)  color="$YELLOW"; prefix="[WARN]" ;;
        ERROR) color="$RED"; prefix="[ERROR]" ;;
        DEBUG) color="$CYAN"; prefix="[DEBUG]" ;;
        *)     color="$NC"; prefix="[$level]" ;;
    esac

    # Print to stderr (so stdout is clean for pipes)
    if [[ "$VERBOSE" == true ]] || [[ "$level" != "DEBUG" ]]; then
        echo -e "${color}${prefix}${NC} ${message}" >&2
    fi

    # Write to log file if configured
    if [[ -n "$LOG_FILE" ]]; then
        echo "${timestamp} ${prefix} ${message}" >> "$LOG_FILE"
    fi
}

info()  { log INFO "$@"; }
warn()  { log WARN "$@"; }
error() { log ERROR "$@"; }
debug() { log DEBUG "$@"; }

die() {
    error "$@"
    send_notification "FAILED" "$*"
    exit 1
}

#===============================================================================
# Utility Functions
#===============================================================================

# Check if command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Get human-readable file size
human_size() {
    local bytes="$1"
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0

    while (( bytes > 1024 && unit < ${#units[@]} - 1 )); do
        bytes=$((bytes / 1024))
        ((unit++))
    done

    echo "${bytes}${units[$unit]}"
}

# Get ISO timestamp
get_timestamp() {
    date '+%Y%m%d-%H%M%S'
}

# Get ISO date for logs
get_iso_date() {
    date -u '+%Y-%m-%dT%H:%M:%SZ'
}

# Ensure directory exists
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            debug "Would create directory: $dir"
        else
            mkdir -p "$dir"
            debug "Created directory: $dir"
        fi
    fi
}

# Get git repository info
get_repo_info() {
    local repo="$1"
    cd "$repo"

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    local commit
    commit=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    local dirty=""
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        dirty="-dirty"
    fi

    echo "${branch}-${commit}${dirty}"
}

# Calculate checksum of file
calculate_checksum() {
    local file="$1"
    if command_exists sha256sum; then
        sha256sum "$file" | cut -d' ' -f1
    elif command_exists shasum; then
        shasum -a 256 "$file" | cut -d' ' -f1
    else
        md5sum "$file" | cut -d' ' -f1
    fi
}

#===============================================================================
# State Management
#===============================================================================

# Initialize state file
init_state() {
    ensure_dir "$(dirname "$STATE_FILE")"

    if [[ ! -f "$STATE_FILE" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            debug "Would create state file: $STATE_FILE"
            return
        fi

        cat > "$STATE_FILE" <<EOF
{
  "version": "1.0",
  "created_at": "$(get_iso_date)",
  "last_backup": null,
  "last_full_backup": null,
  "last_incremental_backup": null,
  "total_backups": 0,
  "total_size_bytes": 0,
  "history": []
}
EOF
        debug "Created state file: $STATE_FILE"
    fi
}

# Update state after backup
update_state() {
    local backup_type="$1"
    local backup_file="$2"
    local backup_size="$3"
    local checksum="$4"
    local status="$5"

    if [[ "$DRY_RUN" == true ]]; then
        debug "Would update state file"
        return
    fi

    # Read current state
    local current_state
    current_state=$(cat "$STATE_FILE")

    # Update fields using jq
    local new_entry
    new_entry=$(cat <<EOF
{
  "timestamp": "$(get_iso_date)",
  "type": "$backup_type",
  "file": "$backup_file",
  "size_bytes": $backup_size,
  "checksum": "$checksum",
  "status": "$status",
  "repo_info": "$(get_repo_info "$REPO_PATH")"
}
EOF
)

    local updated_state
    updated_state=$(echo "$current_state" | jq --argjson entry "$new_entry" '
        .last_backup = $entry.timestamp |
        (if $entry.type == "full" then .last_full_backup = $entry.timestamp else . end) |
        (if $entry.type == "incremental" then .last_incremental_backup = $entry.timestamp else . end) |
        .total_backups += 1 |
        .total_size_bytes += $entry.size_bytes |
        .history = ([$entry] + .history[:99])
    ')

    echo "$updated_state" > "$STATE_FILE"
    debug "Updated state file"
}

# Get last backup info
get_last_backup() {
    local backup_type="${1:-any}"

    if [[ ! -f "$STATE_FILE" ]]; then
        echo ""
        return
    fi

    case "$backup_type" in
        full)
            jq -r '.last_full_backup // empty' "$STATE_FILE"
            ;;
        incremental)
            jq -r '.last_incremental_backup // empty' "$STATE_FILE"
            ;;
        *)
            jq -r '.last_backup // empty' "$STATE_FILE"
            ;;
    esac
}

#===============================================================================
# Backup Functions
#===============================================================================

# Determine backup type based on state and configuration
determine_backup_type() {
    if [[ "$BACKUP_TYPE" != "auto" ]]; then
        echo "$BACKUP_TYPE"
        return
    fi

    local last_full
    last_full=$(get_last_backup "full")

    if [[ -z "$last_full" ]]; then
        debug "No previous full backup found, forcing full backup"
        echo "full"
        return
    fi

    # Check if last full backup is older than 7 days
    local last_full_ts
    last_full_ts=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$last_full" "+%s" 2>/dev/null || date -d "$last_full" "+%s" 2>/dev/null || echo "0")
    local now_ts
    now_ts=$(date "+%s")
    local age_days=$(( (now_ts - last_full_ts) / 86400 ))

    if (( age_days >= 7 )); then
        debug "Last full backup is $age_days days old, forcing full backup"
        echo "full"
    else
        debug "Last full backup is $age_days days old, performing incremental"
        echo "incremental"
    fi
}

# Create git bundle (full)
create_full_bundle() {
    local repo="$1"
    local output="$2"

    info "Creating full git bundle..."

    if [[ "$DRY_RUN" == true ]]; then
        debug "Would run: git bundle create $output --all"
        return 0
    fi

    cd "$repo"

    if ! git bundle create "$output" --all 2>&1; then
        error "Failed to create git bundle"
        return 1
    fi

    # Verify bundle
    if [[ "$VERIFY" == true ]]; then
        if ! git bundle verify "$output" &>/dev/null; then
            error "Bundle verification failed"
            return 1
        fi
        debug "Bundle verified successfully"
    fi

    return 0
}

# Create git bundle (incremental)
create_incremental_bundle() {
    local repo="$1"
    local output="$2"
    local since="$3"

    info "Creating incremental git bundle since $since..."

    if [[ "$DRY_RUN" == true ]]; then
        debug "Would run: git bundle create $output --since=$since --all"
        return 0
    fi

    cd "$repo"

    # Get commits since last backup
    local commits
    commits=$(git log --since="$since" --oneline --all 2>/dev/null | wc -l | tr -d ' ')

    if (( commits == 0 )); then
        info "No new commits since last backup"
        return 2  # Special return code for "nothing to do"
    fi

    debug "Found $commits commits since last backup"

    if ! git bundle create "$output" --since="$since" --all 2>&1; then
        error "Failed to create incremental bundle"
        return 1
    fi

    # Verify bundle
    if [[ "$VERIFY" == true ]]; then
        if ! git bundle verify "$output" &>/dev/null; then
            error "Incremental bundle verification failed"
            return 1
        fi
        debug "Incremental bundle verified successfully"
    fi

    return 0
}

# Compress backup file
compress_backup() {
    local input="$1"
    local compression="${2:-$DEFAULT_COMPRESSION}"

    if [[ -z "$compression" ]] || [[ "$compression" == "none" ]]; then
        echo "$input"
        return
    fi

    local output=""
    local cmd=""

    case "$compression" in
        gzip|gz)
            output="${input}.gz"
            cmd="gzip -9 -c"
            ;;
        bzip2|bz2)
            output="${input}.bz2"
            cmd="bzip2 -9 -c"
            ;;
        xz)
            output="${input}.xz"
            cmd="xz -9 -c"
            ;;
        *)
            warn "Unknown compression: $compression, skipping"
            echo "$input"
            return
            ;;
    esac

    info "Compressing with $compression..."

    if [[ "$DRY_RUN" == true ]]; then
        debug "Would run: $cmd $input > $output"
        echo "$output"
        return
    fi

    if ! $cmd "$input" > "$output"; then
        error "Compression failed"
        echo "$input"
        return
    fi

    # Remove uncompressed file
    rm -f "$input"

    local orig_size
    local comp_size
    orig_size=$(stat -f%z "$input" 2>/dev/null || stat --printf="%s" "$input" 2>/dev/null || echo "0")
    comp_size=$(stat -f%z "$output" 2>/dev/null || stat --printf="%s" "$output" 2>/dev/null || echo "0")

    if (( orig_size > 0 )); then
        local ratio=$(( (orig_size - comp_size) * 100 / orig_size ))
        debug "Compression ratio: ${ratio}% reduction"
    fi

    echo "$output"
}

# Sync to destination using rsync
sync_to_destination() {
    local source="$1"
    local dest="$2"

    info "Syncing to destination: $dest"

    local rsync_opts="-avz --progress"

    if [[ "$DRY_RUN" == true ]]; then
        rsync_opts="$rsync_opts --dry-run"
    fi

    # Ensure destination directory exists (for local paths)
    if [[ ! "$dest" =~ : ]]; then
        ensure_dir "$dest"
    fi

    if ! rsync $rsync_opts "$source" "$dest/"; then
        error "Failed to sync to $dest"
        return 1
    fi

    return 0
}

# Clean up old backups based on retention policy
cleanup_old_backups() {
    local backup_dir="$1"
    local retention_days="${2:-$DEFAULT_RETENTION_DAYS}"
    local retention_full="${3:-$DEFAULT_RETENTION_FULL}"
    local retention_incr="${4:-$DEFAULT_RETENTION_INCREMENTAL}"

    info "Cleaning up old backups (retention: ${retention_days} days, ${retention_full} full, ${retention_incr} incremental)"

    if [[ "$DRY_RUN" == true ]]; then
        debug "Would clean up backups older than $retention_days days"
        return
    fi

    # Remove backups older than retention_days
    find "$backup_dir" -name "kaaos-backup-*.bundle*" -mtime +"$retention_days" -delete 2>/dev/null || true

    # Keep only last N full backups
    local full_backups
    full_backups=$(find "$backup_dir" -name "kaaos-backup-full-*.bundle*" -type f 2>/dev/null | sort -r)
    local count=0
    while IFS= read -r backup; do
        ((count++))
        if (( count > retention_full )); then
            debug "Removing old full backup: $backup"
            rm -f "$backup"
        fi
    done <<< "$full_backups"

    # Keep only last N incremental backups
    local incr_backups
    incr_backups=$(find "$backup_dir" -name "kaaos-backup-incr-*.bundle*" -type f 2>/dev/null | sort -r)
    count=0
    while IFS= read -r backup; do
        ((count++))
        if (( count > retention_incr )); then
            debug "Removing old incremental backup: $backup"
            rm -f "$backup"
        fi
    done <<< "$incr_backups"

    debug "Cleanup complete"
}

#===============================================================================
# Notification Functions
#===============================================================================

# Send notification email
send_notification() {
    local status="$1"
    local message="$2"

    if [[ "$NOTIFY" != true ]] || [[ -z "$NOTIFY_EMAIL" ]]; then
        return
    fi

    local subject="[KAAOS Backup] $status"
    local body="KAAOS Backup Report
==================

Status: $status
Repository: $REPO_PATH
Timestamp: $(get_iso_date)

$message

--
KAAOS Backup System v$SCRIPT_VERSION"

    if [[ "$DRY_RUN" == true ]]; then
        debug "Would send email to $NOTIFY_EMAIL: $subject"
        return
    fi

    if command_exists mail; then
        echo "$body" | mail -s "$subject" "$NOTIFY_EMAIL"
        debug "Sent notification email to $NOTIFY_EMAIL"
    elif command_exists sendmail; then
        {
            echo "To: $NOTIFY_EMAIL"
            echo "Subject: $subject"
            echo ""
            echo "$body"
        } | sendmail "$NOTIFY_EMAIL"
        debug "Sent notification via sendmail to $NOTIFY_EMAIL"
    else
        warn "No mail command available, cannot send notification"
    fi
}

#===============================================================================
# Main Backup Function
#===============================================================================

perform_backup() {
    TIMESTAMP=$(get_timestamp)

    # Determine backup type
    local actual_type
    actual_type=$(determine_backup_type)

    # Set backup name based on type
    if [[ "$actual_type" == "full" ]]; then
        BACKUP_NAME="kaaos-backup-full-${TIMESTAMP}"
    else
        BACKUP_NAME="kaaos-backup-incr-${TIMESTAMP}"
    fi

    BUNDLE_FILE="${BACKUP_DIR}/${BACKUP_NAME}.bundle"

    info "Starting $actual_type backup of $REPO_PATH"
    info "Backup destination: $BACKUP_DIR"

    # Ensure backup directory exists
    ensure_dir "$BACKUP_DIR"

    # Create bundle based on type
    local bundle_result=0
    if [[ "$actual_type" == "full" ]]; then
        create_full_bundle "$REPO_PATH" "$BUNDLE_FILE" || bundle_result=$?
    else
        local last_backup
        last_backup=$(get_last_backup "any")
        if [[ -z "$last_backup" ]]; then
            info "No previous backup found, switching to full backup"
            actual_type="full"
            BACKUP_NAME="kaaos-backup-full-${TIMESTAMP}"
            BUNDLE_FILE="${BACKUP_DIR}/${BACKUP_NAME}.bundle"
            create_full_bundle "$REPO_PATH" "$BUNDLE_FILE" || bundle_result=$?
        else
            create_incremental_bundle "$REPO_PATH" "$BUNDLE_FILE" "$last_backup" || bundle_result=$?
        fi
    fi

    # Handle bundle creation result
    if (( bundle_result == 2 )); then
        info "No changes to backup"
        send_notification "SKIPPED" "No new commits since last backup"
        return 0
    elif (( bundle_result != 0 )); then
        die "Bundle creation failed"
    fi

    # Compress if requested
    if [[ -n "$COMPRESSION" ]] && [[ "$COMPRESSION" != "none" ]]; then
        ARCHIVE_FILE=$(compress_backup "$BUNDLE_FILE" "$COMPRESSION")
    else
        ARCHIVE_FILE="$BUNDLE_FILE"
    fi

    # Get file size and checksum
    local backup_size=0
    local checksum=""
    if [[ "$DRY_RUN" != true ]] && [[ -f "$ARCHIVE_FILE" ]]; then
        backup_size=$(stat -f%z "$ARCHIVE_FILE" 2>/dev/null || stat --printf="%s" "$ARCHIVE_FILE" 2>/dev/null || echo "0")
        checksum=$(calculate_checksum "$ARCHIVE_FILE")
    fi

    info "Backup created: $ARCHIVE_FILE ($(human_size "$backup_size"))"

    # Sync to additional destinations
    local sync_failed=false
    for dest in "${DESTINATIONS[@]}"; do
        if ! sync_to_destination "$ARCHIVE_FILE" "$dest"; then
            sync_failed=true
        fi
    done

    # Update state
    local status="SUCCESS"
    if [[ "$sync_failed" == true ]]; then
        status="PARTIAL"
    fi

    update_state "$actual_type" "$ARCHIVE_FILE" "$backup_size" "$checksum" "$status"

    # Cleanup old backups
    cleanup_old_backups "$BACKUP_DIR" "${RETENTION_DAYS:-$DEFAULT_RETENTION_DAYS}" \
        "${RETENTION_FULL:-$DEFAULT_RETENTION_FULL}" "${RETENTION_INCREMENTAL:-$DEFAULT_RETENTION_INCREMENTAL}"

    # Send notification
    local message="Backup Type: $actual_type
File: $ARCHIVE_FILE
Size: $(human_size "$backup_size")
Checksum: $checksum"

    if [[ "$sync_failed" == true ]]; then
        message="$message

WARNING: Some sync destinations failed"
    fi

    send_notification "$status" "$message"

    info "Backup completed successfully"
    return 0
}

#===============================================================================
# CLI Interface
#===============================================================================

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS] <repository-path>

KAAOS Knowledge Repository Backup Tool v$SCRIPT_VERSION

OPTIONS:
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    -n, --dry-run           Show what would be done without making changes

    Backup Type:
    -f, --full              Force full backup
    -i, --incremental       Force incremental backup (default: auto-detect)

    Output:
    -d, --dest=PATH         Backup destination directory
                            (default: $DEFAULT_BACKUP_DIR)
    --dest-remote=HOST:PATH Add remote rsync destination (can be repeated)
    -c, --compress=TYPE     Compression type: gzip, bzip2, xz, none
                            (default: $DEFAULT_COMPRESSION)

    Retention:
    --retention-days=N      Days to keep backups (default: $DEFAULT_RETENTION_DAYS)
    --retention-full=N      Number of full backups to keep (default: $DEFAULT_RETENTION_FULL)
    --retention-incr=N      Number of incremental backups to keep
                            (default: $DEFAULT_RETENTION_INCREMENTAL)

    Verification:
    --no-verify             Skip bundle verification

    Notifications:
    --notify                Enable email notifications
    --email=ADDRESS         Email address for notifications

    State:
    --state-file=PATH       State file location
                            (default: $DEFAULT_STATE_FILE)
    --log-file=PATH         Log file location
                            (default: $DEFAULT_LOG_DIR/backup.log)

EXAMPLES:
    # Basic backup with defaults
    $SCRIPT_NAME ~/kaaos-knowledge

    # Dry run to see what would happen
    $SCRIPT_NAME --dry-run ~/kaaos-knowledge

    # Full backup with xz compression
    $SCRIPT_NAME --full --compress=xz ~/kaaos-knowledge

    # Backup to custom location with rsync to remote
    $SCRIPT_NAME -d /backup/kaaos --dest-remote=backup.example.com:/backup ~/kaaos-knowledge

    # Backup with email notification
    $SCRIPT_NAME --notify --email=admin@example.com ~/kaaos-knowledge

CRON EXAMPLE:
    # Daily incremental at 2am, weekly full on Sunday
    0 2 * * 1-6 $SCRIPT_NAME --incremental ~/kaaos-knowledge >> ~/.kaaos/logs/backup.log 2>&1
    0 2 * * 0   $SCRIPT_NAME --full ~/kaaos-knowledge >> ~/.kaaos/logs/backup.log 2>&1

EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -f|--full)
                BACKUP_TYPE="full"
                shift
                ;;
            -i|--incremental)
                BACKUP_TYPE="incremental"
                shift
                ;;
            -d|--dest)
                BACKUP_DIR="$2"
                shift 2
                ;;
            --dest=*)
                BACKUP_DIR="${1#*=}"
                shift
                ;;
            --dest-remote)
                DESTINATIONS+=("$2")
                shift 2
                ;;
            --dest-remote=*)
                DESTINATIONS+=("${1#*=}")
                shift
                ;;
            -c|--compress)
                COMPRESSION="$2"
                shift 2
                ;;
            --compress=*)
                COMPRESSION="${1#*=}"
                shift
                ;;
            --retention-days)
                RETENTION_DAYS="$2"
                shift 2
                ;;
            --retention-days=*)
                RETENTION_DAYS="${1#*=}"
                shift
                ;;
            --retention-full)
                RETENTION_FULL="$2"
                shift 2
                ;;
            --retention-full=*)
                RETENTION_FULL="${1#*=}"
                shift
                ;;
            --retention-incr)
                RETENTION_INCREMENTAL="$2"
                shift 2
                ;;
            --retention-incr=*)
                RETENTION_INCREMENTAL="${1#*=}"
                shift
                ;;
            --no-verify)
                VERIFY=false
                shift
                ;;
            --notify)
                NOTIFY=true
                shift
                ;;
            --email)
                NOTIFY_EMAIL="$2"
                NOTIFY=true
                shift 2
                ;;
            --email=*)
                NOTIFY_EMAIL="${1#*=}"
                NOTIFY=true
                shift
                ;;
            --state-file)
                STATE_FILE="$2"
                shift 2
                ;;
            --state-file=*)
                STATE_FILE="${1#*=}"
                shift
                ;;
            --log-file)
                LOG_FILE="$2"
                shift 2
                ;;
            --log-file=*)
                LOG_FILE="${1#*=}"
                shift
                ;;
            -*)
                error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                if [[ -z "$REPO_PATH" ]]; then
                    REPO_PATH="$1"
                else
                    error "Unexpected argument: $1"
                    usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
}

validate_args() {
    # Check repository path
    if [[ -z "$REPO_PATH" ]]; then
        error "Repository path is required"
        usage
        exit 1
    fi

    # Expand home directory
    REPO_PATH="${REPO_PATH/#\~/$HOME}"

    # Validate repository exists
    if [[ ! -d "$REPO_PATH" ]]; then
        die "Repository not found: $REPO_PATH"
    fi

    # Validate it's a git repository
    if [[ ! -d "$REPO_PATH/.git" ]]; then
        die "Not a git repository: $REPO_PATH"
    fi

    # Set defaults
    BACKUP_DIR="${BACKUP_DIR:-$DEFAULT_BACKUP_DIR}"
    BACKUP_DIR="${BACKUP_DIR/#\~/$HOME}"

    COMPRESSION="${COMPRESSION:-$DEFAULT_COMPRESSION}"

    STATE_FILE="${STATE_FILE:-$DEFAULT_STATE_FILE}"
    STATE_FILE="${STATE_FILE/#\~/$HOME}"

    if [[ -z "$LOG_FILE" ]]; then
        LOG_FILE="$DEFAULT_LOG_DIR/backup.log"
    fi
    LOG_FILE="${LOG_FILE/#\~/$HOME}"

    # Ensure log directory exists
    ensure_dir "$(dirname "$LOG_FILE")"

    # Validate compression type
    case "$COMPRESSION" in
        gzip|gz|bzip2|bz2|xz|none|"") ;;
        *)
            die "Invalid compression type: $COMPRESSION"
            ;;
    esac

    # Check for required tools
    if ! command_exists git; then
        die "git is required but not installed"
    fi

    if ! command_exists jq; then
        die "jq is required but not installed"
    fi

    if [[ ${#DESTINATIONS[@]} -gt 0 ]] && ! command_exists rsync; then
        die "rsync is required for remote destinations but not installed"
    fi
}

#===============================================================================
# Main Entry Point
#===============================================================================

main() {
    parse_args "$@"
    validate_args

    # Initialize state tracking
    init_state

    # Log startup
    info "KAAOS Backup v$SCRIPT_VERSION"
    debug "Repository: $REPO_PATH"
    debug "Backup dir: $BACKUP_DIR"
    debug "Backup type: $BACKUP_TYPE"
    debug "Compression: $COMPRESSION"
    debug "Dry run: $DRY_RUN"

    # Perform backup
    perform_backup

    return $?
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
