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
            const Icon(Icons.lock_outline, size: 40, color: RihlaColors.seaBlue),
            const SizedBox(height: 12),
            Text(
              l10n.signInRequiredTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.signInRequiredBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                Navigator.of(context).pushNamed(Routes.auth, arguments: false);
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
