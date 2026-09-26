# Copilot Compatibility Guide

Requirements for ensuring skills work well with GitHub Copilot (VS Code, GitHub.com, Copilot CLI).

## Supported Surfaces

This repo is customized for GitHub Copilot only. Supported surfaces:

| Feature | GitHub Copilot |
|---------|----------------|
| Sub-agents | VS Code: supported via subagents (`runSubagent`) and custom agents; other Copilot surfaces may vary |
| Skill invocation | Repo-local skills in `.agents/skills/`, guided by `.github/copilot-instructions.md` |
| Skill discovery | `.agents/skills/` and/or Copilot agent UI (setup dependent) |
| Parallel execution | Limited; often sequential |
| Reference loading | On-demand |

## Skill File Format

```markdown
---
name: skill-name
description: When to use this skill (triggers auto-discovery)
---

# Skill Title

Instructions here...
```

**Key points:**
- `name`: Lowercase with hyphens (max 64 chars)
- `description`: Comprehensive trigger conditions (max 1,024 chars)
- Body: Detailed instructions, loaded when skill is relevant

## Required Files Alignment

These files must stay synchronized:

| File | Purpose | Update When |
|------|---------|-------------|
| `AGENTS.md` | Quality Standards table | Skill added/removed/renamed |
| `.github/copilot-instructions.md` | Skill Files Reference table | Skill added/removed/renamed |
| `.github/copilot-instructions.md` | Workflow triggers | New workflow patterns |
| `.agents/skills/project-manager/SKILL.md` + `.github/agents/project-manager.agent.md` | PM tracking policy | PM workflow behavior changes |

## AGENTS.md Table Format

```markdown
| Requirement Area | Skill File | Key Points |
|-----------------|------------|------------|
| {Area Name} | `.agents/skills/{skill}/SKILL.md` | {Brief key points} |
```

Sort alphabetically by Requirement Area.

## copilot-instructions.md Table Format

```markdown
| Skill | File Path | When to Use |
|-------|-----------|-------------|
| {Skill Name} | `.agents/skills/{skill}/SKILL.md` | {Trigger conditions} |
```

Sort alphabetically by Skill name.

## Sync Checklist

Run this checklist when adding/updating skills:

- [ ] AGENTS.md table includes skill
- [ ] copilot-instructions.md table includes skill
- [ ] Workflow triggers updated if needed
- [ ] Tables remain alphabetically sorted
- [ ] Skill description is comprehensive enough for auto-discovery
- [ ] PM tracking policy is consistent across AGENTS, PM skill, Copilot instructions, and PM custom agent
- [ ] Specialist skills include PM Status Payload contract when PM delegation is expected

## Common Sync Issues

### Missing from AGENTS.md

**Symptom:** Skill exists but not in Quality Standards table.

**Fix:**
```markdown
# Add to table (maintain alphabetical order)
| {Area} | `.agents/skills/{skill}/SKILL.md` | {Points} |
```

### Missing from copilot-instructions.md

**Symptom:** Skill exists but not in Skill Files Reference table.

**Fix:**
```markdown
# Add to table (maintain alphabetical order)
| {Name} | `.agents/skills/{skill}/SKILL.md` | {When to use} |
```

### Stale Workflow Triggers

**Symptom:** copilot-instructions.md workflow doesn't match current skill capabilities.

**Fix:** Update workflow trigger to match skill workflows.

## Testing Compatibility

1. **VS Code:** Invoke the skill naturally in Copilot Chat; verify the workflow is followable and references resolve
2. **Other Copilot surfaces:** Ensure `.github/copilot-instructions.md` references skills and the workflow remains followable
