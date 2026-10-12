import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/task_models.dart';
import 'task_card.dart';

class TaskStatusColumn extends StatelessWidget {
  final TaskStatus status;
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final Function(Task, TaskStatus) onTaskStatusChanged;

  const TaskStatusColumn({
    super.key,
    required this.status,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          _buildHeader(context),
          
          // Task list
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radius12),
          topRight: Radius.circular(AppTheme.radius12),
        ),
        border: const Border(
          bottom: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getStatusDisplayName(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius24),
              border: Border.all(
                color: _getStatusColor().withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${tasks.length}',
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getEmptyStateIcon(),
                size: 48,
                color: AppTheme.soluk.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'No ${_getStatusDisplayName().toLowerCase()} tasks',
                style: TextStyle(
                  color: AppTheme.soluk.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: AppTheme.spaceMedium,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: () => onTaskTap(task),
          onStatusChanged: (newStatus) => onTaskStatusChanged(task, newStatus),
        );
      },
    );
  }

  Color _getStatusColor() {
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

  String _getStatusDisplayName() {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.review:
        return 'Review';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData _getEmptyStateIcon() {
    switch (status) {
      case TaskStatus.todo:
        return Icons.assignment_outlined;
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
}