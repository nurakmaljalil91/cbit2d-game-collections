---
name: engine-cpp20
description: Design, implement, and review reusable C++20 engine and library code for Cbit2d. Use when working on engine architecture, SDL3/platform boundaries, rendering systems, resource management, public APIs, subsystem lifetimes, or refactoring code toward a clean reusable engine/library instead of game-specific logic.
---

# Engine C++20

Keep `Cbit2d/` engine code reusable, game-agnostic, and maintainable with disciplined modern C++20.

## Quick Start

- Work in `Cbit2d/` unless the task explicitly requires another repository.
- Optimize for library-quality code and stable game-facing APIs.
- Keep SDL3 and platform-specific details near runtime boundaries.
- Use modern C++20 to improve ownership clarity, correctness, and maintainability rather than for novelty.
- Avoid introducing gameplay rules, game-specific content, or sample-only assumptions into engine modules.

## Working Rules

- Define explicit subsystem boundaries before changing cross-cutting engine code.
- Favor narrow public interfaces over exposing internals for convenience.
- Prefer RAII, value semantics, `std::span`, `std::string_view`, and strongly typed parameters when they simplify ownership and call sites.
- Keep resource ownership and lifetime obvious at API boundaries.
- Isolate rendering, platform, and asset-loading concerns instead of mixing them into gameplay-facing abstractions.
- Preserve migration paths when changing an engine API that game code may consume.

## C++20 Guidance

- Use move semantics and scoped ownership to make lifetime visible in types.
- Prefer standard-library facilities before adding custom utility layers.
- Use concepts, ranges, coroutines, or heavy template machinery only when they clearly improve the design instead of obscuring it.
- Keep headers lightweight and avoid leaking implementation dependencies through public includes.
- Treat compile-time cleverness as a cost unless it removes real runtime or maintenance problems.

## Boundary Checklist

Before finalizing an engine change, confirm:

- The code remains reusable by multiple game repositories.
- The engine does not depend on game-specific scenes, rules, or content.
- SDL3-specific code stays close to platform and runtime edges.
- Resource management does not hide lifetime or ownership.
- Public APIs are small, explicit, and documented by usage.

## References

- Read `references/boundaries.md` when changing module seams or shared abstractions.
- Read `references/cpp20-guidelines.md` when a design decision depends on ownership, APIs, or modern language features.
- Read `references/review-checklist.md` before reviewing or landing non-trivial engine refactors.
