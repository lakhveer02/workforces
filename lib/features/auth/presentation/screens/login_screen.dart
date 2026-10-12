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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    _showForgotPasswordDialog();
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Forgot Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailController,
              labelText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              validator: _validateEmail,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<AuthBloc>().add(
                  AuthForgotPasswordRequested(emailController.text.trim()),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link sent to your email'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state.isLoading;
        });

        if (state.isAuthenticated) {
          context.go(AppRouter.dashboard);
        } else if (state.requiresOtp) {
          context.go(AppRouter.otp, extra: state.email);
        } else if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Login failed'),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppTheme.getResponsivePadding(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 
                             isTablet ? 500 : 
                             450,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and branding
                      _buildHeader(context),
                      
                      const SizedBox(height: 48),
                      
                      // Login form
                      _buildLoginForm(context),
                      
                      const SizedBox(height: 24),
                      
                      // Demo credentials info
                      if (!isMobile) _buildDemoInfo(context),
                      
                      const SizedBox(height: 32),
                      
                      // Footer
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return Column(
      children: [
        // Logo
        Container(
          width: isMobile ? 80 : 100,
          height: isMobile ? 80 : 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.business,
            size: isMobile ? 40 : 50,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Text(
          'WorkforceOS',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Enterprise Workforce Management',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form title
              Text(
                'Sign In to Your Account',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Email field
              AppTextField(
                controller: _emailController,
                labelText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: _validateEmail,
                textInputAction: TextInputAction.next,
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: 20),
              
              // Password field
              AppTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: _validatePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(),
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: 20),
              
              // Remember me and forgot password
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: _isLoading ? null : (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Flexible(
                    child: Text('Remember me'),
                  ),
                  const Spacer(),
                  Flexible(
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleForgotPassword,
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Login button
              AppButton(
                onPressed: _isLoading ? null : _handleLogin,
                isLoading: _isLoading,
                isFullWidth: true,
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoInfo(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Demo Accounts',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Use these credentials to test different roles:'),
            const SizedBox(height: 8),
            _buildDemoCredential('Admin', 'admin@workforceos.com'),
            _buildDemoCredential('HR Manager', 'hr@workforceos.com'),
            _buildDemoCredential('Manager', 'manager@workforceos.com'),
            _buildDemoCredential('Employee', 'employee@workforceos.com'),
            const SizedBox(height: 8),
            Text(
              'Password for all accounts: password123',
              style: theme.textTheme.labelSmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCredential(String role, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$role:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _emailController.text = email;
                _passwordController.text = 'password123';
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Text(
                  email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '© 2024 WorkforceOS. All rights reserved.',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Navigate to privacy policy
              },
              child: const Text('Privacy Policy'),
            ),
            Text(
              ' • ',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to terms of service
              },
              child: const Text('Terms of Service'),
            ),
          ],
        ),
      ],
    );
  }
}