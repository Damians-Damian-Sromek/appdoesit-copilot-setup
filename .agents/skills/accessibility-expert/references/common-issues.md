# Common Accessibility Issues & Fixes

Quick reference for fixing common accessibility issues found in AppDoesIt apps.

## Dynamic Content Not Announced

**Issue:** Screen readers don't announce results/changes

**Fix:** Use aria-live regions
```html
<div id="result" aria-live="polite" aria-atomic="true">
    <!-- Results appear here and will be announced -->
</div>
```

## Color Contrast

**Issue:** Text doesn't meet 4.5:1 contrast ratio

**Fix:** Use CSS custom properties for colors
```css
/* Use theme-aware colors */
color: var(--text-primary);
background: var(--bg-primary);
```

## Missing Labels

**Issue:** Form inputs without associated labels

**Fix:** Add `<label for="id">` or `aria-label`
```html
<label for="input-field">Label Text</label>
<input id="input-field" type="text">
<!-- or -->
<input aria-label="Description" type="text">
```

## Focus Indicators

**Issue:** No visible focus state

**Fix:** Add :focus-visible styles
```css
button:focus-visible {
    outline: 2px solid var(--focus-ring);
    outline-offset: 2px;
}
```

## Results Not Keyboard Accessible

**Issue:** Can't navigate to results with keyboard

**Fix:** Ensure results are in tab order or use live regions
```html
<!-- Option 1: Focusable result -->
<div id="result" tabindex="0" role="region" aria-label="Calculation result">
    10
</div>

<!-- Option 2: Live region (preferred for dynamic updates) -->
<div id="result" aria-live="polite">
    10
</div>
```

## Skip Links

**Issue:** No skip navigation link

**Fix:** Add skip link at page top
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

## Heading Hierarchy

**Issue:** Skipped heading levels (h1 to h3)

**Fix:** Use sequential heading levels
```html
<h1>Page Title</h1>
<h2>Section</h2>
<h3>Subsection</h3>
```

## Icon-Only Buttons

**Issue:** Button has no accessible name

**Fix:** Add aria-label
```html
<button aria-label="Close dialog">
    <svg>...</svg>
</button>
```

## Error Messages

**Issue:** Error not associated with input

**Fix:** Use aria-describedby
```html
<input id="email" aria-describedby="email-error" aria-invalid="true">
<span id="email-error" role="alert">Please enter a valid email</span>
```

## Custom Widgets

**Issue:** Custom widget not accessible

**Fix:** Add appropriate ARIA roles and states
```html
<div role="slider"
     aria-valuenow="50"
     aria-valuemin="0"
     aria-valuemax="100"
     tabindex="0">
</div>
```

## Modal Focus Management

**Issue:** Focus doesn't move to modal / escapes modal

**Fix:** Trap focus and manage properly
```javascript
// On open: move focus to first focusable element
// On close: return focus to trigger element
// While open: trap Tab within modal
```

## Touch Target Size

**Issue:** Touch targets too small

**Fix:** Ensure minimum 44x44px
```css
button {
    min-width: 44px;
    min-height: 44px;
}
```
