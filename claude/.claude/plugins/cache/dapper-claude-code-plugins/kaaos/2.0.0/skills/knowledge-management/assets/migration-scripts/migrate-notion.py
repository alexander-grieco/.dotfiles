#!/usr/bin/env python3
"""
Migrate knowledge from Notion export to KAAOS context library.

This script transforms Notion's markdown export into KAAOS-compatible
atomic notes with proper frontmatter, standardized IDs, and converted links.

Usage:
    python migrate-notion.py --input ~/Downloads/notion-export \
                            --output ~/kaaos-knowledge/organizations/company-x \
                            --org company-x

Prerequisites:
    - Export Notion workspace as "Markdown & CSV"
    - Extract the downloaded ZIP file
    - Install: pip install pyyaml python-dateutil beautifulsoup4 markdownify
"""

import argparse
import hashlib
import os
import re
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field
import json

try:
    import yaml
    from dateutil import parser as date_parser
    from bs4 import BeautifulSoup
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Install with: pip install pyyaml python-dateutil beautifulsoup4")
    exit(1)


@dataclass
class NotionPage:
    """Represents a Notion page for migration."""
    source_path: Path
    title: str
    content: str
    created: Optional[datetime] = None
    updated: Optional[datetime] = None
    tags: List[str] = field(default_factory=list)
    parent: Optional[str] = None
    children: List[str] = field(default_factory=list)
    notion_id: Optional[str] = None


@dataclass
class MigrationStats:
    """Track migration statistics."""
    total_files: int = 0
    migrated: int = 0
    skipped: int = 0
    errors: int = 0
    links_converted: int = 0
    assets_copied: int = 0


