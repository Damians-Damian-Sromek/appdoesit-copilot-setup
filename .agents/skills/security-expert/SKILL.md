---
name: security-expert
description: Security auditing and hardening for AppDoesIt apps and platform. Use when creating or modifying apps, reviewing input handling, authentication, file uploads, or when the user mentions security, OWASP, XSS, CSRF, SQL injection, SSRF, RCE, secrets, or vulnerabilities. Provides a structured security review workflow, threat modeling guidance, and remediation patterns.
---

# Security Expert Skill

Comprehensive security review and remediation workflow for AppDoesIt apps, aligned with OWASP Top 10 and project-specific requirements.

## Source of Truth

Security requirements in `AGENTS.md` take precedence. Always read:
- `### Security Essentials` in `AGENTS.md`
- `.agents/skills/programmer/references/security-checklist.md` for project-specific checks

If this skill conflicts with `AGENTS.md`, follow `AGENTS.md`.

## Consulting Other Skills (Task tool required)

Use the Task tool for cross-domain questions:

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /security-expert:
    Context: {what you're securing}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| UX or UI change needed for security fix | `/ui-expert` |
| Input validation or server-side logic changes | `/programmer` |
| Translation updates for new security copy | `/i18n-manager` |
| E2E tests for security-related flows | `/e2e-testing` |
| Requirements unclear | `/product-owner` |

## When to Use This Skill

Trigger this skill when:
- Creating a new app or feature that accepts input
- Modifying forms, uploads, or data processing
- Handling authentication/authorization or session logic
- Adding third-party integrations or APIs
- User requests a security review, audit, or OWASP compliance

## Security Review Workflow

### Step 1: Scope the Review

Identify:
- App(s) affected and entry points (forms, query params, headers, cookies)
- Data handled (PII, secrets, tokens, files)
- Trust boundaries (client vs server, external APIs)

Create a short scope list before proceeding.

### Step 2: Threat Model (Lightweight)

Use STRIDE-style prompts:
- **Spoofing**: Can a user impersonate another user or service?
- **Tampering**: Can inputs modify data or behavior unexpectedly?
- **Repudiation**: Are actions logged or traceable?
- **Information disclosure**: Can data leak via errors or responses?
- **Denial of service**: Can requests be abused (rate limits, payload size)?
- **Elevation of privilege**: Can users gain unauthorized access?

Document 2-5 likely threats and map them to mitigations.

### Step 3: Input/Output Controls

Validate server-side and sanitize:
- Use strict allow-lists for inputs (types, ranges, formats)
- Normalize and validate dates, numbers, and enums
- Reject unexpected fields

Encode outputs:
- Use `e()` for all user-facing output
- Avoid rendering raw HTML from user input
- Sanitize any rich text or markdown (if introduced)

### Step 4: Web App Hardening Checklist

Follow the project checklist in `.agents/skills/programmer/references/security-checklist.md`, plus:
- Enforce CSRF tokens, honeypot, and timing checks for all forms
- Avoid exposing secrets or API keys in client code
- Use same-site cookies for session data where applicable
- Validate file uploads (type, size, MIME, extension), store outside web root

### Step 5: OWASP Top 10 Mapping

Cross-check likely risks against OWASP Top 10. See:
- `references/owasp-top10.md`

Ensure any identified issues are addressed or explicitly mitigated.

### Step 6: Security Regression Tests

Add tests when security behavior can regress:
- CSRF token present and validated
- Input validation rejects invalid data
- Output encoding prevents XSS
- Upload validation rejects unexpected file types

If needed, consult `/e2e-testing` for Playwright coverage.

**Collaboration requirement:**
- Work with `/programmer` to ensure these checks are covered in **unit + integration** tests.
- Work with `/qa-expert` to confirm any **high-risk flows** have minimal E2E smoke coverage.

### Step 7: Report Findings

Provide a concise report with:
- **Risk** (Critical/High/Medium/Low)
- **Impact** and affected area
- **Recommendation** with specific fix
- **Status** (Fixed / Needs follow-up)

Use the format in `references/report-template.md`.

## Common Fix Patterns

- **XSS**: Escape output with `e()`, avoid `innerHTML`, sanitize user input
- **CSRF**: Enforce token checks on all POST/PUT/DELETE requests
- **SQL Injection**: Use prepared statements, avoid string concatenation
- **SSRF**: Restrict outbound requests to allow-listed domains
- **Path Traversal**: Normalize and restrict file paths to safe directories
- **Open Redirect**: Allow-list redirect targets

## Reference Files

- `references/owasp-top10.md` - OWASP Top 10 summary and mapping
- `references/web-hardening.md` - HTTP/security headers and platform hardening
- `references/php-js-security-patterns.md` - Safe patterns for PHP/JS in this repo
- `references/report-template.md` - Security review report template

## Updating This Skill

When `AGENTS.md` security requirements change, update this skill and related references to match.

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /security-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/security-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
