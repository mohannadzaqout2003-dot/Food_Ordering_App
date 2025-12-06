import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/notification_provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';

    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    final year = time.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'notifications_title')),
        centerTitle: true,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notif, _) {
              if (!notif.hasNotifications) return const SizedBox.shrink();
              return IconButton(
                tooltip: AppStrings.t(context, 'notifications_mark_all'),
                onPressed: () {
                  notif.markAllRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.t(context, 'notifications_all_marked'),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.done_all),
              );
            },
          ),
          Consumer<NotificationProvider>(
            builder: (context, notif, _) {
              if (!notif.hasNotifications) return const SizedBox.shrink();
              return IconButton(
                tooltip: AppStrings.t(context, 'notifications_clear_all'),
                onPressed: () {
                  notif.clearAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.t(context, 'notifications_all_cleared'),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.delete_sweep_outlined),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notif, _) {
          if (notif.notifications.isEmpty) {
            return Center(
              child: Text(
                AppStrings.t(context, 'notifications_empty'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: notif.notifications.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final n = notif.notifications[index];

              return Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: colorScheme.error,
                  ),
                ),
                onDismissed: (_) {
                  notif.deleteNotification(n.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.t(context, 'notifications_deleted'),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: InkWell(
                  onTap: () {
                    notif.markAsRead(n.id);
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: n.isRead
                          ? theme.cardColor
                          : colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          margin: EdgeInsets.only(top: 6.h),
                          decoration: BoxDecoration(
                            color: n.isRead
                                ? Colors.transparent
                                : colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: n.isRead
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                n.body,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                _formatTime(n.time),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11.sp,
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
