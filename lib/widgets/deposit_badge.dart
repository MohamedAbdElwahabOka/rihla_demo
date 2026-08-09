import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';

/// Security deposit status badge — the single treatment reused everywhere a
/// deposit appears (booking confirmation, Ticket Detail, My Bookings card).
class DepositBadge extends StatelessWidget {
  final DepositStatus status;
  const DepositBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (IconData icon, Color bg, Color fg, String label) = switch (status) {
      DepositStatus.notYetHeld => (
          Icons.schedule_rounded,
          RihlaColors.hairline,
          RihlaColors.inkMuted,
          l10n.depositNotYetHeld,
        ),
      DepositStatus.held => (
          Icons.lock_rounded,
          RihlaColors.statusSuccessTint,
          RihlaColors.statusSuccess,
          l10n.depositHeld,
        ),
      DepositStatus.released => (
          Icons.check_circle_rounded,
          RihlaColors.seaTint,
          RihlaColors.seaBlueDark,
          l10n.depositReleased,
        ),
      DepositStatus.captured => (
          Icons.block_rounded,
          RihlaColors.coral.withValues(alpha: 0.12),
          RihlaColors.coral,
          l10n.depositCaptured,
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
