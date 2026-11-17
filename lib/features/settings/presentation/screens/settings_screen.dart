import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_bloc.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../shared/widgets/theme/theme_toggle_button.dart';
import '../../../../shared/widgets/modern/modern_card.dart';
import '../../../../shared/widgets/modern/modern_button.dart';
import '../../../auth/data/auth_repository.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authRepository = MockAuthRepository();
  
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _weeklyReports = false;
  bool _monthlyReports = true;

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => _LogoutConfirmationDialog(),
    );

    if (shouldLogout == true && mounted) {
      try {
        await _authRepository.logout();
        
        if (mounted) {
          // Navigate to login screen
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login', 
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.obsidyen,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.buz),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Column(
        children: [
          _buildProfileSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildAppearanceSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildNotificationsSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildReportsSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildAboutSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildDangerZone(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      child: Column(
        children: [
          _buildProfileSection(),
          const SizedBox(height: AppTheme.spaceLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildAppearanceSection(),
                    const SizedBox(height: AppTheme.spaceLarge),
                    _buildReportsSection(),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spaceLarge),
              Expanded(
                child: Column(
                  children: [
                    _buildNotificationsSection(),
                    const SizedBox(height: AppTheme.spaceLarge),
                    _buildAboutSection(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLarge),
          _buildDangerZone(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceXLarge),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildProfileSection(),
              const SizedBox(height: AppTheme.spaceXLarge),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildAppearanceSection(),
                        const SizedBox(height: AppTheme.spaceLarge),
                        _buildNotificationsSection(),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceXLarge),
                  Expanded(
                    child: Column(
                      children: [
                        _buildReportsSection(),
                        const SizedBox(height: AppTheme.spaceLarge),
                        _buildAboutSection(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceXLarge),
              _buildDangerZone(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.panel,
            child: Text(
              'JD',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Senior Developer',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.soluk,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@workforce.com',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.soluk,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        _buildSettingsTile(
          title: 'Theme',
          subtitle: 'Choose your preferred theme',
          leading: const Icon(Icons.brightness_6, color: AppTheme.accent),
          trailing: const ThemeToggleButton(showLabel: true),
        ),
        _buildSettingsTile(
          title: 'Language',
          subtitle: 'App language',
          leading: const Icon(Icons.language, color: AppTheme.accent),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'English',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 12, color: context.colors.textSecondary),
            ],
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Language selection coming soon!'),
                backgroundColor: context.colors.warning,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        _buildSwitchTile(
          title: 'Enable Notifications',
          subtitle: 'Receive app notifications',
          value: _notificationsEnabled,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
          icon: Icons.notifications,
        ),
        _buildSwitchTile(
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          value: _emailNotifications,
          onChanged: _notificationsEnabled 
              ? (value) => setState(() => _emailNotifications = value)
              : null,
          icon: Icons.email,
        ),
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive push notifications',
          value: _pushNotifications,
          onChanged: _notificationsEnabled
              ? (value) => setState(() => _pushNotifications = value)
              : null,
          icon: Icons.push_pin,
        ),
      ],
    );
  }

  Widget _buildReportsSection() {
    return _buildSection(
      title: 'Reports',
      icon: Icons.assessment_outlined,
      children: [
        _buildSwitchTile(
          title: 'Weekly Reports',
          subtitle: 'Receive weekly performance reports',
          value: _weeklyReports,
          onChanged: (value) => setState(() => _weeklyReports = value),
          icon: Icons.calendar_view_week,
        ),
        _buildSwitchTile(
          title: 'Monthly Reports',
          subtitle: 'Receive monthly analytics reports',
          value: _monthlyReports,
          onChanged: (value) => setState(() => _monthlyReports = value),
          icon: Icons.calendar_view_month,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        _buildSettingsTile(
          title: 'Version',
          subtitle: 'App version information',
          leading: const Icon(Icons.info, color: AppTheme.primaryStart),
          trailing: Text(
            'v1.0.0',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.soluk,
            ),
          ),
        ),
        _buildSettingsTile(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          leading: const Icon(Icons.privacy_tip, color: AppTheme.primaryStart),
          trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.soluk),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Privacy policy not implemented in demo'),
                backgroundColor: AppTheme.altin,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        _buildSettingsTile(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          leading: const Icon(Icons.description, color: AppTheme.primaryStart),
          trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.soluk),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Terms of service not implemented in demo'),
                backgroundColor: AppTheme.altin,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_outlined,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 20,
              ),
            ),
            title: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Sign out from your account',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.red,
              size: 16,
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            decoration: const BoxDecoration(
              color: AppTheme.panel,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radius12),
                topRight: Radius.circular(AppTheme.radius12),
              ),
              border: Border(
                bottom: BorderSide(color: AppTheme.structuralLine),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryStart,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(children: children),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required Widget leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMedium,
          vertical: 4,
        ),
        leading: leading,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.soluk,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMedium,
          vertical: 4,
        ),
        leading: Icon(
          icon,
          color: AppTheme.primaryStart,
          size: 20,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.soluk,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.basari,
          inactiveThumbColor: AppTheme.soluk,
          inactiveTrackColor: AppTheme.panel,
        ),
      ),
    );
  }
}

class _LogoutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        decoration: BoxDecoration(
          color: AppTheme.obsidyen,
          borderRadius: BorderRadius.circular(AppTheme.radius16),
          border: Border.all(color: AppTheme.structuralLine),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius12),
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 32,
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            Text(
              'Sign Out',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceSmall),
            
            Text(
              'Are you sure you want to sign out? You will need to sign in again to access your account.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.soluk,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spaceXLarge),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: AppTheme.buz,
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}