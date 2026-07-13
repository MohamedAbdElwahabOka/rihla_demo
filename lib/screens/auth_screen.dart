import 'package:flutter/material.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';

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
      appBar: AppBar(title: Text(_isRegister ? l10n.register : l10n.login)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: true, label: Text(l10n.register)),
                  ButtonSegment(value: false, label: Text(l10n.login)),
                ],
                selected: {_isRegister},
                onSelectionChanged: (s) => setState(() => _isRegister = s.first),
              ),
              const SizedBox(height: 24),
              if (_isRegister) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.fullName),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                ),
                const SizedBox(height: 16),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: DropdownButtonFormField<String>(
                      initialValue: _countryCode,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
                      items: _countryCodeOrder.map((code) => DropdownMenuItem(value: code, child: Text(_countryLabel(l10n, code), overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) => setState(() => _countryCode = v ?? _countryCode),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: l10n.phoneNumber),
                      validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _sendCode,
                child: Text(l10n.sendCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
