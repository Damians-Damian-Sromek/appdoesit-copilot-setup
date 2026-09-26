# Interface Design Principles

These principles define the quality floor for interface direction work.

## Intent First

Before designing, define:
- Who is the human user in this moment
- What they must accomplish
- How the interface should feel

If this is unclear, gather clarity first. Do not default to generic templates.

## Domain-Driven Direction

Always produce:
1. Domain concepts and vocabulary (5+)
2. Color world grounded in that domain (5+)
3. Signature element unique to this product
4. Default choices to avoid (3+) and replacements

Direction must reference all four outputs.

## Anti-Default Mandate

Defaults hide in:
- Typography treated as a neutral container
- Navigation treated as scaffolding
- Data treated as decoration
- Token names treated as implementation detail

Everything is design. Every key choice needs an explicit reason.

## Surface and Token Architecture

Build color/token systems from primitives:
- Foreground (text hierarchy)
- Background (surface elevation)
- Border (separation hierarchy)
- Brand
- Semantic (success/warning/error/destructive)

Do not introduce random hex values. Map decisions to primitives.

## Surface Elevation Hierarchy

Use a clear stacked system:
- Level 0: base canvas
- Level 1: cards and panels
- Level 2: dropdowns and popovers
- Level 3+: stacked overlays

In dark mode, higher layers are slightly lighter. In light mode, use subtle lift (color and/or shadow).

## Subtle Layering

Layering should be felt, not shouted:
- Elevation differences are small
- Borders are present but low-intensity
- Structure remains visible under squint test
- No harsh lines or dramatic jumps

## Text and Border Progression

Text should have at least four roles:
- Primary
- Secondary
- Tertiary
- Muted

Borders should also use graded intensity:
- Default
- Subtle
- Strong
- Stronger (focus/emphasis)

## Control-Specific Tokens

Define control tokens separately from layout tokens:
- Control background
- Control border
- Control focus

Inputs often need inset treatment distinct from cards/panels.

## Spacing and Rhythm

Choose a base unit and maintain multiples. Use context-aware scales:
- Micro spacing
- Component spacing
- Section spacing
- Major separation

Random spacing values are a system failure.

## Typography and Data

Separate text roles by size, weight, and spacing, not size alone.
Use monospace with tabular numbers for aligned data where needed.

## Depth Strategy

Pick one primary depth strategy and apply consistently:
- Borders-only
- Subtle shadows
- Layered shadows
- Surface color shifts

Do not mix depth strategies arbitrarily.

## States Are Mandatory

Every interactive component needs:
- Default
- Hover
- Active
- Focus
- Disabled

Data flows also need:
- Loading
- Empty
- Error

## Craft Checks

Run before delivery:
- Swap test
- Squint test
- Signature test
- Token test

Failing any check requires iteration before handoff.
