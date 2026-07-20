---
target: auth_screen.dart
total_score: 21
p0_count: 1
p1_count: 2
timestamp: 2026-07-20T19-41-06Z
slug: lib-screens-auth-screen-dart
---
Method: dual-agent (A: abbc684f2aedafc86 · B: a3b200d8afeb2d9a6)

## Design Health Score

| # | Heuristic | Score | Key Issue |
|---|-----------|-------|-----------|
| 1 | Visibility of System Status | 2 | No pending/loading feedback on submit; no send confirmation |
| 2 | Match System / Real World | 2 | 3-country dropdown mismatches the app's own evidenced international guest base |
| 3 | User Control and Freedom | 3 | Mode toggle works freely; system Back confirmed intact (no PopScope/interception) |
| 4 | Consistency and Standards | 3 | Token-driven everywhere except the hero section (wordmark style, ad-hoc whites) |
| 5 | Error Prevention | 1 | Name/phone validators are "non-empty" only — no format/length/digit check |
| 6 | Recognition Rather Than Recall | 3 | Labels + icons aid recognition; no phone-format example shown |
| 7 | Flexibility and Efficiency | 2 | No locale-based default country code; no paste-friendly formatting |
| 8 | Aesthetic and Minimalist Design | 2 | Redundant hero ceremony for a two-field task |
| 9 | Error Recovery | 2 | No inline help; no visible recovery path for a bad phone entry |
| 10 | Help and Documentation | 1 | No help/support affordance anywhere on the screen |
| **Total** | | **21/40** | **Acceptable — significant improvements needed** |

## Anti-Patterns Verdict

**LLM assessment**: No absolute-ban violation is literally present (no side-stripe borders, gradient text, glassmorphism, hero-metric template, uppercase eyebrows, numbered markers). At a glance a fluent Material user wouldn't flinch — stock `SegmentedButton`/`TextFormField`/`DropdownButtonFormField`/`FilledButton`, themed correctly almost everywhere. On closer inspection two things read as "strangeness without purpose" per the product register's slop test: a duplicated splash-style gradient hero for a two-field form, and a country-code list (`+20`/`+49`/`+7`) whose content is broken for the app's own demonstrated audience.

**Deterministic scan**: Not applicable. The bundled detector (`detect.mjs`) is HTML/CSS-selector-based; run against `auth_screen.dart` per protocol, it returned exit 0 with empty output — a real attempt, not a silent skip, confirming it simply has nothing to parse in Dart source. No browser automation was possible either (native Android screen, no renderable webview) — that step of the protocol is explicitly skipped rather than omitted quietly. In place of both, Assessment B ran a manual mechanical pass and supplied line-cited evidence instead.

**Where the two tracks agree**: Both independently flagged the wordmark's `TextStyle` (lines 103–108) as a hand-mixed hybrid of two real `TextTheme` roles rather than a defined role — the LLM read called it a type-scale violation; the mechanical pass pinned the exact lines (105, 107) and confirmed no `textTheme` role is referenced. Both also independently flagged the fully synchronous `_sendCode()` (no loading state, no confirmation) as the biggest gap at the highest-stakes hand-off in the funnel.

