## Purpose

Render and interact with layout-driven Cbit2d UI widgets using their computed rectangles and normalized application input.

## ADDED Requirements

### Requirement: Layout-driven widget rendering
The UI system SHALL render panels, text, and buttons using the rectangles computed by the UI layout system.

#### Scenario: Button visual bounds match layout bounds
- **WHEN** a button is arranged in a UI tree
- **THEN** its background, border, and label are rendered within its computed rectangle

### Requirement: Layout-driven pointer interaction
The UI system SHALL determine hover and pointer activation from computed widget rectangles in the logical UI coordinate space.

#### Scenario: Resized button remains clickable
- **WHEN** a button is repositioned by a viewport reflow and the user presses the pointer inside its new computed rectangle
- **THEN** the button invokes its configured activation callback once

#### Scenario: Pointer outside button does not activate it
- **WHEN** the user presses the pointer outside a button's computed rectangle
- **THEN** that button does not invoke its activation callback

### Requirement: UI input precedence and clipping
The UI system SHALL deliver pointer interaction to the topmost eligible visible widget and SHALL not interact with content outside an active clipping region.

#### Scenario: Overlapping buttons
- **WHEN** two eligible buttons overlap in an overlay and the user presses their shared area
- **THEN** only the topmost button receives the activation

#### Scenario: Clipped child
- **WHEN** a button lies outside its parent's active clipping region
- **THEN** pointer input in the button's unclipped area does not activate it

### Requirement: Engine-integrated rendering boundary
The UI system SHALL render through Cbit2d's rendering boundary without exposing backend-specific rendering or layout-library types in game-facing UI declarations.

#### Scenario: Game creates a button
- **WHEN** a game scene declares a UI button and callback through the public UI API
- **THEN** it does not need to reference SDL or the selected layout library types
