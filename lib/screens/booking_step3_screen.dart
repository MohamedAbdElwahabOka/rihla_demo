import 'dart:math';
import 'package:flutter/material.dart';
import '../booking_data.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/price_tag.dart';
import '../widgets/rihla_app_bar.dart';

final _rng = Random();

String _generateRefCode() => 'RHL-2026-${10000 + _rng.nextInt(90000)}';

String _generateTicketNumber() {
  final n = 10000000 + _rng.nextInt(90000000);
  final s = n.toString();
  return '${s.substring(0, 4)}-${s.substring(4, 8)}';
}

/// S3c — Booking Step 3: Confirm (FR-047-050).
class BookingStep3Screen extends StatelessWidget {
  const BookingStep3Screen({super.key});

  void _confirm(BuildContext context, BookingData data, String? creditType) {
    final experience = data.experience;
    final adultPrice = experience.priceDiscounted;
    final childPrice = (experience.priceDiscounted * 0.5).round();
    final finalTotal = adultPrice * data.adults + childPrice * data.children;
    final originalTotal = experience.priceOriginal * (data.adults + data.children);
    final discountPct = ((experience.priceOriginal - experience.priceDiscounted) / experience.priceOriginal * 100).round();

    final booking = Booking(
      id: 'b${bookings.length + 1}',
      experienceTitle: experience.title,
      vendorName: experience.vendorName,
      icon: experience.icon,
      date: data.date!,
      time: data.timeSlot!,
      adults: data.adults,
      children: data.children,
      discountPct: discountPct,
      originalPriceEur: originalTotal,
      finalPriceEur: finalTotal,
      refCode: _generateRefCode(),
      ticketNumber: _generateTicketNumber(),
      creditTypeConsumed: creditType,
    );
    bookings.add(booking);
    if (creditType != null) {
      // Safe: reaching Step 3 requires an active subscription (Detail's
      // Book button gates on it per FR-037/BR-006).
      userSubscription!.creditsRemaining[creditType] = (userSubscription!.creditsRemaining[creditType] ?? 1) - 1;
    }

    Navigator.of(context).pushReplacementNamed(Routes.ticket, arguments: booking);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = ModalRoute.of(context)!.settings.arguments as BookingData;
    final experience = data.experience;

    final adultPrice = experience.priceDiscounted;
    final childPrice = (experience.priceDiscounted * 0.5).round();
    final finalTotal = adultPrice * data.adults + childPrice * data.children;
    final originalSubtotal = experience.priceOriginal * (data.adults + data.children);
    final discountPct = experience.priceOriginal > experience.priceDiscounted
        ? ((experience.priceOriginal - experience.priceDiscounted) / experience.priceOriginal * 100).round()
        : 0;

    final remainingCredit = userSubscription?.creditsRemaining[experience.category];
    final creditType = (remainingCredit != null && remainingCredit > 0) ? experience.category : null;

    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.orderSummary)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            const _BookingStepper(current: 2),
            const SizedBox(height: RihlaSpace.xl),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: RihlaColors.seaTint,
                          borderRadius: BorderRadius.circular(RihlaSpace.radiusSm),
                        ),
                        child: Icon(experience.icon, color: RihlaColors.seaBlue, size: 24),
                      ),
                      const SizedBox(width: RihlaSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              experience.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: -0.3,
                                color: RihlaColors.ink,
                              ),
                            ),
                            const SizedBox(height: RihlaSpace.xs),
                            Text(
                              '${formatDate(data.date!)} · ${data.timeSlot}',
                              style: const TextStyle(color: RihlaColors.inkMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: RihlaSpace.xl + RihlaSpace.sm),
                  _SummaryRow(label: '${l10n.adults} × ${data.adults}', value: formatEur(adultPrice * data.adults)),
                  if (data.children > 0)
                    _SummaryRow(label: '${l10n.children} × ${data.children}', value: formatEur(childPrice * data.children)),
                  const Divider(height: RihlaSpace.xl + RihlaSpace.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: RihlaSpace.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.total,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: RihlaColors.ink),
                        ),
                        if (discountPct > 0)
                          PriceTag(original: originalSubtotal, discounted: finalTotal, discountedFontSize: 16)
                        else
                          Text(
                            formatEur(finalTotal),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: RihlaColors.seaBlueDark,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (discountPct > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.discountApplied(discountPct),
                        style: const TextStyle(fontSize: 12, color: RihlaColors.statusSuccess, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
            if (creditType != null) ...[
              const SizedBox(height: RihlaSpace.lg),
              Container(
                padding: const EdgeInsets.all(RihlaSpace.md),
                decoration: BoxDecoration(
                  color: RihlaColors.goldTint,
                  borderRadius: BorderRadius.circular(RihlaSpace.radius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.redeem_rounded, size: 18, color: RihlaColors.gold),
                    const SizedBox(width: RihlaSpace.sm),
                    Expanded(
                      child: Text(
                        l10n.creditNote(creditType, remainingCredit! - 1),
                        style: const TextStyle(color: RihlaColors.seaBlueDark, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: RihlaSpace.lg),
            Container(
              padding: const EdgeInsets.all(RihlaSpace.md),
              decoration: BoxDecoration(
                color: RihlaColors.seaTint,
                borderRadius: BorderRadius.circular(RihlaSpace.radius),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: RihlaColors.seaBlue),
                  const SizedBox(width: RihlaSpace.sm),
                  Expanded(
                    child: Text(
                      l10n.payVendorNotice,
                      style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StickyActionBar(
        child: FilledButton(
          onPressed: () => _confirm(context, data, creditType),
          child: Text(l10n.confirmBooking),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RihlaSpace.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: RihlaColors.inkMuted),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RihlaColors.ink),
          ),
        ],
      ),
    );
  }
}

/// Segmented progress bar for the 3-step booking flow. Filled sea-blue for
/// completed and current steps; hairline for upcoming ones.
class _BookingStepper extends StatelessWidget {
  final int current;
  const _BookingStepper({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final done = i <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? RihlaSpace.sm : 0.0),
            height: 6,
            decoration: BoxDecoration(
              color: done ? RihlaColors.seaBlue : RihlaColors.hairline,
              borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            ),
          ),
        );
      }),
    );
  }
}

/// Sticky bottom action bar: a rounded surface lifted off the content with an
/// upward soft shadow, hosting the primary CTA.
class _StickyActionBar extends StatelessWidget {
  final Widget child;
  const _StickyActionBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RihlaSpace.radiusLg)),
        boxShadow: RihlaShadows.stickyBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, RihlaSpace.md, RihlaSpace.lg, RihlaSpace.md),
          child: child,
        ),
      ),
    );
  }
}
