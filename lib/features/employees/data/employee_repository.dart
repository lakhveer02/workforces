import '../../../shared/models/employee/employee.dart';
import '../../../shared/models/company/department.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/user_role.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getAllEmployees();
  Future<List<Employee>> getEmployeesByDepartment(String departmentId);
  Future<List<Employee>> getEmployeesByManager(String managerId);
  Future<Employee?> getEmployeeById(String id);
  Future<Employee?> getEmployeeByUserId(String userId);
  Future<List<Employee>> searchEmployees(String query);
  Future<Employee> createEmployee(Employee employee);
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deactivateEmployee(String id);
  Future<List<Department>> getAllDepartments();
}

class MockEmployeeRepository implements EmployeeRepository {
  static const Duration _networkDelay = Duration(milliseconds: 800);

  // Mock departments
  static final List<Department> _departments = [
    Department(
      id: 'dept_001',
      name: 'Engineering',
      description: 'Software development and technology',
      headId: 'emp_003',
      headName: 'Michael Johnson',
      location: 'Building A, Floor 3',
      budget: 2500000.0,
      employeeCount: 25,
    ),
    Department(
      id: 'dept_002',
      name: 'Human Resources',
      description: 'Employee relations and talent management',
      headId: 'emp_002',
      headName: 'Sarah Wilson',
      location: 'Building B, Floor 2',
      budget: 800000.0,
      employeeCount: 8,
    ),
    Department(
      id: 'dept_003',
      name: 'Marketing',
      description: 'Brand management and customer acquisition',
      location: 'Building A, Floor 2',
      budget: 1200000.0,
      employeeCount: 12,
    ),
    Department(
      id: 'dept_004',
      name: 'Sales',
      description: 'Revenue generation and client relations',
      location: 'Building B, Floor 1',
      budget: 1800000.0,
      employeeCount: 15,
    ),
    Department(
      id: 'dept_005',
      name: 'Finance',
      description: 'Financial planning and accounting',
      location: 'Building A, Floor 1',
      budget: 600000.0,
      employeeCount: 6,
    ),
  ];

