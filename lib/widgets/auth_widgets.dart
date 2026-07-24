import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'rihla_app_bar.dart';

/// The phone-entry hero: a single, slightly taller [RihlaAppBar] gradient that
/// hosts the sailing badge + "Rihla" wordmark centered — replacing the old
/// app-bar-plus-brand-strip double band with one gradient moment.
PreferredSizeWidget authHeroAppBar() {
  return RihlaAppBar(
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(96),
      child: SizedBox(
        height: 96,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: RihlaColors.onBrand.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(RihlaSpace.radius),
                border: Border.all(color: RihlaColors.onBrand.withValues(alpha: 0.28)),
              ),
              child: const Icon(Icons.sailing, color: RihlaColors.onBrand, size: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rihla',
              style: TextStyle(color: RihlaColors.onBrand, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Two-step progress indicator shared by the phone-entry and OTP screens
/// ("1. Phone" → "2. Code"), so the flow reads as short and finite.
class AuthStepIndicator extends StatelessWidget {
  /// 1 = phone entry, 2 = OTP.
  final int step;
  const AuthStepIndicator({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _segment(index: 1, label: l10n.stepPhone, active: step >= 1),
        const SizedBox(width: RihlaSpace.md),
        _segment(index: 2, label: l10n.stepCode, active: step >= 2),
      ],
    );
  }

  Widget _segment({required int index, required String label, required bool active}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            height: 4,
            decoration: BoxDecoration(
              color: active ? RihlaColors.seaBlue : RihlaColors.hairline,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$index. $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? RihlaColors.seaBlueDark : RihlaColors.inkFaint,
            ),
          ),
        ],
      ),
    );
  }
}

enum AuthButtonStatus { idle, loading, success }

/// Full-width gradient pill CTA that morphs label ↔ spinner ↔ checkmark in
/// place (no layout jump). The parent owns the [status]; while non-idle taps
/// are ignored.
class PrimaryAuthButton extends StatelessWidget {
  final String label;
  final AuthButtonStatus status;
  final VoidCallback? onPressed;

  const PrimaryAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.status = AuthButtonStatus.idle,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final busy = status != AuthButtonStatus.idle;

    final Widget child = switch (status) {
      AuthButtonStatus.idle => Text(
          label,
          key: const ValueKey('label'),
          style: const TextStyle(color: RihlaColors.onBrand, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.1),
        ),
      AuthButtonStatus.loading => const SizedBox(
          key: ValueKey('loading'),
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: RihlaColors.onBrand),
        ),
      AuthButtonStatus.success => const Icon(Icons.check_rounded, key: ValueKey('success'), color: RihlaColors.onBrand, size: 26),
    };

    return Semantics(
      button: true,
      enabled: onPressed != null && !busy,
      label: label,
      child: Opacity(
        opacity: onPressed == null && !busy ? 0.6 : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
          child: InkWell(
            onTap: busy ? null : onPressed,
            borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
            child: Ink(
              height: 56,
              decoration: BoxDecoration(
                color: RihlaColors.seaBlue,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating rounded confirmation toast with a leading icon — replaces the flat
/// default snackbar for auth confirmations ("Code sent to …"). Leans on the
/// app's floating [SnackBarThemeData] for shape/colour.
void showAuthToast(BuildContext context, String message, {IconData icon = Icons.check_circle_rounded}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: RihlaColors.lagoon, size: 20),
          const SizedBox(width: 10),
          Flexible(child: Text(message)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(RihlaSpace.lg),
    ),
  );
}
