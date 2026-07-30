## Why

Cbit2d's current ECS UI renders text and buttons at scene-supplied pixel coordinates. It cannot preserve menu composition when the viewport changes size or enters fullscreen, and each scene must manually calculate positions.

## What Changes

- Add a retained, responsive UI capability to Cbit2d, backed internally by Yoga flexbox layout.
- Provide a game-facing UI tree with panels, text, and buttons, plus row, column, and overlay composition.
- Reflow UI against the current logical viewport after resize, fullscreen, and UI-content changes.
- Add UI input routing and rendering that use computed layout rectangles rather than ECS transforms.
- Migrate the sandbox menu scene to prove centered responsive layout.
- Keep Yoga and SDL renderer types out of the game-facing UI API.

## Capabilities

### New Capabilities

- `responsive-ui-layout`: Retained UI trees that compute responsive widget rectangles from the viewport and layout constraints.
- `ui-interaction-and-rendering`: Rendering and pointer interaction for layout-driven UI widgets.

### Modified Capabilities

- None.

## Impact

- Affected engine areas: application/window viewport handling, input, ECS UI migration boundary, rendering, CMake dependencies, and sandbox menu scene.
- Adds Yoga as a private Cbit2d dependency.
- Introduces a new public `cbit::ui` API; existing ECS `TextComponent` and `ButtonComponent` remain available during migration but are no longer the preferred UI path.
