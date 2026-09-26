# PHP + JS Security Patterns (AppDoesIt)

## PHP

- Escape output with `e()` for all user-facing content.
- Validate inputs with allow-lists; reject unexpected fields.
- Use `filter_input()` or explicit validation for GET/POST values.
- Avoid string concatenation for SQL; use prepared statements.
- Enforce CSRF token + honeypot + timing checks on forms.

## JavaScript

- Avoid `innerHTML` with untrusted content.
- Prefer `textContent` for inserting user data.
- Avoid `eval`, `new Function`, or dynamic script injection.
- Sanitize any rich-text or markdown before rendering.

## Common Anti-Patterns

- Trusting client-side validation alone
- Echoing raw user input in templates
- Storing secrets in JS or localStorage
- File uploads without server-side validation
