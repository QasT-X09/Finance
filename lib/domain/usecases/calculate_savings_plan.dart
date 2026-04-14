class SavingsPlanParams {
  final double targetAmount;
  final double? monthlyContribution;
  final int? months;

  SavingsPlanParams({required this.targetAmount, this.monthlyContribution, this.months});
}

class SavingsPlanResult {
  final int monthsRequired;
  final double monthlyContribution;

  SavingsPlanResult({required this.monthsRequired, required this.monthlyContribution});
}

class CalculateSavingsPlan {
  CalculateSavingsPlan();

  SavingsPlanResult execute(SavingsPlanParams p) {
    if (p.monthlyContribution != null) {
      final months = (p.targetAmount / p.monthlyContribution!).ceil();
      return SavingsPlanResult(monthsRequired: months, monthlyContribution: p.monthlyContribution!);
    }

    if (p.months != null) {
      final monthly = p.targetAmount / p.months!;
      return SavingsPlanResult(monthsRequired: p.months!, monthlyContribution: monthly);
    }

    // default fallback: 12 months
    final monthly = p.targetAmount / 12.0;
    return SavingsPlanResult(monthsRequired: 12, monthlyContribution: monthly);
  }
}
