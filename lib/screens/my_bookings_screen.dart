import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../utils/format.dart';

/// S6e — My Bookings History (FR-072). Hosted as the Bookings tab body
/// and reachable from Profile via Routes.myBookings.
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  Future<void> _confirmCancel(Booking booking) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.cancelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.cancelBooking)),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        booking.status = BookingStatus.cancelled;
        final creditType = booking.creditTypeConsumed;
        if (creditType != null) {
          userSubscription.creditsRemaining[creditType] = (userSubscription.creditsRemaining[creditType] ?? 0) + 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.myBookings, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...bookings.reversed.map((b) => _BookingCard(
                booking: b,
                onCancel: () => _confirmCancel(b),
              )),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onCancel;
  const _BookingCard({required this.booking, required this.onCancel});

  (Color, String) _statusVisual(AppLocalizations l10n) {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return (Colors.green, l10n.statusConfirmed);
      case BookingStatus.completed:
        return (RihlaColors.seaBlue, l10n.statusCompleted);
      case BookingStatus.cancelled:
        return (Colors.grey, l10n.statusCancelled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (statusColor, statusLabel) = _statusVisual(l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(booking.icon, color: RihlaColors.seaBlue),
                const SizedBox(width: 8),
                Expanded(child: Text(booking.experienceTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${formatDate(booking.date)} · ${booking.time}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            if (booking.discountPct > 0) ...[
              const SizedBox(height: 4),
              Text(l10n.discountApplied(booking.discountPct), style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
            const SizedBox(height: 8),
            Text(formatEur(booking.finalPriceEur), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (booking.status == BookingStatus.confirmed) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: onCancel, child: Text(l10n.cancelBooking)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
