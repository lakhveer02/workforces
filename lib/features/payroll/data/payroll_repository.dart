import '../domain/payroll_models.dart';

class MockPayrollRepository {
  static final MockPayrollRepository _instance = MockPayrollRepository._internal();
  factory MockPayrollRepository() => _instance;
  MockPayrollRepository._internal();

  // Mock data
  final List<SalaryStructure> _salaryStructures = [
    SalaryStructure(
      id: 'salary_001',
      employeeId: 'emp_001',
      employeeName: 'John Doe',
      basicSalary: 5000.0,
      allowances: {
        'House Rent': 2000.0,
        'Transport': 500.0,
        'Medical': 300.0,
        'Communication': 200.0,
      },
      deductions: {
        'Income Tax': 800.0,
        'Health Insurance': 150.0,
        'Provident Fund': 500.0,
      },
      grossSalary: 8000.0,
      netSalary: 6550.0,
      effectiveFrom: DateTime(2024, 1, 1),
    ),
    SalaryStructure(
      id: 'salary_002',
      employeeId: 'emp_002',
      employeeName: 'Jane Smith',
      basicSalary: 6000.0,
      allowances: {
        'House Rent': 2400.0,
        'Transport': 600.0,
        'Medical': 400.0,
        'Performance Bonus': 1000.0,
      },
      deductions: {
        'Income Tax': 1200.0,
        'Health Insurance': 200.0,
        'Provident Fund': 600.0,
      },
      grossSalary: 10400.0,
      netSalary: 8400.0,
      effectiveFrom: DateTime(2024, 1, 1),
    ),
  ];

  final List<Payslip> _payslips = [
    Payslip(
      id: 'payslip_001_202410',
      employeeId: 'emp_001',
      employeeName: 'John Doe',
      payPeriodStart: DateTime(2024, 10, 1),
      payPeriodEnd: DateTime(2024, 10, 31),
      payDate: DateTime(2024, 11, 1),
      status: PayslipStatus.sent,
      basicSalary: 5000.0,
      earnings: [
        PayslipItem(name: 'Basic Salary', amount: 5000.0, isEarning: true),
        PayslipItem(name: 'House Rent Allowance', amount: 2000.0, isEarning: true),
        PayslipItem(name: 'Transport Allowance', amount: 500.0, isEarning: true),
        PayslipItem(name: 'Medical Allowance', amount: 300.0, isEarning: true),
        PayslipItem(name: 'Communication Allowance', amount: 200.0, isEarning: true),
      ],
      deductions: [
        PayslipItem(name: 'Income Tax', amount: 800.0, isEarning: false),
        PayslipItem(name: 'Health Insurance', amount: 150.0, isEarning: false),
        PayslipItem(name: 'Provident Fund', amount: 500.0, isEarning: false),
      ],
      grossPay: 8000.0,
      totalDeductions: 1450.0,
      netPay: 6550.0,
      workingDays: 22,
      paidDays: 22,
      notes: 'Regular monthly salary',
    ),
    Payslip(
      id: 'payslip_001_202409',
      employeeId: 'emp_001',
      employeeName: 'John Doe',
      payPeriodStart: DateTime(2024, 9, 1),
      payPeriodEnd: DateTime(2024, 9, 30),
      payDate: DateTime(2024, 10, 1),
      status: PayslipStatus.acknowledged,
      basicSalary: 5000.0,
      earnings: [
        PayslipItem(name: 'Basic Salary', amount: 5000.0, isEarning: true),
        PayslipItem(name: 'House Rent Allowance', amount: 2000.0, isEarning: true),
        PayslipItem(name: 'Transport Allowance', amount: 500.0, isEarning: true),
        PayslipItem(name: 'Medical Allowance', amount: 300.0, isEarning: true),
        PayslipItem(name: 'Communication Allowance', amount: 200.0, isEarning: true),
        PayslipItem(name: 'Overtime', amount: 300.0, isEarning: true),
      ],
      deductions: [
        PayslipItem(name: 'Income Tax', amount: 830.0, isEarning: false),
        PayslipItem(name: 'Health Insurance', amount: 150.0, isEarning: false),
        PayslipItem(name: 'Provident Fund', amount: 500.0, isEarning: false),
      ],
      grossPay: 8300.0,
      totalDeductions: 1480.0,
      netPay: 6820.0,
      workingDays: 21,
      paidDays: 21,
      notes: 'Includes overtime pay',
    ),
    Payslip(
      id: 'payslip_001_202408',
      employeeId: 'emp_001',
      employeeName: 'John Doe',
      payPeriodStart: DateTime(2024, 8, 1),
      payPeriodEnd: DateTime(2024, 8, 31),
      payDate: DateTime(2024, 9, 1),
      status: PayslipStatus.acknowledged,
      basicSalary: 5000.0,
      earnings: [
        PayslipItem(name: 'Basic Salary', amount: 4545.45, isEarning: true),
        PayslipItem(name: 'House Rent Allowance', amount: 1818.18, isEarning: true),
        PayslipItem(name: 'Transport Allowance', amount: 454.55, isEarning: true),
        PayslipItem(name: 'Medical Allowance', amount: 272.73, isEarning: true),
        PayslipItem(name: 'Communication Allowance', amount: 181.82, isEarning: true),
      ],
      deductions: [
        PayslipItem(name: 'Income Tax', amount: 727.27, isEarning: false),
        PayslipItem(name: 'Health Insurance', amount: 136.36, isEarning: false),
        PayslipItem(name: 'Provident Fund', amount: 454.55, isEarning: false),
      ],
      grossPay: 7272.73,
      totalDeductions: 1318.18,
      netPay: 5954.55,
      workingDays: 22,
      paidDays: 20, // 2 days unpaid leave
      notes: 'Prorated for 2 days unpaid leave',
    ),
  ];

