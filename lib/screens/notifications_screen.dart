import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

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
      appBar: RihlaAppBar(title: Text(l10n.notifications)),
      body: SafeArea(
        child: notifications.isEmpty
            ? _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.all(RihlaSpace.lg),
                itemCount: notifications.length,
                separatorBuilder: (_, _) => const SizedBox(height: RihlaSpace.sm),
                itemBuilder: (context, i) {
                  final n = notifications[i];
                  return FadeInUp(
                    delay: Duration(milliseconds: i * 50),
                    child: _NotificationRow(
                      notification: n,
                      onTap: () => setState(() => n.unread = false),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationRow({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = notification.unread;
    return Material(
      color: unread ? RihlaColors.seaTint : RihlaColors.surface,
      borderRadius: BorderRadius.circular(RihlaSpace.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RihlaSpace.radius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RihlaSpace.radius),
            border: Border.all(color: RihlaColors.hairline),
          ),
          padding: const EdgeInsets.all(RihlaSpace.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: RihlaColors.seaBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(notification.icon, color: RihlaColors.seaBlue, size: 20),
              ),
              const SizedBox(width: RihlaSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                              color: RihlaColors.ink,
                            ),
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: RihlaSpace.sm, top: 4),
                            decoration: const BoxDecoration(
                              color: RihlaColors.coral,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.body,
                      style: const TextStyle(color: RihlaColors.inkMuted, height: 1.4),
                    ),
                    const SizedBox(height: RihlaSpace.sm),
                    Text(
                      notification.relativeTime,
                      style: const TextStyle(fontSize: 11, color: RihlaColors.inkFaint),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: RihlaColors.seaTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded, size: 42, color: RihlaColors.seaBlue),
          ),
          const SizedBox(height: RihlaSpace.lg),
          Text(
            l10n.notifications,
            style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
