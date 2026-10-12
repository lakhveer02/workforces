import 'package:equatable/equatable.dart';
import '../../../shared/models/user_role.dart';

/// Comprehensive employee model for directory management
class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.designation,
    required this.joinDate,
    this.managerId,
    this.managerName,
    this.profilePicture,
    this.address,
    this.emergencyContact,
    this.emergencyPhone,
    this.dateOfBirth,
    this.bloodGroup,
    this.maritalStatus,
    this.nationality = 'Indian',
    this.salary,
    this.bankAccount,
    this.panNumber,
    this.aadharNumber,
    this.isActive = true,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String employeeId; // Employee code like EMP001
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final UserRole role;
  final String department;
  final String designation;
  final DateTime joinDate;
  final String? managerId;
  final String? managerName;
  final String? profilePicture;
  final String? address;
  final String? emergencyContact;
  final String? emergencyPhone;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final MaritalStatus? maritalStatus;
  final String nationality;
  final double? salary;
  final String? bankAccount;
  final String? panNumber;
  final String? aadharNumber;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Computed properties
  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  
  // Compatibility properties for UI components
  DateTime get hireDate => joinDate;
  String get position => designation;
  String? get profileImage => profilePicture;
  
  int get yearsOfService {
    final now = DateTime.now();
    return now.difference(joinDate).inDays ~/ 365;
  }

  EmployeeStatus get status {
    if (!isActive) return EmployeeStatus.inactive;
    if (lastLoginAt == null) return EmployeeStatus.pending;
    
    final daysSinceLogin = DateTime.now().difference(lastLoginAt!).inDays;
    if (daysSinceLogin > 30) return EmployeeStatus.inactive;
    if (daysSinceLogin > 7) return EmployeeStatus.away;
    
    return EmployeeStatus.active;
  }

  Employee copyWith({
    String? id,
    String? employeeId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    UserRole? role,
    String? department,
    String? designation,
    DateTime? joinDate,
    String? managerId,
    String? managerName,
    String? profilePicture,
    String? address,
    String? emergencyContact,
    String? emergencyPhone,
    DateTime? dateOfBirth,
    String? bloodGroup,
    MaritalStatus? maritalStatus,
    String? nationality,
    double? salary,
    String? bankAccount,
    String? panNumber,
    String? aadharNumber,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      joinDate: joinDate ?? this.joinDate,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      nationality: nationality ?? this.nationality,
      salary: salary ?? this.salary,
      bankAccount: bankAccount ?? this.bankAccount,
      panNumber: panNumber ?? this.panNumber,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role.value,
      'department': department,
      'designation': designation,
      'joinDate': joinDate.toIso8601String(),
      'managerId': managerId,
      'managerName': managerName,
      'profilePicture': profilePicture,
      'address': address,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'maritalStatus': maritalStatus?.value,
      'nationality': nationality,
      'salary': salary,
      'bankAccount': bankAccount,
      'panNumber': panNumber,
      'aadharNumber': aadharNumber,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: UserRole.fromString(json['role'] as String),
      department: json['department'] as String,
      designation: json['designation'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      profilePicture: json['profilePicture'] as String?,
      address: json['address'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      bloodGroup: json['bloodGroup'] as String?,
      maritalStatus: json['maritalStatus'] != null
          ? MaritalStatus.fromString(json['maritalStatus'] as String)
          : null,
      nationality: json['nationality'] as String? ?? 'Indian',
      salary: json['salary'] as double?,
      bankAccount: json['bankAccount'] as String?,
      panNumber: json['panNumber'] as String?,
      aadharNumber: json['aadharNumber'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        firstName,
        lastName,
        email,
        phone,
        role,
        department,
        designation,
        joinDate,
        managerId,
        managerName,
        profilePicture,
        address,
        emergencyContact,
        emergencyPhone,
        dateOfBirth,
        bloodGroup,
        maritalStatus,
        nationality,
        salary,
        bankAccount,
        panNumber,
        aadharNumber,
        isActive,
        lastLoginAt,
        createdAt,
        updatedAt,
      ];
}

enum EmployeeStatus {
  active,
  inactive,
  pending,
  away,
  terminated;

  String get displayName {
    switch (this) {
      case EmployeeStatus.active:
        return 'Active';
      case EmployeeStatus.inactive:
        return 'Inactive';
      case EmployeeStatus.pending:
        return 'Pending';
      case EmployeeStatus.away:
        return 'Away';
      case EmployeeStatus.terminated:
        return 'Terminated';
    }
  }

  String get value {
    switch (this) {
      case EmployeeStatus.active:
        return 'active';
      case EmployeeStatus.inactive:
        return 'inactive';
      case EmployeeStatus.pending:
        return 'pending';
      case EmployeeStatus.away:
        return 'away';
      case EmployeeStatus.terminated:
        return 'terminated';
    }
  }

  static EmployeeStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return EmployeeStatus.active;
      case 'inactive':
        return EmployeeStatus.inactive;
      case 'pending':
        return EmployeeStatus.pending;
      case 'away':
        return EmployeeStatus.away;
      case 'terminated':
        return EmployeeStatus.terminated;
      default:
        throw ArgumentError('Invalid employee status: $value');
    }
  }
}

enum MaritalStatus {
  single,
  married,
  divorced,
  widowed;

  String get displayName {
    switch (this) {
      case MaritalStatus.single:
        return 'Single';
      case MaritalStatus.married:
        return 'Married';
      case MaritalStatus.divorced:
        return 'Divorced';
      case MaritalStatus.widowed:
        return 'Widowed';
    }
  }

  String get value {
    switch (this) {
      case MaritalStatus.single:
        return 'single';
      case MaritalStatus.married:
        return 'married';
      case MaritalStatus.divorced:
        return 'divorced';
      case MaritalStatus.widowed:
        return 'widowed';
    }
  }

  static MaritalStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'single':
        return MaritalStatus.single;
      case 'married':
        return MaritalStatus.married;
      case 'divorced':
        return MaritalStatus.divorced;
      case 'widowed':
        return MaritalStatus.widowed;
      default:
        throw ArgumentError('Invalid marital status: $value');
    }
  }
}

