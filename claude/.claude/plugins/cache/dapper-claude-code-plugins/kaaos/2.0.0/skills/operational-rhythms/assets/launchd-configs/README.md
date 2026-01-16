# KAAOS launchd Configurations

macOS launchd configuration files for automating KAAOS operational rhythms.

## Overview

These plist files configure launchd to automatically run KAAOS review operations at scheduled intervals:

| File | Rhythm | Schedule | Cost Estimate |
|------|--------|----------|---------------|
| `com.kaaos.daily.plist` | Daily digest | Daily at 7:00 AM | ~$0.30 |
| `com.kaaos.weekly.plist` | Weekly synthesis | Monday at 6:00 AM | ~$4-5 |
| `com.kaaos.monthly.plist` | Monthly review | 1st of month at 5:00 AM | ~$10-15 |
| `com.kaaos.quarterly.plist` | Quarterly review | 1st of Jan/Apr/Jul/Oct at 3:00 AM | ~$40-50 |

## Installation

### Quick Install (All Rhythms)

```bash
# Copy all plist files to LaunchAgents
cp /path/to/launchd-configs/*.plist ~/Library/LaunchAgents/

# Load all KAAOS schedules
launchctl load ~/Library/LaunchAgents/com.kaaos.daily.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.weekly.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.monthly.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.quarterly.plist
```

### Selective Install

```bash
# Install only daily digest
cp /path/to/launchd-configs/com.kaaos.daily.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.kaaos.daily.plist

# Install only weekly synthesis
cp /path/to/launchd-configs/com.kaaos.weekly.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.kaaos.weekly.plist
```

### Verify Installation

```bash
# List all loaded KAAOS jobs
launchctl list | grep kaaos

# Check specific job status
launchctl list com.kaaos.daily
```

## Configuration

### Customizing Schedule

Before installing, edit the plist files to adjust timing:

```xml
<!-- Daily at 7:00 AM -->
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>7</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

### Customizing Paths

Update paths to match your KAAOS installation:

```xml
<key>ProgramArguments</key>
<array>
    <string>/usr/local/bin/kaaos</string>  <!-- KAAOS CLI path -->
    <string>review</string>
    <string>daily</string>
</array>

<key>StandardOutPath</key>
<string>/Users/YOUR_USERNAME/.kaaos-knowledge/.kaaos/logs/daily.log</string>
```

### Environment Variables

Add environment variables if needed:

```xml
<key>EnvironmentVariables</key>
<dict>
    <key>KAAOS_HOME</key>
    <string>/Users/YOUR_USERNAME/.kaaos-knowledge</string>
    <key>ANTHROPIC_API_KEY</key>
    <string>sk-ant-...</string>
</dict>
```

## Management

### Manual Trigger

```bash
# Test daily digest immediately
launchctl start com.kaaos.daily

# Test weekly synthesis
launchctl start com.kaaos.weekly

# Test monthly review
launchctl start com.kaaos.monthly

# Test quarterly review
launchctl start com.kaaos.quarterly
```

### Stop/Disable

```bash
# Unload (disable) a schedule
launchctl unload ~/Library/LaunchAgents/com.kaaos.daily.plist

# Remove completely
launchctl unload ~/Library/LaunchAgents/com.kaaos.daily.plist
rm ~/Library/LaunchAgents/com.kaaos.daily.plist
```

### Reload After Changes

```bash
# Reload after editing plist
launchctl unload ~/Library/LaunchAgents/com.kaaos.daily.plist
launchctl load ~/Library/LaunchAgents/com.kaaos.daily.plist
```

## Logs

### Log Locations

All logs are written to `~/.kaaos-knowledge/.kaaos/logs/`:

```
~/.kaaos-knowledge/.kaaos/logs/
├── daily.log         # Daily digest output
├── daily.error.log   # Daily digest errors
├── weekly.log        # Weekly synthesis output
├── weekly.error.log  # Weekly synthesis errors
├── monthly.log       # Monthly review output
├── monthly.error.log # Monthly review errors
├── quarterly.log     # Quarterly review output
└── quarterly.error.log
```

### View Logs

```bash
# View recent daily log
tail -50 ~/.kaaos-knowledge/.kaaos/logs/daily.log

