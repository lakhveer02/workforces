import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/common/app_card.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../domain/leave_models.dart';
import '../../data/leave_repository.dart';
import '../widgets/leave_status_badge.dart';

class LeaveApprovalsScreen extends StatefulWidget {
  const LeaveApprovalsScreen({super.key});

  @override
  State<LeaveApprovalsScreen> createState() => _LeaveApprovalsScreenState();
}

class _LeaveApprovalsScreenState extends State<LeaveApprovalsScreen> {
  final MockLeaveRepository _repository = MockLeaveRepository();
  
  List<LeaveRequest> _pendingApprovals = [];
  bool _isLoading = false;
  String? _error;
  String? _processingLeaveId;

  @override
  void initState() {
    super.initState();
    _loadPendingApprovals();
  }

  Future<void> _loadPendingApprovals() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final approvals = await _repository.getPendingApprovals('manager_001');
      setState(() {
        _pendingApprovals = approvals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load pending approvals: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _processLeaveAction(LeaveRequest request, LeaveStatus action) async {
    final comments = await _showActionDialog(request, action);
    if (comments == null) return; // User cancelled
    
    setState(() {
      _processingLeaveId = request.id;
    });

    try {
      final actionRequest = LeaveActionRequest(
        leaveId: request.id,
        action: action,
        managerId: 'manager_001',
        managerName: 'John Manager',
        comments: comments.isNotEmpty ? comments : null,
      );

      await _repository.processLeaveAction(actionRequest);

      // Remove from pending list
      setState(() {
        _pendingApprovals.removeWhere((r) => r.id == request.id);
        _processingLeaveId = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Leave request ${action.displayName.toLowerCase()} successfully',
            ),
            backgroundColor: action == LeaveStatus.approved ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${action.displayName.toLowerCase()} leave: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _processingLeaveId = null;
      });
    }
  }

  Future<String?> _showActionDialog(LeaveRequest request, LeaveStatus action) async {
    final commentsController = TextEditingController();
    final isRejection = action == LeaveStatus.rejected;
    
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${action.displayName} Leave Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employee: ${request.employeeName}'),
            Text('Leave Type: ${request.leaveType.displayName}'),
            Text('Duration: ${request.totalDays} days'),
            Text('Dates: ${DateFormat('MMM d').format(request.startDate)} - ${DateFormat('MMM d, yyyy').format(request.endDate)}'),
            const SizedBox(height: 16),
            TextField(
              controller: commentsController,
              decoration: InputDecoration(
                labelText: isRejection ? 'Rejection Reason *' : 'Comments (Optional)',
                hintText: isRejection 
                    ? 'Please provide a reason for rejection...' 
                    : 'Add any comments...',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final comments = commentsController.text.trim();
              if (isRejection && comments.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rejection reason is required'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              Navigator.pop(context, comments);
            },
            style: FilledButton.styleFrom(
              backgroundColor: action == LeaveStatus.approved 
                  ? Colors.green 
                  : Colors.orange,
            ),
            child: Text(action.displayName),
          ),
        ],
      ),
    );
  }

  void _showLeaveDetails(LeaveRequest request) async {
    // Load team overlaps
    final overlaps = await _repository.getTeamOverlaps(
      request.startDate,
      request.endDate,
      'dept_engineering', // Mock department ID
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.6,
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
                          'Leave Request Details',
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
                  
                  // Employee Information
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employee Information',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Name', request.employeeName),
                          _buildDetailRow('Employee ID', request.employeeId),
                          if (request.emergencyContact != null)
                            _buildDetailRow('Emergency Contact', request.emergencyContact!),
                          if (request.coveringEmployee != null)
                            _buildDetailRow('Covering Employee', request.coveringEmployee!),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Leave Details
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leave Details',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Leave Type', request.leaveType.displayName),
                          _buildDetailRow('Duration', '${request.totalDays} day${request.totalDays != 1 ? 's' : ''}'),
                          _buildDetailRow('Start Date', DateFormat('EEEE, MMM d, yyyy').format(request.startDate)),
                          _buildDetailRow('End Date', DateFormat('EEEE, MMM d, yyyy').format(request.endDate)),
                          _buildDetailRow('Applied On', DateFormat('MMM d, yyyy').format(request.appliedDate)),
                          _buildDetailRow('Status', '', trailing: LeaveStatusBadge(status: request.status)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Reason
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reason for Leave',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(request.reason),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Team Overlaps
                  if (overlaps.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AppCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Team Leave Overlaps',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...overlaps.map((overlap) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(overlap.employeeName),
                                  ),
                                  Text(
                                    '${overlap.overlapDays} day${overlap.overlapDays != 1 ? 's' : ''} overlap',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  if (request.status == LeaveStatus.pending) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _processingLeaveId == request.id 
                                ? null 
                                : () {
                                    Navigator.pop(context);
                                    _processLeaveAction(request, LeaveStatus.rejected);
                                  },
                            icon: _processingLeaveId == request.id 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.close),
                            label: const Text('Reject'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _processingLeaveId == request.id 
                                ? null 
                                : () {
                                    Navigator.pop(context);
                                    _processLeaveAction(request, LeaveStatus.approved);
                                  },
                            icon: _processingLeaveId == request.id 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.check),
                            label: const Text('Approve'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Approvals'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingApprovals,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPendingApprovals,
        child: _buildContent(theme),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Approvals',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loadPendingApprovals,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_pendingApprovals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'All Caught Up!',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'No pending leave requests to review',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileList(theme),
      tablet: _buildTabletList(theme),
      desktop: _buildDesktopTable(theme),
    );
  }

  Widget _buildMobileList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingApprovals.length,
      itemBuilder: (context, index) {
        final request = _pendingApprovals[index];
        return _buildLeaveRequestCard(request, theme);
      },
    );
  }

  Widget _buildTabletList(ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _pendingApprovals.length,
      itemBuilder: (context, index) {
        final request = _pendingApprovals[index];
        return _buildLeaveRequestCard(request, theme);
      },
    );
  }

  Widget _buildDesktopTable(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Leave Type')),
          DataColumn(label: Text('Duration')),
          DataColumn(label: Text('Dates')),
          DataColumn(label: Text('Applied')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _pendingApprovals.map((request) {
          return DataRow(
            onSelectChanged: (_) => _showLeaveDetails(request),
            cells: [
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      request.employeeName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      request.employeeId,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(request.leaveType.displayName)),
              DataCell(Text('${request.totalDays} day${request.totalDays != 1 ? 's' : ''}')),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('MMM d').format(request.startDate)),
                    Text(
                      DateFormat('MMM d, yyyy').format(request.endDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(DateFormat('MMM d').format(request.appliedDate))),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.orange),
                      onPressed: _processingLeaveId == request.id 
                          ? null 
                          : () => _processLeaveAction(request, LeaveStatus.rejected),
                      tooltip: 'Reject',
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: _processingLeaveId == request.id 
                          ? null 
                          : () => _processLeaveAction(request, LeaveStatus.approved),
                      tooltip: 'Approve',
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeaveRequestCard(LeaveRequest request, ThemeData theme) {
    final isProcessing = _processingLeaveId == request.id;
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showLeaveDetails(request),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee info
              Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      request.employeeName[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.employeeName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          request.employeeId,
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
              
              const SizedBox(height: 16),
              
              // Leave details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.leaveType.displayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
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
                  Text(
                    '${DateFormat('MMM d').format(request.startDate)} - ${DateFormat('MMM d').format(request.endDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
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
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing 
                          ? null 
                          : () => _processLeaveAction(request, LeaveStatus.rejected),
                      icon: isProcessing 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: isProcessing 
                          ? null 
                          : () => _processLeaveAction(request, LeaveStatus.approved),
                      icon: isProcessing 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
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

  Widget _buildDetailRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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