import 'package:flutter/material.dart';
import '../../domain/employee_models.dart';

class EmployeeProfileOverview extends StatelessWidget {
  final Employee employee;

  const EmployeeProfileOverview({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information
          _buildSectionCard(
            context,
            'Contact Information',
            Icons.contact_mail,
            [
              _buildInfoRow(context, 'Email', employee.email, Icons.email),
              if (employee.phone != null)
                _buildInfoRow(context, 'Phone', employee.phone!, Icons.phone),
              if (employee.address != null)
                _buildInfoRow(context, 'Address', employee.address!, Icons.location_on),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Employment Information
          _buildSectionCard(
            context,
            'Employment Information',
            Icons.work,
            [
              _buildInfoRow(context, 'Employee ID', employee.employeeId, Icons.badge),
              _buildInfoRow(context, 'Department', employee.department, Icons.business),
              _buildInfoRow(context, 'Position', employee.position, Icons.assignment_ind),
              _buildInfoRow(context, 'Manager', employee.managerId ?? 'Not assigned', Icons.supervisor_account),
              _buildInfoRow(context, 'Hire Date', _formatDate(employee.hireDate), Icons.calendar_today),
              _buildInfoRow(context, 'Status', employee.status.name.toUpperCase(), Icons.info,
                  valueColor: _getStatusColor(employee.status)),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Salary Information (if available)
          if (employee.salary != null)
            _buildSectionCard(
              context,
              'Compensation',
              Icons.attach_money,
              [
                _buildInfoRow(context, 'Base Salary', '\$${employee.salary!.toStringAsFixed(2)}', Icons.payments),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Quick Stats
          _buildQuickStatsCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context) {
    final now = DateTime.now();
    final yearsOfService = now.difference(employee.hireDate).inDays / 365;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Stats',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Years of Service',
                    '${yearsOfService.toStringAsFixed(1)}',
                    Icons.timeline,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Department',
                    employee.department,
                    Icons.business,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Status',
                    employee.status.name.toUpperCase(),
                    Icons.info,
                    valueColor: _getStatusColor(employee.status),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Employee ID',
                    employee.employeeId,
                    Icons.badge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.active:
        return Colors.green;
      case EmployeeStatus.inactive:
        return Colors.orange;
      case EmployeeStatus.terminated:
        return Colors.red;
      case EmployeeStatus.pending:
        return Colors.blue;
      case EmployeeStatus.away:
        return Colors.yellow.shade700;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}