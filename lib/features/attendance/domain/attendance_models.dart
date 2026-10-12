import 'package:equatable/equatable.dart';

/// Daily attendance record for an employee
class AttendanceRecord extends Equatable {
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    this.punchInTime,
    this.punchOutTime,
    this.breakStartTime,
    this.breakEndTime,
    this.location,
    this.notes,
    this.isManualEntry = false,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime? punchInTime;
  final DateTime? punchOutTime;
  final DateTime? breakStartTime;
  final DateTime? breakEndTime;
  final String? location;
  final String? notes;
  final bool isManualEntry;
  final String? approvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed properties
  AttendanceStatus get status {
    if (punchInTime == null) return AttendanceStatus.absent;
    if (punchOutTime == null) return AttendanceStatus.present;
    
    final workHours = totalWorkingHours;
    if (workHours >= 8.0) return AttendanceStatus.present;
    if (workHours >= 4.0) return AttendanceStatus.halfDay;
    
    return AttendanceStatus.present;
  }

  double get totalWorkingHours {
    if (punchInTime == null || punchOutTime == null) return 0.0;
    
    final totalMinutes = punchOutTime!.difference(punchInTime!).inMinutes;
    final breakMinutes = breakDurationMinutes;
    
    return (totalMinutes - breakMinutes) / 60.0;
  }

  int get breakDurationMinutes {
    if (breakStartTime == null || breakEndTime == null) return 0;
    return breakEndTime!.difference(breakStartTime!).inMinutes;
  }

  bool get isLate {
    if (punchInTime == null) return false;
    
    // Consider 9:00 AM as standard start time
    final standardStart = DateTime(
      punchInTime!.year,
      punchInTime!.month,
      punchInTime!.day,
      9,
      0,
    );
    
    return punchInTime!.isAfter(standardStart);
  }

  bool get isOvertime {
    return totalWorkingHours > 8.0;
  }

  double get overtimeHours {
    final regular = totalWorkingHours;
    return regular > 8.0 ? regular - 8.0 : 0.0;
  }

  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    DateTime? date,
    DateTime? punchInTime,
    DateTime? punchOutTime,
    DateTime? breakStartTime,
    DateTime? breakEndTime,
    String? location,
    String? notes,
    bool? isManualEntry,
    String? approvedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      punchInTime: punchInTime ?? this.punchInTime,
      punchOutTime: punchOutTime ?? this.punchOutTime,
      breakStartTime: breakStartTime ?? this.breakStartTime,
      breakEndTime: breakEndTime ?? this.breakEndTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      approvedBy: approvedBy ?? this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'date': date.toIso8601String(),
      'punchInTime': punchInTime?.toIso8601String(),
      'punchOutTime': punchOutTime?.toIso8601String(),
      'breakStartTime': breakStartTime?.toIso8601String(),
      'breakEndTime': breakEndTime?.toIso8601String(),
      'location': location,
      'notes': notes,
      'isManualEntry': isManualEntry,
      'approvedBy': approvedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      date: DateTime.parse(json['date'] as String),
      punchInTime: json['punchInTime'] != null
          ? DateTime.parse(json['punchInTime'] as String)
          : null,
      punchOutTime: json['punchOutTime'] != null
          ? DateTime.parse(json['punchOutTime'] as String)
          : null,
      breakStartTime: json['breakStartTime'] != null
          ? DateTime.parse(json['breakStartTime'] as String)
          : null,
      breakEndTime: json['breakEndTime'] != null
          ? DateTime.parse(json['breakEndTime'] as String)
          : null,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      isManualEntry: json['isManualEntry'] as bool? ?? false,
      approvedBy: json['approvedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        date,
        punchInTime,
        punchOutTime,
        breakStartTime,
        breakEndTime,
        location,
        notes,
        isManualEntry,
        approvedBy,
        createdAt,
        updatedAt,
      ];
}

enum AttendanceStatus {
  present,
  absent,
  halfDay,
  late,
  onLeave;

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.onLeave:
        return 'On Leave';
    }
  }

  String get value {
    switch (this) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.halfDay:
        return 'half_day';
      case AttendanceStatus.late:
        return 'late';
      case AttendanceStatus.onLeave:
        return 'on_leave';
    }
  }

  static AttendanceStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'half_day':
        return AttendanceStatus.halfDay;
      case 'late':
        return AttendanceStatus.late;
      case 'on_leave':
        return AttendanceStatus.onLeave;
      default:
        throw ArgumentError('Invalid attendance status: $value');
    }
  }
}

/// Monthly attendance summary
class AttendanceSummary extends Equatable {
  const AttendanceSummary({
    required this.employeeId,
    required this.month,
    required this.year,
    required this.totalWorkingDays,
    required this.presentDays,
    required this.absentDays,
    required this.halfDays,
    required this.lateDays,
    required this.totalWorkingHours,
    required this.averageWorkingHours,
    required this.overtimeHours,
  });

  final String employeeId;
  final int month;
  final int year;
  final int totalWorkingDays;
  final int presentDays;
  final int absentDays;
  final int halfDays;
  final int lateDays;
  final double totalWorkingHours;
  final double averageWorkingHours;
  final double overtimeHours;

  double get attendancePercentage {
    if (totalWorkingDays == 0) return 0.0;
    return (presentDays + (halfDays * 0.5)) / totalWorkingDays * 100;
  }

  @override
  List<Object?> get props => [
        employeeId,
        month,
        year,
        totalWorkingDays,
        presentDays,
        absentDays,
        halfDays,
        lateDays,
        totalWorkingHours,
        averageWorkingHours,
        overtimeHours,
      ];
}

/// Punch request for check-in/check-out
class PunchRequest extends Equatable {
  const PunchRequest({
    required this.employeeId,
    required this.timestamp,
    required this.type,
    this.location,
    this.notes,
  });

  final String employeeId;
  final DateTime timestamp;
  final PunchType type;
  final String? location;
  final String? notes;

  @override
  List<Object?> get props => [employeeId, timestamp, type, location, notes];
}

enum PunchType {
  punchIn,
  punchOut,
  breakStart,
  breakEnd;

  String get displayName {
    switch (this) {
      case PunchType.punchIn:
        return 'Punch In';
      case PunchType.punchOut:
        return 'Punch Out';
      case PunchType.breakStart:
        return 'Break Start';
      case PunchType.breakEnd:
        return 'Break End';
    }
  }
}

/// Current attendance status for an employee
class CurrentAttendanceStatus extends Equatable {
  const CurrentAttendanceStatus({
    required this.employeeId,
    required this.date,
    this.todayRecord,
    required this.isPunchedIn,
    required this.isOnBreak,
    this.lastPunchTime,
    this.nextAllowedAction,
  });

  final String employeeId;
  final DateTime date;
  final AttendanceRecord? todayRecord;
  final bool isPunchedIn;
  final bool isOnBreak;
  final DateTime? lastPunchTime;
  final PunchType? nextAllowedAction;

  @override
  List<Object?> get props => [
        employeeId,
        date,
        todayRecord,
        isPunchedIn,
        isOnBreak,
        lastPunchTime,
        nextAllowedAction,
      ];
}