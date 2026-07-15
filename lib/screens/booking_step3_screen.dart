import 'dart:math';
import 'package:flutter/material.dart';
import '../booking_data.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';

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

    final remainingCredit = userSubscription?.creditsRemaining[experience.category];
    final creditType = (remainingCredit != null && remainingCredit > 0) ? experience.category : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderSummary)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(experience.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${formatDate(data.date!)} · ${data.timeSlot}', style: const TextStyle(color: Colors.grey)),
                    const Divider(height: 24),
                    _SummaryRow(label: '${l10n.adults} × ${data.adults}', value: formatEur(adultPrice * data.adults)),
                    if (data.children > 0)
                      _SummaryRow(label: '${l10n.children} × ${data.children}', value: formatEur(childPrice * data.children)),
                    const Divider(height: 24),
                    _SummaryRow(label: l10n.total, value: formatEur(finalTotal), bold: true),
                  ],
                ),
              ),
            ),
            if (creditType != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: RihlaColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Text(
                  l10n.creditNote(creditType, remainingCredit! - 1),
                  style: const TextStyle(color: RihlaColors.seaBlueDark),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l10n.payVendorNotice, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _confirm(context, data, creditType),
              child: Text(l10n.confirmBooking),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
