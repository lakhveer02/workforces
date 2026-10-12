import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/states/app_error_state.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.buz),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Center(
        child: AppErrorState.accessDenied(
          onRetry: () {
            context.go('/dashboard');
          },
          onSupport: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contact your administrator for access permissions'),
              ),
            );
          },
        ),
      ),
    );
  }
}