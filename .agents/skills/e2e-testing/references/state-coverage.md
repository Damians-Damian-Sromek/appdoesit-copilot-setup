# UI State Coverage (Dynamic Text & Message States)

**Source of Truth: [AGENTS.md](../../../AGENTS.md), [docs/ui/UI-GUIDELINES.md](../../../docs/ui/UI-GUIDELINES.md) → "Dynamic Text & Message States (i18n-Safe Layout)"**

Automated UI quality checks must verify **all possible UI states and messages**, not only the default render. If a label normally shows "Done" but can become "Unavailable", the check must confirm the longer variant still displays correctly (no clipping, no overflow, no wrap-breakage) in all 3 supported locales (`en`, `es`, `pl`).

## What Is a "UI State"

Any user-visible text or layout condition that changes at runtime:

- **Status / feedback messages** — idle → running → done/error ("Done", "Unavailable", "Processing large file…")
- **Button/label variants** — default vs disabled, "Copy" vs "Copied!" vs "Copy failed"
- **Validation/error messages** — success vs each distinct error string
- **Result content** — empty state, short result, long result, extreme values (very long filenames/inputs where applicable)
- **Locale variants** — the same message in `en`, `es`, `pl` (pl/es are commonly 20-40% longer)

## Coverage Rule (per app)

For each element whose text is **not constant**, the E2E suite must include at least one test that renders the **longest realistic variant** and asserts the element is fully visible. The default-state test is not sufficient.

### How to enumerate states

1. Scan the app source (`apps/{slug}/index.php` + JS) for every `textContent`/`innerHTML` write and every i18n key resolved into UI text.
2. List the distinct values each spot can take (all branches: success, error, disabled, empty, extreme).
3. Pick the **longest** variant per spot per locale. This becomes the test data.

### Assertion pattern (no clipping / no overflow)

For each dynamic element, after triggering the longest variant:

```javascript
// element = page.locator('#chrono-status'); // example
const overflow = await element.evaluate((el) => {
    const cs = getComputedStyle(el);
    const clipped = el.scrollWidth > el.clientWidth + 1 ||
        el.scrollHeight > el.clientHeight + 1;
    const ellipsis = cs.textOverflow === 'ellipsis' &&
        el.scrollWidth > el.clientWidth + 1;
    return { clipped, ellipsis, visible: el.offsetParent !== null };
});
expect(overflow.clipped, 'status text clipped').toBe(false);
expect(overflow.ellipsis, 'semantic text ellipsized').toBe(false);
```

Additional checks:
- The element is visible (`toBeVisible()`) and not `display: none` in that state.
- No horizontal scroll appears at the document level:
  `expect(await page.evaluate(() => document.documentElement.scrollWidth <= document.documentElement.clientWidth)).toBe(true)`.
- The element does not push sibling content off-screen (check the container's bounds are unchanged in width).

### Where to put it

- Prefer extending the **existing per-app spec** (`tests/e2e/{slug}.spec.js`) with a
  `test.describe('UI states')` block, so it runs in the normal <10 min suite.
- Keep it lean: one assertion set per *dynamic* element, not per message. If an app has many messages, group them and assert the longest one per element.
- Only capture a screenshot for a dynamic state when debugging a failure or when
  explicit visual review is requested (per skill policy); store under `var/tmp/qa/`.

## Minimal Example

```javascript
test.describe('Chronometer - UI states', () => {
    test('status label fits its longest message in every locale', async ({ page }) => {
        for (const route of [ROUTES.en, ROUTES.es, ROUTES.pl]) {
            await openChronometer(page, route);
            // Trigger the longest status variant the app can show
            await page.locator('#chrono-start').click();   // "En marcha" / "Uruchomiony" / "Running"
            const status = page.locator('#chrono-status');
            await expect(status).toBeVisible();
            const overflow = await status.evaluate(el => ({
                clipped: el.scrollWidth > el.clientWidth + 1
            }));
            expect(overflow.clipped, `status clipped at ${route}`).toBe(false);
            await page.locator('#chrono-start').click();   // stop, back to idle
        }
    });
});
```

## Checklist per app

- [ ] All dynamic text spots identified from source
- [ ] Longest variant per spot per locale known
- [ ] Test renders the longest variant (not just default)
- [ ] No-clipping assertion added for each dynamic element
- [ ] Document-level horizontal scroll check added
- [ ] Runs in the normal suite (no separate slow job)

## Relation to other skills

- `/programmer` implements fixes when a state clips.
- `/qa-expert` uses the same state list for screenshot review (see its "UI States to Capture").
- `/ui-expert` owns the CSS rules that make states fit (UI-GUIDELINES.md).
