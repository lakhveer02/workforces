import 'package:equatable/equatable.dart';
import '../../../shared/models/user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpRequired,
  error,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.error,
    this.email,
  });

  final AuthStatus status;
  final User? user;
  final String? token;
  final String? error;
  final String? email; // For OTP flow

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get requiresOtp => status == AuthStatus.otpRequired;
  bool get hasError => status == AuthStatus.error && error != null;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? token,
    String? error,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, user, token, error, email];
}

class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool rememberMe;
}

class OtpRequest {
  const OtpRequest({
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;
}

class AuthResponse {
  const AuthResponse({
    required this.user,
    required this.token,
    this.requiresOtp = false,
  });

  final User user;
  final String token;
  final bool requiresOtp;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      requiresOtp: json['requiresOtp'] as bool? ?? false,
    );
  }
}