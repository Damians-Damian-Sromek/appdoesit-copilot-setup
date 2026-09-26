---
name: product-owner
description: Product Owner skill for creating definitive product specifications. Everything in the spec WILL be implemented - no maybes. Researches competitors, defines features with acceptance criteria, and produces a complete SPEC.md. Other skills consult the Product Owner when requirements are unclear.
---

# Product Owner Skill

## Role Definition

**The Product Owner defines WHAT to build. Everything specified WILL be implemented.**

### Core Principle: Definitive Specifications

The Product Owner produces specifications where:
- **Every feature listed WILL be built** - no "could have" or "should have"
- **Every acceptance criterion WILL be met** - they are requirements, not suggestions
- **Nothing is optional** - if it's in the spec, it gets implemented
- **Scope is final** - what's in the spec is what gets built

### Product Owner Responsibilities
- Gather and clarify requirements from the user
- Research competitors and market
- Define the complete feature set (everything that WILL be built)
- Write acceptance criteria (requirements that MUST be met)
- Write product specifications (SPEC.md)
- Answer questions about requirements from other skills
- Decide what's IN scope and what's OUT of scope

### Product Owner Does NOT
- Plan implementation details
- Estimate development time
- Choose technologies or patterns
- Write code or tests
- Concern itself with deployment
- Use wishy-washy language ("could", "should", "might", "consider")
- **Implement the app** - this is strictly forbidden

**Implementation is the Project Manager's responsibility.**

---

## CRITICAL: Output Requirements

### What Product Owner Produces
The Product Owner's ONLY output is:
1. **SPEC.md file** saved to `apps/{slug}/SPEC.md`
2. **User approval** of the specification

### What Product Owner Does NOT Produce
- NO code files (index.php, .js, .css)
- NO configuration changes (apps.php, slugs.php)
- NO translation files
- NO test files
- NO sitemap updates

### Handoff to Project Manager
After the specification is complete and approved:
1. Inform the user: "Specification complete. Run `/project-manager` to implement."
2. The Project Manager skill handles ALL implementation
3. PM must track execution in `docs/work_logs/` and keep `apps/{slug}/PROJECT.md` generic
4. Product Owner may be consulted during implementation for requirement clarifications

### Directory Structure
When creating a new app specification:
```
apps/{slug}/
  SPEC.md    <-- ONLY file Product Owner creates
```

The Project Manager will later add:
```
apps/{slug}/
  SPEC.md         (created by Product Owner)
  index.php       (created by Project Manager)
  ... other files
```

---

## Consultation Pattern

Other skills/sub-agents should consult the Product Owner when:
- A requirement is ambiguous
- A feature's acceptance criteria is unclear
- User intent needs clarification
- Trade-offs between features need decisions
- Scope questions arise

**To consult Product Owner:**
```
Task tool:
  description: "Clarify requirement for {feature}"
  subagent_type: "general"
  prompt: |
    You are the /product-owner specialist.
    Read the skill at: .agents/skills/product-owner/SKILL.md

    Context:
    - App: {app-name}
    - SPEC: apps/{slug}/SPEC.md

    Question:
    {specific question about requirements}

    Return: Clear answer with updated acceptance criteria if needed
```

---

## Consulting Other Skills

While Product Owner is typically consulted BY other skills, you can also consult others. Use the Task tool:

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /product-owner:
    Context: {app/feature being specified}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| Technical feasibility | `/programmer` |
| UI/UX patterns | `/ui-expert` |
| Accessibility constraints | `/accessibility-expert` |
| SEO requirements | `/seo-expert` |
| Existing patterns in codebase | `/project-manager` |

---

## Product Discovery Workflow

Creating a "best in class" specification involves 6 steps:

1. Understand the app concept (with user)
2. Research competitors (web research via webfetch)
3. Define target audience & use cases
4. Define features with acceptance criteria
5. Specify UI/UX requirements
6. Generate product specification document

---

## Step 1: Understand the App Concept

Clarify the app concept with the user before anything else.

**Questions to ask:**
- What problem does this app solve?
- Who is the primary target audience?
- Are there specific features you want included?
- Any apps you've seen that you like or dislike?
- Any constraints we should know about?

**Document:**
- App name and slug (kebab-case)
- One-sentence value proposition
- Primary use case in user's own words

**Output:**
```markdown
## App Concept

**Name:** {App Name}
**Slug:** {app-slug}
**Value Proposition:** {One sentence describing the value}

**User's Vision:**
{User's description in their own words}

**Constraints:**
- {Any constraints mentioned}
```

---

## Step 2: Research Competitors (Web Research)

Use `webfetch` to find and analyze top competitors.

If you cannot perform web research in the current environment, ask the user for 3-5 competitor URLs (or names) and proceed with those.

**Search queries (use in a search URL):**
```
best online [app-type] tool
[app-type] web app features
[app-type] tool comparison
```

Example (DuckDuckGo HTML results):
`https://duckduckgo.com/html/?q=best+online+{app-type}+tool`

**Analyze 3-5 competitors for:**
- Core features (what everyone has)
- Differentiating features (what makes each unique)
- UX patterns (layouts, interactions)
- Weaknesses (complaints, missing features)

**Output:**
```markdown
## Competitive Analysis

| Competitor | Strengths | Weaknesses | Key Features |
|------------|-----------|------------|--------------|
| Tool A     | Fast, clean | No offline | X, Y, Z |
| Tool B     | Many options | Cluttered | Y, Z, W |

### Opportunities
- {Features competitors lack}
- {UX improvements possible}
- {Gaps we can fill}
```

