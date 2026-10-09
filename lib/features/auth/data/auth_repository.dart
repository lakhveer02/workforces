import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/user_role.dart';
import '../domain/auth_state.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> verifyOtp(OtpRequest request);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String password);
}

class MockAuthRepository implements AuthRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  
  // Mock delay to simulate network calls
  static const Duration _networkDelay = Duration(milliseconds: 1500);

  // Mock users for different roles
  static final List<User> _mockUsers = [
    User(
      id: '1',
      email: 'admin@workforceos.com',
      firstName: 'John',
      lastName: 'Admin',
      role: UserRole.admin,
      phone: '+1-555-0101',
      department: 'IT',
      designation: 'System Administrator',
      joinDate: DateTime(2020, 1, 15),
    ),
    User(
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
    User(
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
    User(
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
  ];

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    await Future.delayed(_networkDelay);

    // Simple mock authentication
    final user = _mockUsers.firstWhere(
      (u) => u.email.toLowerCase() == request.email.toLowerCase(),
      orElse: () => throw Exception('Invalid email or password'),
    );

    // Mock password validation (in real app, this would be server-side)
    if (request.password != 'password123') {
      throw Exception('Invalid email or password');
    }

    // Generate mock JWT token
    final token = _generateMockToken(user);

    // Save credentials if remember me is checked
    if (request.rememberMe) {
      await _saveUserSession(user, token);
    }

    // Mock OTP requirement for admin users
    if (user.role == UserRole.admin) {
      return AuthResponse(
        user: user,
        token: token,
        requiresOtp: true,
      );
    }

    // Save session for non-OTP users
    await _saveUserSession(user, token);

    return AuthResponse(
      user: user,
      token: token,
      requiresOtp: false,
    );
  }

  @override
  Future<AuthResponse> verifyOtp(OtpRequest request) async {
    await Future.delayed(_networkDelay);

    // Mock OTP validation (accept any 6-digit code)
    if (request.otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(request.otp)) {
      throw Exception('Invalid OTP code');
    }

    final user = _mockUsers.firstWhere(
      (u) => u.email.toLowerCase() == request.email.toLowerCase(),
      orElse: () => throw Exception('User not found'),
    );

    final token = _generateMockToken(user);
    await _saveUserSession(user, token);

    return AuthResponse(
      user: user,
      token: token,
      requiresOtp: false,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);

      if (userJson != null && token != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
    } catch (e) {
      // Clear corrupted data
      await logout();
    }
    return null;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(_networkDelay);

    final userExists = _mockUsers.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (!userExists) {
      throw Exception('No account found with this email address');
    }

    // In a real app, this would send an email with reset link
    // For mock purposes, we'll just simulate success
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    await Future.delayed(_networkDelay);

    // Mock token validation
    if (token.isEmpty || password.length < 8) {
      throw Exception('Invalid token or password requirements not met');
    }

    // In a real app, this would update the password in the database
    // For mock purposes, we'll just simulate success
  }

  // Helper methods
  String _generateMockToken(User user) {
    final random = Random();
    final tokenData = {
      'userId': user.id,
      'email': user.email,
      'role': user.role.value,
      'iat': DateTime.now().millisecondsSinceEpoch,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    };
    
    // Generate a mock JWT-like token
    final header = base64Encode(utf8.encode(jsonEncode({'typ': 'JWT', 'alg': 'HS256'})));
    final payload = base64Encode(utf8.encode(jsonEncode(tokenData)));
    final signature = List.generate(32, (_) => random.nextInt(256))
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join('');
    
    return '$header.$payload.$signature';
  }

  Future<void> _saveUserSession(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}

// Singleton instance
final AuthRepository authRepository = MockAuthRepository();