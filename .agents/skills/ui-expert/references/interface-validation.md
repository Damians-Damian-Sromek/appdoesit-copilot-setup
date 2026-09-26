# Interface Design Validation and Reuse

Use this to decide what should become reusable AppDoesIt UI guidance.

## When to Update UI Guidelines

Update `docs/ui/UI-GUIDELINES.md` when a pattern is:
- Used in 2+ places
- Reusable across apps
- Backed by specific measurements/states worth standardizing

Do not document:
- One-off experiments
- Temporary artifacts
- Variants better represented as a small parameter change

## Suggested Pattern Entry Format

```markdown
### Component Name
- Purpose: ...
- Sizing: ...
- Spacing: ...
- States: default, hover, active, focus, disabled
- Token usage: ...
```

## Consistency Validation

If a pattern is documented, check implementations for:
- Spacing scale compliance
- Depth strategy consistency
- Token-based color usage
- State parity across similar components

## Reuse Rule

Before inventing a new component pattern:
1. Check `docs/ui/UI-GUIDELINES.md`
2. Reuse existing pattern if applicable
3. Extend only when existing pattern cannot support the use case

Document justified extensions to keep the system coherent over time.
