# Product

## Register

product

## Platform

android

## Users

Travelers browsing and booking Red Sea (Hurghada) tourism experiences — diving, desert safaris, boat tours, and restaurants. There is one persona at different points of the same funnel: a **browsing guest** (no login, read-only), a **new registrant** (registered but no subscription yet), and a **subscribed traveler** (holds typed experience credits and can book). No secondary audience; vendors are represented in-app as listing content, not as users of this surface.

## Product Purpose

Rihla lets travelers discover vetted local experiences and book them without any in-app money changing hands. Instead of paying per booking, the traveler buys a **Rihla Subscription** that grants **typed experience credits** (one diving credit, one safari credit, etc.) plus vendor discounts, then redeems a credit to book — one experience per type per subscription. The traveler pays the vendor directly on arrival; the app's job ends at issuing a digital ticket with an 8-digit verification number.

## Positioning

The only step between "found an experience" and "vendor confirms it on arrival" is a credit and a ticket number — no price is ever paid inside the app.

## Capabilities and Constraints

- **Favorites.** A shared favorite state must stay consistent across every surface that lists experiences (Home, Explore, Detail) plus a dedicated My Favourites view — this completes a feature that currently exists but is broken, not new scope.
- **Account management.** Edit Profile (name/phone/photo/email) and Settings (language, sign-out) are separate concerns; only one language switcher should exist across the app.
- **First-run onboarding.** A one-time language selection gates the first-run experience, shown immediately after first OTP success.
- **Notifications.** Notifications must deep-link to their relevant in-app destination; travelers can set per-category Push/WhatsApp preferences.
- **Subscription purchase.** Follows the same multi-step pattern already established for booking: a headcount & price review step, an explicit payment result step (not a snackbar), and promo code entry.
- **Booking lifecycle.** Bookings carry sub-statuses (Initial / Confirmed / Missed-No-Show) that determine the available action (Cancel vs. Contact Support). A traveler may write a review only after the trip's actual end time, not merely on a status change.
- **Security deposits.** Every booking carries a deposit with an amount/percentage and a lifecycle status (Not Yet Held / Held / Released / Captured) that must read consistently anywhere a booking or ticket appears.
- **Ticket detail.** The persistent ticket view must surface the QR code, deposit status, and a CTA matched to the booking's current status.
- **Vendor reassignment.** A mock flow exists for when a vendor must be reassigned; the traveler responds via Accept or "I have a problem."
- **Refunds & payments.** Refunds attach to a specific booking or subscription and generate a notification; checkout is blocked when the traveler has no saved card.
- **Demo constraints (reaffirmed).** No real payment gateway integration, webhook/reconciliation logic, server-enforced rate limits, or admin-side retry logic — these all require a backend this project deliberately doesn't have.

## Brand Personality

Premium, coastal, trustworthy — already anchored in code as "Red Sea Coastal Premium": deep teal-navy ink, azure-to-lagoon sea gradients, warm gold/coral sunset accents. The tone should feel like a confident boutique travel concierge, not a discount marketplace.

## Anti-references

Not a generic OTA clone — avoid the visual sameness of Booking.com / Expedia / GetYourGuide (dense list rows, generic star-badges, coupon-code chrome). Not a flashy gamified app either — no confetti, streak counters, or loud gradient badges. The premium/trustworthy read has to survive the fact that no payment ever happens in-app; the UI is the only thing standing in for that trust.

## Design Principles

- **Trust substitutes for payment.** Since the app never collects money, every screen that leads to a booking (pricing, vendor identity, ticket verification) has to work harder to earn confidence — clear vendor attribution, unambiguous pricing, a ticket number treated as a real credential, not a receipt afterthought.
- **Typed credits must stay legible.** The one-credit-per-type-per-subscription rule is the core mechanic; a traveler should always be able to see which credits they hold, which are spent, and why a booking is (or isn't) allowed, without reading fine print.
- **Browsing is free; gates appear at commitment.** Guests get full read-only access to discovery (galleries, itineraries, reviews, prices). Login/subscription prompts surface only at the moment of action (favorite, book, subscribe), never blocking exploration.
- **The discount is the hook.** Original-vs-discounted EUR pricing is a primary conversion lever, not a strikethrough afterthought — treat it as a first-class, consistently-styled pattern everywhere a price appears.
- **Coastal premium, not aggregator or arcade.** Sea-blue/gold/coral restraint over both the dense-OTA-list look and gamified flourish; let photography and typography carry the "premium destination" feeling.

## Accessibility & Inclusion

Standard mobile accessibility bar (no formal WCAG audit for this demo): sufficient color contrast for body text and prices, tap targets sized for one-handed phone use, respect for system dynamic type, and reduced-motion alternatives for any animated transitions.
