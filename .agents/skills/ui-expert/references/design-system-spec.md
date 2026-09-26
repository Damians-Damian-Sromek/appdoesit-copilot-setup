# AppDoesIt Design System Specification

Source: `public/assets/css/main.css`

---

## Colors

### Primary Brand Colors

| Variable | Light Mode | Dark Mode | Usage |
|----------|------------|-----------|-------|
| `--color-primary` | `#4f46e5` | same | Primary brand color (indigo) |
| `--color-primary-dark` | `#4338ca` | same | Hover states |
| `--color-primary-light` | `#6366f1` | same | Subtle accents |

### Background Colors

| Variable | Light Mode | Dark Mode | Usage |
|----------|------------|-----------|-------|
| `--color-bg` | `#ffffff` | `#0f172a` | Main page background |
| `--color-bg-alt` | `#f8fafc` | `#1e293b` | Alternate/section background |
| `--color-bg-card` | `#ffffff` | `#1e293b` | Card backgrounds |

### Text Colors

| Variable | Light Mode | Dark Mode | Usage |
|----------|------------|-----------|-------|
| `--color-text` | `#1e293b` | `#f1f5f9` | Primary text |
| `--color-text-muted` | `#64748b` | `#94a3b8` | Secondary/muted text |
| `--color-text-light` | `#64748b` | `#94a3b8` | Light text |

### Border Colors

| Variable | Light Mode | Dark Mode | Usage |
|----------|------------|-----------|-------|
| `--color-border` | `#e2e8f0` | `#334155` | Default borders |
| `--color-border-dark` | `#cbd5e1` | `#475569` | Darker borders |

### Status Colors

| Variable | Light Mode | Dark Mode | Usage |
|----------|------------|-----------|-------|
| `--color-success` | `#10b981` | same | Success backgrounds |
| `--color-success-text` | `#047857` | `#34d399` | Success text (WCAG AA) |
| `--color-error` | `#ef4444` | same | Error backgrounds |
| `--color-error-text` | `#dc2626` | `#f87171` | Error text (WCAG AA) |
| `--color-warning` | `#f59e0b` | same | Warning backgrounds |
| `--color-warning-text` | `#b45309` | `#fbbf24` | Warning text (WCAG AA) |

---

## Typography

### Font Stacks

| Variable | Value | Usage |
|----------|-------|-------|
| `--font-sans` | `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif` | Body text, UI |
| `--font-mono` | `'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace` | Code, numbers |

### Font Sizes

| Variable | Value | Pixels | Usage |
|----------|-------|--------|-------|
| `--font-size-xs` | `0.75rem` | 12px | Captions, labels |
| `--font-size-sm` | `0.875rem` | 14px | Small text |
| `--font-size-base` | `1rem` | 16px | Body text |
| `--font-size-lg` | `1.125rem` | 18px | Large body |
| `--font-size-xl` | `1.25rem` | 20px | Small headings |
| `--font-size-2xl` | `1.5rem` | 24px | Section headings |
| `--font-size-3xl` | `2rem` | 32px | Page headings |
| `--font-size-4xl` | `2.5rem` | 40px | Hero headings |

### Line Heights

| Variable | Value | Usage |
|----------|-------|-------|
| `--line-height-tight` | `1.25` | Headings |
| `--line-height-normal` | `1.5` | Body text |
| `--line-height-relaxed` | `1.75` | Long-form content |

---

## Spacing Scale

| Variable | Value | Pixels | Usage |
|----------|-------|--------|-------|
| `--space-1` | `0.25rem` | 4px | Minimal spacing |
| `--space-2` | `0.5rem` | 8px | Tight spacing |
| `--space-3` | `0.75rem` | 12px | Small spacing |
| `--space-4` | `1rem` | 16px | Default spacing |
| `--space-5` | `1.25rem` | 20px | Medium spacing |
| `--space-6` | `1.5rem` | 24px | Generous spacing |
| `--space-8` | `2rem` | 32px | Large spacing |
| `--space-10` | `2.5rem` | 40px | Section spacing |
| `--space-12` | `3rem` | 48px | Large sections |
| `--space-16` | `4rem` | 64px | Major sections |
| `--space-20` | `5rem` | 80px | Hero spacing |

---

## Layout

| Variable | Value | Usage |
|----------|-------|-------|
| `--container-max` | `1200px` | Main container max-width |
| `--container-narrow` | `720px` | Narrow content areas |
| `--header-height` | `64px` | Fixed header height |
| `--favorites-bar-height` | `44px` | Favorites bar height |

### App Container Widths

| App Complexity | Recommended Width |
|----------------|-------------------|
| Simple (calculator) | `400px - 500px` |
| Medium (password generator) | `500px - 600px` |
| Complex (BMI with charts) | `700px - 900px` |

---

## Border Radius

| Variable | Value | Usage |
|----------|-------|-------|
| `--radius-sm` | `4px` | Small elements (chips, badges) |
| `--radius-md` | `8px` | Buttons, inputs, cards |
| `--radius-lg` | `12px` | Large cards, modals |
| `--radius-full` | `9999px` | Pills, circular elements |

---

## Shadows

| Variable | Value | Usage |
|----------|-------|-------|
| `--shadow-sm` | `0 1px 2px 0 rgb(0 0 0 / 0.05)` | Subtle elevation |
| `--shadow-md` | `0 4px 6px -1px rgb(0 0 0 / 0.1), ...` | Cards, dropdowns |
| `--shadow-lg` | `0 10px 15px -3px rgb(0 0 0 / 0.1), ...` | Modals, popovers |
| `--shadow-xl` | `0 20px 25px -5px rgb(0 0 0 / 0.1), ...` | Dialogs, overlays |

---

## Transitions

| Variable | Value | Usage |
|----------|-------|-------|
| `--transition-fast` | `150ms ease` | Micro-interactions (hover) |
| `--transition-base` | `200ms ease` | Standard transitions |
| `--transition-slow` | `300ms ease` | Larger animations |

---

## Focus States

| Variable | Value | Usage |
|----------|-------|-------|
| `--focus-ring` | `0 0 0 3px rgba(79, 70, 229, 0.4)` | Focus outline for all interactive elements |

---

## Theme Detection

```css
/* Light mode (default) */
:root { ... }

/* Explicit dark mode */
:root[data-theme="dark"] { ... }

/* System preference fallback */
@media (prefers-color-scheme: dark) {
    :root:not([data-theme]) { ... }
}
```

---

## Common Mistakes

| Wrong | Correct |
|-------|---------|
| `padding: 16px` | `padding: var(--space-4)` |
| `color: #64748b` | `color: var(--color-text-muted)` |
| `background: #f8fafc` | `background: var(--color-bg-alt)` |
| `border-radius: 8px` | `border-radius: var(--radius-md)` |
| `box-shadow: 0 4px 6px...` | `box-shadow: var(--shadow-md)` |
| `transition: 0.2s` | `transition: background var(--transition-base)` |
| `font-size: 14px` | `font-size: var(--font-size-sm)` |
