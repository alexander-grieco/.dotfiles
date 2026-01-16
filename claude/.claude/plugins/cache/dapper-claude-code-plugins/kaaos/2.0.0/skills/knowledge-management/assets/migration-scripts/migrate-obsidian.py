#!/usr/bin/env python3
"""
Migrate knowledge from Obsidian vault to KAAOS context library.

Obsidian already uses markdown with wiki-links, so this migration focuses on:
- Standardizing frontmatter to KAAOS format
- Organizing files into KAAOS structure
- Generating proper IDs
- Validating and fixing links

Usage:
    python migrate-obsidian.py --input ~/Documents/ObsidianVault \
                               --output ~/kaaos-knowledge/organizations/personal \
                               --org personal

Prerequisites:
    - Install: pip install pyyaml python-dateutil
"""

import argparse
import os
import re
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple
from dataclasses import dataclass, field

try:
    import yaml
    from dateutil import parser as date_parser
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Install with: pip install pyyaml python-dateutil")
    exit(1)


@dataclass
class ObsidianNote:
    """Represents an Obsidian note for migration."""
    source_path: Path
    title: str
    content: str
    frontmatter: Dict = field(default_factory=dict)
    created: Optional[datetime] = None
    updated: Optional[datetime] = None
    tags: List[str] = field(default_factory=list)
    links: List[str] = field(default_factory=list)
    backlinks: List[str] = field(default_factory=list)
    kaaos_id: Optional[str] = None


@dataclass
class MigrationStats:
    """Track migration statistics."""
    total_files: int = 0
    migrated: int = 0
    skipped: int = 0
    errors: int = 0
    frontmatter_standardized: int = 0
    links_fixed: int = 0
    assets_copied: int = 0


