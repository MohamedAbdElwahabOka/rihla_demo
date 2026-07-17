import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

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
            const SizedBox(height: RihlaSpace.md),
            TextField(controller: expiryController, decoration: InputDecoration(labelText: l10n.expiry)),
            const SizedBox(height: RihlaSpace.md),
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

  Color _brandColor(String brand) {
    switch (brand) {
      case 'Mastercard':
        return RihlaColors.coral;
      case 'Visa':
        return RihlaColors.seaBlue;
      default:
        return RihlaColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.paymentMethods)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            ...paymentMethods.toList().asMap().entries.map((indexed) {
              final pm = indexed.value;
              final brandColor = _brandColor(pm.brand);
              return FadeInUp(
                delay: Duration(milliseconds: indexed.key * 70),
                child: Container(
                  margin: const EdgeInsets.only(bottom: RihlaSpace.md),
                  padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.md, vertical: RihlaSpace.sm),
                  decoration: BoxDecoration(
                    color: RihlaColors.surface,
                    borderRadius: BorderRadius.circular(RihlaSpace.radius),
                    border: Border.all(color: RihlaColors.hairline),
                    boxShadow: RihlaShadows.soft,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: brandColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(Icons.credit_card_rounded, size: 20, color: brandColor),
                      ),
                      const SizedBox(width: RihlaSpace.md),
                      Expanded(
                        child: Text(
                          l10n.cardEndingIn(pm.brand, pm.last4),
                          style: const TextStyle(fontWeight: FontWeight.w600, color: RihlaColors.ink),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: RihlaColors.coral),
                        onPressed: () => setState(() => paymentMethods.remove(pm)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: RihlaSpace.sm),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _addCard,
                borderRadius: BorderRadius.circular(RihlaSpace.radius),
                child: Container(
                  padding: const EdgeInsets.all(RihlaSpace.lg),
                  decoration: BoxDecoration(
                    color: RihlaColors.surface,
                    borderRadius: BorderRadius.circular(RihlaSpace.radius),
                    border: Border.all(color: RihlaColors.hairline, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: RihlaColors.seaTint,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.add_rounded, size: 20, color: RihlaColors.seaBlue),
                      ),
                      const SizedBox(width: RihlaSpace.md),
                      Text(
                        l10n.addCard,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: RihlaColors.seaBlueDark),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
