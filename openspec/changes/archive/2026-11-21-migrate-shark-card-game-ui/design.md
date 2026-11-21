## Context

See proposal.md for motivation. Cbit2d already owns one retained `UiContext` per scene and drives its viewport, update, and rendering lifecycle. SharkCardGame currently creates its menu and screen-facing gameplay UI as ECS text/button entities positioned for a fixed 1280x720 viewport; cards, board slots, and drag/drop also use ECS but are gameplay-world content.

The public UI tree has row, column, panel, overlay, text, and button widgets. It currently lacks semantic overlay stacking, text wrapping, and disabled buttons, all of which the game requires for a responsive modal and status-heavy betting screen.

## Goals / Non-Goals

**Goals:**

- Make Cbit UI the single screen-UI path for both SharkCardGame scenes.
- Preserve game callbacks and model-driven UI refresh behavior.
- Add the smallest general-purpose Cbit UI API needed for the game: modal layering, wrapped text, and disabled button behavior.
- Keep gameplay-world entities and their rendering/input systems unchanged.

**Non-Goals:**

- Redesigning SharkCardGame gameplay, rules, card art, or board geometry.
- Moving cards, slots, or drag/drop into Cbit UI.
- Adding a general style-sheet, focus-navigation, or text-input system.

## Decisions

### Retain one UI tree per scene

`MenuScene` and `PlayScene` will declare their screen UI through `getUi()`. `PlaySceneUi` will create named tree sections once and keep non-owning pointers/references to the widgets whose content, style, visibility, or enabled state changes during play. Widgets remain owned by their `UiContext`.

This replaces ECS object IDs for screen UI. Keeping ECS IDs would preserve two UI systems and undermine responsive layout. Rebuilding the whole tree each frame would be simpler initially but would discard retained-layout benefits and make callback/lifetime behavior harder to reason about.

### Separate UI layout from the gameplay table

The Cbit UI tree will provide a viewport-responsive header, status areas, betting controls, and modal layer. The existing ECS world remains responsible for table slots, cards, sprites, and drag/drop. The scene render order already places retained UI after the ECS world, so screen UI appears above the board without changing gameplay rendering.

### Add a true overlay layout primitive

Overlay children will share the overlay's available bounds and be rendered/input-tested in declaration order, with later children on top. This supports the modal dialog without altering the layout of header and betting sections. An alternative of hiding the normal HUD and putting the dialog in normal flow would avoid engine work but would make the dialog state structurally different and cannot guarantee topmost input precedence.

### Add constrained text and disabled button state to public UI types

Text will have an optional layout width constraint that drives wrapping and measured height. Buttons will expose an enabled/disabled state and disabled visual style; disabled buttons will not be eligible for hover activation or callbacks. Game-specific manual line breaks and callback-side guards were rejected because they do not provide reusable responsive behavior or consistent interaction semantics.

### Preserve model-driven refresh

The existing `PlaySceneUiModel` remains the source for per-frame presentation. Refresh will update retained widgets only when state-derived values change where practical; layout invalidation will be triggered for content and visibility changes. Betting availability is represented by disabled UI controls, not solely by visual colors.

## Risks / Trade-offs

- [Public UI API changes affect the shared Cbit2d submodule] → Add focused layout and interaction tests before migrating the game, then commit the submodule and parent pointer separately.
- [Text measurement differs from existing ECS text wrapping] → Validate long player names and round summaries at common window sizes.
- [Modal overlay could block all screen input unintentionally] → Test modal visibility transitions and pointer precedence against underlying buttons.
- [Retained widget pointers could be invalidated by tree replacement] → Build the tree once per scene lifetime and do not expose child removal during this change.

## Migration Plan

1. Extend and test Cbit2d UI support in its submodule.
2. Convert the menu, then the play-screen UI helper and static play controls.
3. Build and run SharkCardGame through its CMake integration; manually verify menu navigation, betting transitions, match completion, resize/fullscreen, and card drag/drop.
4. Commit the Cbit2d change in the submodule, commit SharkCardGame changes in its submodule, then commit updated submodule pointers and OpenSpec artifacts in the parent repository.

Rollback consists of reverting the SharkCardGame and Cbit2d commits independently, then restoring the parent repository's submodule pointers.
