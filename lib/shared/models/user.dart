import 'package:equatable/equatable.dart';
import 'user_role.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.avatar,
    this.department,
    this.designation,
    this.managerId,
    this.joinDate,
    this.isActive = true,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String? phone;
  final String? avatar;
  final String? department;
  final String? designation;
  final String? managerId;
  final DateTime? joinDate;
  final bool isActive;

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  /// Check if user has specific permission
  bool hasPermission(Permission permission) {
    return role.permissions.contains(permission);
  }

  /// Check if user can access admin features
  bool get canAccessAdmin => role.isAdmin;

  /// Check if user can access HR features
  bool get canAccessHR => role.isHR;

  /// Check if user can access manager features
  bool get canAccessManager => role.isManager;

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? phone,
    String? avatar,
    String? department,
    String? designation,
    String? managerId,
    DateTime? joinDate,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      managerId: managerId ?? this.managerId,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        phone,
        avatar,
        department,
        designation,
        managerId,
        joinDate,
        isActive,
      ];

  /// Create user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: UserRole.fromString(json['role'] as String),
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      department: json['department'] as String?,
      designation: json['designation'] as String?,
      managerId: json['managerId'] as String?,
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.value,
      'phone': phone,
      'avatar': avatar,
      'department': department,
      'designation': designation,
      'managerId': managerId,
      'joinDate': joinDate?.toIso8601String(),
      'isActive': isActive,
    };
  }
}