# Product Specification: Base64 Encoder/Decoder

**Version:** 1.0
**Date:** 2025-01-11
**Status:** Ready for Implementation

---

## 1. App Identity

### Basic Information
| Field | Value |
|-------|-------|
| **App Name** | Base64 Encoder/Decoder |
| **Slug** | base64-encoder |
| **Category** | developer |
| **Icon** | code |
| **Version** | 1.0.0 |

### Description
**Short (for cards):**
Encode and decode Base64 strings instantly. Supports text, files, and URL-safe encoding.

**Long (for SEO):**
Free online Base64 encoder and decoder. Convert text to Base64 and back instantly. Supports standard and URL-safe encoding, file encoding, and works completely offline.

### Keywords
base64 encoder, base64 decoder, base64 converter, encode base64, decode base64, base64 online, data uri

---

## 2. Target Audience

### Primary Persona
**Name:** Dev Dana
**Role:** Web Developer / Backend Engineer
**Goal:** Quickly encode/decode Base64 strings while debugging APIs or embedding data
**Context:** During development work, often working with JWT tokens, API payloads, data URIs
**Pain Points:**
- Command line tools require remembering flags
- Many online tools have ads and tracking
- Some tools don't handle special characters well

### Secondary Persona
**Name:** Student Sam
**Role:** CS Student / Learning Developer
**Goal:** Understand how Base64 encoding works
**Context:** Learning about encoding, completing assignments
**Pain Points:**
- Doesn't understand the output format
- Needs to see the process, not just results

---

## 3. Use Cases (5 Required)

### Use Case 1: Debug API Payloads
**Scenario:** Developer receives a Base64-encoded error message from an API
**Action:** Paste the encoded string, instantly see decoded content
**Benefit:** Quickly understand API response without leaving browser

### Use Case 2: Create Data URIs
**Scenario:** Front-end developer needs to embed a small image as a data URI
**Action:** Upload image file, get Base64 string ready for CSS/HTML
**Benefit:** Inline assets without additional HTTP requests

### Use Case 3: Encode Sensitive Config
**Scenario:** DevOps engineer needs to encode credentials for config files
**Action:** Enter sensitive string, get Base64 encoded version
**Benefit:** Safely store encoded strings in YAML/JSON configs

### Use Case 4: JWT Token Inspection
**Scenario:** Developer debugging JWT authentication issues
**Action:** Paste JWT token parts to decode header and payload
**Benefit:** See token contents without installing jwt.io or similar

### Use Case 5: Email Attachment Analysis
**Scenario:** Security analyst examining email attachments
**Action:** Decode Base64-encoded attachment content
**Benefit:** Inspect attachment data safely in browser

---

## 4. FAQ (5 Required)

### FAQ 1
**Q:** What is Base64 used for?

**A:** Base64 is an encoding format that converts binary data into text so it can be safely transported in places that expect text (like JSON payloads, URLs, or email bodies).

### FAQ 2
**Q:** Is Base64 encryption?

**A:** No. Base64 is not encryption and provides no security. Anyone can decode Base64 back to the original content.

### FAQ 3
**Q:** Why do some Base64 strings end with “=”?

**A:** “=” is padding that makes the encoded output length a multiple of 4 characters. It’s normal and required for standard Base64 in many contexts.

### FAQ 4
**Q:** What is “URL-safe Base64” and when should I use it?

**A:** URL-safe Base64 replaces `+` with `-` and `/` with `_` to avoid characters that are awkward in URLs and filenames. Use it for tokens and URL parameters.

### FAQ 5
**Q:** Why does decoding sometimes fail even when the string “looks” like Base64?

**A:** Common causes include missing padding, invalid characters, line breaks/spaces added during copying, or mixing URL-safe and standard Base64 alphabets.

---

## 5. Feature Matrix

