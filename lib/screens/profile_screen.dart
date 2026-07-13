import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';

/// S6 — Profile (FR-065-072). Hosted as the Profile tab body.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickLanguage(BuildContext context) async {
    final locale = await showModalBottomSheet<Locale>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('English'), onTap: () => Navigator.of(context).pop(const Locale('en'))),
            ListTile(title: const Text('Deutsch'), onTap: () => Navigator.of(context).pop(const Locale('de'))),
            ListTile(title: const Text('Русский'), onTap: () => Navigator.of(context).pop(const Locale('ru'))),
          ],
        ),
      ),
    );
    if (locale != null && context.mounted) RihlaApp.of(context).setLocale(locale);
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.signOut)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.splash, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daysLeft = userSubscription.expiryDate.difference(DateTime.now()).inDays;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [RihlaColors.seaBlue, RihlaColors.gold]),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 12),
                Text('${currentUser.firstName} ${currentUser.lastName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (userSubscription.active) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: RihlaColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(l10n.subscriberBadge, style: const TextStyle(fontSize: 11, color: RihlaColors.seaBlueDark)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _StatTile(value: '${currentUser.totalTrips}', label: l10n.totalTrips),
              _StatTile(value: '${currentUser.reviewsWritten}', label: l10n.reviewsWritten),
              _StatTile(value: l10n.daysLeft(daysLeft), label: l10n.activeSubscription),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.settings, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickLanguage(context),
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number_outlined),
            title: Text(l10n.myBookings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.myBookings),
          ),
          ListTile(
            leading: const Icon(Icons.card_membership_outlined),
            title: Text(l10n.mySubscription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.subscription),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(l10n.subscriptionPlans),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.plans),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card_outlined),
            title: Text(l10n.paymentMethods),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.payments),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.notifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(Routes.notifications),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(l10n.signOut, style: const TextStyle(color: Colors.redAccent)),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: RihlaColors.seaBlueDark)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
