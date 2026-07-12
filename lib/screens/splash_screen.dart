import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/gradient_image.dart';

/// S0 — Splash / Onboarding (FR-001-003). Auto-advances to the shell after
/// 3 seconds, simulating an already-authenticated returning traveler.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _autoAdvance;

  @override
  void initState() {
    super.initState();
    _autoAdvance = Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).pushReplacementNamed(Routes.shell);
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    super.dispose();
  }

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
                    onPressed: () => Navigator.of(context).pushNamed(Routes.auth),
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
