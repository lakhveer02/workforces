import 'package:equatable/equatable.dart';

class Department extends Equatable {
  const Department({
    required this.id,
    required this.name,
    required this.description,
    this.headId,
    this.headName,
    this.parentDepartmentId,
    this.location,
    this.budget,
    this.employeeCount = 0,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String description;
  final String? headId; // Department head employee ID
  final String? headName;
  final String? parentDepartmentId; // For hierarchical departments
  final String? location;
  final double? budget;
  final int employeeCount;
  final bool isActive;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        headId,
        headName,
        parentDepartmentId,
        location,
        budget,
        employeeCount,
        isActive,
      ];

  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? headId,
    String? headName,
    String? parentDepartmentId,
    String? location,
    double? budget,
    int? employeeCount,
    bool? isActive,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      headId: headId ?? this.headId,
      headName: headName ?? this.headName,
      parentDepartmentId: parentDepartmentId ?? this.parentDepartmentId,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      employeeCount: employeeCount ?? this.employeeCount,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      headId: json['headId'] as String?,
      headName: json['headName'] as String?,
      parentDepartmentId: json['parentDepartmentId'] as String?,
      location: json['location'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      employeeCount: json['employeeCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'headId': headId,
      'headName': headName,
      'parentDepartmentId': parentDepartmentId,
      'location': location,
      'budget': budget,
      'employeeCount': employeeCount,
      'isActive': isActive,
    };
  }
}

/// Common department names used in organizations
class DepartmentConstants {
  static const List<String> commonDepartments = [
    'Human Resources',
    'Engineering',
    'Marketing',
    'Sales',
    'Finance',
    'Operations',
    'Customer Support',
    'Product Management',
    'Design',
    'Quality Assurance',
    'Legal',
    'Administration',
    'Research & Development',
    'Business Development',
    'Information Technology',
  ];

  static const Map<String, List<String>> departmentDesignations = {
    'Engineering': [
      'Software Engineer',
      'Senior Software Engineer',
      'Lead Developer',
      'Engineering Manager',
      'Tech Lead',
      'DevOps Engineer',
      'Frontend Developer',
      'Backend Developer',
      'Full Stack Developer',
    ],
    'Human Resources': [
      'HR Manager',
      'HR Business Partner',
      'Recruiter',
      'HR Specialist',
      'Talent Acquisition Manager',
      'Compensation Analyst',
      'Training Coordinator',
    ],
    'Marketing': [
      'Marketing Manager',
      'Digital Marketing Specialist',
      'Content Marketing Manager',
      'Brand Manager',
      'Marketing Coordinator',
      'SEO Specialist',
      'Social Media Manager',
    ],
    'Sales': [
      'Sales Manager',
      'Account Executive',
      'Sales Representative',
      'Business Development Manager',
      'Sales Coordinator',
      'Inside Sales Representative',
    ],
    'Finance': [
      'Finance Manager',
      'Financial Analyst',
      'Accountant',
      'Controller',
      'Finance Director',
      'Budget Analyst',
      'Accounts Payable Specialist',
    ],
  };
}