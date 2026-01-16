# Knowledge Migration Scripts

Scripts for migrating knowledge from various tools into KAAOS-compatible context libraries.

## Overview

These scripts help migrate existing knowledge bases from popular tools into the KAAOS structure while preserving links, metadata, and content quality.

## Available Scripts

| Script | Source Tool | Output | Status |
|--------|-------------|--------|--------|
| `migrate-notion.py` | Notion | Markdown with frontmatter | Production |
| `migrate-obsidian.py` | Obsidian | Standardized markdown | Production |
| `migrate-roam.py` | Roam Research | Markdown with backlinks | Production |

## Prerequisites

### Python Environment

```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install pyyaml python-dateutil beautifulsoup4 markdownify
```

### Required Packages

```txt
pyyaml>=6.0
python-dateutil>=2.8
beautifulsoup4>=4.11
markdownify>=0.11
unidecode>=1.3
```

## Quick Start

### Notion Migration

```bash
# 1. Export from Notion
# Settings > Workspace > Export all workspace content
# Choose "Markdown & CSV" format
# Extract the downloaded ZIP

# 2. Run migration
python migrate-notion.py \
  --input ~/Downloads/notion-export \
  --output ~/kaaos-knowledge/organizations/company-x/context-library \
  --org "company-x"

# 3. Review and finalize
# - Check generated notes for quality
# - Add missing cross-references
# - Run maintenance to validate
```

### Obsidian Migration

```bash
# 1. Run migration
python migrate-obsidian.py \
  --input ~/Documents/ObsidianVault \
  --output ~/kaaos-knowledge/organizations/personal/context-library \
  --org "personal"

# 2. Standardize (if needed)
# Obsidian uses standard markdown, mainly need frontmatter standardization
```

### Roam Migration

```bash
# 1. Export from Roam
# All Pages > Export All > Markdown

# 2. Run migration
python migrate-roam.py \
  --input ~/Downloads/roam-export \
  --output ~/kaaos-knowledge/organizations/research/context-library \
  --org "research"
```

## Migration Process

### Phase 1: Export

1. Export from source tool (see tool-specific instructions below)
2. Verify export completeness
3. Place export in accessible location

### Phase 2: Transform

1. Run appropriate migration script
2. Script performs:
   - File structure creation
   - Content transformation
   - Frontmatter generation
   - Link conversion
   - Asset copying

### Phase 3: Validate

```bash
# Run validation after migration
python validate-migration.py \
  --path ~/kaaos-knowledge/organizations/[org]/context-library

# Check for:
# - Broken links
# - Missing frontmatter
# - Orphan notes
# - Duplicate IDs
```

### Phase 4: Integrate

1. Review generated index
2. Create initial map notes
3. Connect to existing knowledge
4. Run maintenance agent

## Common Options

All scripts support these common options:

```
--input PATH          Source directory (required)
--output PATH         Destination directory (required)
--org NAME           Organization name for IDs
--dry-run            Preview without writing
--verbose            Detailed output
--preserve-dates     Keep original creation dates
--skip-empty         Skip notes with no content
--min-words N        Skip notes shorter than N words
--tag-prefix STR     Prefix for migrated tags
```

## Post-Migration Tasks

### 1. Generate Index

```bash
# Auto-generate 00-INDEX.md
/kaaos:maintenance generate-index --path ~/kaaos-knowledge/organizations/[org]
```

### 2. Create Map Notes

```bash
# Suggest map notes based on clusters
/kaaos:maintenance suggest-maps --path ~/kaaos-knowledge/organizations/[org]
```

### 3. Validate Links

```bash
# Check all internal links
/kaaos:maintenance validate-links --path ~/kaaos-knowledge/organizations/[org]
```

### 4. Initialize Git

```bash
cd ~/kaaos-knowledge
git add organizations/[org]
git commit -m "Migrate knowledge from [source tool]"
```

## Troubleshooting

### Common Issues

**Broken Links After Migration**
- Cause: Different link syntax between tools
- Fix: Run link fixer script or manually update

**Missing Dates**
- Cause: Source tool didn't export creation dates
- Fix: Use file modification dates or set to migration date

**Duplicate Note IDs**
- Cause: Same title exists multiple times
- Fix: Script auto-appends numeric suffix

**Encoding Issues**
- Cause: Non-UTF8 characters in source
- Fix: Scripts auto-convert to UTF-8

### Getting Help

```bash
# Show script help
python migrate-notion.py --help

# Verbose output for debugging
python migrate-notion.py --verbose --dry-run ...
```

## Contributing

To add support for additional tools:

1. Create `migrate-[tool].py` following existing patterns
2. Implement required functions (see template below)
3. Add tests in `tests/`
4. Update this README

### Script Template

```python
#!/usr/bin/env python3
"""
Migrate knowledge from [Tool Name] to KAAOS.

Usage:
    python migrate-[tool].py --input PATH --output PATH --org NAME
"""

import argparse
from pathlib import Path
from migration_utils import (
    MigrationBase,
    generate_note_id,
    create_frontmatter,
    convert_links
)

class ToolMigration(MigrationBase):
    """Migration handler for [Tool Name]."""

    def extract_content(self, source_path: Path) -> dict:
        """Extract content from source format."""
        # Implementation here
        pass

    def transform_content(self, content: dict) -> str:
        """Transform to KAAOS markdown format."""
        # Implementation here
        pass

    def convert_links(self, content: str) -> str:
        """Convert tool-specific links to [[wiki-links]]."""
        # Implementation here
        pass

if __name__ == '__main__':
    # Argument parsing and execution
    pass
```

## Related Resources

- [[SKILL.md|Knowledge Management Skill]] - Parent skill
- [[references/context-library-patterns|Context Library Patterns]] - Target structure
- [[assets/atomic-note-template|Atomic Note Template]] - Output format
