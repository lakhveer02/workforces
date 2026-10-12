import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../common/app_button.dart';

class AppErrorState extends StatelessWidget {
  final String? title;
  final String? message;
  final String? errorCode;
  final String? retryText;
  final VoidCallback? onRetry;
  final VoidCallback? onSupport;
  final EdgeInsets? padding;
  final bool showDetails;

  const AppErrorState({
    super.key,
    this.title,
    this.message,
    this.errorCode,
    this.retryText = 'Retry',
    this.onRetry,
    this.onSupport,
    this.padding,
    this.showDetails = false,
  });

  const AppErrorState.network({
    super.key,
    this.errorCode,
    this.retryText = 'Retry',
    this.onRetry,
    this.onSupport,
    this.padding,
    this.showDetails = false,
  })  : title = 'Connection Error',
        message = 'Please check your internet connection and try again.';

  const AppErrorState.server({
    super.key,
    this.errorCode,
    this.retryText = 'Retry',
    this.onRetry,
    this.onSupport,
    this.padding,
    this.showDetails = false,
  })  : title = 'Server Error',
        message = 'Something went wrong on our end. Please try again.';

  const AppErrorState.unauthorized({
    super.key,
    this.errorCode = '401',
    this.retryText = 'Sign In Again',
    this.onRetry,
    this.onSupport,
    this.padding,
    this.showDetails = false,
  })  : title = 'Session Expired',
        message = 'Your session has expired. Please sign in again to continue.';

  const AppErrorState.notFound({
    super.key,
    this.errorCode = '404',
    this.retryText = 'Go Back',
    this.onRetry,
    this.onSupport,
    this.padding,
    this.showDetails = false,
  })  : title = 'Page Not Found',
        message = 'The page you\'re looking for doesn\'t exist or has been moved.';

  const AppErrorState.accessDenied({
    super.key,
    this.errorCode = '403',
    this.retryText = 'Go Back',
    this.onRetry,
    this.onSupport,
    this.padding,
    this.showDetails = false,
  })  : title = 'Access Denied',
        message = 'You don\'t have permission to access this resource.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppTheme.spaceLarge * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Error Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.yuzey,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.structuralLine,
                width: 2,
              ),
            ),
            child: Icon(
              _getErrorIcon(),
              size: 56,
              color: _getErrorColor(),
            ),
          ),
          
          const SizedBox(height: AppTheme.spaceLarge * 1.5),
          
          // Error Title
          Text(
            title ?? 'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.buz,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spaceMedium),
          
          // Error Message
          Text(
            message ?? 'An unexpected error occurred. Please try again.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.soluk,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (showDetails && errorCode != null) ...[
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Error Code
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceMedium,
                vertical: AppTheme.spaceSmall,
              ),
              decoration: BoxDecoration(
                color: AppTheme.yuzey,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(color: AppTheme.structuralLine),
              ),
              child: Text(
                'Error Code: $errorCode',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.soluk,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppTheme.spaceLarge * 1.5),
          
          // Action Buttons
          Column(
            children: [
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    onPressed: onRetry!,
                    child: Text(retryText ?? 'Retry'),
                  ),
                ),
              
              if (onSupport != null) ...[
                const SizedBox(height: AppTheme.spaceMedium),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.outline(
                    onPressed: onSupport!,
                    child: const Text('Contact Support'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getErrorIcon() {
    switch (errorCode) {
      case '404':
        return Icons.search_off_outlined;
      case '401':
        return Icons.lock_outline;
      case '403':
        return Icons.block_outlined;
      case '500':
        return Icons.dns_outlined;
      default:
        return Icons.error_outline;
    }
  }

  Color _getErrorColor() {
    switch (errorCode) {
      case '404':
        return Colors.orange;
      case '401':
      case '403':
        return Colors.red;
      case '500':
        return Colors.purple;
      default:
        return AppTheme.soluk;
    }
  }
}