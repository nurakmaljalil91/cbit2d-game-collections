## Context

See proposal.md for motivation. The current ECS UI couples `TextComponent` and `ButtonComponent` to `TransformComponent`; `UISystem` uses those absolute positions both for rendering and hit-testing. `Application` owns the SDL window and renderer, while normalized input is provided by `core::Input`. No current engine service exposes a UI viewport or provides a hierarchical layout pass.

Cbit2d is a reusable C++20 SDL3 engine. The solution must be game-agnostic, keep SDL at the platform/rendering boundary, and avoid exposing dependency types in the public API.

## Goals / Non-Goals

**Goals:**

- Create a retained, scene-owned UI tree that reflows from current viewport dimensions.
- Use Yoga internally for mature flexbox layout while preserving a Cbit2d-native public API.
- Render and hit-test against a single computed UI rectangle source of truth.
- Prove the system by migrating the sandbox menu.
- Preserve the existing ECS UI path during the initial migration.

**Non-Goals:**

- A general-purpose web browser, HTML/CSS authoring, or visual UI editor.
- Replacing game-world sprites, cameras, or ECS transforms.
- Text entry, keyboard/gamepad focus navigation, scrolling, rich text, animation, accessibility, or theme serialization in the first increment.
- Modifying downstream game submodules.

## Decisions

### Separate retained UI tree from ECS

Scenes will own a `UiContext` or document containing parent-owned widgets. Widgets retain identity, children, visual state, callbacks, and their computed rectangles. This maps directly to layout hierarchy and avoids forcing parent-child ownership, child ordering, and event propagation into generic ECS components.

The current ECS UI remains operational during migration. New menus use the UI tree; removal or compatibility adaptation is a later explicit change.

Alternative considered: add layout components and parent references to ECS. This would make common UI operations depend on entity ordering and lifecycle coordination while providing no value to world-space gameplay entities.

### Use Yoga as a private layout backend

`cbit::ui` will translate its own size, alignment, padding, and container declarations to an internal Yoga node tree. Yoga calculates widget positions and sizes; Cbit2d copies those results into backend-independent rectangles used by rendering and interaction. Yoga nodes are owned and released with their widgets.

The public headers expose Cbit2d value types such as `UiLength`, `UiInsets`, `UiAlignment`, and `UiRect`; they do not include Yoga or SDL headers.

Alternative considered: Clay. Clay offers a compact immediate layout API, but its per-frame declaration and C macro model are a poorer fit for retained C++ widgets with scene lifetime and future focus/state requirements.

### Single logical UI coordinate space

The application provides the current logical UI viewport. Both layout and pointer positions use that coordinate space, with SDL drawable/high-DPI scaling handled only by the UI renderer/input adapter boundary. Resize and fullscreen changes mark each relevant UI context layout-dirty; layout is guaranteed before that context renders.

Alternative considered: use renderer pixel/output dimensions directly throughout UI. This risks mismatch between SDL mouse coordinates, logical window size, and high-DPI drawable size.

### Three-phase UI frame processing

For each scene frame: update UI input state, perform layout if dirty, then render widgets in tree order. Rendering receives computed rectangles and produces SDL draw operations. Pointer dispatch walks visible widgets in reverse paint order, respects clipping, and consumes the activation at the first eligible widget.

Text measurement will use the same font source as UI rendering so Yoga receives the measured preferred size. The initial render layer can reuse SDL_ttf-based text measurement and texture creation, with future text caching handled separately.

### Initial public widget set and layout rules

The first API provides `Panel`, `Text`, `Button`, `Row`, `Column`, and `Overlay`. Sizing supports auto/content, pixels, percentage, and grow; layout supports alignment, padding, gap, and min/max size. A root fills the viewport by default.

`Button` owns its visual state and callback. `Text` provides measurable content. `Panel` supplies background/border and optional clipping. Row/column/overlay are convenience containers expressed via common layout properties.

## Risks / Trade-offs

- [Yoga integration increases build and dependency complexity] → Add it through CMake as a private target and validate clean configure/build on supported platforms.
- [SDL logical and drawable sizes can diverge on high-DPI displays] → Define the logical UI viewport and coordinate conversion once; validate pointer and rendering alignment at normal and high-DPI scales.
- [Initial text rendering creates textures frequently] → Keep the first change behavior-focused; record text texture caching as a future performance enhancement after profiling.
- [Two UI paths can confuse adopters] → Document the retained UI API as preferred for screen UI and limit migration scope to the sandbox menu.
- [Layout invalidation bugs can produce stale rectangles] → Centralize dirty marking for viewport, constraints, child-tree, and text-content changes; add resize/layout tests.

## Migration Plan

1. Add Yoga as a private dependency and introduce the engine UI module alongside the current ECS UI.
2. Add viewport propagation and normalized UI input/render adapters.
3. Migrate `apps/sandbox/scenes/menu_scene.cpp` to a root-centered UI tree.
4. Validate responsive layout and input at representative window sizes and fullscreen.
5. Keep existing ECS UI components available. If a release blocker appears, the sandbox scene can return to the unchanged ECS path and the new UI module can be disabled at build integration level.

## Open Questions

- Select a concrete logical UI scaling policy for very small windows and high-DPI screens during implementation; it does not affect the API or required reflow behavior.
- Decide whether vcpkg or CMake FetchContent is the preferred dependency source based on the repository's existing third-party dependency policy.
