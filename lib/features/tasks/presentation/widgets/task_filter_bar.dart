import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/task_models.dart';

class TaskFilterBar extends StatelessWidget {
  final String? selectedProjectId;
  final TaskPriority? selectedPriority;
  final Function(String?) onProjectChanged;
  final Function(TaskPriority?) onPriorityChanged;
  final VoidCallback onClearFilters;

  const TaskFilterBar({
    super.key,
    required this.selectedProjectId,
    required this.selectedPriority,
    required this.onProjectChanged,
    required this.onPriorityChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilters = selectedProjectId != null || selectedPriority != null;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: const BoxDecoration(
        color: AppTheme.yuzey,
        border: Border(
          bottom: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: AppTheme.soluk,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMedium),
            
            // Project filter
            _buildProjectFilter(context),
            const SizedBox(width: AppTheme.spaceSmall),
            
            // Priority filter
            _buildPriorityFilter(context),
            
            const SizedBox(width: AppTheme.spaceMedium),
            
            // Clear filters button
            if (hasFilters)
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.soluk,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectFilter(BuildContext context) {
    return PopupMenuButton<String?>(
      onSelected: onProjectChanged,
      offset: const Offset(0, 8),
      color: AppTheme.panel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        side: const BorderSide(color: AppTheme.structuralLine),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<String?>(
          value: null,
          child: Text('All Projects'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'proj_001',
          child: Text('WorkforceOS Mobile'),
        ),
        const PopupMenuItem<String>(
          value: 'proj_002',
          child: Text('HR Dashboard'),
        ),
        const PopupMenuItem<String>(
          value: 'proj_003',
          child: Text('Payroll System'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selectedProjectId != null ? AppTheme.panel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radius24),
          border: Border.all(
            color: selectedProjectId != null 
                ? AppTheme.primaryStart.withValues(alpha: 0.3)
                : AppTheme.structuralLine,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 16,
              color: selectedProjectId != null ? AppTheme.primaryStart : AppTheme.soluk,
            ),
            const SizedBox(width: 6),
            Text(
              selectedProjectId != null ? _getProjectName(selectedProjectId!) : 'Project',
              style: TextStyle(
                color: selectedProjectId != null ? AppTheme.primaryStart : AppTheme.soluk,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: selectedProjectId != null ? AppTheme.primaryStart : AppTheme.soluk,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityFilter(BuildContext context) {
    return PopupMenuButton<TaskPriority?>(
      onSelected: onPriorityChanged,
      offset: const Offset(0, 8),
      color: AppTheme.panel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        side: const BorderSide(color: AppTheme.structuralLine),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<TaskPriority?>(
          value: null,
          child: Text('All Priorities'),
        ),
        const PopupMenuDivider(),
        ...TaskPriority.values.map((priority) {
          return PopupMenuItem<TaskPriority>(
            value: priority,
            child: Row(
              children: [
                Icon(
                  _getPriorityIcon(priority),
                  size: 16,
                  color: _getPriorityColor(priority),
                ),
                const SizedBox(width: 8),
                Text(_getPriorityName(priority)),
              ],
            ),
          );
        }),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selectedPriority != null ? AppTheme.panel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radius24),
          border: Border.all(
            color: selectedPriority != null 
                ? _getPriorityColor(selectedPriority!).withValues(alpha: 0.3)
                : AppTheme.structuralLine,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selectedPriority != null 
                  ? _getPriorityIcon(selectedPriority!)
                  : Icons.flag_outlined,
              size: 16,
              color: selectedPriority != null 
                  ? _getPriorityColor(selectedPriority!)
                  : AppTheme.soluk,
            ),
            const SizedBox(width: 6),
            Text(
              selectedPriority != null 
                  ? _getPriorityName(selectedPriority!)
                  : 'Priority',
              style: TextStyle(
                color: selectedPriority != null 
                    ? _getPriorityColor(selectedPriority!)
                    : AppTheme.soluk,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: selectedPriority != null 
                  ? _getPriorityColor(selectedPriority!)
                  : AppTheme.soluk,
            ),
          ],
        ),
      ),
    );
  }

  String _getProjectName(String projectId) {
    switch (projectId) {
      case 'proj_001':
        return 'WorkforceOS Mobile';
      case 'proj_002':
        return 'HR Dashboard';
      case 'proj_003':
        return 'Payroll System';
      default:
        return 'Unknown Project';
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
      case TaskPriority.urgent:
        return Icons.keyboard_double_arrow_up;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppTheme.basari;
      case TaskPriority.medium:
        return AppTheme.altin;
      case TaskPriority.high:
        return AppTheme.primaryStart;
      case TaskPriority.urgent:
        return Colors.red;
    }
  }

  String _getPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}