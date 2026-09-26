# Documentation Verification Guide

**Source of Truth: [AGENTS.md](../../../AGENTS.md)**

This guide verifies app documentation is complete, accurate, and matches implementation per AGENTS.md requirements.

---

## AGENTS.md Sections to Reference

Before verification, read these sections in AGENTS.md:
- `### App Help/Instructions (MANDATORY)` - Help content requirements
- `### App Page Requirements (MANDATORY)` - Use cases requirements
- `### Translation Test Maintenance (MANDATORY)` - Translation key requirements

---

## All 3 Supported Locales Must Be Verified

**From AGENTS.md: The project supports 3 locales.**

```
en, es, pl
```

**DO NOT sample. Verify all 3 supported locales.**

---

## Required Translation Keys (from AGENTS.md)

Per AGENTS.md `### Translation Test Maintenance (MANDATORY)`, every app needs, in all 3 locales:

- **Core metadata:** `title`, `description`, `seoTitle`, `seoDescription`
- **Help:** `helpTitle`, `openHelp`, `closeHelp`
- **Skip link:** `skipTo{AppNamePascalCase}`
- **Use cases:** `useCasesTitle`, `useCasesIntro`, `useCase1Title/Desc` … `useCase5Title/Desc`

Canonical full key list with examples: `.agents/skills/i18n-manager/references/translation-keys.md` (single source of truth — do not duplicate it here).

---

## Locale Verification Table (All 3 Supported Locales)

| Locale | File Exists | App Section | All Keys | Not Empty | Translated |
|--------|-------------|-------------|----------|-----------|------------|
| en | [ ] | [ ] | [ ] | [ ] | N/A |
| es | [ ] | [ ] | [ ] | [ ] | [ ] |
| pl | [ ] | [ ] | [ ] | [ ] | [ ] |

---

## Verification Commands

### Check all 3 supported locale files

```bash
# Check all locales for app section
for locale in en es pl; do
    echo "=== $locale ==="
  jq 'keys' "i18n/apps/{slug}/$locale.json" 2>/dev/null || echo "MISSING"
done
```

### Compare English vs non-English

```bash
# Titles should differ
diff <(jq '.title' i18n/apps/{slug}/en.json) \
  <(jq '.title' i18n/apps/{slug}/es.json)
```

### Run PHPUnit translation tests

```bash
# CRITICAL: per AGENTS.md, only run automated tests after security review is complete.
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```

---

## Implementation vs Documentation Validation

Per AGENTS.md, documentation must match implementation:

### Help Section (from `### App Help/Instructions (MANDATORY)`)

For each help step documented:
- [ ] Feature exists in UI
- [ ] Feature works as described
- [ ] Keyboard shortcuts work (if documented)

### Use Cases (from `### App Page Requirements (MANDATORY)`)

- [ ] 5 use cases present
- [ ] Each is relevant and accurate
- [ ] All translated

---

## Updating This Guide

When AGENTS.md changes:

1. Check for new requirements:
   ```bash
   grep -n "MANDATORY" AGENTS.md
   grep -n "translation" AGENTS.md
   ```

2. Update required keys list if changed

3. Update verification commands if needed
