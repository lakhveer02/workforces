import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/responsive_layout.dart';
import '../../domain/leave_models.dart';
import '../../data/leave_repository.dart';
import '../widgets/leave_balance_card.dart';
import '../widgets/leave_history_list.dart';
import '../widgets/leave_status_badge.dart';
import 'apply_leave_screen.dart';

class LeaveOverviewScreen extends StatefulWidget {
  const LeaveOverviewScreen({super.key});

  @override
  State<LeaveOverviewScreen> createState() => _LeaveOverviewScreenState();
}

class _LeaveOverviewScreenState extends State<LeaveOverviewScreen> {
  final MockLeaveRepository _repository = MockLeaveRepository();
  
  List<LeaveBalance> _leaveBalances = [];
  List<LeaveRequest> _leaveHistory = [];
  bool _isLoadingBalances = false;
  bool _isLoadingHistory = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadLeaveBalances(),
      _loadLeaveHistory(),
    ]);
  }

  Future<void> _loadLeaveBalances() async {
    setState(() {
      _isLoadingBalances = true;
      _error = null;
    });

    try {
      final balances = await _repository.getLeaveBalances('emp_001');
      setState(() {
        _leaveBalances = balances;
        _isLoadingBalances = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load leave balances: $e';
        _isLoadingBalances = false;
      });
    }
  }

  Future<void> _loadLeaveHistory() async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final history = await _repository.getLeaveHistory(
        employeeId: 'emp_001',
        limit: 10,
      );
      setState(() {
        _leaveHistory = history;
        _isLoadingHistory = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load leave history: $e';
        _isLoadingHistory = false;
      });
    }
  }

  void _navigateToApplyLeave() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApplyLeaveScreen(),
      ),
    );
    
    if (result == true) {
      // Refresh data after successful leave application
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(theme),
          tablet: _buildTabletLayout(theme),
          desktop: _buildDesktopLayout(theme),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToApplyLeave,
        icon: const Icon(Icons.add),
        label: const Text('Apply Leave'),
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaveBalancesSection(theme),
          const SizedBox(height: 24),
          _buildLeaveHistorySection(theme),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaveBalancesSection(theme),
          const SizedBox(height: 32),
          _buildLeaveHistorySection(theme),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - Leave balances (40%)
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: _buildLeaveBalancesSection(theme),
          ),
        ),
        
        // Right column - Leave history (60%)
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: _buildLeaveHistorySection(theme),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveBalancesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Leave Balances',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${DateTime.now().year}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_isLoadingBalances)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_error!)),
                  TextButton(
                    onPressed: _loadLeaveBalances,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (_leaveBalances.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No leave balances found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveLayout.isMobile(context) ? 1 : 2,
              childAspectRatio: ResponsiveLayout.isMobile(context) ? 3.5 : 2.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _leaveBalances.length,
            itemBuilder: (context, index) {
              return LeaveBalanceCard(
                balance: _leaveBalances[index],
                onTap: () {
                  // Could navigate to detailed balance view
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildLeaveHistorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Recent Leave History',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // Navigate to full history view
              },
              child: const Text('View All'),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_isLoadingHistory)
          const Center(child: CircularProgressIndicator())
        else if (_leaveHistory.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No leave history found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your leave applications will appear here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          LeaveHistoryList(
            leaveRequests: _leaveHistory,
            onLeaveSelected: (leave) {
              _showLeaveDetails(leave);
            },
          ),
      ],
    );
  }

  void _showLeaveDetails(LeaveRequest leave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Leave Details',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Leave info
                  _buildDetailRow('Leave Type', leave.leaveType.displayName),
                  _buildDetailRow('Duration', '${leave.totalDays} day${leave.totalDays != 1 ? 's' : ''}'),
                  _buildDetailRow('Start Date', DateFormat('MMM d, yyyy').format(leave.startDate)),
                  _buildDetailRow('End Date', DateFormat('MMM d, yyyy').format(leave.endDate)),
                  _buildDetailRow('Status', '', trailing: LeaveStatusBadge(status: leave.status)),
                  _buildDetailRow('Applied On', DateFormat('MMM d, yyyy').format(leave.appliedDate)),
                  
                  if (leave.approvedDate != null)
                    _buildDetailRow('Approved On', DateFormat('MMM d, yyyy').format(leave.approvedDate!)),
                  
                  if (leave.managerName != null)
                    _buildDetailRow('Manager', leave.managerName!),
                  
                  const SizedBox(height: 16),
                  
                  // Reason
                  Text(
                    'Reason',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(leave.reason),
                  ),
                  
                  if (leave.rejectionReason != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Rejection Reason',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        leave.rejectionReason!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                  
                  // Actions
                  if (leave.canCancel) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Handle cancel leave
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel Leave'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: trailing ?? Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}