import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';

/// S0 — Splash / Onboarding (FR-001-002). Waits for an explicit Get
/// Started / Sign In choice — no auto-advance timer. Both buttons open
/// the Auth screen, defaulting to Register vs. Login respectively.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: RihlaColors.seaGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Hero: brand mark floating over the sea wash with a soft
              // sunlit highlight and a decorative horizon glow.
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0, -0.35),
                          radius: 1.1,
                          colors: [Color(0x33FFFFFF), Color(0x00FFFFFF)],
                        ),
                      ),
                    ),
                    Center(
                      child: FadeInUp(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                              ),
                              child: const Icon(Icons.sailing, size: 54, color: Colors.white),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.appName,
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48),
                              child: Text(
                                l10n.tagline,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action sheet: rounded white card lifting off the gradient.
              FadeInUp(
                delay: const Duration(milliseconds: 180),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: RihlaColors.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton(
                          // Auto-enter guest: browse the app without logging in.
                          // Account actions are gated behind sign-in individually.
                          onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.shell),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
