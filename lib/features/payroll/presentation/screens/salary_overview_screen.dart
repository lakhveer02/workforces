import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../data/payroll_repository.dart';
import '../../domain/payroll_models.dart';
import '../widgets/salary_breakdown_card.dart';
import '../widgets/salary_summary_card.dart';

class SalaryOverviewScreen extends StatefulWidget {
  const SalaryOverviewScreen({super.key});

  @override
  State<SalaryOverviewScreen> createState() => _SalaryOverviewScreenState();
}

class _SalaryOverviewScreenState extends State<SalaryOverviewScreen> {
  final _repository = MockPayrollRepository();
  SalaryStructure? _salaryStructure;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSalaryStructure();
  }

  Future<void> _loadSalaryStructure() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final structure = await _repository.getSalaryStructure('emp_001');
      
      if (mounted) {
        setState(() {
          _salaryStructure = structure;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidyen,
      appBar: AppBar(
        title: Text(
          'My Salary',
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
            onPressed: _loadSalaryStructure,
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
              'Failed to load salary information',
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
              onPressed: _loadSalaryStructure,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_salaryStructure == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'No salary information available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalarySummaryCard(salaryStructure: _salaryStructure!),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildEarningsSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildDeductionsSection(),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildEffectiveDatesCard(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalarySummaryCard(salaryStructure: _salaryStructure!),
          const SizedBox(height: AppTheme.spaceLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildEarningsSection()),
              const SizedBox(width: AppTheme.spaceLarge),
              Expanded(child: _buildDeductionsSection()),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLarge),
          _buildEffectiveDatesCard(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceXLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SalarySummaryCard(salaryStructure: _salaryStructure!),
              ),
              const SizedBox(width: AppTheme.spaceLarge),
              Expanded(child: _buildEffectiveDatesCard()),
            ],
          ),
          const SizedBox(height: AppTheme.spaceXLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildEarningsSection()),
              const SizedBox(width: AppTheme.spaceLarge),
              Expanded(child: _buildDeductionsSection()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSection() {
    final earnings = <String, double>{
      'Basic Salary': _salaryStructure!.basicSalary,
      ..._salaryStructure!.allowances,
    };

    return SalaryBreakdownCard(
      title: 'Earnings',
      icon: Icons.trending_up,
      iconColor: AppTheme.basari,
      items: earnings,
      isEarning: true,
    );
  }

  Widget _buildDeductionsSection() {
    return SalaryBreakdownCard(
      title: 'Deductions',
      icon: Icons.trending_down,
      iconColor: Colors.red,
      items: _salaryStructure!.deductions,
      isEarning: false,
    );
  }

  Widget _buildEffectiveDatesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.panel,
                  borderRadius: BorderRadius.circular(AppTheme.radius8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppTheme.altin,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Effective Period',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildDateRow(
            'Effective From',
            _salaryStructure!.effectiveFrom,
          ),
          if (_salaryStructure!.effectiveTo != null) ...[
            const SizedBox(height: 8),
            _buildDateRow(
              'Effective To',
              _salaryStructure!.effectiveTo!,
            ),
          ],
          const SizedBox(height: AppTheme.spaceMedium),
          _buildInfoRow(
            'Pay Frequency',
            _salaryStructure!.payFrequency,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Currency',
            _salaryStructure!.currency,
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.soluk,
          ),
        ),
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
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
    );
  }
}