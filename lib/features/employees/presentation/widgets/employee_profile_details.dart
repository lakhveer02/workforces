import 'package:flutter/material.dart';
import '../../domain/employee_models.dart';

class EmployeeProfileDetails extends StatelessWidget {
  final Employee employee;

  const EmployeeProfileDetails({
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
          // Personal Information
          _buildSectionCard(
            context,
            'Personal Information',
            Icons.person,
            [
              _buildDetailRow(context, 'Full Name', '${employee.firstName} ${employee.lastName}'),
              _buildDetailRow(context, 'First Name', employee.firstName),
              _buildDetailRow(context, 'Last Name', employee.lastName),
              _buildDetailRow(context, 'Email Address', employee.email),
              if (employee.phone != null)
                _buildDetailRow(context, 'Phone Number', employee.phone ?? ''),
              if (employee.dateOfBirth != null)
                _buildDetailRow(context, 'Date of Birth', _formatDate(employee.dateOfBirth ?? DateTime.now())),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Address Information
          if (employee.address != null)
            _buildSectionCard(
              context,
              'Address Information',
              Icons.location_on,
              [
                _buildDetailRow(context, 'Full Address', employee.address ?? ''),
                // You could break down address into components here
                // _buildDetailRow(context, 'Street', employee.street),
                // _buildDetailRow(context, 'City', employee.city),
                // etc.
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Employment Details
          _buildSectionCard(
            context,
            'Employment Details',
            Icons.work,
            [
              _buildDetailRow(context, 'Employee ID', employee.employeeId),
              _buildDetailRow(context, 'Department', employee.department),
              _buildDetailRow(context, 'Position/Title', employee.position),
              _buildDetailRow(context, 'Direct Manager', employee.managerId ?? 'Not assigned'),
              _buildDetailRow(context, 'Employment Status', employee.status.name.toUpperCase(),
                  valueColor: _getStatusColor(employee.status)),
              _buildDetailRow(context, 'Hire Date', _formatDate(employee.hireDate)),
              _buildDetailRow(context, 'Years of Service', '${_calculateYearsOfService(employee.hireDate)} years'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Compensation Details
          if (employee.salary != null)
            _buildSectionCard(
              context,
              'Compensation',
              Icons.attach_money,
              [
                _buildDetailRow(context, 'Base Salary', '\$${_formatSalary(employee.salary!)} per year'),
                _buildDetailRow(context, 'Monthly Salary', '\$${_formatSalary(employee.salary! / 12)} per month'),
                // You could add more compensation details here
                // _buildDetailRow(context, 'Bonus Eligible', 'Yes'),
                // _buildDetailRow(context, 'Benefits Package', 'Standard'),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Additional Information
          _buildSectionCard(
            context,
            'Additional Information',
            Icons.info,
            [
              _buildDetailRow(context, 'Profile Created', _formatDateTime(DateTime.now())), // This would be actual creation date
              _buildDetailRow(context, 'Last Updated', _formatDateTime(DateTime.now())), // This would be actual update date
              if (employee.profileImage != null)
                _buildDetailRow(context, 'Profile Photo', 'Available')
              else
                _buildDetailRow(context, 'Profile Photo', 'Not set'),
              _buildDetailRow(context, 'Employee Type', 'Full-time'), // This could be an enum
              _buildDetailRow(context, 'Work Location', 'Office'), // This could be part of the model
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Emergency Contact (placeholder - this would be part of expanded model)
          _buildSectionCard(
            context,
            'Emergency Contact',
            Icons.emergency,
            [
              _buildDetailRow(context, 'Contact Name', 'Not provided'),
              _buildDetailRow(context, 'Relationship', 'Not provided'),
              _buildDetailRow(context, 'Phone Number', 'Not provided'),
            ],
          ),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
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

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatSalary(double salary) {
    return salary.toStringAsFixed(2);
  }

  int _calculateYearsOfService(DateTime hireDate) {
    final now = DateTime.now();
    int years = now.year - hireDate.year;
    
    // Adjust if the anniversary hasn't occurred this year
    if (now.month < hireDate.month || 
        (now.month == hireDate.month && now.day < hireDate.day)) {
      years--;
    }
    
    return years;
  }
}