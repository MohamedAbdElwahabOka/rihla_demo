---
name: Rihla
description: Sea-blue/gold coastal-premium design system for a Red Sea tourism booking app
colors:
  sea-blue: "#0077B6"
  deep-sea-ink: "#023E58"
  lagoon-cyan: "#00B4D8"
  sunset-gold: "#E8B23A"
  coral-flare: "#F3705A"
  airy-sea-mist: "#F3F7FA"
  surface-white: "#FFFFFF"
  deep-teal-ink: "#0B2A38"
  muted-slate: "#5C7480"
  faint-slate: "#93A7B0"
  hairline-mist: "#E4ECF1"
  sea-wash: "#E3F1F8"
  warm-sand-wash: "#FBF0D8"
  on-brand: "#FFFFFF"
typography:
  display:
    fontFamily: "Roboto (Material 3 default)"
    fontSize: "36sp"
    fontWeight: 800
    lineHeight: 1.12
    letterSpacing: "-0.8"
  headline:
    fontFamily: "Roboto (Material 3 default)"
    fontSize: "28sp"
    fontWeight: 800
    lineHeight: 1.15
    letterSpacing: "-0.6"
  title:
    fontFamily: "Roboto (Material 3 default)"
    fontSize: "22sp"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.3"
  body:
    fontFamily: "Roboto (Material 3 default)"
    fontSize: "16sp"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "normal"
  label:
    fontFamily: "Roboto (Material 3 default)"
    fontSize: "14sp"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "0.1"
rounded:
  sm: "10px"
  md: "16px"
  lg: "22px"
  pill: "100px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
  xxl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.sea-blue}"
    textColor: "#FFFFFF"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    height: "54px"
  button-outlined:
    backgroundColor: "transparent"
    textColor: "{colors.deep-sea-ink}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    height: "54px"
  chip-selected:
    backgroundColor: "{colors.sea-blue}"
    textColor: "#FFFFFF"
    typography: "{typography.label}"
    rounded: "{rounded.pill}"
  chip-unselected:
    backgroundColor: "{colors.surface-white}"
    textColor: "{colors.deep-teal-ink}"
    typography: "{typography.label}"
    rounded: "{rounded.pill}"
  card:
    backgroundColor: "{colors.surface-white}"
    rounded: "{rounded.md}"
  input:
    backgroundColor: "{colors.surface-white}"
    textColor: "{colors.deep-teal-ink}"
    rounded: "{rounded.md}"
---

# Design System: Rihla

## 1. Overview

**Creative North Star: "The Red Sea Concierge"**

Rihla never touches the traveler's money — the app's only job is to build enough trust that a stranger will hand cash to a vendor because a ticket number said so. The visual system reads like a boutique concierge, not a discount marketplace: deep teal-navy ink grounds every screen, azure-to-lagoon sea gradients carry the brand moments, and warm gold/coral sunset accents mark anything premium — subscription credits, discounts, featured listings. Depth is soft and ambient (layered low-opacity shadows, a frosted-glass panel over hero photography) rather than flat or harshly lifted, because the app is selling a feeling of a well-run establishment, not a utility.

This system explicitly rejects two things: the dense, generic-OTA-aggregator look (list rows, star-badges, coupon-code chrome that make every listing feel interchangeable), and flashy gamification (confetti, streak counters, loud gradient badges) that would undercut the trustworthy, premium register the subscription-without-payment model depends on.

**Key Characteristics:**
- Sea-blue primary, gold/coral sunset secondary — never a third hue family
- Soft layered shadows and frosted glass, never hard Material elevation or flat cards
- Heavy, tight-tracked display/headline/title weights (600–800) paired with relaxed 1.5-line-height body text
- Full-width, decisive 54px buttons — built for one-handed use mid-booking, not dainty forms
- Every price shows both original (struck) and discounted (bold) — the discount is never hidden

## 2. Colors

Coastal and nautical: every name describes where the color sits in the sea-to-shore scene, not its hex order.

