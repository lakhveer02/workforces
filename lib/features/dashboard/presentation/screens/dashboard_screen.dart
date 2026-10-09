import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard/app_stat_card.dart';
import '../../../../shared/widgets/dashboard/app_activity_list.dart';
import '../../../../shared/widgets/dashboard/app_section_header.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/user_role.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../blocs/dashboard_bloc.dart';
import 'widgets/employee_dashboard_view.dart';
import 'widgets/manager_dashboard_view.dart';
import 'widgets/hr_dashboard_view.dart';
import 'widgets/admin_dashboard_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen initializes
    final authState = context.read<AuthBloc>().state;
    if (authState.isAuthenticated) {
      context.read<DashboardBloc>().add(
        const DashboardLoadRequested(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (!authState.isAuthenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = authState.user!;
        
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(
                const DashboardRefreshRequested(),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(user),
                  const SizedBox(height: 24),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, dashboardState) {
                      if (dashboardState is DashboardLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      if (dashboardState is DashboardError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Failed to load dashboard',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dashboardState.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.gray600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<DashboardBloc>().add(
                                      const DashboardRefreshRequested(),
                                    );
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      return _buildRoleDashboard(user.role, dashboardState);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getRoleDescription(user.role),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDashboard(UserRole role, DashboardState state) {
    switch (role) {
      case UserRole.employee:
        return EmployeeDashboardView(state: state);
      case UserRole.manager:
        return ManagerDashboardView(state: state);
      case UserRole.hr:
        return HRDashboardView(state: state);
      case UserRole.admin:
        return AdminDashboardView(state: state);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.employee:
        return 'Ready to make today productive?';
      case UserRole.manager:
        return 'Leading your team to success';
      case UserRole.hr:
        return 'Supporting our workforce';
      case UserRole.admin:
        return 'Managing system operations';
    }
  }
}