### Must Have (Core - v1.0)
| Feature | Description | User Value |
|---------|-------------|------------|
| Text Encode | Convert plain text to Base64 | Core functionality |
| Text Decode | Convert Base64 back to text | Core functionality |
| Instant conversion | Real-time as you type | No friction |
| Copy output | One-click copy to clipboard | Workflow speed |
| Clear inputs | Reset both fields | Quick restart |
| URL-safe mode | Use URL-safe alphabet | API compatibility |

### Should Have (Enhanced - v1.1)
| Feature | Description | User Value |
|---------|-------------|------------|
| File encoding | Drag-drop or upload file | Handle binary data |
| Download decoded | Download decoded content as file | Save results |
| Encoding selector | Standard vs URL-safe toggle | Flexibility |
| Swap direction | Switch input/output | Convenience |

### Could Have (Future)
| Feature | Description | User Value |
|---------|-------------|------------|
| Format JSON output | Pretty-print decoded JSON | Developer convenience |
| Line-break options | Add/remove line breaks | RFC compliance |
| History | Recent conversions | Quick re-access |
| Multi-line handling | Proper multiline encoding | Edge cases |

### Won't Have (Out of Scope)
| Feature | Reason |
|---------|--------|
| Encryption | Different tool purpose |
| Hash generation | Different tool (MD5, SHA) |
| Cloud storage | Requires accounts |
| Batch processing | Complexity, limited value |

---

## 6. UI/UX Specification

### Layout Structure
```
+-----------------------------------------+
| Header + Help Button                    |
+-----------------------------------------+
| Mode Toggle Bar                         |
| [Encode] [Decode] [URL-Safe]            |
|                                         |
| Input Textarea                          |
| Placeholder: "Enter text or paste ..."  |
| [Clear] [Paste]                         |
|                                         |
| [Swap]                                  |
|                                         |
| Output Textarea (read-only)             |
| [Copy] [Download]                       |
+-----------------------------------------+
| Use Cases Section                       |
+-----------------------------------------+
| Footer                                  |
+-----------------------------------------+
```

### Component Details

#### Mode Toggle Bar
**Purpose:** Switch between encode/decode mode and encoding type
**Elements:**
- Encode button (active state highlighted)
- Decode button
- URL-safe toggle checkbox
**Behavior:**
- Selecting mode doesn't clear input
- Automatically re-processes on mode change
- URL-safe toggle affects both encode/decode

#### Input Textarea
**Purpose:** User enters text to encode or Base64 to decode
**States:**
- Empty: Shows placeholder text with instructions
- Active: User typing, instant processing
- Error: Invalid Base64 (decode mode) - shows error below
**Interactions:**
- Paste: Ctrl/Cmd+V or button
- Clear: Button clears field
- File drop: Accepts file drop for encoding
**Size:** Min 200px height, auto-expand up to 400px

#### Output Textarea
**Purpose:** Shows conversion result
**States:**
- Empty: Before any input
- Result: Shows encoded/decoded output
- Error: Shows error message
**Interactions:**
- Read-only (no editing)
- Copy: Button copies to clipboard
- Select all: Ctrl/Cmd+A works

#### Swap Button
**Purpose:** Exchange input and output
**Behavior:** Moves output to input, switches mode

### Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| `Ctrl/Cmd + Enter` | Copy output |
| `Ctrl/Cmd + Shift + C` | Clear all |
| `Ctrl/Cmd + E` | Switch to Encode mode |
| `Ctrl/Cmd + D` | Switch to Decode mode |
| `Escape` | Clear input |

### Responsive Behavior
**Desktop (>768px):**
- Max-width: 900px
- Textareas side-by-side possible, but stacked preferred
- All buttons visible with labels

**Mobile (<768px):**
- Full-width stacked layout
- Textareas full width
- Buttons full width with icons + labels
- Touch-friendly 44px+ targets

### Theme Support
- All elements use CSS custom properties
- Input/output backgrounds use --bg-secondary
- Buttons use --accent-primary
- Error text uses --error-color
- Works seamlessly in both light and dark modes

---

