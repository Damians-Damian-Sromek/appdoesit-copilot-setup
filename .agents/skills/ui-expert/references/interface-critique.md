# Interface Critique Protocol

Use this after a first-pass design direction or draft UI spec.

## The Gap

Correct is not crafted.
- Correct: layout aligns, spacing is consistent, styles compile.
- Crafted: decisions feel intentional, hierarchy is legible, identity is specific.

Critique closes the gap.

## Composition Review

Evaluate the page-level structure:
- Is there rhythm between dense and open regions?
- Do proportions communicate priority?
- Is there a clear focal point for the primary user action?

If everything has equal weight, hierarchy is not resolved.

## Craft Review

Inspect details:
- Spacing follows a clear grid and context-appropriate density
- Typography uses multiple levers (size, weight, tracking, contrast)
- Surface hierarchy is visible without harsh borders
- Interactive states exist and are coherent

## Content Coherence

Read visible text as a real user:
- Does the screen tell one coherent story?
- Are labels and data aligned to the same product context?

Visual polish cannot compensate for incoherent content.

## Structural Integrity

Find hidden hacks:
- Negative margins used as patchwork
- Absolute positioning used to escape layout flow
- Calc-heavy one-off offsets

Prefer clear layout structures over local workarounds.

## Mandatory Final Question

Before delivery, ask:
"If this lacks craft, what would a design lead call out first?"

Fix that issue, then re-check.

## Check Sequence

1. Swap test
2. Squint test
3. Signature test
4. Token test
5. Structural integrity pass

Do not finalize until all checks pass.
