# WCAG 2.1 AA Checklist

**Source of Truth: [AGENTS.md](../../../AGENTS.md) - `### Accessibility (WCAG 2.1 AA)`**

This checklist covers WCAG 2.1 Level AA requirements for AppDoesIt applications.

---

## 1. Perceivable

Information and user interface components must be presentable to users in ways they can perceive.

### 1.1 Text Alternatives

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| 1.1.1 Non-text Content | All images have alt text | Lighthouse + manual check | Add `alt="description"` or `alt=""` for decorative |

### 1.3 Adaptable

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| 1.3.1 Info and Relationships | Semantic HTML structure | Lighthouse audit | Use proper HTML elements |
| 1.3.2 Meaningful Sequence | Reading order matches visual | Tab through page | Fix DOM order |
| 1.3.3 Sensory Characteristics | Don't rely on shape/location | Manual review | Add text labels |
| 1.3.4 Orientation | Works in portrait and landscape | Test both orientations | Use responsive CSS |
| 1.3.5 Identify Input Purpose | Input types specified | Check `type` and `autocomplete` | Add appropriate attributes |

### 1.4 Distinguishable

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **1.4.1 Use of Color** | Color not sole means of info | Manual review | Add text/icons |
| **1.4.3 Contrast (Minimum)** | 4.5:1 normal text, 3:1 large | Lighthouse | Adjust colors |
| 1.4.4 Resize Text | 200% zoom works | Browser zoom | Use relative units |
| 1.4.5 Images of Text | Avoid text in images | Manual review | Use real text |
| **1.4.10 Reflow** | No horizontal scroll at 320px | Test at 320px width | Responsive design |
| **1.4.11 Non-text Contrast** | 3:1 for UI components | Lighthouse/manual | Adjust colors |
| 1.4.12 Text Spacing | Custom spacing works | Browser extension | Don't fix heights |
| 1.4.13 Content on Hover/Focus | Dismissible, hoverable | Manual test | Follow pattern |

**Contrast Ratios:**
- Normal text (<18pt or <14pt bold): **4.5:1 minimum**
- Large text (>=18pt or >=14pt bold): **3:1 minimum**
- UI components and graphical objects: **3:1 minimum**

---

## 2. Operable

User interface components and navigation must be operable.

### 2.1 Keyboard Accessible

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **2.1.1 Keyboard** | All functionality via keyboard | Tab through entire app | Add keyboard handlers |
| **2.1.2 No Keyboard Trap** | Focus can always escape | Tab continuously | Fix focus management |
| 2.1.4 Character Key Shortcuts | Can disable/remap shortcuts | Test shortcuts | Add remap option |

**Keyboard testing checklist:**
- [ ] Tab moves forward through focusable elements
- [ ] Shift+Tab moves backward
- [ ] Enter/Space activate buttons
- [ ] Escape closes modals/dropdowns
- [ ] Arrow keys work in menus/lists
- [ ] No element traps focus

### 2.4 Navigable

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **2.4.1 Bypass Blocks** | Skip links present | Check for skip link | Add skip link |
| 2.4.2 Page Titled | Descriptive title | Check `<title>` | Update title |
| **2.4.3 Focus Order** | Logical tab order | Tab through page | Fix DOM order |
| 2.4.4 Link Purpose | Links describe destination | Read link text | Improve text |
| 2.4.5 Multiple Ways | Multiple navigation paths | Check nav options | Add search/sitemap |
| **2.4.6 Headings and Labels** | Descriptive headings | Review headings | Improve text |
| **2.4.7 Focus Visible** | Clear focus indicator | Tab and observe | Add :focus-visible |

**Focus indicator requirements:**
```css
/* Visible focus ring */
:focus-visible {
    outline: 2px solid var(--focus-ring, #005fcc);
    outline-offset: 2px;
}

/* Remove default for custom styling */
:focus:not(:focus-visible) {
    outline: none;
}
```

