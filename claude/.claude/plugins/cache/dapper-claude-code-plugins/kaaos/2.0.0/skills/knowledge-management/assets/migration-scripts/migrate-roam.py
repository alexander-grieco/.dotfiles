#!/usr/bin/env python3
"""
Migrate knowledge from Roam Research export to KAAOS context library.

Roam uses a unique outliner format with block references and bidirectional links.
This script transforms Roam's structure into KAAOS atomic notes while preserving
the essence of block references as contextual links.

Usage:
    python migrate-roam.py --input ~/Downloads/roam-export \
                          --output ~/kaaos-knowledge/organizations/research \
                          --org research

Prerequisites:
    - Export from Roam: All Pages > Export All > Markdown
    - Install: pip install pyyaml python-dateutil
"""

import argparse
import json
import re
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
class RoamBlock:
    """Represents a Roam block."""
    uid: str
    content: str
    children: List['RoamBlock'] = field(default_factory=list)
    parent_uid: Optional[str] = None


@dataclass
class RoamPage:
    """Represents a Roam page for migration."""
    source_path: Path
    title: str
    content: str
    blocks: List[RoamBlock] = field(default_factory=list)
    created: Optional[datetime] = None
    updated: Optional[datetime] = None
    tags: List[str] = field(default_factory=list)
    linked_pages: List[str] = field(default_factory=list)
    kaaos_id: Optional[str] = None


@dataclass
class MigrationStats:
    """Track migration statistics."""
    total_files: int = 0
    migrated: int = 0
    skipped: int = 0
    errors: int = 0
    blocks_processed: int = 0
    links_converted: int = 0
    block_refs_resolved: int = 0


