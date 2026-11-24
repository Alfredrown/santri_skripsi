import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../application/notification_notifier.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);
    final hasUnread = notifications.any((n) => !n.isRead);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: SecondaryPageHeader(title: 'Notifikasi'),
                  ),
                  if (hasUnread)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: A11yConstants.minTouchTargetSize,
                      ),
                      child: TextButton(
                        onPressed: () {
                          notifier.markAllAsRead();
                          A11yAnnouncer.announce(
                            context,
                            'Semua notifikasi ditandai sudah dibaca.',
                          );
                        },
                        child: const Text(
                          'Tandai Dibaca',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(16),
              if (notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Belum ada notifikasi saat ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                )
              else
                ...notifications.map((notif) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NotificationTile(
                      notification: notif,
                      onTap: () {
                        notifier.markAsRead(notif.id);
                        if (notif.routeTarget != null) {
                          context.push(notif.routeTarget!);
                        }
                      },
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.queue:
        return Icons.confirmation_number_outlined;
      case NotificationType.reminder:
        return Icons.alarm_rounded;
      case NotificationType.pharmacy:
        return Icons.medication_outlined;
      case NotificationType.info:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;

    return Semantics(
      button: true,
      label:
          '${unread ? 'Belum dibaca. ' : ''}${notification.title}. ${notification.body}. ${notification.timeAgo}',
      excludeSemantics: true,
      child: Material(
        color: unread
            ? AppColors.primaryContainer.withValues(alpha: 0.65)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: unread
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : AppColors.outline,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: unread
                        ? AppColors.primary
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _icon,
                    size: 20,
                    color: unread ? AppColors.onPrimary : AppColors.primaryNavy,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (unread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const Gap(4),
                      Text(
                        notification.body,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.bodyMuted,
                          height: 1.45,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
