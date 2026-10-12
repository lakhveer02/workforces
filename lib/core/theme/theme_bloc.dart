import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../storage/app_storage.dart';

// Theme Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeInitialized extends ThemeEvent {
  const ThemeInitialized();
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

// Theme State
class ThemeState extends Equatable {
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isLoading = false,
  });

  final ThemeMode themeMode;
  final bool isLoading;

  /// Check if current theme is dark based on system or user preference
  bool isDark(BuildContext context) {
    switch (themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [themeMode, isLoading];
}

// Theme BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeToggled>(_onThemeToggled);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final savedTheme = await AppStorage.getThemeMode();
      final themeMode = _parseThemeMode(savedTheme);
      
      emit(state.copyWith(
        themeMode: themeMode,
        isLoading: false,
      ));
    } catch (e) {
      // If there's an error loading theme, use system default
      emit(state.copyWith(
        themeMode: ThemeMode.system,
        isLoading: false,
      ));
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    
    // Persist theme preference
    await AppStorage.setThemeMode(_themeModeToString(event.themeMode));
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode = state.themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    
    add(ThemeChanged(newThemeMode));
  }

  /// Parse string to ThemeMode
  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Convert ThemeMode to string for storage
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}