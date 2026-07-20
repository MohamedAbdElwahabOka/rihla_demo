# CLAUDE.md

## Design Context

This project has strategic and visual design context captured via `/impeccable`:

- **[PRODUCT.md](PRODUCT.md)** — register (product), platform (android), users, positioning, brand personality, anti-references, and design principles. Read this before any UX/product decision.
- **[DESIGN.md](DESIGN.md)** — the "Red Sea Coastal Premium" visual system (North Star: "The Red Sea Concierge"): color roles, typography hierarchy, elevation/shadow vocabulary, and component conventions extracted from `lib/theme.dart` and `lib/widgets/`. Read this before touching any UI code.

Any `/impeccable` command (`craft`, `critique`, `audit`, `polish`, etc.) reads both files automatically. When editing UI by hand without the skill, follow the same conventions: colors/spacing through `RihlaColors`/`RihlaSpace` only, no ad-hoc hex, prices always shown as struck-original + bold-discounted, guest-gated actions routed through `promptSignIn`.

See also `docs/HANDOFF.md` for the current implementation task list and dev conventions (localization, analyze-clean-before-commit, no backend/persistence).