# Watch daily log in real-time
tail -f ~/.kaaos-knowledge/.kaaos/logs/daily.log

# View errors
cat ~/.kaaos-knowledge/.kaaos/logs/daily.error.log
```

### Log Rotation

Logs are not automatically rotated. Consider adding log rotation:

```bash
# Add to crontab for weekly log rotation
0 0 * * 0 find ~/.kaaos-knowledge/.kaaos/logs -name "*.log" -mtime +30 -delete
```

## Troubleshooting

### Job Not Running

1. **Check if loaded**:
   ```bash
   launchctl list | grep kaaos.daily
   ```

2. **Check for errors**:
   ```bash
   cat ~/.kaaos-knowledge/.kaaos/logs/daily.error.log
   ```

3. **Verify plist syntax**:
   ```bash
   plutil -lint ~/Library/LaunchAgents/com.kaaos.daily.plist
   ```

4. **Check permissions**:
   ```bash
   ls -la ~/Library/LaunchAgents/com.kaaos.daily.plist
   # Should be: -rw-r--r--
   ```

### Job Runs But Fails

1. **Check KAAOS CLI is accessible**:
   ```bash
   which kaaos
   /usr/local/bin/kaaos --version
   ```

2. **Check API key is set**:
   ```bash
   echo $ANTHROPIC_API_KEY
   ```

3. **Test manual execution**:
   ```bash
   /usr/local/bin/kaaos review daily --debug
   ```

### Wrong Time Zone

launchd uses local time by default. To verify:

```bash
# Check system time zone
date +%Z

# If needed, set TZ in plist
<key>EnvironmentVariables</key>
<dict>
    <key>TZ</key>
    <string>America/Los_Angeles</string>
</dict>
```

### Computer Asleep at Scheduled Time

Jobs scheduled while computer is asleep will run when it wakes. To change behavior, remove the `StartCalendarInterval` and use `StartInterval` for relative timing:

```xml
<!-- Run every 24 hours instead of at specific time -->
<key>StartInterval</key>
<integer>86400</integer>
```

## Cost Management

### Estimated Monthly Costs

| Rhythm | Frequency | Per Run | Monthly |
|--------|-----------|---------|---------|
| Daily | 30x/month | $0.30 | $9.00 |
| Weekly | 4x/month | $5.00 | $20.00 |
| Monthly | 1x/month | $12.00 | $12.00 |
| Quarterly | 0.33x/month | $45.00 | $15.00 (amortized) |
| **Total** | | | **~$56/month** |

### Budget Controls

Configure budget limits in KAAOS config:

```yaml
# ~/.kaaos-knowledge/.kaaos/config.yaml
cost_controls:
  monthly_limit_usd: 100
  alert_threshold_percent: 80
  hard_stop_on_limit: false
```

### Disable Expensive Rhythms

To reduce costs, disable quarterly or monthly:

```bash
launchctl unload ~/Library/LaunchAgents/com.kaaos.quarterly.plist
launchctl unload ~/Library/LaunchAgents/com.kaaos.monthly.plist
```

## Security Considerations

### API Key Storage

Never store API keys directly in plist files. Instead:

1. **Use environment variable** (set in shell profile):
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-..."
   ```

2. **Use macOS Keychain**:
   ```bash
   security add-generic-password -a "$USER" -s "anthropic-api-key" -w "sk-ant-..."
   ```

3. **Reference from config file**:
   ```yaml
   # ~/.kaaos-knowledge/.kaaos/config.yaml
   api_key_source: keychain
   keychain_service: anthropic-api-key
   ```

### File Permissions

Ensure proper permissions:

```bash
chmod 644 ~/Library/LaunchAgents/com.kaaos.*.plist
chmod 700 ~/.kaaos-knowledge/.kaaos
chmod 600 ~/.kaaos-knowledge/.kaaos/config.yaml
```

## Related Resources

- **SKILL.md**: Operational rhythms overview
- **references/daily-rhythm-patterns.md**: Daily digest patterns
- **references/weekly-rhythm-patterns.md**: Weekly synthesis patterns
- **references/monthly-rhythm-patterns.md**: Monthly review patterns
- **references/quarterly-rhythm-patterns.md**: Quarterly review patterns
- **Apple launchd Documentation**: `man launchd.plist`
