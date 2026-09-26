# Marketing Action Checklists

## Directory Submission Checklist

### Pre-Submission

- [ ] App/portal is live and working
- [ ] All features are functional
- [ ] Mobile-responsive design verified
- [ ] Load time is acceptable (<3s)
- [ ] No obvious bugs or errors

### Content Preparation

- [ ] Title written (60 chars max)
- [ ] Tagline written (100 chars max)
- [ ] Full description written (300-500 words)
- [ ] Category/tags identified
- [ ] Screenshots captured (3-5 recommended)
- [ ] Logo/icon available if needed

### Submission

- [ ] Account created on directory
- [ ] All required fields filled
- [ ] Screenshots uploaded
- [ ] Links verified working
- [ ] Preview checked before submit

### Post-Submission

- [ ] Confirmation received
- [ ] Submission date logged
- [ ] Follow-up date set (if needed)
- [ ] Status tracked in report

---

## Product Hunt Launch Checklist

### 2 Weeks Before

- [ ] Hunter identified (or self-hunt planned)
- [ ] Product Hunt account verified
- [ ] Community engagement started (upvote others, comment)
- [ ] Launch date selected (Tuesday-Thursday best)

### 1 Week Before

- [ ] All assets ready (logo, screenshots, video if applicable)
- [ ] Description finalized
- [ ] First comment drafted (maker intro)
- [ ] Support team ready to respond to comments

### Launch Day

- [ ] Post live at 12:01 AM PT
- [ ] First comment posted immediately
- [ ] Social media announcement sent
- [ ] Email to supporters (if applicable)
- [ ] Monitor and respond to all comments
- [ ] Thank upvoters

### Post-Launch

- [ ] Results analyzed
- [ ] Lessons documented
- [ ] Follow-up content planned

---

## Reddit Post Checklist

### Pre-Post

- [ ] Subreddit rules read
- [ ] Recent posts checked (avoid duplicates)
- [ ] Account has karma (if required)
- [ ] Best posting time identified
- [ ] Flair requirements checked

### Content

- [ ] Title follows subreddit conventions
- [ ] Body provides value (not just self-promo)
- [ ] Links are allowed per rules
- [ ] Images/screenshots prepared (if allowed)

### Post

- [ ] Posted at optimal time
- [ ] Flair added
- [ ] Ready to respond to comments

### Post-Post

- [ ] Monitor comments for 24-48 hours
- [ ] Respond to questions quickly
- [ ] Thank users for feedback
- [ ] Note any feedback for product improvement

---

## Hacker News Submission Checklist

### Pre-Submission

- [ ] Content is genuinely interesting to HN audience
- [ ] Title is factual (no clickbait)
- [ ] Timing is right (US morning, weekday)
- [ ] Account in good standing

### Submission

- [ ] "Show HN:" prefix if showing your creation
- [ ] Title is clear and concise
- [ ] Ready to respond to comments immediately

### Post-Submission

- [ ] First comment prepared (if Show HN)
- [ ] Monitor for questions
- [ ] Respond thoughtfully to criticism
- [ ] Don't ask for upvotes

---

## Social Media Content Checklist

### Twitter/X

- [ ] Tweet within 280 chars
- [ ] Visual attached (screenshot, GIF)
- [ ] Relevant hashtags (2-3 max)
- [ ] Call to action included
- [ ] Link shortened if needed
- [ ] Thread planned (if longer content)

### LinkedIn

- [ ] Professional tone
- [ ] Value proposition clear
- [ ] Relevant to professional audience
- [ ] Hashtags appropriate
- [ ] Posted during business hours

### Mastodon

- [ ] Instance-appropriate content
- [ ] Alt text on images
- [ ] CW tags if needed
- [ ] Relevant hashtags

---

## Backlink Outreach Checklist

### Research

- [ ] Target sites identified
- [ ] Contact person found
- [ ] Site relevance verified
- [ ] Existing backlink opportunities identified (broken links, resource pages)

### Email Content

- [ ] Personalized greeting
- [ ] Reference to their content
- [ ] Clear value proposition
- [ ] Specific ask (what link, where)
- [ ] Professional signature

### Outreach

- [ ] Email sent
- [ ] Follow-up scheduled (7-10 days)
- [ ] Response tracked
- [ ] Relationship noted for future

---

## SEO Optimization Checklist

### On-Page

- [ ] Title tag optimized (60 chars, keyword included)
- [ ] Meta description written (155 chars, compelling)
- [ ] H1 contains primary keyword
- [ ] Content includes related keywords naturally
- [ ] Images have alt text
- [ ] Internal links added
- [ ] External links to authoritative sources

