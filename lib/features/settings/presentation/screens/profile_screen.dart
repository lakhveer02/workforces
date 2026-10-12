import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../auth/data/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authRepository = MockAuthRepository();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _positionController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Mock user data
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@workforce.com';
    _phoneController.text = '+1 (555) 123-4567';
    _departmentController.text = 'Engineering';
    _positionController.text = 'Senior Developer';
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    
    try {
      // Mock save operation
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppTheme.basari,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
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

  Future<void> _changePassword() async {
    await showDialog(
      context: context,
      builder: (context) => _ChangePasswordDialog(),
    );
  }

  Future<void> _updateProfilePicture() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProfilePictureBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidyen,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.obsidyen,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.buz),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _loadUserData(); // Reset to original values
                });
              },
              child: const Text('Cancel'),
            ),
          IconButton(
            onPressed: _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            tooltip: _isEditing ? 'Save' : 'Edit',
          ),
        ],
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
          _buildProfileHeader(),
          const SizedBox(height: AppTheme.spaceLarge),
          _buildPersonalInfoCard(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildWorkInfoCard(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildSecurityCard(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: AppTheme.spaceXLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildPersonalInfoCard(),
                    const SizedBox(height: AppTheme.spaceLarge),
                    _buildSecurityCard(),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spaceLarge),
              Expanded(
                child: _buildWorkInfoCard(),
              ),
            ],
          ),
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
              _buildProfileHeader(),
              const SizedBox(height: AppTheme.spaceXXLarge),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildPersonalInfoCard(),
                        const SizedBox(height: AppTheme.spaceLarge),
                        _buildWorkInfoCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceXLarge),
                  Expanded(
                    child: _buildSecurityCard(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        children: [
          // Profile picture
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.panel,
                child: Text(
                  'JD',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _updateProfilePicture,
                  borderRadius: BorderRadius.circular(AppTheme.radius24),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryStart,
                      borderRadius: BorderRadius.circular(AppTheme.radius24),
                      border: Border.all(color: AppTheme.yuzey, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppTheme.buz,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spaceMedium),
          
          // Name and email
          Text(
            _nameController.text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.buz,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.soluk,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          
          // Status badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.basari.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius24),
                  border: Border.all(color: AppTheme.basari.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.basari,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Active',
                      style: TextStyle(
                        color: AppTheme.basari,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryStart.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius24),
                  border: Border.all(color: AppTheme.primaryStart.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Employee',
                  style: TextStyle(
                    color: AppTheme.primaryStart,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLarge),
          
          _buildFormField('Full Name', _nameController, Icons.person),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildFormField('Email', _emailController, Icons.email, enabled: false),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildFormField('Phone', _phoneController, Icons.phone),
        ],
      ),
    );
  }

  Widget _buildWorkInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.work_outline,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Work Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLarge),
          
          _buildFormField('Department', _departmentController, Icons.business, enabled: false),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildFormField('Position', _positionController, Icons.badge, enabled: false),
          const SizedBox(height: AppTheme.spaceMedium),
          
          _buildInfoRow('Employee ID', 'EMP-001'),
          _buildInfoRow('Start Date', '15/01/2024'),
          _buildInfoRow('Manager', 'Sarah Connor'),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security,
                color: AppTheme.primaryStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Security',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLarge),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: AppTheme.altin,
                size: 20,
              ),
            ),
            title: Text(
              'Change Password',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Update your account password',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.soluk,
              size: 16,
            ),
            onTap: _changePassword,
          ),
          
          const Divider(color: AppTheme.structuralLine),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
              child: const Icon(
                Icons.fingerprint,
                color: AppTheme.basari,
                size: 20,
              ),
            ),
            title: Text(
              'Two-Factor Authentication',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Enabled',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.basari,
              ),
            ),
            trailing: Switch(
              value: true,
              onChanged: null, // Disabled for demo
              activeColor: AppTheme.basari,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
  }) {
    final canEdit = _isEditing && enabled;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.soluk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: canEdit,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.soluk, size: 20),
            fillColor: canEdit ? AppTheme.panel : AppTheme.panel.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              borderSide: BorderSide(
                color: canEdit ? AppTheme.structuralLine : AppTheme.structuralLine.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              borderSide: const BorderSide(color: AppTheme.structuralLine),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              borderSide: const BorderSide(color: AppTheme.primaryStart, width: 2),
            ),
          ),
          style: TextStyle(
            color: canEdit ? AppTheme.buz : AppTheme.soluk,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.soluk,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.buz,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        decoration: BoxDecoration(
          color: AppTheme.obsidyen,
          borderRadius: BorderRadius.circular(AppTheme.radius16),
          border: Border.all(color: AppTheme.structuralLine),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: AppTheme.primaryStart,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Change Password',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.soluk),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spaceLarge),
            
            _buildPasswordField(
              'Current Password',
              _currentPasswordController,
              _obscureCurrentPassword,
              () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            _buildPasswordField(
              'New Password',
              _newPasswordController,
              _obscureNewPassword,
              () => setState(() => _obscureNewPassword = !_obscureNewPassword),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            _buildPasswordField(
              'Confirm New Password',
              _confirmPasswordController,
              _obscureConfirmPassword,
              () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            
            const SizedBox(height: AppTheme.spaceXLarge),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    child: _isLoading 
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.buz),
                            ),
                          )
                        : const Text('Change Password'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback onToggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.soluk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.soluk, size: 20),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.soluk,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changePassword() async {
    setState(() => _isLoading = true);
    
    try {
      // Mock password change
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password changed successfully'),
            backgroundColor: AppTheme.basari,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
}

class _ProfilePictureBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.obsidyen,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.soluk,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLarge),
            child: Column(
              children: [
                Text(
                  'Update Profile Picture',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: AppTheme.spaceLarge),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildOption(
                        context,
                        'Camera',
                        Icons.camera_alt,
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Camera feature not implemented in demo'),
                              backgroundColor: AppTheme.altin,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMedium),
                    Expanded(
                      child: _buildOption(
                        context,
                        'Gallery',
                        Icons.photo_library,
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gallery feature not implemented in demo'),
                              backgroundColor: AppTheme.altin,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        decoration: BoxDecoration(
          color: AppTheme.yuzey,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(color: AppTheme.structuralLine),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryStart,
                size: 32,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMedium),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.buz,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}