import 'package:flutter/material.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

const _countryCodeOrder = ['+20', '+49', '+7'];

/// S9 — Authentication: Registration + Login (FR-004-007).
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isRegister = true;
  String _countryCode = '+20';
  bool _argsRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsRead) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is bool) _isRegister = arg;
      _argsRead = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushNamed(
      Routes.otp,
      arguments: AuthRequest(
        isRegister: _isRegister,
        countryCode: _countryCode,
        phone: _phoneController.text.trim(),
        fullName: _nameController.text.trim(),
      ),
    );
  }

  String _countryLabel(AppLocalizations l10n, String code) => switch (code) {
        '+20' => '+20 ${l10n.countryEgypt}',
        '+49' => '+49 ${l10n.countryGermany}',
        '+7' => '+7 ${l10n.countryRussia}',
        _ => code,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(_isRegister ? l10n.register : l10n.login)),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Brand hero — flows out of the gradient app bar into a floating
              // sea-gradient panel with the sailing mark and wordmark.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                    RihlaSpace.xl, RihlaSpace.xl, RihlaSpace.xl, RihlaSpace.xxl),
                decoration: const BoxDecoration(
                  gradient: RihlaColors.seaGradient,
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(RihlaSpace.radiusLg)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(RihlaSpace.radius),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28)),
                      ),
                      child: const Icon(Icons.sailing, color: Colors.white, size: 34),
                    ),
                    const SizedBox(height: RihlaSpace.md),
                    const Text(
                      'Rihla',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
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
                      SegmentedButton<bool>(
                        style: SegmentedButton.styleFrom(
                          backgroundColor: RihlaColors.surface,
                          foregroundColor: RihlaColors.inkMuted,
                          selectedBackgroundColor: RihlaColors.seaBlue,
                          selectedForegroundColor: Colors.white,
                          side: const BorderSide(color: RihlaColors.hairline),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(RihlaSpace.radius)),
                        ),
                        segments: [
                          ButtonSegment(value: true, label: Text(l10n.register)),
                          ButtonSegment(value: false, label: Text(l10n.login)),
                        ],
                        selected: {_isRegister},
                        onSelectionChanged: (s) =>
                            setState(() => _isRegister = s.first),
                      ),
                      const SizedBox(height: RihlaSpace.xl),
                      if (_isRegister) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: l10n.fullName,
                            prefixIcon: const Icon(Icons.person_rounded),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.fieldRequired
                              : null,
                        ),
                        const SizedBox(height: RihlaSpace.lg),
                      ],
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
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16)),
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
                              decoration: InputDecoration(
                                labelText: l10n.phoneNumber,
                                prefixIcon: const Icon(Icons.phone_rounded),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l10n.fieldRequired
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RihlaSpace.xl),
                      FilledButton(
                        onPressed: _sendCode,
                        child: Text(l10n.sendCode),
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
