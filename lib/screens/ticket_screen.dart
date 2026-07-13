import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';

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
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 72),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(l10n.bookingSubmitted, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(booking.icon, color: RihlaColors.seaBlue),
                        const SizedBox(width: 8),
                        Expanded(child: Text(booking.experienceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(l10n.statusConfirmed, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _TicketRow(icon: Icons.calendar_today, label: '${formatDate(booking.date)} · ${booking.time}'),
                    _TicketRow(icon: Icons.people_outline, label: '${l10n.adults}: ${booking.adults}  ${l10n.children}: ${booking.children}'),
                    _TicketRow(icon: Icons.location_on_outlined, label: 'Hurghada, Egypt'),
                    const Divider(height: 28),
                    _TicketRow(icon: Icons.confirmation_number_outlined, label: '${l10n.referenceLabel}: ${booking.refCode}'),
                    _TicketRow(icon: Icons.qr_code, label: '${l10n.ticketNumberLabel}: ${booking.ticketNumber}'),
                    const SizedBox(height: 8),
                    Text(l10n.paymentDueNotice, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _mockAction(context, l10n.download),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l10n.download),
                ),
                OutlinedButton.icon(
                  onPressed: () => _mockAction(context, l10n.shareWhatsapp),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(l10n.shareWhatsapp),
                ),
                OutlinedButton.icon(
                  onPressed: () => _mockAction(context, l10n.addCalendar),
                  icon: const Icon(Icons.event_available_outlined),
                  label: Text(l10n.addCalendar),
                ),
              ],
            ),
            const SizedBox(height: 16),
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

class _TicketRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TicketRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
