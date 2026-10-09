import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/auth_state.dart';
import '../../data/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class AuthOtpVerificationRequested extends AuthEvent {
  const AuthOtpVerificationRequested({
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  const AuthResetPasswordRequested({
    required this.token,
    required this.password,
  });

  final String token;
  final String password;

  @override
  List<Object?> get props => [token, password];
}

class AuthErrorCleared extends AuthEvent {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
       super(const AuthState()) {
    
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthOtpVerificationRequested>(_onAuthOtpVerificationRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthErrorCleared>(_onAuthErrorCleared);
  }

  final AuthRepository _authRepository;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      
      final user = await _authRepository.getCurrentUser();
      
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final request = LoginRequest(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );

      final response = await _authRepository.login(request);

      if (response.requiresOtp) {
        emit(state.copyWith(
          status: AuthStatus.otpRequired,
          email: event.email,
          user: response.user,
          token: response.token,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          token: response.token,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthOtpVerificationRequested(
    AuthOtpVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final request = OtpRequest(
        email: event.email,
        otp: event.otp,
      );

      final response = await _authRepository.verifyOtp(request);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: response.user,
        token: response.token,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      
      await _authRepository.logout();
      
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      
      await _authRepository.forgotPassword(event.email);
      
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      
      await _authRepository.resetPassword(event.token, event.password);
      
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: state.status == AuthStatus.error ? AuthStatus.unauthenticated : state.status,
      error: null,
    ));
  }
}