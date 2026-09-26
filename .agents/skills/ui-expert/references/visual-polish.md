# Visual Polish Patterns

Animation, transition, and interaction patterns for AppDoesIt apps.

---

## Transition Timing

Use CSS variables for consistent timing:

| Variable | Duration | Use Case |
|----------|----------|----------|
| `--transition-fast` | 150ms | Hover effects, micro-interactions |
| `--transition-base` | 200ms | Standard transitions, focus states |
| `--transition-slow` | 300ms | Modal open/close, larger animations |

---

## Button States

### Required States

Every button needs these states:

```css
.{prefix}-btn {
    /* Base state */
    transition: background var(--transition-fast),
                transform var(--transition-fast),
                box-shadow var(--transition-fast);
}

.{prefix}-btn:hover {
    /* Slightly darker/lighter background */
}

.{prefix}-btn:focus-visible {
    outline: none;
    box-shadow: var(--focus-ring);
}

.{prefix}-btn:active {
    transform: scale(0.98);
}

.{prefix}-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}
```

### Primary Button Example

```css
.{prefix}-btn-primary {
    background: var(--color-primary);
    color: white;
    transition: background var(--transition-fast), transform var(--transition-fast);
}

.{prefix}-btn-primary:hover {
    background: var(--color-primary-dark);
}

.{prefix}-btn-primary:active {
    transform: scale(0.98);
}
```

---

## Input States

### Focus Transition

```css
.{prefix}-input {
    border: 1px solid var(--color-border);
    transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
}

.{prefix}-input:focus {
    border-color: var(--color-primary);
    box-shadow: var(--focus-ring);
}
```

### Error State

```css
.{prefix}-input.error,
.{prefix}-input:invalid {
    border-color: var(--color-error);
}

.{prefix}-input.error:focus {
    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.4);
}
```

---

## Toggle/Switch Animation

```css
.{prefix}-toggle-knob {
    transition: transform var(--transition-fast);
}

.{prefix}-toggle[aria-checked="true"] .{prefix}-toggle-knob {
    transform: translateX(24px);
}
```

---

## Modal/Panel Animations

### Fade + Scale Entry

```css
.{prefix}-modal {
    opacity: 0;
    transform: scale(0.95);
    transition: opacity var(--transition-base), transform var(--transition-base);
}

.{prefix}-modal.open {
    opacity: 1;
    transform: scale(1);
}
```

### Backdrop Fade

```css
.{prefix}-backdrop {
    opacity: 0;
    transition: opacity var(--transition-base);
}

.{prefix}-backdrop.visible {
    opacity: 1;
}
```

### Slide In (for drawers/panels)

```css
.{prefix}-drawer {
    transform: translateY(-100%);
    transition: transform var(--transition-slow);
}

.{prefix}-drawer.open {
    transform: translateY(0);
}
```

---

## Loading States

### Spinner

```css
.{prefix}-spinner {
    width: 20px;
    height: 20px;
    border: 2px solid var(--color-border);
    border-top-color: var(--color-primary);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}
```

### Button Loading State

```css
.{prefix}-btn.loading {
    position: relative;
    pointer-events: none;
}

.{prefix}-btn.loading::after {
    content: '';
    position: absolute;
    /* spinner styles */
}

.{prefix}-btn.loading .btn-text {
    opacity: 0;
}
```

---

## Feedback Animations

### Copy Success Flash

```css
.{prefix}-copy-feedback {
    opacity: 0;
    transform: translateY(4px);
    transition: opacity var(--transition-fast), transform var(--transition-fast);
}

.{prefix}-copy-feedback.show {
    opacity: 1;
    transform: translateY(0);
}
```

### Success Checkmark

```css
@keyframes checkmark {
    0% { stroke-dashoffset: 24; }
    100% { stroke-dashoffset: 0; }
}

.{prefix}-success-icon path {
    stroke-dasharray: 24;
    stroke-dashoffset: 24;
    animation: checkmark var(--transition-slow) ease forwards;
}
```

### Error Shake

```css
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-4px); }
    75% { transform: translateX(4px); }
}

.{prefix}-input.error {
    animation: shake 0.3s ease;
}
```

---

## Progress Indicators

### Progress Bar Fill

```css
.{prefix}-progress-fill {
    transition: width var(--transition-base);
}
```

### Strength Indicator

```css
.{prefix}-strength-fill {
    transition: width var(--transition-base), background var(--transition-base);
}
```

---

## Reduced Motion

Always respect user's motion preferences:

```css
@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}
```

---

## Checklist

### Button Polish

- [ ] Hover state changes background
- [ ] Focus state shows `--focus-ring`
- [ ] Active state has subtle scale
- [ ] Disabled state has reduced opacity
- [ ] Transitions are smooth

### Input Polish

- [ ] Focus transition on border and shadow
- [ ] Error state has red border
- [ ] Placeholder has muted color
- [ ] All transitions use CSS variables

### Modal Polish

- [ ] Backdrop fades in
- [ ] Content scales/fades in
- [ ] Close button has focus state
- [ ] Escape key closes modal

### Feedback Polish

- [ ] Success confirmation visible
- [ ] Error messages clear
- [ ] Copy feedback shows temporarily
- [ ] Loading states present
