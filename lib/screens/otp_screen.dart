import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';

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
    final matchesRegistered = request.phone.replaceAll(RegExp(r'\s'), '') == registeredPhoneNumber.replaceAll(RegExp(r'\s'), '');
    if (matchesRegistered) {
      currentUser = registeredUserProfile;
      userSubscription = registeredUserSubscription;
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.shell, (route) => false);
    } else if (request.isRegister) {
      currentUser = UserProfile(
        firstName: request.fullName,
        lastName: '',
        countryCode: request.countryCode,
        phone: request.phone,
        totalTrips: 0,
        reviewsWritten: 0,
      );
      userSubscription = null;
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.shell, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.numberNotRegistered)));
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.otpTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.otpHint, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (i) => SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                      onChanged: (v) => _onDigitChanged(i, v),
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent), textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
              if (_remainingRequests > 0)
                Center(
                  child: TextButton(
                    onPressed: _resend,
                    child: Text(l10n.resendCode),
                  ),
                ),
              Text(
                _remainingRequests > 0 ? l10n.otpRemaining(_remainingRequests) : l10n.otpLimitReached,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: _remainingRequests > 0 ? Colors.grey : Colors.redAccent,
                  fontWeight: _remainingRequests > 0 ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
