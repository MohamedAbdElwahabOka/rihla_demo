import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

// Countries represented in Rihla's own traveler base (see mock_data.dart's
// seeded reviews) plus the three demo-persona codes; `+20` stays first as
// the default since the registered-user demo persona uses it.
const _countryCodeOrder = ['+20', '+49', '+7', '+44', '+33', '+39', '+34'];

/// S9 — Authentication (FR-004-007): a single phone-number entry point.
/// There is no separate register/login choice — after the OTP, Complete
/// Profile (`_verify` in otp_screen.dart) recognizes whether the number is
/// already an account and either signs the traveler in or continues into
/// account creation.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _countryCode = '+20';
  bool _isSending = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_isSending) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    // Simulated network latency, matching the delay shape already used for
    // the subscription-purchase flow (see plans_screen.dart's _purchase).
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final phone = _phoneController.text.trim();
    final request = AuthRequest(countryCode: _countryCode, phone: phone);
    // Capture messenger/navigator before the state change below, so the
    // confirmation still reaches the right Scaffold even mid-navigation.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSending = false);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.codeSentTo('$_countryCode $phone'))),
    );
    navigator.pushNamed(Routes.otp, arguments: request);
  }

  String _countryLabel(AppLocalizations l10n, String code) => switch (code) {
        '+20' => '+20 ${l10n.countryEgypt}',
        '+49' => '+49 ${l10n.countryGermany}',
        '+7' => '+7 ${l10n.countryRussia}',
        '+44' => '+44 ${l10n.countryUk}',
        '+33' => '+33 ${l10n.countryFrance}',
        '+39' => '+39 ${l10n.countryItaly}',
        '+34' => '+34 ${l10n.countrySpain}',
        _ => code,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.enterPhoneTitle)),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Brand strip — a compact echo of the gradient app bar above
              // it, not a second hero; keeps the wordmark present without
              // repeating Splash's full-bleed ceremony for a one-field form.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: RihlaSpace.xl, vertical: RihlaSpace.lg),
                decoration: const BoxDecoration(
                  gradient: RihlaColors.seaGradient,
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(RihlaSpace.radiusLg)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: RihlaColors.onBrand.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(RihlaSpace.radiusSm),
                        border: Border.all(
                            color: RihlaColors.onBrand.withValues(alpha: 0.28)),
                      ),
                      child: const Icon(Icons.sailing,
                          color: RihlaColors.onBrand, size: 22),
                    ),
                    const SizedBox(width: RihlaSpace.md),
                    Text(
                      'Rihla',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: RihlaColors.onBrand),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(RihlaSpace.xl),
                child: FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.enterPhoneBody,
                        style: const TextStyle(
                            color: RihlaColors.inkMuted, height: 1.5),
                      ),
                      const SizedBox(height: RihlaSpace.xl),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButtonFormField<String>(
                              initialValue: _countryCode,
                              isExpanded: true,
                              borderRadius:
                                  BorderRadius.circular(RihlaSpace.radius),
                              items: _countryCodeOrder
                                  .map((code) => DropdownMenuItem(
                                      value: code,
                                      child: Text(_countryLabel(l10n, code),
                                          overflow: TextOverflow.ellipsis)))
                                  .toList(),
                              onChanged: (v) => setState(
                                  () => _countryCode = v ?? _countryCode),
                            ),
                          ),
                          const SizedBox(width: RihlaSpace.md),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: l10n.phoneNumber,
                                prefixIcon: const Icon(Icons.phone_rounded),
                              ),
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                if (value.isEmpty) return l10n.fieldRequired;
                                if (value.length < 6 || value.length > 15) {
                                  return l10n.invalidPhoneNumber;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RihlaSpace.sm),
                      Text(
                        l10n.authPrivacyNote,
                        style: const TextStyle(
                            fontSize: 12, color: RihlaColors.inkMuted, height: 1.4),
                      ),
                      const SizedBox(height: RihlaSpace.lg),
                      FilledButton(
                        onPressed: _isSending ? null : _sendCode,
                        child: _isSending
                            ? Semantics(
                                label: l10n.sendingCode,
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: RihlaColors.onBrand,
                                  ),
                                ),
                              )
                            : Text(l10n.sendCode),
                      ),
                    ],
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
