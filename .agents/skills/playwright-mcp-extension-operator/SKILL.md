---
name: playwright-mcp-extension-operator
description: Use when you need to act like a real, logged-in user via the Playwright MCP Chrome/Edge extension for workflows such as submitting apps to directories, posting on social media, or updating authenticated web forms. Covers extension setup, secure connection, logged-in session use, and safe automation practices for human-in-the-loop approvals.
---

# Playwright MCP Extension Operator

## Purpose

Operate authenticated, human-like browser workflows through the Playwright MCP browser extension, using the user's existing Chrome/Edge profile and logged-in state. Focus on real submissions, social posts, and account-bound form flows that require an existing session.

## Preconditions

- Confirm the user explicitly wants to automate the target website and that the workflow complies with its Terms of Service.
- Confirm the user is already logged in to the target site in their Chrome/Edge profile.
- Ensure the Playwright MCP server is configured with the extension flag.

If any of these are missing, pause and request clarification or user action.

## Setup Checklist

1. Install the Playwright MCP browser extension (Chrome/Edge/Chromium):
   - Download the extension from the Playwright MCP releases page.
   - Load it via `chrome://extensions` -> Developer mode -> Load unpacked.
2. Configure MCP server with `--extension`:
   - Use `@playwright/mcp@latest` and pass `--extension` in MCP config.
3. Optional: bypass approval dialog by setting the extension token:
   - Copy `PLAYWRIGHT_MCP_EXTENSION_TOKEN` from the extension UI.
   - Set it in MCP server environment (never commit this value).

## Operating Workflow

1. Ask the user to open the target site in the logged-in browser profile.
2. Start the MCP server and connect to the correct tab when prompted.
3. Take a snapshot and identify elements by semantic roles/labels.
4. Perform actions in small, reversible steps:
   - Navigate -> fill fields -> upload assets -> review -> submit.
5. After submission/post, verify success by checking:
   - Confirmation message, new post visible, or submitted form state.
6. Report back with the final URL or proof of submission.

## Submission Playbook (Apps/Directories)

Before acting, gather or confirm:
- App name, URL, tagline, and description.
- Category/tags and pricing (free/paid).
- Logo (file path) and screenshots (file paths), if required.
- Contact email and social handles, if required.

If any required fields are unknown, stop and request the missing details.

**Autonomous Execution Policy (canonical - other skills reference this section):**

Autonomous actions (no per-step confirmation):
- Fill all form fields automatically (text inputs, dropdowns, file uploads)
- Navigate between form pages without asking permission
- Scroll, adapt to layout changes, and retry navigation once on failure

Confirm only before irreversible actions:
- Final form submission - show the completed form and ask "Ready to submit? (yes/no)"
- Publishing/posting content - after showing the preview of what will be posted
- Account actions (following/sharing, adding to lists)

Error handling:
- Recoverable errors (wrong field, missing info): fix automatically or ask for clarification
- Form rejection (validation error, rate limit): report back and ask user how to proceed
- Site changes (layout changed, buttons moved): re-snapshot and adapt, ask user if unsure

Reporting: after submission, verify success and report the confirmation URL/message.

## Social Posting Playbook

- Confirm the exact copy, hashtags, and link before posting.
- Use a preview step if the platform provides one.
- **Autonomous Execution:** After the user confirms the copy, automatically proceed with clicking the final "Post/Share" action without requesting additional confirmation for each button click.
- Report success with the post URL or confirmation message.

## Security & Privacy

- Never request or store credentials. Use the user's logged-in session.
- Do not persist tokens or cookies in the repository.
- Avoid pasting secrets into chats; request user to set them locally.

## Anti-Bot and CAPTCHA Handling

- If a CAPTCHA or bot challenge appears, pause and ask the user to complete it manually.
- Do not attempt to bypass anti-bot measures.

## Error Recovery

- If elements are not found, re-snapshot and use alternate labels/roles.
- If navigation fails, retry once; otherwise ask the user to confirm the correct URL.
- If the connection approval dialog blocks progress, ask the user to approve or configure the token.

## Reporting

Provide a brief, structured summary:
- Target site and action performed.
- Confirmation evidence (message text or URL).
- Any user-required follow-ups.

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /playwright-mcp-extension-operator
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/playwright-mcp-extension-operator, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
