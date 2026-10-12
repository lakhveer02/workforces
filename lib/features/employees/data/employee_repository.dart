import '../domain/employee_models.dart';
import '../../../shared/models/user_role.dart';

/// Mock repository for employee CRUD operations
class EmployeeRepository {
  static final List<Employee> _employees = _generateMockEmployees();

  /// Get paginated list of employees with optional filters
  Future<EmployeeListResult> getEmployees({
    int page = 1,
    int pageSize = 20,
    EmployeeFilters? filters,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    var filteredEmployees = _employees;

    // Apply filters
    if (filters != null) {
      if (filters.search != null && filters.search!.isNotEmpty) {
        final searchLower = filters.search!.toLowerCase();
        filteredEmployees = filteredEmployees.where((emp) =>
            emp.fullName.toLowerCase().contains(searchLower) ||
            emp.email.toLowerCase().contains(searchLower) ||
            emp.employeeId.toLowerCase().contains(searchLower) ||
            emp.department.toLowerCase().contains(searchLower)).toList();
      }

      if (filters.department != null) {
        filteredEmployees = filteredEmployees
            .where((emp) => emp.department == filters.department)
            .toList();
      }

      if (filters.role != null) {
        filteredEmployees = filteredEmployees
            .where((emp) => emp.role == filters.role)
            .toList();
      }

      if (filters.status != null) {
        filteredEmployees = filteredEmployees
            .where((emp) => emp.status == filters.status)
            .toList();
      }

      if (filters.managerId != null) {
        filteredEmployees = filteredEmployees
            .where((emp) => emp.managerId == filters.managerId)
            .toList();
      }
    }

    // Sort by name for consistent ordering
    filteredEmployees.sort((a, b) => a.fullName.compareTo(b.fullName));

    final totalCount = filteredEmployees.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);

    final pageEmployees = filteredEmployees.sublist(startIndex, endIndex);
    final hasNextPage = endIndex < totalCount;

    return EmployeeListResult(
      employees: pageEmployees,
      totalCount: totalCount,
      page: page,
      pageSize: pageSize,
      hasNextPage: hasNextPage,
    );
  }

  /// Get employee by ID
  Future<Employee?> getEmployeeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      return _employees.firstWhere((emp) => emp.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get employee by employee ID (EMP001, etc.)
  Future<Employee?> getEmployeeByEmployeeId(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      return _employees.firstWhere((emp) => emp.employeeId == employeeId);
    } catch (e) {
      return null;
    }
  }

  /// Create new employee
  Future<Employee> createEmployee(Employee employee) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Validate unique constraints
    if (_employees.any((emp) => emp.email == employee.email)) {
      throw Exception('Employee with this email already exists');
    }
    
    if (_employees.any((emp) => emp.employeeId == employee.employeeId)) {
      throw Exception('Employee ID already exists');
    }

    final newEmployee = employee.copyWith(
      id: 'emp_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _employees.add(newEmployee);
    return newEmployee;
  }

  /// Update existing employee
  Future<Employee> updateEmployee(Employee employee) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final index = _employees.indexWhere((emp) => emp.id == employee.id);
    if (index == -1) {
      throw Exception('Employee not found');
    }

    // Validate unique constraints (excluding current employee)
    if (_employees.any((emp) => 
        emp.id != employee.id && emp.email == employee.email)) {
      throw Exception('Another employee with this email already exists');
    }

    if (_employees.any((emp) => 
        emp.id != employee.id && emp.employeeId == employee.employeeId)) {
      throw Exception('Another employee with this ID already exists');
    }

    final updatedEmployee = employee.copyWith(updatedAt: DateTime.now());
    _employees[index] = updatedEmployee;
    
