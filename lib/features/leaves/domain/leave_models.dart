import 'package:equatable/equatable.dart';

/// Leave type enumeration
enum LeaveType {
  annual('Annual Leave'),
  sick('Sick Leave'),
  casual('Casual Leave'),
  maternity('Maternity Leave'),
  paternity('Paternity Leave'),
  emergency('Emergency Leave'),
  compensatory('Compensatory Off');

  const LeaveType(this.displayName);
  final String displayName;
}

/// Leave request status
enum LeaveStatus {
  pending('Pending', 'pending'),
  approved('Approved', 'approved'),
  rejected('Rejected', 'rejected'),
  cancelled('Cancelled', 'cancelled'),
  expired('Expired', 'expired');

  const LeaveStatus(this.displayName, this.value);
  final String displayName;
  final String value;
}

/// Leave balance model for tracking employee entitlements
class LeaveBalance extends Equatable {
  const LeaveBalance({
    required this.leaveType,
    required this.totalEntitled,
    required this.used,
    required this.pending,
    required this.year,
  });

  final LeaveType leaveType;
  final double totalEntitled;
  final double used;
  final double pending; // Days in pending requests
  final int year;

  /// Available balance (entitled - used - pending)
  double get available => totalEntitled - used - pending;
  
  /// Usage percentage
  double get usagePercentage => totalEntitled > 0 ? used / totalEntitled : 0.0;

  /// Whether the leave type is nearly exhausted
  bool get isLowBalance => available <= 2.0;

  @override
  List<Object?> get props => [leaveType, totalEntitled, used, pending, year];

  LeaveBalance copyWith({
    LeaveType? leaveType,
    double? totalEntitled,
    double? used,
    double? pending,
    int? year,
  }) {
    return LeaveBalance(
      leaveType: leaveType ?? this.leaveType,
      totalEntitled: totalEntitled ?? this.totalEntitled,
      used: used ?? this.used,
      pending: pending ?? this.pending,
      year: year ?? this.year,
    );
  }
}

/// Leave request model
class LeaveRequest extends Equatable {
  const LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    required this.appliedDate,
    this.managerName,
    this.managerId,
    this.approvedDate,
    this.rejectionReason,
    this.emergencyContact,
    this.documents,
    this.coveringEmployee,
  });

  final String id;
  final String employeeId;
  final String employeeName;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final double totalDays;
  final String reason;
  final LeaveStatus status;
  final DateTime appliedDate;
  final String? managerName;
  final String? managerId;
  final DateTime? approvedDate;
  final String? rejectionReason;
  final String? emergencyContact;
  final List<String>? documents;
  final String? coveringEmployee;

  /// Check if leave is currently active
  bool get isActive {
    final now = DateTime.now();
    return status == LeaveStatus.approved && 
           startDate.isBefore(now.add(const Duration(days: 1))) &&
           endDate.isAfter(now.subtract(const Duration(days: 1)));
  }

  /// Check if leave is upcoming
  bool get isUpcoming {
    return status == LeaveStatus.approved && startDate.isAfter(DateTime.now());
  }

  /// Check if leave can be cancelled
  bool get canCancel {
    return (status == LeaveStatus.pending || 
            (status == LeaveStatus.approved && startDate.isAfter(DateTime.now())));
  }

  @override
  List<Object?> get props => [
    id, employeeId, employeeName, leaveType, startDate, endDate,
    totalDays, reason, status, appliedDate, managerName, managerId,
    approvedDate, rejectionReason, emergencyContact, documents, coveringEmployee
  ];

  LeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    double? totalDays,
    String? reason,
    LeaveStatus? status,
    DateTime? appliedDate,
    String? managerName,
    String? managerId,
    DateTime? approvedDate,
    String? rejectionReason,
    String? emergencyContact,
    List<String>? documents,
    String? coveringEmployee,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      managerName: managerName ?? this.managerName,
      managerId: managerId ?? this.managerId,
      approvedDate: approvedDate ?? this.approvedDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      documents: documents ?? this.documents,
      coveringEmployee: coveringEmployee ?? this.coveringEmployee,
    );
  }
}

/// Leave application request for creating new leave
class LeaveApplicationRequest extends Equatable {
  const LeaveApplicationRequest({
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.emergencyContact,
    this.coveringEmployee,
  });

  final String employeeId;
  final String employeeName;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String? emergencyContact;
  final String? coveringEmployee;

  /// Calculate total days between start and end date
  double get totalDays {
    final difference = endDate.difference(startDate).inDays + 1;
    return difference.toDouble();
  }

  /// Validate the leave request
  List<String> validate() {
    final errors = <String>[];
    
    if (startDate.isAfter(endDate)) {
      errors.add('Start date cannot be after end date');
    }
    
    if (startDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      errors.add('Cannot apply for past dates');
    }
    
    if (reason.trim().isEmpty) {
      errors.add('Reason is required');
    }
    
    if (totalDays > 365) {
      errors.add('Leave duration cannot exceed 365 days');
    }
    
    return errors;
  }

  @override
  List<Object?> get props => [
    employeeId, employeeName, leaveType, startDate, endDate, 
    reason, emergencyContact, coveringEmployee
  ];
}

/// Leave approval/rejection request
class LeaveActionRequest extends Equatable {
  const LeaveActionRequest({
    required this.leaveId,
    required this.action,
    required this.managerId,
    required this.managerName,
    this.comments,
  });

  final String leaveId;
  final LeaveStatus action; // approved or rejected
  final String managerId;
  final String managerName;
  final String? comments;

  @override
  List<Object?> get props => [leaveId, action, managerId, managerName, comments];
}

/// Team leave overlap information
class TeamLeaveOverlap extends Equatable {
  const TeamLeaveOverlap({
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.overlapDays,
  });

  final String employeeName;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int overlapDays;

  @override
  List<Object?> get props => [employeeName, leaveType, startDate, endDate, overlapDays];
}

/// Leave filters for searching and filtering
class LeaveFilters extends Equatable {
  const LeaveFilters({
    this.employeeId,
    this.leaveType,
    this.status,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  final String? employeeId;
  final LeaveType? leaveType;
  final LeaveStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  bool get hasActiveFilters {
    return employeeId != null || 
           leaveType != null || 
           status != null || 
           startDate != null || 
           endDate != null ||
           (searchQuery?.isNotEmpty ?? false);
  }

  @override
  List<Object?> get props => [employeeId, leaveType, status, startDate, endDate, searchQuery];

  LeaveFilters copyWith({
    String? employeeId,
    LeaveType? leaveType,
    LeaveStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    bool clearEmployeeId = false,
    bool clearLeaveType = false,
    bool clearStatus = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return LeaveFilters(
      employeeId: clearEmployeeId ? null : (employeeId ?? this.employeeId),
      leaveType: clearLeaveType ? null : (leaveType ?? this.leaveType),
      status: clearStatus ? null : (status ?? this.status),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}