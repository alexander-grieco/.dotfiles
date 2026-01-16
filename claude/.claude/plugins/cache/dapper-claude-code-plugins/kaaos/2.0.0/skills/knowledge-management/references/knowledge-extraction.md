# Knowledge Extraction Techniques

Automated and semi-automated strategies for extracting valuable knowledge from conversations, documents, meetings, and other sources into atomic notes that compound over time.

## Table of Contents

1. [Extraction Principles](#extraction-principles)
2. [Conversation Extraction](#conversation-extraction)
3. [Document Processing](#document-processing)
4. [Meeting Extraction](#meeting-extraction)
5. [Automated Extraction Pipelines](#automated-extraction-pipelines)
6. [Quality Assurance](#quality-assurance)
7. [Integration with KAAOS Agents](#integration-with-kaaos-agents)

## Extraction Principles

### The Knowledge Extraction Mindset

**Extraction is not transcription.** The goal is to identify discrete insights, decisions, frameworks, and learnings that have standalone value and can compound when connected to other knowledge.

**Key Questions**:
- Would this insight be useful in a different context?
- Does this represent a reusable pattern or framework?
- Is this a decision with rationale worth preserving?
- Does this resolve a previously open question?
- Is this a warning or anti-pattern others should avoid?

### Extractable Knowledge Types

```yaml
extraction_types:
  decisions:
    description: "Explicit choices with rationale"
    indicators:
      - "We decided to..."
      - "After considering, we chose..."
      - "The decision was made to..."
    output_type: decision_note
    priority: high

  frameworks:
    description: "Mental models or structured approaches"
    indicators:
      - "The way I think about this is..."
      - "A useful framework here is..."
      - "The structure we use..."
    output_type: atomic_note
    priority: high

  patterns:
    description: "Recurring themes or behaviors"
    indicators:
      - "We've seen this before..."
      - "This tends to happen when..."
      - "A common pattern is..."
    output_type: pattern_note
    priority: medium

  learnings:
    description: "Insights from experience"
    indicators:
      - "What we learned was..."
      - "The key insight here is..."
      - "In retrospect..."
    output_type: atomic_note
    priority: high

  action_items:
    description: "Commitments and next steps"
    indicators:
      - "Next steps are..."
      - "Action items..."
      - "I'll follow up by..."
    output_type: task
    priority: medium

  questions:
    description: "Unresolved or open questions"
    indicators:
      - "What we don't know is..."
      - "Open question..."
      - "Need to investigate..."
    output_type: question_note
    priority: low

  anti_patterns:
    description: "What to avoid"
    indicators:
      - "Don't do..."
      - "Avoid..."
      - "This doesn't work because..."
    output_type: atomic_note
    priority: medium
```

### Extraction Confidence Levels

```python
class ExtractionConfidence:
    """Confidence levels for extracted knowledge."""

    HIGH = "high"      # Explicit statement, clear intent
    MEDIUM = "medium"  # Implied or inferred, needs verification
    LOW = "low"        # Speculative or uncertain

def assess_confidence(extracted_content: dict) -> str:
    """Assess confidence level of extracted knowledge."""

    confidence_factors = {
        'explicit_statement': 0.3,
        'supporting_context': 0.2,
        'consistent_with_existing': 0.2,
        'source_authority': 0.2,
        'actionable': 0.1
    }

    score = sum(
        weight for factor, weight in confidence_factors.items()
        if extracted_content.get(factor, False)
    )

    if score >= 0.8:
        return ExtractionConfidence.HIGH
    elif score >= 0.5:
        return ExtractionConfidence.MEDIUM
    else:
        return ExtractionConfidence.LOW
```

## Conversation Extraction

### Post-Session Extraction Workflow

The primary workflow for extracting knowledge from KAAOS work sessions:

```bash
# After completing a work session
# 1. Session ends with /kaaos:session wrap command
# 2. Extraction agent reviews conversation
# 3. Creates draft notes for approval
# 4. Links to existing knowledge graph

# Manual trigger:
/kaaos:session extract
```

### Extraction Agent Implementation

```python
# extraction-agent.py

from typing import List, Dict, Optional
from dataclasses import dataclass
import re

@dataclass
class ExtractedInsight:
    """A single extracted piece of knowledge."""
    type: str
    title: str
    summary: str
    details: str
    confidence: str
    source_context: str
    suggested_tags: List[str]
    suggested_links: List[str]

class ConversationExtractor:
    """Extract knowledge from conversation transcripts."""

    # Patterns that indicate extractable content
    DECISION_PATTERNS = [
        r"(?:we|I) decided (?:to|that)",
        r"the decision (?:was|is) to",
        r"going forward,? we (?:will|'ll)",
        r"(?:final|our) decision:",
    ]

    FRAMEWORK_PATTERNS = [
        r"(?:the|a|my) (?:framework|approach|model) (?:for|is)",
        r"(?:I|we) think about (?:it|this) as",
        r"the way to approach this",
        r"structured (?:as|like)",
    ]

    LEARNING_PATTERNS = [
        r"(?:key|main|important) (?:insight|learning|takeaway)",
        r"what (?:I|we) learned",
        r"in (?:retrospect|hindsight)",
        r"the lesson here is",
    ]

    def __init__(self, knowledge_base_path: str):
        self.kb_path = knowledge_base_path
        self.existing_notes = self._load_existing_notes()

    def extract_from_conversation(
        self,
        transcript: str,
        session_metadata: dict
    ) -> List[ExtractedInsight]:
        """Main extraction entry point."""

        insights = []

        # Split into logical chunks
        chunks = self._segment_conversation(transcript)

        for chunk in chunks:
            # Check each extraction type
            if self._matches_patterns(chunk, self.DECISION_PATTERNS):
                insight = self._extract_decision(chunk, session_metadata)
                if insight:
                    insights.append(insight)

            if self._matches_patterns(chunk, self.FRAMEWORK_PATTERNS):
                insight = self._extract_framework(chunk, session_metadata)
                if insight:
                    insights.append(insight)

            if self._matches_patterns(chunk, self.LEARNING_PATTERNS):
                insight = self._extract_learning(chunk, session_metadata)
                if insight:
                    insights.append(insight)

        # Deduplicate and rank
        insights = self._deduplicate(insights)
        insights = self._rank_by_importance(insights)

        # Suggest links to existing notes
        for insight in insights:
            insight.suggested_links = self._find_related_notes(insight)

        return insights

    def _segment_conversation(self, transcript: str) -> List[str]:
        """Break conversation into logical segments."""
        # Split by topic shifts, speaker changes, or time gaps
        segments = []

        # Simple approach: paragraph-based
        paragraphs = transcript.split('\n\n')

        # Group into contextual chunks (3-5 paragraphs)
        current_chunk = []
        for para in paragraphs:
            current_chunk.append(para)
            if len(current_chunk) >= 4:
                segments.append('\n\n'.join(current_chunk))
                # Keep last paragraph for context overlap
                current_chunk = current_chunk[-1:]

        if current_chunk:
            segments.append('\n\n'.join(current_chunk))

        return segments

    def _extract_decision(
        self,
        chunk: str,
        metadata: dict
    ) -> Optional[ExtractedInsight]:
        """Extract a decision from conversation chunk."""

        # Use LLM to extract structured decision
        prompt = f"""
        Extract the decision from this conversation segment:

        {chunk}

        Return:
        - Decision: (one sentence, what was decided)
        - Rationale: (why this decision)
        - Alternatives: (what other options were considered)
        - Context: (what triggered this decision)
        """

        # Parse LLM response into ExtractedInsight
        # ... implementation depends on LLM integration ...

        return ExtractedInsight(
            type="decision",
            title="[Decision title]",
            summary="[Decision summary]",
            details="[Full decision details]",
            confidence="high",
            source_context=chunk[:200],
            suggested_tags=["decision"],
            suggested_links=[]
        )

    def _find_related_notes(
        self,
        insight: ExtractedInsight
    ) -> List[str]:
        """Find existing notes related to this insight."""

        related = []

        # Search by tags
        for tag in insight.suggested_tags:
            notes_with_tag = self._search_by_tag(tag)
            related.extend(notes_with_tag)

        # Search by semantic similarity
        similar_notes = self._semantic_search(
            insight.summary,
            threshold=0.7,
            limit=5
        )
        related.extend(similar_notes)

        # Deduplicate
        return list(set(related))[:5]

    def _matches_patterns(
        self,
        text: str,
        patterns: List[str]
    ) -> bool:
        """Check if text matches any extraction pattern."""
        text_lower = text.lower()
        return any(re.search(p, text_lower) for p in patterns)
```

### Session Extraction Configuration

```yaml
# .kaaos/extraction-config.yaml

extraction:
  auto_extract: true  # Run after every session
  min_session_length: 500  # chars, skip very short sessions
  max_insights_per_session: 10  # Prevent over-extraction

  confidence_thresholds:
    auto_create: high  # Auto-create notes at this confidence
    suggest: medium    # Suggest for review at this level
    ignore: low        # Don't surface low confidence

  deduplication:
    similarity_threshold: 0.85  # Treat as duplicate above this
    prefer_existing: true       # Merge into existing vs create new

  linking:
    auto_link: true
    min_similarity: 0.7
    max_links: 5

  notification:
    on_extraction: true
    summary_format: markdown
```

### Extraction Report Format

```markdown
# Session Extraction Report

**Session**: 2026-01-15 Sprint Planning
**Duration**: 45 minutes
**Extracted**: 4 insights

## High Confidence (Auto-Created)

### 1. Decision: Sprint Length Change
**Type**: Decision
**Confidence**: High
**Note Created**: [[DEC-2026-015-sprint-length]]

> "We decided to move from 2-week to 1-week sprints to increase
> feedback loops during the migration project."

**Linked To**:
- [[PLAY-agile-sprint-planning]]
- [[2026-01-010|Migration Project Overview]]

## Medium Confidence (Review Needed)

### 2. Framework: Velocity Estimation Approach
**Type**: Framework
**Confidence**: Medium
**Draft Created**: drafts/ATOM-2026-01-020-velocity-estimation.md

> "The way we think about velocity now is story points normalized
> to ideal engineering hours..."

**Action Required**: Review and approve or discard

## Summary

- Created: 1 note
- Drafts for review: 2 notes
- Discarded (low confidence): 3
- Deduped (already exists): 1

---
*Generated by extraction-agent on 2026-01-15*
```

## Document Processing

### PDF and Document Extraction

```python
# document-extractor.py

import pypdf
from pathlib import Path
from typing import List, Dict

class DocumentExtractor:
    """Extract knowledge from PDF and document files."""

    SUPPORTED_FORMATS = ['.pdf', '.docx', '.md', '.txt']

    def __init__(self, knowledge_base_path: str):
        self.kb_path = Path(knowledge_base_path)

    def extract_from_document(
        self,
        document_path: str,
        extraction_config: dict = None
    ) -> List[Dict]:
        """Extract insights from a document."""

        path = Path(document_path)
        if path.suffix not in self.SUPPORTED_FORMATS:
            raise ValueError(f"Unsupported format: {path.suffix}")

        # Load document content
        content = self._load_document(path)

        # Extract based on document type
        if self._is_meeting_notes(content):
            return self._extract_meeting_insights(content)
        elif self._is_research_document(content):
            return self._extract_research_insights(content)
        elif self._is_decision_document(content):
            return self._extract_decision_insights(content)
        else:
            return self._generic_extraction(content)

    def _load_document(self, path: Path) -> str:
        """Load document content as text."""
        if path.suffix == '.pdf':
            return self._extract_pdf_text(path)
        elif path.suffix == '.docx':
            return self._extract_docx_text(path)
        else:
            return path.read_text()

    def _extract_pdf_text(self, path: Path) -> str:
        """Extract text from PDF."""
        reader = pypdf.PdfReader(str(path))
        text_parts = []

        for page in reader.pages:
            text_parts.append(page.extract_text())

        return '\n\n'.join(text_parts)

    def _is_meeting_notes(self, content: str) -> bool:
        """Detect if document is meeting notes."""
        indicators = [
            'attendees:', 'participants:', 'meeting notes',
            'action items:', 'agenda:', 'minutes'
        ]
        content_lower = content.lower()
        return any(ind in content_lower for ind in indicators)

    def _extract_meeting_insights(
        self,
        content: str
    ) -> List[Dict]:
        """Extract insights from meeting notes."""
        insights = []

        # Extract decisions
        decisions = self._find_decisions(content)
        insights.extend(decisions)

        # Extract action items
        actions = self._find_action_items(content)
        insights.extend(actions)

        # Extract key points
        key_points = self._find_key_points(content)
        insights.extend(key_points)

        return insights
```

### Batch Document Processing

```bash
#!/bin/bash
# process-documents.sh
# Batch process documents for knowledge extraction

DOCS_DIR="${1:-./documents}"
OUTPUT_DIR="${2:-./extracted}"

echo "Processing documents from: ${DOCS_DIR}"
mkdir -p "${OUTPUT_DIR}"

# Process each document
find "${DOCS_DIR}" -type f \( -name "*.pdf" -o -name "*.docx" -o -name "*.md" \) | while read -r doc; do
    filename=$(basename "$doc")
    echo "Processing: ${filename}"

    # Run extraction
    python -m kaaos.extraction.document \
        --input "$doc" \
        --output "${OUTPUT_DIR}/${filename%.pdf}.json" \
        --format json \
        --confidence-threshold medium

done

echo "Extraction complete. Review drafts in: ${OUTPUT_DIR}"
```

## Meeting Extraction

### Real-Time Meeting Capture

```python
# meeting-capture.py

from datetime import datetime
from typing import List, Optional
import asyncio

class MeetingCapture:
    """Real-time meeting knowledge capture."""

    def __init__(self, session_id: str, attendees: List[str]):
        self.session_id = session_id
        self.attendees = attendees
        self.start_time = datetime.now()
        self.notes = []
        self.decisions = []
        self.action_items = []

    async def capture_note(
        self,
        speaker: str,
        content: str,
        note_type: str = "general"
    ):
        """Capture a note during the meeting."""
        note = {
            "timestamp": datetime.now().isoformat(),
            "speaker": speaker,
            "content": content,
            "type": note_type
        }

        self.notes.append(note)

        # Real-time classification
        if self._is_decision(content):
            self.decisions.append(note)
        elif self._is_action_item(content):
            self.action_items.append(note)

    def _is_decision(self, content: str) -> bool:
        """Check if content contains a decision."""
        decision_phrases = [
            "decided", "agreed", "will do", "going with",
            "final decision", "we're choosing"
        ]
        content_lower = content.lower()
        return any(phrase in content_lower for phrase in decision_phrases)

    def _is_action_item(self, content: str) -> bool:
        """Check if content is an action item."""
        action_phrases = [
            "action item", "todo", "will follow up",
            "i'll", "we'll", "need to", "should"
        ]
        content_lower = content.lower()
        return any(phrase in content_lower for phrase in action_phrases)

    def generate_meeting_summary(self) -> dict:
        """Generate structured meeting summary."""
        duration = datetime.now() - self.start_time

        return {
            "session_id": self.session_id,
            "date": self.start_time.isoformat(),
            "duration_minutes": duration.total_seconds() / 60,
            "attendees": self.attendees,
            "total_notes": len(self.notes),
            "decisions": self.decisions,
            "action_items": self.action_items,
            "key_topics": self._extract_topics(),
            "suggested_extractions": self._suggest_extractions()
        }

    def _extract_topics(self) -> List[str]:
        """Extract main topics discussed."""
        # Use keyword extraction or topic modeling
        all_content = " ".join(n["content"] for n in self.notes)
        # ... topic extraction logic ...
        return []

    def _suggest_extractions(self) -> List[dict]:
        """Suggest knowledge to extract from meeting."""
        suggestions = []

        # Suggest atomic notes for insights
        for note in self.notes:
            if note["type"] == "insight":
                suggestions.append({
                    "type": "atomic_note",
                    "source": note,
                    "confidence": "medium"
                })

        # Suggest decision notes
        for decision in self.decisions:
            suggestions.append({
                "type": "decision_note",
                "source": decision,
                "confidence": "high"
            })

        return suggestions
```

### Post-Meeting Extraction Workflow

```markdown
## Post-Meeting Extraction Process

1. **During Meeting** (Optional)
   - Use quick capture for key moments
   - Tag decisions and action items in real-time

2. **Immediately After** (5 minutes)
   ```bash
   # Generate meeting summary
   /kaaos:meeting summarize --session-id meeting-2026-01-15
   ```

3. **Review & Approve** (15-30 minutes)
   - Review auto-extracted decisions
   - Approve or edit suggested atomic notes
   - Assign action items
   - Link to relevant existing notes

4. **Integration** (Automated)
   - Approved notes added to context library
   - Backlinks created automatically
   - Index updated
   - Relevant map notes updated

## Quick Capture Commands

```bash
# During meeting - quick decision capture
/kaaos:capture decision "Moving to weekly releases starting Q2"

# Quick insight capture
/kaaos:capture insight "Customer feedback shows 3x preference for feature X"

# Quick action item
/kaaos:capture action "Ben to draft migration plan by Friday"
```
```

## Automated Extraction Pipelines

### Git Hook Integration

```bash
#!/bin/bash
# .git/hooks/post-commit
# Extract knowledge from commits

COMMIT_MSG=$(git log -1 --pretty=%B)
COMMIT_HASH=$(git log -1 --pretty=%H)

# Check for extraction triggers
if [[ $COMMIT_MSG =~ (Decision:|Insight:|Learning:|Pattern:) ]]; then
    echo "🔍 Extracting knowledge from commit..."

    # Trigger extraction
    python -m kaaos.extraction.commit \
        --hash "$COMMIT_HASH" \
        --message "$COMMIT_MSG" \
        --output ~/kaaos-knowledge/drafts/

    echo "📝 Draft notes created. Review with: /kaaos:review drafts"
fi
```

### Scheduled Extraction Jobs

```yaml
# .kaaos/extraction-schedules.yaml

schedules:
  daily_conversation_extraction:
    schedule: "0 22 * * *"  # 10 PM daily
    source: conversations
    window: 24h
    config:
      min_confidence: medium
      auto_approve: false

  weekly_document_scan:
    schedule: "0 9 * * 1"  # Monday 9 AM
    source: documents
    paths:
      - ~/Documents/meeting-notes/
      - ~/Downloads/*.pdf
    config:
      auto_import: false
      create_drafts: true

  email_extraction:
    schedule: "0 18 * * 5"  # Friday 6 PM
    source: email
    filters:
      - "label:important"
      - "from:ceo@company.com"
    config:
      extract_decisions: true
      extract_action_items: true
```

### Pipeline Implementation

```typescript
// extraction-pipeline.ts

import { CronJob } from 'cron';
import { ExtractionConfig, ExtractedInsight } from './types';

interface PipelineStage {
  name: string;
  execute: (input: any) => Promise<any>;
}

class ExtractionPipeline {
  private stages: PipelineStage[] = [];
  private config: ExtractionConfig;

  constructor(config: ExtractionConfig) {
    this.config = config;
    this.initializeStages();
  }

  private initializeStages(): void {
    this.stages = [
      {
        name: 'load',
        execute: this.loadSource.bind(this)
      },
      {
        name: 'preprocess',
        execute: this.preprocess.bind(this)
      },
      {
        name: 'extract',
        execute: this.extractInsights.bind(this)
      },
      {
        name: 'deduplicate',
        execute: this.deduplicateInsights.bind(this)
      },
      {
        name: 'enrich',
        execute: this.enrichWithLinks.bind(this)
      },
      {
        name: 'validate',
        execute: this.validateInsights.bind(this)
      },
      {
        name: 'output',
        execute: this.createDrafts.bind(this)
      }
    ];
  }

  async run(): Promise<ExtractedInsight[]> {
    let data: any = null;

    for (const stage of this.stages) {
      console.log(`Running stage: ${stage.name}`);
      data = await stage.execute(data);
    }

    return data as ExtractedInsight[];
  }

  private async loadSource(input: any): Promise<string[]> {
    // Load content from configured source
    const sources = await this.config.sourceLoader.load();
    return sources;
  }

  private async preprocess(sources: string[]): Promise<string[]> {
    // Clean and normalize content
    return sources.map(s => this.normalizeText(s));
  }

  private async extractInsights(content: string[]): Promise<ExtractedInsight[]> {
    const insights: ExtractedInsight[] = [];

    for (const text of content) {
      const extracted = await this.config.extractor.extract(text);
      insights.push(...extracted);
    }

    return insights;
  }

  private async deduplicateInsights(
    insights: ExtractedInsight[]
  ): Promise<ExtractedInsight[]> {
    // Remove duplicates using semantic similarity
    return this.config.deduplicator.dedupe(insights);
  }

  private async enrichWithLinks(
    insights: ExtractedInsight[]
  ): Promise<ExtractedInsight[]> {
    // Add suggested links to existing notes
    for (const insight of insights) {
      insight.suggestedLinks = await this.findRelatedNotes(insight);
    }
    return insights;
  }

  private async validateInsights(
    insights: ExtractedInsight[]
  ): Promise<ExtractedInsight[]> {
    // Filter by confidence threshold
    return insights.filter(i =>
      this.meetsConfidenceThreshold(i, this.config.minConfidence)
    );
  }

  private async createDrafts(insights: ExtractedInsight[]): Promise<ExtractedInsight[]> {
    // Create draft files for review
    for (const insight of insights) {
      await this.config.draftCreator.create(insight);
    }
    return insights;
  }
}

// Schedule pipeline
const pipeline = new ExtractionPipeline(config);

const job = new CronJob(
  config.schedule,
  async () => {
    console.log('Running scheduled extraction...');
    const results = await pipeline.run();
    console.log(`Extracted ${results.length} insights`);
  }
);

job.start();
```

## Quality Assurance

### Extraction Quality Metrics

```python
# quality-metrics.py

from dataclasses import dataclass
from typing import List, Dict
from datetime import datetime, timedelta

@dataclass
class ExtractionQualityReport:
    """Quality metrics for extraction process."""
    period: str
    total_extracted: int
    approved_rate: float
    discarded_rate: float
    merged_rate: float
    avg_confidence: float
    false_positive_rate: float
    coverage_estimate: float

class QualityTracker:
    """Track and report extraction quality over time."""

    def __init__(self, knowledge_base_path: str):
        self.kb_path = knowledge_base_path
        self.metrics_file = f"{knowledge_base_path}/.kaaos/extraction-metrics.json"

    def calculate_metrics(
        self,
        period_days: int = 30
    ) -> ExtractionQualityReport:
        """Calculate quality metrics for recent extractions."""

        extractions = self._load_recent_extractions(period_days)

        total = len(extractions)
        if total == 0:
            return self._empty_report()

        approved = [e for e in extractions if e['status'] == 'approved']
        discarded = [e for e in extractions if e['status'] == 'discarded']
        merged = [e for e in extractions if e['status'] == 'merged']

        return ExtractionQualityReport(
            period=f"Last {period_days} days",
            total_extracted=total,
            approved_rate=len(approved) / total,
            discarded_rate=len(discarded) / total,
            merged_rate=len(merged) / total,
            avg_confidence=self._avg_confidence(extractions),
            false_positive_rate=self._false_positive_rate(extractions),
            coverage_estimate=self._estimate_coverage()
        )

    def generate_quality_report(self) -> str:
        """Generate human-readable quality report."""

        metrics = self.calculate_metrics()

        return f"""
# Extraction Quality Report

**Period**: {metrics.period}
**Generated**: {datetime.now().isoformat()}

## Summary

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Approved Rate | {metrics.approved_rate:.1%} | >70% | {'✅' if metrics.approved_rate > 0.7 else '⚠️'} |
| Discarded Rate | {metrics.discarded_rate:.1%} | <20% | {'✅' if metrics.discarded_rate < 0.2 else '⚠️'} |
| Avg Confidence | {metrics.avg_confidence:.2f} | >0.75 | {'✅' if metrics.avg_confidence > 0.75 else '⚠️'} |
| False Positive Rate | {metrics.false_positive_rate:.1%} | <10% | {'✅' if metrics.false_positive_rate < 0.1 else '⚠️'} |

## Recommendations

{self._generate_recommendations(metrics)}

## Trend

{self._generate_trend_chart(30)}
"""

    def _generate_recommendations(
        self,
        metrics: ExtractionQualityReport
    ) -> str:
        """Generate actionable recommendations."""
        recs = []

        if metrics.approved_rate < 0.7:
            recs.append("- Increase confidence threshold to reduce noise")
        if metrics.discarded_rate > 0.2:
            recs.append("- Review extraction patterns for common false positives")
        if metrics.avg_confidence < 0.75:
            recs.append("- Consider additional context in extraction prompts")

        return '\n'.join(recs) if recs else "- Quality metrics within targets"
```

### Manual Review Interface

```yaml
# Review workflow for extracted knowledge

review_interface:
  display:
    show_source_context: true
    show_confidence_score: true
    show_suggested_links: true
    preview_note_format: true

  actions:
    approve:
      shortcut: "a"
      description: "Approve and create note"
      auto_link: true

    edit_approve:
      shortcut: "e"
      description: "Edit before approving"
      open_editor: true

    merge:
      shortcut: "m"
      description: "Merge with existing note"
      show_candidates: true

    discard:
      shortcut: "d"
      description: "Discard extraction"
      require_reason: true

    skip:
      shortcut: "s"
      description: "Skip for later review"
```

## Integration with KAAOS Agents

### Copilot Agent Integration

The copilot agent can trigger extraction during active sessions:

```yaml
# copilot-extraction-hooks.yaml

triggers:
  decision_detected:
    pattern: "we've decided|the decision is|going forward"
    action: capture_decision
    confirmation: true  # Ask user before capturing

  insight_detected:
    pattern: "key insight|important point|worth noting"
    action: capture_insight
    confirmation: false  # Silent capture

  framework_detected:
    pattern: "the framework|approach is|structured as"
    action: capture_framework
    confirmation: true
```

### Maintenance Agent Integration

```python
# maintenance-agent/extraction-integration.py

class MaintenanceExtractionIntegration:
    """Maintenance agent tasks for extraction support."""

    def daily_extraction_review(self):
        """Review pending extractions from past 24 hours."""

        pending = self._load_pending_extractions(hours=24)

        report = {
            'pending_review': len(pending),
            'by_type': self._group_by_type(pending),
            'recommended_actions': []
        }

        # Auto-approve high confidence
        high_confidence = [p for p in pending if p['confidence'] == 'high']
        for extraction in high_confidence:
            if self._validate_no_duplicate(extraction):
                self._auto_approve(extraction)
                report['recommended_actions'].append(
                    f"Auto-approved: {extraction['title']}"
                )

        # Flag potential duplicates
        for extraction in pending:
            duplicates = self._find_potential_duplicates(extraction)
            if duplicates:
                report['recommended_actions'].append(
                    f"Review duplicate: {extraction['title']} ~ {duplicates[0]}"
                )

        return report

    def weekly_extraction_synthesis(self):
        """Synthesize patterns from week's extractions."""

        extractions = self._load_extractions(days=7)

        # Group by topic
        topics = self._cluster_by_topic(extractions)

        # Identify emerging patterns
        patterns = self._identify_patterns(topics)

        # Suggest map note updates
        map_updates = self._suggest_map_updates(patterns)

        return {
            'extractions_count': len(extractions),
            'topics_identified': len(topics),
            'patterns': patterns,
            'suggested_map_updates': map_updates
        }
```

### Orchestrator Agent Coordination

```yaml
# orchestrator-extraction-workflows.yaml

workflows:
  comprehensive_extraction:
    trigger: "/kaaos:extract comprehensive"
    agents:
      - extraction-agent  # Primary extraction
      - maintenance-agent # Deduplication & linking
      - copilot-agent     # User confirmation

    steps:
      1:
        agent: extraction-agent
        task: extract_all_sources
        timeout: 30m

      2:
        agent: maintenance-agent
        task: deduplicate_and_link
        input: step_1.output

      3:
        agent: copilot-agent
        task: present_for_review
        input: step_2.output

  session_extraction:
    trigger: session_end
    auto: true
    agents:
      - extraction-agent
    steps:
      1:
        agent: extraction-agent
        task: extract_from_session
        config:
          min_confidence: medium
          create_drafts: true
```

## Best Practices

1. **Extract Immediately**: Capture insights while context is fresh
2. **Confidence Thresholds**: Only auto-create high-confidence extractions
3. **Human Review**: Always review medium confidence before creating notes
4. **Deduplication**: Check existing notes before creating new ones
5. **Link Liberally**: Connect extractions to existing knowledge graph
6. **Quality Tracking**: Monitor extraction quality metrics weekly
7. **Iterate Patterns**: Refine extraction patterns based on false positives
8. **Source Attribution**: Always link back to original source context
9. **Batch Processing**: Schedule regular extraction jobs for passive sources
10. **Feedback Loop**: Mark extraction quality to improve future accuracy

## Common Pitfalls

- **Over-Extraction**: Not every statement is worth preserving
- **Under-Contextualization**: Extracted notes missing source context
- **Duplicate Creation**: Not checking for existing similar notes
- **Stale Drafts**: Pending extractions never reviewed
- **False Confidence**: Auto-approving medium confidence extractions
- **Missing Links**: Extracted notes isolated from knowledge graph
- **Tool Obsession**: Spending more time on extraction than creation

## Related Resources

- [[references/context-library-patterns|Context Library Patterns]] - Where extractions go
- [[references/cross-referencing-system|Cross-Referencing System]] - Linking extractions
- [[references/maintenance-workflows|Maintenance Workflows]] - Ongoing extraction health
- [[SKILL.md|Knowledge Management Skill]] - Parent skill documentation
