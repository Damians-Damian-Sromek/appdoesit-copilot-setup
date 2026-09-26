# Optimization Patterns

Patterns for reducing context token usage and improving skill efficiency.

## Context-Efficient Patterns

### 1. Progressive Disclosure

**Pattern:** Load information only when needed.

```
Level 1: YAML frontmatter (~100 tokens) - Always loaded
Level 2: SKILL.md body (<2000 tokens) - When skill triggers
Level 3: Reference files (unlimited) - When the agent reads them
```

**Application:**
- Keep SKILL.md under 500 lines
- Move detailed content to references/
- Link references clearly from SKILL.md

### 2. Examples Over Explanations

**Anti-pattern:**
```markdown
When you need to create a new file, explain the file-writing tool in prose.
```

**Pattern:**
```markdown
Create or update files with a single patch:

\`\`\`diff
*** Begin Patch
*** Add File: path/to/file.md
+File contents
*** End Patch
\`\`\`
```

### 3. Imperative Writing Style

**Anti-pattern:**
```markdown
You should check if the file exists before editing it.
```

**Pattern:**
```markdown
Check file exists before editing.
```

### 4. Tables for Structured Info

**Anti-pattern:**
```markdown
The first step is to check the frontmatter. Then you need to verify the
structure. After that, check the references. Finally, validate the content.
```

**Pattern:**
```markdown
| Step | Action |
|------|--------|
| 1 | Check frontmatter |
| 2 | Verify structure |
| 3 | Check references |
| 4 | Validate content |
```

### 5. Single Source of Truth

**Anti-pattern:** Same information in AGENTS.md, SKILL.md, and copilot-instructions.md.

**Pattern:** Define once, reference elsewhere.
```markdown
# In SKILL.md
See [AGENTS.md](../../../AGENTS.md) for project requirements.
```

## Anti-Patterns to Fix

### 1. Verbose Introductions

**Anti-pattern:**
```markdown
# My Skill

Welcome to the My Skill documentation. This skill is designed to help you
accomplish various tasks. In this document, you will learn about the
different features and capabilities of this skill. Let's get started!

## Overview

My Skill is a powerful tool that...
```

**Fix:** Remove introduction, start with actionable content.
```markdown
# My Skill

## Workflow 1: {Actionable task}
```

### 2. Over-Explanation of Common Concepts

**Anti-pattern:**
```markdown
## Understanding YAML

YAML (YAML Ain't Markup Language) is a human-readable data serialization
format. It uses indentation to represent structure...
```

**Fix:** Remove - the model already knows this.

### 3. Redundant Conditionals

**Anti-pattern:**
```markdown
If the file exists, read it. If the file does not exist, skip this step.
```

**Fix:**
```markdown
Read file if it exists.
```

### 4. Deeply Nested References

**Anti-pattern:**
```
SKILL.md -> references/guide.md -> references/sub/detail.md -> references/sub/deep/info.md
```

**Fix:** Keep references one level deep.
```
SKILL.md -> references/guide.md (contains all detail)
```

### 5. Duplicated Workflows

**Anti-pattern:** Same workflow steps in multiple skills.

**Fix:** Create shared reference, link from each skill.

## Token Footprint Analysis

### Measuring Skill Size

```bash
# Count lines in SKILL.md
wc -l .agents/skills/{skill}/SKILL.md

# Count total lines in references (tool-first)
# 1) Glob tool: .agents/skills/{skill}/references/*.md
# 2) Bash: wc -l <each matched file>
# 3) Sum the totals (optional)

# Estimate tokens (~0.75 tokens per word, ~10 words per line)
# Lines x 10 x 0.75 ~= Tokens
```

### Target Sizes

| File Type | Target | Maximum |
|-----------|--------|---------|
| SKILL.md | 300 lines | 500 lines |
| Reference file | 200 lines | 500 lines |
| Total references | 500 lines | 1500 lines |

### Red Flags

- SKILL.md > 500 lines -> Split to references
- Reference > 500 lines -> Add table of contents
- Total skill > 2000 lines -> Review for duplication

## Optimization Workflow

1. **Measure** current token footprint
2. **Identify** anti-patterns in content
3. **Apply** patterns from this guide
4. **Move** verbose content to references
5. **Remove** duplicated/obvious content
6. **Verify** skill still functions correctly
