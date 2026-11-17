import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:workforces/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WorkforceOS Integration Tests', () {
    testWidgets('Complete login flow: Launch -> Login -> Dashboard', (tester) async {
      // 1. Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 2. Verify splash/login screen loads
      expect(find.byType(TextField), findsWidgets);
      debugPrint('✓ Login screen loaded');

      // 3. Find and enter email
      final emailField = find.byWidgetPredicate(
        (widget) {
          if (widget is! TextField) return false;
          final decoration = widget.decoration;
          return decoration?.hintText?.contains('Email') == true ||
                 decoration?.labelText?.contains('Email') == true;
        },
      );
      
      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@workforceos.com');
        await tester.pump(const Duration(milliseconds: 500));
        debugPrint('✓ Email entered');
      }

      // 4. Find and enter password
      final passwordField = find.byWidgetPredicate(
        (widget) {
          if (widget is! TextField) return false;
          final decoration = widget.decoration;
          return decoration?.hintText?.contains('Password') == true ||
                 decoration?.labelText?.contains('Password') == true;
        },
      );
      
      if (passwordField.evaluate().isNotEmpty) {
        await tester.enterText(passwordField, 'Test123!');
        await tester.pump(const Duration(milliseconds: 500));
        debugPrint('✓ Password entered');
      }

      // 5. Find and tap login button
      final loginButton = find.byWidgetPredicate(
        (widget) => widget is ElevatedButton || 
                   (widget is Text && widget.data?.contains('Login') == true) ||
                   (widget is Text && widget.data?.contains('Sign In') == true),
      );

      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pump(const Duration(milliseconds: 500));
        debugPrint('✓ Login button tapped');
      }

      // 6. Wait for navigation and OTP screen (if enabled)
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Check if we're on OTP screen
      final otpField = find.byWidgetPredicate(
        (widget) {
          if (widget is! TextField) return false;
          final decoration = widget.decoration;
          return decoration?.hintText?.contains('OTP') == true ||
                 decoration?.labelText?.contains('OTP') == true;
        },
      );

      if (otpField.evaluate().isNotEmpty) {
        debugPrint('✓ OTP screen displayed');
        
        // Enter mock OTP
        await tester.enterText(otpField, '123456');
        await tester.pump(const Duration(milliseconds: 500));
        
        // Find and tap verify button
        final verifyButton = find.byWidgetPredicate(
          (widget) => widget is ElevatedButton || 
                     (widget is Text && widget.data?.contains('Verify') == true),
        );
        
        if (verifyButton.evaluate().isNotEmpty) {
          await tester.tap(verifyButton.first);
          await tester.pump(const Duration(milliseconds: 500));
          debugPrint('✓ OTP verification attempted');
        }
      }

      // 7. Wait for dashboard to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 8. Verify dashboard elements are present
      // Look for common dashboard indicators
      final dashboardIndicators = [
        find.text('Dashboard'),
        find.text('Welcome'),
        find.byType(BottomNavigationBar),
        find.byType(NavigationBar),
        find.byIcon(Icons.home),
        find.byIcon(Icons.dashboard),
      ];

      var foundDashboard = false;
      for (final indicator in dashboardIndicators) {
        if (indicator.evaluate().isNotEmpty) {
          foundDashboard = true;
          debugPrint('✓ Dashboard indicator found: ${indicator.toString()}');
          break;
        }
      }

      expect(foundDashboard, true, reason: 'Dashboard should be visible after login');
      debugPrint('✓ Dashboard loaded successfully');

      // 9. Test navigation between tabs (if bottom navigation exists)
      final bottomNav = find.byType(BottomNavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        // Simple tap to verify interaction
        await tester.tap(bottomNav.first);
        await tester.pumpAndSettle();
        debugPrint('✓ Navigation interaction working');
      }

      debugPrint('✅ Integration test completed successfully');
    });

    testWidgets('App launches without crashing', (tester) async {
      // Simple smoke test
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verify app renders something
      expect(find.byType(MaterialApp), findsOneWidget);
      debugPrint('✅ App launches successfully');
    });
  });
}
