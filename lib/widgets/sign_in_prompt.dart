import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';

/// Guest-gate prompt. When a guest attempts an account action (favoriting,
/// booking, subscribing, ...), the caller invokes this instead of performing
/// the action: a bottom sheet inviting sign-in. Tapping Sign In routes to the
/// Auth screen (Login tab); dismissing leaves the guest where they were.
Future<void> promptSignIn(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  gradient: RihlaColors.seaGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_rounded, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.signInRequiredTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.signInRequiredBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                Navigator.of(context).pushNamed(Routes.auth);
              },
              child: Text(l10n.signIn),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: Text(l10n.notNow),
            ),
          ],
        ),
      ),
    ),
  );
}
