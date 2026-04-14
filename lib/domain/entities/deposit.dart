class Deposit {
  final String id;
  final double principal;
  final double annualRatePercent;
  final DateTime startDate;
  final int months;

  Deposit({
    required this.id,
    required this.principal,
    required this.annualRatePercent,
    required this.startDate,
    required this.months,
  });
}
