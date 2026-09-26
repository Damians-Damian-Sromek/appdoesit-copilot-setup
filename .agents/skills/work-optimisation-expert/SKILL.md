---
name: work-optimisation-expert
description: Comprehensive skill management for GitHub Copilot. Audits skill quality, optimizes context usage, synchronizes agent/skill/instruction files, auto-fixes issues, and enforces PM tracking policy alignment (mandatory docs/work_logs + generic PROJECT.md behavior). Use when creating/updating skills, auditing the skill ecosystem, optimizing skill performance, or keeping Copilot instructions in sync. Automatically invoked for requests like "audit skills", "optimize skills", "sync skills", "check skill quality".
---

> **VS Code Note**: This skill includes delegation/subagent examples. In VS Code, use subagents (runSubagent) and custom agents to isolate research and keep context lean. If your Copilot surface does **not** support subagents, execute the steps directly.

# Work Optimisation Expert

## Scope Boundary (Non-Negotiable)

This skill is **ONLY** for improving the repository’s **project guidelines / AI customization ecosystem**:

- Skills (`.agents/skills/**`)
- Custom agents (`.github/agents/**`)
- Custom instructions (`AGENTS.md`, `.github/copilot-instructions.md`, `.github/instructions/**`)
- Prompt assets (`.github/prompts/**`)
- Guideline documentation (only when it is about agents/skills/instructions)

### Allowed edit targets (whitelist)

- `AGENTS.md`
- `.agents/**`
- `.github/**`
- `docs/**` **ONLY** when updating agent/skill/instruction guidelines

### Forbidden work (hard stop)

Do **NOT** use this skill to:

- Implement or modify apps
- Perform **app** audits (security/SEO/performance/accessibility/QA)
- Change runtime code, tests, translations, or deployment scripts

Do **NOT** modify these paths:

- `apps/**`
- `public/**`
- `config/**`
- `tests/**`
- `i18n/**`
- `scripts/**`
- `vendor/**`

If a request involves any of the above forbidden work/paths, stop and redirect to the appropriate specialist skill (e.g. `/programmer`, `/security-expert`, `/seo-expert`, etc.).

## Core Responsibilities

1. **Skill Auditing** - Quality checks on all skill files
2. **Cross-File Sync** - Keep agents, skills, and instruction files aligned
3. **Performance Optimization** - Reduce context token usage
4. **Ecosystem Maintenance** - Add/update/remove skills consistently
5. **Auto-Fix (Guidelines-Only)** - Automatically fix discovered issues **within the guidelines ecosystem** (skills/agents/instructions)
6. **PM Tracking Governance** - Keep PM work-log policy aligned across PM docs/skills/agents

---

## Consulting Other Skills

Consult other skills when auditing or optimizing.

- Prefer subagents when available (VS Code: runSubagent).
- Otherwise, execute the referenced steps directly.

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /work-optimisation-expert:
    Context: {skill being audited/optimized}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| Skill creation patterns | Use this skill and `.github/COPILOT_INSTRUCTIONS_GUIDE.md` |
| Project requirements | Read `AGENTS.md` |
| Testing skill workflows | `/e2e-testing` |
| Performance concerns | `/performance-expert` |

---

## Workflow 1: Full Skill Audit

Run this workflow when auditing the skill ecosystem or checking quality.

### Step 1: Discover All Skills

```bash
# List all skill directories
ls -la .agents/skills/
```

### Step 2: Audit Each Skill

For each skill, check using [skill-audit-checklist.md](references/skill-audit-checklist.md):

1. **YAML Frontmatter**
   - [ ] Has `name:` field matching directory name
   - [ ] Has `description:` field (comprehensive, includes triggers)
   - [ ] No extra fields except optional `license:`

2. **SKILL.md Body**
   - [ ] Under 500 lines (progressive disclosure)
   - [ ] References link to actual files
   - [ ] VS Code compatibility note if it uses subagent/delegation examples

