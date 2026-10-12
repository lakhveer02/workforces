import '../domain/attendance_models.dart';

abstract class AttendanceRepositoryInterface {
  Future<List<AttendanceRecord>> getAttendanceRecords({
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 0,
    int limit = 20,
  });
  
  Future<AttendanceSummary> getAttendanceSummary(String employeeId, int month, int year);
  Future<AttendanceRecord?> getTodayAttendance(String employeeId);
  Future<CurrentAttendanceStatus> getCurrentStatus(String employeeId);
  Future<AttendanceRecord> punchIn(PunchRequest request);
  Future<AttendanceRecord> punchOut(String attendanceId, PunchRequest request);
  Future<bool> canPunchIn(String employeeId);
  Future<bool> canPunchOut(String employeeId);
}

class MockAttendanceRepository implements AttendanceRepositoryInterface {
  // Mock data - simulated attendance records
  final List<AttendanceRecord> _mockRecords = [
    AttendanceRecord(
      id: 'att_001',
      employeeId: 'emp_001',
      date: DateTime.now().subtract(const Duration(days: 0)),
      punchInTime: DateTime.now().subtract(const Duration(hours: 8, minutes: 30)),
      punchOutTime: DateTime.now().subtract(const Duration(minutes: 30)),
      location: 'Office - Main Building',
      createdAt: DateTime.now().subtract(const Duration(days: 0)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    AttendanceRecord(
      id: 'att_002',
      employeeId: 'emp_002',
      date: DateTime.now().subtract(const Duration(days: 0)),
      punchInTime: DateTime.now().subtract(const Duration(hours: 9, minutes: 15)),
      punchOutTime: DateTime.now().subtract(const Duration(minutes: 15)),
      location: 'Remote',
      createdAt: DateTime.now().subtract(const Duration(days: 0)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    AttendanceRecord(
      id: 'att_003',
      employeeId: 'emp_003',
      date: DateTime.now().subtract(const Duration(days: 1)),
      punchInTime: DateTime.now().subtract(const Duration(days: 1, hours: 8, minutes: 45)),
      punchOutTime: DateTime.now().subtract(const Duration(days: 1, minutes: 45)),
      location: 'Office - Main Building',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1, minutes: 45)),
    ),
    AttendanceRecord(
      id: 'att_004',
      employeeId: 'emp_004',
      date: DateTime.now().subtract(const Duration(days: 1)),
      punchInTime: DateTime.now().subtract(const Duration(days: 1, hours: 9, minutes: 30)),
      punchOutTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      location: 'Office - Branch A',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    ),
    AttendanceRecord(
      id: 'att_005',
      employeeId: 'emp_005',
      date: DateTime.now().subtract(const Duration(days: 2)),
      location: 'N/A',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<AttendanceRecord>> getAttendanceRecords({
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 0,
    int limit = 20,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredRecords = List<AttendanceRecord>.from(_mockRecords);

    // Filter by employee ID
    if (employeeId != null) {
      filteredRecords = filteredRecords
          .where((record) => record.employeeId == employeeId)
          .toList();
    }

    // Filter by date range
    if (startDate != null) {
      filteredRecords = filteredRecords
          .where((record) => record.date.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }

    if (endDate != null) {
      filteredRecords = filteredRecords
          .where((record) => record.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    // Sort by date (newest first)
    filteredRecords.sort((a, b) => b.date.compareTo(a.date));

    // Apply pagination
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, filteredRecords.length);
    
    if (startIndex >= filteredRecords.length) {
      return [];
    }

    return filteredRecords.sublist(startIndex, endIndex);
  }

  @override
  Future<AttendanceSummary> getAttendanceSummary(String employeeId, int month, int year) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Calculate summary for the given month
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0);

    final monthRecords = _mockRecords.where((record) => 
      record.employeeId == employeeId &&
      record.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
      record.date.isBefore(endOfMonth.add(const Duration(days: 1)))
    ).toList();

    int presentDays = 0;
    int absentDays = 0;
    int halfDays = 0;
    int lateDays = 0;
    double totalHours = 0.0;
    double overtimeHours = 0.0;

    for (final record in monthRecords) {
      final status = record.status;
      switch (status) {
        case AttendanceStatus.present:
          presentDays++;
          break;
        case AttendanceStatus.halfDay:
          halfDays++;
          break;
        case AttendanceStatus.late:
          lateDays++;
          break;
        case AttendanceStatus.absent:
          absentDays++;
          break;
        case AttendanceStatus.onLeave:
          // Don't count leave days
          break;
      }
      
      final workHours = record.totalWorkingHours;
      totalHours += workHours;
      if (workHours > 8.0) {
        overtimeHours += workHours - 8.0;
      }
    }

    final totalWorkingDays = 22; // Assuming 22 working days per month
    final averageHours = presentDays > 0 ? totalHours / presentDays : 0.0;

    return AttendanceSummary(
      employeeId: employeeId,
      month: month,
      year: year,
      totalWorkingDays: totalWorkingDays,
      presentDays: presentDays,
      absentDays: absentDays,
      halfDays: halfDays,
      lateDays: lateDays,
      totalWorkingHours: totalHours,
      averageWorkingHours: averageHours,
      overtimeHours: overtimeHours,
    );
  }

  @override
  Future<AttendanceRecord?> getTodayAttendance(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final today = DateTime.now();
    final todayRecords = _mockRecords.where((record) =>
      record.employeeId == employeeId &&
      record.date.year == today.year &&
      record.date.month == today.month &&
      record.date.day == today.day
    ).toList();

    return todayRecords.isNotEmpty ? todayRecords.first : null;
  }

  @override
  Future<CurrentAttendanceStatus> getCurrentStatus(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final todayRecord = await getTodayAttendance(employeeId);
    final today = DateTime.now();

    bool isPunchedIn = false;
    bool isOnBreak = false;
    DateTime? lastPunchTime;
    PunchType? nextAllowedAction;

    if (todayRecord != null) {
      isPunchedIn = todayRecord.punchInTime != null && todayRecord.punchOutTime == null;
      isOnBreak = todayRecord.breakStartTime != null && todayRecord.breakEndTime == null;
      
      // Determine last punch time
      if (todayRecord.punchOutTime != null) {
        lastPunchTime = todayRecord.punchOutTime;
      } else if (todayRecord.breakEndTime != null) {
        lastPunchTime = todayRecord.breakEndTime;
      } else if (todayRecord.breakStartTime != null) {
        lastPunchTime = todayRecord.breakStartTime;
      } else if (todayRecord.punchInTime != null) {
        lastPunchTime = todayRecord.punchInTime;
      }
    }

    // Determine next allowed action
    if (todayRecord == null || todayRecord.punchInTime == null) {
      nextAllowedAction = PunchType.punchIn;
    } else if (todayRecord.punchOutTime != null) {
      nextAllowedAction = null; // Already punched out
    } else if (isOnBreak) {
      nextAllowedAction = PunchType.breakEnd;
    } else {
      nextAllowedAction = PunchType.punchOut;
    }

    return CurrentAttendanceStatus(
      employeeId: employeeId,
      date: today,
      todayRecord: todayRecord,
      isPunchedIn: isPunchedIn,
      isOnBreak: isOnBreak,
      lastPunchTime: lastPunchTime,
      nextAllowedAction: nextAllowedAction,
    );
  }

  @override
  Future<AttendanceRecord> punchIn(PunchRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = request.timestamp;
    final newRecord = AttendanceRecord(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: request.employeeId,
      date: now,
      punchInTime: now,
      location: request.location ?? 'Office',
      notes: request.notes,
      createdAt: now,
      updatedAt: now,
    );

    // Add to mock data (in real app, this would be sent to server)
    _mockRecords.insert(0, newRecord);

    return newRecord;
  }

  @override
  Future<AttendanceRecord> punchOut(String attendanceId, PunchRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final recordIndex = _mockRecords.indexWhere((record) => record.id == attendanceId);
    if (recordIndex == -1) {
      throw Exception('Attendance record not found');
    }

    final existingRecord = _mockRecords[recordIndex];
    final now = request.timestamp;
    
    final updatedRecord = existingRecord.copyWith(
      punchOutTime: now,
      notes: request.notes ?? existingRecord.notes,
      updatedAt: now,
    );

    _mockRecords[recordIndex] = updatedRecord;
    return updatedRecord;
  }

  @override
  Future<bool> canPunchIn(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final todayRecord = await getTodayAttendance(employeeId);
    return todayRecord == null || todayRecord.punchInTime == null;
  }

  @override
  Future<bool> canPunchOut(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final todayRecord = await getTodayAttendance(employeeId);
    return todayRecord != null && 
           todayRecord.punchInTime != null && 
           todayRecord.punchOutTime == null;
  }

  // Additional helper methods for realistic mock data
  Future<List<AttendanceRecord>> generateMonthData(String employeeId, int month, int year) async {
    final records = <AttendanceRecord>[];
    final endOfMonth = DateTime(year, month + 1, 0);

    for (int day = 1; day <= endOfMonth.day; day++) {
      final date = DateTime(year, month, day);
      
      // Skip weekends
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        continue;
      }

      // 90% attendance rate simulation
      if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
        records.add(AttendanceRecord(
          id: 'att_${employeeId}_${date.millisecondsSinceEpoch}',
          employeeId: employeeId,
          date: date,
          createdAt: date,
          updatedAt: date,
        ));
        continue;
      }

      final punchIn = DateTime(
        date.year,
        date.month,
        date.day,
        8 + (DateTime.now().millisecondsSinceEpoch % 2), // 8-9 AM
        (DateTime.now().millisecondsSinceEpoch % 60), // Random minutes
      );

      final punchOut = punchIn.add(Duration(
        hours: 8,
        minutes: (DateTime.now().millisecondsSinceEpoch % 60),
      ));

      records.add(AttendanceRecord(
        id: 'att_${employeeId}_${date.millisecondsSinceEpoch}',
        employeeId: employeeId,
        date: date,
        punchInTime: punchIn,
        punchOutTime: punchOut,
        location: 'Office',
        createdAt: date,
        updatedAt: punchOut,
      ));
    }

    return records;
  }
}