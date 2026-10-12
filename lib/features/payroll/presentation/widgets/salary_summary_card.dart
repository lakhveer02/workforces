import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/payroll_models.dart';

class SalarySummaryCard extends StatelessWidget {
  final SalaryStructure salaryStructure;

  const SalarySummaryCard({
    super.key,
    required this.salaryStructure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.buz,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Salary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.buz.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      salaryStructure.employeeName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.buz.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLarge),
          Row(
            children: [
              Expanded(
                child: _buildSalaryColumn(
                  context,
                  'Gross Salary',
                  salaryStructure.grossSalary,
                  Icons.trending_up,
                  AppTheme.basari,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMedium),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.buz.withValues(alpha: 0.3),
              ),
              const SizedBox(width: AppTheme.spaceMedium),
              Expanded(
                child: _buildSalaryColumn(
                  context,
                  'Net Salary',
                  salaryStructure.netSalary,
                  Icons.account_balance_wallet_outlined,
                  AppTheme.buz,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Deductions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.buz.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  '\$${_formatCurrency(salaryStructure.totalDeductions)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryColumn(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.buz.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$${_formatCurrency(amount)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}