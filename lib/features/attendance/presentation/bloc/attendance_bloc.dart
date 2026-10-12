import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/attendance_models.dart';
import '../../data/attendance_repository.dart';

// Events
abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class AttendanceLoadRequested extends AttendanceEvent {
  const AttendanceLoadRequested({required this.employeeId});

  final String employeeId;

  @override
  List<Object?> get props => [employeeId];
}

class AttendanceCurrentStatusRequested extends AttendanceEvent {
  const AttendanceCurrentStatusRequested({required this.employeeId});

  final String employeeId;

  @override
  List<Object?> get props => [employeeId];
}

class AttendancePunchInRequested extends AttendanceEvent {
  const AttendancePunchInRequested({
    required this.employeeId,
    this.location,
    this.notes,
  });

  final String employeeId;
  final String? location;
  final String? notes;

  @override
  List<Object?> get props => [employeeId, location, notes];
}

class AttendancePunchOutRequested extends AttendanceEvent {
  const AttendancePunchOutRequested({
    required this.employeeId,
    this.location,
    this.notes,
  });

  final String employeeId;
  final String? location;
  final String? notes;

  @override
  List<Object?> get props => [employeeId, location, notes];
}

class AttendanceMonthChanged extends AttendanceEvent {
  const AttendanceMonthChanged({
    required this.employeeId,
    required this.month,
    required this.year,
  });

  final String employeeId;
  final int month;
  final int year;

  @override
  List<Object?> get props => [employeeId, month, year];
}

// States
enum AttendanceStateStatus {
  initial,
  loading,
  loaded,
  punching,
  error,
}

class AttendanceState extends Equatable {
  const AttendanceState({
    this.status = AttendanceStateStatus.initial,
    this.records = const [],
    this.summary,
    this.currentStatus,
    this.selectedMonth,
    this.selectedYear,
    this.isPunching = false,
    this.error,
  });

  final AttendanceStateStatus status;
  final List<AttendanceRecord> records;
  final AttendanceSummary? summary;
  final CurrentAttendanceStatus? currentStatus;
  final int? selectedMonth;
  final int? selectedYear;
  final bool isPunching;
  final String? error;

  // Initialize with current month/year if not set
  int get effectiveMonth => selectedMonth ?? DateTime.now().month;
  int get effectiveYear => selectedYear ?? DateTime.now().year;

  AttendanceState copyWith({
    AttendanceStateStatus? status,
    List<AttendanceRecord>? records,
    AttendanceSummary? summary,
    CurrentAttendanceStatus? currentStatus,
    int? selectedMonth,
    int? selectedYear,
    bool? isPunching,
    String? error,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      records: records ?? this.records,
      summary: summary ?? this.summary,
      currentStatus: currentStatus ?? this.currentStatus,
      selectedMonth: selectedMonth ?? this.selectedMonth ?? DateTime.now().month,
      selectedYear: selectedYear ?? this.selectedYear ?? DateTime.now().year,
      isPunching: isPunching ?? this.isPunching,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        records,
        summary,
        currentStatus,
        selectedMonth,
        selectedYear,
        isPunching,
        error,
      ];
}

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepositoryInterface _attendanceRepository;

  AttendanceBloc({
    required AttendanceRepositoryInterface attendanceRepository,
  })  : _attendanceRepository = attendanceRepository,
        super(const AttendanceState()) {
    on<AttendanceLoadRequested>(_onLoadRequested);
    on<AttendanceCurrentStatusRequested>(_onCurrentStatusRequested);
    on<AttendancePunchInRequested>(_onPunchInRequested);
    on<AttendancePunchOutRequested>(_onPunchOutRequested);
    on<AttendanceMonthChanged>(_onMonthChanged);
  }

  Future<void> _onLoadRequested(
    AttendanceLoadRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStateStatus.loading));

    try {
      final records = await _attendanceRepository.getAttendanceRecords(
        employeeId: event.employeeId,
      );

      final summary = await _attendanceRepository.getAttendanceSummary(
        event.employeeId,
        state.effectiveMonth,
        state.effectiveYear,
      );

      final currentStatus = await _attendanceRepository.getCurrentStatus(
        event.employeeId,
      );

      emit(state.copyWith(
        status: AttendanceStateStatus.loaded,
        records: records,
        summary: summary,
        currentStatus: currentStatus,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AttendanceStateStatus.error,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onCurrentStatusRequested(
    AttendanceCurrentStatusRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      final currentStatus = await _attendanceRepository.getCurrentStatus(
        event.employeeId,
      );

      emit(state.copyWith(currentStatus: currentStatus));
    } catch (error) {
      emit(state.copyWith(
        status: AttendanceStateStatus.error,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onPunchInRequested(
    AttendancePunchInRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(
      status: AttendanceStateStatus.punching,
      isPunching: true,
    ));

    try {
      final punchRequest = PunchRequest(
        employeeId: event.employeeId,
        timestamp: DateTime.now(),
        type: PunchType.punchIn,
        location: event.location,
        notes: event.notes,
      );

      await _attendanceRepository.punchIn(punchRequest);

      // Refresh current status and records
      final currentStatus = await _attendanceRepository.getCurrentStatus(
        event.employeeId,
      );

      final records = await _attendanceRepository.getAttendanceRecords(
        employeeId: event.employeeId,
      );

      emit(state.copyWith(
        status: AttendanceStateStatus.loaded,
        isPunching: false,
        currentStatus: currentStatus,
        records: records,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AttendanceStateStatus.error,
        isPunching: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onPunchOutRequested(
    AttendancePunchOutRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(
      status: AttendanceStateStatus.punching,
      isPunching: true,
    ));

    try {
      // Get the attendance record ID from current status
      final currentStatus = state.currentStatus;
      if (currentStatus?.todayRecord?.id == null) {
        throw Exception('No active attendance record found for punch out');
      }

      final punchRequest = PunchRequest(
        employeeId: event.employeeId,
        timestamp: DateTime.now(),
        type: PunchType.punchOut,
        location: event.location,
        notes: event.notes,
      );

      await _attendanceRepository.punchOut(
        currentStatus!.todayRecord!.id,
        punchRequest,
      );

      // Refresh current status and records
      final updatedStatus = await _attendanceRepository.getCurrentStatus(
        event.employeeId,
      );

      final records = await _attendanceRepository.getAttendanceRecords(
        employeeId: event.employeeId,
      );

      emit(state.copyWith(
        status: AttendanceStateStatus.loaded,
        isPunching: false,
        currentStatus: updatedStatus,
        records: records,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AttendanceStateStatus.error,
        isPunching: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onMonthChanged(
    AttendanceMonthChanged event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(
      selectedMonth: event.month,
      selectedYear: event.year,
      status: AttendanceStateStatus.loading,
    ));

    try {
      final summary = await _attendanceRepository.getAttendanceSummary(
        event.employeeId,
        event.month,
        event.year,
      );

      final records = await _attendanceRepository.getAttendanceRecords(
        employeeId: event.employeeId,
        startDate: DateTime(event.year, event.month, 1),
        endDate: DateTime(event.year, event.month + 1, 0),
      );

      emit(state.copyWith(
        status: AttendanceStateStatus.loaded,
        summary: summary,
        records: records,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AttendanceStateStatus.error,
        error: error.toString(),
      ));
    }
  }
}