## 7. Functional Requirements

### FR-1: Text Encoding
**Description:** Convert plain text to Base64 encoded string
**Input:** Any text (UTF-8 supported)
**Processing:**
1. Convert text to bytes (UTF-8)
2. Apply Base64 encoding algorithm
3. If URL-safe: replace +/ with -_
**Output:** Base64 encoded string
**Validation:** No validation needed (all text encodable)
**Errors:** None expected

### FR-2: Text Decoding
**Description:** Convert Base64 string back to original text
**Input:** Base64 encoded string
**Processing:**
1. If URL-safe mode: replace -_ with +/
2. Decode Base64 to bytes
3. Interpret bytes as UTF-8 text
**Output:** Original text
**Validation:**
- Must be valid Base64 (A-Za-z0-9+/=)
- Length must be multiple of 4 (with padding)
**Errors:**
- "Invalid Base64: contains invalid characters"
- "Invalid Base64: incorrect padding"

### FR-3: URL-Safe Mode
**Description:** Use URL-safe Base64 alphabet
**Processing:**
- Encoding: Replace + with -, / with _
- Decoding: Replace - with +, _ with /
- No padding option available
**Use case:** Safe for URLs and filenames

### FR-4: Copy to Clipboard
**Description:** Copy output to system clipboard
**Processing:** Use Clipboard API
**Feedback:** Button changes to "Copied!" for 2 seconds
**Fallback:** Select text for manual copy if API unavailable

### FR-5: Swap Input/Output
**Description:** Exchange input and output content
**Processing:**
1. Store current output
2. Move output to input
3. Toggle encode/decode mode
4. Clear output (will auto-fill)
**Use case:** Verify encoding by immediately decoding

---

## 8. Non-Functional Requirements

### Performance
- [x] Instant encoding/decoding (<50ms for typical inputs)
- [x] Handle inputs up to 1MB
- [x] No network requests for encoding/decoding
- [x] Debounce input at 150ms for very large inputs

### Accessibility (WCAG 2.1 AA)
- [x] Labels for all inputs
- [x] Error messages associated with inputs via aria-describedby
- [x] Focus management on mode switch
- [x] Keyboard shortcuts don't conflict with screen readers
- [x] Clear focus indicators

### Internationalization (i18n)
- [x] All UI text in translation files
- [x] 3 locales: en, es, pl
- [x] Locale-aware support for `en`, `es`, and `pl`
- [x] Labels, placeholders, errors all translated

### Security
- [x] No data sent to servers
- [x] No localStorage of sensitive input
- [x] XSS prevention in output display

### Browser Support
- [x] Chrome, Firefox, Safari, Edge (latest 2 versions)
- [x] Mobile Safari and Chrome
- [x] Clipboard API with fallback

---

## 9. Help Content Outline

### Help Modal Structure
```markdown
## How to Use Base64 Encoder/Decoder

### Getting Started
1. Choose your mode: **Encode** (text to Base64) or **Decode** (Base64 to text)
2. Type or paste your content in the input area
3. See the result instantly in the output area
4. Click **Copy** to copy the result

### Features
- **Instant conversion**: Results appear as you type
- **URL-safe mode**: Use Base64 that's safe for URLs (no + or / characters)
- **Swap**: Click the swap button to verify encoding by immediately decoding
- **File support**: Drag and drop a file to encode it

### Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| Ctrl/Cmd + Enter | Copy output |
| Ctrl/Cmd + E | Encode mode |
| Ctrl/Cmd + D | Decode mode |
| Escape | Clear input |

### Tips
- Base64 increases size by ~33% - it's encoding, not compression
- URL-safe Base64 is great for JWT tokens and API parameters
- Invalid Base64 will show a helpful error message
```

