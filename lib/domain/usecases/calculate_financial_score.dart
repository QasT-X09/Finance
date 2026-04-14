class FinancialScoreParams {
  final double savingsRate; // 0..1
  final double stabilityIndex; // 0..1
  final double impulsiveSpendingIndex; // 0..1, higher worse

  FinancialScoreParams({required this.savingsRate, required this.stabilityIndex, required this.impulsiveSpendingIndex});
}

class FinancialScoreResult {
  final int value; // 0..100
  FinancialScoreResult(this.value);
}

class CalculateFinancialScore {
  CalculateFinancialScore();

  FinancialScoreResult execute(FinancialScoreParams p) {
    // simple weighted formula
    final savingsScore = (p.savingsRate.clamp(0.0, 1.0) * 50);
    final stabilityScore = (p.stabilityIndex.clamp(0.0, 1.0) * 30);
    final impulsivePenalty = (p.impulsiveSpendingIndex.clamp(0.0, 1.0) * 30);

    final raw = savingsScore + stabilityScore - impulsivePenalty;
    final normalized = raw.clamp(0, 100).round();
    return FinancialScoreResult(normalized);
  }
}