  // Mock employees with realistic data
  static final List<Employee> _employees = [
    Employee(
      id: 'emp_001',
      employeeId: 'WOS001',
      user: User(
        id: '1',
        email: 'admin@workforceos.com',
        firstName: 'John',
        lastName: 'Admin',
        role: UserRole.admin,
        phone: '+1-555-0101',
        department: 'Information Technology',
        designation: 'System Administrator',
        joinDate: DateTime(2020, 1, 15),
      ),
      department: 'Information Technology',
      designation: 'System Administrator',
      joinDate: DateTime(2020, 1, 15),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      workLocation: 'Building A, Floor 4',
      workPhone: '+1-555-0101-ext-100',
      salary: 95000.0,
      emergencyContact: EmergencyContact(
        name: 'Jane Admin',
        relationship: 'Spouse',
        phone: '+1-555-0102',
        email: 'jane.admin@email.com',
      ),
      address: Address(
        street: '123 Admin Street',
        city: 'Tech City',
        state: 'CA',
        country: 'USA',
        zipCode: '90210',
      ),
      dateOfBirth: DateTime(1985, 3, 20),
    ),
    Employee(
      id: 'emp_002',
      employeeId: 'WOS002',
      user: User(
        id: '2',
        email: 'hr@workforceos.com',
        firstName: 'Sarah',
        lastName: 'Wilson',
        role: UserRole.hr,
        phone: '+1-555-0102',
        department: 'Human Resources',
        designation: 'HR Manager',
        joinDate: DateTime(2020, 3, 22),
      ),
      department: 'Human Resources',
      designation: 'HR Manager',
      joinDate: DateTime(2020, 3, 22),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      workLocation: 'Building B, Floor 2',
      workPhone: '+1-555-0102-ext-200',
      salary: 85000.0,
      emergencyContact: EmergencyContact(
        name: 'Robert Wilson',
        relationship: 'Brother',
        phone: '+1-555-0103',
      ),
      address: Address(
        street: '456 HR Avenue',
        city: 'Business Park',
        state: 'CA',
        country: 'USA',
        zipCode: '90211',
      ),
      dateOfBirth: DateTime(1988, 7, 14),
    ),
    Employee(
      id: 'emp_003',
      employeeId: 'WOS003',
      user: User(
        id: '3',
        email: 'manager@workforceos.com',
        firstName: 'Michael',
        lastName: 'Johnson',
        role: UserRole.manager,
        phone: '+1-555-0103',
        department: 'Engineering',
        designation: 'Engineering Manager',
        joinDate: DateTime(2021, 1, 10),
      ),
      department: 'Engineering',
      designation: 'Engineering Manager',
      joinDate: DateTime(2021, 1, 10),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      managerId: 'emp_001',
      managerName: 'John Admin',
      workLocation: 'Building A, Floor 3',
      workPhone: '+1-555-0103-ext-300',
      salary: 110000.0,
      emergencyContact: EmergencyContact(
        name: 'Lisa Johnson',
        relationship: 'Spouse',
        phone: '+1-555-0104',
        email: 'lisa.johnson@email.com',
      ),
      address: Address(
        street: '789 Engineering Drive',
        city: 'Innovation Hub',
        state: 'CA',
        country: 'USA',
        zipCode: '90212',
      ),
      dateOfBirth: DateTime(1987, 11, 5),
    ),
    Employee(
      id: 'emp_004',
      employeeId: 'WOS004',
      user: User(
        id: '4',
        email: 'employee@workforceos.com',
        firstName: 'Emily',
        lastName: 'Davis',
        role: UserRole.employee,
        phone: '+1-555-0104',
        department: 'Engineering',
        designation: 'Software Developer',
        managerId: '3',
        joinDate: DateTime(2022, 6, 15),
      ),
      department: 'Engineering',
      designation: 'Software Developer',
      joinDate: DateTime(2022, 6, 15),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      managerId: 'emp_003',
      managerName: 'Michael Johnson',
      workLocation: 'Building A, Floor 3',
      workPhone: '+1-555-0104-ext-301',
      salary: 75000.0,
      emergencyContact: EmergencyContact(
        name: 'Mark Davis',
        relationship: 'Father',
        phone: '+1-555-0105',
      ),
      address: Address(
        street: '321 Developer Lane',
        city: 'Code Valley',
        state: 'CA',
        country: 'USA',
        zipCode: '90213',
      ),
      dateOfBirth: DateTime(1995, 4, 18),
    ),
    Employee(
      id: 'emp_005',
      employeeId: 'WOS005',
      user: User(
        id: '5',
        email: 'alice.cooper@workforceos.com',
        firstName: 'Alice',
        lastName: 'Cooper',
        role: UserRole.employee,
        phone: '+1-555-0105',
        department: 'Engineering',
        designation: 'Senior Software Engineer',
        joinDate: DateTime(2019, 8, 12),
      ),
      department: 'Engineering',
      designation: 'Senior Software Engineer',
      joinDate: DateTime(2019, 8, 12),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      managerId: 'emp_003',
      managerName: 'Michael Johnson',
      workLocation: 'Building A, Floor 3',
      workPhone: '+1-555-0105-ext-302',
      salary: 95000.0,
      emergencyContact: EmergencyContact(
        name: 'Bob Cooper',
        relationship: 'Spouse',
        phone: '+1-555-0106',
        email: 'bob.cooper@email.com',
      ),
      address: Address(
        street: '654 Senior Street',
        city: 'Expert City',
        state: 'CA',
        country: 'USA',
        zipCode: '90214',
      ),
      dateOfBirth: DateTime(1990, 12, 8),
    ),
    Employee(
      id: 'emp_006',
      employeeId: 'WOS006',
      user: User(
        id: '6',
        email: 'david.brown@workforceos.com',
        firstName: 'David',
        lastName: 'Brown',
        role: UserRole.employee,
        phone: '+1-555-0106',
        department: 'Marketing',
        designation: 'Marketing Specialist',
        joinDate: DateTime(2023, 1, 20),
      ),
      department: 'Marketing',
      designation: 'Marketing Specialist',
      joinDate: DateTime(2023, 1, 20),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      workLocation: 'Building A, Floor 2',
      workPhone: '+1-555-0106-ext-201',
      salary: 65000.0,
      emergencyContact: EmergencyContact(
        name: 'Susan Brown',
        relationship: 'Mother',
        phone: '+1-555-0107',
      ),
      dateOfBirth: DateTime(1993, 9, 25),
    ),
    Employee(
      id: 'emp_007',
      employeeId: 'WOS007',
      user: User(
        id: '7',
        email: 'jennifer.garcia@workforceos.com',
        firstName: 'Jennifer',
        lastName: 'Garcia',
        role: UserRole.manager,
        phone: '+1-555-0107',
        department: 'Sales',
        designation: 'Sales Manager',
        joinDate: DateTime(2021, 5, 3),
      ),
      department: 'Sales',
      designation: 'Sales Manager',
      joinDate: DateTime(2021, 5, 3),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      managerId: 'emp_001',
      managerName: 'John Admin',
      workLocation: 'Building B, Floor 1',
      workPhone: '+1-555-0107-ext-101',
      salary: 98000.0,
      emergencyContact: EmergencyContact(
        name: 'Carlos Garcia',
        relationship: 'Spouse',
        phone: '+1-555-0108',
        email: 'carlos.garcia@email.com',
      ),
      dateOfBirth: DateTime(1986, 2, 14),
    ),
    Employee(
      id: 'emp_008',
      employeeId: 'WOS008',
      user: User(
        id: '8',
        email: 'robert.taylor@workforceos.com',
        firstName: 'Robert',
        lastName: 'Taylor',
        role: UserRole.employee,
        phone: '+1-555-0108',
        department: 'Finance',
        designation: 'Financial Analyst',
        joinDate: DateTime(2022, 11, 8),
      ),
      department: 'Finance',
      designation: 'Financial Analyst',
      joinDate: DateTime(2022, 11, 8),
      employmentType: EmploymentType.fullTime,
      status: EmployeeStatus.active,
      workLocation: 'Building A, Floor 1',
      workPhone: '+1-555-0108-ext-111',
      salary: 70000.0,
      emergencyContact: EmergencyContact(
        name: 'Mary Taylor',
        relationship: 'Sister',
        phone: '+1-555-0109',
      ),
      dateOfBirth: DateTime(1992, 6, 30),
    ),
  ];

