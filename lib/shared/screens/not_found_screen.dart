import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/states/app_error_state.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: AppErrorState.notFound(
          onRetry: () {
            // Go back to dashboard or home
            context.go('/dashboard');
          },
          onSupport: () {
            // In a real app, this would open a support chat or email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contact support at support@workforces.com'),
              ),
            );
          },
        ),
      ),
    );
  }
}