class NotionMigrator:
    """
    Handles migration from Notion export to KAAOS format.

    Features:
    - Converts Notion markdown to KAAOS atomic notes
    - Generates proper frontmatter with IDs and metadata
    - Converts Notion links to [[wiki-links]]
    - Preserves hierarchy where appropriate
    - Copies assets (images, files)
    - Creates initial structure and index
    """

    # Patterns for detecting Notion-specific elements
    NOTION_ID_PATTERN = re.compile(r'([a-f0-9]{32})')
    NOTION_LINK_PATTERN = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')
    NOTION_INTERNAL_LINK = re.compile(r'notion://|notion.so/')

    # Note type detection patterns
    TYPE_PATTERNS = {
        'decision': re.compile(r'decision|decided|choosing|option', re.I),
        'playbook': re.compile(r'playbook|process|how.?to|steps|procedure', re.I),
        'meeting': re.compile(r'meeting|standup|retro|sync|notes', re.I),
        'reference': re.compile(r'reference|resource|link|documentation', re.I),
    }

    def __init__(
        self,
        input_path: Path,
        output_path: Path,
        org_name: str,
        verbose: bool = False,
        dry_run: bool = False,
        preserve_dates: bool = True,
        min_words: int = 50,
        tag_prefix: str = 'notion-migrated'
    ):
        self.input_path = Path(input_path)
        self.output_path = Path(output_path)
        self.org_name = org_name
        self.verbose = verbose
        self.dry_run = dry_run
        self.preserve_dates = preserve_dates
        self.min_words = min_words
        self.tag_prefix = tag_prefix

        self.stats = MigrationStats()
        self.id_map: Dict[str, str] = {}  # notion_id -> kaaos_id
        self.pages: List[NotionPage] = []

    def migrate(self) -> MigrationStats:
        """Execute the full migration process."""
        self.log("Starting Notion migration...")
        self.log(f"  Input: {self.input_path}")
        self.log(f"  Output: {self.output_path}")

        # Phase 1: Scan and parse all Notion files
        self.log("\nPhase 1: Scanning Notion export...")
        self._scan_notion_export()

        # Phase 2: Build ID mapping
        self.log("\nPhase 2: Building ID mappings...")
        self._build_id_map()

        # Phase 3: Create output structure
        self.log("\nPhase 3: Creating output structure...")
        if not self.dry_run:
            self._create_structure()

        # Phase 4: Transform and write notes
        self.log("\nPhase 4: Transforming notes...")
        self._transform_all_pages()

        # Phase 5: Copy assets
        self.log("\nPhase 5: Copying assets...")
        self._copy_assets()

        # Phase 6: Generate index
        self.log("\nPhase 6: Generating index...")
        if not self.dry_run:
            self._generate_index()

        # Report
        self._print_summary()

        return self.stats

    def _scan_notion_export(self):
        """Scan Notion export directory for markdown files."""
        for md_file in self.input_path.rglob('*.md'):
            self.stats.total_files += 1

            try:
                page = self._parse_notion_file(md_file)
                if page and len(page.content.split()) >= self.min_words:
                    self.pages.append(page)
                else:
                    self.stats.skipped += 1
                    self.log(f"  Skipped (too short): {md_file.name}", verbose=True)
            except Exception as e:
                self.stats.errors += 1
                self.log(f"  Error parsing {md_file}: {e}")

        self.log(f"  Found {len(self.pages)} pages to migrate")

    def _parse_notion_file(self, file_path: Path) -> Optional[NotionPage]:
        """Parse a Notion markdown file into a NotionPage object."""
        content = file_path.read_text(encoding='utf-8')

        # Extract title from filename (Notion format: "Title abc123.md")
        filename = file_path.stem
        notion_id_match = self.NOTION_ID_PATTERN.search(filename)

        if notion_id_match:
            notion_id = notion_id_match.group(1)
            title = filename[:notion_id_match.start()].strip()
        else:
            notion_id = None
            title = filename

        # Clean up title
        title = title.strip(' -_')

        # Try to extract date from file metadata
        created = None
        updated = None
        if self.preserve_dates:
            stat = file_path.stat()
            created = datetime.fromtimestamp(stat.st_ctime)
            updated = datetime.fromtimestamp(stat.st_mtime)

        # Detect tags from content
        tags = self._extract_tags(content)

        # Detect parent from path
        relative_path = file_path.relative_to(self.input_path)
        parent = str(relative_path.parent) if relative_path.parent != Path('.') else None

        return NotionPage(
            source_path=file_path,
            title=title,
            content=content,
            created=created,
            updated=updated,
            tags=tags,
            parent=parent,
            notion_id=notion_id
        )

    def _extract_tags(self, content: str) -> List[str]:
        """Extract tags from Notion content."""
        tags = [self.tag_prefix]

        # Check for Notion tags format (Tags: tag1, tag2)
        tag_match = re.search(r'Tags?:\s*([^\n]+)', content, re.I)
        if tag_match:
            raw_tags = tag_match.group(1)
            tags.extend([
                t.strip().lower().replace(' ', '-')
                for t in raw_tags.split(',')
                if t.strip()
            ])

        # Detect note type
        for note_type, pattern in self.TYPE_PATTERNS.items():
            if pattern.search(content):
                tags.append(note_type)
                break

        return list(set(tags))

    def _build_id_map(self):
        """Build mapping from Notion IDs to KAAOS IDs."""
        date_counter: Dict[str, int] = {}

        for page in self.pages:
            date_str = page.created.strftime('%Y-%m') if page.created else datetime.now().strftime('%Y-%m')

            if date_str not in date_counter:
                date_counter[date_str] = 0
            date_counter[date_str] += 1

            kaaos_id = f"ATOM-{date_str}-{date_counter[date_str]:03d}"

            if page.notion_id:
                self.id_map[page.notion_id] = kaaos_id

            # Also map by title for link conversion
            title_key = self._slugify(page.title)
            self.id_map[title_key] = kaaos_id

            page.kaaos_id = kaaos_id

        self.log(f"  Created {len(self.id_map)} ID mappings")

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
            self.log(f"  Created: {directory}", verbose=True)

    def _transform_all_pages(self):
        """Transform all parsed pages to KAAOS format."""
        for page in self.pages:
            try:
                self._transform_page(page)
                self.stats.migrated += 1
            except Exception as e:
                self.stats.errors += 1
                self.log(f"  Error transforming {page.title}: {e}")

    def _transform_page(self, page: NotionPage):
        """Transform a single Notion page to KAAOS format."""
        # Determine output type and path
        note_type = self._determine_note_type(page)
        output_dir = self.output_path / 'context-library' / note_type
        output_file = output_dir / f"{page.kaaos_id}.md"

        # Transform content
        transformed_content = self._transform_content(page)

        # Generate frontmatter
        frontmatter = self._generate_frontmatter(page, note_type)

        # Combine
        full_content = f"---\n{yaml.dump(frontmatter, default_flow_style=False)}---\n\n{transformed_content}"

        # Write
        if not self.dry_run:
            output_file.write_text(full_content, encoding='utf-8')
            self.log(f"  Migrated: {page.title} -> {output_file.name}", verbose=True)
        else:
            self.log(f"  [DRY RUN] Would create: {output_file}", verbose=True)

    def _determine_note_type(self, page: NotionPage) -> str:
        """Determine the KAAOS note type for a page."""
        if 'playbook' in page.tags or 'process' in page.tags:
            return 'playbooks'
        elif 'decision' in page.tags:
            return 'decisions'
        elif 'reference' in page.tags:
            return 'references'
        elif page.parent and 'meeting' in page.parent.lower():
            return 'atomic'  # Meeting notes become atomic
        else:
            return 'atomic'

    def _transform_content(self, page: NotionPage) -> str:
        """Transform Notion content to KAAOS format."""
        content = page.content

        # Remove Notion-specific headers
        content = re.sub(r'^#\s+' + re.escape(page.title) + r'\s*\n', '', content)

        # Convert Notion links to wiki-links
        content = self._convert_links(content)

        # Add KAAOS sections if missing
        if '## Summary' not in content:
            # Try to extract first paragraph as summary
            paragraphs = content.split('\n\n')
            if paragraphs:
                summary = paragraphs[0][:200] + '...' if len(paragraphs[0]) > 200 else paragraphs[0]
                content = f"## Summary\n\n{summary}\n\n## Details\n\n{content}"

        # Add Related section if missing
        if '## Related' not in content:
            content += "\n\n## Related\n\n*[Links to be added during review]*\n"

        return content

    def _convert_links(self, content: str) -> str:
        """Convert Notion links to wiki-links."""
        def replace_link(match):
            text = match.group(1)
            url = match.group(2)

            # Check if internal Notion link
            if self.NOTION_INTERNAL_LINK.search(url):
                # Try to find ID in URL
                id_match = self.NOTION_ID_PATTERN.search(url)
                if id_match:
                    notion_id = id_match.group(1)
                    if notion_id in self.id_map:
                        self.stats.links_converted += 1
                        return f"[[{self.id_map[notion_id]}|{text}]]"

                # Try title-based lookup
                title_key = self._slugify(text)
                if title_key in self.id_map:
                    self.stats.links_converted += 1
                    return f"[[{self.id_map[title_key]}|{text}]]"

            # Keep external links as-is
            return match.group(0)

        return self.NOTION_LINK_PATTERN.sub(replace_link, content)

    def _generate_frontmatter(self, page: NotionPage, note_type: str) -> Dict:
        """Generate KAAOS frontmatter for a page."""
        frontmatter = {
            'id': page.kaaos_id,
            'type': 'atomic' if note_type == 'atomic' else note_type.rstrip('s'),
            'title': page.title,
            'tags': page.tags,
            'created': page.created.strftime('%Y-%m-%d') if page.created else datetime.now().strftime('%Y-%m-%d'),
            'confidence': 'medium',
            'source': 'notion-migration',
        }

        if page.updated:
            frontmatter['updated'] = page.updated.strftime('%Y-%m-%d')

        if page.parent:
            frontmatter['migrated_from'] = page.parent

        return frontmatter

    def _copy_assets(self):
        """Copy images and other assets from Notion export."""
        asset_extensions = {'.png', '.jpg', '.jpeg', '.gif', '.svg', '.pdf', '.webp'}
        assets_dir = self.output_path / 'context-library' / 'assets'

        for asset_file in self.input_path.rglob('*'):
            if asset_file.suffix.lower() in asset_extensions:
                if not self.dry_run:
                    dest = assets_dir / asset_file.name
                    shutil.copy2(asset_file, dest)
                self.stats.assets_copied += 1
                self.log(f"  Copied asset: {asset_file.name}", verbose=True)

    def _generate_index(self):
        """Generate 00-INDEX.md for migrated content."""
        context_lib = self.output_path / 'context-library'
        index_path = context_lib / '00-INDEX.md'

        # Group pages by type
        by_type: Dict[str, List[NotionPage]] = {}
        for page in self.pages:
            note_type = self._determine_note_type(page)
            if note_type not in by_type:
                by_type[note_type] = []
            by_type[note_type].append(page)

        # Build index content
        index_content = f"""---
id: INDEX-00
type: index
created: {datetime.now().strftime('%Y-%m-%d')}
updated: {datetime.now().strftime('%Y-%m-%d')}
---

# {self.org_name.title()} Context Library

Knowledge migrated from Notion on {datetime.now().strftime('%Y-%m-%d')}.

## Quick Stats

- **Total Notes**: {self.stats.migrated}
- **Source**: Notion Export
- **Migration Date**: {datetime.now().strftime('%Y-%m-%d')}

## By Type

"""
        for note_type, pages in by_type.items():
            index_content += f"### {note_type.title()} ({len(pages)})\n\n"
            for page in pages[:10]:  # Show first 10
                index_content += f"- [[{page.kaaos_id}|{page.title}]]\n"
            if len(pages) > 10:
                index_content += f"- *...and {len(pages) - 10} more*\n"
            index_content += "\n"

        index_content += """
## Next Steps

1. Review migrated notes for quality
2. Add cross-references between related notes
3. Create map notes for major topic areas
4. Run maintenance: `/kaaos:maintenance validate`

---
*Auto-generated during Notion migration*
"""

        index_path.write_text(index_content, encoding='utf-8')
        self.log(f"  Generated index at {index_path}")

    def _slugify(self, text: str) -> str:
        """Convert text to slug for ID matching."""
        slug = text.lower()
        slug = re.sub(r'[^a-z0-9]+', '-', slug)
        slug = slug.strip('-')
        return slug

    def log(self, message: str, verbose: bool = False):
        """Log a message if appropriate."""
        if verbose and not self.verbose:
            return
        print(message)

    def _print_summary(self):
        """Print migration summary."""
        print("\n" + "=" * 50)
        print("MIGRATION SUMMARY")
        print("=" * 50)
        print(f"  Total files scanned: {self.stats.total_files}")
        print(f"  Successfully migrated: {self.stats.migrated}")
        print(f"  Skipped (too short): {self.stats.skipped}")
        print(f"  Errors: {self.stats.errors}")
        print(f"  Links converted: {self.stats.links_converted}")
        print(f"  Assets copied: {self.stats.assets_copied}")
        print("=" * 50)

        if self.dry_run:
            print("\n[DRY RUN - No files were actually created]")


