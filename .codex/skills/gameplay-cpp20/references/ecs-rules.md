# ECS Rules

Use EnTT as the gameplay data model, but keep it disciplined.

## Components

- Keep components mostly plain data.
- Prefer tags for marker state.
- Separate serialized state from transient runtime state when useful.
- Avoid storing heavy ownership or service objects directly in components unless justified.

## Systems

- Put behavior in systems.
- Operate on clear component sets.
- Keep system side effects narrow and intentional.
- Make dependencies between systems explicit through scheduling or structure.

## Entity Lifetime

- Avoid long-lived raw references to components.
- Be careful when storing entity identifiers across teardown points.
- Centralize spawn/despawn patterns once ad hoc creation starts to spread.
