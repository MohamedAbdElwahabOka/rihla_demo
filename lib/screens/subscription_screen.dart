import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';
import '../widgets/rihla_badge.dart';

/// S6b — My Subscription.
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = userSubscription;

    if (sub == null) {
      return Scaffold(
        appBar: RihlaAppBar(title: Text(l10n.mySubscription)),
        body: SafeArea(
          child: Center(
            child: FadeInUp(
              child: Padding(
                padding: const EdgeInsets.all(RihlaSpace.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(color: RihlaColors.seaTint, shape: BoxShape.circle),
                      child: const Icon(Icons.card_membership_rounded, size: 40, color: RihlaColors.seaBlue),
                    ),
                    const SizedBox(height: RihlaSpace.lg),
                    Text(
                      l10n.noActivePlan,
                      style: const TextStyle(fontSize: 16, color: RihlaColors.inkMuted, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: RihlaSpace.xl),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pushNamed(Routes.plans),
                      child: Text(l10n.subscriptionPlans),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final plan = sub.plan;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.mySubscription)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            FadeInUp(
              child: Container(
                padding: const EdgeInsets.all(RihlaSpace.xl),
                decoration: BoxDecoration(
                  gradient: RihlaColors.seaGradient,
                  borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                  boxShadow: RihlaShadows.raised,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                              color: RihlaColors.onBrand,
                            ),
                          ),
                        ),
                        const SizedBox(width: RihlaSpace.md),
                        sub.active
                            ? RihlaBadge.sunset(l10n.active, icon: Icons.check_circle_rounded)
                            : RihlaBadge(
                                label: l10n.statusCancelled,
                                background: RihlaColors.onBrandFaint,
                                icon: Icons.cancel_rounded,
                              ),
                      ],
                    ),
                    const SizedBox(height: RihlaSpace.sm),
                    Text(plan.description, style: const TextStyle(color: RihlaColors.onBrandMuted, height: 1.4)),
                    Container(height: 1, margin: const EdgeInsets.symmetric(vertical: RihlaSpace.lg), color: RihlaColors.onBrandFaint),
                    _HeroInfoRow(label: l10n.purchaseDate, value: formatDate(sub.purchaseDate)),
                    const SizedBox(height: RihlaSpace.md),
                    _HeroInfoRow(label: l10n.expiryDate, value: formatDate(sub.expiryDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            Text(
              l10n.creditsRemainingHeader,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink),
            ),
            const SizedBox(height: RihlaSpace.md),
            ...sub.creditsRemaining.entries.toList().asMap().entries.map((indexed) {
              final entry = indexed.value;
              final hasCredit = entry.value > 0;
              return FadeInUp(
                delay: Duration(milliseconds: indexed.key * 70),
                child: Container(
                  margin: const EdgeInsets.only(bottom: RihlaSpace.md),
                  padding: const EdgeInsets.all(RihlaSpace.md),
                  decoration: BoxDecoration(
                    color: RihlaColors.surface,
                    borderRadius: BorderRadius.circular(RihlaSpace.radius),
                    border: Border.all(color: RihlaColors.hairline),
                    boxShadow: RihlaShadows.soft,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: RihlaColors.seaTint,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.confirmation_number_rounded, size: 20, color: RihlaColors.seaBlue),
                      ),
                      const SizedBox(width: RihlaSpace.md),
                      Expanded(
                        child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, color: RihlaColors.ink)),
                      ),
                      Text(
                        hasCredit ? l10n.creditRemaining(entry.value) : l10n.creditUsed,
                        style: TextStyle(
                          color: hasCredit ? RihlaColors.seaBlueDark : RihlaColors.inkFaint,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: RihlaSpace.sm),
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

class _HeroInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _HeroInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: RihlaColors.onBrandMuted, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: RihlaColors.onBrand)),
      ],
    );
  }
}
