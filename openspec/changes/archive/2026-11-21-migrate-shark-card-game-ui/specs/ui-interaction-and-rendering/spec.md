## MODIFIED Requirements

### Requirement: UI input precedence and clipping
The UI system SHALL deliver pointer interaction to the topmost eligible visible and enabled widget and SHALL not interact with content outside an active clipping region. A visible modal overlay SHALL receive eligible pointer interaction before the UI it covers.

#### Scenario: Overlapping buttons
- **WHEN** two eligible buttons overlap in an overlay and the user presses their shared area
- **THEN** only the topmost button receives the activation

#### Scenario: Modal overlay blocks underlying controls
- **WHEN** a visible modal overlay covers an eligible button in underlying UI
- **THEN** a pointer press in their shared area does not activate the underlying button

#### Scenario: Clipped child
- **WHEN** a button lies outside its parent's active clipping region
- **THEN** pointer input in the button's unclipped area does not activate it

## ADDED Requirements

### Requirement: Disabled controls
The UI system SHALL support a disabled state for buttons that is visually distinguishable from an enabled button and prevents pointer activation.

#### Scenario: Disabled button click
- **WHEN** the pointer presses within a disabled button's computed rectangle
- **THEN** the button does not invoke its activation callback
