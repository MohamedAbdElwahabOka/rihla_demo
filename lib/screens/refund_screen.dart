import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets/rihla_app_bar.dart';
import '../widgets/fade_in.dart';

/// S10 — Refund Request (FR-086).
class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen> {
  final _formKey = GlobalKey<FormState>();
  final _explanationController = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    if (_reason == null || !_formKey.currentState!.validate()) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.refundReceived)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reasons = <String, String>{
      'notSatisfied': l10n.reasonNotSatisfied,
      'changedPlans': l10n.reasonChangedPlans,
      'financial': l10n.reasonFinancial,
      'technical': l10n.reasonTechnical,
      'other': l10n.reasonOther,
    };

    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.refundRequest)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(RihlaSpace.lg),
            children: [
              FadeInUp(
                child: TextFormField(
                  readOnly: true,
                  initialValue: '${currentUser.firstName} ${currentUser.lastName}',
                  decoration: InputDecoration(labelText: l10n.fullName),
                ),
              ),
              const SizedBox(height: RihlaSpace.lg),
              FadeInUp(
                delay: const Duration(milliseconds: 60),
                child: TextFormField(
                  readOnly: true,
                  initialValue: '${currentUser.countryCode} ${currentUser.phone}',
                  decoration: InputDecoration(labelText: l10n.primaryPhone),
                ),
              ),
              const SizedBox(height: RihlaSpace.lg),
              FadeInUp(
                delay: const Duration(milliseconds: 120),
                child: DropdownButtonFormField<String>(
                  initialValue: _reason,
                  decoration: InputDecoration(labelText: l10n.refundReasonLabel),
                  items: reasons.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                  onChanged: (v) => setState(() => _reason = v),
                  validator: (v) => v == null ? l10n.fieldRequired : null,
                ),
              ),
              const SizedBox(height: RihlaSpace.lg),
              FadeInUp(
                delay: const Duration(milliseconds: 180),
                child: TextFormField(
                  controller: _explanationController,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: l10n.explanation, alignLabelWithHint: true),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                ),
              ),
              const SizedBox(height: RihlaSpace.xl),
              FadeInUp(
                delay: const Duration(milliseconds: 240),
                child: FilledButton(
                  onPressed: () => _submit(l10n),
                  child: Text(l10n.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
