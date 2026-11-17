import 'environment.dart';

/// Application configuration based on environment
class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableDebugFeatures;
  final int apiTimeout;
  final String appName;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableDebugFeatures,
    required this.apiTimeout,
    required this.appName,
  });

  /// Development configuration
  static const AppConfig development = AppConfig._(
    environment: Environment.development,
    apiBaseUrl: 'https://dev-api.workforceos.com',
    enableLogging: true,
    enableDebugFeatures: true,
    apiTimeout: 30,
    appName: 'WorkforceOS (Dev)',
  );

  /// Staging configuration
  static const AppConfig staging = AppConfig._(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.workforceos.com',
    enableLogging: true,
    enableDebugFeatures: false,
    apiTimeout: 30,
    appName: 'WorkforceOS (Staging)',
  );

  /// Production configuration
  static const AppConfig production = AppConfig._(
    environment: Environment.production,
    apiBaseUrl: 'https://api.workforceos.com',
    enableLogging: false,
    enableDebugFeatures: false,
    apiTimeout: 20,
    appName: 'WorkforceOS',
  );

  /// Get configuration from environment string (set via --dart-define)
  static AppConfig fromEnvironment(String? env) {
    switch (env?.toLowerCase()) {
      case 'development':
      case 'dev':
        return development;
      case 'staging':
      case 'stg':
        return staging;
      case 'production':
      case 'prod':
        return production;
      default:
        return development; // Default to development
    }
  }

  /// Current active configuration
  static late AppConfig instance;

  /// Initialize configuration at app startup
  static void initialize({String? environment}) {
    instance = fromEnvironment(environment);
  }

  @override
  String toString() {
    return 'AppConfig(environment: ${environment.name}, apiBaseUrl: $apiBaseUrl)';
  }
}
