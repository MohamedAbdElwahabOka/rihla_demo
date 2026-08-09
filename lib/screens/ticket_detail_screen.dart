import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/booking_status_pill.dart';
import '../widgets/deposit_badge.dart';
import '../widgets/fade_in.dart';
import '../widgets/local_image.dart';
import '../widgets/rihla_app_bar.dart';

/// Persistent Ticket Detail — the full-screen destination reached by tapping
/// a booking in My Bookings (replaces the old bottom sheet). Distinct from
/// [TicketScreen] (S4), which stays as the immediate post-booking moment.
class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  String _thumbFor(Booking b) {
    for (final e in experiences) {
      if (e.title == b.experienceTitle) return e.primaryImage;
    }
    return '';
  }

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
    if (mounted) setState(() {});
  }

  void _contactSupport(AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.contactSupport)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final booking = ModalRoute.of(context)!.settings.arguments as Booking;
    final thumb = _thumbFor(booking);

    final showCancel = booking.status == BookingStatus.confirmed;
    final showReview = booking.status == BookingStatus.completed && !booking.reviewLeft && booking.hasEnded;
    final showContactSupport = booking.status == BookingStatus.missedNoShow;

    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.bookingDetails)),
      body: SafeArea(
        child: FadeInUp(
          child: ListView(
            padding: const EdgeInsets.all(RihlaSpace.lg),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RihlaSpace.radius),
                    child: SizedBox(
                      width: 84,
                      height: 84,
                      child: LocalImage(path: thumb, icon: booking.icon, label: booking.experienceTitle),
                    ),
                  ),
                  const SizedBox(width: RihlaSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.experienceTitle,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: RihlaColors.ink, height: 1.2)),
                        const SizedBox(height: 4),
                        Text(booking.vendorName, style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 13)),
                        const SizedBox(height: RihlaSpace.sm),
                        Wrap(
                          spacing: RihlaSpace.sm,
                          runSpacing: RihlaSpace.sm,
                          children: [
                            BookingStatusPill(status: booking.status),
                            DepositBadge(status: booking.deposit.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RihlaSpace.lg),
              const Divider(height: 1),
              const SizedBox(height: RihlaSpace.md),
              _DetailRow(icon: Icons.event_rounded, label: '${formatDate(booking.date)} · ${booking.time}'),
              const SizedBox(height: RihlaSpace.sm),
              _DetailRow(
                icon: Icons.group_rounded,
                label: '${booking.adults} ${l10n.adults} · ${booking.children} ${l10n.children}',
              ),
              if (booking.discountPct > 0) ...[
                const SizedBox(height: RihlaSpace.sm),
                _DetailRow(icon: Icons.local_offer_rounded, label: l10n.discountApplied(booking.discountPct), color: RihlaColors.coral),
              ],
              const SizedBox(height: RihlaSpace.sm),
              _DetailRow(
                icon: Icons.shield_outlined,
                label: '${l10n.depositLabel} · ${formatEur(booking.deposit.amountEur)} (${booking.deposit.percentage}%)',
              ),
              const SizedBox(height: RihlaSpace.md),
              Row(
                children: [
                  Text(l10n.total, style: const TextStyle(color: RihlaColors.inkMuted, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (booking.discountPct > 0) ...[
                    Text(formatEur(booking.originalPriceEur),
                        style: const TextStyle(decoration: TextDecoration.lineThrough, color: RihlaColors.inkFaint, fontSize: 14)),
                    const SizedBox(width: 6),
                  ],
                  Text(formatEur(booking.finalPriceEur),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: RihlaColors.ink, letterSpacing: -0.3)),
                ],
              ),
              const SizedBox(height: RihlaSpace.lg),
              // Ticket block — the credential-style summary.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(RihlaSpace.lg),
                decoration: BoxDecoration(
                  gradient: RihlaColors.seaGradient,
                  borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.ticketNumberLabel,
                        style: const TextStyle(color: RihlaColors.onBrandMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(booking.ticketNumber,
                        style: const TextStyle(color: RihlaColors.onBrand, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 1)),
                    const SizedBox(height: RihlaSpace.md),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.referenceLabel,
                                  style: const TextStyle(color: RihlaColors.onBrandMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(booking.refCode, style: const TextStyle(color: RihlaColors.onBrand, fontSize: 14, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const Icon(Icons.confirmation_number_rounded, color: RihlaColors.onBrandFaint, size: 40),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RihlaSpace.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: RihlaSpace.lg),
                decoration: BoxDecoration(
                  color: RihlaColors.seaTint,
                  borderRadius: BorderRadius.circular(RihlaSpace.radiusSm),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2_rounded, size: 84, color: RihlaColors.seaBlueDark),
                    const SizedBox(height: RihlaSpace.sm),
                    Text(
                      booking.ticketNumber,
                      style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RihlaSpace.md),
              Text(l10n.paymentDueNotice, style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted, height: 1.4)),
              if (showCancel || showReview || showContactSupport) ...[
                const SizedBox(height: RihlaSpace.xl),
                SizedBox(
                  width: double.infinity,
                  child: showReview
                      ? FilledButton.icon(
                          onPressed: () => _openWriteReview(booking),
                          icon: const Icon(Icons.star_rounded, size: 18),
                          label: Text(l10n.rateExperience),
                        )
                      : showContactSupport
                          ? FilledButton.icon(
                              onPressed: () => _contactSupport(l10n),
                              icon: const Icon(Icons.support_agent_rounded, size: 18),
                              label: Text(l10n.contactSupport),
                            )
                          : OutlinedButton(
                              onPressed: () => _confirmCancel(booking),
                              style: OutlinedButton.styleFrom(foregroundColor: RihlaColors.statusCancelled),
                              child: Text(l10n.cancelBooking),
                            ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _DetailRow({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: color ?? RihlaColors.inkMuted),
        const SizedBox(width: RihlaSpace.sm),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 14, color: color ?? RihlaColors.ink, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
