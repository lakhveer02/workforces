import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/domain/auth_state.dart';
import '../../domain/dashboard_models.dart';
import '../../data/dashboard_repository.dart';
import '../../../../shared/models/user_role.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

class AttendancePunchRequested extends DashboardEvent {
  const AttendancePunchRequested();
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    required this.userRole,
    required this.data,
  });

  final UserRole userRole;
  final DashboardData data;

  @override
  List<Object?> get props => [userRole, data];
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class DashboardAttendanceUpdated extends DashboardLoaded {
  const DashboardAttendanceUpdated({
    required super.userRole,
    required super.data,
    required this.attendanceStatus,
  });

  final AttendanceStatus attendanceStatus;

  @override
  List<Object?> get props => [...super.props, attendanceStatus];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required DashboardRepository dashboardRepository,
    required AuthBloc authBloc,
  }) : _dashboardRepository = dashboardRepository,
       _authBloc = authBloc,
       super(DashboardInitial()) {
    
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
    on<DashboardRefreshRequested>(_onDashboardRefreshRequested);
    on<AttendancePunchRequested>(_onAttendancePunchRequested);
  }

  final DashboardRepository _dashboardRepository;
  final AuthBloc _authBloc;

  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());
      
      final authState = _authBloc.state;
      if (!authState.isAuthenticated || authState.user == null) {
        emit(const DashboardError('User not authenticated'));
        return;
      }

      final user = authState.user!;
      final data = await _loadDashboardData(user.id, user.role);
      
      emit(DashboardLoaded(
        userRole: user.role,
        data: data,
      ));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onDashboardRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final authState = _authBloc.state;
      if (!authState.isAuthenticated || authState.user == null) {
        return;
      }

      final user = authState.user!;
      final data = await _loadDashboardData(user.id, user.role);
      
      emit(DashboardLoaded(
        userRole: user.role,
        data: data,
      ));
    } catch (e) {
      emit(DashboardError('Failed to refresh dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onAttendancePunchRequested(
    AttendancePunchRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! DashboardLoaded) return;

      // Simulate attendance punch
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, toggle the punch status
      final currentData = currentState.data;
      if (currentData is EmployeeDashboardData) {
        final currentStatus = currentData.attendanceStatus;
        final newStatus = AttendanceStatus(
          isPunchedIn: !currentStatus.isPunchedIn,
          punchInTime: currentStatus.isPunchedIn ? null : DateTime.now(),
          punchOutTime: currentStatus.isPunchedIn ? DateTime.now() : null,
          workingHours: currentStatus.isPunchedIn 
              ? Duration(hours: DateTime.now().difference(currentStatus.punchInTime!).inHours)
              : Duration.zero,
          expectedHours: const Duration(hours: 8),
          status: currentStatus.isPunchedIn 
              ? AttendanceStatusType.absent 
              : AttendanceStatusType.present,
        );

        final updatedData = EmployeeDashboardData(
          attendanceStatus: newStatus,
          leaveBalance: currentData.leaveBalance,
          upcomingHolidays: currentData.upcomingHolidays,
          todaySchedule: currentData.todaySchedule,
          personalStats: currentData.personalStats,
          recentActivities: currentData.recentActivities,
          quickActions: currentData.quickActions,
        );

        emit(DashboardAttendanceUpdated(
          userRole: currentState.userRole,
          data: updatedData,
          attendanceStatus: newStatus,
        ));
      }
    } catch (e) {
      emit(DashboardError('Failed to update attendance: ${e.toString()}'));
    }
  }

  Future<DashboardData> _loadDashboardData(String userId, UserRole role) async {
    switch (role) {
      case UserRole.employee:
        return await _dashboardRepository.getEmployeeDashboard(userId);
      case UserRole.manager:
        return await _dashboardRepository.getManagerDashboard(userId);
      case UserRole.hr:
      case UserRole.admin:
        return await _dashboardRepository.getAdminDashboard(userId);
    }
  }
}