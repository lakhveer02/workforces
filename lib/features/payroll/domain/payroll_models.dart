enum PayslipStatus {
  draft,
  finalized,
  sent,
  acknowledged,
}

enum EarningType {
  basicSalary,
  overtime,
  bonus,
  allowance,
  commission,
  incentive,
}

enum DeductionType {
  tax,
  insurance,
  providentFund,
  loan,
  advance,
  fine,
}

class SalaryStructure {
  final String id;
  final String employeeId;
  final String employeeName;
  final double basicSalary;
  final Map<String, double> allowances;
  final Map<String, double> deductions;
  final double grossSalary;
  final double netSalary;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final String currency;
  final String payFrequency; // Monthly, Weekly, etc.

  const SalaryStructure({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.grossSalary,
    required this.netSalary,
    required this.effectiveFrom,
    this.effectiveTo,
    this.currency = 'USD',
    this.payFrequency = 'Monthly',
  });

  double get totalAllowances => allowances.values.fold(0.0, (sum, amount) => sum + amount);
  double get totalDeductions => deductions.values.fold(0.0, (sum, amount) => sum + amount);
}

class PayslipItem {
  final String name;
  final double amount;
  final bool isEarning;

  const PayslipItem({
    required this.name,
    required this.amount,
    required this.isEarning,
  });
}

class Payslip {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime payPeriodStart;
  final DateTime payPeriodEnd;
  final DateTime payDate;
  final PayslipStatus status;
  final double basicSalary;
  final List<PayslipItem> earnings;
  final List<PayslipItem> deductions;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final int workingDays;
  final int paidDays;
  final String currency;
  final String? notes;

  const Payslip({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.payPeriodStart,
    required this.payPeriodEnd,
    required this.payDate,
    required this.status,
    required this.basicSalary,
    required this.earnings,
    required this.deductions,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.workingDays,
    required this.paidDays,
    this.currency = 'USD',
    this.notes,
  });

  double get totalEarnings => earnings.fold(0.0, (sum, item) => sum + item.amount);
}

class PayrollSummary {
  final String period;
  final double totalGrossPay;
  final double totalDeductions;
  final double totalNetPay;
  final int totalEmployees;
  final DateTime lastProcessed;

  const PayrollSummary({
    required this.period,
    required this.totalGrossPay,
    required this.totalDeductions,
    required this.totalNetPay,
    required this.totalEmployees,
    required this.lastProcessed,
  });
}