import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/rihla_app_bar.dart';
import '../widgets/rihla_badge.dart';
import '../widgets/fade_in.dart';

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

    // Guests have no bookings — they can't book until signed in. Gate the
    // whole screen behind a sign-in prompt rather than showing the demo
    // account's bookings.
    if (isGuest) {
      final guest = const SafeArea(child: _GuestBookings());
      if (!widget.standalone) return guest;
      return Scaffold(appBar: RihlaAppBar(title: Text(l10n.myBookings)), body: guest);
    }

    final items = bookings.reversed.toList();
    final content = SafeArea(
      child: items.isEmpty
          ? _EmptyBookings()
          : ListView(
              padding: const EdgeInsets.all(RihlaSpace.lg),
              children: [
                if (!widget.standalone) ...[
                  Text(
                    l10n.myBookings,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: RihlaColors.ink,
                    ),
                  ),
                  const SizedBox(height: RihlaSpace.lg),
                ],
                for (var i = 0; i < items.length; i++)
                  FadeInUp(
                    delay: Duration(milliseconds: i * 60),
                    child: _BookingCard(
                      booking: items[i],
                      onCancel: () => _confirmCancel(items[i]),
                      onReview: () => _openWriteReview(items[i]),
                    ),
                  ),
              ],
            ),
    );
    if (!widget.standalone) return content;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.myBookings)),
      body: content,
    );
  }
}

class _GuestBookings extends StatelessWidget {
  const _GuestBookings();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FadeInUp(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(RihlaSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RihlaColors.seaGradient,
                  boxShadow: [
                    BoxShadow(color: RihlaColors.seaBlue.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 44),
              ),
              const SizedBox(height: RihlaSpace.lg),
              Text(
                l10n.guestModeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink),
              ),
              const SizedBox(height: RihlaSpace.sm),
              Text(
                l10n.guestModeBody,
                textAlign: TextAlign.center,
                style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5),
              ),
              const SizedBox(height: RihlaSpace.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushNamed(Routes.auth, arguments: false),
                  child: Text(l10n.signIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 88,
        height: 88,
        decoration: const BoxDecoration(color: RihlaColors.seaTint, shape: BoxShape.circle),
        child: const Icon(Icons.confirmation_number_rounded, size: 42, color: RihlaColors.seaBlue),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onCancel;
  final VoidCallback onReview;
  const _BookingCard({required this.booking, required this.onCancel, required this.onReview});

  Widget _statusBadge(AppLocalizations l10n) {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return RihlaBadge(
          label: l10n.statusConfirmed,
          icon: Icons.check_circle_rounded,
          background: const Color(0xFFE3F5EC),
          foreground: const Color(0xFF1F8A5B),
        );
      case BookingStatus.completed:
        return RihlaBadge(
          label: l10n.statusCompleted,
          icon: Icons.verified_rounded,
          background: RihlaColors.goldTint,
          foreground: const Color(0xFF9A6B12),
        );
      case BookingStatus.cancelled:
        return RihlaBadge(
          label: l10n.statusCancelled,
          icon: Icons.cancel_rounded,
          background: const Color(0xFFFCE7E3),
          foreground: const Color(0xFFC94A38),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: RihlaSpace.md),
      child: Padding(
        padding: const EdgeInsets.all(RihlaSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: RihlaColors.seaTint,
                    borderRadius: BorderRadius.circular(RihlaSpace.radiusSm),
                  ),
                  child: Icon(booking.icon, color: RihlaColors.seaBlue),
                ),
                const SizedBox(width: RihlaSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.experienceTitle,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: RihlaColors.ink),
                      ),
                      const SizedBox(height: RihlaSpace.xs),
                      Text(
                        '${formatDate(booking.date)} · ${booking.time}',
                        style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: RihlaSpace.sm),
                _statusBadge(l10n),
              ],
            ),
            if (booking.discountPct > 0) ...[
              const SizedBox(height: RihlaSpace.sm),
              Text(
                l10n.discountApplied(booking.discountPct),
                style: const TextStyle(color: RihlaColors.coral, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: RihlaSpace.md),
            Text(
              formatEur(booking.finalPriceEur),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: RihlaColors.ink, letterSpacing: -0.4),
            ),
            if (booking.status == BookingStatus.confirmed) ...[
              const SizedBox(height: RihlaSpace.xs),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: onCancel, child: Text(l10n.cancelBooking)),
              ),
            ],
            if (booking.status == BookingStatus.completed && !booking.reviewLeft) ...[
              const SizedBox(height: RihlaSpace.xs),
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
