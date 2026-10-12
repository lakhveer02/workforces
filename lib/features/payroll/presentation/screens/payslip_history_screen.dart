import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../data/payroll_repository.dart';
import '../../domain/payroll_models.dart';
import '../widgets/payslip_card.dart';
import '../widgets/payslip_detail_dialog.dart';

class PayslipHistoryScreen extends StatefulWidget {
  const PayslipHistoryScreen({super.key});

  @override
  State<PayslipHistoryScreen> createState() => _PayslipHistoryScreenState();
}

class _PayslipHistoryScreenState extends State<PayslipHistoryScreen> {
  final _repository = MockPayrollRepository();
  List<Payslip> _payslips = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPayslips();
  }

  Future<void> _loadPayslips() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final payslips = await _repository.getPayslips('emp_001');
      
      if (mounted) {
        setState(() {
          _payslips = payslips;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showPayslipDetail(Payslip payslip) async {
    await showDialog(
      context: context,
      builder: (context) => PayslipDetailDialog(payslip: payslip),
    );
  }

  Future<void> _downloadPayslip(Payslip payslip) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryStart),
          ),
        ),
      );

      await _repository.downloadPayslip(payslip.id);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payslip downloaded successfully'),
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
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: Feature not implemented in demo'),
            backgroundColor: AppTheme.altin,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidyen,
      appBar: AppBar(
        title: Text(
          'Payslip History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.obsidyen,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.buz),
        actions: [
          IconButton(
            onPressed: _loadPayslips,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryStart),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load payslips',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.soluk,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPayslips,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_payslips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'No payslips found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your payslips will appear here once generated',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.soluk,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return RefreshIndicator(
      onRefresh: _loadPayslips,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppTheme.spaceMedium),
        itemCount: _payslips.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: AppTheme.spaceMedium,
        ),
        itemBuilder: (context, index) {
          final payslip = _payslips[index];
          return PayslipCard(
            payslip: payslip,
            onTap: () => _showPayslipDetail(payslip),
            onDownload: () => _downloadPayslip(payslip),
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout() {
    return RefreshIndicator(
      onRefresh: _loadPayslips,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: GridView.builder(
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: AppTheme.spaceLarge,
          mainAxisSpacing: AppTheme.spaceLarge,
        ),
        itemCount: _payslips.length,
        itemBuilder: (context, index) {
          final payslip = _payslips[index];
          return PayslipCard(
            payslip: payslip,
            onTap: () => _showPayslipDetail(payslip),
            onDownload: () => _downloadPayslip(payslip),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return RefreshIndicator(
      onRefresh: _loadPayslips,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceXLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary section
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLarge),
              decoration: BoxDecoration(
                color: AppTheme.yuzey,
                borderRadius: BorderRadius.circular(AppTheme.radius12),
                border: Border.all(color: AppTheme.structuralLine),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.panel,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: AppTheme.primaryStart,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payslip History',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.buz,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_payslips.length} payslips available for download',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.soluk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceXLarge),
            
            // Payslips grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                crossAxisSpacing: AppTheme.spaceLarge,
                mainAxisSpacing: AppTheme.spaceLarge,
              ),
              itemCount: _payslips.length,
              itemBuilder: (context, index) {
                final payslip = _payslips[index];
                return PayslipCard(
                  payslip: payslip,
                  onTap: () => _showPayslipDetail(payslip),
                  onDownload: () => _downloadPayslip(payslip),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}