import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';
import '../widgets/sign_in_prompt.dart';

/// S6c — Subscription Plans (SS4.8).
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  Future<void> _purchase(BuildContext context, SubscriptionPlan plan) async {
    if (isGuest) {
      promptSignIn(context);
      return;
    }
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
    // Visual emphasis only — spotlight the middle tier as the standout plan.
    final featuredIndex = subscriptionPlans.length ~/ 2;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.subscriptionPlans)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            for (var i = 0; i < subscriptionPlans.length; i++)
              FadeInUp(
                delay: Duration(milliseconds: i * 90),
                child: _PlanCard(
                  plan: subscriptionPlans[i],
                  featured: i == featuredIndex,
                  onTap: () => _purchase(context, subscriptionPlans[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool featured;
  final VoidCallback onTap;
  const _PlanCard({required this.plan, required this.featured, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final titleColor = featured ? Colors.white : RihlaColors.ink;
    final priceColor = featured ? Colors.white : RihlaColors.seaBlueDark;
    final descColor = featured ? Colors.white70 : RihlaColors.inkMuted;
    final faintColor = featured ? Colors.white60 : RihlaColors.inkFaint;
    final dividerColor = featured ? Colors.white24 : RihlaColors.hairline;
    final checkColor = featured ? RihlaColors.gold : RihlaColors.seaBlue;
    final featureColor = featured ? Colors.white : RihlaColors.ink;

    return Container(
      margin: const EdgeInsets.only(bottom: RihlaSpace.lg),
      decoration: BoxDecoration(
        gradient: featured ? RihlaColors.seaGradient : null,
        color: featured ? null : RihlaColors.surface,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
        border: featured ? null : Border.all(color: RihlaColors.hairline),
        boxShadow: RihlaShadows.card,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(RihlaSpace.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: titleColor,
                          ),
                        ),
                      ),
                      if (featured)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: RihlaColors.sunsetGradient,
                            borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
                            boxShadow: RihlaShadows.soft,
                          ),
                          child: const Icon(Icons.star_rounded, size: 16, color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: RihlaSpace.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatEur(plan.priceEur),
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8, color: priceColor),
                      ),
                      const SizedBox(width: RihlaSpace.sm),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(l10n.validity(plan.validityDays), style: TextStyle(color: faintColor, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: RihlaSpace.xs),
                  Text(plan.description, style: TextStyle(color: descColor, height: 1.4)),
                  Container(height: 1, margin: const EdgeInsets.symmetric(vertical: RihlaSpace.lg), color: dividerColor),
                  ...plan.credits.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: RihlaSpace.md),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded, size: 20, color: checkColor),
                            const SizedBox(width: RihlaSpace.md),
                            Expanded(
                              child: Text(
                                '${e.value}× ${e.key}',
                                style: TextStyle(fontSize: 14, color: featureColor, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: RihlaSpace.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: featured ? Colors.white : RihlaColors.seaTint,
                      borderRadius: BorderRadius.circular(RihlaSpace.radius),
                    ),
                    child: Icon(Icons.arrow_forward_rounded, size: 20, color: featured ? RihlaColors.seaBlueDark : RihlaColors.seaBlue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
