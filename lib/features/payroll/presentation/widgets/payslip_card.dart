import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/payroll_models.dart';

class PayslipCard extends StatelessWidget {
  final Payslip payslip;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const PayslipCard({
    super.key,
    required this.payslip,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.yuzey,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(color: AppTheme.structuralLine),
        ),
        padding: const EdgeInsets.all(AppTheme.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatPeriod(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.buz,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pay Date: ${_formatDate(payslip.payDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.soluk,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Net pay highlight
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                border: Border.all(color: AppTheme.structuralLine),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Pay',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.soluk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${_formatCurrency(payslip.netPay)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.basari,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppTheme.basari,
                    size: 24,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Summary row
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Gross',
                    payslip.grossPay,
                    AppTheme.buz,
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppTheme.structuralLine,
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Deductions',
                    payslip.totalDeductions,
                    Colors.red,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spaceMedium),
            
            // Working days info
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.altin.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius24),
                border: Border.all(
                  color: AppTheme.altin.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                '${payslip.paidDays}/${payslip.workingDays} days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.altin,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('PDF'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (payslip.status) {
      case PayslipStatus.draft:
        backgroundColor = AppTheme.soluk.withValues(alpha: 0.1);
        textColor = AppTheme.soluk;
        label = 'Draft';
        break;
      case PayslipStatus.finalized:
        backgroundColor = AppTheme.altin.withValues(alpha: 0.1);
        textColor = AppTheme.altin;
        label = 'Finalized';
        break;
      case PayslipStatus.sent:
        backgroundColor = AppTheme.primaryStart.withValues(alpha: 0.1);
        textColor = AppTheme.primaryStart;
        label = 'Sent';
        break;
      case PayslipStatus.acknowledged:
        backgroundColor = AppTheme.basari.withValues(alpha: 0.1);
        textColor = AppTheme.basari;
        label = 'Acknowledged';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radius24),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.soluk,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '\$${_formatCurrency(amount)}',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatPeriod() {
    final start = payslip.payPeriodStart;
    final end = payslip.payPeriodEnd;
    
    if (start.month == end.month && start.year == end.year) {
      return '${_getMonthName(start.month)} ${start.year}';
    }
    
    return '${start.day}/${start.month} - ${end.day}/${end.month}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}