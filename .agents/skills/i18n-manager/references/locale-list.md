# Supported Locales

Complete reference for the 3 supported locales in AppDoesIt.

## Locale Details

| Code | Language | Native Name | Direction | Notes |
|------|----------|-------------|-----------|-------|
| en | English | English | LTR | Base locale; create and review first |
| es | Spanish | Español | LTR | Verify natural phrasing, accents, and punctuation |
| pl | Polish | Polski | LTR | Verify diacritics and allow for text expansion |

## Translation File Paths

Canonical translation source files live under `i18n/`:

```
i18n/apps/{slug}/
  _meta.json
  en.json
  es.json
  pl.json

i18n/pages/{slug}/
  _meta.json
  en.json
  es.json
  pl.json

i18n/common/
  _meta.json
  en.json
  es.json
  pl.json
```

Generated runtime bundles are output to `public/assets/i18n/` and should only be inspected as a targeted last-resort verification step.

```
public/assets/i18n/
  en.json
  es.json
  pl.json
```

## Locale-Specific Checks

### Spanish (`es`)

- Verify accents and punctuation display correctly
- Prefer natural, neutral phrasing over literal translation
- Check longer UI labels still fit common button and tab widths

### Polish (`pl`)

- Verify diacritics render correctly (`ą ć ę ł ń ó ś ź ż`)
- Expect some labels to be longer than English equivalents
- Check wrapping and truncation in buttons, menus, and cards

## Cross-Locale Quality Checks

- Keep key parity across `en.json`, `es.json`, and `pl.json`
- Ensure non-English values are translated, not copied from English
- Verify localized app titles still sort correctly per locale
- Rebuild with `npm run i18n:build` after source-file edits
