---
name: marketing-expert
description: Marketing analysis and promotion for AppDoesIt portal and apps. Use when researching competitors, finding promotion channels, or executing marketing actions. Analyzes app directories, Reddit, HN, forums, and search engines. Can generate and submit content to free channels. Works at both individual app level (calculator competitors) and portal level (multi-tool site competitors).
---

# Marketing Expert

Analyze competitors, identify promotion opportunities, and execute marketing actions for AppDoesIt portal and individual apps.

## Source of Truth

**All app information is defined in [AGENTS.md](../../../AGENTS.md).**

Before marketing work, read these AGENTS.md sections:
- `## Project Overview` - Understand what AppDoesIt is
- `### Apps Structure` - How apps are organized
- `config/apps.php` - Available apps and their metadata

**If requirements in this skill conflict with AGENTS.md, AGENTS.md takes precedence.**

---

## Consulting Other Skills

Consult other skills when you encounter questions outside your domain. Use the Task tool:

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /marketing-expert:
    Context: {marketing task}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| App requirements | `/product-owner` |
| SEO optimization | `/seo-expert` |
| Content implementation | `/programmer` |
| Translation of content | `/i18n-manager` |
| Visual assets | `/ui-expert` |

---

## When to Use This Skill

Trigger this skill when:
- Researching competitors for an app or the portal
- Finding places to promote (directories, communities, social)
- Creating marketing content (posts, submissions, outreach)
- Analyzing traffic sources or SEO opportunities
- Planning a launch or promotion campaign

## Opportunity Classification

| Level | Impact | Action |
|-------|--------|--------|
| **CRITICAL** | High traffic potential, low effort | Execute immediately |
| **WARNING** | Medium traffic, moderate effort | Execute within 1 week |
| **RECOMMENDATION** | Lower traffic or higher effort | Consider for future |

## Workflow: Analysis Mode

Use when researching competitors or identifying promotion opportunities.

### Step 1: Define Scope

Determine analysis level:
- **App-level**: Specific app (e.g., "Calculator app competitors")
- **Portal-level**: Entire portal (e.g., "Multi-tool site competitors")

### Step 2: Research Competitors

Use `webfetch` to find competitors (search results + competitor pages). If web access/search is unavailable, ask the user for 3-5 competitor URLs (or names) and proceed with those.

**For app-level:**
```
"free online [app-type]" (e.g., "free online calculator")
"[app-type] tool" site:producthunt.com
"[app-type]" site:alternativeto.net
```

Example (DuckDuckGo HTML results):
`https://duckduckgo.com/html/?q=free+online+{app-type}`

**For portal-level:**
```
"free online tools" collection
"web tools" site:producthunt.com
multi-tool sites like 10015.io
```

Analyze each competitor for:
- Features offered
- Traffic sources (use SimilarWeb free tier if available)
- Directory presence (Product Hunt, AlternativeTo)
- Social presence (Reddit mentions, Twitter)
- Backlink sources

### Step 3: Identify Channels

Use [promotion-channels.md](references/promotion-channels.md) to find relevant channels:
- App directories matching the app category
- Reddit subreddits for target audience
- Forums and communities
- SEO keyword opportunities

### Step 4: Prioritize Opportunities

Create opportunity matrix using [report-template.md](references/report-template.md):

| Channel | Effort | Impact | Priority |
|---------|--------|--------|----------|
| Product Hunt | Medium | High | CRITICAL |
| r/webdev | Low | Medium | WARNING |
| ... | ... | ... | ... |

### Step 5: Generate Report

Output marketing report to `var/tmp/marketing/{app-slug}/`:
- `analysis.md` - Competitor and channel analysis
- `plan.md` - Marketing action plan
- For portal-level: use `var/tmp/marketing/portal/`

## Workflow: Execution Mode

Use when performing marketing actions.

### Step 1: Select Action

Choose from [action-checklist.md](references/action-checklist.md):
- Directory submission
- Reddit/HN post
- Social media content
- Backlink outreach
- SEO optimization

### Step 2: Gather App Information

Read app metadata from `config/apps.php`:
- App name, description, slug
- Category and features
- Target keywords

For portal-level, use AGENTS.md project overview.

### Step 3: Generate Content

Create channel-appropriate content:

**Directory submission:**
- Title (60 chars max)
- Tagline (100 chars max)
- Description (300-500 words)
- Screenshots list (suggest which to capture)
- Category tags

**Reddit/HN post:**
- Title following subreddit rules
- Body with value proposition
- Appropriate flair/tags

**Social media:**
- Twitter/X thread (280 chars per tweet)
- LinkedIn post (professional tone)
- Key hashtags

**Outreach email:**
- Subject line
- Personalized introduction
- Value proposition
- Clear CTA

### Step 4: Execute or Save

**For directories with forms (Automated Submission):**
- Use the `/playwright-mcp-extension-operator` skill to submit directly
- No need for user confirmation on field-by-field filling
- Confirm only the final submission action (after reviewing the filled form)
- Save confirmation to `var/tmp/marketing/{app-slug}/submissions/{channel}.md`

**For social platforms (Automated Posting):**
- Use the `/playwright-mcp-extension-operator` skill to post directly
- Confirm the exact post copy before clicking final "Post/Share" action
- Automatically proceed with posting after confirmation
- Save posted content to `var/tmp/marketing/{app-slug}/posts/{platform}.md`

**For outreach (Semi-automated):**
- Generate email template
- Save to `var/tmp/marketing/{app-slug}/outreach/{target}.md`
- Use playwright-mcp to submit forms if applicable (otherwise manual sending)