def main():
    parser = argparse.ArgumentParser(
        description='Migrate Notion export to KAAOS context library',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    # Basic migration
    python migrate-notion.py --input ~/Downloads/notion-export --output ~/kaaos-knowledge/orgs/company --org company

    # Dry run to preview
    python migrate-notion.py --input ~/Downloads/notion-export --output ~/kaaos-knowledge/orgs/company --org company --dry-run

    # Verbose with custom options
    python migrate-notion.py --input ~/Downloads/notion-export --output ~/kaaos-knowledge/orgs/company --org company --verbose --min-words 100
        """
    )

    parser.add_argument('--input', '-i', required=True, help='Path to Notion export directory')
    parser.add_argument('--output', '-o', required=True, help='Path to output KAAOS organization directory')
    parser.add_argument('--org', required=True, help='Organization name for IDs and structure')
    parser.add_argument('--dry-run', action='store_true', help='Preview without writing files')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--preserve-dates', action='store_true', default=True, help='Preserve file dates (default: true)')
    parser.add_argument('--min-words', type=int, default=50, help='Minimum words to include note (default: 50)')
    parser.add_argument('--tag-prefix', default='notion-migrated', help='Prefix for migration tags')

    args = parser.parse_args()

    # Validate paths
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input path does not exist: {input_path}")
        exit(1)

    output_path = Path(args.output)

    # Run migration
    migrator = NotionMigrator(
        input_path=input_path,
        output_path=output_path,
        org_name=args.org,
        verbose=args.verbose,
        dry_run=args.dry_run,
        preserve_dates=args.preserve_dates,
        min_words=args.min_words,
        tag_prefix=args.tag_prefix
    )

    stats = migrator.migrate()

    # Exit code based on errors
    exit(1 if stats.errors > 0 else 0)


if __name__ == '__main__':
    main()
