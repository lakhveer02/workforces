import '../domain/leave_models.dart';

/// Abstract interface for leave repository
abstract class LeaveRepositoryInterface {
  Future<List<LeaveBalance>> getLeaveBalances(String employeeId);
  Future<List<LeaveRequest>> getLeaveHistory({
    String? employeeId,
    LeaveFilters? filters,
    int page = 0,
    int limit = 20,
  });
  Future<LeaveRequest> applyLeave(LeaveApplicationRequest request);
  Future<List<LeaveRequest>> getPendingApprovals(String managerId);
  Future<LeaveRequest> processLeaveAction(LeaveActionRequest request);
  Future<List<TeamLeaveOverlap>> getTeamOverlaps(
    DateTime startDate, 
    DateTime endDate, 
    String departmentId
  );
  Future<bool> canApplyLeave(String employeeId, LeaveType leaveType, double days);
}

/// Mock implementation of leave repository
class MockLeaveRepository implements LeaveRepositoryInterface {
  
  // Mock data storage
  static final List<LeaveBalance> _leaveBalances = _generateMockBalances();
  static final List<LeaveRequest> _leaveRequests = _generateMockLeaveRequests();

  @override
  Future<List<LeaveBalance>> getLeaveBalances(String employeeId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Return balances for the specific employee
    return _leaveBalances.where((balance) => 
      balance.year == DateTime.now().year
    ).toList();
  }

  @override
  Future<List<LeaveRequest>> getLeaveHistory({
    String? employeeId,
    LeaveFilters? filters,
    int page = 0,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filteredRequests = List<LeaveRequest>.from(_leaveRequests);
    
    // Filter by employee ID
    if (employeeId != null) {
      filteredRequests = filteredRequests
          .where((request) => request.employeeId == employeeId)
          .toList();
    }
    
    // Apply additional filters
    if (filters != null) {
      if (filters.leaveType != null) {
        filteredRequests = filteredRequests
            .where((request) => request.leaveType == filters.leaveType)
            .toList();
      }
      
      if (filters.status != null) {
        filteredRequests = filteredRequests
            .where((request) => request.status == filters.status)
            .toList();
      }
      
      if (filters.startDate != null) {
        filteredRequests = filteredRequests
            .where((request) => request.startDate.isAfter(
              filters.startDate!.subtract(const Duration(days: 1))))
            .toList();
      }
      
      if (filters.endDate != null) {
        filteredRequests = filteredRequests
            .where((request) => request.endDate.isBefore(
              filters.endDate!.add(const Duration(days: 1))))
            .toList();
      }
      
      if (filters.searchQuery?.isNotEmpty ?? false) {
        final query = filters.searchQuery!.toLowerCase();
        filteredRequests = filteredRequests
            .where((request) => 
              request.employeeName.toLowerCase().contains(query) ||
              request.reason.toLowerCase().contains(query) ||
              request.leaveType.displayName.toLowerCase().contains(query))
            .toList();
      }
    }
    
    // Sort by application date (newest first)
    filteredRequests.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    
    // Apply pagination
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, filteredRequests.length);
    
    if (startIndex >= filteredRequests.length) {
      return [];
    }
    
    return filteredRequests.sublist(startIndex, endIndex);
  }

  @override
  Future<LeaveRequest> applyLeave(LeaveApplicationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Validate the request
    final errors = request.validate();
    if (errors.isNotEmpty) {
      throw Exception('Validation failed: ${errors.join(', ')}');
    }
    
    // Check leave balance
    final canApply = await canApplyLeave(
      request.employeeId, 
      request.leaveType, 
      request.totalDays
    );
    
    if (!canApply) {
      throw Exception('Insufficient leave balance for ${request.leaveType.displayName}');
    }
    
    // Create new leave request
    final newRequest = LeaveRequest(
      id: 'leave_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: request.employeeId,
      employeeName: request.employeeName,
      leaveType: request.leaveType,
      startDate: request.startDate,
      endDate: request.endDate,
      totalDays: request.totalDays,
      reason: request.reason,
      status: LeaveStatus.pending,
      appliedDate: DateTime.now(),
      managerName: 'John Manager', // Mock manager
      managerId: 'manager_001',
      emergencyContact: request.emergencyContact,
      coveringEmployee: request.coveringEmployee,
    );
    
    // Add to mock storage
    _leaveRequests.insert(0, newRequest);
    
    // Update leave balance to reflect pending request
    _updateLeaveBalance(request.employeeId, request.leaveType, 0, request.totalDays);
    
    return newRequest;
  }