  Future<SalaryStructure?> getSalaryStructure(String employeeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _salaryStructures
        .where((structure) => structure.employeeId == employeeId)
        .firstOrNull;
  }

  Future<List<Payslip>> getPayslips(String employeeId, {int limit = 12}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _payslips
        .where((payslip) => payslip.employeeId == employeeId)
        .take(limit)
        .toList();
  }

  Future<Payslip?> getPayslip(String payslipId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _payslips
        .where((payslip) => payslip.id == payslipId)
        .firstOrNull;
  }

  Future<List<PayrollSummary>> getPayrollSummaries({int months = 6}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final summaries = <PayrollSummary>[];
    final now = DateTime.now();
    
    for (int i = 0; i < months; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthlyPayslips = _payslips.where((p) => 
        p.payPeriodStart.year == month.year && 
        p.payPeriodStart.month == month.month
      ).toList();
      
      if (monthlyPayslips.isNotEmpty) {
        final totalGross = monthlyPayslips.fold(0.0, (sum, p) => sum + p.grossPay);
        final totalDeductions = monthlyPayslips.fold(0.0, (sum, p) => sum + p.totalDeductions);
        final totalNet = monthlyPayslips.fold(0.0, (sum, p) => sum + p.netPay);
        
        summaries.add(PayrollSummary(
          period: '${month.year}-${month.month.toString().padLeft(2, '0')}',
          totalGrossPay: totalGross,
          totalDeductions: totalDeductions,
          totalNetPay: totalNet,
          totalEmployees: monthlyPayslips.length,
          lastProcessed: DateTime(month.year, month.month + 1, 1),
        ));
      }
    }
    
    return summaries;
  }

  Future<void> downloadPayslip(String payslipId) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // Mock download - in real app would generate and download PDF
    throw UnimplementedError('PDF generation not implemented in mock');
  }

  Future<void> acknowledgePayslip(String payslipId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _payslips.indexWhere((p) => p.id == payslipId);
    if (index != -1 && _payslips[index].status == PayslipStatus.sent) {
      // In real implementation, this would update the database
      // For mock, we'll just simulate the action
    }
  }
}