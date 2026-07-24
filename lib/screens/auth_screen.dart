import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/fade_in.dart';

/// A country represented in Rihla's traveler base + the demo-persona codes.
class _Country {
  final String dialCode;
  final String flag;
  final String Function(AppLocalizations) name;
  const _Country(this.dialCode, this.flag, this.name);
}

// `+20` stays first as the default — the registered-user demo persona uses it.
const _countries = <_Country>[
  _Country('+20', '🇪🇬', _egypt),
  _Country('+49', '🇩🇪', _germany),
  _Country('+7', '🇷🇺', _russia),
  _Country('+44', '🇬🇧', _uk),
  _Country('+33', '🇫🇷', _france),
  _Country('+39', '🇮🇹', _italy),
  _Country('+34', '🇪🇸', _spain),
];

String _egypt(AppLocalizations l) => l.countryEgypt;
String _germany(AppLocalizations l) => l.countryGermany;
String _russia(AppLocalizations l) => l.countryRussia;
String _uk(AppLocalizations l) => l.countryUk;
String _france(AppLocalizations l) => l.countryFrance;
String _italy(AppLocalizations l) => l.countryItaly;
String _spain(AppLocalizations l) => l.countrySpain;

/// S9 — Authentication (FR-004-007): a single phone-number entry point.
/// There is no separate register/login choice — after the OTP, Complete
/// Profile recognizes whether the number is already an account and either
/// signs the traveler in or continues into account creation.
///
/// Redesigned to a calm single-focus onboarding: one gradient hero, a step
/// indicator, a headline/subline pairing, and a unified country-pill + phone
/// input group with inline validation. Behavior is unchanged.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  _Country _country = _countries.first;
  AuthButtonStatus _status = AuthButtonStatus.idle;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  /// 6–15 digit rule (FR-006), unchanged from the original.
  String? _validate(AppLocalizations l10n) {
    final value = _phoneController.text.trim();
    if (value.isEmpty) return l10n.fieldRequired;
    if (value.length < 6 || value.length > 15) return l10n.invalidPhoneNumber;
    return null;
  }

  Future<void> _sendCode() async {
    if (_status != AuthButtonStatus.idle) return;
    final l10n = AppLocalizations.of(context)!;
    final error = _validate(l10n);
    if (error != null) {
      setState(() => _phoneError = error);
      return;
    }

    setState(() {
      _phoneError = null;
      _status = AuthButtonStatus.loading;
    });
    // Simulated network latency, matching the subscription-purchase flow.
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final phone = _phoneController.text.trim();
    final request = AuthRequest(countryCode: _country.dialCode, phone: phone);

    // Brief checkmark beat before navigating.
    setState(() => _status = AuthButtonStatus.success);
    showAuthToast(context, l10n.codeSentTo('${_country.dialCode} $phone'));
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;

    Navigator.of(context).pushNamed(Routes.otp, arguments: request);
    // Reset so returning to this screen (back from OTP) shows a ready button.
    setState(() => _status = AuthButtonStatus.idle);
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<_Country>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CountrySheet(selected: _country),
    );
    if (selected != null) setState(() => _country = selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const stagger = Duration(milliseconds: 55);

    return Scaffold(
      appBar: authHeroAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(RihlaSpace.xl, RihlaSpace.xl, RihlaSpace.xl, RihlaSpace.xl),
          children: [
            FadeInUp(child: const AuthStepIndicator(step: 1)),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: stagger,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.phoneHeadline,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.6, color: RihlaColors.ink),
                  ),
                  const SizedBox(height: RihlaSpace.sm),
                  Text(l10n.phoneSubline, style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: stagger * 2,
              child: _PhoneInputGroup(
                country: _country,
                controller: _phoneController,
                focusNode: _phoneFocus,
                hasError: _phoneError != null,
                onCountryTap: _pickCountry,
                onChanged: () {
                  if (_phoneError != null) setState(() => _phoneError = null);
                },
              ),
            ),
            if (_phoneError != null) ...[
              const SizedBox(height: RihlaSpace.sm),
              Row(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 15, color: RihlaColors.coral),
                  const SizedBox(width: 6),
                  Text(_phoneError!, style: const TextStyle(fontSize: 12, color: RihlaColors.coral, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
            const SizedBox(height: RihlaSpace.md),
            FadeInUp(
              delay: stagger * 3,
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 15, color: RihlaColors.inkFaint),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(l10n.authPrivacyNote, style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: stagger * 4,
              child: PrimaryAuthButton(
                label: l10n.sendCode,
                status: _status,
                onPressed: _sendCode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Unified input group: a tappable country pill + a divider + the phone field,
/// sharing one rounded container whose border reflects focus / error state.
class _PhoneInputGroup extends StatelessWidget {
  final _Country country;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final VoidCallback onCountryTap;
  final VoidCallback onChanged;

  const _PhoneInputGroup({
    required this.country,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onCountryTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final focused = focusNode.hasFocus;
    final borderColor = hasError
        ? RihlaColors.coral
        : focused
            ? RihlaColors.seaBlue
            : RihlaColors.hairline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
        border: Border.all(color: borderColor, width: focused || hasError ? 1.6 : 1),
        boxShadow: focused ? RihlaShadows.soft : null,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onCountryTap,
            borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg, vertical: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(country.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(country.dialCode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: RihlaColors.ink)),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: RihlaColors.inkMuted),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 28, color: RihlaColors.hairline),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => onChanged(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: RihlaColors.ink, letterSpacing: 0.3),
              decoration: InputDecoration(
                isCollapsed: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg, vertical: 18),
                hintText: l10n.phoneNumber,
                hintStyle: const TextStyle(color: RihlaColors.inkFaint, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Searchable country picker sheet: flag + name + dial code per row.
class _CountrySheet extends StatefulWidget {
  final _Country selected;
  const _CountrySheet({required this.selected});

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final q = _query.trim().toLowerCase();
    final filtered = _countries.where((c) {
      if (q.isEmpty) return true;
      return c.name(l10n).toLowerCase().contains(q) || c.dialCode.contains(q);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: RihlaSpace.xl,
          right: RihlaSpace.xl,
          top: 4,
          bottom: MediaQuery.of(context).viewInsets.bottom + RihlaSpace.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.selectCountry,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
            const SizedBox(height: RihlaSpace.lg),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l10n.searchCountryHint,
              ),
            ),
            const SizedBox(height: RihlaSpace.sm),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final c = filtered[i];
                  final selected = c.dialCode == widget.selected.dialCode;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                    title: Text(c.name(l10n), style: const TextStyle(fontWeight: FontWeight.w600, color: RihlaColors.ink)),
                    trailing: Text(
                      c.dialCode,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected ? RihlaColors.seaBlue : RihlaColors.inkMuted,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
