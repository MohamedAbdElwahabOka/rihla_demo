import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/gradient_image.dart';

/// S0 — Splash / Onboarding (FR-001-002). Waits for an explicit Get
/// Started / Sign In choice — no auto-advance timer. Both buttons open
/// the Auth screen, defaulting to Register vs. Login respectively.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GradientImage(icon: Icons.sailing, label: l10n.splashLocation),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    l10n.appName,
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: RihlaColors.seaBlueDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushNamed(Routes.auth, arguments: true),
                    child: Text(l10n.getStarted),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pushNamed(Routes.auth, arguments: false),
                    child: Text(l10n.signIn),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