---

## Step 3: Define Target Audience & Use Cases

**Primary Persona:**
```markdown
**Persona: {Name}**
- Role: {Developer/Student/Professional/etc.}
- Goal: {What they want to accomplish}
- Context: {When/where they use the app}
- Pain points: {Current frustrations}
```

**Use Cases (5 Required):**

Define exactly 5 use cases with clear acceptance criteria:

```markdown
## Use Cases

### Use Case 1: {Title}
**As a** {user type}
**I want to** {action}
**So that** {benefit}

**Acceptance Criteria:**
- [ ] {Specific testable criterion}
- [ ] {Specific testable criterion}

### Use Case 2: {Title}
...
```

Use cases should be:
- Specific and testable
- Cover different scenarios
- Have clear acceptance criteria

---

## Step 4: Feature Definition

**IMPORTANT: Every feature listed WILL be implemented. No priorities, no maybes.**

Define two categories only:

**Features (WILL be built):**
- Everything listed here gets implemented
- Each feature has acceptance criteria that MUST be met
- If you're not sure it should be built, don't list it

**Out of Scope (will NOT be built):**
- Explicitly excluded features
- Prevents scope creep
- Makes boundaries clear

**Feature Template:**
```markdown
### Feature: {Name}

**Description:**
{What the feature does}

**Acceptance Criteria:**
- [ ] {Testable requirement 1}
- [ ] {Testable requirement 2}
- [ ] {Testable requirement 3}

**User Interaction:**
{How user interacts with this feature}
```

**"Best in Class" Features to Include:**

When defining features, include these where applicable:
- Keyboard shortcuts for power users
- Clipboard integration (paste input, copy output)
- Instant feedback (no waiting for local operations)
- Zero-config defaults (works immediately)
- Clear all/reset functionality
- Mobile-friendly touch interactions
- Dark/light theme support
- Responsive design (mobile, tablet, desktop)

---

## Step 5: UI/UX Requirements

Define the user interface requirements (not implementation).

**Layout Requirements:**
```markdown
## UI Requirements

### Layout
- {Description of major sections}
- {Relationship between sections}
- {Responsive behavior requirements}

### Components
- {Component 1}: {What it does, states it has}
- {Component 2}: {What it does, states it has}

### Interactions
- {User action} -> {Expected result}
- {User action} -> {Expected result}

### Accessibility
- {Specific accessibility requirements}
- {Keyboard navigation requirements}

### Mobile
- {Mobile-specific requirements}
- {Touch interaction requirements}
```

See [ux-checklist.md](references/ux-checklist.md) for AppDoesIt UX requirements.

---

## Step 6: Generate Product Specification

Create the final SPEC.md document.

**Required Sections:**
1. App Identity (name, slug, value proposition)
2. Target Audience (persona)
3. Use Cases (5 with acceptance criteria)
4. Features (complete list - everything WILL be built)
5. UI/UX Requirements
6. Out of Scope (explicit exclusions)
7. FAQ (5 Q&A pairs, with standard i18n key contract)

**Save to:** `apps/{slug}/SPEC.md`

See [specification-template.md](references/specification-template.md) for complete template.

---

## Specification Quality Checklist

Before finalizing, verify:

- [ ] **Clear value proposition** - One sentence explaining the app's value
- [ ] **5 use cases defined** - Each with acceptance criteria
- [ ] **All features are definitive** - No "could", "should", "might" language
- [ ] **Acceptance criteria are requirements** - MUST be met, not suggestions
- [ ] **UI requirements clear** - Without prescribing implementation
- [ ] **Out of scope explicit** - What we're NOT building
- [ ] **FAQ included** - 5 Q&A pairs defined and mapped to standard i18n keys (`faqTitle`, `faq1Q`/`faq1A` … `faq5Q`/`faq5A`)
- [ ] **User approved** - User has reviewed and approved the complete spec

---

## Handling Requirement Changes

When requirements change during development:

1. **Document the change** in SPEC.md
2. **Update acceptance criteria** if affected
3. **Notify Project Manager** of the change
4. **Re-prioritize** if needed

---

## Output Format

The Product Owner delivers:

1. **SPEC.md** - Complete, definitive product specification
2. **User Approval** - Confirmation user agrees with the spec

The specification is a contract:
- **Everything in SPEC.md WILL be implemented**
- **Every acceptance criterion WILL be met**
- **Nothing outside SPEC.md will be built**
- Any developer can understand exactly WHAT to build
- Questions about requirements can be answered by reading the spec

---

## Completion Message

**IMPORTANT:** When the specification is complete and saved, end with this exact message:

```
Specification complete and saved to `apps/{slug}/SPEC.md`.

To implement this app, run: `/project-manager implement apps/{slug}`
PM tracking note: execution details go into `docs/work_logs/*.md`; `apps/{slug}/PROJECT.md` stays high-level.
```

**DO NOT:**
- Start implementing the app
- Create any code files
- Modify any configuration files
- Suggest "let me start building this"

The Product Owner's job is DONE when SPEC.md is written and approved.

---

## Reference Files

- [specification-template.md](references/specification-template.md) - SPEC.md template
- [feature-analysis-guide.md](references/feature-analysis-guide.md) - Feature prioritization
- [ux-checklist.md](references/ux-checklist.md) - UX requirements checklist
- [assets/spec-example.md](assets/spec-example.md) - Complete example

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /product-owner
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/product-owner, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
