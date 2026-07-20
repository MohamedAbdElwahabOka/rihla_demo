import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

/// S9 — OTP entry (FR-005/007b). Any 6-digit code is accepted as valid
/// except [demoExpiredOtp], which demonstrates the expired-code error path.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _remainingRequests = 4;
  String? _error;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    setState(() => _error = null);
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verify();
    }
  }

  void _verify() {
    final code = _controllers.map((c) => c.text).join();
    final l10n = AppLocalizations.of(context)!;
    final request = ModalRoute.of(context)!.settings.arguments as AuthRequest;

    if (code == demoExpiredOtp) {
      setState(() => _error = l10n.otpExpired);
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
      return;
    }

    // Compare digits only -- users type phone numbers without the exact
    // spacing the demo constant happens to use (e.g. via a numeric keypad
    // with no convenient space key).
    final matchesRegistered = request.countryCode == registeredPhoneCountryCode &&
        request.phone.replaceAll(RegExp(r'\s'), '') == registeredPhoneNumber.replaceAll(RegExp(r'\s'), '');
    if (matchesRegistered) {
      currentUser = registeredUserProfile;
      userSubscription = registeredUserSubscription;
      isLoggedIn = true;
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.shell, (route) => false);
    } else {
      // Unrecognized number: there's no separate "register" flow anymore —
      // any number that isn't already an account continues into Complete
      // Profile, which collects the name and finishes account creation.
      Navigator.of(context).pushReplacementNamed(
        Routes.completeProfile,
        arguments: request,
      );
    }
  }

  void _resend() {
    if (_remainingRequests <= 0) return;
    setState(() {
      _remainingRequests--;
      _error = null;
      for (final c in _controllers) {
        c.clear();
      }
    });
    _focusNodes[0].requestFocus();
  }

  Widget _otpBox(int i) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controllers[i], _focusNodes[i]]),
      builder: (context, _) {
        final active =
            _controllers[i].text.isNotEmpty || _focusNodes[i].hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 46,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: RihlaColors.surface,
            borderRadius: BorderRadius.circular(RihlaSpace.radius),
            border: Border.all(
              color: active ? RihlaColors.seaBlue : RihlaColors.hairline,
              width: active ? 1.6 : 1,
            ),
            boxShadow: active ? RihlaShadows.soft : null,
          ),
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: RihlaColors.ink),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              counterText: '',
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (v) => _onDigitChanged(i, v),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.otpTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RihlaSpace.xl),
          child: FadeInUp(
            child: Column(
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
                    child: const Icon(Icons.lock_rounded,
                        size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: RihlaSpace.lg),
                Text(
                  l10n.otpHint,
                  style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: RihlaSpace.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, _otpBox),
                ),
                if (_error != null) ...[
                  const SizedBox(height: RihlaSpace.md),
                  Text(
                    _error!,
                    style: const TextStyle(
                        color: RihlaColors.coral, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: RihlaSpace.xl),
                if (_remainingRequests > 0)
                  Center(
                    child: TextButton(
                      onPressed: _resend,
                      child: Text(l10n.resendCode),
                    ),
                  ),
                Text(
                  _remainingRequests > 0
                      ? l10n.otpRemaining(_remainingRequests)
                      : l10n.otpLimitReached,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: _remainingRequests > 0
                        ? RihlaColors.inkMuted
                        : RihlaColors.coral,
                    fontWeight: _remainingRequests > 0
                        ? FontWeight.normal
                        : FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