### Technical

- [ ] Page loads fast (<3s)
- [ ] Mobile-friendly
- [ ] HTTPS enabled
- [ ] Structured data (JSON-LD) added
- [ ] Sitemap includes page
- [ ] No broken links

### Content

- [ ] Unique content (not duplicate)
- [ ] Answers user intent
- [ ] Comprehensive coverage
- [ ] Updated/fresh

---

## Content Creation Checklist

### Blog Post

- [ ] Topic researched (keyword volume, competition)
- [ ] Outline created
- [ ] Draft written
- [ ] Images/screenshots added
- [ ] Internal links included
- [ ] Meta tags optimized
- [ ] CTA included

### Tutorial/Guide

- [ ] Steps are clear and numbered
- [ ] Screenshots at each step
- [ ] Common issues addressed
- [ ] Tested by someone else

### Comparison Article

- [ ] Fair comparison (not biased)
- [ ] Criteria clearly defined
- [ ] Table/matrix included
- [ ] Conclusion with recommendation

---

## Recording Results Checklist

After ANY marketing action, update `status.md`:

### For Directory Submissions

- [ ] Add row to Directory Submissions table
- [ ] Record: Directory name, submission date, status
- [ ] If approved: Add live URL and initial engagement
- [ ] Note any feedback or category placement
- [ ] Update Quick Summary counts

### For Social Posts

- [ ] Add row to Social Posts table
- [ ] Record: Platform, post date, URL
- [ ] After 24-48h: Update engagement metrics (upvotes, comments, shares)
- [ ] Note audience feedback themes
- [ ] Update Social Learnings if new insights

### For Outreach

- [ ] Add row to Outreach table
- [ ] Record: Target, send date
- [ ] When response received: Update outcome
- [ ] Schedule follow-up if no response (7-10 days)
- [ ] Note effective pitch angles

### Monthly Review

- [ ] Update referral traffic from analytics
- [ ] Check and update search keyword positions
- [ ] Calculate success rates for Quick Summary
- [ ] Update Learnings & Insights section
- [ ] Reprioritize Next Priority Actions
- [ ] Update "Last Updated" date

---

## Visual Assets Checklist

### Screenshots (Recommended for Authenticity)

- [ ] App is in polished, demo-ready state
- [ ] Realistic sample data entered (not "test" or "lorem ipsum")
- [ ] Light theme screenshot captured
- [ ] Dark theme screenshot captured (if app supports)
- [ ] Key feature/result state captured (not empty form)
- [ ] Resolution is 1280x720 or 1920x1080
- [ ] Browser chrome cropped out if needed
- [ ] Saved to `var/tmp/marketing/{app-slug}/assets/screenshots/`

**Capture Methods:**

1. **Playwright (automated):**
   ```bash
   npx playwright screenshot http://localhost/{app-slug} screenshot.png --full-page
   ```

2. **Browser DevTools:**
    - Open DevTools -> Cmd/Ctrl+Shift+P -> "Capture screenshot"
   - Set device dimensions for consistent sizing

3. **QA Expert consultation:**
   - Request multi-theme, multi-state screenshots
   - Get viewport-specific captures

### AI-Generated Graphics

- [ ] Purpose defined (social, banner, icon)
- [ ] Dimensions specified (1200x628 for Twitter/LinkedIn, 1080x1080 for Instagram)
- [ ] Brand colors referenced in prompt
- [ ] Generated image reviewed for accuracy
- [ ] No misleading UI mockups (if app doesn't look like that)
- [ ] Saved to `var/tmp/marketing/{app-slug}/assets/graphics/`

**Tool Selection:**

| Need | Recommended Tool |
|------|-----------------|
| Text in image | Ideogram |
| Artistic/creative | Midjourney |
| Quick conceptual | DALL-E / ChatGPT |
| Template-based | Canva AI |

### Asset Organization

- [ ] Directory structure created: `assets/{screenshots,graphics}/`
- [ ] Files named descriptively (e.g., `main-light.png`, `twitter-promo.png`)
- [ ] Multiple sizes prepared if needed (full, thumbnail)
- [ ] Assets referenced in submission docs

---

## Tracking Template

| Action | Channel | Date | Status | URL | Notes |
|--------|---------|------|--------|-----|-------|
| [Action] | [Channel] | YYYY-MM-DD | [Pending/Done/Rejected] | [URL] | [Notes] |
