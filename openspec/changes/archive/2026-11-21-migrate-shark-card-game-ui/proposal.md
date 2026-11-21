## Why

SharkCardGame still constructs its screen UI with ECS entities and fixed 1280x720 coordinates, even though Cbit2d now provides a retained, responsive UI library. Migrating it will make the game the first full consumer of that API and remove a separate screen-UI implementation path.

## What Changes

- Replace SharkCardGame's ECS-based menu, HUD, betting controls, and match-finished dialog with retained Cbit UI trees.
- Keep gameplay-world rendering and interaction—cards, slots, and drag/drop—in ECS.
- Make the play UI reflow from the active viewport instead of using fixed screen coordinates.
- Extend Cbit UI where required for a genuine modal overlay, wrapped status/summary text, and non-interactive disabled controls.
- Preserve all existing game actions and presentation states, including menu navigation, betting selection and confirmation, and starting a new match.

## Capabilities

### New Capabilities

- `shark-card-game-ui`: Responsive menu and gameplay UI for SharkCardGame built with the public Cbit UI API.

### Modified Capabilities

- `responsive-ui-layout`: Define true overlay placement and constrained text wrapping needed by game UI.
- `ui-interaction-and-rendering`: Define disabled controls and modal input precedence for Cbit UI.

## Impact

- SharkCardGame scene and UI helper sources will stop creating screen UI ECS entities and instead use `Scene::getUi()`.
- Cbit2d's public UI API, layout implementation, rendering, interaction handling, and UI tests will be updated.
- No gameplay rules, card ECS entities, or game assets are replaced; existing font assets continue to be used.
