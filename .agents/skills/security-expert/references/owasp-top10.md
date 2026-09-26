# OWASP Top 10 (2021) - Quick Mapping

Use this as a quick check to ensure common risks are addressed.

## A01: Broken Access Control
- Ensure routes and actions enforce authorization.
- Never rely on client-side checks.

## A02: Cryptographic Failures
- Avoid storing sensitive data when possible.
- Use secure transport (HTTPS) and avoid secrets in client code.

## A03: Injection
- Use prepared statements for SQL.
- Strict input validation and allow-lists.
- Avoid eval and dynamic code execution.

## A04: Insecure Design
- Threat model the feature and document mitigations.
- Prefer secure defaults and minimal exposure.

## A05: Security Misconfiguration
- Review headers, error handling, and server config.
- Disable directory listing and remove debug output.

## A06: Vulnerable and Outdated Components
- Keep dependencies updated (Composer/NPM).
- Avoid unmaintained libraries.

## A07: Identification and Authentication Failures
- Use secure session handling and cookies.
- Avoid custom auth mechanisms.

## A08: Software and Data Integrity Failures
- Validate external data sources.
- Verify deployment integrity and avoid unsigned scripts.

## A09: Security Logging and Monitoring Failures
- Ensure security-relevant events can be traced.
- Avoid logging secrets or PII.

## A10: Server-Side Request Forgery (SSRF)
- Restrict outbound requests to allow-listed hosts.
- Validate and normalize URLs before fetching.

## Quick Checklist
- [ ] Input validation and output encoding
- [ ] CSRF protections on state-changing actions
- [ ] No secrets in client or logs
- [ ] Secure headers and server config
- [ ] Dependencies reviewed/updated
