import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';

/// S8 — Notifications (FR-012). Last-50 notification list.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final n = notifications[i];
            return Card(
              color: n.unread ? RihlaColors.seaBlue.withValues(alpha: 0.06) : null,
              child: ListTile(
                leading: Icon(n.icon, color: n.unread ? RihlaColors.seaBlue : Colors.grey),
                title: Text(n.title, style: TextStyle(fontWeight: n.unread ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text(n.body),
                trailing: Text(n.relativeTime, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                onTap: () => setState(() => n.unread = false),
              ),
            );
          },
        ),
      ),
    );
  }
}
