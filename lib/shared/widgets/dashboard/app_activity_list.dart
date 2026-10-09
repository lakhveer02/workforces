import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';

/// A reusable activity list component for displaying timelines, notifications, and recent activities
class AppActivityList extends StatelessWidget {
  const AppActivityList({
    required this.activities,
    this.title,
    this.showViewAll = false,
    this.onViewAllTap,
    this.maxItems,
    this.emptyMessage = 'No activities to show',
    super.key,
  });

  final List<ActivityItem> activities;
  final String? title;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;
  final int? maxItems;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayActivities = maxItems != null 
        ? activities.take(maxItems!).toList() 
        : activities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showViewAll && onViewAllTap != null)
                  TextButton(
                    onPressed: onViewAllTap,
                    child: const Text('View All'),
                  ),
              ],
            ),
          ),

        // Activity list
        if (displayActivities.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayActivities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final activity = displayActivities[index];
              return _ActivityItemWidget(
                activity: activity,
                isLast: index == displayActivities.length - 1,
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Individual activity item widget
class _ActivityItemWidget extends StatelessWidget {
  const _ActivityItemWidget({
    required this.activity,
    this.isLast = false,
  });

  final ActivityItem activity;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return InkWell(
      onTap: activity.onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with timeline
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: activity.color?.withValues(alpha: 0.1) ?? 
                           theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: activity.color ?? theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    activity.icon,
                    size: isMobile ? 18 : 20,
                    color: activity.color ?? theme.colorScheme.primary,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        activity.timeAgo,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Description
                  if (activity.description != null)
                    Text(
                      activity.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  
                  // Metadata chips
                  if (activity.metadata.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: activity.metadata.map((meta) => Chip(
                        label: Text(
                          meta,
                          style: theme.textTheme.labelSmall,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for activity items
class ActivityItem {
  const ActivityItem({
    required this.title,
    required this.timeAgo,
    required this.icon,
    this.description,
    this.color,
    this.metadata = const [],
    this.onTap,
  });

  final String title;
  final String timeAgo;
  final String? description;
  final IconData icon;
  final Color? color;
  final List<String> metadata;
  final VoidCallback? onTap;
}

/// Specialized activity list for notifications
class AppNotificationList extends StatelessWidget {
  const AppNotificationList({
    required this.notifications,
    this.title,
    this.showViewAll = false,
    this.onViewAllTap,
    this.maxItems,
    super.key,
  });

  final List<NotificationItem> notifications;
  final String? title;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayNotifications = maxItems != null 
        ? notifications.take(maxItems!).toList() 
        : notifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showViewAll && onViewAllTap != null)
                  TextButton(
                    onPressed: onViewAllTap,
                    child: const Text('View All'),
                  ),
              ],
            ),
          ),

        // Notification list
        if (displayNotifications.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayNotifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = displayNotifications[index];
              return _NotificationItemWidget(notification: notification);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Individual notification item widget
class _NotificationItemWidget extends StatelessWidget {
  const _NotificationItemWidget({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: notification.isRead 
            ? theme.colorScheme.outline.withValues(alpha: 0.2)
            : theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Icon(
          notification.icon,
          size: 20,
          color: notification.isRead 
              ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
              : theme.colorScheme.primary,
        ),
      ),
      title: Text(
        notification.title,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      subtitle: notification.description != null
          ? Text(
              notification.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            notification.timeAgo,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (!notification.isRead) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ],
      ),
      onTap: notification.onTap,
    );
  }
}

/// Data model for notification items
class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.timeAgo,
    required this.icon,
    required this.isRead,
    this.description,
    this.onTap,
  });

  final String title;
  final String timeAgo;
  final String? description;
  final IconData icon;
  final bool isRead;
  final VoidCallback? onTap;
}