/// Employee search and filter parameters
class EmployeeFilters extends Equatable {
  const EmployeeFilters({
    this.search,
    this.department,
    this.role,
    this.status,
    this.managerId,
    this.position,
    this.hireDateFrom,
    this.hireDateTo,
  });

  final String? search;
  final String? department;
  final UserRole? role;
  final EmployeeStatus? status;
  final String? managerId;
  final String? position;
  final DateTime? hireDateFrom;
  final DateTime? hireDateTo;

  EmployeeFilters copyWith({
    String? search,
    String? department,
    UserRole? role,
    EmployeeStatus? status,
    String? managerId,
    String? position,
    DateTime? hireDateFrom,
    DateTime? hireDateTo,
  }) {
    return EmployeeFilters(
      search: search ?? this.search,
      department: department ?? this.department,
      role: role ?? this.role,
      status: status ?? this.status,
      managerId: managerId ?? this.managerId,
      position: position ?? this.position,
      hireDateFrom: hireDateFrom ?? this.hireDateFrom,
      hireDateTo: hireDateTo ?? this.hireDateTo,
    );
  }

  // Method to remove specific filters
  EmployeeFilters removeStatus() {
    return copyWith(status: null);
  }

  EmployeeFilters copyWithRemovedStatus() {
    return copyWith(status: null);
  }

  bool get hasActiveFilters =>
      search != null ||
      department != null ||
      role != null ||
      status != null ||
      managerId != null ||
      position != null ||
      hireDateFrom != null ||
      hireDateTo != null;

  @override
  List<Object?> get props => [search, department, role, status, managerId, position, hireDateFrom, hireDateTo];
}

/// Pagination result for employee list
class EmployeeListResult extends Equatable {
  const EmployeeListResult({
    required this.employees,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });

  final List<Employee> employees;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  int get totalPages => (totalCount / pageSize).ceil();

  @override
  List<Object?> get props => [employees, totalCount, page, pageSize, hasNextPage];
}