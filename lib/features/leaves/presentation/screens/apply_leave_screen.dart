import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/common/app_card.dart';
import '../../domain/leave_models.dart';
import '../../data/leave_repository.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final MockLeaveRepository _repository = MockLeaveRepository();
  
  // Form controllers
  final _reasonController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _coveringEmployeeController = TextEditingController();
  
  // Form state
  LeaveType _selectedLeaveType = LeaveType.annual;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;
  List<LeaveBalance> _leaveBalances = [];
  
  // Validation state
  List<String> _validationErrors = [];
  bool _hasInsufficientBalance = false;

  @override
  void initState() {
    super.initState();
    _loadLeaveBalances();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _emergencyContactController.dispose();
    _coveringEmployeeController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaveBalances() async {
    try {
      final balances = await _repository.getLeaveBalances('emp_001');
      setState(() {
        _leaveBalances = balances;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load leave balances: $e')),
        );
      }
    }
  }

  double get _totalDays {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1.0;
  }

  LeaveBalance? get _selectedLeaveBalance {
    return _leaveBalances.firstWhere(
      (balance) => balance.leaveType == _selectedLeaveType,
      orElse: () => const LeaveBalance(
        leaveType: LeaveType.annual,
        totalEntitled: 0,
        used: 0,
        pending: 0,
        year: 0,
      ),
    );
  }

  void _validateForm() {
    final errors = <String>[];
    
    // Basic validations
    if (_startDate == null) {
      errors.add('Please select a start date');
    }
    
    if (_endDate == null) {
      errors.add('Please select an end date');
    }
    
    if (_startDate != null && _endDate != null) {
      if (_startDate!.isAfter(_endDate!)) {
        errors.add('Start date cannot be after end date');
      }
      
      if (_startDate!.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        errors.add('Cannot apply for past dates');
      }
      
      // Check weekend/holiday logic if needed
      if (_totalDays > 365) {
        errors.add('Leave duration cannot exceed 365 days');
      }
    }
    
    if (_reasonController.text.trim().isEmpty) {
      errors.add('Please provide a reason for leave');
    }
    
    // Balance check
    final balance = _selectedLeaveBalance;
    final hasInsufficientBalance = balance != null && balance.available < _totalDays;
    
    if (hasInsufficientBalance) {
      errors.add('Insufficient ${_selectedLeaveType.displayName.toLowerCase()} balance. Available: ${balance!.available} days');
    }
    
    setState(() {
      _validationErrors = errors;
      _hasInsufficientBalance = hasInsufficientBalance;
    });
  }

  Future<void> _submitLeaveApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    _validateForm();
    
    if (_validationErrors.isNotEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = LeaveApplicationRequest(
        employeeId: 'emp_001',
        employeeName: 'Current User',
        leaveType: _selectedLeaveType,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim().isNotEmpty 
            ? _emergencyContactController.text.trim() 
            : null,
        coveringEmployee: _coveringEmployeeController.text.trim().isNotEmpty 
            ? _coveringEmployeeController.text.trim() 
            : null,
      );

      await _repository.applyLeave(request);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave application submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit leave application: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _startDate = date;
        // Reset end date if it's before the new start date
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = null;
        }
      });
      _validateForm();
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _endDate ?? _startDate ?? DateTime.now().add(const Duration(days: 1));
    final firstDate = _startDate ?? DateTime.now();
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _endDate = date;
      });
      _validateForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Leave'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type Selection
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leave Type',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      DropdownButtonFormField<LeaveType>(
                        value: _selectedLeaveType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: LeaveType.values.map((type) {
                          final balance = _leaveBalances.firstWhere(
                            (b) => b.leaveType == type,
                            orElse: () => const LeaveBalance(
                              leaveType: LeaveType.annual,
                              totalEntitled: 0,
                              used: 0,
                              pending: 0,
                              year: 0,
                            ),
                          );
                          
                          return DropdownMenuItem(
                            value: type,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    type.displayName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${balance.available.toStringAsFixed(1)} available',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: balance.isLowBalance ? Colors.orange : theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLeaveType = value;
                            });
                            _validateForm();
                          }
                        },
                      ),
                      
                      // Balance display
                      if (_selectedLeaveBalance != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Available: ${_selectedLeaveBalance!.available} days (${_selectedLeaveBalance!.used} used of ${_selectedLeaveBalance!.totalEntitled})',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Date Selection
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leave Duration',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _selectStartDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _startDate != null 
                                      ? DateFormat('MMM d, yyyy').format(_startDate!)
                                      : 'Select date',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: _selectEndDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _endDate != null 
                                      ? DateFormat('MMM d, yyyy').format(_endDate!)
                                      : 'Select date',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Duration display
                      if (_startDate != null && _endDate != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _hasInsufficientBalance 
                                ? theme.colorScheme.errorContainer 
                                : theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _hasInsufficientBalance ? Icons.warning : Icons.event,
                                size: 16,
                                color: _hasInsufficientBalance 
                                    ? theme.colorScheme.onErrorContainer 
                                    : theme.colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Total: ${_totalDays.toStringAsFixed(0)} day${_totalDays != 1 ? 's' : ''}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _hasInsufficientBalance 
                                      ? theme.colorScheme.onErrorContainer 
                                      : theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Reason
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason for Leave',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          hintText: 'Please provide a detailed reason for your leave...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Please provide a reason';
                          }
                          return null;
                        },
                        onChanged: (_) => _validateForm(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Additional Information
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information (Optional)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _emergencyContactController,
                        decoration: const InputDecoration(
                          labelText: 'Emergency Contact',
                          hintText: 'Phone number for emergencies',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _coveringEmployeeController,
                        decoration: const InputDecoration(
                          labelText: 'Covering Employee',
                          hintText: 'Who will handle your responsibilities?',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Validation Errors
              if (_validationErrors.isNotEmpty) ...[
                const SizedBox(height: 16),
                AppCard(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.onErrorContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Please fix the following issues:',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ..._validationErrors.map((error) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  error,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _validationErrors.isEmpty && !_isSubmitting 
                      ? _submitLeaveApplication 
                      : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Submitting...'),
                          ],
                        )
                      : const Text('Submit Leave Application'),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}