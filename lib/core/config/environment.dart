/// Environment types supported by the application
enum Environment {
  development,
  staging,
  production,
}

/// Extension to add display names to environments
extension EnvironmentExtension on Environment {
  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  bool get isDevelopment => this == Environment.development;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;
}
