import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';

/// S6d — Saved Payment Methods (FR-070).
class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  Future<void> _addCard() async {
    final l10n = AppLocalizations.of(context)!;
    final numberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addCard),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: numberController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.cardNumber)),
            TextField(controller: expiryController, decoration: InputDecoration(labelText: l10n.expiry)),
            TextField(controller: cvvController, keyboardType: TextInputType.number, obscureText: true, decoration: InputDecoration(labelText: l10n.cvv)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.add)),
        ],
      ),
    );

    if (added == true) {
      final last4 = numberController.text.length >= 4
          ? numberController.text.substring(numberController.text.length - 4)
          : numberController.text.padLeft(4, '0');
      setState(() {
        paymentMethods.add(PaymentMethod(id: 'pm${paymentMethods.length + 1}', brand: 'Visa', last4: last4));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentMethods)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...paymentMethods.map((pm) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.credit_card, color: RihlaColors.seaBlue),
                    title: Text(l10n.cardEndingIn(pm.brand, pm.last4)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => setState(() => paymentMethods.remove(pm)),
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _addCard,
              icon: const Icon(Icons.add),
              label: Text(l10n.addCard),
            ),
          ],
        ),
      ),
    );
  }
}
