import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.style,
    super.key,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final TextStyle? style;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXSmall),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          style: widget.style ?? theme.textTheme.bodyMedium,
          decoration: _buildInputDecoration(theme),
        ),
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: AppTheme.spaceXSmall),
          Text(
            widget.helperText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme) {
    return InputDecoration(
      hintText: widget.hintText,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(theme),
      filled: true,
      fillColor: widget.enabled 
          ? theme.colorScheme.surface 
          : theme.disabledColor.withOpacity(0.12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.outline,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.outline,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        borderSide: BorderSide(
          color: theme.disabledColor,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMedium,
        vertical: AppTheme.spaceMedium,
      ),
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      errorStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

// Specialized text fields
class AppEmailField extends StatelessWidget {
  const AppEmailField({
    this.controller,
    this.labelText = 'Email',
    this.hintText = 'Enter your email',
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator ?? _defaultEmailValidator,
      errorText: errorText,
      autofocus: autofocus,
      enabled: enabled,
    );
  }

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
}

class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: const Icon(Icons.lock_outline),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator ?? _defaultPasswordValidator,
      errorText: errorText,
      autofocus: autofocus,
      enabled: enabled,
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    return null;
  }
}

class AppOtpField extends StatelessWidget {
  const AppOtpField({
    this.controller,
    this.labelText = 'OTP Code',
    this.hintText = 'Enter 6-digit code',
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.autofocus = true,
    this.enabled = true,
    super.key,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: const Icon(Icons.security_outlined),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator ?? _defaultOtpValidator,
      errorText: errorText,
      autofocus: autofocus,
      enabled: enabled,
    );
  }

  String? _defaultOtpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP code is required';
    }
    
    if (value.length != 6) {
      return 'OTP code must be 6 digits';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP code must contain only numbers';
    }
    
    return null;
  }
}