### Translation Keys Required
```
base64Encoder.title
base64Encoder.description
base64Encoder.seoTitle
base64Encoder.seoDescription

# Help (required keys)
base64Encoder.helpTitle
base64Encoder.openHelp
base64Encoder.closeHelp

# Help outline keys (example pattern used in existing apps)
base64Encoder.helpHowTo
base64Encoder.helpHowToStep1
base64Encoder.helpHowToStep2
base64Encoder.helpHowToStep3
base64Encoder.helpHowToStep4
base64Encoder.helpFeatures
base64Encoder.helpFeatureUrlSafe
base64Encoder.helpTips
base64Encoder.helpTip1

# Use cases (required keys)
base64Encoder.useCasesTitle
base64Encoder.useCasesIntro
base64Encoder.useCase1Title
base64Encoder.useCase1Desc
... (useCase2-5)

# Skip-to (required key)
base64Encoder.skipToBase64Encoder

# App UI keys (examples)
base64Encoder.encode
base64Encoder.decode
base64Encoder.urlSafe
base64Encoder.inputPlaceholder
base64Encoder.clear
base64Encoder.copy
base64Encoder.copied
base64Encoder.invalidBase64
```

---

## 10. SEO Considerations

### Meta Tags
```html
<title>Base64 Encoder/Decoder - Free Online Tool | AppDoesIt</title>
<meta name="description" content="Free online Base64 encoder and decoder. Convert text to Base64 and back instantly. URL-safe encoding, file support, works offline. No ads, no tracking.">
```

### JSON-LD Structured Data
```json
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Base64 Encoder/Decoder",
  "description": "Encode and decode Base64 strings instantly",
  "applicationCategory": "DeveloperApplication",
  "operatingSystem": "Any",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  }
}
```

### Target Keywords
- Primary: base64 encoder, base64 decoder
- Secondary: encode base64 online, decode base64 online, base64 converter
- Long-tail: base64 url safe encoder, convert text to base64 online free

---

## 11. Complexity Assessment

### Rating: Low-Medium

### Breakdown
| Factor | Assessment |
|--------|------------|
| Core Algorithm | Simple (built-in btoa/atob) |
| State Management | Minimal (mode, url-safe flag) |
| UI Components | Few (2 textareas, toggles, buttons) |
| External Dependencies | None |
| i18n Effort | Standard (3 supported locales) |
| Accessibility | Standard |

### Risk Factors
- Unicode handling in Base64 (needs UTF-8 encoding first)
- Large file handling (may need chunking)
- Clipboard API browser support varies

### Dependencies
- None (vanilla JS using built-in btoa/atob)
- Polyfill for TextEncoder if needed for old browsers

---

## 12. Competitive Analysis Summary

### Competitors Analyzed
| Tool | URL | Strengths | Weaknesses |
|------|-----|-----------|------------|
| Base64encode.org | base64encode.org | Simple, fast | Ads, no dark mode |
| Base64-decode.com | base64-decode.com | File support | Cluttered UI, ads |
| CyberChef | gchq.github.io/CyberChef | Many operations | Overkill for simple Base64 |

### Our Differentiation
- No ads, no tracking - completely clean UI
- Instant conversion as you type
- Dark mode support
- Offline-capable (no network needed)
- Mobile-first responsive design
- 3 supported locales (`en`, `es`, `pl`)
- URL-safe encoding built-in

---

## 13. Success Metrics

### Launch Criteria
- [x] Encode and decode work correctly
- [x] URL-safe mode works
- [x] Copy to clipboard works
- [x] All 3 supported locales translated
- [x] Help modal complete
- [x] 5 use cases documented
- [x] Required E2E smoke tests passing
- [x] Accessibility audit passed

### Post-Launch Metrics
- Page views and unique users
- Feature usage (encode vs decode ratio)
- Error rate (invalid Base64 attempts)
- Copy button usage rate

---

## Appendix

### Technical Notes
- Use `btoa()` and `atob()` for ASCII-safe operations
- For UTF-8: encode with `encodeURIComponent` + `unescape` pattern or TextEncoder
- URL-safe: simple character replacement, no library needed

### Open Questions
- None - specification is complete