    return updatedEmployee;
  }

  /// Delete employee (soft delete - mark as inactive)
  Future<void> deleteEmployee(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _employees.indexWhere((emp) => emp.id == id);
    if (index == -1) {
      throw Exception('Employee not found');
    }

    _employees[index] = _employees[index].copyWith(
      isActive: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Get all departments
  Future<List<String>> getDepartments() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final departments = _employees
        .map((emp) => emp.department)
        .toSet()
        .toList();
    departments.sort();
    
    return departments;
  }

  /// Get employees by department
  Future<List<Employee>> getEmployeesByDepartment(String department) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _employees
        .where((emp) => emp.department == department && emp.isActive)
        .toList();
  }

  /// Get employees by manager ID
  Future<List<Employee>> getEmployeesByManager(String managerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _employees
        .where((emp) => emp.managerId == managerId && emp.isActive)
        .toList();
  }

  /// Generate next employee ID
  Future<String> generateNextEmployeeId() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final existingIds = _employees
        .map((emp) => emp.employeeId)
        .where((id) => id.startsWith('EMP'))
        .map((id) => int.tryParse(id.substring(3)))
        .where((num) => num != null)
        .cast<int>()
        .toList();
    
    if (existingIds.isEmpty) return 'EMP001';
    
    final maxId = existingIds.reduce((a, b) => a > b ? a : b);
    return 'EMP${(maxId + 1).toString().padLeft(3, '0')}';
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getEmployeeStats() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final activeEmployees = _employees.where((emp) => emp.isActive).toList();
    
    return {
      'totalEmployees': activeEmployees.length,
      'newThisMonth': activeEmployees.where((emp) => 
          emp.joinDate.isAfter(DateTime.now().subtract(const Duration(days: 30)))).length,
      'byDepartment': _groupByDepartment(activeEmployees),
      'byRole': _groupByRole(activeEmployees),
      'averageTenure': _calculateAverageTenure(activeEmployees),
    };
  }

  Map<String, int> _groupByDepartment(List<Employee> employees) {
    final groups = <String, int>{};
    for (final emp in employees) {
      groups[emp.department] = (groups[emp.department] ?? 0) + 1;
    }
    return groups;
  }

  Map<String, int> _groupByRole(List<Employee> employees) {
    final groups = <String, int>{};
    for (final emp in employees) {
      groups[emp.role.displayName] = (groups[emp.role.displayName] ?? 0) + 1;
    }
    return groups;
  }

  double _calculateAverageTenure(List<Employee> employees) {
    if (employees.isEmpty) return 0.0;
    
    final totalDays = employees
        .map((emp) => DateTime.now().difference(emp.joinDate).inDays)
        .reduce((a, b) => a + b);
    
    return totalDays / employees.length / 365; // Return in years
  }

  /// Generate realistic mock employee data
  static List<Employee> _generateMockEmployees() {
    final now = DateTime.now();
    final employees = <Employee>[];

    // Departments and their typical roles
    final departments = {
      'Engineering': ['Software Engineer', 'Senior Engineer', 'Tech Lead', 'Engineering Manager'],
      'Design': ['UI Designer', 'UX Designer', 'Design Lead', 'Creative Director'],
      'Product': ['Product Manager', 'Senior PM', 'Product Director'],
      'Marketing': ['Marketing Manager', 'Content Writer', 'SEO Specialist', 'Marketing Director'],
      'Sales': ['Sales Executive', 'Account Manager', 'Sales Manager', 'VP Sales'],
      'Human Resources': ['HR Executive', 'HR Manager', 'Recruiter', 'HR Director'],
      'Finance': ['Accountant', 'Finance Manager', 'Financial Analyst', 'CFO'],
      'Operations': ['Operations Manager', 'Office Manager', 'Admin Executive'],
    };

    // Sample employee data
    final employeeData = [
      {'name': 'John Smith', 'email': 'john.smith@workforce.com', 'phone': '+91-9876543210'},
      {'name': 'Sarah Johnson', 'email': 'sarah.johnson@workforce.com', 'phone': '+91-9876543211'},
      {'name': 'Mike Chen', 'email': 'mike.chen@workforce.com', 'phone': '+91-9876543212'},
      {'name': 'Emily Davis', 'email': 'emily.davis@workforce.com', 'phone': '+91-9876543213'},
      {'name': 'Alex Thompson', 'email': 'alex.thompson@workforce.com', 'phone': '+91-9876543214'},
      {'name': 'Maria Garcia', 'email': 'maria.garcia@workforce.com', 'phone': '+91-9876543215'},
      {'name': 'David Wilson', 'email': 'david.wilson@workforce.com', 'phone': '+91-9876543216'},
      {'name': 'Lisa Anderson', 'email': 'lisa.anderson@workforce.com', 'phone': '+91-9876543217'},
      {'name': 'Robert Lee', 'email': 'robert.lee@workforce.com', 'phone': '+91-9876543218'},
      {'name': 'Jennifer Taylor', 'email': 'jennifer.taylor@workforce.com', 'phone': '+91-9876543219'},
      {'name': 'James Brown', 'email': 'james.brown@workforce.com', 'phone': '+91-9876543220'},
      {'name': 'Amanda White', 'email': 'amanda.white@workforce.com', 'phone': '+91-9876543221'},
      {'name': 'Christopher Moore', 'email': 'chris.moore@workforce.com', 'phone': '+91-9876543222'},
      {'name': 'Michelle Clark', 'email': 'michelle.clark@workforce.com', 'phone': '+91-9876543223'},
      {'name': 'Daniel Rodriguez', 'email': 'daniel.rodriguez@workforce.com', 'phone': '+91-9876543224'},
      {'name': 'Karen Miller', 'email': 'karen.miller@workforce.com', 'phone': '+91-9876543225'},
      {'name': 'Steven Martinez', 'email': 'steven.martinez@workforce.com', 'phone': '+91-9876543226'},
      {'name': 'Patricia Lewis', 'email': 'patricia.lewis@workforce.com', 'phone': '+91-9876543227'},
      {'name': 'Kevin Walker', 'email': 'kevin.walker@workforce.com', 'phone': '+91-9876543228'},
      {'name': 'Nancy Hall', 'email': 'nancy.hall@workforce.com', 'phone': '+91-9876543229'},
    ];

    int empIndex = 1;
    String? ceoId;

    for (int i = 0; i < employeeData.length; i++) {
      final data = employeeData[i];
      final names = data['name']!.split(' ');
      final firstName = names[0];
      final lastName = names.length > 1 ? names[1] : '';
      
      // Select random department and role
      final deptEntry = departments.entries.elementAt(i % departments.length);
      final department = deptEntry.key;
      final roles = deptEntry.value;
      final designation = roles[i % roles.length];
      
      // Determine user role based on designation
      UserRole userRole = UserRole.employee;
      if (designation.contains('Director') || designation.contains('VP') || designation.contains('CFO')) {
        userRole = UserRole.admin;
      } else if (designation.contains('Manager') || designation.contains('Lead')) {
        userRole = UserRole.manager;
      } else if (department == 'Human Resources') {
        userRole = UserRole.hr;
      }

      // Create employee
      final employee = Employee(
        id: 'emp_${i + 1}',
        employeeId: 'EMP${empIndex.toString().padLeft(3, '0')}',
        firstName: firstName,
        lastName: lastName,
        email: data['email']!,
        phone: data['phone']!,
        role: userRole,
        department: department,
        designation: designation,
        joinDate: now.subtract(Duration(days: 30 + (i * 45))),
        managerId: i > 0 && userRole != UserRole.admin ? (ceoId ?? 'emp_1') : null,
        managerName: i > 0 && userRole != UserRole.admin ? 'John Smith' : null,
        address: '${100 + i}, Sample Street, Mumbai, Maharashtra, 400001',
        emergencyContact: 'Emergency Contact ${i + 1}',
        emergencyPhone: '+91-9876540${i.toString().padLeft(3, '0')}',
        dateOfBirth: DateTime(1985 + (i % 15), 1 + (i % 12), 1 + (i % 28)),
        bloodGroup: ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'][i % 8],
        maritalStatus: i % 3 == 0 ? MaritalStatus.married : MaritalStatus.single,
        salary: 50000.0 + (i * 15000.0),
        bankAccount: '1234567890${i.toString().padLeft(2, '0')}',
        panNumber: 'ABCDE${(1234 + i).toString()}F',
        aadharNumber: '1234${i.toString().padLeft(8, '0')}',
        isActive: i < 18, // Make a few inactive for testing
        lastLoginAt: now.subtract(Duration(hours: i % 72)),
        createdAt: now.subtract(Duration(days: 30 + (i * 45))),
        updatedAt: now.subtract(Duration(days: i % 7)),
      );

      if (i == 0) ceoId = employee.id; // First employee is CEO/Admin
      employees.add(employee);
      empIndex++;
    }

    return employees;
  }
}