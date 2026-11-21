## MODIFIED Requirements

### Requirement: Composable layout primitives
The UI system SHALL support panel, row, column, overlay, text, and button widgets with nested child relationships. An overlay SHALL stack its visible children in declaration order within the same layout bounds rather than consuming sequential layout space.

#### Scenario: Vertical menu composition
- **WHEN** a scene places a text widget and a button widget in a column with a configured gap
- **THEN** the UI system arranges them vertically in declaration order with the configured space between them

#### Scenario: Centered modal overlay
- **WHEN** a scene places a modal panel in an overlay that fills its viewport and centers its children
- **THEN** the modal panel is centered over the underlying layout without reflowing that layout

## ADDED Requirements

### Requirement: Constrained text layout
The UI system SHALL support constraining text to an available layout width and calculate its layout height from wrapped lines.

#### Scenario: Wrapped match summary
- **WHEN** a text widget's rendered content exceeds its configured available width
- **THEN** the widget wraps the content within that width and its layout height includes all rendered lines
