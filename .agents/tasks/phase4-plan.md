# Implementation Plan: Phase 5 - Leave Management System

## Overview
This plan implements the Phase 5 Leave Management system for WorkforceOS, including employee leave overview, application forms, manager approvals, and routing integration. The system follows BLoC patterns and responsive design principles established in the existing AttendanceScreen implementation.

## Implementation Plan

- [ ] 1. Create leave domain models in /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/domain/leave_models.dart.
      Define LeaveType/LeaveStatus enums, LeaveBalance model (annual/sick/casual with total/used/remaining), LeaveRequest model with all required fields including dates, status, reviewer info, and overlapping colleagues.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/domain/leave_models.dart
      Verify: `flutter analyze lib/features/leaves/domain/leave_models.dart` — models compile without errors and include proper Equatable implementation.

- [ ] 2. Create LeaveRepository with mock data in /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/data/leave_repository.dart.
      Implement all required methods: getLeaveBalance, getLeaveRequests, submitLeaveRequest, getPendingApprovals, approveLeave, rejectLeave. Include realistic mock data with proper balance calculations and date ranges.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/data/leave_repository.dart  
      Verify: `flutter analyze lib/features/leaves/data/leave_repository.dart` — repository compiles and methods return expected data structures.

- [ ] 3. Create LeaveBloc for state management in /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/blocs/leave_bloc.dart.
      Follow AttendanceBloc pattern exactly: LeaveEvent base class, LeaveLoadRequested event, LeaveState with status enum/balance/requests/error fields, proper Equatable implementation, async repository integration.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/blocs/leave_bloc.dart
      Verify: `flutter analyze lib/features/leaves/presentation/blocs/leave_bloc.dart` — BLoC compiles and follows same patterns as AttendanceBloc.

- [ ] 4. Create LeaveOverviewScreen with responsive UI in /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/screens/leave_overview_screen.dart.  
      BlocProvider setup like AttendanceScreen, balance cards using AppColors, responsive history table/list, apply leave button/FAB. Follow mobile <600px, tablet 600-1200px, desktop >1200px breakpoints.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/screens/leave_overview_screen.dart
      Verify: `flutter analyze lib/features/leaves/presentation/screens/leave_overview_screen.dart` — screen compiles and matches AttendanceScreen responsive patterns.

- [ ] 5. Create ApplyLeaveScreen with form validation in /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/screens/apply_leave_screen.dart.
      Leave type dropdown, date pickers, reason field, form validation (end >= start, calculate days, check balance), submit with loading states, LeaveBloc integration.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/screens/apply_leave_screen.dart
      Verify: `flutter analyze lib/features/leaves/presentation/screens/apply_leave_screen.dart` — form compiles and validation logic is implemented correctly.

- [ ] 6. Create LeaveApprovalsBloc and LeaveApprovalsScreen in /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/blocs/leave_approvals_bloc.dart and screens/leave_approvals_screen.dart.
      Manager-only BLoC for pending approvals, responsive screen with approve/reject actions, role-based access control, confirmation dialogs.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/blocs/leave_approvals_bloc.dart, /Users/squad-mac/Desktop/Flutter/workforces/lib/features/leaves/presentation/screens/leave_approvals_screen.dart
      Verify: `flutter analyze lib/features/leaves/presentation/` — all components compile and role-based access is implemented.

- [ ] 7. Update app router with leave routes in /Users/squad-mac/Desktop/Flutter/workforces/lib/core/router/app_router.dart.
      Replace LeavesScreen placeholder with LeaveOverviewScreen in leaves branch, add sub-routes /leaves/apply and /leaves/approvals, add BlocProvider setup for both BLoCs, maintain StatefulShellRoute.indexedStack branch index stability.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/core/router/app_router.dart
      Verify: `flutter analyze lib/core/router/app_router.dart` — router compiles and leave routes are properly configured without breaking existing navigation.

- [ ] 8. Update dashboard navigation in employee and manager dashboard views.
      Change employee_dashboard_view.dart 'Apply Leave' button to `context.go('/leaves/apply')`, change manager_dashboard_view.dart 'View All' button in Pending Approvals to `context.go('/leaves/approvals')`.
      Files: /Users/squad-mac/Desktop/Flutter/workforces/lib/features/dashboard/presentation/screens/widgets/employee_dashboard_view.dart, /Users/squad-mac/Desktop/Flutter/workforces/lib/features/dashboard/presentation/screens/widgets/manager_dashboard_view.dart  
      Verify: `flutter analyze lib/features/dashboard/presentation/screens/widgets/` — dashboard files compile and navigation calls are updated correctly.

## Key Implementation Details

### Domain Models
- LeaveType enum: annual, sick, casual, maternity, paternity, unpaid
- LeaveStatus enum: pending, approved, rejected, cancelled  
- LeaveBalance: annual/sick/casual objects with total/used/remaining integers
- LeaveRequest: comprehensive model with dates, employee info, review details, overlapping colleagues

### Repository Pattern
- Follow EmployeeRepository structure with Future<T> return types
- Mock data includes realistic date ranges, employee assignments, approval workflows
- Balance calculations: remaining = total - used, with proper validation

### BLoC Architecture  
- LeaveBloc: employee-focused with balance and history loading
- LeaveApprovalsBloc: manager-focused with pending approvals and actions
- Follow AttendanceBloc patterns for events, states, error handling

### UI Components
- Responsive design with mobile/tablet/desktop breakpoints
- AppColors for consistent theming across balance cards and status indicators
- Form validation with real-time day calculation and balance checking
- DataTable for desktop, ListView for mobile following AttendanceScreen patterns

### Routing Integration
- StatefulShellRoute.indexedStack branch maintains index 3 for leaves
- Sub-routes nested within leaves branch without affecting navigation shell
- BlocProvider setup in route builders for proper dependency injection
- Role-based access guards for manager approval screens

## Verification Strategy
Each step includes specific `flutter analyze` commands to verify compilation. Final verification ensures end-to-end leave workflow: employee applies for leave → manager reviews → approval/rejection → status updates. All components must integrate seamlessly with existing navigation and state management patterns.