### Primary
- **Sea Blue** (#0077B6): the brand's primary action color — filled buttons, links, selected nav/tab states, focused input borders.
- **Deep Sea Ink** (#023E58): the darkest brand shade — anchors the app bar gradient and the sea gradient's dark end.
- **Lagoon Cyan** (#00B4D8): the brand's brightest highlight — the sea gradient's light end, used sparingly for energy/sparkle.

### Secondary
- **Sunset Gold** (#E8B23A): premium and discount signaling — subscription badges, "Featured" tags, the sunset gradient's warm end.
- **Coral Flare** (#F3705A): pairs with Sunset Gold in the sunset gradient — warm CTA emphasis, discount/urgency accents.

### Neutral
- **Airy Sea Mist** (#F3F7FA): page/scaffold background.
- **Surface White** (#FFFFFF): cards, sheets, inputs, dialogs.
- **Deep Teal Ink** (#0B2A38): primary text.
- **Muted Slate** (#5C7480): secondary/body-muted text.
- **Faint Slate** (#93A7B0): tertiary text, hints, placeholders.
- **Hairline Mist** (#E4ECF1): dividers, borders, unselected outlines.
- **Sea Wash** (#E3F1F8): tinted fill for soft badges, nav-indicator backgrounds.
- **Warm Sand Wash** (#FBF0D8): tinted fill for soft warm/gold backgrounds.
- **On-Brand** (#FFFFFF): the resolved text/icon color for anything placed on top of a brand-colored surface (sea/sunset gradients, filled buttons) — a named token so those call sites never reach for a raw `Colors.white`.

### Named Rules
**The Two-Gradient Rule.** Exactly two gradients exist system-wide: the **Sea Gradient** (Deep Sea Ink → Sea Blue → Lagoon Cyan) for brand/hero surfaces — the app bar wash, splash, sign-in-gate icon — and the **Sunset Gradient** (Sunset Gold → Coral Flare) for anything premium or promotional — badges, subscription accents. Never introduce a third gradient or blend the two.

**The No-Ad-Hoc-Hex Rule.** Every color reference resolves through `RihlaColors`. A raw hex literal anywhere outside `theme.dart` is a bug, not a shortcut.

## 3. Typography

**Display/Body/Label Font:** Roboto (Material 3 platform default; no custom font is bundled — `pubspec.yaml` declares no `fonts:` block).

**Character:** One family carrying the whole system through weight and tracking rather than a font pairing — heavy, tightly-tracked display/headline/title against relaxed, generously-leaded body copy. The contrast axis is weight, not typeface.

### Hierarchy
- **Display** (800, 36sp, 1.12 line-height, -0.8 tracking): rare, reserved for the splash wordmark and other one-off hero moments.
- **Headline** (800/700, 28sp / 24sp, -0.6 / -0.4 tracking): screen titles, hero price call-outs.
- **Title** (700/700/600, 22sp / 16sp / 14sp, -0.3 / -0.2 / normal tracking): card headers, experience names, section titles.
- **Body** (400, 16sp / 14sp, 1.5 line-height): descriptions, itineraries, reviews. 16sp uses Deep Teal Ink; 14sp uses Muted Slate for the secondary read.
- **Label** (700, 14sp, 0.1 tracking): button labels, nav labels, chip text, badge text (11sp at its smallest, in `RihlaBadge`).

### Named Rules
**The Heavy-Display Rule.** Nothing from title size and up renders at regular (400) weight; the hierarchy starts at 600 and climbs to 800, always with negative letter-spacing. Only body copy is allowed to relax to 400 weight and neutral tracking.

## 4. Elevation

Soft layered depth: shadows are diffuse, low-opacity stacks (never Material's default hard elevation), and the flagship elevation move is `GlassPanel` — a frosted, backdrop-blurred surface with a hairline highlight border, floated over hero photography so white text stays legible without a flat scrim.

### Shadow Vocabulary
- **card** (`RihlaShadows.card`: two stacked shadows, `alpha 0.06 / blur 18 / offset (0,8)` + `alpha 0.04 / blur 4 / offset (0,1)`): the default resting elevation for cards and tiles.
- **soft** (`RihlaShadows.soft`: `alpha 0.05 / blur 12 / offset (0,4)`): a lighter touch for smaller surfaces (chips, small tiles).
- **raised** (`RihlaShadows.raised`: `alpha 0.16 / blur 24 / offset (0,12)`): reserved for surfaces that need to visibly float above everything else (sheets, floating CTAs).

### Named Rules
**The Ambient-Not-Hard Rule.** Shadow color is always a low-alpha tint of Deep Sea Ink, never black, and never a single hard-edged drop shadow — depth reads as atmosphere, not as a UI-kit default.

## 5. Components

### Buttons
- **Shape:** 16px radius (`rounded.md`), full-width, 54px minimum height — decisive, one-handed-friendly targets.
- **Primary (`FilledButton`):** Sea Blue background, white text, bold 15sp label, zero elevation (the flatness is intentional — brand color carries the weight, not a shadow).
- **Outlined/Secondary:** transparent background, Deep Sea Ink text, 1.5px Hairline Mist border.
- **Ghost/Text:** Sea Blue text, bold weight, no container.

### Chips
- **Style:** pill radius (`rounded.pill`), no checkmark on selection (`showCheckmark: false`) — the filled Sea Blue background alone signals the selected state.
- **State:** selected = Sea Blue fill + white label; unselected = Surface White fill + Hairline Mist border + Deep Teal Ink label.

### Cards / Containers
- **Corner Style:** 16px radius, clipped (`Clip.antiAlias`).
- **Background:** Surface White, `surfaceTintColor: transparent` (no Material 3 tonal overlay — color stays true).
- **Shadow Strategy:** the `card` shadow vocabulary above; `shadowColor` is Deep Sea Ink at 0.28 alpha.
- **Border:** none — separation comes from shadow and white-on-mist contrast, not strokes.
- **Internal Padding:** zero card margin at the component level; spacing is composed by the parent layout using the `spacing` scale.

### Inputs / Fields
- **Style:** filled Surface White background, 16px radius, 1px Hairline Mist border at rest.
- **Focus:** border shifts to Sea Blue at 1.6px — no glow, no color-fill change.
- **Hint/placeholder:** Faint Slate.

### Navigation
- **Style:** `NavigationBar`, Surface White background, zero elevation, 68px height, Sea Wash selected-indicator pill.
- **States:** selected = bold 12sp label in Deep Sea Ink + Sea Blue icon; unselected = medium-weight label + icon in Faint Slate.

### Sign-In Gate Sheet (signature pattern)
A bottom sheet is the one and only guest-gate mechanism (`promptSignIn`): a circular Sea Gradient icon badge (lock icon), a bold headline, muted body copy, then a full-width primary "Sign In" button over a ghost "Not now." Every gated action (favorite, book, subscribe, review) calls this same sheet rather than improvising its own dialog.

### Price Tag (signature component)
Struck-through original price (grey / white70 on photography) beside a bold discounted price (Deep Sea Ink, or white when placed over imagery via the `light` variant). This pairing is mandatory anywhere a price appears — see Do's and Don'ts.

### Badge (signature component)
`RihlaBadge.sunset` (Sunset Gradient fill, white label) for premium/promo callouts (Featured, discount %); `RihlaBadge.soft` (Sea Wash fill, Deep Sea Ink label) for neutral inline metadata (category, duration). No third badge style exists.

## 6. Do's and Don'ts

### Do:
- **Do** resolve every color through `RihlaColors` and every radius/spacing value through `RihlaSpace` — no ad-hoc hex or magic numbers.
- **Do** show both the struck original price and the bold discounted price together, anywhere a price appears (per FR-021/036/060) — the discount is the hook, never an afterthought.
- **Do** route every guest-gated action through the single `promptSignIn` bottom sheet, never a bespoke dialog.
- **Do** keep shadows diffuse and low-opacity (the `card` / `soft` / `raised` vocabulary) — depth is atmosphere, not a hard drop shadow.
- **Do** reserve the Sunset Gradient strictly for premium/promo moments (subscription, discounts, featured) so its meaning stays legible.

### Don't:
- **Don't** build dense, aggregator-style list rows with generic star-badges or coupon-code chrome — that's the generic-OTA-clone look this system explicitly rejects.
- **Don't** add confetti, streak counters, or loud gradient badges outside the two sanctioned gradients — that's the flashy-gamified-app look this system explicitly rejects.
- **Don't** introduce a third brand gradient or a third accent hue beyond Sea Blue / Sunset Gold / Coral Flare.
- **Don't** use Material 3's default hard elevation or `surfaceTintColor` tonal overlays — this system overrides both in favor of soft shadow stacks and true (untinted) surface color.
- **Don't** render title-size-and-above text at regular (400) weight — the heavy-display hierarchy is load-bearing for the "premium" read.
