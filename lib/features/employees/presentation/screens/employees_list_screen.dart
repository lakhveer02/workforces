import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/employee_bloc.dart';
import '../../data/employee_repository.dart';
import '../../../../shared/widgets/common/app_text_field.dart';
import '../../../../shared/widgets/common/app_card.dart';
import '../../../../shared/widgets/common/app_data_table.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../../../../shared/models/employee/employee.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';

class EmployeesListScreen extends StatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  final _searchController = TextEditingController();
  String? _selectedDepartment;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(
        employeeRepository: employeeRepository,
      )..add(EmployeeLoadRequested()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Employees'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // TODO: Navigate to add employee screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Employee - Coming Soon!')),
                  );
                },
                tooltip: 'Add Employee',
              ),
            ],
          ),
          body: BlocConsumer<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return LoadingOverlay(
                isLoading: state.isLoading,
                child: Responsive.getValue(
                  context,
                  mobile: _buildMobileLayout(context, state),
                  tablet: _buildTabletLayout(context, state),
                  desktop: _buildDesktopLayout(context, state),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, EmployeeState state) {
    return Column(
      children: [
        _buildSearchAndFilters(context, state),
        Expanded(
          child: _buildEmployeeList(context, state),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, EmployeeState state) {
    return Column(
      children: [
        _buildSearchAndFilters(context, state),
        const SizedBox(height: AppTheme.spaceMedium),
        _buildStatsCards(context, state),
        const SizedBox(height: AppTheme.spaceMedium),
        Expanded(
          child: _buildEmployeeDataTable(context, state),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, EmployeeState state) {
    return Row(
      children: [
        // Sidebar with filters and stats
        SizedBox(
          width: 300,
          child: Card(
            margin: const EdgeInsets.all(AppTheme.spaceMedium),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSection(context, state),
                  const SizedBox(height: AppTheme.spaceLarge),
                  _buildFiltersSection(context, state),
                  const SizedBox(height: AppTheme.spaceLarge),
                  _buildQuickStats(context, state),
                ],
              ),
            ),
          ),
        ),
        
        // Main content area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            child: _buildEmployeeDataTable(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, EmployeeState state) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Column(
        children: [
          _buildSearchSection(context, state),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildFiltersSection(context, state),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, EmployeeState state) {
    return AppTextField(
      controller: _searchController,
      hintText: 'Search employees...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<EmployeeBloc>().add(
                  const EmployeeSearchRequested(''),
                );
              },
            )
          : null,
      onChanged: (query) {
        context.read<EmployeeBloc>().add(
          EmployeeSearchRequested(query),
        );
      },
    );
  }

  Widget _buildFiltersSection(BuildContext context, EmployeeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Department',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppTheme.spaceSmall),
        Wrap(
          spacing: AppTheme.spaceSmall,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedDepartment == null,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedDepartment = null);
                  context.read<EmployeeBloc>().add(
                    const EmployeeDepartmentFilterRequested(null),
                  );
                }
              },
            ),
            ...state.departmentNames.map((dept) => FilterChip(
              label: Text(dept),
              selected: _selectedDepartment == dept,
              onSelected: (selected) {
                setState(() => _selectedDepartment = selected ? dept : null);
                context.read<EmployeeBloc>().add(
                  EmployeeDepartmentFilterRequested(selected ? dept : null),
                );
              },
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, EmployeeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMedium),
      child: Row(
        children: [
          Expanded(
            child: AppStatCard(
              title: 'Total Employees',
              value: state.employees.length.toString(),
              icon: Icons.people,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: AppStatCard(
              title: 'Active',
              value: state.employeeCountByStatus[EmployeeStatus.active]?.toString() ?? '0',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: AppStatCard(
              title: 'Departments',
              value: state.departments.length.toString(),
              icon: Icons.business,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, EmployeeState state) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spaceMedium),
        ...state.employeeCountByDepartment.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spaceSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceSmall,
                  vertical: AppTheme.spaceXSmall,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  entry.value.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildEmployeeList(BuildContext context, EmployeeState state) {
    if (state.displayEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spaceMedium),
            Text(
              'No employees found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSmall),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      itemCount: state.displayEmployees.length,
      itemBuilder: (context, index) {
        final employee = state.displayEmployees[index];
        return _buildEmployeeCard(context, employee);
      },
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    final theme = Theme.of(context);
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMedium),
      onTap: () {
        // TODO: Navigate to employee detail screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View ${employee.fullName} - Coming Soon!')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  employee.user.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      employee.designation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      employee.department,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: employee.statusBadgeText,
                color: _getStatusColor(employee.status),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppTheme.spaceXSmall),
              Expanded(
                child: Text(
                  employee.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                employee.employeeId,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDataTable(BuildContext context, EmployeeState state) {
    if (state.displayEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spaceMedium),
            Text(
              'No employees found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return AppDataTable(
      columns: [
        const AppDataColumn(label: Text('Employee')),
        const AppDataColumn(label: Text('Department')),
        const AppDataColumn(label: Text('Status')),
        const AppDataColumn(label: Text('Join Date')),
        const AppDataColumn(label: Text('Actions')),
      ],
      rows: state.displayEmployees.map((employee) => AppDataRow(
        cells: [
          AppDataCell(
            child: AvatarCell(
              name: employee.fullName,
              subtitle: employee.designation,
            ),
          ),
          AppDataCell(child: Text(employee.department)),
          AppDataCell(
            child: StatusChip(
              label: employee.statusBadgeText,
              color: _getStatusColor(employee.status),
              size: StatusChipSize.small,
            ),
          ),
          AppDataCell(
            child: Text(_formatDate(employee.joinDate)),
          ),
          AppDataCell(
            child: ActionCell(
              actions: [
                ActionItem(
                  icon: Icons.visibility,
                  onPressed: () {
                    // TODO: Navigate to employee detail
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('View ${employee.fullName} - Coming Soon!')),
                    );
                  },
                  tooltip: 'View Details',
                ),
                ActionItem(
                  icon: Icons.edit,
                  onPressed: () {
                    // TODO: Navigate to edit employee
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit ${employee.fullName} - Coming Soon!')),
                    );
                  },
                  tooltip: 'Edit Employee',
                ),
              ],
            ),
          ),
        ],
      )).toList(),
    );
  }

  Color _getStatusColor(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.active:
        return Colors.green;
      case EmployeeStatus.inactive:
        return Colors.grey;
      case EmployeeStatus.onLeave:
        return Colors.orange;
      case EmployeeStatus.terminated:
        return Colors.red;
      case EmployeeStatus.probation:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}