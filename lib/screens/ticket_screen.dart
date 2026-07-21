import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/rihla_app_bar.dart';
import '../widgets/fade_in.dart';
import '../widgets/price_tag.dart';

/// S4 — Ticket Detail (FR-051-054).
class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  void _mockAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final booking = ModalRoute.of(context)!.settings.arguments as Booking;

    return Scaffold(
      appBar: const RihlaAppBar(leading: SizedBox.shrink()),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            Center(
              child: MediaQuery.of(context).disableAnimations
                  ? const Icon(Icons.check_circle_rounded, color: RihlaColors.statusSuccess, size: 72)
                  : TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutExpo,
                      builder: (context, t, child) => Opacity(
                        opacity: t,
                        child: Transform.scale(scale: 0.6 + (0.4 * t), child: child),
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: RihlaColors.statusSuccess, size: 72),
                    ),
            ),
            const SizedBox(height: RihlaSpace.md),
            Center(
              child: Text(
                l10n.bookingSubmitted,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink),
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: const Duration(milliseconds: 120),
              child: _TicketCard(booking: booking, l10n: l10n),
            ),
            const SizedBox(height: RihlaSpace.xl),
            Wrap(
              spacing: RihlaSpace.md,
              runSpacing: RihlaSpace.md,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _mockAction(context, l10n.download),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(l10n.download),
                ),
                OutlinedButton.icon(
                  onPressed: () => _mockAction(context, l10n.shareWhatsapp),
                  icon: const Icon(Icons.share_rounded),
                  label: Text(l10n.shareWhatsapp),
                ),
                OutlinedButton.icon(
                  onPressed: () => _mockAction(context, l10n.addCalendar),
                  icon: const Icon(Icons.event_available_rounded),
                  label: Text(l10n.addCalendar),
                ),
              ],
            ),
            const SizedBox(height: RihlaSpace.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.shell, (route) => false),
              child: Text(l10n.bookAnother),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Booking booking;
  final AppLocalizations l10n;
  const _TicketCard({required this.booking, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header band — the "stub" of the e-ticket.
          Container(
            decoration: const BoxDecoration(gradient: RihlaColors.seaGradient),
            padding: const EdgeInsets.all(RihlaSpace.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: RihlaColors.onBrand.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(RihlaSpace.radiusSm),
                  ),
                  child: Icon(booking.icon, color: RihlaColors.onBrand),
                ),
                const SizedBox(width: RihlaSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.referenceLabel.toUpperCase(),
                        style: const TextStyle(
                          color: RihlaColors.onBrandMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.experienceTitle,
                        style: const TextStyle(color: RihlaColors.onBrand, fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: -0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _DashedDivider(),
          Padding(
            padding: const EdgeInsets.all(RihlaSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TicketRow(icon: Icons.calendar_today_rounded, label: '${formatDate(booking.date)} · ${booking.time}'),
                _TicketRow(icon: Icons.people_outline_rounded, label: '${l10n.adults}: ${booking.adults}  ${l10n.children}: ${booking.children}'),
                const _TicketRow(icon: Icons.location_on_outlined, label: 'Hurghada, Egypt'),
                const SizedBox(height: RihlaSpace.md),
                _TicketRow(icon: Icons.confirmation_number_outlined, label: l10n.referenceLabel, value: booking.refCode),
                _TicketRow(icon: Icons.qr_code_2_rounded, label: l10n.ticketNumberLabel, value: booking.ticketNumber),
                const Divider(height: RihlaSpace.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.total, style: Theme.of(context).textTheme.bodyMedium),
                    if (booking.discountPct > 0)
                      PriceTag(
                        original: booking.originalPriceEur,
                        discounted: booking.finalPriceEur,
                        discountedFontSize: 18,
                      )
                    else
                      Text(
                        formatEur(booking.finalPriceEur),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: RihlaColors.ink),
                      ),
                  ],
                ),
                if (booking.discountPct > 0) ...[
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      l10n.discountApplied(booking.discountPct),
                      style: const TextStyle(fontSize: 12, color: RihlaColors.statusSuccess, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                const SizedBox(height: RihlaSpace.md),
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
                Text(
                  l10n.paymentDueNotice,
                  style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A dashed line that gives the card a torn ticket-stub feel.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const gap = 5.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: dashWidth, height: 1.5, color: RihlaColors.hairline),
          ),
        );
      },
    );
  }
}

class _TicketRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  const _TicketRow({required this.icon, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RihlaSpace.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: RihlaColors.seaBlue),
          const SizedBox(width: RihlaSpace.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: value == null ? RihlaColors.ink : RihlaColors.inkMuted,
                fontSize: 14,
              ),
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(color: RihlaColors.ink, fontWeight: FontWeight.w600, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
