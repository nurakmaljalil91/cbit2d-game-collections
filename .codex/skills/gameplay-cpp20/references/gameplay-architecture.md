# Gameplay Architecture

Keep game behavior in the game repository and treat the engine as a dependency.

## Gameplay Responsibilities

- Rules and win/loss logic
- Ability resolution
- AI and turn sequencing
- Scene-specific flow
- Spawning rules and prefab composition
- Content-specific data and balancing

## Seam Rules

- Use engine APIs as stable services.
- Request a small engine interface change when a gameplay need is broadly reusable.
- Do not duplicate engine systems in game code unless the duplication is a deliberate temporary stopgap.
- Avoid teaching the engine about a single game's terminology or rules.
