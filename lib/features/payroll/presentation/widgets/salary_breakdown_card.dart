import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SalaryBreakdownCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Map<String, double> items;
  final bool isEarning;

  const SalaryBreakdownCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.isEarning,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.values.fold(0.0, (sum, amount) => sum + amount);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            decoration: BoxDecoration(
              color: AppTheme.panel,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radius12),
                topRight: Radius.circular(AppTheme.radius12),
              ),
              border: const Border(
                bottom: BorderSide(color: AppTheme.structuralLine),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.buz,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${items.length} items',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.soluk,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.soluk,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${_formatCurrency(total)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isEarning ? AppTheme.basari : Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Items list
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            child: Column(
              children: items.entries.map((entry) {
                final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
                return _buildBreakdownItem(
                  context,
                  entry.key,
                  entry.value,
                  percentage,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context,
    String name,
    double amount,
    double percentage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_formatCurrency(amount)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.buz,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.soluk,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.panel,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: isEarning ? AppTheme.basari : Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}