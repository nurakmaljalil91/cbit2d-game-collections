# Engine Boundaries

Use these boundaries when deciding whether code belongs in the engine.

## Engine Responsibilities

- Platform lifecycle
- Windowing and SDL3 integration
- Rendering abstractions
- Shared math, timing, logging, and diagnostics
- Asset and resource loading infrastructure
- ECS infrastructure only when it is generic and reusable
- Game-facing APIs intended for multiple projects

## Non-Engine Responsibilities

- Concrete game rules
- Specific enemies, cards, quests, or abilities
- Game-specific progression logic
- Scene logic tied to one title
- Temporary sample logic that leaks into reusable modules

## Seam Rules

- Let the engine define capabilities and abstractions.
- Let the game define behavior and content.
- If a game feature needs a new engine capability, add the smallest reusable engine API that supports it.
- Do not move game logic into the engine just because multiple systems call it.
- Keep adapters thin where game code bridges into engine services.
