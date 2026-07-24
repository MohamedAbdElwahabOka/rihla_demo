# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Rihla is a **Flutter demo app** (Android-focused) for browsing and booking Red Sea / Hurghada tourism experiences (diving, safaris, boat tours, restaurants). It is a UI prototype: **no backend, no network, no persistence.** All content is authored as Dart literals and all session state lives in mutable in-memory globals that reset on every launch. There is no payment — the booking flow ends at issuing a ticket number.

## Commands

```bash
flutter pub get              # install deps (run after editing pubspec.yaml)
flutter run                  # launch on the connected device/emulator
flutter analyze              # static analysis — keep this CLEAN before committing
flutter gen-l10n             # regenerate lib/l10n/app_localizations*.dart from .arb files
flutter build apk            # release Android build
```

- **Always run `flutter analyze` and get it clean before committing** — the project has no test suite, so the analyzer is the only automated gate.
- There are **no tests** (`test/` is absent). If asked to add behavior verification, add widget tests under `test/`.
- Localization files are code-generated (`generate: true` in pubspec). Editing an `.arb` file requires a `flutter gen-l10n` (or the next `flutter run`) to regenerate `AppLocalizations`.

## Architecture

**Navigation — Navigator 1.0, named routes, no router package.** All routes are declared in [lib/routes.dart](lib/routes.dart) (`Routes` constants + `appRoutes` map). Screens push by name and pass data forward via route `arguments`, never through a global store. Two typed argument carriers exist: [AuthRequest](lib/auth_request.dart) (Auth → OTP → Complete Profile) and [BookingData](lib/booking_data.dart) (the 3-step booking flow, `booking1` → `booking2` → `booking3`).

**State — no state-management package (no Provider/Riverpod/Bloc).** UI state is local `setState`; cross-screen session state is a set of **mutable top-level globals** in [lib/mock_data.dart](lib/mock_data.dart):
- `currentUser`, `isLoggedIn` / `isGuest`, `userSubscription` — the session; `signOutToGuest()` resets them.
- `bookings`, `favoriteIds`, `recentSearches` — mutated in place at runtime (e.g. Write Review appends to an `Experience.reviewsList`, favoriting toggles `favoriteIds`).
- All of these reset on a fresh launch **by design** — do not add persistence unless asked.
- Because tab bodies read these mutable globals, [lib/main_shell.dart](lib/main_shell.dart) intentionally builds its tab list **non-`const`** so switching back to a tab reflects changed state. Don't "optimize" that to `const`.

**Data model.** Plain Dart classes in [lib/mock_data.dart](lib/mock_data.dart) (`Experience`, `Restaurant`, `SubscriptionPlan`, `UserSubscription`, `Booking`, `Review`, etc.) — **no `fromJson`/serialization**; all instances are authored directly in that file. `experiences` and `bookings` are non-`const` (growable at runtime); reference lists (`restaurants`, `subscriptionPlans`, categories) are `const`.

**Localization — EN / DE / RU.** [lib/main.dart](lib/main.dart)'s `RihlaApp` owns the active `Locale` (the only state above the route tree); any screen switches language via `RihlaApp.of(context).setLocale(...)`. Strings come from `AppLocalizations.of(context)!` (`l10n.someKey`). Source of truth is the `.arb` files in [lib/l10n/](lib/l10n/) (`app_en.arb` is the template per [l10n.yaml](l10n.yaml)); the `app_localizations*.dart` files are generated — **never hand-edit them**. Any new user-facing string must be added to all three `.arb` files.

**Shell.** [lib/main_shell.dart](lib/main_shell.dart) hosts the 4-tab bottom nav (Home / Explore / Bookings / Profile) as an `IndexedStack`. Detail, booking, auth, and settings-style screens push on top of the shell.

## Core business rules (encoded in the UI)

- **Guest gating.** A guest (`isGuest`) browses everything read-only. Every *account action* (favorite, book, subscribe, review, profile edit) must, when `isGuest`, call `promptSignIn(context)` from [lib/widgets/sign_in_prompt.dart](lib/widgets/sign_in_prompt.dart) **instead of** performing the action.
- **Subscription-to-book gate.** Booking requires an active `userSubscription` holding a matching typed credit (one credit per experience type). The Detail screen's Book action checks this. A freshly-registered user has `userSubscription == null` and must subscribe first.
- **Demo login personas** (see comments in [lib/mock_data.dart](lib/mock_data.dart)): registered subscriber = `+20` `106 442 5532`; unregistered (triggers registration flow) = `+20` `100 999 0000`. Any 6-digit OTP is accepted; `000000` is special-cased to demo the expired-code error.

## UI conventions (see PRODUCT.md / DESIGN.md for the full system)

This project has strategic and visual design context captured via `/impeccable`:

- **[PRODUCT.md](PRODUCT.md)** — register, platform, users, positioning, brand personality, anti-references, design principles. Read before any UX/product decision.
- **[DESIGN.md](DESIGN.md)** — the "Red Sea Coastal Premium" visual system: color roles, typography, elevation, component conventions. Read before touching any UI code.

Any `/impeccable` command reads both files automatically. When editing UI by hand:
- **Colors, spacing, radii, shadows go through `RihlaColors` / `RihlaSpace` / `RihlaShadows`** in [lib/theme.dart](lib/theme.dart) — **no ad-hoc hex** and no raw `Colors.white` on branded surfaces (use `RihlaColors.onBrand*`). The global `ThemeData` is `buildRihlaTheme()`; prefer theming components there over per-widget overrides.
- **Prices** always render as struck-through original + bold discounted, via [lib/widgets/price_tag.dart](lib/widgets/price_tag.dart). Format money/dates only through `formatEur` / `formatDate` in [lib/utils/format.dart](lib/utils/format.dart) (`€ 1,900`, `20/07/2026`).
- **Images** use [LocalImage](lib/widgets/local_image.dart), which falls back to a gradient placeholder (`GradientImage`) when an asset is missing — so the demo never shows a broken-image glyph. Photos are bundled per-category under `assets/<category>/` and declared in [pubspec.yaml](pubspec.yaml); adding a new asset folder there requires it to exist on disk or `flutter pub get` fails.
- Shared widgets live in [lib/widgets/](lib/widgets/) (`rihla_app_bar`, `glass_panel`, `rihla_badge`, `fade_in`, `animated_favorite_icon`, `sign_in_prompt`, …) — reuse these rather than reinventing chrome.
