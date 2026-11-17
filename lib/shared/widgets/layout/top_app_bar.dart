import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_bloc.dart';
import '../../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../../shared/models/user.dart';
import '../../../main.dart';

/// Top app bar with user profile, notifications, and theme controls
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({
    required this.user,
    this.onMenuPressed,
    this.showMenuButton = false,
    super.key,
  });

  final User user;
  final VoidCallback? onMenuPressed;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: showMenuButton && onMenuPressed != null
          ? IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
            )
          : null,
      title: isMobile 
          ? const Text('WorkforceOS')
          : Row(
              children: [
                if (showMenuButton && onMenuPressed != null) ...[
                  IconButton(
                    onPressed: onMenuPressed,
                    icon: const Icon(Icons.menu),
                    tooltip: 'Toggle Sidebar',
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  'WorkforceOS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
      actions: [
        // Search button (mobile)
        if (isMobile) ...[
          IconButton(
            onPressed: () {
              // TODO: Implement search
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],

        // Notifications
        Badge(
          label: const Text('3'),
          backgroundColor: theme.colorScheme.error,
          textColor: theme.colorScheme.onError,
          child: IconButton(
            onPressed: () {
              _showNotificationsBottomSheet(context);
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
          ),
        ),

        // Theme toggle
        if (!isMobile) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              _showThemeMenu(context);
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            tooltip: 'Theme',
          ),
        ],

        // User profile menu
        const SizedBox(width: 8),
        _UserProfileButton(user: user),
        
        const SizedBox(width: 16),
      ],
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => _NotificationsList(
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showThemeMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 20, 100),
      items: [
        const PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(Icons.brightness_auto),
              SizedBox(width: 12),
              Text('System'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(Icons.light_mode),
              SizedBox(width: 12),
              Text('Light'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(Icons.dark_mode),
              SizedBox(width: 12),
              Text('Dark'),
            ],
          ),
        ),
      ],
    ).then((themeMode) {
      if (themeMode != null && context.mounted) {
        context.read<ThemeBloc>().add(ThemeChanged(themeMode));
      }
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// User profile button with dropdown menu
class _UserProfileButton extends StatelessWidget {
  const _UserProfileButton({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!Responsive.isMobile(context)) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    user.role.displayName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: const Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 12),
              Text('My Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: const Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'help',
          child: const Row(
            children: [
              Icon(Icons.help_outline),
              SizedBox(width: 12),
              Text('Help & Support'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Sign Out',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'profile':
            // TODO: Navigate to profile
            break;
          case 'settings':
            // TODO: Navigate to settings
            break;
          case 'help':
            // TODO: Show help
            break;
          case 'logout':
            context.read<AuthBloc>().add(AuthLogoutRequested());
            break;
        }
      },
    );
  }
}

/// Mock notifications list
class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Mark all as read
                },
                child: const Text('Mark all read'),
              ),
            ],
          ),
        ),

        // Notifications list
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 8,
            itemBuilder: (context, index) {
              return _NotificationItem(
                title: _mockNotifications[index % _mockNotifications.length]['title']!,
                message: _mockNotifications[index % _mockNotifications.length]['message']!,
                time: '${index + 1}h ago',
                isUnread: index < 3,
              );
            },
          ),
        ),
      ],
    );
  }

  static const List<Map<String, String>> _mockNotifications = [
    {
      'title': 'New Leave Request',
      'message': 'Sarah Wilson has submitted a leave request for approval.',
    },
    {
      'title': 'Task Assigned',
      'message': 'You have been assigned a new task: Update employee records.',
    },
    {
      'title': 'Payroll Processed',
      'message': 'Monthly payroll for March has been processed successfully.',
    },
    {
      'title': 'Team Meeting',
      'message': 'Reminder: Team standup meeting in 30 minutes.',
    },
    {
      'title': 'System Update',
      'message': 'WorkforceOS will be updated tonight at 2:00 AM.',
    },
  ];
}

/// Individual notification item
class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = false,
  });

  final String title;
  final String message;
  final String time;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnread
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.notifications,
              color: isUnread
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}