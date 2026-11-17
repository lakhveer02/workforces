import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(user),
                  const SizedBox(height: 28),
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
                                  color: context.colors.danger,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Failed to load dashboard',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dashboardState.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: context.colors.textSecondary,
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
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF312E81), Color(0xFF4F46E5), Color(0xFF6366F1)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.fullName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getRoleDescription(user.role),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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