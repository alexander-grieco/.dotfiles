# Knowledge Maintenance Workflows

Systematic processes for maintaining knowledge base health, ensuring quality over time, and preventing knowledge decay through automated and manual workflows.

## Table of Contents

1. [Maintenance Philosophy](#maintenance-philosophy)
2. [Daily Maintenance](#daily-maintenance)
3. [Weekly Maintenance](#weekly-maintenance)
4. [Monthly Maintenance](#monthly-maintenance)
5. [Quarterly Deep Maintenance](#quarterly-deep-maintenance)
6. [Automated Maintenance Scripts](#automated-maintenance-scripts)
7. [Health Monitoring](#health-monitoring)
8. [Troubleshooting](#troubleshooting)

## Maintenance Philosophy

### Why Maintenance Matters

Knowledge bases suffer from entropy without active maintenance:
- **Link Rot**: References break as notes are renamed or deleted
- **Knowledge Drift**: Information becomes outdated
- **Orphan Accumulation**: Unconnected notes lose value
- **Duplication Creep**: Similar notes created unknowingly
- **Structure Decay**: Organization patterns break down

### The Maintenance Mindset

```yaml
principles:
  prevention_over_cure:
    description: "Catch issues early through automated checks"
    implementation: "Daily validation scripts"

  incremental_improvement:
    description: "Small regular improvements compound"
    implementation: "5-minute daily reviews"

  automated_where_possible:
    description: "Reduce human maintenance burden"
    implementation: "Scheduled agents and scripts"

  human_for_quality:
    description: "Humans review quality, machines check structure"
    implementation: "Weekly human review of agent suggestions"

  measurement_driven:
    description: "Track metrics to identify trends"
    implementation: "Monthly health reports"
```

### Maintenance Time Investment

```markdown
## Recommended Time Allocation

| Frequency | Duration | Focus | Automation |
|-----------|----------|-------|------------|
| Daily | 5 min | Review alerts, quick fixes | 90% automated |
| Weekly | 30 min | Quality review, link updates | 60% automated |
| Monthly | 2 hours | Synthesis, reorganization | 40% automated |
| Quarterly | 4 hours | Deep review, strategic pruning | 20% automated |

**Total Monthly Investment**: ~10 hours
**ROI**: Prevents ~40 hours of remediation work
```

## Daily Maintenance

### Automated Daily Tasks

```python
# daily-maintenance.py

from datetime import datetime
from pathlib import Path
from typing import List, Dict
import json

class DailyMaintenance:
    """Automated daily maintenance tasks."""

    def __init__(self, knowledge_base_path: str):
        self.kb_path = Path(knowledge_base_path)
        self.report_path = self.kb_path / '.kaaos' / 'reports'
        self.today = datetime.now().strftime('%Y-%m-%d')

    def run_all(self) -> Dict:
        """Execute all daily maintenance tasks."""
        report = {
            'date': self.today,
            'tasks': [],
            'alerts': [],
            'auto_fixed': []
        }

        # Task 1: Validate links
        link_results = self.validate_links()
        report['tasks'].append({
            'name': 'link_validation',
            'status': 'completed',
            'results': link_results
        })

        # Task 2: Update backlinks
        backlink_results = self.update_backlinks()
        report['tasks'].append({
            'name': 'backlink_update',
            'status': 'completed',
            'results': backlink_results
        })

        # Task 3: Detect orphans
        orphan_results = self.detect_orphans()
        report['tasks'].append({
            'name': 'orphan_detection',
            'status': 'completed',
            'results': orphan_results
        })

        # Task 4: Update statistics
        stats_results = self.update_statistics()
        report['tasks'].append({
            'name': 'statistics_update',
            'status': 'completed',
            'results': stats_results
        })

        # Generate alerts for issues needing attention
        report['alerts'] = self._generate_alerts(report)

        # Save report
        self._save_report(report)

        return report

    def validate_links(self) -> Dict:
        """Check all internal links for validity."""
        broken_links = []
        total_links = 0

        for note_path in self.kb_path.rglob('*.md'):
            content = note_path.read_text()
            links = self._extract_links(content)
            total_links += len(links)

            for link in links:
                if not self._link_exists(link):
                    broken_links.append({
                        'source': str(note_path),
                        'target': link,
                        'context': self._get_link_context(content, link)
                    })

        return {
            'total_links': total_links,
            'broken_links': len(broken_links),
            'details': broken_links[:10]  # Top 10 for report
        }

    def update_backlinks(self) -> Dict:
        """Add backlinks to notes that are referenced."""
        updates_made = 0
        reference_map = self._build_reference_map()

        for target_id, sources in reference_map.items():
            target_path = self._find_note_by_id(target_id)
            if not target_path:
                continue

            content = target_path.read_text()
            existing_backlinks = self._extract_backlinks(content)

            new_backlinks = [
                s for s in sources
                if s['id'] not in existing_backlinks
            ]

            if new_backlinks:
                updated_content = self._add_backlinks(
                    content, new_backlinks
                )
                target_path.write_text(updated_content)
                updates_made += 1

        return {
            'notes_updated': updates_made,
            'backlinks_added': sum(
                len(v) for v in reference_map.values()
            )
        }

    def detect_orphans(self) -> Dict:
        """Find notes with zero incoming references."""
        orphans = []
        reference_map = self._build_reference_map()

        for note_path in self.kb_path.rglob('*.md'):
            note_id = self._extract_note_id(note_path)
            if note_id and note_id not in reference_map:
                # Check if it's an index or map (allowed to be orphan)
                if not self._is_structural_note(note_path):
                    orphans.append({
                        'path': str(note_path),
                        'id': note_id,
                        'age_days': self._note_age_days(note_path)
                    })

        return {
            'orphan_count': len(orphans),
            'details': sorted(
                orphans,
                key=lambda x: x['age_days'],
                reverse=True
            )[:10]
        }

    def update_statistics(self) -> Dict:
        """Update knowledge base statistics."""
        stats = {
            'total_notes': 0,
            'by_type': {},
            'by_age': {
                'today': 0,
                'this_week': 0,
                'this_month': 0,
                'older': 0
            },
            'link_density': 0,
            'avg_note_length': 0
        }

        total_links = 0
        total_words = 0

        for note_path in self.kb_path.rglob('*.md'):
            stats['total_notes'] += 1

            # By type
            note_type = self._extract_note_type(note_path)
            stats['by_type'][note_type] = stats['by_type'].get(note_type, 0) + 1

            # By age
            age_bucket = self._get_age_bucket(note_path)
            stats['by_age'][age_bucket] += 1

            # Content metrics
            content = note_path.read_text()
            total_links += len(self._extract_links(content))
            total_words += len(content.split())

        if stats['total_notes'] > 0:
            stats['link_density'] = total_links / stats['total_notes']
            stats['avg_note_length'] = total_words / stats['total_notes']

        # Save to statistics file
        stats_file = self.kb_path / '.kaaos' / 'statistics.json'
        stats_file.write_text(json.dumps(stats, indent=2))

        return stats

    def _generate_alerts(self, report: Dict) -> List[Dict]:
        """Generate alerts for issues needing human attention."""
        alerts = []

        # Alert on broken links
        link_task = next(
            t for t in report['tasks']
            if t['name'] == 'link_validation'
        )
        if link_task['results']['broken_links'] > 5:
            alerts.append({
                'severity': 'warning',
                'type': 'broken_links',
                'message': f"{link_task['results']['broken_links']} broken links detected",
                'action': 'Run /kaaos:maintenance fix-links'
            })

        # Alert on orphan accumulation
        orphan_task = next(
            t for t in report['tasks']
            if t['name'] == 'orphan_detection'
        )
        if orphan_task['results']['orphan_count'] > 10:
            alerts.append({
                'severity': 'info',
                'type': 'orphans',
                'message': f"{orphan_task['results']['orphan_count']} orphan notes detected",
                'action': 'Review orphans for linking or archival'
            })

        return alerts

    def _save_report(self, report: Dict):
        """Save daily report to file."""
        report_file = self.report_path / f"daily-{self.today}.json"
        report_file.parent.mkdir(parents=True, exist_ok=True)
        report_file.write_text(json.dumps(report, indent=2))
```

### Daily Maintenance Schedule

```yaml
# .kaaos/schedules/daily-maintenance.yaml

schedule:
  name: daily-maintenance
  cron: "0 6 * * *"  # 6 AM daily
  timezone: local

tasks:
  - name: validate_links
    timeout: 5m
    on_failure: alert

  - name: update_backlinks
    timeout: 10m
    on_failure: alert

  - name: detect_orphans
    timeout: 5m
    on_failure: continue

  - name: update_statistics
    timeout: 5m
    on_failure: continue

notifications:
  on_completion: slack
  on_alert: email
  channel: "#knowledge-maintenance"
```

### Quick Daily Review Checklist

```markdown
## Daily Review (5 minutes)

### Morning (2 min)
- [ ] Check overnight maintenance report
- [ ] Review any alerts generated
- [ ] Acknowledge or dismiss notifications

### Evening (3 min)
- [ ] Quick review of notes created today
- [ ] Ensure new notes have 3+ links
- [ ] Check for obvious issues

### Commands
```bash
# View today's maintenance report
/kaaos:status maintenance

# Quick health check
/kaaos:health --quick

# View recent alerts
/kaaos:alerts --today
```
```

## Weekly Maintenance

### Weekly Task Automation

```python
# weekly-maintenance.py

from datetime import datetime, timedelta
from typing import List, Dict, Tuple
import networkx as nx

class WeeklyMaintenance:
    """Weekly maintenance tasks requiring more analysis."""

    def __init__(self, knowledge_base_path: str):
        self.kb_path = Path(knowledge_base_path)
        self.week_start = datetime.now() - timedelta(days=7)

    def run_all(self) -> Dict:
        """Execute all weekly maintenance tasks."""
        report = {
            'week_ending': datetime.now().strftime('%Y-%m-%d'),
            'tasks': [],
            'suggestions': [],
            'actions_required': []
        }

        # Task 1: Semantic clustering
        clusters = self.identify_semantic_clusters()
        report['tasks'].append({
            'name': 'semantic_clustering',
            'results': clusters
        })

        # Task 2: Pattern detection
        patterns = self.detect_emerging_patterns()
        report['tasks'].append({
            'name': 'pattern_detection',
            'results': patterns
        })

        # Task 3: Stale note detection
        stale = self.identify_stale_notes()
        report['tasks'].append({
            'name': 'stale_detection',
            'results': stale
        })

        # Task 4: Duplicate detection
        duplicates = self.detect_potential_duplicates()
        report['tasks'].append({
            'name': 'duplicate_detection',
            'results': duplicates
        })

        # Task 5: Map note updates
        map_updates = self.suggest_map_updates()
        report['tasks'].append({
            'name': 'map_suggestions',
            'results': map_updates
        })

        # Task 6: Graph health analysis
        graph_health = self.analyze_graph_health()
        report['tasks'].append({
            'name': 'graph_health',
            'results': graph_health
        })

        # Generate suggestions
        report['suggestions'] = self._compile_suggestions(report)
        report['actions_required'] = self._compile_actions(report)

        return report

    def identify_semantic_clusters(self) -> Dict:
        """Find groups of semantically similar notes."""
        from sentence_transformers import SentenceTransformer
        from sklearn.cluster import DBSCAN

        model = SentenceTransformer('all-MiniLM-L6-v2')
        notes = list(self.kb_path.rglob('*.md'))

        # Generate embeddings
        texts = []
        note_ids = []
        for note in notes:
            content = note.read_text()
            summary = self._extract_summary(content)
            texts.append(summary)
            note_ids.append(self._extract_note_id(note))

        embeddings = model.encode(texts)

        # Cluster
        clustering = DBSCAN(eps=0.3, min_samples=3, metric='cosine')
        labels = clustering.fit_predict(embeddings)

        # Group by cluster
        clusters = {}
        for note_id, label in zip(note_ids, labels):
            if label == -1:
                continue
            if label not in clusters:
                clusters[label] = []
            clusters[label].append(note_id)

        # Identify clusters without map notes
        clusters_needing_maps = []
        for cluster_id, members in clusters.items():
            if len(members) >= 5:
                has_map = any(
                    m.startswith('MAP-') for m in members
                )
                if not has_map:
                    clusters_needing_maps.append({
                        'cluster_id': cluster_id,
                        'members': members,
                        'suggested_title': self._suggest_cluster_title(members)
                    })

        return {
            'total_clusters': len(clusters),
            'clusters_needing_maps': clusters_needing_maps
        }

    def detect_emerging_patterns(self) -> Dict:
        """Identify patterns in recent notes."""
        recent_notes = self._get_notes_since(self.week_start)

        # Extract tags from recent notes
        tag_frequency = {}
        for note in recent_notes:
            tags = self._extract_tags(note)
            for tag in tags:
                tag_frequency[tag] = tag_frequency.get(tag, 0) + 1

        # Identify emerging patterns (high frequency this week)
        emerging = [
            {'tag': tag, 'frequency': freq}
            for tag, freq in tag_frequency.items()
            if freq >= 3
        ]

        return {
            'notes_analyzed': len(recent_notes),
            'emerging_patterns': sorted(
                emerging,
                key=lambda x: x['frequency'],
                reverse=True
            )
        }

    def identify_stale_notes(self) -> Dict:
        """Find notes not updated in 90+ days."""
        stale_threshold = datetime.now() - timedelta(days=90)
        stale_notes = []

        for note in self.kb_path.rglob('*.md'):
            updated = self._get_note_updated_date(note)
            if updated and updated < stale_threshold:
                stale_notes.append({
                    'path': str(note),
                    'id': self._extract_note_id(note),
                    'last_updated': updated.isoformat(),
                    'days_stale': (datetime.now() - updated).days
                })

        return {
            'stale_count': len(stale_notes),
            'candidates_for_archive': [
                n for n in stale_notes
                if n['days_stale'] > 180
            ],
            'candidates_for_review': [
                n for n in stale_notes
                if 90 <= n['days_stale'] <= 180
            ]
        }

    def detect_potential_duplicates(self) -> Dict:
        """Find notes that may be duplicates."""
        from sklearn.metrics.pairwise import cosine_similarity

        notes = list(self.kb_path.rglob('*.md'))
        similarities = []

        # Compare summaries for similarity
        for i, note1 in enumerate(notes):
            for note2 in notes[i+1:]:
                sim = self._calculate_similarity(note1, note2)
                if sim > 0.85:
                    similarities.append({
                        'note1': str(note1),
                        'note2': str(note2),
                        'similarity': sim
                    })

        return {
            'potential_duplicates': len(similarities),
            'pairs': sorted(
                similarities,
                key=lambda x: x['similarity'],
                reverse=True
            )[:10]
        }

    def analyze_graph_health(self) -> Dict:
        """Analyze knowledge graph connectivity."""
        G = self._build_knowledge_graph()

        metrics = {
            'nodes': G.number_of_nodes(),
            'edges': G.number_of_edges(),
            'density': nx.density(G),
            'connected_components': nx.number_connected_components(
                G.to_undirected()
            ),
            'avg_degree': sum(
                dict(G.degree()).values()
            ) / G.number_of_nodes() if G.number_of_nodes() > 0 else 0,

            # Hub notes (most connected)
            'top_hubs': sorted(
                G.degree(),
                key=lambda x: x[1],
                reverse=True
            )[:10],

            # Isolated notes
            'isolated_notes': [
                n for n in G.nodes()
                if G.degree(n) == 0
            ],

            # Bridge notes (connect communities)
            'bridge_notes': self._find_bridge_notes(G)
        }

        # Health score (0-100)
        metrics['health_score'] = self._calculate_health_score(metrics)

        return metrics

    def _calculate_health_score(self, metrics: Dict) -> int:
        """Calculate overall graph health score."""
        score = 100

        # Penalize low density
        if metrics['density'] < 0.1:
            score -= 20

        # Penalize many isolated notes
        isolation_rate = len(metrics['isolated_notes']) / max(metrics['nodes'], 1)
        if isolation_rate > 0.1:
            score -= int(isolation_rate * 50)

        # Penalize fragmentation
        if metrics['connected_components'] > 3:
            score -= (metrics['connected_components'] - 3) * 5

        # Reward good average connectivity
        if metrics['avg_degree'] >= 3:
            score = min(100, score + 10)

        return max(0, score)
```

### Weekly Review Checklist

```markdown
## Weekly Review (30 minutes)

### Structure Review (10 min)
- [ ] Review semantic clustering suggestions
- [ ] Decide on new map notes to create
- [ ] Check for potential duplicates
- [ ] Review isolated notes

### Quality Review (10 min)
- [ ] Review notes created this week
- [ ] Ensure proper tagging
- [ ] Check link quality and context
- [ ] Verify frontmatter completeness

### Planning (10 min)
- [ ] Identify knowledge gaps
- [ ] Plan notes to create next week
- [ ] Schedule any needed refactoring
- [ ] Update maintenance priorities

### Commands
```bash
# Generate weekly report
/kaaos:maintenance weekly-report

# Review suggested actions
/kaaos:maintenance suggestions

# Fix common issues
/kaaos:maintenance auto-fix
```
```

## Monthly Maintenance

### Monthly Synthesis and Reorganization

```python
# monthly-maintenance.py

class MonthlyMaintenance:
    """Monthly deep maintenance and synthesis."""

    def run_all(self) -> Dict:
        """Execute monthly maintenance tasks."""
        report = {
            'month': datetime.now().strftime('%Y-%m'),
            'tasks': [],
            'synthesis': None,
            'reorganization': None,
            'archive': None
        }

        # Task 1: Generate monthly synthesis
        report['synthesis'] = self.generate_monthly_synthesis()

        # Task 2: Structure optimization
        report['reorganization'] = self.optimize_structure()

        # Task 3: Archive stale content
        report['archive'] = self.archive_stale_content()

        # Task 4: Update all map notes
        report['tasks'].append({
            'name': 'map_update',
            'results': self.update_all_maps()
        })

        # Task 5: Regenerate index
        report['tasks'].append({
            'name': 'index_regeneration',
            'results': self.regenerate_index()
        })

        # Task 6: Full link validation
        report['tasks'].append({
            'name': 'full_link_validation',
            'results': self.full_link_validation()
        })

        return report

    def generate_monthly_synthesis(self) -> Dict:
        """Create synthesis note from month's activity."""
        month_start = datetime.now().replace(day=1)
        notes_created = self._get_notes_since(month_start)

        synthesis = {
            'notes_analyzed': len(notes_created),
            'patterns_identified': [],
            'recommendations': [],
            'synthesis_note_id': None
        }

        # Identify patterns
        tag_clusters = self._cluster_by_tags(notes_created)
        for cluster_name, cluster_notes in tag_clusters.items():
            if len(cluster_notes) >= 3:
                pattern = self._extract_pattern(cluster_notes)
                synthesis['patterns_identified'].append(pattern)

        # Generate recommendations
        synthesis['recommendations'] = self._generate_recommendations(
            synthesis['patterns_identified']
        )

        # Create synthesis note
        synthesis_note = self._create_synthesis_note(synthesis)
        synthesis['synthesis_note_id'] = synthesis_note

        return synthesis

    def optimize_structure(self) -> Dict:
        """Suggest and optionally apply structure optimizations."""
        optimizations = []

        # Check for deep nesting
        deep_paths = self._find_deep_paths(max_depth=4)
        if deep_paths:
            optimizations.append({
                'type': 'reduce_nesting',
                'paths': deep_paths,
                'suggestion': 'Consider flattening directory structure'
            })

        # Check for inconsistent naming
        naming_issues = self._check_naming_consistency()
        if naming_issues:
            optimizations.append({
                'type': 'naming_consistency',
                'issues': naming_issues,
                'suggestion': 'Standardize note naming conventions'
            })

        # Check for oversized directories
        large_dirs = self._find_large_directories(threshold=50)
        if large_dirs:
            optimizations.append({
                'type': 'directory_split',
                'directories': large_dirs,
                'suggestion': 'Consider splitting large directories'
            })

        return {
            'optimizations_found': len(optimizations),
            'details': optimizations
        }

    def archive_stale_content(self) -> Dict:
        """Move old, unused content to archive."""
        archive_candidates = []
        archived = []

        # Find stale notes (180+ days, low references)
        for note in self.kb_path.rglob('*.md'):
            if self._should_archive(note):
                archive_candidates.append(note)

        # Auto-archive notes meeting strict criteria
        for note in archive_candidates:
            if self._auto_archive_safe(note):
                self._move_to_archive(note)
                archived.append(str(note))

        return {
            'candidates': len(archive_candidates),
            'auto_archived': len(archived),
            'manual_review': [
                str(n) for n in archive_candidates
                if str(n) not in archived
            ]
        }

    def update_all_maps(self) -> Dict:
        """Update all map notes with current references."""
        maps = list(self.kb_path.rglob('MAP-*.md'))
        updated = 0

        for map_note in maps:
            content = map_note.read_text()
            updated_content = self._update_map_references(content)

            if updated_content != content:
                map_note.write_text(updated_content)
                updated += 1

        return {
            'maps_found': len(maps),
            'maps_updated': updated
        }

    def regenerate_index(self) -> Dict:
        """Regenerate main index with current statistics."""
        index_path = self.kb_path / '00-INDEX.md'

        # Gather statistics
        stats = self._gather_full_statistics()

        # Generate index content
        index_content = self._generate_index_content(stats)

        # Write index
        index_path.write_text(index_content)

        return {
            'index_updated': True,
            'statistics': stats
        }
```

### Monthly Review Agenda

```markdown
## Monthly Review (2 hours)

### Hour 1: Analysis

#### Review Reports (20 min)
- [ ] Review monthly synthesis note
- [ ] Analyze pattern trends
- [ ] Compare to previous months

#### Structure Assessment (20 min)
- [ ] Review structure optimization suggestions
- [ ] Decide on reorganization actions
- [ ] Plan any major refactoring

#### Archive Review (20 min)
- [ ] Review archive candidates
- [ ] Approve or reject archival
- [ ] Document archival decisions

### Hour 2: Action

#### Map Updates (30 min)
- [ ] Review auto-updated maps
- [ ] Create new maps for emerging clusters
- [ ] Remove obsolete map entries

#### Gap Analysis (20 min)
- [ ] Identify knowledge gaps
- [ ] Prioritize gaps to fill
- [ ] Schedule creation tasks

#### Planning (10 min)
- [ ] Set goals for next month
- [ ] Adjust maintenance schedules if needed
- [ ] Document process improvements

### Deliverables
- [ ] Monthly synthesis note created
- [ ] Structure optimizations applied
- [ ] Archive actions completed
- [ ] Next month goals documented
```

## Quarterly Deep Maintenance

### Quarterly Review Process

```python
# quarterly-maintenance.py

class QuarterlyMaintenance:
    """Deep quarterly maintenance and strategic review."""

    def run_all(self) -> Dict:
        """Execute quarterly deep maintenance."""
        report = {
            'quarter': self._current_quarter(),
            'strategic_review': None,
            'deep_analysis': None,
            'major_actions': [],
            'next_quarter_plan': None
        }

        # Strategic pattern synthesis
        report['strategic_review'] = self.strategic_synthesis()

        # Deep structural analysis
        report['deep_analysis'] = self.deep_structural_analysis()

        # Cross-organization patterns
        if self._has_multiple_orgs():
            report['cross_org'] = self.cross_org_analysis()

        # Generate next quarter plan
        report['next_quarter_plan'] = self.generate_quarterly_plan()

        return report

    def strategic_synthesis(self) -> Dict:
        """Extract strategic patterns from quarter's knowledge."""
        quarter_notes = self._get_quarter_notes()

        synthesis = {
            'total_notes': len(quarter_notes),
            'strategic_patterns': [],
            'decision_review': [],
            'framework_evolution': [],
            'knowledge_roi': {}
        }

        # Review all decisions made this quarter
        decisions = [n for n in quarter_notes if 'DEC-' in str(n)]
        for decision in decisions:
            review = self._review_decision_outcome(decision)
            synthesis['decision_review'].append(review)

        # Identify strategic patterns
        strategic_tags = ['strategy', 'planning', 'leadership', 'growth']
        strategic_notes = [
            n for n in quarter_notes
            if any(tag in self._get_tags(n) for tag in strategic_tags)
        ]
        synthesis['strategic_patterns'] = self._extract_strategic_patterns(
            strategic_notes
        )

        # Calculate knowledge ROI
        synthesis['knowledge_roi'] = self._calculate_knowledge_roi()

        return synthesis

    def deep_structural_analysis(self) -> Dict:
        """Comprehensive structural health analysis."""
        analysis = {
            'hierarchy_health': self._analyze_hierarchy(),
            'link_network': self._deep_network_analysis(),
            'content_quality': self._assess_content_quality(),
            'coverage_map': self._generate_coverage_map(),
            'recommendations': []
        }

        # Generate recommendations based on analysis
        if analysis['hierarchy_health']['depth_issues']:
            analysis['recommendations'].append({
                'priority': 'high',
                'area': 'structure',
                'action': 'Flatten deep directory hierarchies',
                'effort': '2-4 hours'
            })

        if analysis['link_network']['fragmentation'] > 0.3:
            analysis['recommendations'].append({
                'priority': 'medium',
                'area': 'connectivity',
                'action': 'Create bridge notes between clusters',
                'effort': '1-2 hours'
            })

        return analysis

    def _calculate_knowledge_roi(self) -> Dict:
        """Calculate return on knowledge investment."""
        # Measure knowledge reuse
        reuse_metrics = {
            'notes_referenced_multiple_times': 0,
            'playbooks_used': 0,
            'decisions_referenced': 0,
            'patterns_applied': 0
        }

        for note in self.kb_path.rglob('*.md'):
            backlink_count = len(self._get_backlinks(note))
            if backlink_count >= 3:
                reuse_metrics['notes_referenced_multiple_times'] += 1

            if 'PLAY-' in str(note):
                times_used = self._get_times_used(note)
                if times_used > 0:
                    reuse_metrics['playbooks_used'] += 1

        return reuse_metrics
```

### Quarterly Review Template

```markdown
## Quarterly Deep Review (4 hours)

### Part 1: Strategic Review (1.5 hours)

#### Knowledge Portfolio Assessment
- [ ] Review all decisions made this quarter
- [ ] Assess decision outcomes vs predictions
- [ ] Identify decision-making improvements

#### Pattern Evolution
- [ ] Compare patterns to last quarter
- [ ] Identify new emerging patterns
- [ ] Retire obsolete patterns

#### Framework Effectiveness
- [ ] Review usage of documented frameworks
- [ ] Identify frameworks needing updates
- [ ] Document new frameworks discovered

### Part 2: Structural Health (1 hour)

#### Hierarchy Review
- [ ] Assess folder structure effectiveness
- [ ] Plan any major reorganization
- [ ] Review naming conventions

#### Network Analysis
- [ ] Review knowledge graph visualization
- [ ] Identify isolated clusters
- [ ] Plan integration improvements

#### Quality Metrics
- [ ] Review content quality scores
- [ ] Identify notes needing revision
- [ ] Plan quality improvement initiatives

### Part 3: Strategic Planning (1 hour)

#### Gap Analysis
- [ ] Map knowledge coverage vs needs
- [ ] Prioritize gap-filling efforts
- [ ] Assign creation responsibilities

#### Process Improvement
- [ ] Review maintenance effectiveness
- [ ] Identify automation opportunities
- [ ] Plan process enhancements

#### Goals Setting
- [ ] Set quarterly knowledge goals
- [ ] Define success metrics
- [ ] Schedule milestone reviews

### Part 4: Execution (30 minutes)

#### Immediate Actions
- [ ] Execute critical fixes
- [ ] Create priority synthesis notes
- [ ] Update strategic map notes

#### Handoff
- [ ] Document decisions made
- [ ] Assign follow-up tasks
- [ ] Schedule next quarterly review
```

## Automated Maintenance Scripts

### Link Fixer Script

```bash
#!/bin/bash
# fix-broken-links.sh
# Automatically fix common broken link patterns

KB_PATH="${1:-$HOME/kaaos-knowledge}"
REPORT_FILE="$KB_PATH/.kaaos/reports/link-fixes-$(date +%Y%m%d).log"

echo "Starting link fix scan at $(date)" > "$REPORT_FILE"

# Find all markdown files
find "$KB_PATH" -name "*.md" -type f | while read -r file; do
    # Check for broken links
    grep -oP '\[\[([^\]]+)\]\]' "$file" | while read -r link; do
        # Extract link target
        target=$(echo "$link" | sed 's/\[\[\([^|]*\).*/\1/')

        # Check if target exists
        if ! find "$KB_PATH" -name "*${target}*" -type f | grep -q .; then
            echo "Broken: $file -> $target" >> "$REPORT_FILE"

            # Try to find similar file (fuzzy match)
            similar=$(find "$KB_PATH" -name "*.md" -type f | \
                xargs -I {} basename {} | \
                grep -i "${target:0:10}" | head -1)

            if [ -n "$similar" ]; then
                echo "  Suggestion: $similar" >> "$REPORT_FILE"
            fi
        fi
    done
done

echo "Scan complete. Report: $REPORT_FILE"
cat "$REPORT_FILE"
```

### Orphan Linker Script

```python
#!/usr/bin/env python3
# link-orphans.py
"""
Automatically suggest links for orphan notes
based on semantic similarity.
"""

import sys
from pathlib import Path
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

def find_orphans(kb_path: Path) -> list:
    """Find notes with no incoming references."""
    all_notes = list(kb_path.rglob('*.md'))
    reference_targets = set()

    # Build set of referenced notes
    for note in all_notes:
        content = note.read_text()
        # Extract [[references]]
        import re
        refs = re.findall(r'\[\[([^\]|]+)', content)
        reference_targets.update(refs)

    # Find orphans
    orphans = []
    for note in all_notes:
        note_id = note.stem
        if note_id not in reference_targets:
            # Exclude structural notes
            if not any(x in note_id for x in ['INDEX', 'README', 'template']):
                orphans.append(note)

    return orphans

def suggest_links(orphan: Path, all_notes: list, model) -> list:
    """Suggest potential links for an orphan note."""
    orphan_content = orphan.read_text()[:1000]  # First 1000 chars
    orphan_embedding = model.encode([orphan_content])[0]

    suggestions = []
    for note in all_notes:
        if note == orphan:
            continue

        note_content = note.read_text()[:1000]
        note_embedding = model.encode([note_content])[0]

        similarity = cosine_similarity(
            [orphan_embedding],
            [note_embedding]
        )[0][0]

        if similarity > 0.6:
            suggestions.append({
                'note': note.stem,
                'similarity': float(similarity)
            })

    return sorted(suggestions, key=lambda x: x['similarity'], reverse=True)[:5]

def main():
    kb_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.home() / 'kaaos-knowledge'

    print(f"Scanning: {kb_path}")
    model = SentenceTransformer('all-MiniLM-L6-v2')
    all_notes = list(kb_path.rglob('*.md'))

    orphans = find_orphans(kb_path)
    print(f"Found {len(orphans)} orphan notes\n")

    for orphan in orphans[:10]:  # Process first 10
        print(f"\nOrphan: {orphan.stem}")
        suggestions = suggest_links(orphan, all_notes, model)

        if suggestions:
            print("  Suggested links:")
            for s in suggestions:
                print(f"    - [[{s['note']}]] (similarity: {s['similarity']:.2f})")
        else:
            print("  No suggestions found")

if __name__ == '__main__':
    main()
```

### Statistics Generator

```typescript
// generate-stats.ts

import * as fs from 'fs';
import * as path from 'path';
import * as glob from 'glob';

interface KnowledgeStats {
  totalNotes: number;
  byType: Record<string, number>;
  byAge: {
    thisWeek: number;
    thisMonth: number;
    thisQuarter: number;
    older: number;
  };
  linkMetrics: {
    totalLinks: number;
    avgLinksPerNote: number;
    orphanCount: number;
    mostLinked: { note: string; count: number }[];
  };
  contentMetrics: {
    avgWordCount: number;
    shortNotes: number;  // < 100 words
    longNotes: number;   // > 1000 words
  };
  healthScore: number;
}

function generateStats(kbPath: string): KnowledgeStats {
  const notes = glob.sync(path.join(kbPath, '**/*.md'));

  const stats: KnowledgeStats = {
    totalNotes: notes.length,
    byType: {},
    byAge: { thisWeek: 0, thisMonth: 0, thisQuarter: 0, older: 0 },
    linkMetrics: {
      totalLinks: 0,
      avgLinksPerNote: 0,
      orphanCount: 0,
      mostLinked: []
    },
    contentMetrics: {
      avgWordCount: 0,
      shortNotes: 0,
      longNotes: 0
    },
    healthScore: 0
  };

  const linkCounts: Record<string, number> = {};
  let totalWords = 0;
  let totalLinks = 0;

  for (const notePath of notes) {
    const content = fs.readFileSync(notePath, 'utf-8');

    // Count by type
    const type = extractType(content);
    stats.byType[type] = (stats.byType[type] || 0) + 1;

    // Count by age
    const age = getAgeCategory(notePath);
    stats.byAge[age]++;

    // Count links
    const links = extractLinks(content);
    totalLinks += links.length;
    for (const link of links) {
      linkCounts[link] = (linkCounts[link] || 0) + 1;
    }

    // Word count
    const wordCount = content.split(/\s+/).length;
    totalWords += wordCount;
    if (wordCount < 100) stats.contentMetrics.shortNotes++;
    if (wordCount > 1000) stats.contentMetrics.longNotes++;
  }

  // Calculate averages
  stats.linkMetrics.totalLinks = totalLinks;
  stats.linkMetrics.avgLinksPerNote = totalLinks / Math.max(notes.length, 1);
  stats.contentMetrics.avgWordCount = totalWords / Math.max(notes.length, 1);

  // Find most linked
  stats.linkMetrics.mostLinked = Object.entries(linkCounts)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 10)
    .map(([note, count]) => ({ note, count }));

  // Count orphans
  stats.linkMetrics.orphanCount = notes.filter(n =>
    !linkCounts[path.basename(n, '.md')]
  ).length;

  // Calculate health score
  stats.healthScore = calculateHealthScore(stats);

  return stats;
}

function calculateHealthScore(stats: KnowledgeStats): number {
  let score = 100;

  // Penalize low link density
  if (stats.linkMetrics.avgLinksPerNote < 2) {
    score -= 20;
  }

  // Penalize high orphan rate
  const orphanRate = stats.linkMetrics.orphanCount / Math.max(stats.totalNotes, 1);
  if (orphanRate > 0.2) {
    score -= Math.min(30, orphanRate * 100);
  }

  // Penalize too many short notes
  const shortRate = stats.contentMetrics.shortNotes / Math.max(stats.totalNotes, 1);
  if (shortRate > 0.3) {
    score -= 15;
  }

  return Math.max(0, Math.round(score));
}

// Run
const kbPath = process.argv[2] || process.env.HOME + '/kaaos-knowledge';
const stats = generateStats(kbPath);

console.log(JSON.stringify(stats, null, 2));
```

## Health Monitoring

### Health Dashboard Configuration

```yaml
# .kaaos/health-dashboard.yaml

metrics:
  - name: link_health
    query: broken_links / total_links
    threshold:
      warning: 0.05
      critical: 0.1
    description: "Percentage of broken links"

  - name: orphan_rate
    query: orphan_notes / total_notes
    threshold:
      warning: 0.15
      critical: 0.25
    description: "Percentage of orphan notes"

  - name: stale_rate
    query: stale_notes / total_notes
    threshold:
      warning: 0.2
      critical: 0.4
    description: "Notes not updated in 90+ days"

  - name: avg_connectivity
    query: total_links / total_notes
    threshold:
      warning_below: 2.0
      critical_below: 1.0
    description: "Average links per note"

  - name: synthesis_coverage
    query: notes_in_synthesis / total_notes
    threshold:
      warning_below: 0.5
      critical_below: 0.3
    description: "Notes included in synthesis"

alerts:
  channels:
    - type: slack
      webhook: "${SLACK_WEBHOOK}"
    - type: email
      recipient: "${ALERT_EMAIL}"

  rules:
    - metric: link_health
      condition: "> critical"
      action: email
      message: "Critical: {value:.1%} broken links detected"

    - metric: orphan_rate
      condition: "> warning"
      action: slack
      message: "Warning: Orphan rate at {value:.1%}"
```

### Health Check Command

```bash
#!/bin/bash
# health-check.sh
# Quick knowledge base health check

KB_PATH="${1:-$HOME/kaaos-knowledge}"

echo "=== Knowledge Base Health Check ==="
echo "Path: $KB_PATH"
echo "Time: $(date)"
echo ""

# Count notes
TOTAL=$(find "$KB_PATH" -name "*.md" -type f | wc -l)
echo "Total Notes: $TOTAL"

# Count by type
echo ""
echo "By Type:"
echo "  Atomic: $(find "$KB_PATH" -name "ATOM-*.md" | wc -l)"
echo "  Maps: $(find "$KB_PATH" -name "MAP-*.md" | wc -l)"
echo "  Playbooks: $(find "$KB_PATH" -name "PLAY-*.md" | wc -l)"
echo "  Decisions: $(find "$KB_PATH" -name "DEC-*.md" | wc -l)"
echo "  Synthesis: $(find "$KB_PATH" -name "SYNTH-*.md" | wc -l)"

# Check for recent activity
echo ""
echo "Recent Activity (7 days):"
RECENT=$(find "$KB_PATH" -name "*.md" -mtime -7 | wc -l)
echo "  Notes modified: $RECENT"

# Check for stale notes
echo ""
echo "Stale Notes (90+ days):"
STALE=$(find "$KB_PATH" -name "*.md" -mtime +90 | wc -l)
echo "  Count: $STALE"

# Overall health
echo ""
if [ "$STALE" -gt "$((TOTAL / 3))" ]; then
    echo "Health: WARNING - High stale note count"
elif [ "$RECENT" -lt 5 ]; then
    echo "Health: WARNING - Low recent activity"
else
    echo "Health: GOOD"
fi
```

## Troubleshooting

### Common Issues and Solutions

```markdown
## Troubleshooting Guide

### Issue: Many Broken Links

**Symptoms**:
- Daily maintenance reports multiple broken links
- Health score declining

**Diagnosis**:
```bash
/kaaos:maintenance diagnose links
```

**Solutions**:
1. Run automated link fixer: `/kaaos:maintenance fix-links --auto`
2. Review renamed notes: Check git history for recent renames
3. Update references manually for complex cases

### Issue: Orphan Note Accumulation

**Symptoms**:
- Orphan count increasing over time
- Knowledge graph fragmentation

**Diagnosis**:
```bash
/kaaos:maintenance diagnose orphans --verbose
```

**Solutions**:
1. Run orphan linker: `/kaaos:maintenance link-orphans`
2. Review orphan candidates for archival
3. Create map notes to organize isolated clusters
4. Add backlinks when creating new notes

### Issue: Declining Health Score

**Symptoms**:
- Health score dropped 10+ points
- Multiple warning alerts

**Diagnosis**:
```bash
/kaaos:health --detailed
```

**Solutions**:
1. Review health report for specific issues
2. Address highest-impact problems first
3. Schedule deep maintenance session
4. Consider structural reorganization

### Issue: Slow Maintenance Scripts

**Symptoms**:
- Daily maintenance taking >30 minutes
- Timeouts in scheduled jobs

**Solutions**:
1. Increase compute resources
2. Optimize heavy queries (embedding generation)
3. Run expensive tasks less frequently
4. Archive old content to reduce scope
```

## Best Practices

1. **Automate Ruthlessly**: Minimize manual maintenance burden
2. **Alert Early**: Catch issues before they compound
3. **Measure Everything**: Data-driven maintenance decisions
4. **Incremental Over Big-Bang**: Small daily improvements
5. **Human for Quality**: Automation for structure, humans for content
6. **Document Decisions**: Track why maintenance actions taken
7. **Regular Cadence**: Consistent schedule prevents debt accumulation
8. **Health First**: Address health issues before adding content
9. **Archive Aggressively**: Dead content reduces signal-to-noise
10. **Review Reviews**: Periodically assess maintenance effectiveness

## Related Resources

- [[references/context-library-patterns|Context Library Patterns]] - Structure being maintained
- [[references/cross-referencing-system|Cross-Referencing System]] - Link maintenance details
- [[references/knowledge-extraction|Knowledge Extraction]] - Source of new content
- [[SKILL.md|Knowledge Management Skill]] - Parent skill documentation
