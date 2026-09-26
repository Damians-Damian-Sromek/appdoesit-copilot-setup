# Component Patterns

Expected styling patterns for AppDoesIt app components. All apps should follow these patterns for consistency.

---

## App Page Layout

Every app uses this base layout structure:

```css
.app-page {
    padding: var(--space-4);
    padding-top: calc(var(--header-height) + var(--space-4));
    min-height: calc(100vh - var(--header-height));
    display: flex;
    flex-direction: column;
    align-items: center;
}

.app-container {
    width: 100%;
    max-width: 400px - 900px;  /* varies by app complexity */
    margin: 0 auto;            /* CRITICAL: must be centered */
}

.app-header {
    text-align: center;
    margin-bottom: var(--space-6);
}

.app-header h1 {
    font-size: var(--font-size-2xl);
    margin-bottom: var(--space-2);
}

.app-description {
    color: var(--color-text-muted);
    font-size: var(--font-size-sm);
    margin-bottom: 0;
}
```

**CRITICAL:** App container MUST have `margin: 0 auto` for centering.

---

## Main App Card

The main app interface should be in a card:

```css
.{prefix}-{app-name} {
    background: var(--color-bg-card);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-lg);
}
```

Example: `.calculator`, `.password-generator`, `.bmi-calculator`

---

## Buttons

### Primary Button

```css
.{prefix}-btn-primary {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--space-2);
    padding: var(--space-3) var(--space-6);
    background: var(--color-primary);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    font-weight: 500;
    font-size: var(--font-size-base);
    cursor: pointer;
    transition: background var(--transition-fast);
    min-height: 44px;  /* touch target */
}

.{prefix}-btn-primary:hover {
    background: var(--color-primary-dark);
}

.{prefix}-btn-primary:focus-visible {
    outline: none;
    box-shadow: var(--focus-ring);
}

.{prefix}-btn-primary:active {
    transform: scale(0.98);
}
```

### Secondary Button

```css
.{prefix}-btn-secondary {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--space-2);
    padding: var(--space-3) var(--space-6);
    background: var(--color-bg-alt);
    color: var(--color-text);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    font-weight: 500;
    cursor: pointer;
    transition: background var(--transition-fast), border-color var(--transition-fast);
    min-height: 44px;
}

.{prefix}-btn-secondary:hover {
    background: var(--color-bg);
    border-color: var(--color-border-dark);
}

.{prefix}-btn-secondary:focus-visible {
    outline: none;
    box-shadow: var(--focus-ring);
}
```

### Icon Button

```css
.{prefix}-btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    padding: 0;
    background: var(--color-bg-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    color: var(--color-text);
    cursor: pointer;
    transition: background var(--transition-fast);
}

.{prefix}-btn-icon:hover {
    background: var(--color-bg);
}

.{prefix}-btn-icon:focus-visible {
    outline: none;
    box-shadow: var(--focus-ring);
}

.{prefix}-btn-icon svg {
    width: 20px;
    height: 20px;
}
```

---

## Form Inputs

### Text Input

```css
.{prefix}-input {
    width: 100%;
    padding: var(--space-3) var(--space-4);
    background: var(--color-bg-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    font-size: var(--font-size-base);
    color: var(--color-text);
    transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
}

.{prefix}-input:focus {
    outline: none;
    border-color: var(--color-primary);
    box-shadow: var(--focus-ring);
}

.{prefix}-input::placeholder {
    color: var(--color-text-muted);
}
```

### Select Dropdown

```css
.{prefix}-select {
    width: 100%;
    padding: var(--space-3) var(--space-4);
    padding-right: var(--space-10);  /* space for arrow */
    background: var(--color-bg-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    font-size: var(--font-size-base);
    color: var(--color-text);
    cursor: pointer;
    appearance: none;
    background-image: url("data:image/svg+xml,...");  /* dropdown arrow */
    background-repeat: no-repeat;
    background-position: right var(--space-3) center;
}

.{prefix}-select:focus {
    outline: none;
    border-color: var(--color-primary);
    box-shadow: var(--focus-ring);
}
```

### Toggle/Switch

```css
.{prefix}-toggle {
    position: relative;
    width: 48px;
    height: 24px;
    background: var(--color-bg-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-full);
    cursor: pointer;
    transition: background var(--transition-fast);
}

.{prefix}-toggle[aria-checked="true"] {
    background: var(--color-primary);
    border-color: var(--color-primary);
}

.{prefix}-toggle-knob {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 18px;
    height: 18px;
    background: white;
    border-radius: var(--radius-full);
    box-shadow: var(--shadow-sm);
    transition: transform var(--transition-fast);
}

.{prefix}-toggle[aria-checked="true"] .{prefix}-toggle-knob {
    transform: translateX(24px);
}
```

---

## Display/Output Areas

For showing results or generated content:

```css
.{prefix}-display {
    padding: var(--space-4);
    background: var(--color-bg-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    font-family: var(--font-mono);
    font-size: var(--font-size-lg);
    word-break: break-all;
    user-select: all;
}
```

---

## Help Panel (Modal)

All apps use the same help panel structure:

```css
.{prefix}-help-panel {
    position: fixed;
    inset: 0;
    z-index: 1000;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: var(--space-4);
}

.{prefix}-help-backdrop {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
}

.{prefix}-help-content {
    position: relative;
    width: 100%;
    max-width: 600px;
    max-height: 80vh;
    background: var(--color-bg-card);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-xl);
    overflow-y: auto;
}

.{prefix}-help-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: var(--space-4) var(--space-6);
    border-bottom: 1px solid var(--color-border);
}

.{prefix}-help-title {
    font-size: var(--font-size-xl);
    font-weight: 600;
    margin: 0;
}

.{prefix}-help-close {
    /* Use icon button pattern */
}

.{prefix}-help-body {
    padding: var(--space-6);
}

/* Help panel hidden state */
.{prefix}-help-panel[hidden] {
    display: none;
}
```

---

## Section Headers

For use cases, features, and other sections:

```css
.{prefix}-section {
    margin-top: var(--space-12);
    padding-top: var(--space-8);
    border-top: 1px solid var(--color-border);
}

.{prefix}-section-title {
    font-size: var(--font-size-xl);
    font-weight: 600;
    margin-bottom: var(--space-6);
    color: var(--color-text);
}
```

---

## Progress/Strength Indicators

```css
.{prefix}-progress-bar {
    height: 8px;
    background: var(--color-bg-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-full);
    overflow: hidden;
}

.{prefix}-progress-fill {
    height: 100%;
    border-radius: var(--radius-full);
    transition: width var(--transition-base), background var(--transition-base);
}
```

---

## Responsive Patterns

### Mobile Breakpoint (max-width: 480px)

```css
@media (max-width: 480px) {
    .app-container {
        padding: var(--space-3);
    }

    .app-header h1 {
        font-size: var(--font-size-xl);
    }

    .{prefix}-btn-primary,
    .{prefix}-btn-secondary {
        width: 100%;
    }
}
```

### Tablet Breakpoint (max-width: 768px)

```css
@media (max-width: 768px) {
    .app-page {
        padding: var(--space-3);
    }
}
```

---

## Verification Checklist

For each component type, verify:

- [ ] Uses CSS variables (no hard-coded values)
- [ ] Has hover state
- [ ] Has focus-visible state with `--focus-ring`
- [ ] Has active state (for buttons)
- [ ] Uses `--transition-*` for animations
- [ ] Touch targets are 44x44px minimum
- [ ] Colors adapt to dark mode (using CSS variables)
