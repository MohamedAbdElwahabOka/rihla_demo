import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';

/// Soft rounded status pill (Confirmed / Completed / Cancelled / Missed) —
/// shared between the My Bookings card and the Ticket Detail screen.
class BookingStatusPill extends StatelessWidget {
  final BookingStatus status;
  const BookingStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (IconData icon, Color bg, Color fg, String label) = switch (status) {
      BookingStatus.confirmed => (
          Icons.check_circle_rounded,
          RihlaColors.statusSuccessTint,
          RihlaColors.statusSuccess,
          l10n.statusConfirmed,
        ),
      BookingStatus.completed => (
          Icons.verified_rounded,
          RihlaColors.goldTint,
          RihlaColors.statusPending,
          l10n.statusCompleted,
        ),
      BookingStatus.cancelled => (
          Icons.cancel_rounded,
          RihlaColors.statusCancelledTint,
          RihlaColors.statusCancelled,
          l10n.statusCancelled,
        ),
      BookingStatus.missedNoShow => (
          Icons.event_busy_rounded,
          RihlaColors.coral.withValues(alpha: 0.12),
          RihlaColors.coral,
          l10n.statusMissedNoShow,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.2)),
        ],
      ),
    );
  }
}
