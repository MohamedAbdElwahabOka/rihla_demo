import 'package:flutter/material.dart';
import '../auth_request.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

/// S9b — Complete Profile: reached from OTP verification when the phone
/// number isn't an existing account. Collects just the traveler's name and
/// finishes account creation (FR-004-007's registration path, now decided
/// after verification rather than by an upfront register/login choice).
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createAccount(AuthRequest request) async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    currentUser = UserProfile(
      firstName: _nameController.text.trim(),
      lastName: '',
      countryCode: request.countryCode,
      phone: request.phone,
      totalTrips: 0,
      reviewsWritten: 0,
    );
    userSubscription = null;
    isLoggedIn = true;
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.shell, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final request = ModalRoute.of(context)!.settings.arguments as AuthRequest;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.completeProfileTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RihlaSpace.xl),
          child: FadeInUp(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      child: const Icon(Icons.person_rounded,
                          size: 30, color: RihlaColors.onBrand),
                    ),
                  ),
                  const SizedBox(height: RihlaSpace.lg),
                  Text(
                    l10n.completeProfileBody,
                    style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: RihlaSpace.xl),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.fullName,
                      prefixIcon: const Icon(Icons.badge_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: RihlaSpace.xl),
                  FilledButton(
                    onPressed: _isSaving ? null : () => _createAccount(request),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: RihlaColors.onBrand,
                            ),
                          )
                        : Text(l10n.createAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
