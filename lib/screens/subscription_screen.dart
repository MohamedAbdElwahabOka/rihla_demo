import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';

/// S6b — My Subscription.
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = userSubscription;

    if (sub == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.mySubscription)),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.card_membership_outlined, size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(l10n.noActivePlan, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushNamed(Routes.plans),
                    child: Text(l10n.subscriptionPlans),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final plan = sub.plan;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mySubscription)),
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
                    Row(
                      children: [
                        Expanded(child: Text(plan.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (sub.active ? Colors.green : Colors.grey).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            sub.active ? l10n.active : l10n.statusCancelled,
                            style: TextStyle(color: sub.active ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(plan.description, style: const TextStyle(color: Colors.grey)),
                    const Divider(height: 24),
                    _InfoRow(label: l10n.purchaseDate, value: formatDate(sub.purchaseDate)),
                    _InfoRow(label: l10n.expiryDate, value: formatDate(sub.expiryDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.creditsRemainingHeader, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...sub.creditsRemaining.entries.map((entry) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.confirmation_number_outlined, color: RihlaColors.seaBlue),
                    title: Text(entry.key),
                    trailing: Text(
                      entry.value > 0 ? l10n.creditRemaining(entry.value) : l10n.creditUsed,
                      style: TextStyle(color: entry.value > 0 ? RihlaColors.seaBlueDark : Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamed(Routes.refund),
                child: Text(l10n.refundRequest),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