3. **File Organization**
   - [ ] Only contains: SKILL.md, references/, scripts/, assets/
   - [ ] No README.md, CHANGELOG.md, or unnecessary docs
   - [ ] References properly linked from SKILL.md

### Step 3: Auto-Fix Issues

For each issue found, apply the fix from [auto-fix-procedures.md](references/auto-fix-procedures.md).

### Step 4: Generate Report

```markdown
## Skill Audit Report

**Date:** {date}
**Skills Audited:** {count}

### Issues Found and Fixed
| Skill | Issue | Fix Applied |
|-------|-------|-------------|
| ... | ... | ... |

### Remaining Issues (Manual Review Required)
- ...

### Recommendations
- ...
```

---

## Workflow 2: Cross-File Synchronization

Ensure GitHub Copilot instruction files are aligned (AGENTS.md, `.github/copilot-instructions.md`, custom agents).

### Step 1: Compare Skill Tables

1. Read `AGENTS.md` Quality Standards table
2. Read `.github/copilot-instructions.md` Skill Files Reference table
3. List actual skills in `.agents/skills/`

### Step 2: Check Alignment

| Check | Source | Target |
|-------|--------|--------|
| All skills in AGENTS.md | `.agents/skills/*/SKILL.md` | AGENTS.md table |
| All skills in copilot-instructions | `.agents/skills/*/SKILL.md` | copilot-instructions.md table |
| Copilot workflow triggers | Project needs | copilot-instructions.md triggers |
| VS Code notes in skills | Skills using subagent examples | SKILL.md VS Code notes |
| PM tracking policy | AGENTS + PM skill | Copilot docs + PM custom agent |

### Step 3: Auto-Fix Sync Issues

**Missing from AGENTS.md:**
```markdown
# Add to Quality Standards table (alphabetically sorted)
| {Skill Name} | `.agents/skills/{skill}/SKILL.md` | {Key points} |
```

**Missing from copilot-instructions.md:**
```markdown
# Add to Skill Files Reference table (alphabetically sorted)
| {Skill Name} | `.agents/skills/{skill}/SKILL.md` | {When to use} |
```

**Missing compatibility note:**
```markdown
# Add after YAML frontmatter in SKILL.md
> **VS Code Note**: This skill includes delegation/subagent examples. In VS Code, use subagents (runSubagent) and custom agents. If your Copilot surface does not support subagents, execute the steps directly.
```

### Step 4: Verify Copilot Workflow

Check `.github/copilot-instructions.md` has workflow triggers for:
- Creating new apps
- Fixing bugs
- Adding translations
- Running audits
- Creating tests
- **Auditing/optimizing skills** (this skill)

## Workflow 2b: PM Tracking Policy Validation

Use this workflow when PM tracking behavior changes.

### Step 1: Validate policy presence

Confirm these files contain aligned PM tracking rules:

- `AGENTS.md`
- `.agents/skills/project-manager/SKILL.md`
- `.github/copilot-instructions.md`
- `.github/agents/project-manager.agent.md`

### Step 2: Validate PM references

Confirm these PM references are present and aligned:

- `.agents/skills/project-manager/references/work-log-template.md`
- `.agents/skills/project-manager/references/project-template.md`
- `.agents/skills/project-manager/references/delegation-patterns.md`
- `.agents/skills/project-manager/references/quality-gates.md`

### Step 3: Validate specialist payload coverage

Check that PM-delegated specialist skills define a required PM payload:

- `Work Item ID`
- `Skill`
- `Status`
- `Progress Summary`
- `Blocker`
- `Next Owner`

---

## Workflow 3: Performance Optimization

Reduce context token usage across skills.

### Step 1: Analyze Token Footprint

For each skill:
1. Count lines in SKILL.md (target: <500)
2. Count total lines in references/ (note large files)
3. Identify duplicated content across skills

### Step 2: Apply Optimization Patterns

See [optimization-patterns.md](references/optimization-patterns.md) for:

**Context-Efficient Patterns:**
- Concise examples over verbose explanations
- Progressive disclosure (SKILL.md -> references/)
- Single source of truth (no duplication)
- Imperative/infinitive writing style

