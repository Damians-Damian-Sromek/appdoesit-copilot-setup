# Common QA Issues Checklist

## Header/Navigation Issues (CRITICAL - CHECK FIRST!)

- [ ] **Header has complete navigation menu** - Not just logo + help button
- [ ] **Nav toggle present** - Mobile hamburger menu button
- [ ] **Nav menu visible** - Contains: Home, Apps dropdown, About, Theme toggle, Language selector
- [ ] **Apps dropdown included** - Via nav-dropdown.php partial
- [ ] **Theme toggle present** - Sun/moon icons for light/dark mode
- [ ] **Language selector present** - Dropdown with the 3 supported locales (`en`, `es`, `pl`)

**If header only has logo and help button:**
This is a CRITICAL bug. The app is missing the entire navigation menu.
Users cannot navigate to other apps, switch theme, or change language.
Report as: "CRITICAL: Header missing navigation menu - only has logo + help button"

## Footer Issues (CRITICAL)

- [ ] **Footer has 3 sections** - Not just copyright
- [ ] **Footer brand present** - Logo icon + site name at top
- [ ] **Footer nav present** - 6 links: Home, About, Contact, Privacy, Terms, Attributions
- [ ] **Footer copyright present** - At bottom

**If footer only has copyright:**
This is a bug. Footer should have brand + nav links + copyright.
Report as: "CRITICAL: Footer missing brand and navigation sections"

## Translation Issues
- [ ] No `camelCase.dotNotation` keys visible
- [ ] Help section fully translated
- [ ] Use cases fully translated
- [ ] Buttons and labels translated
- [ ] Placeholder text translated

## Text Display Issues (CRITICAL - Often Missed!)
- [ ] **All labels fully visible** - No truncated text like "STA'" instead of "START WITH"
- [ ] **Text has proper spacing** - No concatenated strings like "Ctrl+EnterGenerateCtrl+Shift+C..."
- [ ] **Keyboard shortcuts formatted correctly** - Should be "Ctrl+Enter - Generate" not "Ctrl+EnterGenerate"
- [ ] **No text overflow** - All text fits within containers
- [ ] **Labels and values are separate** - Not merged together

## Layout Issues (CRITICAL - FREQUENTLY MISSED!)
- [ ] **App container is HORIZONTALLY CENTERED** (not left-aligned)
- [ ] **On 1280px viewport, app has equal whitespace on both sides**
- [ ] Max-width constraints working (app doesn't stretch full-width)
- [ ] Sections have proper spacing
- [ ] No content cut off at edges
- [ ] Form labels align with inputs

**If app is left-aligned instead of centered:**
This is a CRITICAL CSS bug. The app's CSS file is missing `margin: 0 auto` on the container class.
Report this as: "CRITICAL: App container not centered - missing `margin: 0 auto` in CSS"

## Mobile Issues
- [ ] Buttons/inputs at least 44px touch target
- [ ] Text at least 16px for readability
- [ ] No side-scrolling required
- [ ] Hamburger menu working (if applicable)

## Theme Issues
- [ ] Background colors correct for theme
- [ ] Text colors maintain contrast
- [ ] Borders/shadows appropriate
- [ ] Interactive states visible (hover, focus)

## Locale Text/Layout Issues
- [ ] Spanish and Polish text is fully translated
- [ ] Longer labels do not overflow or clip
- [ ] Diacritics render correctly
- [ ] Layout remains aligned with localized content

## Dynamic Message-State Issues (check every non-constant text)
- [ ] Each status/feedback message variant was exercised (idle, running, done, error, unavailable)
- [ ] Longest variant of each label/message renders fully — no clipping, ellipsis, or overflow
- [ ] Longest `es`/`pl` translation fits without hard-coded widths squeezing it
- [ ] Empty and long-result states do not break layout (no horizontal scroll, no pushed-off siblings)
- [ ] Status regions (`role="status"`) expand with content
