import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth_bloc.dart';
import '../../domain/auth_state.dart';
import '../../../../shared/widgets/common/app_button.dart';
import '../../../../shared/widgets/common/app_text_field.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../../../../shared/widgets/brand/app_logo.dart';
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
  bool _rememberMe = true;
  bool _isLoading = false;

  static const _demoAccounts = [
    ('Admin', 'admin@workforceos.com'),
    ('HR', 'hr@workforceos.com'),
    ('Manager', 'manager@workforceos.com'),
    ('Employee', 'employee@workforceos.com'),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
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

  void _fillDemo(String email) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = 'password123';
    });
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your work email and we will send a reset link.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailController,
              labelText: 'Work email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
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
                  const SnackBar(content: Text('Reset link sent if the account exists')),
                );
              }
            },
            child: const Text('Send link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 960;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() => _isLoading = state.isLoading);

        if (state.isAuthenticated) {
          context.go(AppRouter.dashboard);
        } else if (state.requiresOtp) {
          context.go(AppRouter.otp, extra: state.email);
        } else if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Login failed'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: isWide ? _buildSplitLayout() : _buildCompactLayout(),
        ),
      ),
    );
  }

  Widget _buildSplitLayout() {
    return Row(
      children: [
        Expanded(flex: 5, child: _BrandPanel()),
        Expanded(
          flex: 4,
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _buildLoginForm(showDemo: true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: AppTheme.getResponsivePadding(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                const AppLogo(size: 64, showWordmark: true),
                const SizedBox(height: 36),
                _buildLoginForm(showDemo: !Responsive.isMobile(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm({required bool showDemo}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome back',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to manage people, time, and payroll.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.24 : 0.04),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _emailController,
                  labelText: 'Work email',
                  hintText: 'you@company.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded),
                  validator: _validateEmail,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  validator: _validatePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: _isLoading
                            ? null
                            : (value) => setState(() => _rememberMe = value ?? false),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Keep me signed in'),
                    const Spacer(),
                    TextButton(
                      onPressed: _isLoading ? null : _showForgotPasswordDialog,
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AppButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  icon: Icons.arrow_forward_rounded,
                  iconPosition: IconPosition.trailing,
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ),
        if (showDemo) ...[
          const SizedBox(height: 20),
          _buildDemoChips(),
        ],
        const SizedBox(height: 28),
        Text(
          '© ${DateTime.now().year} WorkforceOS',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoChips() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try a demo role',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _demoAccounts
              .map(
                (account) => ActionChip(
                  avatar: const Icon(Icons.person_outline, size: 16),
                  label: Text(account.$1),
                  onPressed: () => _fillDemo(account.$2),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'Password: password123',
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _BrandPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B),
            Color(0xFF312E81),
            Color(0xFF4F46E5),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -80,
            top: -60,
            child: _Glow(size: 280, opacity: 0.18),
          ),
          const Positioned(
            left: -40,
            bottom: 80,
            child: _Glow(size: 180, opacity: 0.12),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 48, 56, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(size: 48, showWordmark: true, light: true),
                const Spacer(),
                Text(
                  'The operating system\nfor your workforce.',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Attendance, leave, payroll, and performance — one calm workspace for HR and managers.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FeatureChip(icon: Icons.fingerprint_rounded, label: 'Smart attendance'),
                    _FeatureChip(icon: Icons.event_available_rounded, label: 'Leave workflows'),
                    _FeatureChip(icon: Icons.payments_outlined, label: 'Payroll clarity'),
                    _FeatureChip(icon: Icons.insights_rounded, label: 'Live analytics'),
                  ],
                ),
                const Spacer(),
                Text(
                  'Trusted by people teams who want less admin and more signal.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
