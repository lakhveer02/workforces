import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../common/app_button.dart';

class AppEmptyState extends StatelessWidget {
  final IconData? icon;
  final String? illustration;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final EdgeInsets? padding;

  const AppEmptyState({
    super.key,
    this.icon,
    this.illustration,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.padding,
  });

  const AppEmptyState.noTasks({
    super.key,
    this.actionText = 'Create Task',
    this.onActionPressed,
    this.padding,
  })  : icon = Icons.task_alt_outlined,
        illustration = null,
        title = 'No Tasks Found',
        subtitle = 'Create your first task to get started with project management';

  const AppEmptyState.noEmployees({
    super.key,
    this.actionText = 'Add Employee',
    this.onActionPressed,
    this.padding,
  })  : icon = Icons.people_outline,
        illustration = null,
        title = 'No Employees Found',
        subtitle = 'Add employees to your organization to get started';

  const AppEmptyState.noLeaves({
    super.key,
    this.actionText = 'Apply for Leave',
    this.onActionPressed,
    this.padding,
  })  : icon = Icons.event_busy_outlined,
        illustration = null,
        title = 'No Leave Requests',
        subtitle = 'You haven\'t applied for any leaves yet';

  const AppEmptyState.noAttendance({
    super.key,
    this.actionText = 'Punch In',
    this.onActionPressed,
    this.padding,
  })  : icon = Icons.access_time_outlined,
        illustration = null,
        title = 'No Attendance Records',
        subtitle = 'Start tracking your attendance by punching in';

  const AppEmptyState.noPayslips({
    super.key,
    this.actionText = null,
    this.onActionPressed = null,
    this.padding,
  })  : icon = Icons.receipt_long_outlined,
        illustration = null,
        title = 'No Payslips Available',
        subtitle = 'Your payslips will appear here once they are generated';

  const AppEmptyState.noNotifications({
    super.key,
    this.actionText = null,
    this.onActionPressed = null,
    this.padding,
  })  : icon = Icons.notifications_none_outlined,
        illustration = null,
        title = 'No Notifications',
        subtitle = 'You\'re all caught up! No new notifications';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppTheme.spaceLarge * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon or Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accent, AppTheme.warning],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: icon != null
                ? Icon(
                    icon!,
                    size: 56,
                    color: Colors.white,
                  )
                : illustration != null
                    ? ClipOval(
                        child: Image.asset(
                          illustration!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.inbox_outlined,
                        size: 56,
                        color: Colors.white,
                      ),
          ),
          
          const SizedBox(height: AppTheme.spaceLarge * 1.5),
          
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.buz,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spaceMedium),
          
          // Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.soluk,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (actionText != null && onActionPressed != null) ...[
            const SizedBox(height: AppTheme.spaceLarge * 1.5),
            
            // Action Button
            AppButton.primary(
              onPressed: onActionPressed!,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}