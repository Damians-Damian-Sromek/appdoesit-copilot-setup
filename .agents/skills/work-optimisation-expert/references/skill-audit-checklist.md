# Skill Audit Checklist

Comprehensive checklist for auditing skill quality.

## 1. YAML Frontmatter

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| `name:` field exists | Required | Add from directory name |
| `name:` matches directory | Must match exactly | Rename to match |
| `description:` exists | Required | Flag for manual writing |
| `description:` comprehensive | Include what + when to use | Flag for review |
| `description:` includes triggers | Trigger phrases for invocation | Flag for review |
| No extra fields | Only name, description, license | Remove extra fields |

## 2. SKILL.md Structure

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| Under 500 lines | Progressive disclosure | Move content to references/ |
| Copilot note present | Required if uses Task tool | Add standard note |
| References link to files | All refs must exist | Remove broken links |
| No duplicate headings | Each heading unique | Rename duplicates |
| Imperative writing style | Use "Do X" not "You should do X" | Rewrite |

## 3. File Organization

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| Only allowed dirs | SKILL.md, references/, scripts/, assets/ | Remove extras |
| No README.md | Not needed for skills | Delete |
| No CHANGELOG.md | Not needed for skills | Delete |
| No INSTALLATION.md | Not needed for skills | Delete |
| References linked | All reference files linked from SKILL.md | Add links |

## 4. Content Quality

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| No verbose intros | Get to the point | Trim |
| Examples over explanations | Show, don't tell | Refactor |
| No duplicated content | Single source of truth | Consolidate |
| No model-obvious info | Don't explain what the model already knows | Remove |

## 5. Cross-Tool Compatibility

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| In AGENTS.md table | Quality Standards table | Add entry |
| In copilot-instructions.md | Skill Files Reference table | Add entry |
| Workflow triggers | If applicable | Add trigger |

## 6. PM Tracking Policy Alignment

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| PM work-log policy in AGENTS.md | `docs/work_logs` required for every PM task | Add/update policy section |
| PM skill matches policy | `.agents/skills/project-manager/SKILL.md` enforces work logs + generic PROJECT.md | Update PM skill instructions |
| Copilot PM docs match policy | `.github/copilot-instructions.md` + `.github/agents/project-manager.agent.md` aligned | Update both files |
| PM references include template | `work-log-template.md` exists and is linked | Add template and references |
| Specialist payload contract present | PM-delegated skills include PM Status Payload in output | Add standard payload block |

## 7. Scripts (if present)

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| Executable | Has shebang, correct permissions | Add shebang |
| Error handling | Handles failures gracefully | Flag for review |
| Documented usage | Usage comment in script | Add usage |

## 8. Temporal File Safety

| Check | Requirement | Auto-Fix |
|-------|-------------|----------|
| Uses var/tmp/ | All temporal files in `var/tmp/` | Update output paths |
| Creates subdirectory | Uses `mkdir -p var/tmp/{skill}/` | Add mkdir command |
| Documents output path | SKILL.md mentions output location | Add documentation |

## Severity Levels

- **CRITICAL**: Skill will not function (missing frontmatter, broken refs)
- **WARNING**: Skill works but has issues (verbose, missing from tables)
- **RECOMMENDATION**: Improvements possible (optimization opportunities)

## Audit Report Template

```markdown
## Skill: {skill-name}

### CRITICAL Issues
- [ ] {issue} -> {fix applied/needed}

### WARNING Issues
- [ ] {issue} -> {fix applied/needed}

### RECOMMENDATIONS
- {suggestion}

### Status: {PASS/FAIL}
```
