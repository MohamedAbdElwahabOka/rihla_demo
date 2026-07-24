import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

const _resendCooldownSeconds = 30;

/// S9 — OTP entry (FR-005/007b). Any 6-digit code is accepted as valid
/// except [demoExpiredOtp], which demonstrates the expired-code error path.
///
/// Redesigned to share the phone screen's single-focus onboarding language:
/// step indicator, masked-number subline, richer box states with an
/// error-shake, paste/autofill distribution, and a resend cooldown. The
/// verification logic and branching are unchanged.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _remainingRequests = 4;
  String? _error;

  late final AnimationController _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

  Timer? _cooldownTimer;
  int _cooldown = _resendCooldownSeconds;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _shake.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = _resendCooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _cooldown--);
      if (_cooldown <= 0) timer.cancel();
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _clearBoxes() {
    for (final c in _controllers) {
      c.clear();
    }
  }

  /// Handles both single-digit typing and a pasted / SMS-autofilled string:
  /// a multi-character value is spread across the boxes from [index] onward.
  void _onChanged(int index, String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (_error != null) setState(() => _error = null);

    if (digits.isEmpty) {
      _controllers[index].text = '';
      if (index > 0) _focusNodes[index - 1].requestFocus();
      return;
    }

    if (digits.length == 1) {
      _controllers[index].text = digits;
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
      if (index < 5) _focusNodes[index + 1].requestFocus();
    } else {
      // Paste / autofill: distribute across the boxes.
      for (var k = 0; k < digits.length && index + k < 6; k++) {
        _controllers[index + k].text = digits[k];
        _controllers[index + k].selection = const TextSelection.collapsed(offset: 1);
      }
      final next = (index + digits.length).clamp(0, 5);
      _focusNodes[next].requestFocus();
    }

    if (_controllers.every((c) => c.text.isNotEmpty)) _verify();
  }

  void _verify() {
    final l10n = AppLocalizations.of(context)!;
    final request = ModalRoute.of(context)!.settings.arguments as AuthRequest;

    if (_code == demoExpiredOtp) {
      _triggerError(l10n.otpExpired);
      return;
    }

    // Compare digits only — users type numbers without the demo's exact spacing.
    final matchesRegistered = request.countryCode == registeredPhoneCountryCode &&
        request.phone.replaceAll(RegExp(r'\s'), '') == registeredPhoneNumber.replaceAll(RegExp(r'\s'), '');
    if (matchesRegistered) {
      currentUser = registeredUserProfile;
      userSubscription = registeredUserSubscription;
      isLoggedIn = true;
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.shell, (route) => false);
    } else {
      // Unrecognized number: continue into Complete Profile to finish signup.
      Navigator.of(context).pushReplacementNamed(Routes.completeProfile, arguments: request);
    }
  }

  void _triggerError(String message) {
    setState(() => _error = message);
    if (!MediaQuery.of(context).disableAnimations) _shake.forward(from: 0);
    _clearBoxes();
    _focusNodes[0].requestFocus();
  }

  void _resend() {
    if (_remainingRequests <= 0 || _cooldown > 0) return;
    setState(() {
      _remainingRequests--;
      _error = null;
      _clearBoxes();
    });
    _focusNodes[0].requestFocus();
    _startCooldown();
  }

  void _tryAgain() {
    setState(() {
      _error = null;
      _clearBoxes();
    });
    _focusNodes[0].requestFocus();
  }

  String _maskedNumber(AuthRequest request) {
    final digits = request.phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 3) return '${request.countryCode} ${request.phone}';
    final first = digits.substring(0, 1);
    final last = digits.substring(digits.length - 2);
    final dots = '•' * (digits.length - 3);
    return '${request.countryCode} $first$dots$last';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final request = ModalRoute.of(context)!.settings.arguments as AuthRequest;
    const stagger = Duration(milliseconds: 55);

    return Scaffold(
      appBar: const RihlaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RihlaSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInUp(
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(gradient: RihlaColors.seaGradient, shape: BoxShape.circle),
                    child: const Icon(Icons.lock_rounded, size: 34, color: RihlaColors.onBrand),
                  ),
                ),
              ),
              const SizedBox(height: RihlaSpace.xl),
              FadeInUp(delay: stagger, child: const AuthStepIndicator(step: 2)),
              const SizedBox(height: RihlaSpace.xl),
              FadeInUp(
                delay: stagger * 2,
                child: Column(
                  children: [
                    Text(
                      l10n.otpTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink),
                    ),
                    const SizedBox(height: RihlaSpace.sm),
                    Text(
                      l10n.otpSentTo(_maskedNumber(request)),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: RihlaColors.inkMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RihlaSpace.lg),
              // DEV-only: reveals the demo codes. Remove for production builds.
              FadeInUp(delay: stagger * 3, child: Center(child: _DevHintChip(text: l10n.otpHint))),
              const SizedBox(height: RihlaSpace.xl),
              FadeInUp(
                delay: stagger * 4,
                child: AutofillGroup(
                  child: AnimatedBuilder(
                    animation: _shake,
                    builder: (context, child) {
                      // Damped horizontal oscillation on error.
                      final dx = math.sin(_shake.value * math.pi * 4) * 9 * (1 - _shake.value);
                      return Transform.translate(offset: Offset(dx, 0), child: child);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (i) => _OtpBox(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            isError: _error != null,
                            isFirst: i == 0,
                            onChanged: (v) => _onChanged(i, v),
                          )),
                    ),
                  ),
                ),
              ),
              // Error line — fades in/out.
              AnimatedSize(
                duration: MediaQuery.of(context).disableAnimations ? Duration.zero : const Duration(milliseconds: 180),
                child: _error == null
                    ? const SizedBox(width: double.infinity)
                    : Padding(
                        padding: const EdgeInsets.only(top: RihlaSpace.md),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.warning_amber_rounded, size: 16, color: RihlaColors.coral),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(_error!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: RihlaColors.coral, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: RihlaSpace.sm),
                            TextButton.icon(
                              onPressed: _tryAgain,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: Text(l10n.tryAgain),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: RihlaSpace.xl),
              FadeInUp(delay: stagger * 5, child: _ResendBlock(
                    cooldown: _cooldown,
                    remaining: _remainingRequests,
                    onResend: _resend,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single OTP box with idle / active / filled / error states and a small
/// active scale-up.
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isError;
  final bool isFirst;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isError,
    required this.isFirst,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, _) {
        final focused = focusNode.hasFocus;
        final filled = controller.text.isNotEmpty;
        final active = focused;

        final Color border;
        final Color fill;
        if (isError) {
          border = RihlaColors.coral;
          fill = RihlaColors.statusCancelledTint;
        } else if (active) {
          border = RihlaColors.seaBlue;
          fill = RihlaColors.surface;
        } else if (filled) {
          border = RihlaColors.seaBlueDark;
          fill = RihlaColors.surface;
        } else {
          border = RihlaColors.hairline;
          fill = RihlaColors.surface;
        }

        final reduceMotion = MediaQuery.of(context).disableAnimations;
        return AnimatedScale(
          scale: active && !reduceMotion ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 160),
            width: 46,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(RihlaSpace.radius),
              border: Border.all(color: border, width: active || isError ? 1.6 : 1),
              boxShadow: active && !isError ? RihlaShadows.soft : null,
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: isFirst,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              autofillHints: isFirst ? const [AutofillHints.oneTimeCode] : null,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: RihlaColors.ink),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: '',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}

/// Resend control: a cooldown countdown that swaps to an active button, plus a
/// remaining-requests pill (or a "daily limit reached" pill at zero).
class _ResendBlock extends StatelessWidget {
  final int cooldown;
  final int remaining;
  final VoidCallback onResend;

  const _ResendBlock({required this.cooldown, required this.remaining, required this.onResend});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final limitReached = remaining <= 0;

    Widget top;
    if (limitReached) {
      top = const SizedBox.shrink();
    } else if (cooldown > 0) {
      final time = '0:${cooldown.toString().padLeft(2, '0')}';
      top = Text(
        l10n.resendIn(time),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: RihlaColors.inkFaint, fontWeight: FontWeight.w600),
      );
    } else {
      top = TextButton(onPressed: onResend, child: Text(l10n.resendCode));
    }

    return Column(
      children: [
        top,
        const SizedBox(height: RihlaSpace.sm),
        _Pill(
          label: limitReached ? l10n.otpDailyLimit : l10n.otpRequestsLeft(remaining),
          danger: limitReached,
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool danger;
  const _Pill({required this.label, this.danger = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: danger ? RihlaColors.statusCancelledTint : RihlaColors.seaTint,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: danger ? RihlaColors.statusCancelled : RihlaColors.seaBlueDark,
        ),
      ),
    );
  }
}

/// Dashed-border callout that flags demo-only guidance (the test OTP codes).
/// DEV affordance — should be removed for production builds.
class _DevHintChip extends StatelessWidget {
  final String text;
  const _DevHintChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(color: RihlaColors.inkFaint, radius: RihlaSpace.radius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.md, vertical: RihlaSpace.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: RihlaColors.inkFaint,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('DEV', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: RihlaColors.onBrand, letterSpacing: 0.5)),
            ),
            const SizedBox(width: RihlaSpace.sm),
            Flexible(
              child: Text(text, style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted, height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  const _DashedRRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final source = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dash = 5.0;
    const gap = 4.0;
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final len = math.min(dash, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
