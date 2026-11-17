# Phase 8: Testing, CI/CD & Deployment Preparation

## 📋 Overview

This phase adds production-ready features including automated testing, environment configuration, CI/CD pipeline, and app branding.

## 🏗️ Architecture

### 1. Environment Configuration

The app supports three environments: **Development**, **Staging**, and **Production**.

#### Running with Different Environments

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production
```

#### Building for Different Environments

```bash
# Android APK - Staging
flutter build apk --release --dart-define=ENVIRONMENT=staging

# iOS - Production
flutter build ios --release --dart-define=ENVIRONMENT=production

# Web - Staging
flutter build web --release --dart-define=ENVIRONMENT=staging
```

#### Environment Configuration Details

- **Development**
  - API: `https://dev-api.workforceos.com`
  - Logging: Enabled
  - Debug Features: Enabled
  - Timeout: 30s

- **Staging**
  - API: `https://staging-api.workforceos.com`
  - Logging: Enabled
  - Debug Features: Disabled
  - Timeout: 30s

- **Production**
  - API: `https://api.workforceos.com`
  - Logging: Disabled
  - Debug Features: Disabled
  - Timeout: 20s

### 2. Automated Testing

#### Test Structure

```
test/
├── features/
│   ├── auth/
│   │   └── data/
│   │       └── auth_repository_test.dart
│   └── leaves/
│       └── data/
│           └── leave_repository_test.dart
└── core/
    └── widgets/
        ├── app_button_test.dart
        └── app_stat_card_test.dart

integration_test/
└── app_test.dart
```

#### Running Tests

```bash
# Run all unit and widget tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/data/auth_repository_test.dart

# Run integration tests
flutter test integration_test/app_test.dart

# Run integration tests on device
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

#### Test Coverage

View coverage report:
```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser (macOS)
open coverage/html/index.html
```

### 3. CI/CD Pipeline

#### GitHub Actions Workflow

The workflow (`/workflows/build_and_test.yml`) runs on:
- Pull requests to `main` or `develop`
- Pushes to `main` or `develop`

#### Workflow Steps

1. **Analyze & Test**
   - Flutter analyze (code quality)
   - Unit and widget tests
   - Coverage report upload

2. **Build Android APK (Staging)**
   - Builds release APK for staging
   - Uploads artifact (30-day retention)

3. **Build Web (Staging)**
   - Builds web release bundle
   - Uploads artifact (30-day retention)

#### Viewing Build Artifacts

1. Go to GitHub Actions tab
2. Click on the workflow run
3. Scroll to "Artifacts" section
4. Download builds

### 4. App Branding

#### App Icons

Configuration: `flutter_launcher_icons.yaml`

```bash
# 1. Place your icon at: assets/icons/app_icon.png
#    Recommended size: 1024x1024px

# 2. Generate icons
flutter pub get
flutter pub run flutter_launcher_icons
```

Generates icons for:
- ✅ Android (adaptive icons with primary blue background)
- ✅ iOS (all required sizes)
- ✅ Web (PWA icons)
- ✅ Windows
- ✅ macOS

#### Splash Screen

Configuration: `flutter_native_splash.yaml`

```bash
# 1. Place images:
#    - assets/images/splash_logo.png
#    - assets/images/splash_logo_dark.png (optional)

# 2. Generate splash screens
flutter pub get
flutter pub run flutter_native_splash:create

# 3. To remove (if needed)
flutter pub run flutter_native_splash:remove
```

Generates splash screens for:
- ✅ Android (including Android 12+)
- ✅ iOS
- ✅ Web

## 📦 Dependencies

### Production Dependencies
- `flutter_bloc` - State management
- `go_router` - Navigation
- `shared_preferences` - Local storage

### Development Dependencies
- `flutter_test` - Testing framework
- `integration_test` - Integration testing
- `mocktail` - Mocking for tests
- `flutter_launcher_icons` - Icon generation
- `flutter_native_splash` - Splash screen generation

## 🧪 Writing Tests

### Unit Test Example

```dart
test('should return success when login is valid', () async {
  // Arrange
  when(() => mockApi.login(any(), any()))
      .thenAnswer((_) async => mockUser);
  
  // Act
  final result = await repository.login('email', 'password');
  
  // Assert
  expect(result.isSuccess, true);
  verify(() => mockApi.login('email', 'password')).called(1);
});
```

### Widget Test Example

```dart
testWidgets('button triggers callback when tapped', (tester) async {
  var tapped = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: AppButton(
        onPressed: () => tapped = true,
        child: Text('Tap'),
      ),
    ),
  );
  
  await tester.tap(find.byType(AppButton));
  expect(tapped, true);
});
```

### Integration Test Example

```dart
testWidgets('user can login and view dashboard', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byType(EmailField), 'test@example.com');
  await tester.enterText(find.byType(PasswordField), 'password');
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  
  expect(find.text('Dashboard'), findsOneWidget);
});
```

## 🚀 Deployment Checklist

### Pre-Deployment

- [ ] All tests passing (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Environment configured correctly
- [ ] App icons generated
- [ ] Splash screens generated
- [ ] Version updated in `pubspec.yaml`

### Android Deployment

```bash
# Build release APK
flutter build apk --release --dart-define=ENVIRONMENT=production

# Build App Bundle (for Play Store)
flutter build appbundle --release --dart-define=ENVIRONMENT=production
```

### iOS Deployment

```bash
# Build for App Store
flutter build ios --release --dart-define=ENVIRONMENT=production

# Or use Xcode for signing and uploading
open ios/Runner.xcworkspace
```

### Web Deployment

```bash
# Build web release
flutter build web --release --dart-define=ENVIRONMENT=production

# Deploy to hosting (example: Firebase)
firebase deploy --only hosting
```

## 📊 Monitoring & Analytics

### Environment Detection

```dart
import 'package:workforces/core/config/app_config.dart';

// Check current environment
if (AppConfig.instance.environment.isDevelopment) {
  // Development-specific code
}

if (AppConfig.instance.enableLogging) {
  print('Logging enabled');
}
```

### API Configuration

```dart
import 'package:workforces/core/config/app_config.dart';

final apiUrl = AppConfig.instance.apiBaseUrl;
final timeout = AppConfig.instance.apiTimeout;
```

## 🔧 Troubleshooting

### Tests Failing

1. **Check mocks are registered**
   ```dart
   setUpAll(() {
     registerFallbackValue(FakeData());
   });
   ```

2. **Verify test data**
   - Ensure mock responses match expected format
   - Check date/time formats

3. **Widget tests timing**
   ```dart
   await tester.pumpAndSettle(); // Wait for animations
   await tester.pump(Duration(seconds: 1)); // Wait specific time
   ```

### CI/CD Issues

1. **Build failing**: Check Flutter version matches CI
2. **Tests timeout**: Increase timeout in workflow
3. **Artifacts not uploading**: Check workflow permissions

### Icon Generation Issues

1. **Image not found**: Verify path in YAML
2. **Wrong size**: Use 1024x1024px PNG
3. **Regenerate**: Delete old icons, run generator again

## 📝 Notes

- Environment is set at compile-time (cannot be changed at runtime)
- Test coverage should be > 80% for production
- All features should have corresponding tests
- CI/CD pipeline must pass before merging to main

## 🎯 Next Steps

With Phase 8 complete, the app is ready for:
- ✅ Beta distribution
- ✅ Backend API integration
- ✅ App Store submissions
- ✅ Production deployment

---

**WorkforceOS** - Production-Ready Enterprise HRMS
