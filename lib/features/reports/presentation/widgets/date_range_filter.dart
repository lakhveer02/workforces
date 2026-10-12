import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/report_models.dart';

class DateRangeFilterWidget extends StatelessWidget {
  final DateRangeFilter selectedRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateRangeFilter, DateTime?, DateTime?) onChanged;

  const DateRangeFilterWidget({
    super.key,
    required this.selectedRange,
    this.startDate,
    this.endDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: const BoxDecoration(
        color: AppTheme.yuzey,
        border: Border(
          bottom: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.date_range,
            color: AppTheme.soluk,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Period',
            style: TextStyle(
              color: AppTheme.buz,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          
          // Quick filters
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Today', DateRangeFilter.today),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Week', DateRangeFilter.thisWeek),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Month', DateRangeFilter.thisMonth),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Quarter', DateRangeFilter.thisQuarter),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Year', DateRangeFilter.thisYear),
                  const SizedBox(width: 8),
                  _buildCustomRangeButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, DateRangeFilter range) {
    final isSelected = selectedRange == range;
    
    return InkWell(
      onTap: () => _selectRange(range),
      borderRadius: BorderRadius.circular(AppTheme.radius24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryStart : AppTheme.panel,
          borderRadius: BorderRadius.circular(AppTheme.radius24),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryStart 
                : AppTheme.structuralLine,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.buz : AppTheme.soluk,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRangeButton() {
    final isCustom = selectedRange == DateRangeFilter.custom;
    
    return InkWell(
      onTap: _selectCustomRange,
      borderRadius: BorderRadius.circular(AppTheme.radius24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isCustom ? AppTheme.primaryStart : AppTheme.panel,
          borderRadius: BorderRadius.circular(AppTheme.radius24),
          border: Border.all(
            color: isCustom 
                ? AppTheme.primaryStart 
                : AppTheme.structuralLine,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month,
              size: 14,
              color: isCustom ? AppTheme.buz : AppTheme.soluk,
            ),
            const SizedBox(width: 4),
            Text(
              isCustom && startDate != null && endDate != null
                  ? '${_formatDate(startDate!)} - ${_formatDate(endDate!)}'
                  : 'Custom',
              style: TextStyle(
                color: isCustom ? AppTheme.buz : AppTheme.soluk,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectRange(DateRangeFilter range) {
    final dates = _getDateRangeForFilter(range);
    onChanged(range, dates.start, dates.end);
  }

  void _selectCustomRange() async {
    // In a real app, this would show a date picker dialog
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Mock custom date selection
    onChanged(DateRangeFilter.custom, thirtyDaysAgo, now);
  }

  DateTimeRange _getDateRangeForFilter(DateRangeFilter filter) {
    final now = DateTime.now();
    
    switch (filter) {
      case DateRangeFilter.today:
        final today = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: today, end: today);
        
      case DateRangeFilter.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          end: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
        );
        
      case DateRangeFilter.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return DateTimeRange(start: startOfMonth, end: endOfMonth);
        
      case DateRangeFilter.thisQuarter:
        final quarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        final quarterEnd = DateTime(quarterStart.year, quarterStart.month + 3, 0);
        return DateTimeRange(start: quarterStart, end: quarterEnd);
        
      case DateRangeFilter.thisYear:
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year, 12, 31);
        return DateTimeRange(start: startOfYear, end: endOfYear);
        
      case DateRangeFilter.lastWeek:
        final lastWeekStart = now.subtract(Duration(days: now.weekday + 6));
        final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(lastWeekStart.year, lastWeekStart.month, lastWeekStart.day),
          end: DateTime(lastWeekEnd.year, lastWeekEnd.month, lastWeekEnd.day),
        );
        
      case DateRangeFilter.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        final lastMonthEnd = DateTime(now.year, now.month, 0);
        return DateTimeRange(start: lastMonth, end: lastMonthEnd);
        
      case DateRangeFilter.lastQuarter:
        final currentQuarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        final lastQuarterStart = DateTime(
          currentQuarterStart.year,
          currentQuarterStart.month - 3,
          1,
        );
        final lastQuarterEnd = DateTime(currentQuarterStart.year, currentQuarterStart.month, 0);
        return DateTimeRange(start: lastQuarterStart, end: lastQuarterEnd);
        
      case DateRangeFilter.lastYear:
        final lastYear = DateTime(now.year - 1, 1, 1);
        final lastYearEnd = DateTime(now.year - 1, 12, 31);
        return DateTimeRange(start: lastYear, end: lastYearEnd);
        
      case DateRangeFilter.custom:
        // Return current month as fallback
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return DateTimeRange(start: startOfMonth, end: endOfMonth);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}