import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../subscription_purchase_data.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/fade_in.dart';
import '../widgets/price_tag.dart';
import '../widgets/rihla_app_bar.dart';

/// Subscription purchase Step 2 of 2 — Payment Result. Gives the purchase
/// moment a full screen (matching [TicketScreen]'s register) instead of the
/// SnackBar the flow used to end on.
class SubscribeResultScreen extends StatelessWidget {
  const SubscribeResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = ModalRoute.of(context)!.settings.arguments as SubscriptionPurchaseData;
    final plan = data.plan;
    final card = paymentMethods.first;

    final childPriceEur = (plan.priceEur * 0.5).round();
    final subtotal = plan.priceEur * data.adults + childPriceEur * data.children;
    final finalTotal = (subtotal * (100 - data.promoDiscountPct) / 100).round();

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
                l10n.purchaseSuccess,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink),
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: const Duration(milliseconds: 120),
              child: Container(
                decoration: BoxDecoration(
                  color: RihlaColors.surface,
                  borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                  boxShadow: RihlaShadows.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(gradient: RihlaColors.seaGradient),
                      padding: const EdgeInsets.all(RihlaSpace.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.name,
                              style: const TextStyle(color: RihlaColors.onBrand, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.3)),
                          const SizedBox(height: 2),
                          Text(
                            data.children > 0 ? l10n.forAdultsAndChildren(data.adults, data.children) : l10n.forTravelers(data.adults),
                            style: const TextStyle(color: RihlaColors.onBrandMuted, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(RihlaSpace.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.creditsGranted,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: RihlaColors.ink)),
                          const SizedBox(height: RihlaSpace.sm),
                          ...plan.credits.entries.map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: RihlaSpace.xs),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, size: 16, color: RihlaColors.seaBlue),
                                    const SizedBox(width: RihlaSpace.sm),
                                    Text('${e.value * (data.adults + data.children)}× ${e.key}',
                                        style: const TextStyle(fontSize: 14, color: RihlaColors.ink, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              )),
                          const Divider(height: RihlaSpace.xl),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.total, style: Theme.of(context).textTheme.bodyMedium),
                              if (data.promoDiscountPct > 0)
                                PriceTag(original: subtotal, discounted: finalTotal, discountedFontSize: 18)
                              else
                                Text(formatEur(finalTotal),
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: RihlaColors.ink)),
                            ],
                          ),
                          if (data.promoDiscountPct > 0) ...[
                            const SizedBox(height: 2),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(l10n.promoAppliedNote(data.promoDiscountPct),
                                  style: const TextStyle(fontSize: 12, color: RihlaColors.statusSuccess, fontWeight: FontWeight.w600)),
                            ),
                          ],
                          const SizedBox(height: RihlaSpace.md),
                          Row(
                            children: [
                              const Icon(Icons.credit_card_rounded, size: 18, color: RihlaColors.inkMuted),
                              const SizedBox(width: RihlaSpace.sm),
                              Text(l10n.cardEndingIn(card.brand, card.last4),
                                  style: const TextStyle(fontSize: 13, color: RihlaColors.inkMuted, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.subscription, (route) => route.isFirst),
              child: Text(l10n.viewMySubscription),
            ),
          ],
        ),
      ),
    );
  }
}
