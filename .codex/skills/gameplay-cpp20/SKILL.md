---
name: gameplay-cpp20
description: Design, implement, and review C++20 gameplay code using disciplined ECS patterns. Use when working on game rules, EnTT components and systems, scene behavior, entity spawning, update order, state transitions, AI, interactions, or game-specific feature implementation that should consume engine APIs without redesigning engine internals.
---

# Gameplay C++20

Keep gameplay code explicit, ECS-friendly, and clearly separated from reusable engine code.

## Quick Start

- Work in the game repository unless the task explicitly targets `Cbit2d/`.
- Keep gameplay rules, progression, and content in game code.
- Consume engine services through clean APIs instead of reaching into engine internals.
- Use modern C++20 to improve readability, correctness, and ownership clarity in gameplay systems.
- Prefer EnTT patterns that keep components small and systems focused.

## Working Rules

- Keep components mostly plain data.
- Put behavior in systems and keep system responsibilities narrow.
- Make update order explicit when one gameplay system depends on another.
- Centralize spawn, teardown, and scene setup patterns when complexity grows.
- Keep transient runtime state separate from long-lived gameplay state when that improves clarity.
- Push engine API changes back to the engine layer instead of patching around missing capabilities inside gameplay code.

## C++20 Guidance

- Use standard-library types and value semantics by default.
- Keep ownership-heavy resources out of components unless there is a clear reason and lifetime model.
- Prefer readable data flow over meta-programming or overly generic helpers.
- Use helper abstractions only when they reduce repeated gameplay boilerplate without hiding system behavior.
- Keep gameplay code easy to inspect during debugging and iteration.

## ECS Checklist

Before finalizing gameplay work, confirm:

- Components remain small and understandable.
- Systems have clear inputs and side effects.
- Update order is documented by structure or scheduling.
- Entity lifetime is controlled during spawn and teardown.
- Game logic consumes engine APIs without depending on engine internals.

## References

- Read `references/ecs-rules.md` when adding or refactoring EnTT components and systems.
- Read `references/gameplay-architecture.md` when organizing scenes, game rules, or multi-system features.
- Read `references/review-checklist.md` before reviewing or landing non-trivial gameplay changes.
