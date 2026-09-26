# UX Checklist for AppDoesIt Apps

Comprehensive UX requirements checklist specific to the AppDoesIt platform.

## Layout & Structure

### Page Structure
- [ ] Header with navigation and theme toggle
- [ ] Main app area (centered, constrained width)
- [ ] Use cases section below app
- [ ] FAQ section below use cases
- [ ] Standard footer

### App Container
- [ ] Max-width appropriate for app type (typically 900px)
- [ ] Centered horizontally
- [ ] Adequate padding on all sides
- [ ] Consistent with other AppDoesIt apps

### Content Hierarchy
- [ ] Clear visual hierarchy
- [ ] Primary action most prominent
- [ ] Secondary actions less prominent
- [ ] Labels clearly associated with inputs

---

## Responsive Design (Mobile-First)

### Breakpoints
```css
/* Mobile first approach */
/* Base styles: 320px+ */
/* Tablet: 768px+ */
/* Desktop: 1024px+ */
```

### Mobile Requirements (<768px)
- [ ] Single column layout
- [ ] Full-width inputs
- [ ] Stacked elements (not side-by-side)
- [ ] Touch targets minimum 44x44px
- [ ] No horizontal scrolling
- [ ] Adequate spacing between tap targets (8px min)

### Tablet Requirements (768px-1024px)
- [ ] May introduce 2-column where beneficial
- [ ] Touch-friendly still prioritized
- [ ] Readable without zooming

### Desktop Requirements (>1024px)
- [ ] Multi-column layouts where appropriate
- [ ] Keyboard shortcuts prominently displayed
- [ ] Hover states for interactive elements
- [ ] Max-width prevents overly wide layouts

---

## Accessibility (WCAG 2.1 AA)

### Perceivable

**Text & Color**
- [ ] Text minimum 16px base size
- [ ] Color contrast 4.5:1 for normal text
- [ ] Color contrast 3:1 for large text (24px+ or 18.5px+ bold)
- [ ] Information not conveyed by color alone
- [ ] Links distinguishable from regular text

**Images & Media**
- [ ] Alt text for meaningful images
- [ ] Decorative images marked `aria-hidden`
- [ ] No auto-playing media
- [ ] Captions for video content

### Operable

**Keyboard Navigation**
- [ ] All interactive elements reachable via Tab
- [ ] Logical tab order (top-to-bottom, left-to-right)
- [ ] Focus indicator visible (2px minimum, contrasting)
- [ ] No keyboard traps
- [ ] Skip link to main content

**Keyboard Shortcuts**
- [ ] Standard shortcuts work (Ctrl+C, Ctrl+V)
- [ ] Custom shortcuts don't conflict with browser/AT
- [ ] Shortcuts documented in help modal

**Focus Management**
- [ ] Focus moves logically
- [ ] Modal focus trapped within modal
- [ ] Focus returns after modal closes
- [ ] Focus visible at all times

### Understandable

**Labels & Instructions**
- [ ] All inputs have visible labels
- [ ] Labels positioned consistently (above or left)
- [ ] Placeholder text not used as only label
- [ ] Error messages near the input
- [ ] Error messages describe how to fix

**Predictable**
- [ ] No unexpected context changes
- [ ] Consistent navigation
- [ ] Consistent identification of elements

### Robust

**Semantic HTML**
- [ ] Proper heading hierarchy (h1 -> h2 -> h3)
- [ ] Lists use ul/ol/li
- [ ] Buttons use `<button>`
- [ ] Links use `<a href>`
- [ ] Forms use `<form>`, `<label>`, `<input>`

