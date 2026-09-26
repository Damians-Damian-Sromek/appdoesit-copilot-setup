# Auto-Fix Procedures

Step-by-step procedures for automatically fixing common skill issues.

## Safety Guardrails

Before auto-fixing, always:
1. **Read the file** to confirm the issue exists
2. **Make minimal changes** - fix only the identified issue
3. **Preserve formatting** - maintain existing style
4. **Verify after fix** - read file to confirm fix applied

## Frontmatter Fixes

### Fix: Missing name field

**Detection:** No `name:` in YAML frontmatter.

**Procedure:**
1. Get directory name from skill path
2. Add `name: {directory-name}` as first frontmatter field

**Example:**
```yaml
# Before
---
description: Some description
---

# After
---
name: my-skill
description: Some description
---
```

### Fix: Name doesn't match directory

**Detection:** `name:` value differs from directory name.

**Procedure:**
1. Get directory name from skill path
2. Update `name:` to match

### Fix: Missing description field

**Detection:** No `description:` in YAML frontmatter.

**Procedure:** Flag for manual writing - descriptions require human judgment.

**Report:**
```
CRITICAL: Skill {skill} missing description. Manual intervention required.
```

### Fix: Extra frontmatter fields

**Detection:** Fields other than `name`, `description`, `license`.

**Procedure:**
1. Remove extra fields
2. Preserve name, description, license (if present)

## Structure Fixes

### Fix: SKILL.md too long (>500 lines)

**Detection:** Line count > 500.

**Procedure:**
1. Identify verbose sections (explanations, examples, lists)
2. Create reference file: `references/{section-name}.md`
3. Move content to reference file
4. Add link in SKILL.md: `See [{section-name}.md](references/{section-name}.md)`

### Fix: Missing Copilot note

**Detection:** Skill uses Task tool but no Copilot note.

**Procedure:**
1. Search SKILL.md for "Task tool" or "sub-agent"
2. If found, add note after YAML frontmatter:

```markdown
> **Copilot Note**: This skill includes delegation/subagent examples.
> - In **VS Code**, you can use subagents (runSubagent) and custom agents.
> - In other Copilot surfaces that don't support subagents/Task, execute the steps directly.
```

### Fix: Broken reference link

**Detection:** Link to file that doesn't exist.

**Procedure:**
1. Check if similar file exists (typo in name)
2. If found, fix link
3. If not found, remove link and flag for review

## Organization Fixes

### Fix: Unnecessary files

**Detection:** README.md, CHANGELOG.md, INSTALLATION.md, etc.

**Procedure:**
1. Delete the file:
```bash
rm .agents/skills/{skill}/{unnecessary-file}
```

### Fix: Unlinked reference file

**Detection:** File in references/ not linked from SKILL.md.

**Procedure:**
1. Read reference file to understand purpose
2. Add link in appropriate section of SKILL.md:
```markdown
See [{filename}](references/{filename}) for {purpose}.
```

## Cross-Tool Sync Fixes

### Fix: Missing from AGENTS.md

**Detection:** Skill exists but not in Quality Standards table.

**Procedure:**
1. Read AGENTS.md
2. Find Quality Standards table
3. Add row (maintain alphabetical order):
```markdown
| {Requirement Area} | `.agents/skills/{skill}/SKILL.md` | {Key points from description} |
```

### Fix: Missing from copilot-instructions.md

**Detection:** Skill exists but not in Skill Files Reference table.

**Procedure:**
1. Read .github/copilot-instructions.md
2. Find Skill Files Reference table
3. Add row (maintain alphabetical order):
```markdown
| {Skill Name} | `.agents/skills/{skill}/SKILL.md` | {When to use from description} |
```

### Fix: Missing workflow trigger

**Detection:** Skill should have workflow trigger but doesn't.

**Procedure:**
1. Read .github/copilot-instructions.md
2. Add workflow trigger in Workflow Triggers section:
```markdown
**When {trigger condition}**:
1. Read `.agents/skills/{skill}/SKILL.md` -> {What to do}
```

### Fix: Missing PM tracking policy alignment

**Detection:** PM tracking instructions conflict or are missing across:

- `AGENTS.md`
- `.agents/skills/project-manager/SKILL.md`
- `.github/copilot-instructions.md`
- `.github/agents/project-manager.agent.md`

**Procedure:**
1. Define `docs/work_logs` as mandatory PM tracking location.
2. Define `apps/{slug}/PROJECT.md` as generic high-level summary only.
3. Ensure all four files use consistent wording for:
   - filename convention: `YYYY-MM-DD_HHMM_task-slug.md`
   - required work-log sections
   - required status enum
4. Ensure PM references include a work-log template.

### Fix: Missing PM Status Payload contract in specialist skill

**Detection:** Specialist skill lacks PM-delegated output payload instructions.

**Procedure:**
1. Add a section:
```markdown
## PM Status Payload (When Delegated by /project-manager)
```
2. Require these exact fields:
   - Work Item ID
   - Skill
   - Status
   - Progress Summary
   - Blocker
   - Next Owner

## Temporal File Fixes

### Fix: Temporal files outside var/tmp/

**Detection:** Skill creates files outside `var/tmp/` directory (e.g., `accessibility-reports/`, `seo-reports/`).

**Procedure:**
1. Identify output directory variable (e.g., `OUTPUT_DIR`)
2. Change to `var/tmp/{appropriate-subdirectory}`
3. Ensure script uses `mkdir -p` for the directory
4. Update skill documentation if it mentions output paths

**Example:**
```bash
# Before
OUTPUT_DIR="./accessibility-reports"

# After
OUTPUT_DIR="./var/tmp/accessibility"
mkdir -p "$OUTPUT_DIR"
```

**Standard subdirectories:**
- `var/tmp/accessibility/` - Accessibility reports
- `var/tmp/performance/` - Performance reports
- `var/tmp/seo/` - SEO reports
- `var/tmp/qa/` - QA screenshots
- `var/tmp/playwright/` - E2E test reports
- `var/tmp/test-results/` - Test results

## Content Fixes

### Fix: Verbose introduction

**Detection:** First section is non-actionable (welcome, overview, about).

**Procedure:**
1. Delete introduction section
2. Ensure first heading is actionable workflow

### Fix: Duplicated content

**Detection:** Same text appears in multiple skills.

**Procedure:**
1. Identify canonical location (most appropriate skill)
2. Keep content in canonical location
3. Replace duplicates with links:
```markdown
See [skill-name](../{skill}/SKILL.md) for {topic}.
```

## Verification Procedures

### After Any Fix

Prefer tool-first verification (works in any agent surface):

```text
Read tool (use an absolute path):
  filePath: {repoRoot}/.agents/skills/{skill}/SKILL.md
  limit: 30
Confirm:
- YAML frontmatter exists (--- ... ---)
- name/description fields present
- No obvious formatting breakage
```

### After Cross-Tool Sync Fix

```text
Grep tool:
  pattern: "\\| Requirement Area \\| Skill File \\|"
  path: {repoRoot}
  include: "AGENTS.md"

Grep tool:
  pattern: "\\| Skill \\| File Path \\| When to Use \\|"
  path: {repoRoot}/.github
  include: "copilot-instructions.md"

Then Read tool around the matched lines to confirm ordering.
```

### After Structure Fix

```bash
# Verify line count
wc -l .agents/skills/{skill}/SKILL.md

# Verify references exist (CLI fallback)
ls -la .agents/skills/{skill}/references/
```

Tool-first alternative:

```text
Glob tool:
  pattern: .agents/skills/{skill}/references/*
Confirm expected files exist.
```
