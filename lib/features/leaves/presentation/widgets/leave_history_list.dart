import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/common/app_card.dart';
import '../../domain/leave_models.dart';
import 'leave_status_badge.dart';

class LeaveHistoryList extends StatelessWidget {
  final List<LeaveRequest> leaveRequests;
  final Function(LeaveRequest)? onLeaveSelected;

  const LeaveHistoryList({
    super.key,
    required this.leaveRequests,
    this.onLeaveSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: leaveRequests.map((request) => 
        _buildLeaveHistoryItem(context, request)
      ).toList(),
    );
  }

  Widget _buildLeaveHistoryItem(BuildContext context, LeaveRequest request) {
    final theme = Theme.of(context);
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onLeaveSelected?.call(request),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getLeaveTypeColor(request.leaveType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getLeaveTypeIcon(request.leaveType),
                      color: _getLeaveTypeColor(request.leaveType),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.leaveType.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${request.totalDays} day${request.totalDays != 1 ? 's' : ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  LeaveStatusBadge(status: request.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Date range
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('MMM d').format(request.startDate)} - ${DateFormat('MMM d, yyyy').format(request.endDate)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (request.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    )
                  else if (request.isUpcoming)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'UPCOMING',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Reason
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.reason,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Additional info for rejected leaves
              if (request.status == LeaveStatus.rejected && request.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rejection Reason:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.rejectionReason!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Footer with applied date and manager
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Applied ${DateFormat('MMM d, yyyy').format(request.appliedDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (request.managerName != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.person,
                      size: 14,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      request.managerName!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLeaveTypeColor(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return Colors.blue;
      case LeaveType.sick:
        return Colors.red;
      case LeaveType.casual:
        return Colors.green;
      case LeaveType.maternity:
        return Colors.pink;
      case LeaveType.paternity:
        return Colors.indigo;
      case LeaveType.emergency:
        return Colors.orange;
      case LeaveType.compensatory:
        return Colors.purple;
    }
  }

  IconData _getLeaveTypeIcon(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return Icons.beach_access;
      case LeaveType.sick:
        return Icons.healing;
      case LeaveType.casual:
        return Icons.coffee;
      case LeaveType.maternity:
        return Icons.child_care;
      case LeaveType.paternity:
        return Icons.family_restroom;
      case LeaveType.emergency:
        return Icons.emergency;
      case LeaveType.compensatory:
        return Icons.access_time;
    }
  }
}