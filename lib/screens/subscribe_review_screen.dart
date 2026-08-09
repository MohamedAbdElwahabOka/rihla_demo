import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../subscription_purchase_data.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/price_tag.dart';
import '../widgets/rihla_app_bar.dart';

const int _minAdults = 1;
const int _maxAdults = 6;
const int _minChildren = 0;
const int _maxChildren = 6;

/// Subscription purchase Step 1 of 2 — Headcount & Price Review. Mirrors the
/// booking flow's step pattern (stepper, sticky action bar) for a plan that
/// currently has no headcount concept: every traveler — adult or child (ages
/// 1-11) — adds one full set of the plan's credits, but a child only pays
/// 50% of the plan's price.
class SubscribeReviewScreen extends StatefulWidget {
  const SubscribeReviewScreen({super.key});

  @override
  State<SubscribeReviewScreen> createState() => _SubscribeReviewScreenState();
}

class _SubscribeReviewScreenState extends State<SubscribeReviewScreen> {
  final _promoController = TextEditingController();
  int _adults = 1;
  int _children = 0;
  int _promoDiscountPct = 0;
  String? _promoError;
  bool _processing = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      if (code.toUpperCase() == demoPromoCode) {
        _promoDiscountPct = demoPromoDiscountPct;
        _promoError = null;
      } else {
        _promoDiscountPct = 0;
        _promoError = AppLocalizations.of(context)!.promoInvalid;
      }
    });
  }

  Future<void> _confirmAndPay(BuildContext context, SubscriptionPlan plan) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _processing = true);
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

    final multipliedCredits = <String, int>{
      for (final entry in plan.credits.entries) entry.key: entry.value * (_adults + _children),
    };
    userSubscription = UserSubscription(
      plan: plan,
      purchaseDate: DateTime.now(),
      expiryDate: DateTime.now().add(Duration(days: plan.validityDays)),
      creditsRemaining: multipliedCredits,
    );

    Navigator.of(context).pushReplacementNamed(
      Routes.subscribeResult,
      arguments: SubscriptionPurchaseData(
        plan: plan,
        adults: _adults,
        children: _children,
        promoCode: _promoDiscountPct > 0 ? demoPromoCode : null,
        promoDiscountPct: _promoDiscountPct,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = ModalRoute.of(context)!.settings.arguments as SubscriptionPurchaseData;
    final plan = data.plan;

    final childPriceEur = (plan.priceEur * 0.5).round();
    final subtotal = plan.priceEur * _adults + childPriceEur * _children;
    final finalTotal = (subtotal * (100 - _promoDiscountPct) / 100).round();

    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.reviewAndPay)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            const _SubscribeStepper(current: 0),
            const SizedBox(height: RihlaSpace.xl),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.3, color: RihlaColors.ink)),
                  const SizedBox(height: 4),
                  Text(plan.description, style: const TextStyle(color: RihlaColors.inkMuted, height: 1.4)),
                  const SizedBox(height: RihlaSpace.sm),
                  Text('${formatEur(plan.priceEur)} · ${l10n.validity(plan.validityDays)}',
                      style: const TextStyle(color: RihlaColors.inkFaint, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: RihlaSpace.lg),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.travelers,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: RihlaColors.ink)),
                  const SizedBox(height: RihlaSpace.sm),
                  _TravelerStepper(
                    label: l10n.adults,
                    value: _adults,
                    onDecrement: _adults > _minAdults ? () => setState(() => _adults--) : null,
                    onIncrement: _adults < _maxAdults ? () => setState(() => _adults++) : null,
                  ),
                  const Divider(height: RihlaSpace.lg),
                  _TravelerStepper(
                    label: l10n.children,
                    value: _children,
                    onDecrement: _children > _minChildren ? () => setState(() => _children--) : null,
                    onIncrement: _children < _maxChildren ? () => setState(() => _children++) : null,
                  ),
                  const SizedBox(height: RihlaSpace.sm),
                  Text(l10n.childPriceNote,
                      style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: RihlaSpace.lg),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.creditsGranted,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: RihlaColors.ink)),
                  const SizedBox(height: RihlaSpace.md),
                  ...plan.credits.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: RihlaSpace.sm),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 18, color: RihlaColors.seaBlue),
                            const SizedBox(width: RihlaSpace.sm),
                            Text('${e.value * (_adults + _children)}× ${e.key}',
                                style: const TextStyle(fontSize: 14, color: RihlaColors.ink, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: RihlaSpace.lg),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          decoration: InputDecoration(hintText: l10n.promoCodeHint),
                        ),
                      ),
                      const SizedBox(width: RihlaSpace.sm),
                      OutlinedButton(
                        onPressed: _applyPromo,
                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 54)),
                        child: Text(l10n.applyPromo),
                      ),
                    ],
                  ),
                  if (_promoError != null) ...[
                    const SizedBox(height: RihlaSpace.sm),
                    Text(_promoError!, style: const TextStyle(color: RihlaColors.statusCancelled, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                  if (_promoDiscountPct > 0) ...[
                    const SizedBox(height: RihlaSpace.sm),
                    Text(l10n.promoAppliedNote(_promoDiscountPct),
                        style: const TextStyle(color: RihlaColors.statusSuccess, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                  const Divider(height: RihlaSpace.xl + RihlaSpace.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.total, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: RihlaColors.ink)),
                      if (_promoDiscountPct > 0)
                        PriceTag(original: subtotal, discounted: finalTotal, discountedFontSize: 16)
                      else
                        Text(formatEur(subtotal),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: RihlaColors.seaBlueDark)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StickyActionBar(
        child: FilledButton(
          onPressed: _processing ? null : () => _confirmAndPay(context, plan),
          child: Text(l10n.confirmAndPay),
        ),
      ),
    );
  }
}

class _TravelerStepper extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  const _TravelerStepper({required this.label, required this.value, this.onDecrement, this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: RihlaColors.ink)),
        ),
        _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),
        SizedBox(
          width: 44,
          child: Text('$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: RihlaColors.ink)),
        ),
        _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? RihlaColors.seaTint : RihlaColors.bg,
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? RihlaColors.seaBlue.withValues(alpha: 0.35) : RihlaColors.hairline),
        ),
        child: Icon(icon, size: 20, color: enabled ? RihlaColors.seaBlue : RihlaColors.inkFaint),
      ),
    );
  }
}

/// Segmented progress bar for the 2-step subscription purchase flow.
class _SubscribeStepper extends StatelessWidget {
  final int current;
  const _SubscribeStepper({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(2, (i) {
        final done = i <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 1 ? RihlaSpace.sm : 0.0),
            height: 6,
            decoration: BoxDecoration(
              color: done ? RihlaColors.seaBlue : RihlaColors.hairline,
              borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            ),
          ),
        );
      }),
    );
  }
}

/// Sticky bottom action bar: a rounded surface lifted off the content with an
/// upward soft shadow, hosting the primary CTA.
class _StickyActionBar extends StatelessWidget {
  final Widget child;
  const _StickyActionBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RihlaSpace.radiusLg)),
        boxShadow: RihlaShadows.stickyBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, RihlaSpace.md, RihlaSpace.lg, RihlaSpace.md),
          child: child,
        ),
      ),
    );
  }
}
