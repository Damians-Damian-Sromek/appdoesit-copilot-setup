# Coding Standards

Code conventions for AppDoesIt apps derived from AGENTS.md.

## PHP Standards

### Style
- **PSR-12** coding style
- **Strict types** where possible
- **Type hints** for parameters and return types

### Output Escaping
Always use the `e()` helper for user-facing output:

```php
// CORRECT
<h1><?= e($title) ?></h1>
<input value="<?= e($value) ?>">

// INCORRECT - XSS vulnerability
<h1><?= $title ?></h1>
```

### Helper Functions

Available helpers from `app/helpers.php`:

| Function | Purpose | Example |
|----------|---------|---------|
| `e($string)` | HTML escape | `e($userInput)` |
| `url($path)` | Generate site URL | `url('/about')` |
| `appUrl($slug)` | Generate app URL | `appUrl('calculator')` |
| `asset($path)` | Asset URL with cache busting | `asset('/css/main.css')` |
| `jsonLd($data)` | Structured data output | `jsonLd($schema)` |

### File Structure

```php
<?php
/**
 * File description
 */

// PHP logic here (minimal)
?>

<!-- HTML template here -->
```

---

## JavaScript Standards

### Style
- **ES6+** features (const, let, arrow functions, template literals)
- **IIFE pattern** for encapsulation
- **'use strict'** directive
- **No build step** - vanilla JS only

### Pattern

```javascript
/**
 * App Name - Description
 */
(function() {
    'use strict';

    // Private variables
    const CONSTANTS = {};
    let state = {};

    // Private functions
    function init() {
        // Initialization
    }

    function handleEvent(e) {
        // Event handling
    }

    // DOM ready
    document.addEventListener('DOMContentLoaded', init);

    // Public API (optional)
    window.AppDoesIt = window.AppDoesIt || {};
    window.AppDoesIt.appName = {
        publicMethod: function() {}
    };
})();
```

### Translation Access

```javascript
// Use the i18n helper
const text = AppDoesIt.i18n.t('appKey.translationKey');
const formatted = AppDoesIt.i18n.t('appKey.greeting', { name: 'User' });
```

### DOM Manipulation

```javascript
// Query elements
const element = document.querySelector('.selector');
const elements = document.querySelectorAll('.selector');

// Event listeners
element.addEventListener('click', handleClick);

// Class manipulation
element.classList.add('active');
element.classList.remove('active');
element.classList.toggle('visible');
```

---

## CSS Standards

### Style
- **BEM-ish naming** (Block__Element--Modifier)
- **CSS custom properties** for theming
- **Mobile-first** responsive design
- **No frameworks** - vanilla CSS only

### Naming Convention

```css
/* Block */
.app-calculator { }

/* Element */
.app-calculator__display { }
.app-calculator__button { }

/* Modifier */
.app-calculator__button--primary { }
.app-calculator__button--disabled { }
```

### Theme Variables

Use existing CSS custom properties:

```css
.my-element {
    /* Colors */
    color: var(--color-text);
    background: var(--color-background);
    border-color: var(--color-border);

    /* Primary colors */
    background: var(--color-primary);
    color: var(--color-primary-text);

    /* Spacing */
    padding: var(--spacing-md);
    margin: var(--spacing-lg);

    /* Borders */
    border-radius: var(--border-radius);
}
```

### Responsive Design

```css
/* Mobile-first (base styles) */
.element {
    width: 100%;
    padding: 1rem;
}

/* Tablet and up */
@media (min-width: 768px) {
    .element {
        width: 50%;
        padding: 1.5rem;
    }
}

/* Desktop and up */
@media (min-width: 1024px) {
    .element {
        width: 33.33%;
        padding: 2rem;
    }
}
```

---

## HTML Standards

### Semantic Structure

```html
<div class="app-container">
    <header class="app-header">
        <h1>App Title</h1>
    </header>

    <main class="app-main">
        <section class="app-section">
            <h2>Section Title</h2>
            <!-- Content -->
        </section>
    </main>

    <aside class="app-sidebar">
        <!-- Secondary content -->
    </aside>

    <footer class="app-footer">
        <!-- Footer content -->
    </footer>
</div>
```

### Accessibility

```html
<!-- Labels for form elements -->
<label for="input-name">Name</label>
<input id="input-name" type="text" aria-describedby="name-help">
<span id="name-help" class="help-text">Enter your full name</span>

<!-- ARIA for interactive elements -->
<button aria-label="Close dialog" aria-expanded="false">
    <span class="icon">x</span>
</button>

<!-- Skip links -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<!-- Landmarks -->
<nav aria-label="Main navigation">
<main id="main-content" role="main">
```

### Translation Attributes

```html
<!-- Static text -->
<h1 data-i18n="appKey.title"></h1>
<p data-i18n="appKey.description"></p>

<!-- Attributes -->
<input data-i18n-placeholder="appKey.placeholder">
<button data-i18n-aria-label="appKey.buttonLabel"></button>
```

---

## File Organization

### App Files

```
apps/{slug}/
  index.php           # Main template (required)

public/assets/
  js/{slug}.js        # App JavaScript (if needed)
  css/{slug}.css      # App CSS (if needed)
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| App slug | kebab-case | `my-new-app` |
| Translation key | camelCase | `myNewApp` |
| CSS class | BEM kebab-case | `app-calculator__button` |
| JS function | camelCase | `handleButtonClick` |
| JS constant | UPPER_SNAKE | `MAX_VALUE` |
| PHP variable | camelCase | `$pageTitle` |