  @override
  Future<List<LeaveRequest>> getPendingApprovals(String managerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return _leaveRequests
        .where((request) => 
          request.status == LeaveStatus.pending && 
          request.managerId == managerId)
        .toList();
  }

  @override
  Future<LeaveRequest> processLeaveAction(LeaveActionRequest request) async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    final requestIndex = _leaveRequests.indexWhere(
      (leave) => leave.id == request.leaveId
    );
    
    if (requestIndex == -1) {
      throw Exception('Leave request not found');
    }
    
    final leaveRequest = _leaveRequests[requestIndex];
    
    if (leaveRequest.status != LeaveStatus.pending) {
      throw Exception('Leave request has already been processed');
    }
    
    // Update the request
    final updatedRequest = leaveRequest.copyWith(
      status: request.action,
      managerName: request.managerName,
      managerId: request.managerId,
      approvedDate: request.action == LeaveStatus.approved ? DateTime.now() : null,
      rejectionReason: request.action == LeaveStatus.rejected ? request.comments : null,
    );
    
    _leaveRequests[requestIndex] = updatedRequest;
    
    // Update leave balance based on action
    if (request.action == LeaveStatus.approved) {
      // Move from pending to used
      _updateLeaveBalance(
        leaveRequest.employeeId,
        leaveRequest.leaveType,
        leaveRequest.totalDays,
        -leaveRequest.totalDays, // Remove from pending
      );
    } else if (request.action == LeaveStatus.rejected) {
      // Remove from pending
      _updateLeaveBalance(
        leaveRequest.employeeId,
        leaveRequest.leaveType,
        0,
        -leaveRequest.totalDays,
      );
    }
    