**Anti-Patterns to Fix:**
- Verbose introductions (trim or remove)
- Duplicated info across skills (consolidate)
- Over-explained concepts the model already knows
- Deeply nested references (flatten)

### Step 3: Auto-Fix Optimizations

1. Move verbose sections to reference files
2. Add table of contents to long references
3. Remove redundant explanations
4. Consolidate duplicated content

---

## Workflow 4: Add New Skill

When adding a new skill to the ecosystem.

### Step 1: Create the Skill

Follow the skill creation/update guidance in `.github/COPILOT_INSTRUCTIONS_GUIDE.md` (authoring patterns) and this skill's own workflows, and keep the new skill aligned with:
1. **AGENTS.md Quality Standards table**
2. **.github/copilot-instructions.md** (skills reference/workflow triggers)
   - Step 1: Understand with concrete examples
   - Step 2: Plan reusable contents (scripts, references, assets)
   - Step 3: Initialize using `init_skill.py`
   - Step 4: Edit SKILL.md and implement resources
   - Step 5: Package (optional, for distribution)
   - Step 6: Iterate based on real usage

### Step 2: Update Ecosystem Files

After creating or updating the skill:

1. **AGENTS.md** - Add to Quality Standards table (alphabetical)
2. **copilot-instructions.md** - Add to Skill Files Reference table (alphabetical)
3. **copilot-instructions.md** - Add workflow trigger if needed

### Step 3: Verify Integration

- [ ] Skill triggers correctly on relevant requests
- [ ] Tables are alphabetically sorted
- [ ] Cross-references work
- [ ] VS Code compatibility note added if skill uses subagent/delegation examples

---

## Workflow 5: Update Existing Skill

When modifying an existing skill.

### Step 1: Assess Change Scope

Determine the type of modification:

| Change Type | Action |
|-------------|--------|
| **Structural** (new resources, reorganization, new workflows) | Follow `COPILOT_INSTRUCTIONS_GUIDE.md` authoring patterns and this skill's audit workflow |
| **Content** (fixing errors, updating text, minor additions) | Apply changes following the principles below |

### Step 2: Apply Changes

**For structural changes** - Use the authoring guidance in `.github/COPILOT_INSTRUCTIONS_GUIDE.md` and the optimization patterns in this skill.
- Apply progressive disclosure: keep SKILL.md under 500 lines, move details to references/
- Use imperative writing style

**For content changes** - Apply directly with these principles:
- Challenge each line: "Does the agent need this?"
- Avoid over-explanation of concepts the model already knows
- Keep examples concise
- Maintain consistent formatting

### Step 3: Update Ecosystem If Needed

If skill name, description, or scope changed:
1. Update AGENTS.md table entry
2. Update copilot-instructions.md table entry
3. Update any workflow triggers

### Step 4: Run Audit

Run Workflow 1 on the updated skill to verify quality.

---

## Workflow 6: Remove Skill

When deprecating/removing a skill.

### Step 1: Remove Skill Directory

```bash
rm -rf .agents/skills/{skill-name}
```

### Step 2: Update Ecosystem Files

1. **AGENTS.md** - Remove from Quality Standards table
2. **copilot-instructions.md** - Remove from Skill Files Reference table
3. **copilot-instructions.md** - Remove workflow triggers
4. **Other skills** - Remove any cross-references

### Step 3: Verify Clean Removal

Search for any remaining references:
```bash
grep -r "{skill-name}" .agents/skills/ .github/
```

---

## Reference Files

- [skill-audit-checklist.md](references/skill-audit-checklist.md) - Detailed audit checklist
- [copilot-compatibility-guide.md](references/copilot-compatibility-guide.md) - Cross-tool requirements
- [optimization-patterns.md](references/optimization-patterns.md) - Performance patterns
- [auto-fix-procedures.md](references/auto-fix-procedures.md) - Auto-fix procedures

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /work-optimisation-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/work-optimisation-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
