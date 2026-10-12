import 'package:flutter/material.dart';
import '../../domain/leave_models.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveBalance balance;
  final VoidCallback? onTap;

  const LeaveBalanceCard({
    super.key,
    required this.balance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and type
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getLeaveTypeColor(balance.leaveType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getLeaveTypeIcon(balance.leaveType),
                      color: _getLeaveTypeColor(balance.leaveType),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          balance.leaveType.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (balance.isLowBalance)
                          Text(
                            'Low Balance',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Balance display
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${balance.available.toStringAsFixed(1)}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: balance.isLowBalance ? Colors.orange : theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${balance.totalEntitled.toStringAsFixed(1)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Total',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Progress bar
              LinearProgressIndicator(
                value: balance.usagePercentage,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  balance.isLowBalance ? Colors.orange : theme.colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Usage details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Used: ${balance.used.toStringAsFixed(1)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (balance.pending > 0)
                    Text(
                      'Pending: ${balance.pending.toStringAsFixed(1)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                      ),
                    ),
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