## 1. Dependency and viewport foundation

- [x] 1.1 Add Yoga to the Cbit2d build as a private dependency and verify a clean supported-platform configure/build.
- [x] 1.2 Define and expose the application logical UI viewport, including resize and fullscreen invalidation notifications.
- [x] 1.3 Define the single logical UI coordinate conversion used by pointer input and SDL UI rendering, including high-DPI behavior.

## 2. Public UI model and Yoga layout bridge

- [ ] 2.1 Create the public `cbit::ui` value types for rectangles, lengths, insets, alignment, layout constraints, colors, and text style without exposing Yoga or SDL types.
- [ ] 2.2 Implement retained widget ownership, parent-child composition, visibility, layout invalidation, and safe Yoga-node lifetime management.
- [ ] 2.3 Implement panel, row, column, overlay, text, and button widgets with auto, fixed, percentage, grow, min/max, padding, gap, and alignment constraints.
- [ ] 2.4 Implement text measurement through the engine font path and feed the measured preferred size into layout.
- [ ] 2.5 Implement the measure-and-arrange pass and persist computed rectangles and clipping regions for each visible widget.

## 3. Rendering and interaction

- [ ] 3.1 Implement the SDL-backed UI renderer for panel backgrounds/borders, text, and button visual states from computed UI rectangles.
- [ ] 3.2 Implement reverse paint-order pointer hit testing that respects visibility and clipping.
- [ ] 3.3 Implement button hover, pressed, and single-activation callback behavior using normalized UI input.
- [ ] 3.4 Integrate UI update, reflow, and rendering with scene/application frame ordering while preserving existing ECS UI behavior.

## 4. Sandbox migration and validation

- [ ] 4.1 Migrate the sandbox menu title and Play button to a root-centered retained UI tree.
- [ ] 4.2 Add automated layout tests for centered, row/column, flexible sizing, invalidation, and clipping/hit-test behavior.
- [ ] 4.3 Manually validate the sandbox menu at small, default, ultrawide, resized, fullscreen, and high-DPI viewport configurations.
- [ ] 4.4 Add concise engine documentation showing the preferred responsive UI API and noting the legacy ECS UI migration path.