class RoamMigrator:
    """
    Handles migration from Roam Research to KAAOS format.

    Features:
    - Converts Roam markdown to KAAOS atomic notes
    - Resolves block references to contextual links
    - Handles page references and tags
    - Flattens outline structure appropriately
    - Preserves bidirectional linking intent
    """

    # Roam-specific patterns
    PAGE_REF_PATTERN = re.compile(r'\[\[([^\]]+)\]\]')
    BLOCK_REF_PATTERN = re.compile(r'\(\(([a-zA-Z0-9_-]+)\)\)')
    TAG_PATTERN = re.compile(r'#\[\[([^\]]+)\]\]|#([a-zA-Z][a-zA-Z0-9_-]*)')
    ATTRIBUTE_PATTERN = re.compile(r'^([^:]+)::(.+)$')
    DATE_PAGE_PATTERN = re.compile(r'^(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d+(?:st|nd|rd|th)?,?\s+\d{4}$')
    BULLET_PATTERN = re.compile(r'^(\s*)[-*]\s+(.+)$', re.MULTILINE)

    def __init__(
        self,
        input_path: Path,
        output_path: Path,
        org_name: str,
        verbose: bool = False,
        dry_run: bool = False,
        preserve_dates: bool = True,
        min_words: int = 50,
        skip_daily_pages: bool = True,
        flatten_depth: int = 2,
        tag_prefix: str = 'roam-migrated'
    ):
        self.input_path = Path(input_path)
        self.output_path = Path(output_path)
        self.org_name = org_name
        self.verbose = verbose
        self.dry_run = dry_run
        self.preserve_dates = preserve_dates
        self.min_words = min_words
        self.skip_daily_pages = skip_daily_pages
        self.flatten_depth = flatten_depth
        self.tag_prefix = tag_prefix

        self.stats = MigrationStats()
        self.pages: List[RoamPage] = []
        self.title_to_id: Dict[str, str] = {}
        self.block_to_page: Dict[str, str] = {}  # block_uid -> page_title

    def migrate(self) -> MigrationStats:
        """Execute the full migration process."""
        self.log("Starting Roam Research migration...")
        self.log(f"  Input: {self.input_path}")
        self.log(f"  Output: {self.output_path}")

        # Phase 1: Scan export
        self.log("\nPhase 1: Scanning Roam export...")
        self._scan_roam_export()

        # Phase 2: Build mappings
        self.log("\nPhase 2: Building ID and block mappings...")
        self._build_mappings()

        # Phase 3: Create structure
        self.log("\nPhase 3: Creating output structure...")
        if not self.dry_run:
            self._create_structure()

        # Phase 4: Transform pages
        self.log("\nPhase 4: Transforming pages...")
        self._transform_all_pages()

        # Phase 5: Generate index
        self.log("\nPhase 5: Generating index...")
        if not self.dry_run:
            self._generate_index()

        self._print_summary()
        return self.stats

    def _scan_roam_export(self):
        """Scan Roam export directory."""
        # Roam can export as individual .md files or a single JSON
        json_export = self.input_path / 'roam-export.json'

        if json_export.exists():
            self._parse_json_export(json_export)
        else:
            self._parse_markdown_export()

        self.log(f"  Found {len(self.pages)} pages to migrate")

    def _parse_json_export(self, json_path: Path):
        """Parse Roam JSON export format."""
        try:
            data = json.loads(json_path.read_text(encoding='utf-8'))

            for page_data in data:
                self.stats.total_files += 1

                title = page_data.get('title', 'Untitled')

                # Skip daily pages
                if self.skip_daily_pages and self._is_daily_page(title):
                    self.stats.skipped += 1
                    continue

                # Extract content from children
                content = self._extract_content_from_blocks(
                    page_data.get('children', [])
                )

                if len(content.split()) < self.min_words:
                    self.stats.skipped += 1
                    continue

                # Parse dates
                created = None
                if 'create-time' in page_data:
                    created = datetime.fromtimestamp(page_data['create-time'] / 1000)
                elif 'edit-time' in page_data:
                    created = datetime.fromtimestamp(page_data['edit-time'] / 1000)

                # Extract tags from content
                tags = self._extract_tags(content)

                # Extract linked pages
                linked = self._extract_page_refs(content)

                page = RoamPage(
                    source_path=json_path,
                    title=title,
                    content=content,
                    created=created,
                    tags=tags,
                    linked_pages=linked
                )

                self.pages.append(page)

                # Build block mapping
                self._map_blocks(page_data.get('children', []), title)

        except Exception as e:
            self.log(f"Error parsing JSON export: {e}")
            self.stats.errors += 1

    def _parse_markdown_export(self):
        """Parse Roam markdown export format."""
        for md_file in self.input_path.rglob('*.md'):
            self.stats.total_files += 1

            try:
                title = md_file.stem

                # Skip daily pages
                if self.skip_daily_pages and self._is_daily_page(title):
                    self.stats.skipped += 1
                    continue

                content = md_file.read_text(encoding='utf-8')

                # Skip short pages
                if len(content.split()) < self.min_words:
                    self.stats.skipped += 1
                    continue

                # Get dates from file
                created = None
                if self.preserve_dates:
                    stat = md_file.stat()
                    created = datetime.fromtimestamp(stat.st_mtime)

                tags = self._extract_tags(content)
                linked = self._extract_page_refs(content)

                page = RoamPage(
                    source_path=md_file,
                    title=title,
                    content=content,
                    created=created,
                    tags=tags,
                    linked_pages=linked
                )

                self.pages.append(page)

            except Exception as e:
                self.stats.errors += 1
                self.log(f"  Error parsing {md_file}: {e}")

    def _extract_content_from_blocks(
        self,
        blocks: List[dict],
        depth: int = 0
    ) -> str:
        """Recursively extract content from Roam blocks."""
        lines = []

        for block in blocks:
            self.stats.blocks_processed += 1

            string = block.get('string', '')
            if string:
                indent = '  ' * min(depth, self.flatten_depth)
                lines.append(f"{indent}- {string}")

            # Process children
            if 'children' in block and depth < self.flatten_depth + 1:
                child_content = self._extract_content_from_blocks(
                    block['children'],
                    depth + 1
                )
                if child_content:
                    lines.append(child_content)

        return '\n'.join(lines)

    def _map_blocks(self, blocks: List[dict], page_title: str):
        """Map block UIDs to their containing page."""
        for block in blocks:
            uid = block.get('uid')
            if uid:
                self.block_to_page[uid] = page_title

            if 'children' in block:
                self._map_blocks(block['children'], page_title)

    def _is_daily_page(self, title: str) -> bool:
        """Check if page is a daily note."""
        return bool(self.DATE_PAGE_PATTERN.match(title))

    def _extract_tags(self, content: str) -> List[str]:
        """Extract tags from Roam content."""
        tags = [self.tag_prefix]

        for match in self.TAG_PATTERN.finditer(content):
            tag = match.group(1) or match.group(2)
            if tag:
                tags.append(tag.lower().replace(' ', '-'))

        return list(set(tags))

    def _extract_page_refs(self, content: str) -> List[str]:
        """Extract page references from content."""
        refs = []
        for match in self.PAGE_REF_PATTERN.finditer(content):
            refs.append(match.group(1))
        return list(set(refs))

    def _build_mappings(self):
        """Build ID mappings for all pages."""
        date_counter: Dict[str, int] = {}

        for page in self.pages:
            date_str = page.created.strftime('%Y-%m') if page.created else datetime.now().strftime('%Y-%m')

            if date_str not in date_counter:
                date_counter[date_str] = 0
            date_counter[date_str] += 1

            kaaos_id = f"ATOM-{date_str}-{date_counter[date_str]:03d}"
            page.kaaos_id = kaaos_id

            # Map various forms of the title
            self.title_to_id[page.title.lower()] = kaaos_id
            self.title_to_id[self._slugify(page.title)] = kaaos_id

        self.log(f"  Created {len(self.title_to_id)} title mappings")
        self.log(f"  Mapped {len(self.block_to_page)} blocks")

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
        ]

        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)

    def _transform_all_pages(self):
        """Transform all pages to KAAOS format."""
        for page in self.pages:
            try:
                self._transform_page(page)
                self.stats.migrated += 1
            except Exception as e:
                self.stats.errors += 1
                self.log(f"  Error transforming {page.title}: {e}")

    def _transform_page(self, page: RoamPage):
        """Transform single Roam page to KAAOS format."""
        output_dir = self.output_path / 'context-library' / 'atomic'
        output_file = output_dir / f"{page.kaaos_id}.md"

        # Transform content
        transformed_content = self._transform_content(page)

        # Generate frontmatter
        frontmatter = self._generate_frontmatter(page)

        # Combine
        full_content = f"---\n{yaml.dump(frontmatter, default_flow_style=False)}---\n\n{transformed_content}"

        if not self.dry_run:
            output_file.write_text(full_content, encoding='utf-8')
            self.log(f"  Migrated: {page.title} -> {output_file.name}", verbose=True)
        else:
            self.log(f"  [DRY RUN] Would create: {output_file}", verbose=True)

    def _transform_content(self, page: RoamPage) -> str:
        """Transform Roam content to KAAOS format."""
        content = page.content

        # Convert page references to wiki-links
        def convert_page_ref(match):
            ref_title = match.group(1)
            ref_lower = ref_title.lower()

            if ref_lower in self.title_to_id:
                self.stats.links_converted += 1
                return f"[[{self.title_to_id[ref_lower]}|{ref_title}]]"

            # Keep as placeholder if not found
            return f"[[{ref_title}]]"

        content = self.PAGE_REF_PATTERN.sub(convert_page_ref, content)

        # Convert block references to contextual links
        def convert_block_ref(match):
            block_uid = match.group(1)

            if block_uid in self.block_to_page:
                page_title = self.block_to_page[block_uid]
                page_lower = page_title.lower()

                if page_lower in self.title_to_id:
                    self.stats.block_refs_resolved += 1
                    return f"(see [[{self.title_to_id[page_lower]}|{page_title}]])"

            # Keep reference notation if unresolved
            return f"(ref: {block_uid})"

        content = self.BLOCK_REF_PATTERN.sub(convert_block_ref, content)

        # Convert Roam tags to inline notation
        def convert_tag(match):
            tag = match.group(1) or match.group(2)
            return f"`#{tag}`"

        content = self.TAG_PATTERN.sub(convert_tag, content)

        # Convert Roam attributes
        def convert_attribute(match):
            key = match.group(1).strip()
            value = match.group(2).strip()
            return f"**{key}**: {value}"

        content = self.ATTRIBUTE_PATTERN.sub(convert_attribute, content)

        # Add KAAOS sections
        content = self._add_kaaos_structure(content, page)

        return content

    def _add_kaaos_structure(self, content: str, page: RoamPage) -> str:
        """Add KAAOS section structure to content."""
        # Add title
        result = f"# {page.title}\n\n"

        # Try to extract summary from first non-bullet content
        lines = content.split('\n')
        summary_lines = []
        detail_lines = []

        in_summary = True
        for line in lines:
            stripped = line.strip()
            if in_summary and stripped and not stripped.startswith('-'):
                summary_lines.append(line)
                if len(' '.join(summary_lines)) > 200:
                    in_summary = False
            else:
                if stripped.startswith('-') and in_summary:
                    in_summary = False
                detail_lines.append(line)

        if summary_lines:
            result += "## Summary\n\n"
            result += ' '.join(summary_lines)[:300]
            if len(' '.join(summary_lines)) > 300:
                result += "..."
            result += "\n\n"

        result += "## Details\n\n"
        result += '\n'.join(detail_lines)

        # Add Related section
        if page.linked_pages:
            result += "\n\n## Related\n\n"
            for linked in page.linked_pages[:10]:
                linked_lower = linked.lower()
                if linked_lower in self.title_to_id:
                    result += f"- [[{self.title_to_id[linked_lower]}|{linked}]]\n"
                else:
                    result += f"- [[{linked}]] *(unresolved)*\n"
        else:
            result += "\n\n## Related\n\n*[Add related notes]*\n"

        return result

    def _generate_frontmatter(self, page: RoamPage) -> Dict:
        """Generate KAAOS frontmatter."""
        return {
            'id': page.kaaos_id,
            'type': 'atomic',
            'title': page.title,
            'tags': page.tags,
            'created': page.created.strftime('%Y-%m-%d') if page.created else datetime.now().strftime('%Y-%m-%d'),
            'confidence': 'medium',
            'source': 'roam-migration',
        }

    def _generate_index(self):
        """Generate 00-INDEX.md."""
        context_lib = self.output_path / 'context-library'
        index_path = context_lib / '00-INDEX.md'

        # Sort pages by title
        sorted_pages = sorted(self.pages, key=lambda p: p.title.lower())

        index_content = f"""---
id: INDEX-00
type: index
created: {datetime.now().strftime('%Y-%m-%d')}
updated: {datetime.now().strftime('%Y-%m-%d')}
---

# {self.org_name.title()} Context Library

Knowledge migrated from Roam Research on {datetime.now().strftime('%Y-%m-%d')}.

## Statistics

- **Total Notes**: {self.stats.migrated}
- **Blocks Processed**: {self.stats.blocks_processed}
- **Links Converted**: {self.stats.links_converted}
- **Block Refs Resolved**: {self.stats.block_refs_resolved}
- **Source**: Roam Research Export

## All Notes

"""
        for page in sorted_pages[:50]:
            index_content += f"- [[{page.kaaos_id}|{page.title}]]\n"

        if len(sorted_pages) > 50:
            index_content += f"\n*...and {len(sorted_pages) - 50} more notes*\n"

        index_content += """

## Post-Migration Tasks

1. Review converted block references
2. Fix unresolved page links
3. Add cross-references
4. Create map notes for topic clusters
5. Run: `/kaaos:maintenance validate`

---
*Generated during Roam migration*
"""

        index_path.write_text(index_content, encoding='utf-8')

    def _slugify(self, text: str) -> str:
        """Convert text to slug."""
        slug = text.lower()
        slug = re.sub(r'[^a-z0-9]+', '-', slug)
        return slug.strip('-')

    def log(self, message: str, verbose: bool = False):
        """Log message."""
        if verbose and not self.verbose:
            return
        print(message)

    def _print_summary(self):
        """Print migration summary."""
        print("\n" + "=" * 50)
        print("ROAM RESEARCH MIGRATION SUMMARY")
        print("=" * 50)
        print(f"  Total files scanned: {self.stats.total_files}")
        print(f"  Successfully migrated: {self.stats.migrated}")
        print(f"  Skipped: {self.stats.skipped}")
        print(f"  Errors: {self.stats.errors}")
        print(f"  Blocks processed: {self.stats.blocks_processed}")
        print(f"  Links converted: {self.stats.links_converted}")
        print(f"  Block refs resolved: {self.stats.block_refs_resolved}")
        print("=" * 50)

        if self.dry_run:
            print("\n[DRY RUN - No files were created]")


