import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/payroll_models.dart';

class PayslipDetailDialog extends StatelessWidget {
  final Payslip payslip;

  const PayslipDetailDialog({
    super.key,
    required this.payslip,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: AppTheme.obsidyen,
            borderRadius: BorderRadius.circular(AppTheme.radius16),
            border: Border.all(color: AppTheme.structuralLine),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(context),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spaceLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPayslipInfo(context),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildEarningsSection(context),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildDeductionsSection(context),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildSummarySection(context),
                      if (payslip.notes?.isNotEmpty == true) ...[
                        const SizedBox(height: AppTheme.spaceLarge),
                        _buildNotesSection(context),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Footer actions
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: const BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radius16),
          topRight: Radius.circular(AppTheme.radius16),
        ),
        border: Border(
          bottom: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.panel,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: const Icon(
              Icons.description,
              color: AppTheme.primaryStart,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payslip Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatPeriod(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.soluk,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: AppTheme.soluk,
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employee Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.buz,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildInfoRow('Employee Name', payslip.employeeName),
          _buildInfoRow('Employee ID', payslip.employeeId),
          _buildInfoRow('Pay Period', '${_formatDate(payslip.payPeriodStart)} - ${_formatDate(payslip.payPeriodEnd)}'),
          _buildInfoRow('Pay Date', _formatDate(payslip.payDate)),
          _buildInfoRow('Working Days', '${payslip.workingDays}'),
          _buildInfoRow('Paid Days', '${payslip.paidDays}'),
          _buildInfoRow('Currency', payslip.currency),
        ],
      ),
    );
  }

  Widget _buildEarningsSection(BuildContext context) {
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
                const Icon(
                  Icons.trending_up,
                  color: AppTheme.basari,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Earnings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_formatCurrency(payslip.totalEarnings)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.basari,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            child: Column(
              children: payslip.earnings.map((item) {
                return _buildAmountRow(item.name, item.amount, AppTheme.basari);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionsSection(BuildContext context) {
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
                const Icon(
                  Icons.trending_down,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Deductions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_formatCurrency(payslip.totalDeductions)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            child: Column(
              children: payslip.deductions.map((item) {
                return _buildAmountRow(item.name, item.amount, Colors.red);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: AppTheme.buz,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Net Pay Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          _buildSummaryRow('Gross Pay', payslip.grossPay),
          const SizedBox(height: 8),
          _buildSummaryRow('Total Deductions', payslip.totalDeductions, isDeduction: true),
          const SizedBox(height: AppTheme.spaceMedium),
          Container(
            height: 1,
            color: AppTheme.buz.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Net Pay',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${_formatCurrency(payslip.netPay)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
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
                Icons.note_outlined,
                color: AppTheme.altin,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          Text(
            payslip.notes!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.soluk,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: const BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppTheme.radius16),
          bottomRight: Radius.circular(AppTheme.radius16),
        ),
        border: Border(
          top: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Download feature not implemented in demo'),
                    backgroundColor: AppTheme.altin,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radius8),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.soluk,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.buz,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, Color amountColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.buz,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '\$${_formatCurrency(amount)}',
            style: TextStyle(
              color: amountColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isDeduction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.buz.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${isDeduction ? '-' : ''}\$${_formatCurrency(amount)}',
          style: const TextStyle(
            color: AppTheme.buz,
            fontSize: 16,
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
    
    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}