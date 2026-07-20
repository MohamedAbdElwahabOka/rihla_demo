import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_badge.dart';

/// S6 — Profile (FR-065-072). Hosted as the Profile tab body.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickLanguage(BuildContext context) async {
    final locale = await showModalBottomSheet<Locale>(
      context: context,
      // Each language name is an endonym (shown in itself, not translated —
      // "Deutsch" must never become "German" just because the UI is in
      // English), so these are intentionally not ARB keys.
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(title: const Text('English'), onTap: () => Navigator.of(context).pop(const Locale('en'))),
            ListTile(title: const Text('Deutsch'), onTap: () => Navigator.of(context).pop(const Locale('de'))),
            ListTile(title: const Text('Русский'), onTap: () => Navigator.of(context).pop(const Locale('ru'))),
            const SizedBox(height: 8),
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
      signOutToGuest();
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.splash, (route) => false);
    }
  }

  Widget _avatar(IconData icon) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RihlaColors.seaGradient,
        boxShadow: [
          BoxShadow(color: RihlaColors.seaBlue.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 46),
    );
  }

  Widget _buildGuestView(BuildContext context, AppLocalizations l10n) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          FadeInUp(
            child: Center(
              child: Column(
                children: [
                  _avatar(Icons.person_outline),
                  const SizedBox(height: 18),
                  Text(l10n.guestModeTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                  const SizedBox(height: 8),
                  Text(l10n.guestModeBody, textAlign: TextAlign.center, style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pushNamed(Routes.auth),
                      child: Text(l10n.signIn),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          _SettingsGroup(
            title: l10n.settings,
            children: [
              _SettingsTile(icon: Icons.language_rounded, color: RihlaColors.seaBlue, title: l10n.language, onTap: () => _pickLanguage(context)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isGuest) return _buildGuestView(context, l10n);
    final sub = userSubscription;
    final daysLeft = sub?.expiryDate.difference(DateTime.now()).inDays;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FadeInUp(
            child: Center(
              child: Column(
                children: [
                  _avatar(Icons.person),
                  const SizedBox(height: 14),
                  Text('${currentUser.firstName} ${currentUser.lastName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                  if (sub != null && sub.active) ...[
                    const SizedBox(height: 8),
                    RihlaBadge(
                      label: l10n.subscriberBadge,
                      icon: Icons.workspace_premium_rounded,
                      gradient: RihlaColors.sunsetGradient,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 80),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.card,
              ),
              child: Row(
                children: [
                  _StatTile(value: '${currentUser.totalTrips}', label: l10n.totalTrips),
                  const _StatDivider(),
                  _StatTile(value: '${currentUser.reviewsWritten}', label: l10n.reviewsWritten),
                  const _StatDivider(),
                  _StatTile(value: daysLeft != null ? l10n.daysLeft(daysLeft) : l10n.noActivePlan, label: l10n.activeSubscription),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 140),
            child: _SettingsGroup(
              title: l10n.settings,
              children: [
                _SettingsTile(icon: Icons.language_rounded, color: RihlaColors.seaBlue, title: l10n.language, onTap: () => _pickLanguage(context)),
                _SettingsTile(icon: Icons.confirmation_number_rounded, color: RihlaColors.lagoon, title: l10n.myBookings, onTap: () => Navigator.of(context).pushNamed(Routes.myBookings)),
                _SettingsTile(icon: Icons.card_membership_rounded, color: RihlaColors.gold, title: l10n.mySubscription, onTap: () => Navigator.of(context).pushNamed(Routes.subscription)),
                _SettingsTile(icon: Icons.workspace_premium_rounded, color: RihlaColors.coral, title: l10n.subscriptionPlans, onTap: () => Navigator.of(context).pushNamed(Routes.plans)),
                _SettingsTile(icon: Icons.credit_card_rounded, color: RihlaColors.seaBlueDark, title: l10n.paymentMethods, onTap: () => Navigator.of(context).pushNamed(Routes.payments)),
                _SettingsTile(icon: Icons.notifications_rounded, color: RihlaColors.seaBlue, title: l10n.notifications, onTap: () => Navigator.of(context).pushNamed(Routes.notifications)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _SettingsGroup(
              children: [
                _SettingsTile(icon: Icons.logout_rounded, color: RihlaColors.coral, title: l10n.signOut, danger: true, onTap: () => _confirmSignOut(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SettingsGroup({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(title!.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: RihlaColors.inkFaint)),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: RihlaColors.surface,
            borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
            boxShadow: RihlaShadows.soft,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;
  final bool danger;
  const _SettingsTile({required this.icon, required this.color, required this.title, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: danger ? RihlaColors.coral : RihlaColors.ink,
                ),
              ),
            ),
            if (!danger) const Icon(Icons.chevron_right_rounded, color: RihlaColors.inkFaint),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 34, color: RihlaColors.hairline);
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
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.seaBlueDark)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: RihlaColors.inkMuted, height: 1.3)),
          ),
        ],
      ),
    );
  }
}