def main():
    parser = argparse.ArgumentParser(
        description='Migrate Roam Research export to KAAOS context library'
    )

    parser.add_argument('--input', '-i', required=True, help='Path to Roam export')
    parser.add_argument('--output', '-o', required=True, help='Output organization directory')
    parser.add_argument('--org', required=True, help='Organization name')
    parser.add_argument('--dry-run', action='store_true', help='Preview without writing')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--preserve-dates', action='store_true', default=True)
    parser.add_argument('--min-words', type=int, default=50)
    parser.add_argument('--skip-daily-pages', action='store_true', default=True)
    parser.add_argument('--flatten-depth', type=int, default=2, help='Max outline depth to preserve')
    parser.add_argument('--tag-prefix', default='roam-migrated')

    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input path does not exist: {input_path}")
        exit(1)

    migrator = RoamMigrator(
        input_path=input_path,
        output_path=Path(args.output),
        org_name=args.org,
        verbose=args.verbose,
        dry_run=args.dry_run,
        preserve_dates=args.preserve_dates,
        min_words=args.min_words,
        skip_daily_pages=args.skip_daily_pages,
        flatten_depth=args.flatten_depth,
        tag_prefix=args.tag_prefix
    )

    stats = migrator.migrate()
    exit(1 if stats.errors > 0 else 0)


if __name__ == '__main__':
    main()
