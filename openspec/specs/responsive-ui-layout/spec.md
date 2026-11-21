# responsive-ui-layout Specification

## Purpose

Provide Cbit2d games with retained UI trees that reflow predictably as the application viewport and UI content change.

## Requirements

### Requirement: Viewport-responsive layout
The UI system SHALL calculate each visible widget's rectangle from the current logical UI viewport and its parent layout constraints, rather than requiring absolute scene coordinates.

#### Scenario: Centered menu after window resize
- **WHEN** the application viewport width or height changes
- **THEN** a root-centered column remains centered within the new viewport without scene code recalculating child coordinates

#### Scenario: Fullscreen reflow
- **WHEN** the application changes between windowed and fullscreen presentation
- **THEN** the UI system reflows visible UI against the resulting viewport before rendering the next frame

### Requirement: Composable layout primitives
The UI system SHALL support panel, row, column, overlay, text, and button widgets with nested child relationships. An overlay SHALL stack its visible children in declaration order within the same layout bounds rather than consuming sequential layout space.

#### Scenario: Vertical menu composition
- **WHEN** a scene places a text widget and a button widget in a column with a configured gap
- **THEN** the UI system arranges them vertically in declaration order with the configured space between them

#### Scenario: Centered modal overlay
- **WHEN** a scene places a modal panel in an overlay that fills its viewport and centers its children
- **THEN** the modal panel is centered over the underlying layout without reflowing that layout

### Requirement: Responsive size and alignment constraints
The UI system SHALL support automatic, fixed, percentage, and flexible size constraints, plus alignment, padding, gap, and minimum/maximum size constraints.

#### Scenario: Flexible content fills remaining width
- **WHEN** a row contains a fixed-width sidebar and a flexible content panel
- **THEN** the content panel receives the remaining available width while respecting its configured minimum and maximum sizes

### Requirement: Layout invalidation
The UI system SHALL recompute layout before rendering when its viewport changes or when a visible widget's layout-relevant content or constraints change.

#### Scenario: Text content change updates placement
- **WHEN** a visible text widget's content changes
- **THEN** its measured size and affected descendant or sibling placement are updated before the UI is rendered

### Requirement: Constrained text layout
The UI system SHALL support constraining text to an available layout width and calculate its layout height from wrapped lines.

#### Scenario: Wrapped match summary
- **WHEN** a text widget's rendered content exceeds its configured available width
- **THEN** the widget wraps the content within that width and its layout height includes all rendered lines
