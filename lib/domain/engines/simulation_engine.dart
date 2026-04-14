import 'dart:math';

class SimulationEngine {
  /// Simulate future value for monthly contributions using compound interest.
  /// Returns the projected future value after [months].
  ///
  /// Parameters:
  /// - principal: initial amount
  /// - monthlyContribution: amount added each month
  /// - annualRate: annual interest rate as decimal (e.g., 0.05 for 5%)
  /// - months: number of months to project
  double simulateSavings({
    required double principal,
    required double monthlyContribution,
    required double annualRate,
    required int months,
  }) {
    if (months <= 0) return principal;
  final monthlyRate = annualRate / 12.0;
    // Future value of principal
    final fvPrincipal = principal * pow(1 + monthlyRate, months);
    // Future value of a series of monthly contributions (ordinary annuity)
    double fvContrib;
    if (monthlyRate == 0) {
      fvContrib = monthlyContribution * months;
    } else {
      fvContrib = monthlyContribution * (pow(1 + monthlyRate, months) - 1) / monthlyRate;
    }
    return fvPrincipal + fvContrib;
  }
}