    return updatedRequest;
  }

  @override
  Future<List<TeamLeaveOverlap>> getTeamOverlaps(
    DateTime startDate, 
    DateTime endDate, 
    String departmentId
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Find overlapping approved leaves in the same department
    final overlaps = <TeamLeaveOverlap>[];
    
    for (final request in _leaveRequests) {
      if (request.status == LeaveStatus.approved &&
          _hasDateOverlap(request.startDate, request.endDate, startDate, endDate)) {
        
        final overlapDays = _calculateOverlapDays(
          request.startDate, request.endDate, startDate, endDate
        );
        
        overlaps.add(TeamLeaveOverlap(
          employeeName: request.employeeName,
          leaveType: request.leaveType,
          startDate: request.startDate,
          endDate: request.endDate,
          overlapDays: overlapDays,
        ));
      }
    }
    
    return overlaps;
  }

  @override
  Future<bool> canApplyLeave(String employeeId, LeaveType leaveType, double days) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final balances = await getLeaveBalances(employeeId);
    final balance = balances.firstWhere(
      (b) => b.leaveType == leaveType,
      orElse: () => const LeaveBalance(
        leaveType: LeaveType.annual,
        totalEntitled: 0,
        used: 0,
        pending: 0,
        year: 0,
      ),
    );
    
    return balance.available >= days;
  }

  // Helper methods
  
  void _updateLeaveBalance(String employeeId, LeaveType leaveType, double usedDelta, double pendingDelta) {
    final balanceIndex = _leaveBalances.indexWhere(
      (b) => b.leaveType == leaveType && b.year == DateTime.now().year
    );
    
    if (balanceIndex != -1) {
      final balance = _leaveBalances[balanceIndex];
      _leaveBalances[balanceIndex] = balance.copyWith(
        used: balance.used + usedDelta,
        pending: balance.pending + pendingDelta,
      );
    }
  }
  
  bool _hasDateOverlap(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isBefore(end2.add(const Duration(days: 1))) &&
           end1.isAfter(start2.subtract(const Duration(days: 1)));
  }
  
  int _calculateOverlapDays(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    final overlapStart = start1.isAfter(start2) ? start1 : start2;
    final overlapEnd = end1.isBefore(end2) ? end1 : end2;
    
    if (overlapStart.isAfter(overlapEnd)) return 0;
    
    return overlapEnd.difference(overlapStart).inDays + 1;
  }

  // Mock data generators
  
  static List<LeaveBalance> _generateMockBalances() {
    final currentYear = DateTime.now().year;
    
    return [
      LeaveBalance(
        leaveType: LeaveType.annual,
        totalEntitled: 20.0,
        used: 8.0,
        pending: 2.0,
        year: currentYear,
      ),
      LeaveBalance(
        leaveType: LeaveType.sick,
        totalEntitled: 10.0,
        used: 3.0,
        pending: 0.0,
        year: currentYear,
      ),
      LeaveBalance(
        leaveType: LeaveType.casual,
        totalEntitled: 12.0,
        used: 5.0,
        pending: 1.0,
        year: currentYear,
      ),
      LeaveBalance(
        leaveType: LeaveType.compensatory,
        totalEntitled: 6.0,
        used: 2.0,
        pending: 0.0,
        year: currentYear,
      ),
    ];
  }
  
  static List<LeaveRequest> _generateMockLeaveRequests() {
    final now = DateTime.now();
    
    return [
      // Recent pending request
      LeaveRequest(
        id: 'leave_001',
        employeeId: 'emp_001',
        employeeName: 'Current User',
        leaveType: LeaveType.annual,
        startDate: now.add(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 17)),
        totalDays: 3.0,
        reason: 'Family vacation to mountains',
        status: LeaveStatus.pending,
        appliedDate: now.subtract(const Duration(days: 2)),
        managerName: 'John Manager',
        managerId: 'manager_001',
      ),
      
      // Approved upcoming leave
      LeaveRequest(
        id: 'leave_002',
        employeeId: 'emp_001',
        employeeName: 'Current User',
        leaveType: LeaveType.sick,
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 6)),
        totalDays: 2.0,
        reason: 'Medical appointment',
        status: LeaveStatus.approved,
        appliedDate: now.subtract(const Duration(days: 10)),
        approvedDate: now.subtract(const Duration(days: 8)),
        managerName: 'John Manager',
        managerId: 'manager_001',
      ),
      
      // Past approved leave
      LeaveRequest(
        id: 'leave_003',
        employeeId: 'emp_001',
        employeeName: 'Current User',
        leaveType: LeaveType.casual,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.subtract(const Duration(days: 28)),
        totalDays: 3.0,
        reason: 'Personal work',
        status: LeaveStatus.approved,
        appliedDate: now.subtract(const Duration(days: 35)),
        approvedDate: now.subtract(const Duration(days: 33)),
        managerName: 'John Manager',
        managerId: 'manager_001',
      ),
      
      // Rejected leave
      LeaveRequest(
        id: 'leave_004',
        employeeId: 'emp_001',
        employeeName: 'Current User',
        leaveType: LeaveType.annual,
        startDate: now.subtract(const Duration(days: 20)),
        endDate: now.subtract(const Duration(days: 15)),
        totalDays: 6.0,
        reason: 'Extended weekend trip',
        status: LeaveStatus.rejected,
        appliedDate: now.subtract(const Duration(days: 25)),
        rejectionReason: 'Peak project delivery period',
        managerName: 'John Manager',
        managerId: 'manager_001',
      ),
      
      // Team member requests for manager approval
      LeaveRequest(
        id: 'leave_005',
        employeeId: 'emp_002',
        employeeName: 'Sarah Johnson',
        leaveType: LeaveType.annual,
        startDate: now.add(const Duration(days: 20)),
        endDate: now.add(const Duration(days: 25)),
        totalDays: 6.0,
        reason: 'Family wedding celebration',
        status: LeaveStatus.pending,
        appliedDate: now.subtract(const Duration(days: 1)),
        managerName: 'John Manager',
        managerId: 'manager_001',
        emergencyContact: '+1234567890',
        coveringEmployee: 'Mike Wilson',
      ),
      
      LeaveRequest(
        id: 'leave_006',
        employeeId: 'emp_003',
        employeeName: 'Mike Wilson',
        leaveType: LeaveType.sick,
        startDate: now.add(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 4)),
        totalDays: 2.0,
        reason: 'Recovery from surgery',
        status: LeaveStatus.pending,
        appliedDate: now,
        managerName: 'John Manager',
        managerId: 'manager_001',
        emergencyContact: '+1234567891',
      ),
    ];
  }
}