import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/task_models.dart';
import '../../data/task_repository.dart';

class TaskDetailModal extends StatefulWidget {
  final Task task;

  const TaskDetailModal({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailModal> createState() => _TaskDetailModalState();
}

class _TaskDetailModalState extends State<TaskDetailModal> {
  final _repository = MockTaskRepository();
  late Task _task;
  bool _isLoading = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _updateTaskStatus(TaskStatus newStatus) async {
    try {
      setState(() => _isLoading = true);

      final updatedTask = await _repository.updateTaskStatus(_task.id, newStatus);
      
      if (mounted) {
        setState(() {
          _task = updatedTask;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task moved to ${newStatus.name}'),
            backgroundColor: AppTheme.basari,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Return updated task to parent
        Navigator.pop(context, updatedTask);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      await _repository.addComment(_task.id, content, 'emp_001', 'Current User');
      
      if (mounted) {
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment added'),
            backgroundColor: AppTheme.basari,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Reload task to show new comment (in real app would update state)
        Navigator.pop(context, _task);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.obsidyen,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radius16),
              topRight: Radius.circular(AppTheme.radius16),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.soluk,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              _buildHeader(),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppTheme.spaceLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTaskInfo(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildDescription(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildAssignees(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildLabels(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildProgress(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildComments(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildAddComment(),
                      const SizedBox(height: AppTheme.spaceXLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: const BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radius16),
          topRight: Radius.circular(AppTheme.radius16),
        ),
        border: Border(
          bottom: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _task.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _task.projectName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.soluk,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius24),
        border: Border.all(color: _getStatusColor().withValues(alpha: 0.3)),
      ),
      child: Text(
        _task.statusDisplayName,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTaskInfo() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Task Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          _buildInfoRow('Priority', _task.priorityDisplayName, _getPriorityColor()),
          _buildInfoRow('Created By', _task.createdByName),
          _buildInfoRow('Created', _formatDate(_task.createdAt)),
          if (_task.dueDate != null)
            _buildInfoRow(
              'Due Date', 
              _formatDate(_task.dueDate!),
              _task.isOverdue ? Colors.red : null,
            ),
          if (_task.estimatedHours != null)
            _buildInfoRow('Estimated', '${_task.estimatedHours}h'),
          if (_task.actualHours != null)
            _buildInfoRow('Actual', '${_task.actualHours}h'),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          Text(
            _task.description.isNotEmpty 
                ? _task.description 
                : 'No description provided',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _task.description.isNotEmpty ? AppTheme.buz : AppTheme.soluk,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignees() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_outline,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Assignees (${_task.assignees.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          if (_task.assignees.isEmpty)
            Text(
              'No assignees',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            )
          else
            Column(
              children: _task.assignees.map((assignee) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.panel,
                        child: Text(
                          assignee.name.split(' ').map((n) => n[0]).take(2).join(),
                          style: const TextStyle(
                            color: AppTheme.buz,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignee.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.buz,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              assignee.email,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.soluk,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLabels() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.label_outline,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Labels',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          if (_task.labels.isEmpty)
            Text(
              'No labels',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _task.labels.map((label) {
                final color = Color(int.parse(label.color.replaceAll('#', '0xFF')));
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radius24),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    label.name,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.timeline,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Change Status',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskStatus.values
                .where((status) => status != _task.status && status != TaskStatus.cancelled)
                .map((status) {
              return ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _updateTaskStatus(status),
                icon: Icon(_getStatusIcon(status), size: 16),
                label: Text(_getStatusDisplayName(status)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(status),
                  foregroundColor: AppTheme.buz,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildComments() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.comment_outlined,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Comments (${_task.comments.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          if (_task.comments.isEmpty)
            Text(
              'No comments yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            )
          else
            Column(
              children: _task.comments.map((comment) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.panel,
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                    border: Border.all(color: AppTheme.structuralLine),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppTheme.yuzey,
                            child: Text(
                              comment.authorName.split(' ').map((n) => n[0]).take(2).join(),
                              style: const TextStyle(
                                color: AppTheme.buz,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              comment.authorName,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.buz,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            _formatDate(comment.createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.soluk,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comment.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.buz,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAddComment() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Comment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.buz,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Write a comment...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _addComment,
                child: const Text('Add Comment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.soluk,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor ?? AppTheme.buz,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor([TaskStatus? status]) {
    final taskStatus = status ?? _task.status;
    switch (taskStatus) {
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

  Color _getPriorityColor() {
    switch (_task.priority) {
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
        return 'In Progress';
      case TaskStatus.review:
        return 'Review';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}