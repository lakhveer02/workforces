import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/task_models.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(TaskStatus) onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.yuzey,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(
            color: task.isOverdue ? Colors.red.withValues(alpha: 0.3) : AppTheme.structuralLine,
            width: task.isOverdue ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with priority and project
            Row(
              children: [
                _buildPriorityBadge(),
                const Spacer(),
                if (task.isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radius24),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'OVERDUE',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spaceSmall),
            
            // Task title
            Text(
              task.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spaceSmall),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.soluk,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Project info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(AppTheme.radius24),
                border: Border.all(color: AppTheme.structuralLine),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryStart,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      task.projectName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.buz,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Labels
            if (task.labels.isNotEmpty) ...[
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: task.labels.take(3).map((label) {
                  final color = Color(int.parse(label.color.replaceAll('#', '0xFF')));
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radius24),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      label.name,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTheme.spaceMedium),
            ],
            
            // Bottom row with assignees and due date
            Row(
              children: [
                // Assignees
                if (task.assignees.isNotEmpty) ...[
                  _buildAssigneeAvatars(),
                  const SizedBox(width: AppTheme.spaceSmall),
                ],
                
                const Spacer(),
                
                // Due date
                if (task.dueDate != null) ...[
                  Icon(
                    Icons.schedule,
                    color: task.isOverdue ? Colors.red : AppTheme.soluk,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDueDate(task.dueDate!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: task.isOverdue ? Colors.red : AppTheme.soluk,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Status action buttons
            _buildStatusActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    IconData icon;
    
    switch (task.priority) {
      case TaskPriority.low:
        color = AppTheme.basari;
        icon = Icons.keyboard_arrow_down;
        break;
      case TaskPriority.medium:
        color = AppTheme.altin;
        icon = Icons.remove;
        break;
      case TaskPriority.high:
        color = AppTheme.primaryStart;
        icon = Icons.keyboard_arrow_up;
        break;
      case TaskPriority.urgent:
        color = Colors.red;
        icon = Icons.keyboard_double_arrow_up;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            task.priorityDisplayName,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssigneeAvatars() {
    const maxAvatars = 3;
    final visibleAssignees = task.assignees.take(maxAvatars).toList();
    final remainingCount = task.assignees.length - maxAvatars;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...visibleAssignees.map((assignee) {
          return Container(
            margin: const EdgeInsets.only(right: 2),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: AppTheme.panel,
              child: Text(
                assignee.name.split(' ').map((n) => n[0]).take(2).join(),
                style: const TextStyle(
                  color: AppTheme.buz,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(right: 2),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: AppTheme.primaryStart.withValues(alpha: 0.2),
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  color: AppTheme.primaryStart,
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusActions() {
    final availableStatuses = TaskStatus.values
        .where((status) => status != task.status && status != TaskStatus.cancelled)
        .toList();
    
    if (availableStatuses.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: availableStatuses.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () => onStatusChanged(status),
              borderRadius: BorderRadius.circular(AppTheme.radius24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius24),
                  border: Border.all(
                    color: _getStatusColor(status).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getStatusDisplayName(status),
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppTheme.soluk;
      case TaskStatus.inProgress:
        return AppTheme.primaryStart;
      case TaskStatus.review:
        return AppTheme.altin;
      case TaskStatus.done:
        return AppTheme.basari;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.review:
        return Icons.rate_review_outlined;
      case TaskStatus.done:
        return Icons.check_circle_outline;
      case TaskStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getStatusDisplayName(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'Start';
      case TaskStatus.review:
        return 'Review';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.cancelled:
        return 'Cancel';
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference < 0) {
      return '${(-difference)}d overdue';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference < 7) {
      return '${difference}d left';
    } else {
      return '${dueDate.day}/${dueDate.month}';
    }
  }
}