# Web App Hardening

## HTTP Security Headers

Prefer setting in Apache config or response middleware:
- **Content-Security-Policy (CSP)**: Restrict script/style/img sources
- **Strict-Transport-Security (HSTS)**: `max-age=31536000; includeSubDomains; preload`
- **X-Content-Type-Options**: `nosniff`
- **X-Frame-Options**: `DENY` or `SAMEORIGIN`
- **Referrer-Policy**: `strict-origin-when-cross-origin`
- **Permissions-Policy**: Deny unused browser features

## Cookies and Sessions

- `HttpOnly`, `Secure`, `SameSite=Lax` (or `Strict` if feasible)
- Avoid storing secrets in client-side storage

## Error Handling

- Avoid detailed stack traces in production
- Return generic error messages to clients

## Rate Limiting and Abuse Prevention

- Cap request sizes (payload limits)
- Apply rate limits to forms or API endpoints
- Use server-side validation and time-based checks

## File Uploads

- Validate file type, MIME, size, and extension
- Store outside web root where possible
- Generate server-side filenames

## Logging

- Log security events without sensitive data
- Include request IDs where feasible
