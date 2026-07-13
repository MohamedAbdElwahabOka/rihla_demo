import 'package:flutter/material.dart';
import '../booking_data.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';

/// S3b — Booking Step 2: Contact details (FR-044-046).
class BookingStep2Screen extends StatefulWidget {
  const BookingStep2Screen({super.key});

  @override
  State<BookingStep2Screen> createState() => _BookingStep2ScreenState();
}

class _BookingStep2ScreenState extends State<BookingStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _primaryPhone;
  late final TextEditingController _backupPhone;
  late final TextEditingController _hotel;
  late final TextEditingController _specialRequests;
  late final TextEditingController _email;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final data = ModalRoute.of(context)!.settings.arguments as BookingData;
      _fullName = TextEditingController(text: '${currentUser.firstName} ${currentUser.lastName}');
      _primaryPhone = TextEditingController(text: '${currentUser.countryCode} ${currentUser.phone}');
      _backupPhone = TextEditingController(text: data.backupPhone);
      _hotel = TextEditingController(text: data.hotelName);
      _specialRequests = TextEditingController(text: data.specialRequests);
      _email = TextEditingController(text: currentUser.email ?? '');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _primaryPhone.dispose();
    _backupPhone.dispose();
    _hotel.dispose();
    _specialRequests.dispose();
    _email.dispose();
    super.dispose();
  }

  void _continue(BookingData data) {
    if (!_formKey.currentState!.validate()) return;
    data
      ..fullName = _fullName.text
      ..primaryPhone = _primaryPhone.text
      ..backupPhone = _backupPhone.text
      ..hotelName = _hotel.text
      ..specialRequests = _specialRequests.text
      ..email = _email.text;
    Navigator.of(context).pushNamed(Routes.booking3, arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = ModalRoute.of(context)!.settings.arguments as BookingData;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.contactDetails)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _fullName,
                decoration: InputDecoration(labelText: l10n.fullName),
                validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _primaryPhone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l10n.primaryPhone),
                validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _backupPhone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l10n.backupPhone),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hotel,
                decoration: InputDecoration(labelText: l10n.hotel),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialRequests,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.specialRequests, alignLabelWithHint: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.email),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _continue(data),
                child: Text(l10n.continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
