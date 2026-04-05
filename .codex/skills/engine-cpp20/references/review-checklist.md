# Engine Review Checklist

- Confirm the change improves or preserves engine/library reusability.
- Confirm the public API is smaller or clearer than before, not just different.
- Confirm ownership and lifetime are obvious from types and call sites.
- Confirm SDL3-specific details stay near the runtime edge.
- Confirm the engine still avoids direct knowledge of game rules or content.
- Confirm the implementation does not introduce unnecessary compile-time complexity.
