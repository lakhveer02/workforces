import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/employee_repository.dart';
import '../../domain/employee_models.dart';

// Events
abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeLoadRequested extends EmployeeEvent {}

class EmployeeSearchRequested extends EmployeeEvent {
  const EmployeeSearchRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class EmployeeDepartmentFilterRequested extends EmployeeEvent {
  const EmployeeDepartmentFilterRequested(this.department);

  final String? department;

  @override
  List<Object?> get props => [department];
}

class EmployeeDetailRequested extends EmployeeEvent {
  const EmployeeDetailRequested(this.employeeId);

  final String employeeId;

  @override
  List<Object?> get props => [employeeId];
}

class EmployeeCreateRequested extends EmployeeEvent {
  const EmployeeCreateRequested(this.employee);

  final Employee employee;

  @override
  List<Object?> get props => [employee];
}

class EmployeeUpdateRequested extends EmployeeEvent {
  const EmployeeUpdateRequested(this.employee);

  final Employee employee;

  @override
  List<Object?> get props => [employee];
}

class EmployeeDeactivateRequested extends EmployeeEvent {
  const EmployeeDeactivateRequested(this.employeeId);

  final String employeeId;

  @override
  List<Object?> get props => [employeeId];
}

class DepartmentLoadRequested extends EmployeeEvent {}

// States
enum EmployeeStateStatus {
  initial,
  loading,
  success,
  error,
}

class EmployeeState extends Equatable {
  const EmployeeState({
    this.status = EmployeeStateStatus.initial,
    this.employees = const [],
    this.departments = const [],
    this.selectedEmployee,
    this.filteredEmployees = const [],
    this.selectedDepartment,
    this.searchQuery = '',
    this.error,
  });

  final EmployeeStateStatus status;
  final List<Employee> employees;
  final List<String> departments;
  final Employee? selectedEmployee;
  final List<Employee> filteredEmployees;
  final String? selectedDepartment;
  final String searchQuery;
  final String? error;

  List<Employee> get displayEmployees {
    if (searchQuery.isNotEmpty) {
      return filteredEmployees;
    }
    if (selectedDepartment != null) {
      return employees.where((emp) => emp.department == selectedDepartment).toList();
    }
    return employees;
  }

  List<String> get departmentNames {
    return departments;
  }

  Map<String, int> get employeeCountByDepartment {
    final counts = <String, int>{};
    for (final employee in employees) {
      counts[employee.department] = (counts[employee.department] ?? 0) + 1;
    }
    return counts;
  }

  Map<EmployeeStatus, int> get employeeCountByStatus {
    final counts = <EmployeeStatus, int>{};
    for (final employee in employees) {
      counts[employee.status] = (counts[employee.status] ?? 0) + 1;
    }
    return counts;
  }

  bool get isLoading => status == EmployeeStateStatus.loading;
  bool get hasError => status == EmployeeStateStatus.error && error != null;

  EmployeeState copyWith({
    EmployeeStateStatus? status,
    List<Employee>? employees,
    List<String>? departments,
    Employee? selectedEmployee,
    List<Employee>? filteredEmployees,
    String? selectedDepartment,
    String? searchQuery,
    String? error,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      departments: departments ?? this.departments,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        employees,
        departments,
        selectedEmployee,
        filteredEmployees,
        selectedDepartment,
        searchQuery,
        error,
      ];
}

// BLoC
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc({
    required EmployeeRepository employeeRepository,
  }) : _employeeRepository = employeeRepository,
       super(const EmployeeState()) {
    
    on<EmployeeLoadRequested>(_onEmployeeLoadRequested);
    on<EmployeeSearchRequested>(_onEmployeeSearchRequested);
    on<EmployeeDepartmentFilterRequested>(_onEmployeeDepartmentFilterRequested);
    on<EmployeeDetailRequested>(_onEmployeeDetailRequested);
    on<EmployeeCreateRequested>(_onEmployeeCreateRequested);
    on<EmployeeUpdateRequested>(_onEmployeeUpdateRequested);
    on<EmployeeDeactivateRequested>(_onEmployeeDeactivateRequested);
    on<DepartmentLoadRequested>(_onDepartmentLoadRequested);
  }

  final EmployeeRepository _employeeRepository;

  Future<void> _onEmployeeLoadRequested(
    EmployeeLoadRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EmployeeStateStatus.loading));
      
      final employeeResult = await _employeeRepository.getEmployees();
      final departments = await _employeeRepository.getDepartments();
      
      emit(state.copyWith(
        status: EmployeeStateStatus.success,
        employees: employeeResult.employees,
        departments: departments,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onEmployeeSearchRequested(
    EmployeeSearchRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EmployeeStateStatus.loading));
      
      final employeeResult = await _employeeRepository.getEmployees(
        filters: EmployeeFilters(search: event.query),
      );
      
      emit(state.copyWith(
        status: EmployeeStateStatus.success,
        filteredEmployees: employeeResult.employees,
        searchQuery: event.query,
        selectedDepartment: null, // Clear department filter when searching
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onEmployeeDepartmentFilterRequested(
    EmployeeDepartmentFilterRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(
      selectedDepartment: event.department,
      searchQuery: '', // Clear search when filtering by department
      filteredEmployees: [], // Clear search results
    ));
  }

  Future<void> _onEmployeeDetailRequested(
    EmployeeDetailRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EmployeeStateStatus.loading));
      
      final employee = await _employeeRepository.getEmployeeById(event.employeeId);
      
      emit(state.copyWith(
        status: EmployeeStateStatus.success,
        selectedEmployee: employee,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onEmployeeCreateRequested(
    EmployeeCreateRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EmployeeStateStatus.loading));
      
      final newEmployee = await _employeeRepository.createEmployee(event.employee);
      final updatedEmployees = [...state.employees, newEmployee];
      
      emit(state.copyWith(
        status: EmployeeStateStatus.success,
        employees: updatedEmployees,
        selectedEmployee: newEmployee,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onEmployeeUpdateRequested(
    EmployeeUpdateRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EmployeeStateStatus.loading));
      
      final updatedEmployee = await _employeeRepository.updateEmployee(event.employee);
      final updatedEmployees = state.employees.map((emp) {
        return emp.id == updatedEmployee.id ? updatedEmployee : emp;
      }).toList();
      
      emit(state.copyWith(
        status: EmployeeStateStatus.success,
        employees: updatedEmployees,
        selectedEmployee: updatedEmployee,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onEmployeeDeactivateRequested(
    EmployeeDeactivateRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EmployeeStateStatus.loading));
      
      await _employeeRepository.deleteEmployee(event.employeeId);
      
      // Reload employees to get updated status
      final employeeResult = await _employeeRepository.getEmployees();
      
      emit(state.copyWith(
        status: EmployeeStateStatus.success,
        employees: employeeResult.employees,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDepartmentLoadRequested(
    DepartmentLoadRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      final departments = await _employeeRepository.getDepartments();
      
      emit(state.copyWith(departments: departments));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStateStatus.error,
        error: e.toString(),
      ));
    }
  }
}