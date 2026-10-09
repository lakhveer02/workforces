import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth_bloc.dart';
import '../../domain/auth_state.dart';
import '../../../../shared/widgets/common/app_button.dart';
import '../../../../shared/widgets/common/app_text_field.dart';
import '../../../../shared/widgets/common/app_card.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    required this.email,
    super.key,
  });

  final String? email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isResending = false;
  int _resendCountdown = 0;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.email != null) {
        context.read<AuthBloc>().add(
          AuthOtpVerificationRequested(
            email: widget.email!,
            otp: _otpController.text,
          ),
        );
      }
    }
  }

  void _handleResendOtp() {
    if (_resendCountdown > 0) return;

    setState(() {
      _isResending = true;
      _resendCountdown = 60;
    });

    // Start countdown
    _startCountdown();

    // Simulate resend (in real app, this would call the API)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP code has been resent to your email'),
          ),
        );
      }
    });
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.email == null) {
      // Redirect to login if no email provided
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRouter.login);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final responsive = Responsive.getValue(
      context,
      mobile: _buildMobileLayout(theme),
      tablet: _buildTabletLayout(theme),
      desktop: _buildDesktopLayout(theme),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.go(AppRouter.dashboard);
        } else if (state.hasError) {
          _showErrorSnackBar(context, state.error!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify OTP'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRouter.login),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state.isLoading,
              message: 'Verifying OTP...',
              child: responsive,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(theme),
                      const SizedBox(height: AppTheme.spaceXLarge),
                      _buildOtpForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceXLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(theme),
                const SizedBox(height: AppTheme.spaceXLarge),
                _buildOtpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceXXLarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(theme),
              const SizedBox(height: AppTheme.spaceXLarge),
              _buildOtpForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          ),
          child: Icon(
            Icons.security,
            size: 40,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spaceLarge),
        Text(
          'Enter Verification Code',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spaceSmall),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: 'We sent a verification code to\n'),
              TextSpan(
                text: widget.email,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppOtpField(
              controller: _otpController,
              onSubmitted: (_) => _handleVerifyOtp(),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Resend OTP
            Center(
              child: TextButton(
                onPressed: _resendCountdown > 0 || _isResending 
                    ? null 
                    : _handleResendOtp,
                child: _isResending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _resendCountdown > 0
                            ? 'Resend code in ${_resendCountdown}s'
                            : 'Resend verification code',
                      ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceLarge),
            
            AppButton(
              onPressed: _handleVerifyOtp,
              isFullWidth: true,
              child: const Text('Verify & Continue'),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            AppButton.outline(
              onPressed: () => context.go(AppRouter.login),
              isFullWidth: true,
              child: const Text('Back to Login'),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            _buildHelpInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpInfo() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppTheme.spaceSmall),
              Text(
                'Demo Information',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSmall),
          Text(
            'For demo purposes, you can use any 6-digit code (e.g., 123456)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            context.read<AuthBloc>().add(AuthErrorCleared());
          },
        ),
      ),
    );
  }
}

// Extension to maintain consistency with login screen
extension FormValidation on GlobalKey<FormState> {
  bool currentValidate() {
    return currentState?.validate() ?? false;
  }
}