**Where the mechanical pass caught what the design read underweighted**: Assessment B found 5 concrete `Colors.white` literals inside the hero container (lines 93, 96, 98, 104, 124) that never resolve through a `RihlaColors` token — a literal violation of DESIGN.md's No-Ad-Hoc-Hex Rule that the design review's "token discipline" strength claim didn't catch, because it's visually invisible (white is white whether it's a token or not). **False-positive nuance**: Assessment B itself flagged that this pattern is consistent with an app-wide gap — `theme.dart` does the same thing in its button/appbar themes because `RihlaColors` has no dedicated "on-brand-color" token — so this reads as a system-level token gap, not a screen-specific regression. Fix at the token level, not by patching this file alone.

**Where the design read caught what the mechanical pass treated as neutral**: Assessment B logged the 3-item country-code list as "checked, no violation found" (it prevents mistyped codes). Assessment A cross-referenced it against `mock_data.dart`'s own seeded review data — real travelers from the UK, France, Italy, and Spain populate this app's reviews — and concluded the same list is a functional lockout for most of the product's own evidenced audience. This is a case where severity requires product context a line-level mechanical check can't see; it's promoted to P0 in this synthesis.

## Overall Impression

The screen is well-built at the component level — real Material widgets, real theme tokens, real progressive disclosure — but it over-invests in a redundant brand moment while under-investing in the two things that actually matter for a phone-based auth gate: validating what people type, and telling them something happened when they submit. The single biggest opportunity is the country-code list: a three-nation dropdown sitting in front of an app whose own review data proves its travelers are British, French, Italian, and Spanish is the one issue that actually blocks task completion, not just polish.

## What's Working

1. **Token discipline almost everywhere.** `SegmentedButton`, `TextFormField`, `DropdownButtonFormField`, and `FilledButton` all resolve through the shared `RihlaColors`/`RihlaSpace`/theme system rather than inventing custom controls — exactly the "earned familiarity" the product register asks for.
2. **Progressive disclosure done right.** The Full Name field only renders in register mode; login stays a true two-field form. Genuinely good cognitive-load discipline, confirmed against the 8-item checklist.
3. **Touch targets and back-navigation are clean, confirmed mechanically.** Every interactive control is a stock Material widget inheriting standard target sizing (no sub-48dp risk found); the app bar's back arrow is auto-generated with no `PopScope`/gesture interception anywhere in the file — system Back is guaranteed to work.

## Priority Issues

**[P0] Country-code list locks most of the app's own evidenced traveler base out of registering or logging in.**
- **Why it matters**: `_countryCodeOrder = ['+20', '+49', '+7']` (line 9) supports only Egypt, Germany, and Russia. `mock_data.dart`'s own seeded reviews name UK, French, Italian, and Spanish travelers as real Rihla guests. Those travelers cannot select their real country code — a blocking failure at the single gate into an app whose entire design mandate (PRODUCT.md) is building enough trust to skip in-app payment.
- **Fix**: Expand the picker to a real, searchable country-code list (or at minimum the countries represented in the app's own seed/review data), and validate phone length/format per selected country.
- **Suggested command**: `/impeccable harden auth_screen.dart` (edge cases, real-world input coverage) or `/impeccable clarify` if the immediate fix is copy/affordance-only.

**[P1] No real validation on name or phone — "non-empty" is the only check.**
- **Why it matters**: Both validators (lines 146–148, 184–186) accept anything non-blank. `"abc"` in the phone field, a single digit, or a pasted string with its own leading `+` code all pass and proceed straight to OTP with zero correction opportunity. No `inputFormatters` restrict the phone field despite `keyboardType: TextInputType.phone`, and `autovalidateMode` is unset, so there's no inline feedback before the first submit attempt either.
- **Fix**: Add digit-only `inputFormatters`, a length check tied to the selected country code, and switch to `AutovalidateMode.onUserInteraction` after first submit.
- **Suggested command**: `/impeccable harden auth_screen.dart`.

**[P1] No loading, pending, or confirmation feedback on the highest-stakes submit action.**
- **Why it matters**: `_sendCode()` (lines 44–55) is fully synchronous — no `async`/`await`, no `_isLoading` flag, no spinner, no button-disable, no simulated latency, and no "Code sent" acknowledgment before the hard navigation cut to OTP. Per the peak-end rule, this is the flattest, most anticlimactic moment in the funnel's single highest-stakes hand-off.
- **Fix**: Add a brief pending state on the button (disabled + spinner) and a snackbar confirmation ("Code sent to +20 100 123 4567") before navigating.
- **Suggested command**: `/impeccable polish auth_screen.dart`.

**[P2] The hero section over-builds the brand moment and drifts from the token system in three ways.**
- **Why it matters**: A second full-bleed `seaGradient` container (lines 78–112) repeats the wordmark and icon badge the user likely just saw on Splash seconds earlier, consuming 180dp+ before any input appears — ceremony a two-field task doesn't need, and it's exactly where the token drift concentrates: the wordmark's `TextStyle` (lines 103–108) hand-mixes two real `TextTheme` roles instead of using one, and 5 `Colors.white` literals (lines 93, 96, 98, 104, 124) bypass `RihlaColors` entirely (a systemic token gap — `RihlaColors` has no "on-brand-color" token — not unique to this screen).
- **Fix**: Cut or shrink the redundant hero; route the wordmark through a real `TextTheme` role; add an `onSeaGradient`-style white token to `RihlaColors` so future screens over photography/gradients don't reach for raw `Colors.white` either.
- **Suggested command**: `/impeccable distill auth_screen.dart` for the hero itself; `/impeccable extract` to add the missing on-color token system-wide.

**[P2] Entrance animation ignores the project's own stated reduced-motion requirement.**
- **Why it matters**: `FadeInUp` runs a 460ms slide/fade unconditionally, with no check against `MediaQuery.of(context).disableAnimations`. PRODUCT.md's own Accessibility & Inclusion section explicitly promises "reduced-motion alternatives for any animated transitions" — this is a direct, code-level gap against the project's own documented bar, not a hypothetical best practice.
- **Fix**: Gate `FadeInUp`'s animation on `MediaQuery.of(context).disableAnimations`, falling back to an instant/crossfade appearance.
- **Suggested command**: `/impeccable animate` (scoped to `fade_in.dart`, since this is a shared primitive, not just this screen).

## Persona Red Flags

**Jordan (first-timer, register flow):** Lands on Auth right after Splash and sees near-identical brand ceremony again — a beat of "did something reset?" confusion. Opens the country dropdown and, if not Egyptian/German/Russian, has no valid code to pick, with zero copy explaining this is a demo shortcut — reads as a broken picker, not an intentional limitation.

**Sam (accessibility-dependent):** With system dynamic type scaled up, the fixed 140px-wide dropdown column (line 156) holding entries like `"+49 Germany"` has even less room before truncation. More concretely and non-hypothetically: with Android's "Remove animations" enabled, `FadeInUp` still plays its 460ms slide/fade — a confirmed code-level violation of PRODUCT.md's own accessibility promise, not a maybe.

**Camille — project-specific persona, French tourist in Hurghada on hotel wifi:** Her real country code is +33, which is not one of the three options in `_countryCodeOrder`. She must pick a wrong code or abandon registration — and `mock_data.dart`'s own review seed data (a French reviewer among others) proves travelers exactly like her are part of Rihla's real user base. This is the single most concrete, PRODUCT.md-contradicting flaw on the screen. On flaky hotel wifi she also gets zero visual feedback that "Send Code" is doing anything — no spinner, no pending state, nothing distinguishing "working" from "frozen."

## Minor Observations

- Dropdown's fixed 140px width relies entirely on `TextOverflow.ellipsis` for longer country names — cosmetically tight even at default type scale.
- The country-code dropdown's `contentPadding` (12/16, line 163) diverges from the adjacent phone field's inherited theme default (16/16) — a small, code-confirmed padding mismatch between two fields in the same row.
- `SegmentedButton.styleFrom` and other component styling set colors directly from `RihlaColors` rather than via `Theme.of(context).colorScheme` roles — consistent with how the rest of `theme.dart` is built (not a screen-specific issue), but means a future dark-theme pass would need to touch these call sites individually rather than getting it for free from `ColorScheme`.
- No terms-of-service/reassurance microcopy near the CTA (e.g. "We'll only use this number for booking updates") — cheap to add, reinforces the "trust substitutes for payment" mandate at the exact right moment.
- Toggling the register/login `SegmentedButton` snaps the Full Name field in/out with no transition — abrupt, very low priority.

## Questions to Consider

1. If this login form can't register a French, Italian, Spanish, or British tourist — nationalities the app's own seeded review data proves are real guests — who was the `['+20', '+49', '+7']` list actually built for?
2. Splash already delivers the "Rihla" brand moment once. Why does Auth repeat wordmark + gradient + icon badge in near-identical form seconds later, for a screen whose entire job is two text fields and a button?
3. Given "trust substitutes for payment" is this product's core design mandate, why does its single highest-stakes screen validate a phone number no more strictly than "is this field non-empty," and confirm nothing back to the user when the code is sent?
