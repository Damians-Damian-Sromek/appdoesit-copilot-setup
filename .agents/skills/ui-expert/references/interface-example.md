# Interface Design Example Notes

This reference explains how subtle layering choices translate into concrete interface decisions.

## Subtle Layering Mindset

Well-crafted systems make structure obvious without visual noise. Users should feel hierarchy without noticing decorative mechanics.

## Surface Decisions

Keep elevation changes narrow and intentional:
- Small lightness steps between stacked surfaces
- Consistent hue family across related layers
- No dramatic jumps unless intentionally signaling a distinct mode/state

## Border Decisions

Use borders for structure, not decoration:
- Low-intensity borders define regions quietly
- Increase border emphasis only when hierarchy demands it

Arm's-length test:
- If borders are the first thing you notice, reduce intensity.
- If boundaries disappear completely, increase slightly.

## Sidebar Decisions

Use same-canvas sidebars when product context benefits from a unified workspace.
Use boundary lines and spacing to separate regions instead of abrupt color blocks.

## Overlay Decisions

Dropdowns/popovers should read as layers above parent surfaces:
- Slightly elevated surface tone
- Slightly stronger containment edge when needed

## Input Decisions

Inputs should read as interactive receiving surfaces:
- Often inset compared with surrounding panels
- Focus states clear but not aggressive

## Adapt by Product Context

Values vary by product, but principles stay stable:
- Distinction without noise
- Consistent elevation logic
- Meaningful use of emphasis

## Quick Validation

Run squint test:
1. Blur the interface visually.
2. Confirm hierarchy still reads.
3. Confirm no element shouts for attention without purpose.
