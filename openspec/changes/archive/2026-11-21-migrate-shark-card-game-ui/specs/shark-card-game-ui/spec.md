## Purpose

Provide SharkCardGame with a responsive screen interface using Cbit2d's retained UI while leaving gameplay-table entities under ECS control.

## ADDED Requirements

### Requirement: Retained menu UI
SharkCardGame SHALL present its title, instructional subtitle, and Play action through the Cbit2d retained UI API rather than screen-space ECS text or button entities.

#### Scenario: Start a game from the menu
- **WHEN** the player activates Play
- **THEN** the game invokes the existing transition into the play scene

#### Scenario: Resize the menu
- **WHEN** the application viewport changes while the menu is active
- **THEN** the menu title, subtitle, and Play action reflow without scene code recalculating absolute coordinates

### Requirement: Retained gameplay screen UI
SharkCardGame SHALL render its gameplay title, instructions, match HUD, betting controls, and match-finished dialog through a Cbit2d retained UI tree.

#### Scenario: Gameplay state refresh
- **WHEN** the current match phase, player state, bet selection, or round result changes
- **THEN** the retained UI reflects the corresponding text, visibility, and control state before the next frame is rendered

#### Scenario: Responsive gameplay layout
- **WHEN** the application viewport changes while the play scene is active
- **THEN** the screen UI reflows while the card table remains managed by its existing ECS rendering and drag/drop behavior

### Requirement: Betting controls preserve game actions
SharkCardGame SHALL preserve the existing Pass, 5, 10, 20, Confirm, Menu, and New Game actions through retained UI controls.

#### Scenario: Local player may choose a bet
- **WHEN** it is the local player's betting turn
- **THEN** the player can select a betting option and confirm it through the retained UI

#### Scenario: Ineligible bet controls
- **WHEN** it is not the local player's betting turn or no betting option is selected for confirmation
- **THEN** the affected retained UI controls are visibly disabled and do not invoke their game actions

### Requirement: Match completion dialog
SharkCardGame SHALL show a centered modal match-completion dialog containing the result summary and New Game action when the match finishes.

#### Scenario: Match finishes
- **WHEN** the match enters its finished phase
- **THEN** the dialog appears above the gameplay screen UI and exposes the New Game action

#### Scenario: Match is active
- **WHEN** the match is not finished
- **THEN** the match-completion dialog is not visible and does not receive pointer input