  @override
  Future<List<Employee>> getAllEmployees() async {
    await Future.delayed(_networkDelay);
    return List.from(_employees);
  }

  @override
  Future<List<Employee>> getEmployeesByDepartment(String departmentName) async {
    await Future.delayed(_networkDelay);
    return _employees
        .where((emp) => emp.department.toLowerCase() == departmentName.toLowerCase())
        .toList();
  }

  @override
  Future<List<Employee>> getEmployeesByManager(String managerId) async {
    await Future.delayed(_networkDelay);
    return _employees.where((emp) => emp.managerId == managerId).toList();
  }

  @override
  Future<Employee?> getEmployeeById(String id) async {
    await Future.delayed(_networkDelay);
    try {
      return _employees.firstWhere((emp) => emp.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Employee?> getEmployeeByUserId(String userId) async {
    await Future.delayed(_networkDelay);
    try {
      return _employees.firstWhere((emp) => emp.user.id == userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Employee>> searchEmployees(String query) async {
    await Future.delayed(_networkDelay);
    
    if (query.isEmpty) return _employees;
    
    final lowercaseQuery = query.toLowerCase();
    
    return _employees.where((emp) {
      return emp.fullName.toLowerCase().contains(lowercaseQuery) ||
             emp.email.toLowerCase().contains(lowercaseQuery) ||
             emp.employeeId.toLowerCase().contains(lowercaseQuery) ||
             emp.department.toLowerCase().contains(lowercaseQuery) ||
             emp.designation.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<Employee> createEmployee(Employee employee) async {
    await Future.delayed(_networkDelay);
    
    // Generate new employee ID
    final newId = 'emp_${(_employees.length + 1).toString().padLeft(3, '0')}';
    final newEmployeeId = 'WOS${(_employees.length + 1).toString().padLeft(3, '0')}';
    
    final newEmployee = employee.copyWith(
      id: newId,
      employeeId: newEmployeeId,
    );
    
    _employees.add(newEmployee);
    return newEmployee;
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    await Future.delayed(_networkDelay);
    
    final index = _employees.indexWhere((emp) => emp.id == employee.id);
    if (index == -1) {
      throw Exception('Employee not found');
    }
    
    _employees[index] = employee;
    return employee;
  }

  @override
  Future<void> deactivateEmployee(String id) async {
    await Future.delayed(_networkDelay);
    
    final index = _employees.indexWhere((emp) => emp.id == id);
    if (index == -1) {
      throw Exception('Employee not found');
    }
    
    _employees[index] = _employees[index].copyWith(
      status: EmployeeStatus.inactive,
      lastWorkingDay: DateTime.now(),
    );
  }

  @override
  Future<List<Department>> getAllDepartments() async {
    await Future.delayed(_networkDelay);
    return List.from(_departments);
  }
}

// Singleton instance
final EmployeeRepository employeeRepository = MockEmployeeRepository();