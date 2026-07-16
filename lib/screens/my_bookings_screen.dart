import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';

/// S6e — My Bookings History (FR-072). Hosted as the Bookings tab body
/// (no own Scaffold -- relies on MainShell's) and also reachable
/// standalone from Profile via Routes.myBookings (needs its own Scaffold
/// there, since MainShell isn't an ancestor of a pushed route).
class MyBookingsScreen extends StatefulWidget {
  final bool standalone;
  const MyBookingsScreen({super.key, this.standalone = false});

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
        final sub = userSubscription;
        if (creditType != null && sub != null) {
          sub.creditsRemaining[creditType] = (sub.creditsRemaining[creditType] ?? 0) + 1;
        }
      });
    }
  }

  Future<void> _openWriteReview(Booking booking) async {
    await Navigator.of(context).pushNamed(Routes.writeReview, arguments: booking);
    // Refresh so a just-submitted review hides the CTA (reviewLeft is now true).
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!widget.standalone) ...[
            Text(l10n.myBookings, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
          ],
          ...bookings.reversed.map((b) => _BookingCard(
                booking: b,
                onCancel: () => _confirmCancel(b),
                onReview: () => _openWriteReview(b),
              )),
        ],
      ),
    );
    if (!widget.standalone) return content;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myBookings)),
      body: content,
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onCancel;
  final VoidCallback onReview;
  const _BookingCard({required this.booking, required this.onCancel, required this.onReview});

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
            if (booking.status == BookingStatus.completed && !booking.reviewLeft) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: onReview, child: Text(l10n.writeReview)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
