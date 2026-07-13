import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/gradient_image.dart';

/// S0 — Splash / Onboarding (FR-001-002). Waits for an explicit Get
/// Started / Sign In choice — no auto-advance timer.
///
/// TEMPORARY (until Phase 5 builds real Auth/OTP/Registration): "Get
/// Started" routes straight to the shell so Home/Profile stay reachable
/// for testing later phases. "Sign In" still points at the Phase-5
/// placeholder.
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
              child: GradientImage(icon: Icons.sailing, label: 'Hurghada, Red Sea'),
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
                    onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.shell),
                    child: Text(l10n.getStarted),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pushNamed(Routes.otp),
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