### 2.5 Input Modalities

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| 2.5.1 Pointer Gestures | Complex gestures have alternatives | Test with single pointer | Add button alternatives |
| 2.5.2 Pointer Cancellation | Down event doesn't trigger | Test click behavior | Use click not mousedown |
| 2.5.3 Label in Name | Visible label in accessible name | Compare label to name | Match text |
| **2.5.4 Motion Actuation** | Motion has alternatives | Test without motion | Add button fallback |

---

## 3. Understandable

Information and the operation of user interface must be understandable.

### 3.1 Readable

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **3.1.1 Language of Page** | `lang` attribute set | Check `<html lang="">` | Add lang attribute |
| 3.1.2 Language of Parts | Language changes marked | Check inline lang | Add `lang` to elements |

### 3.2 Predictable

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **3.2.1 On Focus** | No context change on focus | Tab through page | Remove auto-changes |
| **3.2.2 On Input** | No context change on input | Fill forms | Add submit button |
| 3.2.3 Consistent Navigation | Navigation consistent | Compare pages | Standardize nav |
| 3.2.4 Consistent Identification | Same functions identified same | Compare across site | Use consistent labels |

### 3.3 Input Assistance

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **3.3.1 Error Identification** | Errors clearly described | Trigger errors | Add descriptive messages |
| **3.3.2 Labels or Instructions** | Inputs have labels | Check all inputs | Add labels |
| 3.3.3 Error Suggestion | Suggest corrections | Trigger errors | Add suggestions |
| 3.3.4 Error Prevention | Confirm important actions | Test submissions | Add confirmation |

---

## 4. Robust

Content must be robust enough to be interpreted by a wide variety of user agents.

### 4.1 Compatible

| Criterion | Requirement | How to Test | Fix |
|-----------|-------------|-------------|-----|
| **4.1.1 Parsing** | Valid HTML | HTML validator | Fix errors |
| **4.1.2 Name, Role, Value** | Custom widgets have ARIA | Lighthouse + manual | Add ARIA attributes |
| 4.1.3 Status Messages | Status announced | Screen reader test | Use aria-live |

**ARIA requirements:**
```html
<!-- Buttons with icons need labels -->
<button aria-label="Close dialog">
    <svg>...</svg>
</button>

<!-- Custom widgets need roles -->
<div role="slider" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">
</div>

<!-- Modals need proper structure -->
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
    <h2 id="dialog-title">Dialog Title</h2>
</div>

<!-- Live regions for updates -->
<div aria-live="polite" aria-atomic="true">
    Status message here
</div>
```

---

## Quick Audit Checklist

**Must Pass (Critical):**
- [ ] All interactive elements keyboard accessible
- [ ] No keyboard traps
- [ ] Skip link present
- [ ] Focus indicators visible
- [ ] Color contrast meets ratios (4.5:1 / 3:1)
- [ ] Language attribute set
- [ ] Form inputs have labels
- [ ] Error messages are descriptive
- [ ] Valid HTML structure
- [ ] Proper ARIA on custom widgets

**Should Pass (Important):**
- [ ] Logical heading hierarchy
- [ ] Descriptive link text
- [ ] Works at 200% zoom
- [ ] Works at 320px width
- [ ] Touch targets 44x44px minimum
- [ ] Status messages announced

---

## AppDoesIt-Specific Requirements

From AGENTS.md:
- Proper heading hierarchy
- ARIA labels for interactive elements
- Keyboard navigation support
- Sufficient color contrast
- Focus indicators
- Alt text for images
- Skip links

**Theme support:**
- Test both light and dark themes
- Ensure contrast meets requirements in both themes
- No hardcoded colors that break in alternate themes

**Locale-specific rendering:**
- Test Spanish and Polish locale variants
- Ensure localized labels remain readable and do not overflow
- Verify punctuation and diacritics render correctly

**Mobile:**
- Touch targets minimum 44x44px
- No horizontal scroll
- Works in both orientations
