import 'package:equatable/equatable.dart';
import '../user.dart';

enum EmployeeStatus {
  active('Active', 'active'),
  inactive('Inactive', 'inactive'),
  onLeave('On Leave', 'on_leave'),
  terminated('Terminated', 'terminated'),
  probation('Probation', 'probation');

  const EmployeeStatus(this.displayName, this.value);

  final String displayName;
  final String value;

  static EmployeeStatus fromString(String value) {
    return EmployeeStatus.values.firstWhere(
      (status) => status.value == value.toLowerCase(),
      orElse: () => EmployeeStatus.active,
    );
  }
}

enum EmploymentType {
  fullTime('Full-time', 'full_time'),
  partTime('Part-time', 'part_time'),
  contract('Contract', 'contract'),
  intern('Intern', 'intern'),
  consultant('Consultant', 'consultant');

  const EmploymentType(this.displayName, this.value);

  final String displayName;
  final String value;

  static EmploymentType fromString(String value) {
    return EmploymentType.values.firstWhere(
      (type) => type.value == value.toLowerCase(),
      orElse: () => EmploymentType.fullTime,
    );
  }
}

class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.employeeId,
    required this.user,
    required this.department,
    required this.designation,
    required this.joinDate,
    required this.employmentType,
    required this.status,
    this.managerId,
    this.managerName,
    this.workLocation,
    this.workPhone,
    this.emergencyContact,
    this.address,
    this.dateOfBirth,
    this.salary,
    this.lastWorkingDay,
    this.notes,
  });

  final String id;
  final String employeeId; // Employee ID like EMP001
  final User user; // Contains basic user info
  final String department;
  final String designation;
  final DateTime joinDate;
  final EmploymentType employmentType;
  final EmployeeStatus status;
  final String? managerId;
  final String? managerName;
  final String? workLocation;
  final String? workPhone;
  final EmergencyContact? emergencyContact;
  final Address? address;
  final DateTime? dateOfBirth;
  final double? salary;
  final DateTime? lastWorkingDay;
  final String? notes;

  // Computed properties
  String get fullName => user.fullName;
  String get email => user.email;
  String get displayId => employeeId;
  bool get isActive => status == EmployeeStatus.active;
  bool get canManageTeam => user.canAccessManager;

  int get yearsOfService {
    final endDate = lastWorkingDay ?? DateTime.now();
    final diff = endDate.difference(joinDate);
    return (diff.inDays / 365).floor();
  }

  String get statusBadgeText => status.displayName;

  Employee copyWith({
    String? id,
    String? employeeId,
    User? user,
    String? department,
    String? designation,
    DateTime? joinDate,
    EmploymentType? employmentType,
    EmployeeStatus? status,
    String? managerId,
    String? managerName,
    String? workLocation,
    String? workPhone,
    EmergencyContact? emergencyContact,
    Address? address,
    DateTime? dateOfBirth,
    double? salary,
    DateTime? lastWorkingDay,
    String? notes,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      user: user ?? this.user,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      joinDate: joinDate ?? this.joinDate,
      employmentType: employmentType ?? this.employmentType,
      status: status ?? this.status,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      workLocation: workLocation ?? this.workLocation,
      workPhone: workPhone ?? this.workPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      salary: salary ?? this.salary,
      lastWorkingDay: lastWorkingDay ?? this.lastWorkingDay,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        user,
        department,
        designation,
        joinDate,
        employmentType,
        status,
        managerId,
        managerName,
        workLocation,
        workPhone,
        emergencyContact,
        address,
        dateOfBirth,
        salary,
        lastWorkingDay,
        notes,
      ];

  /// Create employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      department: json['department'] as String,
      designation: json['designation'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      employmentType: EmploymentType.fromString(json['employmentType'] as String),
      status: EmployeeStatus.fromString(json['status'] as String),
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      workLocation: json['workLocation'] as String?,
      workPhone: json['workPhone'] as String?,
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContact.fromJson(json['emergencyContact'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      salary: (json['salary'] as num?)?.toDouble(),
      lastWorkingDay: json['lastWorkingDay'] != null
          ? DateTime.parse(json['lastWorkingDay'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }

  /// Convert employee to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'user': user.toJson(),
      'department': department,
      'designation': designation,
      'joinDate': joinDate.toIso8601String(),
      'employmentType': employmentType.value,
      'status': status.value,
      'managerId': managerId,
      'managerName': managerName,
      'workLocation': workLocation,
      'workPhone': workPhone,
      'emergencyContact': emergencyContact?.toJson(),
      'address': address?.toJson(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'salary': salary,
      'lastWorkingDay': lastWorkingDay?.toIso8601String(),
      'notes': notes,
    };
  }
}

class EmergencyContact extends Equatable {
  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
    this.email,
  });

  final String name;
  final String relationship;
  final String phone;
  final String? email;

  @override
  List<Object?> get props => [name, relationship, phone, email];

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
      'email': email,
    };
  }
}

class Address extends Equatable {
  const Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });

  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

  String get formattedAddress => '$street, $city, $state $zipCode, $country';

  @override
  List<Object?> get props => [street, city, state, country, zipCode];

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      zipCode: json['zipCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }
}