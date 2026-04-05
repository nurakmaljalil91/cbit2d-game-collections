# Engine C++20 Guidelines

Use C++20 to make the engine clearer and safer.

## Prefer

- RAII for subsystem and resource lifetime
- `std::unique_ptr` for unique ownership
- references or `std::span` for non-owning access
- `std::string_view` for read-only string parameters with stable lifetime expectations
- `enum class` and small strong types for important identifiers
- explicit constructors and explicit conversions when ambiguity would be costly

## Avoid

- hidden ownership
- engine-wide singletons without a clear lifetime model
- template-heavy abstractions that make call sites or errors harder to understand
- exposing SDL types in high-level APIs unless that boundary is intentional
- wide headers that force unrelated rebuilds or leak implementation concerns

## Design Questions

- Who owns this object?
- How long does it live?
- Is this type part of the stable engine API or just an internal implementation detail?
- Would a game repository understand and consume this interface cleanly?
