import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../utils/format.dart';

/// S6c — Subscription Plans (SS4.8).
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  Future<void> _purchase(BuildContext context, SubscriptionPlan plan) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.purchaseConfirm(plan.name, formatEur(plan.priceEur))),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.confirm)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(l10n.processingPayment)),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    userSubscription = UserSubscription(
      plan: plan,
      purchaseDate: DateTime.now(),
      expiryDate: DateTime.now().add(Duration(days: plan.validityDays)),
      creditsRemaining: Map<String, int>.from(plan.credits),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.purchaseSuccess)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscriptionPlans)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: subscriptionPlans.map((plan) => _PlanCard(plan: plan, onTap: () => _purchase(context, plan))).toList(),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onTap;
  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(plan.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  Text(formatEur(plan.priceEur), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RihlaColors.seaBlueDark)),
                ],
              ),
              const SizedBox(height: 4),
              Text(plan.description, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(l10n.validity(plan.validityDays), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Divider(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: plan.credits.entries
                    .map((e) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: RihlaColors.bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                          child: Text('${e.value}× ${e.key}', style: const TextStyle(fontSize: 12)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