class ObsidianMigrator:
    """
    Handles migration from Obsidian vault to KAAOS format.

    Features:
    - Preserves existing wiki-links
    - Standardizes frontmatter
    - Organizes into KAAOS structure
    - Handles Obsidian-specific syntax
    - Copies attachments
    """

    # Obsidian-specific patterns
    WIKILINK_PATTERN = re.compile(r'\[\[([^\]|]+)(?:\|([^\]]+))?\]\]')
    FRONTMATTER_PATTERN = re.compile(r'^---\n(.*?)\n---', re.DOTALL)
    TAG_IN_CONTENT = re.compile(r'(?:^|\s)#([a-zA-Z][a-zA-Z0-9_-]*)')
    EMBED_PATTERN = re.compile(r'!\[\[([^\]]+)\]\]')

    # Note type detection
    TYPE_INDICATORS = {
        'map': ['MOC', 'Map of Content', '## Contents', '## Index'],
        'playbook': ['## Steps', '## Process', '## Procedure', '## How to'],
        'decision': ['## Decision', '## Options', '## Rationale'],
        'daily': ['Daily Note', '## Journal'],
    }

    def __init__(
        self,
        input_path: Path,
        output_path: Path,
        org_name: str,
        verbose: bool = False,
        dry_run: bool = False,
        preserve_dates: bool = True,
        min_words: int = 30,
        skip_daily_notes: bool = True,
        tag_prefix: str = 'obsidian-migrated'
    ):
        self.input_path = Path(input_path)
        self.output_path = Path(output_path)
        self.org_name = org_name
        self.verbose = verbose
        self.dry_run = dry_run
        self.preserve_dates = preserve_dates
        self.min_words = min_words
        self.skip_daily_notes = skip_daily_notes
        self.tag_prefix = tag_prefix

        self.stats = MigrationStats()
        self.notes: List[ObsidianNote] = []
        self.title_to_id: Dict[str, str] = {}
        self.attachment_dirs: Set[str] = {'attachments', 'assets', 'images', 'files'}

    def migrate(self) -> MigrationStats:
        """Execute the full migration process."""
        self.log("Starting Obsidian migration...")
        self.log(f"  Input: {self.input_path}")
        self.log(f"  Output: {self.output_path}")

        # Phase 1: Scan vault
        self.log("\nPhase 1: Scanning Obsidian vault...")
        self._scan_vault()

        # Phase 2: Build ID mappings
        self.log("\nPhase 2: Building ID mappings...")
        self._build_id_map()

        # Phase 3: Create structure
        self.log("\nPhase 3: Creating output structure...")
        if not self.dry_run:
            self._create_structure()

        # Phase 4: Transform notes
        self.log("\nPhase 4: Transforming notes...")
        self._transform_all_notes()

        # Phase 5: Copy attachments
        self.log("\nPhase 5: Copying attachments...")
        self._copy_attachments()

        # Phase 6: Generate index
        self.log("\nPhase 6: Generating index...")
        if not self.dry_run:
            self._generate_index()

        # Report
        self._print_summary()

        return self.stats

    def _scan_vault(self):
        """Scan Obsidian vault for markdown files."""
        for md_file in self.input_path.rglob('*.md'):
            # Skip files in attachment directories
            if any(att_dir in str(md_file) for att_dir in self.attachment_dirs):
                continue

            self.stats.total_files += 1

            try:
                note = self._parse_obsidian_file(md_file)

                # Skip daily notes if configured
                if self.skip_daily_notes and self._is_daily_note(note):
                    self.stats.skipped += 1
                    self.log(f"  Skipped (daily note): {md_file.name}", verbose=True)
                    continue

                # Skip short notes
                if len(note.content.split()) < self.min_words:
                    self.stats.skipped += 1
                    self.log(f"  Skipped (too short): {md_file.name}", verbose=True)
                    continue

                self.notes.append(note)

            except Exception as e:
                self.stats.errors += 1
                self.log(f"  Error parsing {md_file}: {e}")

        self.log(f"  Found {len(self.notes)} notes to migrate")

    def _parse_obsidian_file(self, file_path: Path) -> ObsidianNote:
        """Parse an Obsidian markdown file."""
        content = file_path.read_text(encoding='utf-8')
        frontmatter = {}

        # Extract existing frontmatter
        fm_match = self.FRONTMATTER_PATTERN.match(content)
        if fm_match:
            try:
                frontmatter = yaml.safe_load(fm_match.group(1)) or {}
                content = content[fm_match.end():].strip()
            except yaml.YAMLError:
                pass

        # Title from frontmatter or filename
        title = frontmatter.get('title', file_path.stem)

        # Extract dates
        created = None
        updated = None

        if 'created' in frontmatter:
            try:
                created = date_parser.parse(str(frontmatter['created']))
            except:
                pass
        if 'date' in frontmatter:
            try:
                created = date_parser.parse(str(frontmatter['date']))
            except:
                pass

        if self.preserve_dates and not created:
            stat = file_path.stat()
            created = datetime.fromtimestamp(stat.st_ctime)
            updated = datetime.fromtimestamp(stat.st_mtime)

        # Extract tags from frontmatter and content
        tags = []
        if 'tags' in frontmatter:
            fm_tags = frontmatter['tags']
            if isinstance(fm_tags, list):
                tags.extend(fm_tags)
            elif isinstance(fm_tags, str):
                tags.extend([t.strip() for t in fm_tags.split(',')])

        # Extract inline tags
        inline_tags = self.TAG_IN_CONTENT.findall(content)
        tags.extend(inline_tags)

        # Clean up tags
        tags = [t.lower().replace(' ', '-') for t in tags if t]
        tags = list(set(tags))

        # Extract links
        links = [m.group(1) for m in self.WIKILINK_PATTERN.finditer(content)]

        return ObsidianNote(
            source_path=file_path,
            title=title,
            content=content,
            frontmatter=frontmatter,
            created=created,
            updated=updated,
            tags=tags,
            links=links
        )

    def _is_daily_note(self, note: ObsidianNote) -> bool:
        """Check if note is a daily note."""
        # Check filename for date patterns
        date_patterns = [
            r'^\d{4}-\d{2}-\d{2}$',  # 2026-01-15
            r'^\d{4}\.\d{2}\.\d{2}$',  # 2026.01.15
            r'^\d{2}-\d{2}-\d{4}$',  # 01-15-2026
        ]

        for pattern in date_patterns:
            if re.match(pattern, note.title):
                return True

        # Check for daily note indicators
        for indicator in self.TYPE_INDICATORS.get('daily', []):
            if indicator.lower() in note.content.lower()[:500]:
                return True

        return False

    def _build_id_map(self):
        """Build mapping from titles to KAAOS IDs."""
        date_counter: Dict[str, int] = {}

        for note in self.notes:
            date_str = note.created.strftime('%Y-%m') if note.created else datetime.now().strftime('%Y-%m')

            if date_str not in date_counter:
                date_counter[date_str] = 0
            date_counter[date_str] += 1

            # Determine prefix based on note type
            note_type = self._determine_note_type(note)
            prefix_map = {
                'atomic': 'ATOM',
                'maps': 'MAP',
                'playbooks': 'PLAY',
                'decisions': 'DEC',
                'references': 'REF',
                'synthesis': 'SYNTH'
            }
            prefix = prefix_map.get(note_type, 'ATOM')

            if note_type == 'maps':
                kaaos_id = f"MAP-{self._slugify(note.title)}"
            else:
                kaaos_id = f"{prefix}-{date_str}-{date_counter[date_str]:03d}"

            note.kaaos_id = kaaos_id
            self.title_to_id[note.title.lower()] = kaaos_id
            self.title_to_id[note.source_path.stem.lower()] = kaaos_id

        self.log(f"  Created {len(self.title_to_id)} ID mappings")

    def _determine_note_type(self, note: ObsidianNote) -> str:
        """Determine KAAOS note type from Obsidian note."""
        content_lower = note.content.lower()

        # Check for MOC/Map indicators
        for indicator in self.TYPE_INDICATORS.get('map', []):
            if indicator.lower() in content_lower:
                return 'maps'

        # Check for playbook indicators
        for indicator in self.TYPE_INDICATORS.get('playbook', []):
            if indicator.lower() in content_lower:
                return 'playbooks'

        # Check for decision indicators
        for indicator in self.TYPE_INDICATORS.get('decision', []):
            if indicator.lower() in content_lower:
                return 'decisions'

        # Check tags
        if any(t in note.tags for t in ['moc', 'map', 'index']):
            return 'maps'
        if any(t in note.tags for t in ['playbook', 'process', 'how-to']):
            return 'playbooks'
        if any(t in note.tags for t in ['decision', 'adr']):
            return 'decisions'
        if any(t in note.tags for t in ['reference', 'resource']):
            return 'references'

        return 'atomic'

    def _create_structure(self):
        """Create KAAOS directory structure."""
        context_lib = self.output_path / 'context-library'

        directories = [
            context_lib / 'atomic',
            context_lib / 'maps',
            context_lib / 'playbooks',
            context_lib / 'decisions',
            context_lib / 'references',
            context_lib / 'synthesis',
            context_lib / 'assets',
        ]

        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)

    def _transform_all_notes(self):
        """Transform all notes to KAAOS format."""
        for note in self.notes:
            try:
                self._transform_note(note)
                self.stats.migrated += 1
            except Exception as e:
                self.stats.errors += 1
                self.log(f"  Error transforming {note.title}: {e}")

    def _transform_note(self, note: ObsidianNote):
        """Transform single note to KAAOS format."""
        note_type = self._determine_note_type(note)
        output_dir = self.output_path / 'context-library' / note_type
        output_file = output_dir / f"{note.kaaos_id}.md"

        # Transform content
        transformed_content = self._transform_content(note)

        # Generate standardized frontmatter
        frontmatter = self._generate_frontmatter(note, note_type)

        # Combine
        full_content = f"---\n{yaml.dump(frontmatter, default_flow_style=False)}---\n\n{transformed_content}"

        if not self.dry_run:
            output_file.write_text(full_content, encoding='utf-8')
            self.log(f"  Migrated: {note.title} -> {output_file.name}", verbose=True)
        else:
            self.log(f"  [DRY RUN] Would create: {output_file}", verbose=True)

    def _transform_content(self, note: ObsidianNote) -> str:
        """Transform Obsidian content to KAAOS format."""
        content = note.content

        # Update wiki-links with new IDs
        def update_link(match):
            link_target = match.group(1)
            link_text = match.group(2) if match.group(2) else link_target

            # Look up new ID
            target_lower = link_target.lower()
            if target_lower in self.title_to_id:
                new_id = self.title_to_id[target_lower]
                self.stats.links_fixed += 1
                return f"[[{new_id}|{link_text}]]"

            # Keep original if not found
            return match.group(0)

        content = self.WIKILINK_PATTERN.sub(update_link, content)

        # Convert embedded files
        content = self._convert_embeds(content)

        # Ensure KAAOS sections exist
        if not any(section in content for section in ['## Summary', '## Overview', '## Description']):
            # Try to use first paragraph as summary
            paragraphs = content.split('\n\n')
            if paragraphs:
                first_para = paragraphs[0].strip()
                if not first_para.startswith('#'):
                    summary = first_para[:300] + '...' if len(first_para) > 300 else first_para
                    rest = '\n\n'.join(paragraphs[1:]) if len(paragraphs) > 1 else ''
                    content = f"## Summary\n\n{summary}\n\n## Details\n\n{rest}"

        # Ensure Related section
        if '## Related' not in content and '## See Also' not in content:
            content += "\n\n## Related\n\n*[Add related note links]*\n"

        return content

    def _convert_embeds(self, content: str) -> str:
        """Convert Obsidian embeds to KAAOS format."""
        def convert_embed(match):
            embed_target = match.group(1)

            # Image embed
            if any(embed_target.lower().endswith(ext) for ext in ['.png', '.jpg', '.jpeg', '.gif', '.svg']):
                return f"![{embed_target}](assets/{embed_target})"

            # Note embed -> link
            target_lower = embed_target.lower()
            if target_lower in self.title_to_id:
                return f"See: [[{self.title_to_id[target_lower]}|{embed_target}]]"

            return match.group(0)

        return self.EMBED_PATTERN.sub(convert_embed, content)

    def _generate_frontmatter(self, note: ObsidianNote, note_type: str) -> Dict:
        """Generate standardized KAAOS frontmatter."""
        type_map = {
            'atomic': 'atomic',
            'maps': 'map',
            'playbooks': 'playbook',
            'decisions': 'decision',
            'references': 'reference',
            'synthesis': 'synthesis'
        }

        frontmatter = {
            'id': note.kaaos_id,
            'type': type_map.get(note_type, 'atomic'),
            'title': note.title,
            'tags': [self.tag_prefix] + note.tags,
            'created': note.created.strftime('%Y-%m-%d') if note.created else datetime.now().strftime('%Y-%m-%d'),
            'confidence': 'medium',
            'source': 'obsidian-migration',
        }

        if note.updated:
            frontmatter['updated'] = note.updated.strftime('%Y-%m-%d')

        # Preserve any custom frontmatter fields
        preserve_fields = ['aliases', 'author', 'status', 'project']
        for field in preserve_fields:
            if field in note.frontmatter:
                frontmatter[field] = note.frontmatter[field]

        self.stats.frontmatter_standardized += 1
        return frontmatter

    def _copy_attachments(self):
        """Copy attachments from Obsidian vault."""
        assets_dir = self.output_path / 'context-library' / 'assets'
        asset_extensions = {'.png', '.jpg', '.jpeg', '.gif', '.svg', '.pdf', '.webp', '.mp3', '.mp4'}

        for att_dir in self.attachment_dirs:
            source_dir = self.input_path / att_dir
            if source_dir.exists():
                for asset_file in source_dir.rglob('*'):
                    if asset_file.suffix.lower() in asset_extensions:
                        if not self.dry_run:
                            dest = assets_dir / asset_file.name
                            shutil.copy2(asset_file, dest)
                        self.stats.assets_copied += 1
                        self.log(f"  Copied: {asset_file.name}", verbose=True)

    def _generate_index(self):
        """Generate 00-INDEX.md."""
        context_lib = self.output_path / 'context-library'
        index_path = context_lib / '00-INDEX.md'

        # Group by type
        by_type: Dict[str, List[ObsidianNote]] = {}
        for note in self.notes:
            note_type = self._determine_note_type(note)
            if note_type not in by_type:
                by_type[note_type] = []
            by_type[note_type].append(note)

        index_content = f"""---
id: INDEX-00
type: index
created: {datetime.now().strftime('%Y-%m-%d')}
updated: {datetime.now().strftime('%Y-%m-%d')}
---

# {self.org_name.title()} Context Library

Knowledge migrated from Obsidian on {datetime.now().strftime('%Y-%m-%d')}.

## Statistics

- **Total Notes**: {self.stats.migrated}
- **Source**: Obsidian Vault
- **Migration Date**: {datetime.now().strftime('%Y-%m-%d')}

## By Type

"""
        type_order = ['maps', 'playbooks', 'atomic', 'decisions', 'references']
        for note_type in type_order:
            if note_type in by_type:
                notes = by_type[note_type]
                index_content += f"### {note_type.title()} ({len(notes)})\n\n"
                for note in notes[:15]:
                    index_content += f"- [[{note.kaaos_id}|{note.title}]]\n"
                if len(notes) > 15:
                    index_content += f"- *...and {len(notes) - 15} more*\n"
                index_content += "\n"

        index_content += """
## Post-Migration Tasks

1. Review converted frontmatter
2. Verify all links resolve
3. Add cross-references where needed
4. Create additional map notes
5. Run: `/kaaos:maintenance validate`

---
*Generated during Obsidian migration*
"""

        index_path.write_text(index_content, encoding='utf-8')

    def _slugify(self, text: str) -> str:
        """Convert text to slug."""
        slug = text.lower()
        slug = re.sub(r'[^a-z0-9]+', '-', slug)
        slug = slug.strip('-')
        return slug

    def log(self, message: str, verbose: bool = False):
        """Log message if appropriate."""
        if verbose and not self.verbose:
            return
        print(message)

    def _print_summary(self):
        """Print migration summary."""
        print("\n" + "=" * 50)
        print("OBSIDIAN MIGRATION SUMMARY")
        print("=" * 50)
        print(f"  Total files scanned: {self.stats.total_files}")
        print(f"  Successfully migrated: {self.stats.migrated}")
        print(f"  Skipped: {self.stats.skipped}")
        print(f"  Errors: {self.stats.errors}")
        print(f"  Frontmatter standardized: {self.stats.frontmatter_standardized}")
        print(f"  Links updated: {self.stats.links_fixed}")
        print(f"  Assets copied: {self.stats.assets_copied}")
        print("=" * 50)

        if self.dry_run:
            print("\n[DRY RUN - No files were created]")


def main():
    parser = argparse.ArgumentParser(
        description='Migrate Obsidian vault to KAAOS context library'
    )

    parser.add_argument('--input', '-i', required=True, help='Path to Obsidian vault')
    parser.add_argument('--output', '-o', required=True, help='Output organization directory')
    parser.add_argument('--org', required=True, help='Organization name')
    parser.add_argument('--dry-run', action='store_true', help='Preview without writing')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--preserve-dates', action='store_true', default=True)
    parser.add_argument('--min-words', type=int, default=30)
    parser.add_argument('--skip-daily-notes', action='store_true', default=True)
    parser.add_argument('--tag-prefix', default='obsidian-migrated')

    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input path does not exist: {input_path}")
        exit(1)

    migrator = ObsidianMigrator(
        input_path=input_path,
        output_path=Path(args.output),
        org_name=args.org,
        verbose=args.verbose,
        dry_run=args.dry_run,
        preserve_dates=args.preserve_dates,
        min_words=args.min_words,
        skip_daily_notes=args.skip_daily_notes,
        tag_prefix=args.tag_prefix
    )

    stats = migrator.migrate()
    exit(1 if stats.errors > 0 else 0)


if __name__ == '__main__':
    main()
