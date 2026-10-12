import 'package:flutter/material.dart';
import '../../domain/employee_models.dart';

class EmployeeFilterDialog extends StatefulWidget {
  final EmployeeFilters? currentFilters;
  final Function(EmployeeFilters) onFiltersApplied;

  const EmployeeFilterDialog({
    super.key,
    this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<EmployeeFilterDialog> createState() => _EmployeeFilterDialogState();
}

class _EmployeeFilterDialogState extends State<EmployeeFilterDialog> {
  late EmployeeFilters _filters;

  // Predefined options for dropdowns
  final List<String> _departments = [
    'Engineering',
    'Human Resources',
    'Marketing',
    'Sales',
    'Finance',
    'Operations',
    'Design',
    'Product',
  ];

  final List<String> _positions = [
    'Software Engineer',
    'Senior Software Engineer',
    'Tech Lead',
    'Engineering Manager',
    'HR Manager',
    'HR Specialist',
    'Marketing Manager',
    'Marketing Specialist',
    'Sales Manager',
    'Account Executive',
    'Finance Manager',
    'Accountant',
    'Operations Manager',
    'Operations Specialist',
    'UX Designer',
    'Product Manager',
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters ?? const EmployeeFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Filter Employees',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Department Filter
            DropdownButtonFormField<String>(
              value: _filters.department?.isNotEmpty == true ? _filters.department : null,
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Departments'),
                ),
                ..._departments.map((dept) => DropdownMenuItem<String>(
                  value: dept,
                  child: Text(dept),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(department: value ?? '');
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Position Filter
            DropdownButtonFormField<String>(
              value: _filters.position?.isNotEmpty == true ? _filters.position : null,
              decoration: const InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Positions'),
                ),
                ..._positions.map((position) => DropdownMenuItem<String>(
                  value: position,
                  child: Text(position),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(position: value ?? '');
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Status Filter
            DropdownButtonFormField<EmployeeStatus>(
              value: _filters.status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<EmployeeStatus>(
                  value: null,
                  child: Text('All Status'),
                ),
                ...EmployeeStatus.values.map((status) => DropdownMenuItem<EmployeeStatus>(
                  value: status,
                  child: Text(_getStatusDisplayName(status)),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _filters = value == null 
                      ? _filters.removeStatus()
                      : _filters.copyWith(status: value);
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Date Range Filters
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectStartDate(),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Hire Date From',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _filters.hireDateFrom != null
                            ? _formatDate(_filters.hireDateFrom!)
                            : 'Select date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectEndDate(),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Hire Date To',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _filters.hireDateTo != null
                            ? _formatDate(_filters.hireDateTo!)
                            : 'Select date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _filters.hireDateFrom ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _filters = _filters.copyWith(hireDateFrom: date);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _filters.hireDateTo ?? DateTime.now(),
      firstDate: _filters.hireDateFrom ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _filters = _filters.copyWith(hireDateTo: date);
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _filters = const EmployeeFilters();
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }

  String _getStatusDisplayName(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.active:
        return 'Active';
      case EmployeeStatus.inactive:
        return 'Inactive';
      case EmployeeStatus.terminated:
        return 'Terminated';
      case EmployeeStatus.pending:
        return 'Pending';
      case EmployeeStatus.away:
        return 'Away';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}