**For simple form fields:**
- Pre-fill all non-sensitive form fields automatically using playwright-mcp
- Only request confirmation for actions that cannot be undone (final submission/publish)

### Step 5: Track Progress

Update action checklist with:
- Submission date
- Status (pending, approved, rejected)
- URL if published
- Notes

## Workflow: State Documentation Mode

Use when recording marketing activity or checking current marketing state.

### When to Use

- After executing any marketing action (submission, post, outreach)
- When reviewing marketing performance for an app
- When planning next marketing steps based on what's been done
- When the user asks "what marketing have we done?" or similar

### Step 1: Check Existing State

Read existing `var/tmp/marketing/{app-slug}/status.md` (if exists).

### Step 2: Record Action Results

Update status.md with:
- Action taken (channel, type)
- Date executed
- Status (Submitted/Live/Rejected/Pending)
- URL (if published)
- Engagement metrics (upvotes, comments, clicks)
- Notes/learnings

### Step 3: Update Performance Metrics

If analytics or search data available, update:
- Referral traffic from marketing channels
- Search keyword rankings
- Total engagement across channels

### Step 4: Identify Learnings

Document:
- What worked well (high engagement, good reception)
- What didn't work (rejected, low engagement)
- Adjustments for future actions

### Step 5: Prioritize Next Actions

Based on performance data, update recommended next actions list.

## Visual Assets Creation

Marketing materials often require graphics. Two primary approaches:

### Option 1: App Screenshots (Recommended)

Capture the actual app in action - authentic and accurate.

**Using Playwright (automated):**
```bash
# Run inside Docker
docker exec -it appdoesit-web bash
cd /app && npx playwright screenshot http://localhost/{app-slug} var/tmp/marketing/{app-slug}-screenshot.png --full-page
```

**Using QA Expert:**
```
Task tool:
  description: "Capture {app-slug} screenshots"
  prompt: |
    You are the /qa-expert specialist.
    CONSULTATION from /marketing-expert:
    Context: Need marketing screenshots for {app-slug}
    Request: Capture screenshots showing:
    - Main app interface (light theme)
    - Main app interface (dark theme)
    - Key feature in action (e.g., calculation result, conversion output)
    Save to: var/tmp/marketing/{app-slug}/
```

**Screenshot best practices:**
- Capture both light and dark themes
- Show the app with realistic data/examples
- Include the result/output state (not empty forms)
- Use 1280x720 or 1920x1080 resolution
- Crop to focus on the app, remove browser chrome if needed

### Option 2: AI-Generated Graphics

Use AI image generators for promotional banners, social media graphics, or abstract visuals.

**Recommended AI tools:**
- **DALL-E** (via ChatGPT) - Good for conceptual graphics
- **Midjourney** - High-quality artistic images
- **Ideogram** - Best for text in images (logos, banners)
- **Canva AI** - Templates with AI enhancement

**Prompt templates for AI graphics:**

```
# App Feature Banner
"Clean minimal web app interface showing [feature],
modern UI design, soft gradient background,
professional software screenshot style, 16:9 aspect ratio"

# Social Media Promo
"Modern tech promotional graphic for [app type],
abstract geometric shapes, brand colors [colors],
clean professional design, Instagram post format"

# Icon/Logo
"Simple flat icon representing [concept],
single color on transparent background,
minimalist design, app icon style"
```

**When to use AI graphics:**
- Social media promotional posts
- Blog post header images
- Abstract concept illustrations
- When screenshots don't convey the value well

**When NOT to use AI graphics:**
- Directory submissions (use real screenshots)
- Product Hunt (authenticity matters)
- Technical documentation

### Storing Visual Assets

```
var/tmp/marketing/{app-slug}/
  assets/
    screenshots/           # Real app screenshots
      main-light.png
      main-dark.png
      feature-demo.png
    graphics/              # AI-generated or designed
      social-banner.png
      twitter-card.png
      promo-square.png
```

Create directory: `mkdir -p var/tmp/marketing/{app-slug}/assets/{screenshots,graphics}`

## Integration with Playwright MCP Extension Operator

When using the `/playwright-mcp-extension-operator` skill for marketing actions, follow its **Autonomous Execution Policy** (canonical rules: fill forms autonomously, confirm only before irreversible actions such as final submission or publishing, error-recovery and tracking behavior).

Marketing-specific additions on top of that policy:
- Record every execution in `var/tmp/marketing/{app-slug}/status.md` (timestamp, channel, URL)
- Keep all generated content under `var/tmp/marketing/{app-slug}/` (submissions, posts, outreach)

---

## Reference Files

- [competitor-analysis-guide.md](references/competitor-analysis-guide.md) - Detailed competitor research methodology
- [promotion-channels.md](references/promotion-channels.md) - Free channels by category
- [report-template.md](references/report-template.md) - Marketing report format
- [action-checklist.md](references/action-checklist.md) - Execution checklists

## Output Location

All marketing outputs go to `var/tmp/marketing/`:
```
var/tmp/marketing/
  portal/                     # Portal-level marketing
    analysis.md               # Competitor analysis
    plan.md                   # Marketing plan
    status.md                 # Marketing state & results
    submissions/              # Directory submissions
    posts/                    # Social media posts
  {app-slug}/                 # Per-app marketing
    analysis.md               # Competitor analysis
    plan.md                   # Marketing plan
    status.md                 # Marketing state & results
    submissions/              # Directory submissions
      producthunt.md
      alternativeto.md
    posts/                    # Social media posts
      reddit.md
      twitter.md
    outreach/                 # Outreach emails
      {target}.md
```

Create directories as needed:
```bash
mkdir -p var/tmp/marketing/{app-slug}/{submissions,posts,outreach}
```

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /marketing-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/marketing-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
