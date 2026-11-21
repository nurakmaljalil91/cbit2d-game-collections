## 1. Extend Cbit UI layout and interaction

- [x] 1.1 Define public Cbit UI properties for stacked modal overlays, constrained/wrapped text, and enabled/disabled buttons with disabled visuals.
- [x] 1.2 Implement overlay layout so a viewport-filling modal layer stacks over, rather than reflows, the underlying retained UI.
- [x] 1.3 Implement wrapped text measurement and rendering within its configured layout width.
- [x] 1.4 Implement disabled button rendering and pointer exclusion, including modal overlay precedence over underlying controls.
- [ ] 1.5 Add focused Cbit2d UI tests for overlay placement/input precedence, wrapped text sizing, and disabled-button activation.

## 2. Migrate SharkCardGame menu and play UI

- [x] 2.1 Convert `MenuScene` title, subtitle, and Play button to a responsive retained Cbit UI tree; remove its screen-space ECS UI entities.
- [x] 2.2 Refactor `PlaySceneUi` to create and retain Cbit UI widgets instead of ECS UI entity IDs while preserving its model-driven refresh interface and callbacks.
- [x] 2.3 Convert play-scene static title, instructions, and Menu action to retained Cbit UI and remove the corresponding ECS screen UI entities.
- [x] 2.4 Build responsive retained layouts for phase/round/player status and betting controls; map game state to widget content, styles, visibility, and disabled states.
- [x] 2.5 Build the modal match-finished overlay with wrapped summary and New Game action, preserving current match-state transitions.
- [x] 2.6 Keep cards, board slots, dealing, and drag/drop ECS systems unchanged and remove obsolete empty UI wrapper methods and fields.

## 3. Verify and integrate submodule changes

- [ ] 3.1 Build and run Cbit2d UI tests and SharkCardGame from the parent workspace.
- [ ] 3.2 Manually verify menu navigation, resize/fullscreen reflow, betting selection/confirmation eligibility, match-finished modal input, New Game, and card drag/drop.
- [ ] 3.3 Commit Cbit2d changes inside its submodule, commit SharkCardGame changes inside its submodule, then commit the parent submodule-pointer and OpenSpec artifact updates.
