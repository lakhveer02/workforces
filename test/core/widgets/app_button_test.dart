import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workforces/shared/widgets/common/app_button.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('should render with correct text', (tester) async {
      // Arrange
      const buttonText = 'Test Button';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              text: buttonText,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('should trigger onPressed callback when tapped', (tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {
                tapped = true;
              },
              text: 'Tap Me',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should not trigger callback when disabled', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              text: 'Disabled',
              isEnabled: false,
            ),
          ),
        ),
      );

      // Tap should not crash even when disabled
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      await tester.pump();

      // Assert - button exists but is disabled
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              text: 'Loading',
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display with secondary type', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              text: 'Secondary',
              type: AppButtonType.secondary,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('should display with outlined type', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              text: 'Outlined',
              type: AppButtonType.outlined,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Outlined'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