**ARIA**
- [ ] ARIA labels for icon-only buttons
- [ ] ARIA live regions for dynamic content
- [ ] ARIA describedby for help text
- [ ] No redundant ARIA (don't label already labeled elements)

---

## Theme Support (Light/Dark)

### CSS Custom Properties
```css
/* All colors use CSS custom properties */
--bg-primary
--bg-secondary
--text-primary
--text-secondary
--accent-primary
--border-color
--focus-ring
```

### Theme Requirements
- [ ] All colors defined via custom properties
- [ ] No hardcoded colors in component styles
- [ ] Theme transition smooth (0.2s)
- [ ] Images/icons work in both themes
- [ ] User preference persisted in localStorage

### Testing
- [ ] Light theme screenshot captured
- [ ] Dark theme screenshot captured
- [ ] Contrast verified in both themes
- [ ] No invisible elements in either theme

---

## Locale-Specific Text Support

### Spanish and Polish Review
- [ ] All localized labels fit within their containers
- [ ] Diacritics and punctuation render correctly
- [ ] Buttons, tabs, and menus remain aligned
- [ ] Inputs and validation messages remain readable

---

## Form Design

### Input Fields
- [ ] Clear, visible labels
- [ ] Placeholder provides hint (not label)
- [ ] Sufficient padding (12px+)
- [ ] Visible border or background
- [ ] Focus state clearly visible

### Buttons
- [ ] Primary action uses primary color
- [ ] Secondary actions less prominent
- [ ] Disabled state visually distinct
- [ ] Loading state for async actions
- [ ] Minimum 44px touch target

### Validation
- [ ] Real-time validation where helpful
- [ ] Error messages specific and helpful
- [ ] Success feedback when appropriate
- [ ] Don't validate on blur prematurely

### Form States
```
Normal -> Focus -> Filled -> Error -> Success
```

---

## Feedback & States

### Loading States
- [ ] Instant operations have no loader
- [ ] Operations >300ms show loading indicator
- [ ] Loading doesn't block entire UI if possible

### Success States
- [ ] Clear success feedback (visual + optional text)
- [ ] Feedback doesn't block workflow
- [ ] Auto-dismiss after appropriate time (2-3s)

### Error States
- [ ] Errors clearly visible (color + icon)
- [ ] Error message explains what went wrong
- [ ] Suggests how to fix if possible
- [ ] Doesn't lose user's input

### Empty States
- [ ] Placeholder or instruction shown
- [ ] Not just blank space
- [ ] Invites user action

---

## Copy/Clipboard Interactions

### Copy to Clipboard
- [ ] Copy button clearly visible near copyable content
- [ ] Button shows feedback on copy (icon change or tooltip)
- [ ] Feedback auto-dismisses
- [ ] Works across browsers

### Paste Handling
- [ ] Input accepts paste
- [ ] Pastes cleanly (strips formatting if appropriate)
- [ ] Large pastes handled gracefully

---

## Help Modal Requirements

### Trigger
- [ ] Help button visible and accessible
- [ ] Keyboard shortcut (? or F1)
- [ ] ARIA label: "Open help"

### Modal UX
- [ ] Centered overlay
- [ ] Close button visible (X)
- [ ] ESC key closes modal
- [ ] Click outside closes modal
- [ ] Focus trapped in modal
- [ ] Scrollable if content long

### Content Structure
```markdown
1. Getting Started (numbered steps)
2. Features (bullet list)
3. Keyboard Shortcuts (table)
4. Tips (optional)
```

---

## Performance UX

### Perceived Performance
- [ ] UI responds immediately to user input
- [ ] Skeleton/placeholder during load
- [ ] Progressive enhancement

### Real Performance
- [ ] No unnecessary network requests
- [ ] Debounce rapid inputs (150-300ms)
- [ ] Efficient DOM updates
- [ ] No layout thrashing

---

## AppDoesIt-Specific Patterns

### Standard Max-Widths
| App Type | Max Width |
|----------|-----------|
| Simple calculator | 500px |
| Text tools | 900px |
| Code/JSON tools | 1300px |
| Two-panel tools | 1200px |

### Standard Spacing
- Section padding: 32px (desktop), 16px (mobile)
- Element gap: 16px
- Input padding: 12px
- Button padding: 12px 24px

### Standard Typography
- Headings: System font stack
- Body: 16px base
- Inputs: 16px (prevents iOS zoom)
- Monospace for code: `ui-monospace, monospace`

---

## Final Checklist

Before marking UX complete:

### Visual
- [ ] Consistent with AppDoesIt design system
- [ ] Screenshots captured (light, dark, mobile, `en`/`es`/`pl` coverage)
- [ ] No broken layouts
- [ ] No text overflow/truncation issues

### Functional
- [ ] All interactive elements work
- [ ] Keyboard navigation complete
- [ ] Touch interactions work
- [ ] Copy/paste works

### Accessibility
- [ ] Screen reader tested (or ARIA verified)
- [ ] Color contrast verified
- [ ] Focus indicators visible
- [ ] Tab order logical

### Responsive
- [ ] Mobile layout works
- [ ] Tablet layout works
- [ ] Desktop layout works
- [ ] No horizontal scroll at any size
